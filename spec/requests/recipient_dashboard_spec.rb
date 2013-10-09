# Tests for the recipient dashboard
require 'spec_helper'

describe "The recipient dashboard" do

  subject { page }

  let(:recipient) { FactoryGirl.create :recipient }
  let!(:grant1) { FactoryGirl.create :grant }
  let!(:grant2) { FactoryGirl.create :grant }

  before do
    sign_in recipient
    visit recipient_path
  end

  it 'should list my grants' do
    [grant1, grant2].each do |g|
      page.should have_content g.title
    end
  end

end

describe "Dashboard authorization" do

  subject { page }

  describe 'for non-logged in users' do
    before { visit recipient_path }
    it { should have_error_message 'not authorized' }
  end

  describe 'for regular users' do
    let(:user) { FactoryGirl.create :user }
    before do
      sign_in user
      visit recipient_path
    end
    it { should have_error_message 'not authorized' }
  end

  describe 'for admins' do
    let(:admin) { FactoryGirl.create :admin }
    before do
      sign_in admin
      visit recipient_path
    end
    it { should have_error_message 'not authorized' }
  end

  describe 'for recipients' do
    let(:recipient) { FactoryGirl.create :recipient }
    before do
      sign_in recipient
      visit recipient_path
    end
    it { should_not have_error_message 'not authorized' }
    it { should have_h1 'Dashboard' }
  end
  
end
