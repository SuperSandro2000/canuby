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
  # Load config from file or default if no file exists.
  def self.load
    # skip if run trough rake or bundler
    args = ArgParser.min(ARGV)
    logger.debug("Ignoring config file #{$options.ignore_config_file}")
    if ENV['Testing'] != 'true' && $options.ignore_config_file != 'true' && File.exist?(args.yml_file)
      yaml_file = YAML.load_file(args.yml_file)
      migrate(yaml_file[:config_version], Canuby::CONFIG_VERSION)
      $options = OpenStruct.new(args.to_h.merge!(yaml_file))
    else
      load_default(args)
    end
  end

  # Default config file. Mostly used for testing.
  def self.load_default(args)
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
    $options = OpenStruct.new(args.to_h.merge!(default))
  end

  # Checks if the config structure is valid. Does not check if the actual content is working.
  def self.check(quiet = false)
    invalid('Missing projects key') unless $options.respond_to? :projects
    invalid('Missing project value') unless $options.projects.key?($options.projects.keys[0])
    $options.projects.each_key do |project|
      %w[url version build_tool project_file output_dir outputs].each_entry do |key|
        invalid("#{project} misses #{key} key") unless $options.projects[project.to_s].key?(key)
      end
    end
    logger.warn('Config is valid!') unless quiet
  end

  def self.invalid(option)
    raise StandardError, "#{option}. Canuby can't continue"
  end

  # Migrate the config to a newer version. Not used until Canuby hits a more stable state.
  def self.migrate(from_version, to_version)
    return unless from_version != to_version

    logger.info("Migrating from #{from_version} to #{to_version}")
    case from_version
    when 0
      logger.warn('No compatibility gurantied!')
    # TODO
    when 1
      logger.error('TODO')
      # TODO
    end
  end

  # Write config to file
  def self.write
    write_config = $options.to_h
    [:target, :yml_file].each do |key|
      write_config.delete(key)
    end

    File.write('canuby.yml', write_config.to_yaml)
  end
end
