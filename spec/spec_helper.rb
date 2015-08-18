ENV['RAILS_ENV']   = 'test'
ENV['BULKY_QUEUE'] = 'bulky_test'

require File.expand_path("../dummy/config/application.rb",  __FILE__)
require 'rails/test_help'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'database_cleaner'
require 'pry'
require 'sidekiq/api'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.run_all_when_everything_filtered = true
  config.order = :random
  config.filter_run :focus

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    bulky_queue.clear
  end

end

def bulky_queue
  @bulky_queue ||= Sidekiq::Queue.new(Bulky::Worker::QUEUE)
end

def process_bulky_queue_item
  job = bulky_queue.first
  job.class.new.perform(*job.args)
end
