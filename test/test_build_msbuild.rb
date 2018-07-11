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
require 'test_helper'

require 'canuby/build/msbuild'
require 'canuby/git'
require 'canuby/paths'

class CanubyTest < Minitest::Test
  def git_project(project)
    const_set(project, Project.new)
    const_get(project).outputs = ['math.lib']
    const_get(project).path = File.join(Paths.base_dir, project)
    const_get(project).url = 'https://github.com/SuperSandro2000/canuby-cmake-test'
    Git.clone(project, true) unless File.exist?(File.join(const_get(project).path, 'CMakeLists.txt'))
  end

  def test_msbuild
    return if ENV['linux']

    project = 'CMake_test'
    rel_type = 'RelWithDebInfo'
    git_project(project)

    Build.msbuild(project, 'cmake-test', 'q')
    assert_exists(File.join(Paths.build_dir(project), 'cmake-test.sln'))
    assert_exists(File.join(Paths.build_dir(project), rel_type, 'cmake-test.exe'))

    Stage.collect(project, 'q')
    assert_exists(File.join(Paths.stage_dir, 'math.lib'))
    Stage.clean(project)
    refute_exists(File.join(Paths.build_dir(project), 'math.lib'))
  end

  Minitest.after_run do
    FileUtils.rm_rf('testing')
  end
end
