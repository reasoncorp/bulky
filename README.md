# Bulky

## Installation

## Usage

```ruby
  Bulky.update(Account, [10,25], {"contact" => "Yes, please."})
```

This will enqueue the `Bulky::Updater` to update each account when the job is processed by Resque

