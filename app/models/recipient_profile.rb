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
#  address          :string(255)
#  city             :string(255)
#  zipcode          :integer
#  work_phone       :string(255)
#  home_phone       :string(255)
#

class RecipientProfile < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_accessible :about, :image_url, :school_id, :recipient_id, :grade, :subject,
    :started_teaching, :zipcode, :city, :address, :work_phone, :home_phone
  belongs_to :recipient

  before_save :set_phone_numbers

  validates :about, presence: true,
    length: { minimum: 40, message: "is too shoort" }
  validates :school_id, presence: true
  validates :subject, presence: true
  validates :started_teaching, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :zipcode, presence: true,
    length: { minimum: 5, message: 'is an invalid zipcode' }
  validates :work_phone, presence: true
  validates :home_phone, presence: true

  def years_teaching
    Date.today.year - self.started_teaching.year
  end

  private
  def set_phone_numbers
    self.work_phone = number_to_phone(self.work_phone, area_code: true)
    self.home_phone = number_to_phone(self.home_phone, area_code: true)
  end
end
