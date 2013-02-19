require 'spec_helper'


describe 'bulky:form_installer' do
  context "with no arguments or options" do
    it "should generate a help message" do
      subject.should output("No value provided for required arguments 'model_name'")
    end
  end

  with_args Account do

    before :each do
      FileUtils.rm_rf("spec/dummy/app/views/bulky/updates/edit_account.html.erb")
    end

    it "should generate a edit_account form" do
      subject.should generate(:create_file)
    end 
  end
end
