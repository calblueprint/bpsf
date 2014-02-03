# Tests grant submission
require 'spec_helper'

describe 'Submiting a Grant' do
  subject { page }

  let(:recipient) { FactoryGirl.create :recipient }
  let(:draft) { FactoryGirl.create :filled_in_draft_grant, recipient: recipient }

  before do
    sign_in recipient
    visit edit_draft_path draft
  end

  it { should have_content 'Editing' }
  it { should have_button 'Submit!' }

  describe 'after filling fields' do
    before { click_button 'Submit!' }
    it { should have_content 'Pending' }
  end

end