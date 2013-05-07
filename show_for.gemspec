# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "show_for/version"

Gem::Specification.new do |s|
  s.name        = "show_for"
  s.version     = ShowFor::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Wrap your objects with a helper to easily show them"
  s.email       = "contact@plataformatec.com.br"
  s.homepage    = "http://github.com/plataformatec/show_for"
  s.description = "Wrap your objects with a helper to easily show them"
  s.authors     = ['José Valim']

  s.files         = Dir["CHANGELOG.rdoc", "MIT-LICENSE", "README.rdoc", "lib/**/*"]
  s.test_files    = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.rubyforge_project = "show_for"

  s.add_dependency('activemodel', '>= 3.0', '< 5')
  s.add_dependency('actionpack', '>= 3.0', '< 5')
end
