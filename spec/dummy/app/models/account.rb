class Account < ActiveRecord::Base

  extend Bulky::Model
  bulky :business, :contact, :last_contracted_on

  validates :business, presence: true
  # attr_accessible :business, :contact, :last_contacted_on
  
end
