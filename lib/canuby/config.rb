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

# Canuby's Config utility to read and write canuby.yml files
#
# Structure:
# projects => name =>
# url, version, build_tool, project_file, output_dir, outputs
module Config
  def self.load
    # skip if run trough rake or bundler
    args = ArgParser.min(ARGV)
    if ENV['Testing'] != 'true' && File.exist?(args.yml_file)
      $options = OpenStruct.new(args.to_h.merge!(YAML.load_file(args.yml_file)))
    else
      default = { 'projects' => {
        'Googletest' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0',
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
  end

  def self.write
    write_config = $options.to_h
    [:target, :yml_file].each do |key|
      write_config.delete(key)
    end

    File.write('canuby.yml', write_config.to_yaml)
  end
end
