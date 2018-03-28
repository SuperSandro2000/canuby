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
require 'English'
require 'rake'

require_relative 'util'

## build tools config
# TODO make changeable
ENV['vcvars'] ||= '"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat"'
ENV['rel_type'] ||= 'RelWithDebInfo'

# TODO: load from JSON or canuby.rb
Projects = {
  'Googletest' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', 'project_file' => 'googletest-distribution',
                    'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest.lib', 'gtest_main.lib'] }, \
  'Dummy' => { 'url' => 'https://github.com/google/googletest', 'version': '1.0.0', 'project_file' => 'googletest-distribution',
               'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest.lib'] }, \
  'Dummy2' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', 'project_file' => 'googletest-distribution',
                'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest_main.lib'] }
}

# TODO: remove
Projects.each_key do |project|
  const_set(project, Project.new)
  const_get(project).url = Projects[project]['url']
  const_get(project).version = Projects[project]['version']
  const_get(project).path = File.join(Paths.base_dir, project).downcase
  const_get(project).project_file = Projects[project]['project_file']
  const_get(project).output_dir = File.join(const_get(project).path, 'build', Projects[project]['output_dir'])
  const_get(project).outputs = Projects[project]['outputs']
end

# Main entry point for executable
# TODO add ability run from current dir and use .json or .rb files for projects
class Canuby
  def initialize; end

  def self.load
    # TODO: add load code from json or rb file
    Projects
  end

  def self.main(target)
    logger.info('===== Welcome to Canuby! ====='.red)
    logger.info('building' + target) if target
    logger.info(load)
    Rake.application['build:thirdparty'].invoke('one')
  end
end

# which tasks are executed if you specify none
desc 'Get, build and stage all thirdparty dependencies'
task thirdparty: ['thirdparty:Googletest', 'thirdparty:Dummy']

# generate tasks dynamically
Projects.each_key do |project|
  namespace :thirdparty do
    desc "Prepare #{project}"
    task "#{project}": "#{project}:staged"

    namespace project do
      task cloned: :init do
        Git.clone(project) unless File.exist?(Object.const_get(project).path)
      end

      task build: :cloned do
        Build.msbuild(project, const_get(project).project_file) unless const_get(project).outputs.all? { |f| File.exist?(f) }
      end

      task staged: :build do
        collect_stage(project) unless const_get(project).outputs.all? { |f| File.exist?(f) }
      end

      desc "Pull upstream #{project} changes"
      task :pull do
        git.pull(project)
      end

      desc "Build and stage #{project}"
      task build_stage: :cloned do
        Build.msbuild(project, const_get(project).project_file)
        Stage.collect(project)
      end

      desc "Pull, build and stage #{project}"
      task update: [:pull, :build_stage]
    end

    task :init do
    end
  end
end
