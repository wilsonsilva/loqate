# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

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

[0.7.0]: https://github.com/wilsonsilva/loqate/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/wilsonsilva/loqate/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/wilsonsilva/loqate/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/wilsonsilva/loqate/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/wilsonsilva/loqate/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/wilsonsilva/loqate/compare/v0.1.0...v0.2.0
