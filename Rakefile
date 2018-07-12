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
require 'fileutils'
require 'rake/testtask'
require 'yard'

ENV['Testing'] = 'true'

Rake::TestTask.new do |t|
  # breaks all tests. until we know why we inject minitest-profile in test_helper.rb
  # t.options = '--profile'
  t.libs << 'lib'
  t.libs << 'test'
end

YARD::Rake::YardocTask.new do |t|
  FileUtils.makedirs('docs')
  FileUtils.touch('docs/.nojekyll')
  t.files = ['lib/**/*.rb']
  t.options = ['-odocs', '--title=Canuby', '--files=LICENSE']
  # t.stats_options = ['--list-undoc']
end

task default: :test
