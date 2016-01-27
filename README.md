# HasArchive

This project was born out of frustration with all the options I've found so far for archiving non-current ActiveRecord backed models, so I'm going to give it a go. The initial target will be Rails 4 (point two-ish) on Postgres, and if it goes somewhere, I will begin looking at what else we can support.

[![Gem Version](https://badge.fury.io/rb/has_archive.svg)](https://badge.fury.io/rb/has_archive)

Please halp. This is far from ready, but if this seems like a useful/worthwhile project to you, please feel free to dig and lend a hand.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_archive'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_archive

## Usage

### Setup

1. First, create your archive tables for any models you wish to make archivable. There is a utility method (`HasArchive::MigrationManager.create_archive_for`) to help generate the starting migrations. It must match the columns for the archivable model, plus add an `archived_at` datetime field.

2. Call `has_archive` in your models.

### Archive Controls

Access the archive model directly with `ModelName::Archive`, or use the class method `archived` to union live and archived records.

Archive a record by calling `archive` on it. Optionally, `destroy` may be overridden to work as a "soft delete" by setting `Rails.configuration.has_archive.override_destroy` to `true`.

An archived record may be returned to the main table by calling `restore` on it.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/matt-morris/has_archive.
