# basic
basic puppet module for managing many defined types

## [Deprecated] - 2020-01-12

- Functionality roled in to the new and more flexible 'types' module

## [0.4.0] - 2019-08-23
### Rewrite
- New 'basic::type' defined type replaces the legacy 'create_resources()' with
iteration and abstract resource types.

## [0.3.0] - 2019-06-29
### Added
- Support for 'archive' type as provided by puppet/archive
- Added support for 'notify', 'stage', and 'schedule' types using module
parameters 'notifications', 'stages', and 'schedules', respectively.

## [0.2.1] - 2019-06-26
### Documentation
- Corrected hiera data in the README example for the iptables_restore resource

## [0.2.0] - 2019-06-24
### Added
- New type 'binary' for creating binary files from base64 encoded data

## [0.1.0] - 2019-06-23
- Initial release, supporting native puppet 5.5 types and the file_line type as
provided by puppetlabs/stdlib

