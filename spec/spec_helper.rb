# frozen_string_literal: true

require 'bundler/setup'
require 'simplecov'
require 'simplecov-console'

SimpleCov.formatter = SimpleCov::Formatter::Console
SimpleCov.start do
  root 'lib'
  coverage_dir Dir.pwd + '/coverage'
end

require 'loqate'
require 'vcr'
require 'webmock'

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_localhost = true

  # Allow continue re-recording with flag VCR=all
  record_mode = ENV['VCR'] ? ENV['VCR'].to_sym : :none
  config.default_cassette_options = { record: record_mode }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
