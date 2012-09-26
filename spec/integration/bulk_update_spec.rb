require 'spec_helper'
require 'rake'

describe "Bulk Updates" do

  let(:accounts) do
    Account.create! business: "TMA"
    Account.create! business: "Adam Incorporated"
    Account.create! business: "Ambers Accounting LLC"
    Account.all
  end

  describe "Bulky.enqueue_update" do
    it "will bulk update all the accounts" do
      Bulky.enqueue_update(Account, accounts.map(&:id), {"contact" => "Awesome-o-tron"})
      3.times { process_bulky_queue_item }
      Account.all.map(&:contact).uniq.should eq(['Awesome-o-tron'])
    end
  end

end
