require 'spec_helper'

describe Bulky::UpdatesController do
  describe "#edit" do
    it "renders" do
      get '/bulky/accounts/edit'
      expect(response).to be_ok
    end
  end
  
  describe "#update" do
    let(:a1) { Account.create! business: "TMA" }
    let(:a2) { Account.create! business: "Adam Incorporated" }
    let(:a3) { Account.create! business: "Ambers Accounting LLC" }
    let(:size) { bulky_queue.size }

    it { expect(size).to be_zero }

    it "queues bulk updates" do
      put '/bulky/accounts', ids: "#{a1.id}\n#{a2.id},#{a3.id}\n\n,", bulk: {business: 'Awesome-o-tron'}
      expect(size).to eq(3)
    end

    it "sets the flash to a success message on success" do
      put '/bulky/accounts', ids: "#{a1.id}\n#{a2.id},#{a3.id}\n\n,", bulk: {business: 'Awesome-o-tron'}
      expect(flash[:notice]).to eq(I18n.t('flash.notice.enqueue_update'))
    end

    it "will redirect to the edit page if :ids is blank" do
      put '/bulky/accounts'
      expect(response).to redirect_to(bulky_edit_path)
    end

    it "will redirect to the edit page unless :bulk is a hash" do
      put '/bulky/accounts', ids: "1,2,3"
      expect(response).to redirect_to(bulky_edit_path)
    end

    it "sets the flash to an error about blank ids" do
      put '/bulky/accounts'
      expect(flash[:alert]).to eq(I18n.t('flash.alert.blank_ids'))
    end

    it "sets the flash to an error about bulk not being a hash" do
      put '/bulky/accounts', ids: "1,2,3"
      expect(flash[:alert]).to eq(I18n.t('flash.alert.bulk_not_hash'))
    end

    it "does not bulk update values to blank" do
      put '/bulky/accounts', ids: [a1,a2,a3].map(&:id).join(','), bulk: {business: '', contact: 'Woot Bot'}
      # binding.pry
      3.times { process_bulky_queue_item }
      a1.reload
      expect(a1.contact).to eq('Woot Bot')
      expect(a1.business).to eq('TMA')
    end
  end
end

