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
require 'yaml'

require 'canuby/argparser'
require 'canuby/util'

# Canuby's Config utility to read and write canuby.yml files
#
# Structure:
# projects => name =>
# url, version, build_tool, project_file, output_dir, outputs
module Config
  def self.load
    # skip if run trough rake or bundler
    args = ArgParser.min(ARGV)
    logger.debug("Ignoring config file #{ENV['ignore_config_file']}")
    if ENV['Testing'] != 'true' && ENV['ignore_config_file'] != 'true' && File.exist?(args.yml_file)
      yaml_file = YAML.load_file(args.yml_file)
      migrate(yaml_file[:config_version], Canuby::CONFIG_VERSION) if yaml_file[:config_version] != Canuby::CONFIG_VERSION
      $build_options = OpenStruct.new(args.to_h.merge!(yaml_file)) unless ENV['ignore_config_file']
    else
      default = { 'projects' => {
        'Googletest' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0', \
                          'build_tool' => 'msbuild', 'project_file' => 'googletest-distribution',
                          'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest.lib', 'gtest_main.lib'] }, \
        'Dummy' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0',
                     'build_tool' => 'msbuild', 'project_file' => 'googletest-distribution',
                     'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest.lib'] }, \
        'Dummy2' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0',
                      'build_tool' => 'msbuild', 'project_file' => 'googletest-distribution',
                      'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest_main.lib'] }
      } }
      $build_options = OpenStruct.new(args.to_h.merge!(default))
    end
  end

  def self.check
    invalid('Missing projects key') unless $build_options.respond_to? :projects
    invalid('Missing project value') unless $build_options.projects.key?($build_options.projects.keys[0])
    $build_options.projects.each_key do |project|
      %w[url version build_tool project_file output_dir outputs].each_entry do |key|
        invalid("#{project} misses #{key} key") unless $build_options.projects[project.to_s].key?(key)
      end
    end
    logger.warn('Config is valid!')
  end

  def self.invalid(option)
    raise StandardError, "#{option}. Canuby can't continue"
  end

  def self.migrate(from_version, to_version)
    # TODO
    logger.info("Migrating from #{from_version} to #{to_version}")
  end

  def self.write
    write_config = $build_options.to_h
    [:target, :yml_file].each do |key|
      write_config.delete(key)
    end

    File.write('canuby.yml', write_config.to_yaml)
  end
end
