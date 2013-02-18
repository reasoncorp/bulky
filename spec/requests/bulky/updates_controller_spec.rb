require 'spec_helper'

describe Bulky::UpdatesController do
  describe "index and show actions" do
    
    before :each do
      Bulky::BulkUpdate.destroy_all
      FactoryGirl.create(:bulky_bulk_update_with_bulky_updated_records)
    end

    describe "#index" do
      let(:update) { Bulky::BulkUpdate.first }

      it "responds ok" do
        get "/bulky"
        expect(response).to be_ok
      end

      it "shows a table of all bulk update jobs" do
        get "/bulky"
        expect(response.body).to have_selector('table')
      end

      it "should have a flash message when notifications need to be displayed" do
        get "/bulky"
        expect(response.body).to have_content('Bulk Update Notifications')
      end

    end
    describe "#show" do
      let(:update) { Bulky::BulkUpdate.first }

      it "responds ok" do
        get "/bulky/#{update.id}"
        expect(response).to be_ok
      end

      it "has displays a table of updated records" do
        get "/bulky/#{update.id}"
        expect(response.body).to have_selector('table')
      end
    end
  end

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

