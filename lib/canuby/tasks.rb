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

require 'canuby/argparser'
require 'canuby/build'
require 'canuby/config'
require "canuby/git"
require 'canuby/outputs'
require 'canuby/paths'
require 'canuby/project'

Config.load
Config.check(true)

# Paths.base_dir = ENV[base_dir] unless ENV[base_dir].nil?

$options.projects.each_key do |project|
  const_set(project, Project.new)
  const_get(project).url = $options.projects[project]['url']
  const_get(project).version = $options.projects[project]['version']
  const_get(project).build_tool = $options.projects[project]['build_tool']
  const_get(project).path = File.join(Paths.base_dir, project).downcase
  const_get(project).project_file = $options.projects[project]['project_file']
  const_get(project).output_dir = File.join(const_get(project).path, 'build', $options.projects[project]['output_dir'])
  const_get(project).outputs = $options.projects[project]['outputs']
end

default_build = []
$options.projects.each_key do |project|
  default_build.push("thirdparty:#{project}")
end

task thirdparty: default_build
add_desc('thirdparty', 'Get, build and stage all thirdparty dependencies')

# generate tasks dynamically
$options.projects.each_key do |project|
  namespace :thirdparty do
    task "#{project}": "#{project}:staged"
    add_desc(project, "Prepare #{project}")

    namespace project do
      task cloned: :init do
        Git.clone(project) unless File.exist?(Object.const_get(project).path)
      end

      task build: :cloned do
        build(project) unless Outputs.stage(project).all? { |f| File.exist?(f) }
      end

      task staged: :build do
        Stage.collect(project) unless Outputs.stage(project).all? { |f| File.exist?(f) }
      end

      task :pull do
        Git.pull(project)
      end
      add_desc("#{project}:pull", "Pull upstream #{project} changes")

      task build_stage: :cloned do
        build(project)
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
