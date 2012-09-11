require 'spec_helper'

describe Bulky do

  describe ".update" do
    it "will enqueue a Bulky::Update with the class and updates for each id provided" do
      updates = {"company" => "Adam Inc."}
      Resque.should_receive(:enqueue).with(Bulky::Updater, 'Account', 10, updates)
      Resque.should_receive(:enqueue).with(Bulky::Updater, 'Account', 25, updates)
      Bulky.enqueue_update(Account, [10,25], updates)
    end
  end

  describe ".parse_ids" do
    array = %w[1 2 3 4]
    [
      "1\n2\n3\n4",
      "1\n2\n3\n4\n\n",
      "\n\n1\n\n2\n3\n4\n\n",
      "1,2,3,4",
      "\n1\n,\n2,\n3\n4\n\n,,"
    ].each do |example|
      it "can parse #{example.inspect} into #{array.inspect}" do
        Bulky.parse_ids(example).should eq(array)
      end
    end
  end

end
