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
include FileUtils # rubocop:disable Style/MixinUsage

# Folder and files related methods
module Paths
  require 'canuby/argparser'
  $options = ArgParser.parse(ARGV)
  
  # defaults to 3rdparty
  @base_dir = $options.base_dir.to_s
  # @base_dir = 'testing'
  def self.base_dir=(var)
    @base_dir = var
  end

  # Returns the dependency folder
  # custom allows to change the default path
  def self.base_dir
    @base_dir
  end

  # Returns a projects build dir
  def self.build_dir(project)
    File.join(const_get(project).path, 'build')
  end

  # returns stage dir
  def self.stage_dir
    File.join(base_dir, 'lib')
  end

  # Create build folders
  def self.create
    mkdir_p stage_dir unless Dir.exist?(stage_dir)
  end
end
