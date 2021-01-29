# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.11.0] - 2021-01-29
## Changed
- Updated `bundler` to version `2.1`
- Updated `guard` to version `2.16`
- Updated `guard-bundler` to version `3.0`
- Updated `guard-rubocop` to version `1.3`
- Updated `overcommit` to version `0.53`
- Updated `pry` to version `0.13`
- Updated `rubocop` to version `0.85`
- Updated `rubocop-rspec` to version `1.39`
- Updated `simplecov-console` to version `0.7`
- Updated `vcr` to version `6.0`
- Updated `webmock` to version `3.8`
- Enabled the newest RuboCop rules
- Set the local development Ruby version to 2.7.1

## Removed
- Removed the attribute `is_complainer_or_fraud_risk` from `EmailValidation`. It is no longer supported by Loqate's API
and will always return `false`.

## Fixed
- Fixed the type coercion of the attribute `duration` on the `EmailValidation` class:
```
[Loqate::Email::EmailValidation.new] 0 (Integer) has invalid type for :duration violates
  constraints (type?(Float, 0) failed)
```

## [0.10.4] - 2020-05-08
### Changed
- Updated `HTTP` to version `4.3`
- Updated `Rake` to version `12.3`

### Fixed
- Fixed an [incompatibility with Ruby 2.7](https://github.com/httprb/http/issues/582)

## [0.10.3] - 2020-01-13
### Changed
- Updated Rubocop to version `0.78`
- Fixed the keyword arguments deprecation warning introduced in Ruby `2.7`

## Added
- Added additional build versions (`2.5`, `2.6`, `2.7` and `jruby`) on Travis CI

## [0.10.2] - 2019-12-31
### Changed
- Relaxed the dependency on `bundler` to support Bundler 2.x and later
- Replaced `.ruby-versions` with `.tools-versions` because `asdf` is a modular package manager for all languages
- Set the Ruby development version to `2.6.5`

## Fixed
- Renamed `Dry::Struct::Value` to `Dry::Struct` to fix a deprecation warning
- Renamed `Dry::Types.module` to `Dry.Types()` to fix a deprecation warning

## [0.10.1] - 2019-04-29
### Fixed
- Updated `dry-struct` to version `1.0`, which has a more stable API

## [0.10.0] - 2018-12-12
### Added
- A service to find the nearest places around a given coordinate

### Changed
- Disabled the Yardstick rules `ExampleTag`, `ReturnTag` and `Summary::Presence`.

## [0.9.0] - 2018-12-11
### Added
- Geocoding service of the Geocoding API
- A service to calculate the country a given location is within

## [0.8.0] - 2018-12-10
### Added
- Distance service of the Geocoding API

## [0.7.0] - 2018-12-03
### Changed
- Moved the `Address`, `Email` and `Phone` APIs into their own namespaces

## [0.6.0] - 2018-12-03
### Added
- Bank API

## [0.5.0] - 2018-11-20
### Added
- Email API

## [0.4.0] - 2018-11-14
### Changed
- Updated the gem `HTTP` to version `4.0.0`
- Added the header `Accept: application/json` to every request
- Simplified the Value Objects with Dry-Struct

## Added
- A License (MIT)
- Phone API

## [0.3.0] - 2018-11-10
### Changed
- `address.retrieve` and `address.find` return a single error, not an array with a single item
- `address.retrieve` returns a single address, not an array of addresses
- `Loqate::Error` inherits from `StandardError` so that it can be raised as an exception
- Improved the documentation of `Success` and `Failure`

## Added
- `find!` to find an address or raise an exception
- `retrieve!` to retrieve the details of an address or raise an exception
- Aliased `Failure#value` to `Failure#error`

## Fixed
- Fixed the documentation of `AddressGateway`

## [0.2.0] - 2018-10-31
### Added
- VCR and WebMock to record HTTP interactions
- A file to hold a development API key (`.api_key`)
- A ruby version dotfile (`.ruby-version`)
- Core of the gem
- Address API

### Changed
- Document the available code maintenance Rake tasks.

## [0.1.0] - 2018-09-29
### Added
- Initial core functionality
- Codebase maintenance tools

[0.11.0]: https://github.com/wilsonsilva/loqate/compare/v0.10.4...v0.11.0
[0.10.4]: https://github.com/wilsonsilva/loqate/compare/v0.10.3...v0.10.4
[0.10.3]: https://github.com/wilsonsilva/loqate/compare/v0.10.2...v0.10.3
[0.10.2]: https://github.com/wilsonsilva/loqate/compare/v0.10.1...v0.10.2
[0.10.1]: https://github.com/wilsonsilva/loqate/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/wilsonsilva/loqate/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/wilsonsilva/loqate/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/wilsonsilva/loqate/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/wilsonsilva/loqate/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/wilsonsilva/loqate/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/wilsonsilva/loqate/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/wilsonsilva/loqate/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/wilsonsilva/loqate/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/wilsonsilva/loqate/compare/v0.1.0...v0.2.0
