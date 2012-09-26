require 'spec_helper'

describe Bulky::UpdatesController do
  describe "#edit" do
    it "renders" do
      get '/bulky/accounts/edit'
      response.should be_ok
    end
  end
  
  describe "#update" do
    let(:a1) { Account.create! business: "TMA" }
    let(:a2) { Account.create! business: "Adam Incorporated" }
    let(:a3) { Account.create! business: "Ambers Accounting LLC" }
    let(:size) { Resque.size(Bulky::Updater::QUEUE) }

    it { expect(size).to be_zero }

    it "queues bulk updates" do
      put '/bulky/accounts', ids: "#{a1.id}\n#{a2.id},#{a3.id}\n\n,", bulk: {business: 'Awesome-o-tron'}
      size.should eq(3)
    end

    it "sets the flash to a success message on success" do
      put '/bulky/accounts', ids: "#{a1.id}\n#{a2.id},#{a3.id}\n\n,", bulk: {business: 'Awesome-o-tron'}
      flash[:notice].should eq(I18n.t('flash.notice.enqueue_update'))
    end

    it "will redirect to the edit page if :ids is blank" do
      put '/bulky/accounts'
      response.should redirect_to(bulky_edit_path)
    end

    it "will redirect to the edit page unless :bulk is a hash" do
      put '/bulky/accounts', ids: "1,2,3"
      response.should redirect_to(bulky_edit_path)
    end

    it "sets the flash to an error about blank ids" do
      put '/bulky/accounts'
      flash[:alert].should eq(I18n.t('flash.alert.blank_ids'))
    end

    it "sets the flash to an error about bulk not being a hash" do
      put '/bulky/accounts', ids: "1,2,3"
      flash[:alert].should eq(I18n.t('flash.alert.bulk_not_hash'))
    end

    it "does not bulk update values to blank" do
      put '/bulky/accounts', ids: [a1,a2,a3].map(&:id).join(','), bulk: {business: '', contact: 'Woot Bot'}
      3.times { process_bulky_queue_item }
      a1.reload
      a1.contact.should eq('Woot Bot')
      a1.business.should eq('TMA')
    end
  end
end

