require 'spec_helper'

describe Bulky::BulkUpdate do

  let (:update) { Bulky::BulkUpdate.new }

  it "uses bulky_bulk_updates for its table name" do
    expect(Bulky::BulkUpdate.table_name).to eq('bulky_bulk_updates')
  end

  describe "validation" do
    it "validates presence of ids" do
      update.ids = nil
      update.valid?
      expect(update.errors[:ids]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "has_many updated_records" do
      association = Bulky::BulkUpdate.reflect_on_association(:updated_records)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe "serialization" do
    it "serializes updates as a hash" do
      update.ids = [1]
      update.updates = {foo: 'on you'}
      update.save!
      update.reload
      expect(update.updates).to eq(foo: 'on you')
    end

    it "serializes ids as an array" do
      update.ids = [1,2,3,4]
      update.updates = {foo: 'on you'}
      update.save!
      update.reload
      expect(update.ids).to eq([1,2,3,4])
    end
  end
end
