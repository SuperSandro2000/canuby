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

# Staging related methods
module Stage
  # Delete all staged files from a project
  def self.clean(project)
    const_get(project).outputs.each { |f| rm f if File.exist?(f) }
  end

  # Collect all stage files from a project
  def self.collect(project, verbosity = 'm')
    logger.info("Staging #{project}...") unless verbosity == 'q'
    Paths.create
    if const_get(project).output_dir.nil?
      const_get(project).outputs.map { |f| cp File.join(Paths.build_dir(project), ENV['rel_type'], f), Paths.stage_dir }
    else
      const_get(project).outputs.map { |f| cp File.join(const_get(project).output_dir, ENV['rel_type'], f), Paths.stage_dir }
    end
  end
end
