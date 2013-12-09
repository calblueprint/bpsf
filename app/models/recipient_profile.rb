# == Schema Information
#
# Table name: recipient_profiles
#
#  id               :integer          not null, primary key
#  school_id        :integer
#  image_url        :string(255)
#  about            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipient_id     :integer
#  started_teaching :datetime
#  subject          :string(255)
#  grade            :string(255)
#

class RecipientProfile < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_accessible :about, :image_url, :school_id, :recipient_id, :grade, :subject,
    :started_teaching, :zipcode, :city, :address, :work_phone, :home_phone
  belongs_to :recipient

  before_save :set_phone_numbers


  def years_teaching
    Date.today.year - self.started_teaching.year
  end

  private
  def set_phone_numbers
    self.work_phone = number_to_phone(self.work_phone, area_code: true)
    self.home_phone = number_to_phone(self.home_phone, area_code: true)
  end
end
