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
  attr_accessible :about, :image_url, :school_id, :recipient_id, :grade, :subject, :started_teaching
  belongs_to :recipient

  mount_uploader :image_url, ImageUploader

  def years_teaching
    Date.today.year - self.started_teaching.year
  end
end
