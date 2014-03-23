# == Schema Information
#
# Table name: recipient_profiles
#
#  id               :integer          not null, primary key
#  school_id        :integer
#  about            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipient_id     :integer
#  started_teaching :datetime
#  subject          :string(255)
#  grade            :string(255)
#  address          :string(255)
#  city             :string(255)
#  zipcode          :text
#  work_phone       :string(255)
#  home_phone       :string(255)
#  state            :text
#

class RecipientProfile < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_accessible :about, :school_id, :recipient_id, :grade, :subject,
    :started_teaching, :zipcode, :city, :address, :work_phone, :home_phone, :state
  belongs_to :recipient

  before_save :format_phone_numbers

  validates :about, presence: true, on: :update
  validates :school_id, presence: true, on: :update
  validates :subject, presence: true, on: :update
  validates :started_teaching, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :city, presence: true, on: :update
  validates :state, presence: true, on: :update
  validates :zipcode, length: { minimum: 5, message: 'is an invalid zipcode' }, presence: true, on: :update
  validates :work_phone, presence: true, on: :update
  validates :home_phone, presence: true, on: :update


  def years_teaching
    Date.today.year - self.started_teaching.year
  end

  private
    def format_phone_numbers
      self.work_phone = number_to_phone(self.work_phone, area_code: true)
      self.home_phone = number_to_phone(self.home_phone, area_code: true)
    end
end
