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
begin
  require 'Win32/Console/ANSI' if RUBY_PLATFORM =~ /mingw32/
rescue LoadError
  raise 'You must gem install win32console to use color on Windows'
end

require_relative 'canuby/argparser'
require_relative 'canuby/util'

module Canuby
  def self.main
    $options = ArgParser.parse(ARGV)
    logger.info("===== #{'Welcome to Canuby!'.green} =====".blue)

    # Rake.add_rakelib 'canuby/tasks'
    require_relative 'canuby/tasks'

    Rake.application[$options.target.to_s].invoke
    File.write('canuby.yml', $projects.to_yaml)

    logger.info("===========  #{'Done'.green}  ===========".blue)
  end
end
