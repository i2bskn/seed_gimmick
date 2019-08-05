# SeedGimmick

Database bootstrapping utilities for Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'seed_gimmick'
```

And then execute:

    $ bundle

## Usage

### Generate configuration file and default seed directory

Run generator of Rails.  
Configuration file created to `config/seed_gimmick.yml`.

```
$ bundle exec rails generate seed_gimmick:install
      create  db/seed_gimmick/.keep
      create  config/seed_gimmick.yml
```

### Rake tasks

#### Apply fixtures

Read fixtures from seed directory and apply to database.  
All fixtures applied if not specified tables.

```
$ [TABLES=table_name,table_name] bundle exec rake db:seed_gimmick
```

#### Dump fixtures

Dump to fixture file from database in seed directory.

```
$ MODELS=ModelName,ModelName [FORMAT=csv] bundle exec rake db:seed_gimmick:dump
```

#### Diff

Display the database and seed difference.

```
$ bundle exec rake seed_gimmick:diff
```

## Contributing

1. Fork it ( https://github.com/i2bskn/seed_gimmick/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
