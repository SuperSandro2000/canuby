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
require_relative 'util'

# supported colors on cmd Windows: bold, negative, black, red, green, yellow, blue, magenta, cyan, white
puts '===== Welcome to Canuby! ====='.red

## Projects config
Projects = {
  'googletest' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', 'outputs' => ['gtest.lib', 'gtest_main.lib'] }, \
  'dummy' => { 'url' => 'https://github.com/google/googletest', 'version': '1.0.0', 'outputs' => ['gtest.lib'] }, \
  'dummy2' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', 'outputs' => ['gtest_main.lib'] }
}

## build tools config
ENV['vcvars'] ||= '"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"'
ENV['rel_type'] ||= 'RelWithDebInfo'

# Rake default task
task default: :thirdparty

# which tasks are executed if you specify none
desc 'Prepare 3rdparty dependencies'
task thirdparty: ['thirdparty:googletest', 'thirdparty:dummy']

# generate tasks dynamically
Projects.each_key do |project|
  namespace :thirdparty do
    Projects[project]['path'] = File.join(base_dir, project)

    desc "Prepare #{project}"
    task "#{project}": "#{project}:staged"

    namespace project do
      task cloned: :init do
        git_clone(Projects[project]['url'], project) unless File.exist?(Projects[project]['path'])
      end

      task built: :cloned do
        msbuild(project) unless build_outputs(project).all? { |f| File.exist?(f) }
      end

      task staged: :built do
        collect_stage(project) unless stage_outputs(project).all? { |f| File.exist?(f) }
      end

      desc "Pull upstream #{project} changes"
      task :pull do
        git_pull(project)
      end

      desc "Build and stage #{project}"
      task build_stage: :cloned do
        msbuild(project)
        collect_stage(project)
      end

      desc "Pull, build and stage #{project}"
      task update: %i[pull build_stage]
    end
  end
end
