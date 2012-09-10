require 'spec_helper'

describe Bulky do

  describe ".update" do
    it "will enqueue a Bulky::Update with the class and updates for each id provided" do
      updates = {"company" => "Adam Inc."}
      Resque.should_receive(:enqueue).with(Bulky::Updater, 'Account', 10, updates)
      Resque.should_receive(:enqueue).with(Bulky::Updater, 'Account', 25, updates)
      Bulky.update(Account, [10,25], updates)
    end
  end

end
