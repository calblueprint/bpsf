# Tests grant submission
require 'spec_helper'

describe 'Submiting a Grant' do
  subject { page }

  let(:recipient) { FactoryGirl.create :recipient }
  let(:draft) { FactoryGirl.create filled_in_draft_grant recipient: recipient }

  before do
    sign_in recipient
    visit edit_draft_path draft
  end

end