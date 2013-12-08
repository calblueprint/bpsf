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

require 'textacular/searchable'
class Grant < ActiveRecord::Base
  has_paper_trail :only => [:state]
  extend Enumerize
  SUBJECTS = ['After School Program', 'Arts / Music', 'Arts / Dance', 'Arts / Drama',
    'Arts / Visual', 'Community Service', 'Computer / Media', 'Computer Science',
    'Foreign Language / ELL / TWI','Gardening','History & Social Studies / Multi-culturalism',
    'Mathematics','Multi-subject','Nutrition','Physical Education',
    'Professional Development','Reading & Writing / Communication','Science & Ecology',
    'Special Ed','Student / Family Support / Mental Health','Other']
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
  delegate :name, to: :school, prefix: true
  delegate :goal, :pledged_total, :progress, to: :crowdfunder, prefix: true
  extend Searchable :title, :summary, :subject_areas
  ajaxful_rateable stars: 10

  before_validation do |grant|
    grant.subject_areas = grant.subject_areas.to_a.reject &:empty?
  end

  validates :title, presence: true, length: { maximum: 40 }
  validate :valid_subject_areas
  validates :summary, presence: true, length: { maximum: 200 }
  include GradeValidation
  validates :grade_level, presence: true
  validate :grade_format
  validates :purpose, :methods, :background,
            presence: true, length: { maximum: 1200 }
  validates :comments, length: { maximum: 1200 }
  validates :n_collaborators, numericality: { greater_than_or_equal_to: 0 }
  validates :collaborators, length: { maximum: 1200 },
            presence: true, if: 'n_collaborators && n_collaborators > 0'

  scope :pending_grants,      -> { with_state :pending }
  scope :complete_grants,     -> { with_state :complete }
  scope :accepted_grants,     -> { (with_state :complete) | (with_state :crowdfunding) | (with_state :crowdfund_pending) }
  scope :rejected_grants,     -> { with_state :rejected }
  scope :crowdfunding_grants, -> { with_state :crowdfunding }
  scope :crowdpending_grants, -> { with_state :crowdfund_pending }
  scope :newest, limit: 5, order: 'created_at DESC'

  state_machine initial: :pending do

    after_transition :on => :fund, :do => :process_payments
    after_transition [:pending, :crowdfund_pending] => :rejected, :do => :grant_rejected
    after_transition :crowdfunding => :complete, :do => [:crowdsuccess,:grant_funded]
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

  def prev_state
    return self.previous_version.state
  end

  # Grant state transition mailer callbacks
  def grant_rejected
    GrantRejectedJob.new.async.perform(self)
  end

  def crowdsuccess
    @admins = Admin.all + SuperUser.all
    @admins.each do |admin|
      AdminCrowdsuccessJob.new.async.perform(self, admin)
    end
  end

  def grant_funded
    GrantFundedJob.new.async.perform(self)
  end

  def grant_crowdfunding
    GrantCrowdfundingJob.new.async.perform(self)
  end

  def crowdfailed
    @admins = Admin.all + SuperUser.all
    @admins.each do |admin|
      AdminCrowdfailedJob.new.async.perform(self, admin)
    end
    self.crowdfunder.destroy if self.crowdfunder
    GrantCrowdfailedJob.new.async.perform(self)
  end

  # Callback to process payments after a successful crowdfund
  def process_payments
    @payments = Payment.where crowdfund_id: self.id
    @payments.each do |payment|
      unless payment.charge_id
        user = User.find payment.user_id
        recipient = Recipient.find payment.crowdfund.grant.recipient_id
        amount = (payment.amount * 100).to_i
        charge = Stripe::Charge.create amount: amount,
          currency: "usd",
          customer: user.stripe_token,
          description: "Grant: #{payment.crowdfund.grant.title}, Teacher: #{recipient.name}"
        payment.charge_id = charge.id
        payment.save!
        UserCrowdsuccessJob.new.async.perform(user,self)
      end
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

  def has_collaborators?
    n_collaborators > 0
  end

  def has_comments?
    !comments.blank?
  end

  def self.close_to_goal
    close = []
    Grant.all.each do |grant|
      cf = grant.crowdfunder
      if cf.pledged_total >= cf.goal * 0.9
        close << grant
      end
    end
    close
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

    def valid_subject_areas
      errors.add :subject_areas, "can't be empty" unless !subject_areas.empty?
    end
end
