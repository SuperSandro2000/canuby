Gem::Specification.new do |s|
  s.name        = 'canuby'
  s.version     = '0.0.1'
  s.date        = '2018-03-23'
  s.summary     = "Canuby"
  s.description = "A placeholder for Canuby"
  s.authors     = ["Sandro Jäckel"]
  s.email       = 'sandro.jaeckel@gmail.com'
  s.homepage    = 'https://github.com/SuperSandro2000/canuby'
  s.metadata    = { "source_code_uri" => "https://github.com/SuperSandro2000/canuby" }
  s.license     = 'GPL-3.0'
  s.files       = ["lib/canuby.rb"]

  s.required_ruby_version = '~> 2.5'
  s.required_rubygems_version = '~> 2.7.3'

  s.add_dependency 'bundler', '~> 1.16'
  s.add_dependency 'rake', '~> 12.3'
  s.add_dependency 'term-ansicolor', '~> 1.6'
  s.add_dependency 'tins', '~> 1.16'
end
