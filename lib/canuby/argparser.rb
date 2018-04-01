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
require 'ostruct'
require 'optparse'

require 'canuby/version'

# Parses command line arguments
module ArgParser
  def self.parse(args)
    options = OpenStruct.new
    options.config_version = Canuby::CONFIG_VERSION
    options.target = 'thirdparty'
    options.yml_file = 'canuby.yml'

    parser = OptionParser.new do |opts|
      opts.banner = "\n"
      opts.separator 'Usage: canuby [options]'
      opts.separator "\nBuild options:"

      opts.on('-t', '--target [Target]', 'Choose a target to build') do |t|
        options.target = if t.to_s.match?(/^thirdparty:/)
                           t
                         else
                           "thirdparty:#{t}"
                         end
      end

      opts.separator "\nOther @options:"
      opts.on('-c', '--config', 'Use a custom config file.') do
        Rake.application.tasks.each do |c|
          options.yml_file = c
        end
      end

      opts.on('-d', '--debug', 'Show debug log in console.') do
        ENV['DEBUG'] = 'true'
      end

      opts.on('-l', '--list', 'List all available targets') do
        require 'canuby/tasks'
        Rake.application.tasks.each do |t|
          # puts "#{t}".sub /:[a-z]{0,}$/, ''
          # puts "#{t}".match /^[A-z]{0,}:[A-z1-9]{0,}/
          puts t.to_s.yellow + ' ' * (45 - t.to_s.length) + t.comment.to_s unless t.comment.nil?
        end
        exit
      end

      opts.on('--list-all', 'List all available tasks') do
        Rake.application.tasks.each do |t|
          puts t
        end
        exit
      end

      opts.separator "\n"
      opts.on_tail('-h', '--help', 'Show this help message') do
        puts opts
        exit
      end

      opts.on_tail('-v', '--version', 'Show version') do
        puts Canuby::VERSION
        exit
      end
    end
    begin
      parser.parse!(args)
    rescue OptionParser::InvalidOption => e
      logger.error('Canuby does not understand that argument. We just assume it belongs to ruby.')
      logger.error(e)
      if File.basename($PROGRAM_NAME) == 'ruby'
        exit 1
      end
    end
    options
  end

  def self.min(args)
    options = OpenStruct.new
    options.config_version = Canuby::CONFIG_VERSION
    options.target = 'thirdparty'
    options.yml_file = 'canuby.yml'

    parser = OptionParser.new do |opts|
      opts.on('-c', '--config', 'Use a custom config file.') do
        Rake.application.tasks.each do |c|
          options.yml_file = c
        end
      end
    end
    options
  end
end
