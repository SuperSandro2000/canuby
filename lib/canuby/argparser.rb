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

require_relative 'version'

# Parses command line arguments
module ArgParser
  def self.parse(args)
    options = OpenStruct.new
    options.target = 'thirdparty'
    options.yml_file = 'canuby.yml'

    parser = OptionParser.new do |parser|
      if ARGV.delete '--profile'
      end

      parser.banner = "\n#{'Canuby'.cyan} build tool"
      parser.separator 'Usage: canuby [options]'
      parser.separator "\n\nBuild options:"

      parser.on('-t', '--target [Target]', 'Choose a target to build') do |t|
        target = if t.to_s.match?(/^thirdparty:/)
                           t
                         else
                           "thirdparty:#{t}"
                         end
      end

      parser.separator "\nOther @options:"
      parser.on('-c', '--config', 'Use a custom config file.') do
        Rake.application.tasks.each do |c|
          yml_file = c
        end
      end

      parser.on('-l', '--list', 'List all available targets') do
        require_relative 'tasks'
        Rake.application.tasks.each do |t|
          # puts "#{t}".sub /:[a-z]{0,}$/, ''
          # puts "#{t}".match /^[A-z]{0,}:[A-z1-9]{0,}/
          puts t.to_s.yellow + ' ' * (45 - t.to_s.length) + t.comment.to_s unless t.comment.nil?
        end
        exit
      end

      parser.on('--list-all', 'List all available tasks') do
        Rake.application.tasks.each do |t|
          puts t
        end
        exit
      end

      parser.separator "\n"
      parser.on_tail('-h', '--help', 'Show this help message') do
        puts parser
        exit
      end

      parser.on_tail('-v', '--version', 'Show version') do
        puts Canuby::Version
        exit
      end
    end
    parser.parse!(args)
    options
  end
end
