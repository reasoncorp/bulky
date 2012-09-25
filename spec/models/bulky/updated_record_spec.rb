require 'spec_helper'

describe Bulky::UpdatedRecord do

  let(:record) { Bulky::UpdatedRecord.new }

  it "uses bulky_updated_records for its table name" do
    Bulky::UpdatedRecord.table_name.should eq('bulky_updated_records')
  end

  describe "validations" do
    it "validates presence of bulk_update_id" do
      record.bulk_update_id = nil
      record.valid?
      expect(record.errors[:bulk_update_id]).to include("can't be blank")
    end

    it "validates presence of updatable" do
      record.updatable = nil
      record.valid?
      expect(record.errors[:updatable]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "belongs to a bulk_update" do
      association = Bulky::UpdatedRecord.reflect_on_association(:bulk_update)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to updatedable, polymorphic: true" do
      association = Bulky::UpdatedRecord.reflect_on_association(:updatable)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:polymorphic]).to be_true
    end
  end

  describe "serialization" do
    it "serializes updates as a hash" do
      record.bulk_update_id    = 1
      record.updatable_id      = 1
      record.updatable_type    = 'Account'
      record.updatable_changes = {contact: [nil, 'Awesome-o-tron']}
      record.save(validate: false) # i know updatable can't be blank...
      record.reload
      record.updatable_changes.should eq(contact: [nil, 'Awesome-o-tron'])
    end
  end

end
