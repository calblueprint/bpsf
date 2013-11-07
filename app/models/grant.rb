# == Schema Information
#
# Table name: grants
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  title              :text
#  summary            :text
#  subject_areas      :text
#  grade_level        :text
#  duration           :text
#  num_classes        :integer
#  num_students       :integer
#  total_budget       :integer
#  requested_funds    :integer
#  funds_will_pay_for :text
#  budget_desc        :text
#  purpose            :text
#  methods            :text
#  background         :text
#  n_collaborators    :integer
#  collaborators      :text
#  comments           :text
#  recipient_id       :integer
#  state              :string(255)
#  video              :string(255)
#  image_url          :string(255)
#  school_id          :integer
#

class ValidGradeValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if not value
    nums = value.split(/,\s*|-/)
    unless nums.all? { |num| num =~ /^([K1-9]|1[0-2])$/ }
      object.errors[attribute] << (options[:message] || "is not formatted properly")
    end
  end
end

class ValidSubjectValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    value = value.drop(1)
    if value.empty?
      object.errors[attribute] << (options[:message] || "cannot be empty")
    end
  end
end

require 'textacular/searchable'
class Grant < ActiveRecord::Base
  extend Enumerize
  SUBJECTS = ['Art & Music', 'Supplies', 'Reading', 'Science & Math', 'Field Trips', 'Other']
  serialize :subject_areas, Array
  enumerize :subject_areas, in: SUBJECTS, multiple: true

  attr_accessible :title, :summary, :subject_areas, :grade_level, :duration,
                  :num_classes, :num_students, :total_budget, :requested_funds,
                  :funds_will_pay_for, :budget_desc, :purpose, :methods, :background,
                  :n_collaborators, :collaborators, :comments, :video, :image_url
  belongs_to :recipient
  belongs_to :school
  extend Searchable :title, :summary, :subject_areas

  validates :title, presence: true, length: { maximum: 40 }
  validates :subject_areas, valid_subject: true, allow_blank: false
  validates_length_of :summary, within: 1..200, too_short: 'cannot be blank'
  validates_length_of :duration, :budget_desc,
                      minimum: 1, too_short: 'cannot be blank'
  validates :grade_level, presence: true, valid_grade: true
  validates_length_of :purpose, :methods, :background, :collaborators, :comments,
                      within: 1..1200, too_short: 'cannot be blank'

  scope :pending_grants, -> { with_state :pending }
  scope :complete_grants, -> { with_state :complete }
  scope :crowdfunding_grants, -> { with_state :crowdfunding }

  state_machine initial: :pending do

    after_transition :on => :fund, :do => :process_payments
    after_transition [:pending, :crowdfund_pending] => :rejected, :do => :grant_rejected
    after_transition :crowdfunding => :complete, :do => [:admin_crowdsuccess,:grant_funded]
    after_transition [:pending, :crowdfund_pending] => :complete, :do => :grant_funded
    after_transition :pending => :crowdfunding, :do => :grant_crowdfunding
    after_transition :crowdfunding => :crowdfund_pending, :do => :crowdfailed

    event :reject do
      transition [:pending, :crowdfund_pending] => :rejected
    end

    event :reconsider do
      transition [:rejected, :crowdfund_pending, :crowdfunding, :complete] => :pending
    end

    event :fund do
      transition [:pending, :crowdfund_pending, :crowdfunding] => :complete
    end

    event :crowdfund do
      transition :pending => :crowdfunding
    end

    event :crowdfunding_failed do
      transition :crowdfunding => :crowdfund_pending
    end
  end

  def process_payments
    @payments = Payment.where crowdfund_id: self.id
    @payments.each do |payment|
      user = User.find payment.user_id
      charge = Stripe::Charge.create amount: payment.amount,
                                     currency: "usd",
                                     customer: user.stripe_token,
                                     description: "Donation to BPSF"
      payment.charge_id = charge.id
      payment.save!
      UserMailer.user_crowdsuccess(user,self).deliver
    end
  rescue Stripe::InvalidRequestError => err
    logger.error "Stripe error: #{err.message}"
  end

  def grant_rejected
    UserMailer.grant_rejected(self).deliver
  end

  def admin_crowdsuccess
    @admins = Admin.all
    @admins.each do |admin|
      UserMailer.admin_crowdsuccess(self, admin).deliver
    end
  end

  def grant_funded
    UserMailer.grant_funded(self).deliver

  end

  def grant_crowdfunding
    UserMailer.grant_crowdfunding(self).deliver
  end

  def crowdfailed
    @admins = Admin.all
    @admins.each do |admin|
      UserMailer.admin_crowdfailed(self, admin).deliver
    end
    UserMailer.grant_crowdfailed(self).deliver
  end

end
