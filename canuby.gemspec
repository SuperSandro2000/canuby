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
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canuby/version'

Gem::Specification.new do |spec|
  spec.name           = 'canuby'
  spec.version        =  Canuby::Version
  spec.authors        = ["Sandro J\xC3\xA4ckel"]
  spec.email          = ["sandro.jaeckel@gmail.com"]

  spec.summary        = 'Canuby build tool'
  spec.description    = 'Canuby is a modular and very flexible dependency manager that can download,
                      build and stage dependencies from multiple languages and build tools.'
  spec.homepage       = 'https://github.com/SuperSandro2000/canuby'
  spec.metadata       = {
    'bug_tracker_uri' => 'https://github.com/SuperSandro2000/canuby/issues',
    'changelog_uri'   => 'https://github.com/SuperSandro2000/canuby/releases',
    'homepage_uri'    => 'https://supersandro2000.github.io/canuby/',
    'source_code_uri' => 'https://github.com/SuperSandro2000/canuby'
  }
  spec.license        = 'GPL-3.0'

  spec.files          = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir         = "exe"
  spec.executables    = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths  = ["lib"]

  spec.required_ruby_version = '~> 2.5'
  spec.required_rubygems_version = '~> 2.7.3'

  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'rake', '~> 12.3'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "minitest", "~> 5.11"
  spec.add_development_dependency "minitest-filesystem", "~> 1.2"
  spec.add_development_dependency "minitest-profile", "~> 0.0.2"
  spec.add_development_dependency "minitest--", "~> 5.2"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency 'yard', '~> 0.9.12'
end
