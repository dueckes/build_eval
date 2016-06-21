require 'bundler'
require 'bundler/gem_tasks'
Bundler.require(:default, :development)

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

desc "Source code metrics analysis"
RuboCop::RakeTask.new(:metrics) { |task| task.fail_on_error = true }

directory 'pkg'

desc "Removed generated artefacts"
task :clobber do
  %w{ pkg tmp }.each { |dir| rm_rf dir }
  rm Dir.glob("**/coverage.data"), force: true
  puts "Clobbered"
end

desc "Exercises unit specifications"
RSpec::Core::RakeTask.new(:unit) do |task|
  task.rspec_opts = "--tag ~integration --tag ~smoke"
end

desc "Exercises integration specifications"
RSpec::Core::RakeTask.new(:integration) do |task|
  task.pattern = "spec/**/*integration_spec.rb"
end

desc "Exercises smoke specifications"
RSpec::Core::RakeTask.new(:smoke) do |task|
  task.pattern = "spec/**/*smoke_spec.rb"
end

desc "Exercises unit specifications with coverage analysis"
task coverage: "coverage:generate"

namespace :coverage do
  desc "Generates unit specification coverage results"
  task :generate do
    ENV["coverage"] = "enabled"
    Rake::Task[:unit].invoke
    ENV["coverage"] = nil
  end

  desc "Shows specification coverage results in browser"
  task :show do
    begin
      Rake::Task["coverage:generate"].invoke
    ensure
      `open tmp/coverage/index.html`
    end
  end
end

task :validate do
  print " Travis CI Validation ".center(80, "*") + "\n"
  result = "travis-lint #{::File.expand_path("../.travis.yml", __FILE__)}"
  puts result
  print "*" * 80 + "\n"
  raise "Travis CI validation failed" unless $CHILD_STATUS.success?
end

task default: %w( clobber metrics coverage integration smoke )

task pre_commit: %w( clobber metrics coverage:show validate )
