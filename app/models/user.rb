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
#  school_id              :integer
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :first_name, :last_name, :email, :password,
                  :password_confirmation, :remember_me, :type, :approved

  has_many :payments, dependent: :destroy

  def name
    return "#{first_name} #{last_name}"
  end

  def profile
    nil
  end

  def self.donors
    where 'type is null'
  end

  def init_approved
    true
  end

  def default_card
    if self.stripe_token
      customer = Stripe::Customer.retrieve(self.stripe_token)
      customer.cards.retrieve(customer[:default_card])
    end
  end

  def last4
    if default_card
      default_card[:last4]
    end
  end
end
