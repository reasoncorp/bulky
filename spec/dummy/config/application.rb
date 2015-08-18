ENV['BUNDLE_GEMFILE'] = File.expand_path('../../../../Gemfile', __FILE__)

require 'rubygems'
require 'bundler'

Bundler.setup

$:.unshift File.expand_path('../../../../lib', __FILE__)

# for everything: require "rails/all"
require "action_controller/railtie"
require "active_record/railtie"

Bundler.require

# controllers
ApplicationController = Class.new(ActionController::Base) do
  protect_from_forgery with: :exception
end

# models
class Account < ActiveRecord::Base
  extend Bulky::Model
  bulky :business, :contact, :last_contracted_on

  validates :business, presence: true
end

require 'sqlite3'
require 'bulky'

module Dummy
  class Application < ::Rails::Application
    config.cache_classes = true
    config.active_support.deprecation = :stderr
    config.secret_token = 'http://s3-ec.buzzfed.com/static/enhanced/webdr03/2013/5/25/8/anigif_enhanced-buzz-11857-1369483324-0.gif'
    config.eager_load = false
  end
end

Dummy::Application.initialize!

