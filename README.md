# Loqate

[![Gem Version](https://badge.fury.io/rb/loqate.svg)](https://badge.fury.io/rb/loqate)
[![Build Status](https://travis-ci.org/wilsonsilva/loqate.svg?branch=master)](https://travis-ci.org/wilsonsilva/loqate)
[![Maintainability](https://api.codeclimate.com/v1/badges/5c1414d5dedc68c15533/maintainability)](https://codeclimate.com/github/wilsonsilva/loqate/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5c1414d5dedc68c15533/test_coverage)](https://codeclimate.com/github/wilsonsilva/loqate/test_coverage)
[![Security](https://hakiri.io/github/wilsonsilva/loqate/master.svg)](https://hakiri.io/github/wilsonsilva/loqate/master)
[![Inline docs](http://inch-ci.org/github/wilsonsilva/loqate.svg?branch=master)](http://inch-ci.org/github/wilsonsilva/loqate)

Client to address verification, postcode lookup, & data quality services from Loqate.

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

### Getting started

Loqate provides multiple APIs. And each API provides several services. This gem exposes these APIs through
an API gateway.

To get started, initialize an API gateway with [your API key](https://account.loqate.com/account#/):

```ruby
gateway = Loqate::Gateway.new(api_key: '<YOUR_API_KEY>')
```

Every call to a gateway method will return a `Loqate::Result` object, which will respond to `success?` and `failure?`.

### Address API

The Address API consists of two main API requests:
[Find](https://www.loqate.com/resources/support/apis/Capture/Interactive/Find/1/) request is used to narrow down a
possible list of addresses;
and a [Retrieve](https://www.loqate.com/resources/support/apis/Capture/Interactive/Retrieve/1/) request is used to
retrieve a fully formatted address.

A typical address search is made up of a series of `find` requests, followed by a `retrieve` based on the user
selection.

#### Finding addresses

```ruby
result = gateway.address.find(text: 'EC1Y 8AF', country: 'GB', limit: 5)

result.success? # => true
result.failure? # => false

addresses = result.value
addresses.first.id # => 'GB|RM|B|8144611'
```

#### Retrieving the details of an address

```ruby
result = gateway.address.retrieve(id: 'GB|RM|B|8144611')

result.success? # => true
result.failure? # => false

address = result.value
address.city        # 'London' 
address.line1       # '148 Warner Road'
address.postal_code # 'E17 7EA'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies, configure git hooks and create support files.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Then add your Loqate API key to `.api_key`. It will be used by RSpec and VCR, but not stored in the codebase. 

The health and maintainability of the codebase is ensured through a set of
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

Bug reports and pull requests are welcome on GitHub at https://github.com/wilsonsilva/loqate.
