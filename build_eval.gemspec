# -*- encoding: utf-8 -*-
$LOAD_PATH.push ::File.expand_path('../lib', __FILE__)
require 'build_eval/version'

Gem::Specification.new do |spec|
  spec.name              = "build_eval"
  spec.version           = BuildEval::VERSION
  spec.platform          = Gem::Platform::RUBY
  spec.authors           = [ "Matthew Ueckerman", "Ryan Davis", "Andy King" ]
  spec.summary           = "Evaluates the effective status of continuous integration builds"
  spec.description       = "Evaluates the effective status of continuous integration builds."\
                           " Useful for subsequent display on information radiators."
  spec.email             = "matthew.ueckerman@myob.com"
  spec.homepage          = "http://github.com/MYOB-Technology/build_eval"
  spec.rubyforge_project = "build_eval"
  spec.license           = "MIT"

  spec.files      = Dir.glob('./lib/**/*')
  spec.test_files = Dir.glob('./spec/**/*')

  spec.require_path = 'lib'

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'travis',   '~> 1.8'

  spec.add_development_dependency 'rake',                      '~> 11.2'
  spec.add_development_dependency 'rubocop',                   '~> 0.42'
  spec.add_development_dependency 'rspec',                     '~> 3.5'
  spec.add_development_dependency 'fakeweb',                   '~> 1.3'
  spec.add_development_dependency 'simplecov',                 '~> 0.12'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.6'
  spec.add_development_dependency 'travis-lint',               '~> 2.0'
end
