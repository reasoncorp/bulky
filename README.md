# Bulky

Bulky is a Rails engine that allows you to create background bulk update jobs for your models and provides an administrative interface to view job status. Flash notices are displayed in the host application when jobs are completed. 

## Installation

In your Gemfile
``` ruby
  gem 'bulky', github: 'adamhunter/bulky'
```

Then in your shell prompt
```bash
  bundle
  rake bulky_engine:install:migrations
  rake db:migrate
  rake bulky:work # (starts the resque worker for bulky)
```

## Views

Bulky requires that you customize a form for making a bulk update. To get a quick start, provide the model you wish to update in bulk as an argument to the form generator provided. The generated form will require customization to fit your project's needs.

```ruby
  #app/views/bulky/updates/edit_account.html.erb
  rails g bulky:form_installer Account
``` 


## Usage

Application
Add a form in `app/views/bulky/updates/edit.html.haml` to override the one provided.


Command Line
```ruby
  #                    model,   ids,     arguments for update_attributes!
  Bulky.enqueue_update(Account, [10,25], {"contact" => "Yes, please."})
```

This will enqueue the `Bulky::Updater` to update each account when the job is processed by Resque
