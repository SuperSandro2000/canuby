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

require 'canuby/git'
require 'canuby/paths'
require 'canuby/project'
require 'canuby/util'

class CanubyTest < Minitest::Test
  # $project = 'Test'
  # Object.const_set($project, Project.new)
  # Object.const_get($project).path = File.join(Paths.base_dir, $project)

  def test_git
    rm_rf(File.join('testing', 'test')) if Dir.exist?(Object.const_get($project).path)
    Git.clone($project, true)
    assert_exists(File.join(const_get($project).path), 'CMakeLists.txt')
    Git.pull($project, true)
  end
end
