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
require 'fileutils'
require 'yaml'

require_relative 'argparser'
require_relative 'util'

# skip if run trough rake or bundler
if File.basename($PROGRAM_NAME) != 'rake' && ENV['Testing'] != 'true' && File.exist?($options.yml_file)
  $options = ArgParser.parse(ARGV) unless defined? $options
  $projects = YAML.load_file($options.yml_file)
else
  $projects = {
    'Googletest' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', 'project_file' => 'googletest-distribution',
                      'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest.lib', 'gtest_main.lib'] }, \
    'Dummy' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', 'project_file' => 'googletest-distribution',
                 'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest.lib'] }, \
    'Dummy2' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', 'project_file' => 'googletest-distribution',
                  'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest_main.lib'] }
  }
end

$projects.each_key do |project|
  const_set(project, Project.new)
  const_get(project).url = $projects[project]['url']
  const_get(project).version = $projects[project]['version']
  const_get(project).path = File.join(Paths.base_dir, project).downcase
  const_get(project).project_file = $projects[project]['project_file']
  const_get(project).output_dir = File.join(const_get(project).path, 'build', $projects[project]['output_dir'])
  const_get(project).outputs = $projects[project]['outputs']
end

default_build = []
$projects.each_key do |project|
  default_build.push("thirdparty:#{project}")
end

task thirdparty: default_build
add_desc('thirdparty', 'Get, build and stage all thirdparty dependencies')

# generate tasks dynamically
$projects.each_key do |project|
  namespace :thirdparty do
    task "#{project}": "#{project}:staged"
    add_desc(project, "Prepare #{project}")

    namespace project do
      task cloned: :init do
        Git.clone(project) unless File.exist?(Object.const_get(project).path)
      end

      task build: :cloned do
        Build.msbuild(project, const_get(project).project_file) unless Outputs.stage(project).all? { |f| File.exist?(f) }
      end

      task staged: :build do
        Stage.collect(project) unless Outputs.stage(project).all? { |f| File.exist?(f) }
      end

      task :pull do
        Git.pull(project)
      end
      add_desc("#{project}:pull", "Pull upstream #{project} changes")

      task build_stage: :cloned do
        Build.msbuild(project, const_get(project).project_file)
        Stage.collect(project)
      end
      add_desc("#{project}:build_stage", "Build and stage #{project}")

      task update: [:pull, :build_stage]
      add_desc("#{project}:update", "Pull, build and stage #{project}")
    end

    task :init do
    end
  end
end
