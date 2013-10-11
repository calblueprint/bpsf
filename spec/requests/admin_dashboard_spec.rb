# Tests for the admin dashboard
require 'spec_helper'

describe 'The admin dashboard' do
  subject { page }
  let(:admin) { FactoryGirl.create :admin }
  before do
    sign_in admin
    visit admin_dashboard_path
  end

  describe 'grants listing' do
    before do
      let!(:grant1) { FactoryGirl.create :grant }
      let!(:grant2) { FactoryGirl.create :grant }
    end

    it { should have_content 'Pending' }
    [grant1, grant2].each do |g|
      page.should have_content g.title
    end
  end

  describe 'toggling grant fields' do
    let!(:grant) { FactoryGirl.create :grant }

    describe 'the complete field' do
      before { click_link 'Complete' }

      it { should have_content 'Complete' }
      it { should_not have_content 'Pending' }
    end

    describe 'the crowdsource field' do
      before { click_link 'Crowdsource' }

      it { should have_content 'Crowdsourcing' }
      it { should_not have_content 'Pending' }
    end

    describe 'the rejected field' do
      before { click_link 'Reject' }

      it { should have_content 'Reject' }
      it { should_not have_content 'Pending' }
    end
  end

end

describe 'Dashboard authorization' do

  subject { page }

  describe 'for non-logged in users' do
    before { visit admin_dashboard_path }
    it { should have_error_message 'not authorized' }
  end

  describe 'for regular users' do
    let(:user) { FactoryGirl.create :user }
    before do
      sign_in user
      visit admin_dashboard_path
    end
    it { should have_error_message 'not authorized' }
  end

  describe 'for recipients' do
    let(:recipient) { FactoryGirl.create :recipient }
    before do
      sign_in recipient
      visit admin_dashboard_path
    end
    it { should have_error_message 'not authorized' }
  end

  describe 'for admins' do
    let(:admin) { FactoryGirl.create :admin }
    before do
      sign_in admin
      visit admin_dashboard_path
    end
    it { should_not have_error_message 'not authorized' }
    it { should have_h1 'Dashboard' }
  end
end