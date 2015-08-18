# Bulky

[![Circle CI](https://circleci.com/gh/tma1/bulky.svg?style=svg)](https://circleci.com/gh/tma1/bulky)

## Installation

In your Gemfile
``` ruby
  gem 'bulky', github: 'tma1/bulky'
```

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
