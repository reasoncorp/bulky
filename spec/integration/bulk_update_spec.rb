require 'spec_helper'
require 'rake'

describe "Bulk Updates" do

  let(:accounts) do
    Account.create! business: "TMA"
    Account.create! business: "Adam Incorporated"
    Account.create! business: "Ambers Accounting LLC"
    Account.all
  end

  it "will bulk update all the accounts" do
    Bulky.update(Account, accounts.map(&:id), {"contact" => "Awesome-o-tron"})
    3.times do
      klass, args = Resque.reserve(:bulky_updates)
      klass.perform(*args)
    end
    Account.all.map(&:contact).uniq.should eq(['Awesome-o-tron'])
  end

end
