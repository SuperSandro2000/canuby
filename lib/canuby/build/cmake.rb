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

# Building related methods
module Build
  # Generate native build projects via CMake.
  #
  # Canuby currently fully supports these Generators:
  #   - Visual Studio 15 2017
  def self.cmake(gen_short)
    case gen_short
    when '"Visual Studio 15 2017"', 'VS15'
      generator = '"Visual Studio 15 2017"'
    else
      raise ArgumentError, 'Wrong generator supplied!' if generator.nil?
    end
    begin
      Open3.popen2("cmake .. -G #{generator}") do |_stdin, stdout, _status_thread|
        stdout.each_line { |line| logger.debug(line.delete("\n")) }
      end
    rescue StandardError
      raise StandardError, 'Do you have CMake installed?'
    end
  end
end
