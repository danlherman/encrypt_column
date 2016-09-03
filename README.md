[![Gem Version](https://badge.fury.io/rb/encrypt_column.svg)](https://badge.fury.io/rb/encrypt_column)
[![Build Status](https://travis-ci.org/danlherman/encrypt_column.svg?branch=master)](https://travis-ci.org/danlherman/encrypt_column)
[![Coverage Status](https://coveralls.io/repos/github/danlherman/encrypt_column/badge.svg?branch=master)](https://coveralls.io/github/danlherman/encrypt_column?branch=master)
[![Issue Count](https://codeclimate.com/github/danlherman/encrypt_column/badges/issue_count.svg)](https://codeclimate.com/github/danlherman/encrypt_column)

# EncryptColumn

Encrypt any column with an optional hash (using searchable: true) or conditionally (if: Proc)
also has a failsafe (failsafe: true) feature to write to different db column in
the database, i.e. `<name>_ciphertext`. This prevents users from accidentally
commenting out the encrypt declaration and writing plaintext to the database.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'encrypt_column'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install encrypt_column

## Usage

Specify the column to be encrypted as so (i.e. encrypt ssn column):
```ruby
  encrypt :ssn
```

To add a `<Model>.with_<field_name>(<field_value>)` search method (using a hash column named `<column_name>_hash` or `ssn_hash`)
```ruby
  encrypt :ssn, searchable: true

Usage like so:

  SecureTable.with_ssn('123456789')
```

To use a failsafe column name to prevent accidental removal of encryption specify "failsafe: true". This will store the data in a column name `<column_name>_ciphertext` (i.e. `ssn_ciphertext`) but allow for read/write access by the original column name.
```ruby
  encrypt :ssn, failsafe: true
```

To conditionally encrypt a column you can specify an if statement like so:
```ruby
  encrypt :card_number,  if: -> (x) { x.card_type == 'credit' }
```

Use all the options combined, like so:
```ruby
  encrypt :card_number, searchable: true, failsafe: true, if -> (x) { x.card_type == 'credit' }
```

The gem uses the ENCRYPTION_KEY environment variable for encryption setup:
```
  ENV['ENCRYPTION_KEY'] = 'your_encryption_key_goes_here'
```
Alternatively, you can specify the encryption key as an option in the encrypt line:
```
  encrypt :ssn, key: 'your_encryption_key_goes_here'
```

and optionally a HASH_SALT if the searchable option is used.
```
  ENV['HASH_SALT'] = 'some_salt'
```
Or specify the hash salt in the encrypt line:
```
  encrypt :ssn, :searchable, hash_salt: 'your_hash_salt_goes_here', key: 'your_encryption_key_goes_here'
```


After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danlherman/encrypt_column.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

