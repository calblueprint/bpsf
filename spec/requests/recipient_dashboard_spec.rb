# Tests for the recipient dashboard
require 'spec_helper'

describe "The recipient dashboard" do

  subject { page }

  let(:recipient) { FactoryGirl.create :recipient }

  before do
    sign_in recipient
    visit recipient_dashboard_path
  end

  describe 'draft grants' do
    describe 'creation' do

      describe 'with invalid title' do
        before do
          visit new_draft_path
          click_button 'Go'
        end

        it { should have_error_message "Title can't be blank" }
      end

      describe 'with valid title' do
        before do
          visit new_draft_path
          fill_in 'draft_grant_title', with: 'Draft'
          click_button 'Go'
        end

        it { should have_success_message 'created!' }
      end

    end

    describe 'editing' do
      let(:draft) { FactoryGirl.create :draft_grant, recipient_id: recipient.id }
      describe 'General Info' do
        before do
          visit draft_edit_general_path draft
          fill_in 'Summary', with: 'Summary text'
          select 'Supplies', from: 'draft_grant_subject_areas'
          click_button 'Save!'
        end

        it { should have_success_message 'updated!' }
        it { should have_content 'Summary text' }
      end

    end

    describe 'submitting' do
      describe 'with all fields filled in' do
        let(:draft) { FactoryGirl.create :draft_grant,
                                         summary: Faker::Lorem.sentence,
                                         subject_areas: ["","Art & Music", "Reading"],
                                         grade_level: "6",
                                         duration: "4 weeks",
                                         num_classes: 4,
                                         num_students: 10,
                                         total_budget: 300,
                                         requested_funds: 250,
                                         funds_will_pay_for: Faker::Lorem.paragraph,
                                         budget_desc: Faker::Lorem.paragraph,
                                         purpose: Faker::Lorem.paragraph,
                                         methods: Faker::Lorem.paragraph,
                                         background: Faker::Lorem.paragraph,
                                         n_collaborators: 2,
                                         collaborators: Faker::Lorem.paragraph,
                                         comments: Faker::Lorem.paragraph,
                                         recipient_id: recipient.id }
        before do
          visit edit_draft_path draft
          click_link 'Submit!'
        end
        it { should have_success_message 'submitted!' }
        it { should_not have_selector 'div.drafts', text: draft.title }
        it { should have_selector 'div.submitted', text: draft.title }
      end

      describe 'with blank fields' do
        let(:draft) { FactoryGirl.create :draft_grant, recipient_id: recipient.id }
        before do
          visit edit_draft_path draft
          click_link 'Submit!'
        end
        it { should have_error_message 'not filled in!' }
      end
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
    it { should have_h2 'Welcome' }
  end

end
