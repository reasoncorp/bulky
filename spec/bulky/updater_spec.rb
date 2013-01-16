require 'spec_helper'

describe Bulky::Updater do

  it "has '(application name)_bulky_updates' as its QUEUE" do
    Bulky::Updater::QUEUE.should eq(:dummy_bulky_updates)
  end

  it "uses the QUEUE constant to set the :@queue class instance variable" do
    Bulky::Updater.instance_variable_get(:@queue).should eq(Bulky::Updater::QUEUE)
  end

  describe ".perform" do 
    before :each do
      Account.stub(:find).with(1).and_return(@account = Account.new)
      Bulky::BulkUpdate.stub(:find).with(5).and_return(@bulk = Bulky::BulkUpdate.new)
      Bulky::UpdatedRecord.any_instance.stub(:save!).and_return(true)
      @account.stub!(:save!).and_return(true)
    end

    it "will find the class it is supposed to update" do
      klass = "Account"
      klass.should_receive(:constantize).and_return(Account)
      Bulky::Updater.perform(klass, 1, 5)
    end

    it "will find the instance from the given class and id" do
      Account.should_receive(:find).with(1).and_return(@account)
      Bulky::Updater.perform('Account', 1, 5)
    end

    it "will update the attributes on the instance with the given updates" do
      @account.should_receive(:attributes=).with(updates = {"business" => "Adam Inc"})
      Bulky::BulkUpdate.stub(:find).and_return(@bulk = Bulky::BulkUpdate.new { |b| b.updates = {"business" => "Adam Inc"} })
      Bulky::Updater.perform('Account', 1, 5)
    end
  end

  describe "logging updating a model" do
    let(:account) { Account.create! { |a| a.business = 'Higher Inc.' } }
    let(:bulk_update) { Bulky::BulkUpdate.create! { |b| b.ids = [1,2]; b.updates = {"business" => "Fallen Corp"} } }
    let(:updater) { Bulky::Updater.new(account, bulk_update.id) }
    let(:log) { updater.update!; Bulky::UpdatedRecord.last }

    it "logs the model class that will be updated" do
      log.updatable_type.should eq('Account')
    end

    it "logs the model id that will be updated" do
      log.updatable_id.should eq(account.id)
    end

    it "logs the changes to the model that will happen" do
      log.updatable_changes.should eq('business' => ['Higher Inc.', 'Fallen Corp'])
    end

    describe "that has errors" do
      let(:bulk_update) { Bulky::BulkUpdate.create! { |b| b.ids = [1,2]; b.updates = {"age" => 27} } }
      let(:updater) { Bulky::Updater.new(account, bulk_update.id) }
      let(:log) { Bulky::UpdatedRecord.last }

      it "logs any errors that happen when saving the model" do
        updater.update! rescue nil
        log.error_message.should eq("Can't mass-assign protected attributes: age")
      end

      it "reraises any errors that happen when saving the model" do
        expect { updater.update! }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end

end
