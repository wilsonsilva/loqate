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

### Bang methods

Most methods have a bang and a non-bang version (e.g. `gateway.address.find` and `gateway.address.find!`).
The non-bang version will either return a `Loqate::Success` or an `Loqate::Failure`. The bang version will
either return the desired resource, or it will raise an exception.

#### Example of using non-bang method

```ruby
result = gateway.address.find(text: 'EC1Y 8AF', country: 'GB', limit: 5)

if result.success?
  addresses = result.value
  addresses.first.id # => 'GB|RM|B|8144611'
else
  error = result.error
  puts "Error retrieving the address: #{error.description}. Resolution: #{error.resolution}"
end

result.failure? # => false
```

#### Example of using bang method

```ruby
begin
  addresses = gateway.address.find!(text: 'EC1Y 8AF', country: 'GB', limit: 5)
  addresses.first.id # => 'GB|RM|B|8144611'
rescue Loqate::Error => e
  puts "Error retrieving the address: #{e.description}. Resolution: #{e.resolution}"
end
```

It is recommended that you use the bang methods when you assume that the data is valid and do not expect validations
to fail. Otherwise, use the non-bang methods.

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

addresses = result.value
addresses.first.id # => 'GB|RM|B|8144611'
```

#### Retrieving the details of an address

```ruby
result = gateway.address.retrieve(id: 'GB|RM|B|8144611')

address = result.value
address.city           # 'London' 
address.line1          # '148 Warner Road'
address.postal_code    # 'E17 7EA'
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

## License

See [LICENSE](https://github.com/wilsonsilva/loqate/blob/master/LICENSE).
