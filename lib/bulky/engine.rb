require 'haml'
require 'resque'

module Bulky
  class Engine < ::Rails::Engine
    initializer "bulky.engine.queue_name" do |app|
      Bulky::Updater::QUEUE = :"#{app.class.parent_name.underscore}_bulky_updates"
      Bulky::Updater.instance_variable_set(:@queue, Bulky::Updater::QUEUE)
    end

    initializer "bulky.notifier" do |app|
      ApplicationController.send :include, Bulky::Notifier
    end
  end
end
