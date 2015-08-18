RSpec.describe Bulky::Worker do

  it "uses a test queue" do
    expect(Bulky::Worker::QUEUE).to eq('bulky_test')
  end

  it "gets the queue name from the environment" do
    expect(Bulky::Worker::QUEUE).to eq ENV.fetch('BULKY_QUEUE')
  end

  describe "#perform" do 
    let(:account) { Account.new }
    let(:worker)  { Bulky::Worker.new }
    let(:updater) { double(update!: true) }

    before :each do
      allow(Account).to receive(:find).with(1).and_return(account)
      allow(Bulky::Updater).to receive(:new).and_return(updater)
    end

    it "will find the class it is supposed to update" do
      klass = "Account"
      expect(klass).to receive(:constantize).and_return(Account)
      worker.perform(klass, 1, 5)
    end

    it "will find the instance it is supposed to update" do
      klass = "Account"
      allow(klass).to receive(:constantize).and_return(Account)
      expect(Account).to receive(:find).with(1)
      worker.perform(klass, 1, 5)
    end

    it "will pass the instance and bulk_update_id to the updater" do
      klass = "Account"
      allow(klass).to receive(:constantize).and_return(Account)
      allow(Account).to receive(:find).with(1).and_return(account)
      expect(Bulky::Updater).to receive(:new).with(account, 5).and_return(updater)
      worker.perform(klass, 1, 5)
    end
  end

end
