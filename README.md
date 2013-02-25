# Bulky

Bulky is a Rails engine that allows you to create background bulk update jobs for your models and provides an administrative interface to view job status.  

To process bulk updates, a bulk update job is saved to the database and passed to Resque. Resque then queues a job for each of the records contained in the bulk update. Resque workers then process the queued updates in the background. All model validations and callbacks are handled normally and a flash notice will be displayed in the host application when all updates have been processed.

Note that there are inherent security risks involved with bulk updating your models. Users with rights to perform bulk updates should be allowed explicitly and all others blocked.

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

Remember to set attr_accessible on each attribute of the model you wish to update 'en masse'.

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
