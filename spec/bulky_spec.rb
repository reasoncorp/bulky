require 'spec_helper'

describe Bulky do

  let(:ids) { [10,25] }
  let(:updates) { {"company" => "Awesome-O Inc."} }

  describe ".enqueue_update" do
    before :each do 
      allow(Bulky).to receive(:log_bulk_update).and_return(
        double('BulkUpdate', id: 5, updates: updates))
    end

    it "will enqueue a Bulky::Update with the class and updates for each id provided" do
      expect(Bulky::Worker).to receive(:perform_async).with('Account', 10, 5)
      expect(Bulky::Worker).to receive(:perform_async).with('Account', 25, 5)
      Bulky.enqueue_update(Account, ids, updates)
    end

    it "will log that it has started a bulk update" do
      expect(Bulky).to receive(:log_bulk_update).with([10,25], updates)
      allow(Bulky::Worker).to receive(:perform_async)
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
        expect(Bulky.parse_ids(example)).to eq(array)
      end
    end
  end

  describe ".log_bulk_update" do
    let(:log) { Bulky.log_bulk_update(ids, updates) }

    it "creates a bulk update entry" do
      expect(log).to be_persisted
    end

    it "creates a bulk update entry with the given ids" do
      expect(log.ids).to eq(ids)
    end

    it "creates a bulk update entry with the given updates" do
      expect(log.updates).to eq(updates)
    end
  end

end
