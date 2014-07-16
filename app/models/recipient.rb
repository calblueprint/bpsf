# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  type                   :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  stripe_token           :string(255)
#  approved               :boolean
#

class Recipient < User
  has_many :grants, dependent: :destroy
  has_many :draft_grants, dependent: :destroy
  has_one :profile, class_name: 'RecipientProfile'

  attr_accessible :profile_attributes
  accepts_nested_attributes_for :profile

  CSV_COLUMNS = ['First Name', 'Last Name', 'Email']

  def init_approved
    true
  end

  def previous_grants
    grants.complete_grants
  end

  def self.to_csv(recipients)
    CSV.generate do |csv|
      csv << CSV_COLUMNS
      recipients.each do |recipient|
        csv << recipient.to_csv
      end
    end
  end

  def to_csv
    [first_name, last_name, email]
  end
end
