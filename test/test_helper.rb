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
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

if ENV['CI'] == 'true'
  require 'simplecov'
  SimpleCov.start

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

require 'minitest/autorun'
require 'minitest/filesystem'
require 'minitest/profile'
require 'minitest/rg'

# require 'canuby/argparser'
# $options = ArgParser.parse(ARGV)
# puts 'options paths'
# puts $options
# puts ENV['Testing']

require 'canuby/paths'
require 'canuby/project'

Paths.base_dir = 'testing'
$project = 'Test'
Object.const_set($project, Project.new)
Object.const_get($project).url = 'https://github.com/SuperSandro2000/canuby-cmake-test'
Object.const_get($project).version = '1.7.10'
Object.const_get($project).path = File.join(Paths.base_dir, $project)
Object.const_get($project).output_dir = ''
Object.const_get($project).outputs = ['math.lib']

def timestamp_regex(color = 'white')
  case color
  when 'white'
    '[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}'
  when 'magenta'
    '\e\[0;35;49m\[[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}\]\e\[0m'
  when 'red'
    '\e\[0;31;49m\[[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}\]\e\[0m'
  end
end
