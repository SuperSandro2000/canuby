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
require 'term/ansicolor'

include FileUtils

# Allow easy string formating via string.color
# supported colors on cmd Windows: bold, negative, black, red, green, yellow, blue, magenta, cyan, white
class String
  include Term::ANSIColor
end

def const_set(string, classes)
  Object.const_set(string, classes)
end

def const_get(string)
  Object.const_get(string)
end

module Logging
  def logger
    Logging.logger
  end

  def self.logger
    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG
    logger.formatter = proc do |severity, datetime, progname, msg|
        date_format = datetime.strftime("%d-%m-%Y %H:%M:%S,%L")
        if severity == "DEBUG"
            "[#{date_format}] #{severity} (): #{msg}\n"
        elsif severity == "INFO"
            "[#{date_format}] #{severity}  (#{progname}): #{msg}\n"
        elsif severity == "WARN"
            "[#{date_format}] #{severity}  (#{progname}): #{msg}\n".yellow
        elsif severity == "ERROR"
            "[#{date_format}] #{severity} (#{progname}): #{msg}\n".red
        end
    end
    @logger = logger
  end
end

  # folders and files
module Paths
  # use a different folder for testing
  def self.base_dir(test = false)
    unless test
      '3rdparty'
    else
      'testing'
    end
  end

  def self.build_dir(project)
    File.join(const_get(project).path, 'build')
  end

  def self.stage_dir(test = false)
    File.join(base_dir(test), 'lib')
  end

  def self.create(test = false)
    #mkdir_p self.base_dir(test) unless Dir.exist?(self.base_dir(test))
    mkdir_p self.stage_dir(test) unless Dir.exist?(self.stage_dir(test))
  end
end

module Outputs
  def self.build(project)
    output_dir = const_get(project).output_dir
    if output_dir
      const_get(project).outputs.map { |f| File.join(Paths.build_dir(project), output_dir, ENV['rel_type'], f) }
    else
      const_get(project).outputs.map { |f| File.join(Paths.build_dir(project), ENV['rel_type'], f) }
    end
  end

  def self.stage(project, test = false)
    const_get(project).outputs.map { |f| File.join(Paths.stage_dir(test), f) }
  end
end

# Module handeling git operations.
#
# ``WARNING``
#
# Do not include it as clone conflicts with ruby's inbuilt clone.
module Git
  def self.clone(project)
    puts "Cloning #{const_get(project).url}... to #{const_get(project).path.downcase}"
    system("git clone --depth 1 #{const_get(project).url} #{const_get(project).path.downcase}")
  end

  def self.pull(project)
    Dir.chdir(const_get(project).path)
    system('git pull')
  end
end

module Build
  def self.msbuild(project, project_file)
    puts "Building #{project}..."
    Stage.clean(project)
    build_dir = Paths.build_dir(project)
    mkdir_p build_dir unless Dir.exist?(build_dir)
    Dir.chdir(build_dir) do
      system( 'cmake ..')
      system("#{ENV['vcvars']} && msbuild #{project_file}.sln /p:Configuration=#{ENV['rel_type']} /p:Platform=Win32 /v:m")
    end
  end
end

module Stage
  def self.clean(project)
    const_get(project).outputs.each { |f| rm f if File.exist?(f) }
  end

  def self.collect(project)
    puts "Staging #{project}..."
    const_get(project).outputs.map { |f| cp File.join(const_get(project).output_dir, ENV['reL_type'], f), stage_dir}
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

  def path
    @path
  end
end
