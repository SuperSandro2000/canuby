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
require 'optparse'
require 'ostruct'

require 'canuby/version'

# Parses command line arguments
module ArgParser
  def self.parse(args)
    # options = OpenStruct.new
    # options.config_version = Canuby::CONFIG_VERSION
    # options.base_dir = '3rdparty'
    # options.target = 'thirdparty'
    # options.yml_file = 'canuby.yml'
    default_options = { 'config_version' => Canuby::CONFIG_VERSION, 'base_dir' => '3rdparty', 'target' => 'thirdparty', 'yml_file' => 'canuby.yml' }
    options = OpenStruct.new(default_options)

    parser = OptionParser.new do |opts|
      opts.banner = "\n"
      opts.separator 'Usage: canuby [options]'
      opts.separator "\nBuild options:"

      opts.on('-c', '--config', 'Use a custom config file.') do
        Rake.application.tasks.each do |c|
          options.yml_file = c
        end
      end

      opts.on('-d', '--dir [directory]', 'Specify a working directory') do |dir|
        options.base_dir = dir
      end

      opts.on('-t', '--target [target]', 'Choose a target to build') do |t|
        options.target = if t.to_s.match?(/^thirdparty:/)
                           t
                         else
                           "thirdparty:#{t}"
                         end
      end

      opts.separator "\nOther @options:"

      opts.on('--check-config', 'Checks only if the config is valid.') do
        options.only_check_config = true
      end

      opts.on('--debug', 'Show debug information in console') do
        options.debug = true
      end

      opts.on('--ignore-config-file', 'Ignore the config file.') do
        options.ignore_config_file = true
      end

      opts.on('-l', '--list', 'List all available targets') do
        options.list = true
      end

      opts.on('--list-all', 'List all available tasks') do
        options.list_all = true
      end

      opts.on('-v', '--verbose', 'Be more verbose and show debug information in console') do
        options.debug = true
      end

      opts.separator "\n"
      opts.on_tail('-h', '--help', 'Show this help message') do
        puts opts
        exit
      end

      opts.on_tail('--version', 'Show version') do
        puts Canuby::VERSION
        exit
      end
    end
    begin
      parser.parse!(args)
    rescue OptionParser::InvalidOption => e
      if File.basename(__FILE__) == 'Rakefile' || File.basename($PROGRAM_NAME) == 'rake_test_loader.rb' || e.to_s.split(': ')[1] == '--profile'
        puts 'hi'
        # return
      else
        puts('Canuby does not understand that argument. We just assume it belongs to ruby.')
        puts(e)
      end
    end
    options
  end

  # Parse minimal arguments. Usefull if you just need the all build tasks.
  def self.min(_args)
    options = OpenStruct.new
    options.config_version = Canuby::CONFIG_VERSION
    options.target = 'thirdparty'
    options.yml_file = 'canuby.yml'

    OptionParser.new do |opts|
      opts.on('-c', '--config', 'Use a custom config file.') do
        Rake.application.tasks.each do |c|
          options.yml_file = c
        end
      end
    end
    options
  end
end
