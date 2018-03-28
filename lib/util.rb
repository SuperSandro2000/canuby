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

include FileUtils # rubocop:disable Style/MixinUsage

# Allow easy string formating via string.color.
# Supported colors on cmd Windows are: bold, negative, black, red, green, yellow, blue, magenta, cyan, white
class String
  include Term::ANSIColor
end

# Creates an instance of the class with the name of string
def const_set(string, klass)
  Object.const_set(string, klass)
end

# Acces a constant from a string
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

    if ENV['CI'] == 'true' || false
      @logger.level = Logger::WARN
    elsif ENV['DEBUG'].nil? || ENV['DEBUG'] == 'true' || false
      @logger.level = Logger::DEBUG
    else
      appveyor env variable wrong!
      @logger.level = Logger::INFO
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

# Folder and files related methods
module Paths
  @base_dir = '3rdparty'
  def self.base_dir= var
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
    File.join(self.base_dir, 'lib')
  end

  # Create build folders
  def self.create
    mkdir_p stage_dir unless Dir.exist?(stage_dir)
  end
end

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

# Git related methods
# ``WARNING``
# Do not include it as clone conflicts with ruby's inbuilt clone.
module Git
  # Clone a projects repository
  def self.clone(project, quiet = false)
    logger.info("Cloning #{const_get(project).url}... to #{const_get(project).path.downcase}")
    system("git clone --depth 1 #{const_get(project).url} #{const_get(project).path.downcase} #{'-q' if quiet}")
  end

  # Pull updates for a projects repository
  def self.pull(project, quiet = false)
    Dir.chdir(const_get(project).path) do
      system("git pull #{'-q' if quiet}")
    end
  end
end

# Building related methods
module Build
  # Generate native build projects via CMake.
  #
  # Canuby currently fully supports these Generators:
  #   - Visual Studio 15 2017
  def self.cmake(project, gen_short, quiet = true)
    case gen_short
    when '"Visual Studio 15 2017"', 'VS15'
      generator = '"Visual Studio 15 2017"'
    else
      raise ArgumentError, "Wrong generator supplied!" if generator.nil?
    end
    system("cmake .. -G #{generator} #{'> nul' if quiet}")
  end

  # Adds vcvars to current shell
  def self.vcvars(verbosity, cmd)
    system('msbuild /version >nul 2>&1')
    unless $?.success?
      system("#{ENV['vcvars']}#{'>nul' if verbosity == 'q'} && #{cmd}")
    else
      system("#{cmd}")
    end
  end

  # Build a Visual Studio project via MSBUild.
  # Note: only works on Windows!
  #
  # Verbosity accepts: q[uiet], m[inimal], n[ormal], d[etailed], and diag[nostic]
  # defaults to q. Higher than m[inimal] is not recommended.
  def self.msbuild(project, project_file, verbosity = 'm')
    logger.info("Building #{project}...")
    Stage.clean(project)
    build_dir = Paths.build_dir(project)
    mkdir_p build_dir unless Dir.exist?(build_dir)
    Dir.chdir(build_dir) do
      cmake(project, '"Visual Studio 15 2017"', "#{true if verbosity == 'q'}")
      vcvars(verbosity, "msbuild #{project_file}.sln /p:Configuration=#{ENV['rel_type']} /p:Platform=Win32  /v:#{verbosity} /nologo")
    end
  end
end

# Staging related methods
module Stage
  # Delete all staged files from a project
  def self.clean(project)
    const_get(project).outputs.each { |f| rm f if File.exist?(f) }
  end

  # Collect all stage files from a project
  def self.collect(project)
    logger.info("Staging #{project}...")
    Paths.create
    output_dir = const_get(project).output_dir
    if output_dir
      const_get(project).outputs.map { |f| cp File.join(const_get(project).output_dir, ENV['rel_type'], f), Paths.stage_dir }
    else
      const_get(project).outputs.map { |f| cp File.join(Paths.build_dir(project), ENV['rel_type'], f), Paths.stage_dir }
    end
  end
end

# Holds all properties a Project has.
class Project
  attr_accessor :url, :version, :project_file, :output_dir, :outputs
  attr_reader :path

  def initialize()
  end

  def path=(dir)
    @path = dir.downcase
  end
end
