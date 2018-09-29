# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'bundler/audit/task'
require 'rspec/core/rake_task'

Bundler::Audit::Task.new
RSpec::Core::RakeTask.new(:spec)

task default: :spec

# Delete these files and folders when running rake clobber.
CLOBBER.include('coverage', '.rspec_status')

desc 'Run spec with coverage'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
  `open coverage/index.html`
end
