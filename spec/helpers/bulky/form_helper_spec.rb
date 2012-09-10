require 'spec_helper'

describe Bulky::FormHelper do

  describe "whitelisted_attributes_collection" do
    let(:collection) { helper.whitelisted_attributes_collection(Account) }
    let(:option_value) { collection.first[1] }
    let(:html_value) { collection.first[0] }

    it "creates a list of attributes for each whitelisted attribute" do
      collection.length.should eq(Account.accessible_attributes.count - 1)
    end

    it "uses the column name the option" do
      option_value.should eq('business')
    end

    it "uses a titleized column name for the text" do
      html_value.should eq('Business')
    end
  end

end
