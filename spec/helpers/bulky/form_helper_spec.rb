require 'spec_helper'

describe Bulky::FormHelper do

  describe "whitelisted_attributes_collection" do
    let(:collection) { helper.whitelisted_attributes_collection(Account) }
    let(:option_value) { collection.first[1] }
    let(:html_value) { collection.first[0] }

    it "creates a list of attributes for each whitelisted attribute" do
      expect(collection.length).to eq(Account.bulky_attributes.count)
    end

    it "uses the column name the option" do
      expect(option_value).to eq('business')
    end

    it "uses a titleized column name for the text" do
      expect(html_value).to eq('Business')
    end
  end

end
