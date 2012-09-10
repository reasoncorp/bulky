class Account < ActiveRecord::Base
  validates :business, presence: true
  attr_accessible :business, :contact, :last_contacted_on
end
