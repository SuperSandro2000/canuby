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

require 'canuby/outputs'
require 'canuby/paths'

class CanubyTest < Minitest::Test
  def test_outputs
    rel_type = 'RelWithDebInfo'

    assert_equal([File.join(Paths.build_dir($project), rel_type, 'math.lib')], Outputs.build($project))
    assert_equal([File.join(Paths.stage_dir, 'math.lib')], Outputs.stage($project))

    const_get($project).output_dir = 'folder'
    assert_equal([File.join(Paths.build_dir($project), 'folder', rel_type, 'math.lib')], Outputs.build($project))
  end
end
