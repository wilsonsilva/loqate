# Loqate

[![Gem Version](https://badge.fury.io/rb/loqate.svg)](https://badge.fury.io/rb/loqate)
[![Build Status](https://travis-ci.org/wilsonsilva/loqate.svg?branch=master)](https://travis-ci.org/wilsonsilva/loqate)
[![Maintainability](https://api.codeclimate.com/v1/badges/5c1414d5dedc68c15533/maintainability)](https://codeclimate.com/github/wilsonsilva/loqate/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5c1414d5dedc68c15533/test_coverage)](https://codeclimate.com/github/wilsonsilva/loqate/test_coverage)
[![Security](https://hakiri.io/github/wilsonsilva/loqate/master.svg)](https://hakiri.io/github/wilsonsilva/loqate/master)
[![Inline docs](http://inch-ci.org/github/wilsonsilva/loqate.svg?branch=master)](http://inch-ci.org/github/wilsonsilva/loqate)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/loqate`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'loqate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install loqate

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive
prompt that will allow you to experiment. The health and maintainability of the codebase is ensured through a set of
Rake tasks to test, lint and audit the gem for security vulnerabilities and documentation:

```
rake bundle:audit          # Checks for vulnerable versions of gems 
rake qa                    # Test, lint and perform security and documentation audits
rake rubocop               # Lint the codebase with RuboCop
rake rubocop:auto_correct  # Auto-correct RuboCop offenses
rake spec                  # Run RSpec code examples
rake verify_measurements   # Verify that yardstick coverage is at least 100%
rake yard                  # Generate YARD Documentation
rake yard:junk             # Check the junk in your YARD Documentation
rake yardstick_measure     # Measure docs in lib/**/*.rb with yardstick
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/loqate.
