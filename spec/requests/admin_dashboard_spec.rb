# Tests for the admin dashboard
require 'spec_helper'

describe 'The admin dashboard' do
  subject { page }

  describe 'authorization' do
    describe 'for non-logged in users' do
      before { visit admin_path }
      it { should have_error_message 'not authorized' }
    end

    describe 'for regular users' do
      let(:user) { FactoryGirl.create :user }
      before do
        sign_in user
        visit admin_path
      end
      it { should have_error_message 'not authorized' }
    end

    describe 'for recipients' do
      let(:recipient) { FactoryGirl.create :recipient }
      before do
        sign_in recipient
        visit admin_path
      end
      it { should have_error_message 'not authorized' }
    end

    describe 'for admins' do
      let(:admin) { FactoryGirl.create :admin }
      before do
        sign_in admin
        visit admin_path
      end
      it { should_not have_error_message 'not authorized' }
      it { should have_h1 'Dashboard' }
    end
  end

  

end