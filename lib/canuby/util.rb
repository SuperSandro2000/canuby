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
require 'colorize'
require 'logger'

## build tools config
# TODO make changeable
ENV['vcvars'] = '"C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat"'
ENV['rel_type'] = 'RelWithDebInfo'

# Creates an instance of the class with the name of string
def const_set(string, klass)
  Object.const_set(string, klass)
end

# Acces a constant from a string
def const_get(string)
  Object.const_get(string)
end

# Add description to rake tasks that show up in help
def add_desc(task, comment)
  Rake.application[task].add_description(comment)
end

# Canuby's Logger
module Logging
  def self.log(severity, datetime, progname, msg)
    date_format = "[#{datetime.strftime('%d-%m-%Y %H:%M:%S,%L')}]".magenta
    # color needs to be set before \n or it will leak into the console
    case severity
    when 'DEBUG'
      "#{date_format} #{severity} (#{progname}): #{msg}".cyan + "\n"
    when 'INFO'
      "#{date_format} #{severity.yellow}  (#{progname}): #{msg}" + "\n"
    when 'WARN'
      "#{date_format} #{severity.red}  (#{progname}): #{msg}" + "\n"
    when 'ERROR'
      "#{date_format} #{severity} (#{progname}): #{msg}".red + "\n"
    end
  end

  def self.logger
    @logger = Logger.new($stdout)

    @logger.level = if ENV['CI'] == 'true' || ENV['Testing'] == 'true'
                      Logger::WARN
                    elsif $options.debug
                      Logger::DEBUG
                    else
                      Logger::INFO
                    end

    @logger.formatter = proc do |severity, datetime, progname, msg|
      log(severity, datetime, progname, msg)
    end
    @logger
  end
end

# Shortcut to logger
def logger
  Logging.logger
end
