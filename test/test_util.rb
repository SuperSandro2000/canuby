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
require_relative 'test_helper'

require 'fileutils'
require 'minitest/filesystem'
require 'minitest/profile'

require 'util'

class CanubyTest < Minitest::Test
  include FileUtils

  Paths.base_dir = 'testing'
  $project = 'Test'
  Object.const_set($project, Project.new)
  Object.const_get($project).url = 'https://github.com/SuperSandro2000/canuby-cmake-test'
  Object.const_get($project).version = '1.7.10'
  Object.const_get($project).path = File.join(Paths.base_dir, $project)
  Object.const_get($project).output_dir = ''
  Object.const_get($project).outputs = ['math.lib']

  # Object.const_set('CMake_test', Project.new)
  # Object.const_get('CMake_test').outputs = ['math.lib']

  # run ebfore each test
  def setup
  end

  # run after each test
  def teardown
  end

  def timestamp_regex
    '[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}'
  end

  def test_logger
    # CI has a lower log level to not spam the console
    if ENV['CI'] || false
      assert_output(/\[#{timestamp_regex}\] DEBUG \(\): This is an debug log...\n/) { logger.debug('This is an debug log...') }
      assert_output(/\[#{timestamp_regex}\] INFO  \(\): This is an info log...\n/) { logger.info('This is an info log...') }
    else
      assert_output("") { logger.debug('This is an debug log...') }
      assert_output("") { logger.info('This is an info log...') }
    end
    assert_output(/\[#{timestamp_regex}\] WARN  \(\): This is an warn log...\n/) { logger.warn('This is an warn log...') }
    assert_output(/\[#{timestamp_regex}\] ERROR \(\): This is an error log...\n/) { logger.error('This is an error log...') }
  end

  def test_paths
    assert_equal(Paths.base_dir, 'testing')
    assert_equal(File.join(Paths.base_dir, 'test', 'build'), Paths.build_dir($project))
    assert_equal(File.join(Paths.base_dir, 'lib'), Paths.stage_dir)

    assert_exists('testing', Paths.create)
  end

  def test_output
    rel_type = 'RelWithDebInfo'

    assert_equal([File.join(Paths.build_dir($project), rel_type, 'math.lib')], Outputs.build($project))
    assert_equal([File.join(Paths.stage_dir, 'math.lib')], Outputs.stage($project))

    const_get($project).output_dir = 'folder'
    assert_equal([File.join(Paths.build_dir($project), 'folder', rel_type, 'math.lib')], Outputs.build($project))
  end

  def test_git
    rm_rf(File.join('testing', 'test')) if Dir.exist?(Object.const_get($project).path)
    Git.clone($project, true)
    assert_exists(File.join(const_get($project).path), 'CMakeLists.txt')
    Git.pull($project, true)
  end

  def test_cmake
    assert_raises(ArgumentError){ Build.cmake('Test', 'invalid') }
  end

  def git_project(project)
    # const_set(project, Project.new)
    const_get(project).path = File.join(Paths.base_dir, project)
    const_get(project).url = 'https://github.com/SuperSandro2000/canuby-cmake-test'
    Git.clone(project, true) unless File.exist?(File.join(const_get(project).path, 'CMakeLists.txt'))
  end

  def test_msbuild
    return if ENV['linux']

    project = 'CMake_test'
    const_set(project, Project.new)
    const_get(project).outputs = ['math.lib']
    rel_type = 'RelWithDebInfo'

    git_project(project)

    Build.msbuild(project, 'cmake-test', 'q')
    assert_exists(File.join(Paths.build_dir(project), 'cmake-test.sln'))
    assert_exists(File.join(Paths.build_dir(project), rel_type, 'cmake-test.exe'))

    Stage.collect(project)
    assert_exists(File.join(Paths.stage_dir, 'math.lib'))
    Stage.clean(project)
    refute_exists(File.join(Paths.build_dir(project), 'math.lib'))
  end

  Minitest.after_run do
    # FileUtils.rm_rf('testing')
  end
end
