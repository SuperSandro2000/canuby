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

## folders and files
def base_dir
  '3rdparty'
end

def stage_dir
  File.join(base_dir, 'lib')
end

def stage_outputs
  outputs.collect { |f| File.join(stage_dir, f) }
end

## external tools methods
def git_clone(url, project)
  puts "Cloning #{url}... to Projects[project]['path']"
  sh "git clone #{url} #{Projects[project]['path']}"
end

def git_pull
  Dir.chdir(Projects[project]['path'])
  sh 'git pull'
end

def msbuild(project)
  puts "Building #{project}..."
  clean_stage
  build_dir = File.join(Projects[project]['path'], 'build')
  mkdir_p build_dir
  Dir.chdir(build_dir) do
    sh 'cmake ..'
    sh "call #{ENV['vcvars']} && msbuild #{project}-distribution.sln /p:Configuration=#{ENV['reL_type']} /p:Platform=Win32 /v:m"
  end
end

## stage
def clean_stage
  stage_outputs.each { |f| rm f if File.exist?(f) }
end

def collect_stage(project)
  puts "Staging #{project}..."
  mkdir_p stage_dir
  cp build_outputs(project), stage_dir
end

## standard tasks
namespace :thirdparty do
  task :init do
    mkdir_p base_dir unless Dir.exist?(base_dir)
  end
end
