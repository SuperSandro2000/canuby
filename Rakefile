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
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yard'

ENV['Testing'] ||= 'true'

require_relative 'lib/canuby/tasks'

Rake::TestTask.new do |t|
  t.options = '--profile'
  t.libs << 'test'
end

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.options = ['-odocs', '--title=Canuby', '--files=LICENSE']
  # t.stats_options = ['--list-undoc']
end

task default: :test
