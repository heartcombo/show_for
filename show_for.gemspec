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
  s.licenses    = ["MIT"]

  s.files         = Dir["CHANGELOG.md", "MIT-LICENSE", "README.md", "lib/**/*"]
  s.test_files    = Dir["test/**/*"]
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 2.1.7'

  s.add_dependency('activemodel', '>= 4.1', '< 5.2')
  s.add_dependency('actionpack', '>= 4.1', '< 5.2')
end
