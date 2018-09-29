# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'bundler/audit/task'
require 'rspec/core/rake_task'

Bundler::Audit::Task.new
RSpec::Core::RakeTask.new(:spec)

task default: :spec
