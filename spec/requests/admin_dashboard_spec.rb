# Tests for the admin dashboard
require 'spec_helper'
require 'pry'

describe 'The admin dashboard' do
  subject { page }
  let(:admin) { FactoryGirl.create :super_user }

  before do
    sign_in admin
    visit admin_dashboard_path
  end

  it { should have_content 'Admin Dashboard' }

  describe 'grants listing' do
    let!(:grant1) { FactoryGirl.create :grant }
    let!(:grant2) { FactoryGirl.create :grant }

    before { visit admin_dashboard_path }

    it { should have_content 'Pending' }
    it 'should list all grants' do
      [grant1, grant2].each do |g|
        page.should have_link g.title
      end
    end
  end

  describe 'grant status links' do
    let!(:grant) { FactoryGirl.create :grant }
    before do
      visit admin_dashboard_path
      click_link grant.title
    end

    it { should have_link 'Reject' }
    it { should have_link 'Fund' }
    it { should have_link 'Crowdfund' }
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
    it { should have_h2 'Dashboard' }
  end
end