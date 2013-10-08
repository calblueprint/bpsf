# Tests for the admin dashboard
require 'spec_helper'

describe 'The admin dashboard' do
  subject { page }

  describe 'for non-logged in users' do
    before { visit admin_dashboard_path }

    it { should have_error_message 'not authorized' }
  end
end