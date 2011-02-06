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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.rubyforge_project = "show_for"
end
