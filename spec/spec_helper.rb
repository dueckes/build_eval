require 'bundler'
Bundler.require(:development)

if ENV["coverage"]
  CodeClimate::TestReporter.start

  SimpleCov.start do
    coverage_dir "tmp/coverage"

    add_filter "/spec/"

    minimum_coverage 100
    refuse_coverage_drop
  end
end

require_relative '../lib/build_eval'
