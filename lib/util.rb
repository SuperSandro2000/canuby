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
require 'fileutils'
require 'logger'
require 'term/ansicolor'

include FileUtils

# Allow easy string formating via string.color
# supported colors on cmd Windows are: bold, negative, black, red, green, yellow, blue, magenta, cyan, white
class String
  include Term::ANSIColor
end

# creates an instance of the class with the name of string
def const_set(string, klass)
  Object.const_set(string, klass)
end

# acces a constant from a string
def const_get(string)
  Object.const_get(string)
end

# Canuby's Logger
module Logging
  def self.log(severity, datetime, progname, msg)
    date_format = datetime.strftime('%d-%m-%Y %H:%M:%S,%L')
    case severity
    when 'DEBUG'
      "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
    when 'INFO'
      "[#{date_format}] #{severity}  (#{progname}): #{msg}\n"
    when 'WARN'
      "[#{date_format}] #{severity}  (#{progname}): #{msg}\n".yellow
    when 'ERROR'
      "[#{date_format}] #{severity} (#{progname}): #{msg}\n".red
    end
  end

  def self.logger
    @logger = Logger.new($stdout)
    @logger.level = Logger::DEBUG
    @logger.formatter = proc do |severity, datetime, progname, msg|
      self.log(severity, datetime, progname, msg)
    end
    @logger
  end
end

# shortcut to logger
def logger
  Logging.logger
end

# folder and files related methods
module Paths
  # returns the dependency folder
  def self.base_dir(test = false)
    # use a different folder for testing
    if test
      'testing'
    else
      '3rdparty'
    end
  end

  # returns a projects build dir
  def self.build_dir(project)
    File.join(const_get(project).path, 'build')
  end

  # returns stage dir
  def self.stage_dir(test = false)
    File.join(base_dir(test), 'lib')
  end

  # create build folders
  def self.create(test = false)
    # mkdir_p self.base_dir(test) unless Dir.exist?(self.base_dir(test))
    mkdir_p stage_dir(test) unless Dir.exist?(stage_dir(test))
  end
end

# Output related methods
module Outputs
  # returns a list of the projects output files
  def self.build(project)
    output_dir = const_get(project).output_dir
    if output_dir
      const_get(project).outputs.map { |f| File.join(Paths.build_dir(project), output_dir, ENV['rel_type'], f) }
    else
      const_get(project).outputs.map { |f| File.join(Paths.build_dir(project), ENV['rel_type'], f) }
    end
  end

  # returns a list of the projects stage files
  def self.stage(project, test = false)
    const_get(project).outputs.map { |f| File.join(Paths.stage_dir(test), f) }
  end
end

# Git related methods
# ``WARNING``
# Do not include it as clone conflicts with ruby's inbuilt clone.
module Git
  # clone a projects repository
  def self.clone(project)
    puts "Cloning #{const_get(project).url}... to #{const_get(project).path.downcase}"
    system("git clone --depth 1 #{const_get(project).url} #{const_get(project).path.downcase}")
  end

  # pull updates for a projects repository
  def self.pull(project)
    Dir.chdir(const_get(project).path)
    system('git pull')
  end
end

# Building related methods
module Build
  # build a CMake project via MSBUild
  # Note: only works on Windows
  def self.msbuild(project, project_file)
    puts "Building #{project}..."
    Stage.clean(project)
    build_dir = Paths.build_dir(project)
    mkdir_p build_dir unless Dir.exist?(build_dir)
    Dir.chdir(build_dir) do
      system('cmake ..')
      system("#{ENV['vcvars']} && msbuild #{project_file}.sln /p:Configuration=#{ENV['rel_type']} /p:Platform=Win32 /v:m")
    end
  end
end

# Staging related methods
module Stage
  # delete all staged files from a project
  def self.clean(project)
    const_get(project).outputs.each { |f| rm f if File.exist?(f) }
  end

  # collect all stage files from a project
  def self.collect(project)
    puts "Staging #{project}..."
    const_get(project).outputs.map { |f| cp File.join(const_get(project).output_dir, ENV['reL_type'], f), stage_dir }
  end
end
# Holds all properties a Project has
class Project
  def initialize(url = '')
    @url = url
  end

  attr_accessor :url, :version, :project_file, :output_dir, :outputs

  def path=(dir)
    @path = dir.downcase
  end

  attr_reader :path
end
