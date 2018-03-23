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
Gem::Specification.new do |s|
  s.name        = 'canuby'
  s.version     = '0.0.1'
  s.executables << 'canuby'

  s.date        = '2018-03-23'
  s.summary     = 'Canuby'
  s.description = 'Canuby build using rake'
  s.authors     = ['Sandro Jäckel']
  s.email       = 'sandro.jaeckel@gmail.com'
  s.homepage    = 'https://github.com/SuperSandro2000/canuby'
  s.metadata    = { 'source_code_uri' => 'https://github.com/SuperSandro2000/canuby' }
  s.license     = 'GPL-3.0'

  s.files       = ['bin/canuby', 'lib/canuby.rb', 'lib/util.rb']
  s.test_files = ["test/test_canuby.rb"]

  s.required_ruby_version = '~> 2.5'
  s.required_rubygems_version = '~> 2.7.3'

  s.add_dependency 'bundler', '~> 1.16'
  s.add_dependency 'rake', '~> 12.3'
  s.add_dependency 'term-ansicolor', '~> 1.6'
  s.add_dependency 'tins', '~> 1.16'
end
