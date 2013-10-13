# Tests for the recipient dashboard
require 'spec_helper'

describe "The recipient dashboard" do

  subject { page }

  let(:recipient) { FactoryGirl.create :recipient }
  let!(:grant1) { FactoryGirl.create(:grant,recipient_id: recipient.id) }
  let!(:grant2) { FactoryGirl.create(:grant,recipient_id: recipient.id) }

  before { sign_in recipient }

  it 'should list my grants' do
    [grant1, grant2].each do |g|
      page.should have_content g.title
    end
  end

end

describe "Dashboard authorization" do

  subject { page }

  describe 'for non-logged in users' do
    before { visit recipient_dashboard_path }
    it { should have_error_message "You are not authorized to access this page." }
  end

  describe 'for regular users' do
    let(:user) { FactoryGirl.create :user }
    before do
      sign_in user
      visit recipient_dashboard_path
    end
    it { should have_error_message "You are not authorized to access this page." }
  end

  describe 'for admins' do
    let(:admin) { FactoryGirl.create :admin }
    before do
      sign_in admin
      visit recipient_dashboard_path
    end
    it { should have_error_message "You are not authorized to access this page." }
  end

  describe 'for recipients' do
    let(:recipient) { FactoryGirl.create :recipient }
    before do
      sign_in recipient
      visit recipient_dashboard_path
    end
    it { should_not have_error_message "You are not authorized to access this page." }
    it { should have_h1 'Dashboard' }
  end
  
end
