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

# Output related methods
module Outputs
  # Returns a list of the projects output files
  def self.build(project)
    output_dir = const_get(project).output_dir
    if output_dir
      const_get(project).outputs.map { |f| File.join(Paths.build_dir(project), output_dir, ENV['rel_type'], f) }
    else
      const_get(project).outputs.map { |f| File.join(Paths.build_dir(project), ENV['rel_type'], f) }
    end
  end

  # Returns a list of the projects stage files
  def self.stage(project)
    const_get(project).outputs.map { |f| File.join(Paths.stage_dir, f) }
  end
end
