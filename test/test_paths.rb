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

class CanubyTest < Minitest::Test
  def test_paths
    assert_equal(Paths.base_dir, 'testing')
    assert_equal(File.join(Paths.base_dir, 'test', 'build'), Paths.build_dir($project))
    assert_equal(File.join(Paths.base_dir, 'lib'), Paths.stage_dir)

    assert_exists('testing', Paths.create)
  end
end
