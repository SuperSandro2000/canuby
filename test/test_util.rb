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

  $rel_type = 'RelWithDebInfo'
  $project = 'Test'
  Object.const_set($project, Project.new)
  Object.const_get($project).url = 'https://github.com/SuperSandro2000/canuby-cmake-test'
  Object.const_get($project).version = '1.7.10'
  Object.const_get($project).path = File.join(Paths.base_dir(true), $project)
  Object.const_get($project).outputs = ['math.lib']

  # run ebfore each test
  def setup; end

  # run after each test
  def teardown; end

  def timestamp_regex
    '[0-9]{2}-[0-9]{2}-[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2},[0-9]{3}'
  end

  def test_logger
    assert_output(/\[#{timestamp_regex}\] DEBUG \(\): This is an debug log...\n/) { logger.debug('This is an debug log...') }
    assert_output(/\[#{timestamp_regex}\] INFO  \(\): This is an info log...\n/) { logger.info('This is an info log...') }
    assert_output(/\[#{timestamp_regex}\] WARN  \(\): This is an warn log...\n/) { logger.warn('This is an warn log...') }
    assert_output(/\[#{timestamp_regex}\] ERROR \(\): This is an error log...\n/) { logger.error('This is an error log...') }
  end

  def test_paths
    assert_equal(Paths.base_dir(true), 'testing')
    assert_equal(File.join(Paths.base_dir(true), 'test', 'build'), Paths.build_dir($project))
    assert_equal(File.join(Paths.base_dir(true), 'lib'), Paths.stage_dir(true))

    assert_exists('testing', Paths.create(true))
  end

  def test_output
    assert_equal([File.join(Paths.build_dir($project), $rel_type, 'math.lib')], Outputs.build($project))
    assert_equal([File.join(Paths.stage_dir(true), 'math.lib')], Outputs.stage($project, true))
  end

  def test_git
    rm_rf('testing') if Dir.exist?(Object.const_get($project).path)
    Git.clone($project)
    assert_exists(File.join(const_get($project).path), 'CMakeLists.txt')
    # TODO: just cloned. Repo is up to date.
    # Git.pull(@project)
  end

  def test_msbuild
    return if ENV['linux']

    Git.clone($project) unless File.exist?(File.join(const_get($project).path, 'CMakeLists.txt'))
    Build.msbuild($project, 'cmake-tutorial')
    assert_exists(File.join(Paths.build_dir($project), 'cmake-tutorial.sln'))
    assert_exists(File.join(Paths.build_dir($project), $rel_type, 'cmake-tutorial.exe'))
  end

  Minitest.after_run do
    FileUtils.rm_rf('testing')
  end
end
