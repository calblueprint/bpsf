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
#  rating_average     :decimal(6, 2)    default(0.0)
#

# Validates the grade_levels format.
class ValidGradeValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    return if not value
    nums = value.split(/,\s*|-/)
    unless nums.all? { |num| num =~ /^([K1-9]|1[0-2])$/ }
      object.errors[attribute] << (options[:message] || "is not formatted properly")
    end
  end
end

# Validates the subject_areas
class ValidSubjectValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    object.errors.add attribute, "cannot be empty" unless !value.empty?
  end
end

require 'textacular/searchable'
class Grant < ActiveRecord::Base
  extend Enumerize
  SUBJECTS = ['Art & Music', 'Supplies', 'Reading', 'Science & Math', 'Field Trips', 'Other']
  serialize :subject_areas, Array
  enumerize :subject_areas, in: SUBJECTS, multiple: true, scope: true

  attr_accessible :title, :summary, :subject_areas, :grade_level, :duration,
                  :num_classes, :num_students, :total_budget, :requested_funds,
                  :funds_will_pay_for, :budget_desc, :purpose, :methods, :background,
                  :n_collaborators, :collaborators, :comments, :video, :image_url, :school_id
  belongs_to :recipient
  belongs_to :school
  has_one :crowdfunder, class_name: 'Crowdfund'
  has_one :preapproved_grant
  extend Searchable :title, :summary, :subject_areas
  ajaxful_rateable stars: 10

  before_validation do |grant|
    grant.subject_areas = grant.subject_areas.to_a.reject &:empty?
  end

  validates :title, presence: true, length: { maximum: 40 }
  validates :subject_areas, valid_subject: true
  validates_length_of :summary, within: 1..200, too_short: 'cannot be blank'
  validates_length_of :duration, :budget_desc,
                      minimum: 1, too_short: 'cannot be blank'
  validates :grade_level, presence: true, valid_grade: true
  validates_length_of :purpose, :methods, :background,
                      within: 1..1200, too_short: 'cannot be blank'
  validates_length_of :comments, within: 1..1200, allow_blank: true
  validates_length_of :collaborators, within: 1..1200,
                      too_short: 'cannot be blank', if: "n_collaborators > 0"

  scope :pending_grants,      -> { with_state :pending }
  scope :complete_grants,     -> { with_state :complete }
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

  # Grant state transition mailer callbacks
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
    self.crowdfunder.destroy
  end

  # Callback to process payments after a successful crowdfund
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

  def preapprove!
    transfer_attributes_to_new_preapproved_grant
  end

  def preapproved?
    !preapproved_grant.nil?
  end

  def school_name
    school.name
  end

  def has_collaborators?
    n_collaborators > 0
  end

  def has_comments?
    !comments.blank?
  end

  private
    BLACKLISTED_ATTRIBUTES = %w{background n_collaborators collaborators
                                comments video image_url}
    def transfer_attributes_to_new_preapproved_grant
      return false if preapproved?
      preapproved_grant = PreapprovedGrant.new
      valid_attributes = PreapprovedGrant.accessible_attributes.reject(&:empty?) -
                         BLACKLISTED_ATTRIBUTES
      preapproved_grant.attributes = attributes.slice *valid_attributes
      preapproved_grant.grant_id = id
      preapproved_grant.save
    end

end
