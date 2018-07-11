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

# Git related methods
# ``WARNING``
# Do not include it as clone conflicts with ruby's inbuilt clone.
module Git
  # Clone a projects repository
  def self.clone(project, quiet = false)
    logger.info("Cloning #{const_get(project).url}... to #{const_get(project).path.downcase}") unless quiet
    system("git clone --depth 1 #{const_get(project).url} #{const_get(project).path.downcase} #{'-q' if quiet}")
  end

  # Pull updates for a projects repository
  def self.pull(project, quiet = false)
    Dir.chdir(const_get(project).path) do
      system("git pull #{'-q' if quiet}")
    end
  end
end
