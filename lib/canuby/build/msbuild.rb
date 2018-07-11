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
require 'open3'

require 'canuby/stage'

# Building related methods
module Build
  # Run command trough vcvars
  def self.vcvars(cmd)
    Open3.popen2("#{ENV['vcvars']} && #{cmd}") do |_stdin, stdout, _status_thread|
      stdout.each_line { |line| logger.debug(line.delete("\n")) }
    end
  rescue StandardError
    raise StandardError, "Do you have Visual Studio installed? #{stdout}"
  end

  # Build a Visual Studio project via MSBUild.
  # Note: only works on Windows!
  #
  # Verbosity controlls the msbuild verbosity not if it is printed to console.
  # To show the actual output in console run canuby with the debug flag.
  #
  # Verbosity accepts: q[uiet], m[inimal], n[ormal], d[etailed], and diag[nostic]
  # defaults to q. Higher than m[inimal] is not recommended.
  def self.msbuild(project, project_file, verbosity = 'm')
    logger.info("Building #{project}...")
    Stage.clean(project)
    build_dir = Paths.build_dir(project)
    mkdir_p build_dir unless Dir.exist?(build_dir)
    Dir.chdir(build_dir) do
      cmake('"Visual Studio 15 2017"')
      vcvars("msbuild #{project_file}.sln /p:Configuration=#{ENV['rel_type']} /p:Platform=Win32  /v:#{verbosity} /nologo")
    end
  end
end
