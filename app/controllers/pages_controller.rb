# Controller for miscellaneous pages
class PagesController < ApplicationController
  MENU = ['All','After School Program', 'Arts / Music', 'Arts / Dance', 'Arts / Drama',
    'Arts / Visual', 'Community Service', 'Computer / Media', 'Computer Science',
    'Foreign Language / ELL / TWI','Gardening','History & Social Studies / Multi-culturalism',
    'Mathematics','Multi-subject','Nutrition','Physical Education',
    'Professional Development','Reading & Writing / Communication','Science & Ecology',
    'Special Ed','Student / Family Support / Mental Health','Other']

  def home
    @grants = Grant.crowdfunding_grants.includes :recipient, :school, :crowdfunder
    subject = params[:subject]
    if subject && subject != 'All'
      @grants = @grants.select { |grant| grant.subject_areas.include? subject }
    end
    @grants = @grants.paginate :page => params[:page], :per_page => 6
    @slideshow_grants = slideshow_grants
  end

  def search
    @grants = Grant.crowdfunding_grants
                   .search(params[:query])
                   .includes :recipient, :school
  end

  def successful
    @successful_grants = []
    Grant.complete_grants.each do |grant|
      if grant.previous_version.state == 'crowdfunding'
        @successful_grants << grant
      end
    end
  end

  def slideshow_grants
    possible_grants = []
    if user_signed_in?
      payments = current_user.payments.includes :crowdfund
      payments.each do |payment|
        crowdfund = payment.crowdfund
        possible_grants << crowdfund.grant
      end
    end
    possible_grants.concat Grant.crowdfunding_grants.newest
    possible_grants.concat Grant.close_to_goal
    possible_grants = possible_grants.uniq
    possible_grants.sample 3
  end
end
