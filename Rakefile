# encoding: UTF-8

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'show_for', 'version')

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the show_form plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the show_for plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ShowFor'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "show_for"
    s.version = ShowFor::VERSION
    s.summary = "Wrap your objects with a helper to easily show them"
    s.email = "contact@plataformatec.com.br"
    s.homepage = "http://github.com/plataformatec/show_for"
    s.description = "Wrap your objects with a helper to easily show them"
    s.authors = ['José Valim']
    s.files =  FileList["[A-Z]*(.rdoc)", "{generators,lib}/**/*", "init.rb"]
  end

  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install jeweler"
end
