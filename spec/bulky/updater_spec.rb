RSpec.describe Bulky::Updater do
  let(:account)     { Account.create! { |a| a.business = 'Higher Inc.' } }

  describe "logging updating a model" do
    let(:bulk_update) { 
      Bulky::BulkUpdate.create! { |b| 
        b.ids     = [1, 2]
        b.updates = {"business" => "Fallen Corp"} 
      }
    }
    let(:updater) { Bulky::Updater.new(account, bulk_update.id) }
    let(:log)     { updater.update!; Bulky::UpdatedRecord.last }

    it "logs the model class that will be updated" do
      log.updatable_type.should eq('Account')
    end

    it "logs the model id that will be updated" do
      log.updatable_id.should eq(account.id)
    end

    it "logs the changes to the model that will happen" do
      log.updatable_changes.should eq('business' => ['Higher Inc.', 'Fallen Corp'])
    end
  end

  describe "setting attributes" do
    let(:attrs) { {"business" => "Adam Inc"} }
    let(:bulk)  { Bulky::BulkUpdate.new { |b| 
      b.updates = attrs } }

    it "will update the attributes on the instance with the given updates" do
      expect(account).to receive(:attributes=).with(attrs)
      allow(Bulky::BulkUpdate).to receive(:find).with(5).and_return(bulk)
      Bulky::Updater.new(account, 5).update!
    end
  end

  describe "bulky attributes" do
    let(:bulk_update) { 
      Bulky::BulkUpdate.create! { |b| b.ids = [1]; b.updates = {"id" => 10} } }
    let(:updater)     { Bulky::Updater.new(account, bulk_update.id) }

    it "only passes through bulky_attributes as permitted" do
      expect(updater.updates).not_to have_key('id')
    end
  end

  describe "that has errors" do
    let(:bulk_update) { 
      Bulky::BulkUpdate.create! { |b|
        b.ids = [1,2]; b.updates = {"business" => ''} } }
    let(:updater)     { Bulky::Updater.new(account, bulk_update.id) }
    let(:log)         { Bulky::UpdatedRecord.last }

    it "logs any errors that happen when saving the model" do
      updater.update! rescue nil
      log.error_message.should eq("Validation failed: Business can't be blank")
    end

    it "reraises any errors that happen when saving the model" do
      expect { updater.update! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

end
