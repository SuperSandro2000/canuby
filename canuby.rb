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

## Projects config
Projects = {}
Projects['googletest'] = {'url' => 'https://github.com/google/googletest', 'version' => '1.0.0'}
Projects['dummy'] = {'url' => 'https://github.com/google/googletest', 'version' => '1.0.0'}
Projects['dummy2'] = {'url' => 'https://github.com/google/googletest', 'version' => '1.0.0'}

## build tools config
ENV['vcvars'] ||= '"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"'
ENV['rel_type'] ||= 'RelWithDebInfo'

task default: :thirdparty

desc 'Prepare 3rdparty dependencies'
task thirdparty: ['thirdparty:googletest', 'thirdparty:dummy']

Projects.keys.each do |project|
  namespace :thirdparty do
    Projects[project]['path'] = File.join(base_dir, project)

    desc "Prepare #{project}"
    task "#{project}": "#{project}:staged"

    namespace project do
      def outputs
        ['gtest.lib', 'gtest_main.lib']
      end

      def build_outputs(project)
        output_dir = File.join(Projects[project]['path'], 'build', 'googlemock', 'gtest', ENV['rel_type'])
        outputs.collect { |f| File.join(output_dir, f) }
      end

      task cloned: :init do
        git_clone(Projects[project]['url'], project) unless File.exist?(Projects[project]['path'])
      end

      task built: :cloned do
        msbuild('googletest') unless build_outputs('googletest').all? { |f| File.exist?(f) }
      end

      task staged: :built do
        collect_stage('googletest') unless stage_outputs.all? { |f| File.exist?(f) }
      end

      desc 'Pull upstream googletest changes'
      task :pull do
        git_pull
      end

      desc 'Build and stage googletest'
      task build_stage: :cloned do
        msbuild('googletest')
        collect_stage('googletest')
      end

      desc 'Pull, build and stage googletest'
      task update: [:pull, :build_stage]
    end
  end
end
