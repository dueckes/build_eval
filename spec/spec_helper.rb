require 'bundler'
Bundler.require(:development)

if ENV['coverage']
  CodeClimate::TestReporter.start

  SimpleCov.start do
    coverage_dir 'tmp/coverage'

    add_filter '/examples/'
    add_filter '/spec/'

    minimum_coverage 100
    refuse_coverage_drop
  end
end

require_relative '../lib/build_eval'
require_relative '../examples/travis'

%w( shared_examples shared_context ).each do |file_type|
  Dir[::File.expand_path("../**/*_#{file_type}.rb", __FILE__)].each { |file| require file }
end
