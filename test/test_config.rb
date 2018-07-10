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
require 'test_helper'

require 'canuby/config'
require 'canuby/util'

class CanubyTest < Minitest::Test
  ENV['ignore_config_file'] = 'true'

  def test_empty_config
    build_options = {}
    $build_options = OpenStruct.new(build_options)
    assert_raises(StandardError) { Config.check }
  end

  def test_almost_empty_config
    build_options = { 'projects' => '' }
    $build_options = OpenStruct.new(build_options)
    assert_raises(StandardError) { Config.check }
  end

  def test_empty_project
    build_options = { 'projects' => {
      'Googletest' => {}
    } }
    $build_options = OpenStruct.new(build_options)
    assert_raises(StandardError) { Config.check }
  end

  def test_full_empty_project
    build_options = { 'projects' => {
      'Googletest' => { 'url' => 'https://github.com/google/googletest', 'version' => '1.0.0',
                        'build_tool' => 'msbuild', 'project_file' => 'googletest-distribution',
                        'output_dir' => 'googlemock/gtest', 'outputs' => ['gtest.lib', 'gtest_main.lib'] }, \
      'Dummy' => {}
    } }
    $build_options = OpenStruct.new(build_options)
    assert_raises(StandardError) { Config.check }
  end

  def test_complete_config
    build_options = { 'projects' => {
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
    $build_options = OpenStruct.new(build_options)
    assert_output(/#{timestamp_regex('magenta')} \e\[0;31;49mWARN\e\[0m  \(\): Config is valid!/) { Config.check }
  end
end
