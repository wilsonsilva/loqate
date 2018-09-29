# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'bundler/audit/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yaml'
require 'yard/rake/yardoc_task'
require 'yard-junk/rake'
require 'yardstick/rake/measurement'
require 'yardstick/rake/verify'

yardstick_options = YAML.load_file('.yardstick.yml')

Bundler::Audit::Task.new
RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new
YardJunk::Rake.define_task
Yardstick::Rake::Measurement.new(:yardstick_measure, yardstick_options)
Yardstick::Rake::Verify.new

task default: :spec

# Delete these files and folders when running rake clobber.
CLOBBER.include('coverage', '.rspec_status')

# Remove the report on rake clobber
CLEAN.include('measurements', 'doc', '.yardoc', 'tmp')

desc 'Run spec with coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
  `open coverage/index.html`
end
