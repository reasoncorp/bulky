# Bulky

[![Circle CI](https://circleci.com/gh/tma1/bulky.svg?style=svg)](https://circleci.com/gh/tma1/bulky)

## Installation

In your Gemfile use one of the following
``` ruby
  gem 'bulky', '~> 2.0.0'
  # or
  gem 'bulky', github: 'tma1/bulky'
  # or in bash run
  git submodule add git@github.com:tma1/bulky.git vendor/bulky
  # then add to your gemfile
  gem 'bulky', path: 'vendor/bulky'
  # users add a submodule (aka path...) need to run
  git submodule init --update
```
```bash
```
Then edit your 

Then in your shell prompt
```bash
  bundle
  rake bulky_engine:install:migrations
  rake db:migrate
  sidekiq
```

## Usage

Application
Add a form in `app/views/bulky/updates/edit.html.haml` to override the one provided.


Command Line
```ruby
  #                    model,   ids,     arguments for update_attributes!
  Bulky.enqueue_update(Account, [10,25], {"contact" => "Yes, please."})
```

This will enqueue the `Bulky::Updater` to update each account when the job is
processed by Sidekiq
