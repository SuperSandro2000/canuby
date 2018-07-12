# frozen_string_literal: true

# Copyright (C) 2018 Sandro Jäckel.  All rights reserved.
#
# This file is part of Canuby.
#
# Canuby is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Canuby is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Canuby.  If not, see <http://www.gnu.org/licenses/>.
require 'colorize'
require 'rake'

# Supported colors on cmd Windows are: black, red, green, yellow, blue, magenta, cyan, white
# and these modes: bold, underline(light gray background), swap (swap background and letter color) and hide
# Background colors are editable with on_color. eg: .blue.on_red
if RUBY_PLATFORM.match?(/mingw32/)
  require 'socket'
  require 'win32ole'
  if WIN32OLE.connect("winmgmts://#{Socket.gethostname}/root/cimv2").InstancesOf('Win32_OperatingSystem').each { |os| (os.version !~ /^10.0./).nil? }
    begin
      require 'Win32/Console/ANSI'
    rescue LoadError
      puts 'You must gem install win32console to use color on Windows'
    end
  end
end

require 'canuby/argparser'
require 'canuby/config'
require 'canuby/util'

# Main entry point
module Canuby
  def self.main
    $options = ArgParser.parse(ARGV)
    logger.info('===== Welcome to Canuby! =====')
    logger.debug('Running in debug mode.')
    logger.debug($options)

    if $options.only_check_config
      Config.load
      Config.check

    elsif $options.list
      require 'canuby/tasks'
      Rake.application.tasks.each do |t|
        # puts "#{t}".sub /:[a-z]{0,}$/, ''
        # puts "#{t}".match /^[A-z]{0,}:[A-z1-9]{0,}/
        puts t.to_s.yellow + ' ' * (45 - t.to_s.length) + t.comment.to_s unless t.comment.nil?
      end

    elsif $options.list_all
      require 'canuby/tasks'
      Rake.application.tasks.each do |t|
        puts t
      end

    else
      require 'canuby/tasks'
      Rake.application[$options.target.to_s].invoke
      Config.write
    end

    logger.info('===========  Done  ===========')
  end
end
