require 'spec_helper'
require 'rake'

describe "Bulk Updates" do

  let(:accounts) do
    Account.create! business: "TMA"
    Account.create! business: "Adam Incorporated"
    Account.create! business: "Ambers Accounting LLC"
    Account.all
  end

  describe "Bulky.update" do
    it "will bulk update all the accounts" do
      Bulky.update(Account, accounts.map(&:id), {"contact" => "Awesome-o-tron"})
      3.times do
        klass, args = Resque.reserve(:bulky_updates)
        klass.perform(*args)
      end
      Account.all.map(&:contact).uniq.should eq(['Awesome-o-tron'])
    end
  end

  describe "Bulky::UpdatesController" do
    describe "#edit" do
      it "renders" do
        get '/bulky/accounts/edit'
        response.should be_ok
      end
    end
    
    describe "#update" do
      it "queues bulk updates"
      it "will redirect to the edit page if :ids is blank"
      it "will redirect to the edit page unless :bulk is a hash"
    end
  end

end
