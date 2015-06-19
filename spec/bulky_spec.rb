require 'spec_helper'

describe Bulky do

  let(:ids) { [10,25] }
  let(:updates) { {"company" => "Awesome-O Inc."} }

  describe ".enqueue_update" do
    before :each do 
      Bulky.stub(:log_bulk_update).and_return(double('BulkUpdate', id: 5, updates: updates))
    end

    it "will enqueue a Bulky::Update with the class and updates for each id provided" do
      Resque.should_receive(:enqueue).with(Bulky::Updater, 'Account', 10, 5)
      Resque.should_receive(:enqueue).with(Bulky::Updater, 'Account', 25, 5)
      Bulky.enqueue_update(Account, ids, updates)
    end

    it "will log that it has started a bulk update" do
      Bulky.should_receive(:log_bulk_update).with([10,25], updates)
      Resque.stub(:enqueue)
      Bulky.enqueue_update(Account, ids, updates)
    end
  end

  describe ".parse_ids" do
    array = %w[1 2 3 4]
    [
      "1\n2\n3\n4",
      "1\n2\n3\n4\n\n",
      "\n\n1\n\n2\n3\n4\n\n",
      "1,2,3,4",
      "\n1\n,\n2,\n3\n4\n\n,,",
      "\n1\n,\n2 ,\n3, 4 \n\n,,"
    ].each do |example|
      it "can parse #{example.inspect} into #{array.inspect}" do
        Bulky.parse_ids(example).should eq(array)
      end
    end
  end

  describe ".log_bulk_update" do
    let(:log) { Bulky.log_bulk_update(ids, updates) }

    it "creates a bulk update entry" do
      log.should be_persisted
    end

    it "creates a bulk update entry with the given ids" do
      log.ids.should eq(ids)
    end

    it "creates a bulk update entry with the given updates" do
      log.updates.should eq(updates)
    end
  end

end
