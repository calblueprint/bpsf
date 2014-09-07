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
#  image              :string(255)
#  school_id          :integer
#  school_name        :string(255)
#  teacher_name       :string(255)
#  type               :string(255)
#  deadline           :date
#  other_funds        :text
#

require 'textacular/searchable'
class Grant < ActiveRecord::Base
  has_paper_trail only: [:state], skip: [:image]
  extend Enumerize
  SUBJECTS = ['After School Program', 'Arts / Music', 'Arts / Dance', 'Arts / Drama',
    'Arts / Visual', 'Community Service', 'Computer / Media', 'Computer Science',
    'Foreign Language / ELL / TWI','Gardening','History & Social Studies / Multi-culturalism',
    'Mathematics','Multi-subject','Nutrition','Physical Education',
    'Professional Development','Reading & Writing / Communication','Science & Ecology',
    'Special Ed','Student / Family Support / Mental Health','Other']
  FUNDS = ['Supplies','Books','Equipment','Technology / Media',
    'Professional Guest (Consultant, Speaker, Artist, etc.)','Professional Development',
    'Field Trips / Transportation','Assembly','Other']
  serialize :funds_will_pay_for, Array
  serialize :subject_areas, Array
  enumerize :subject_areas, in: SUBJECTS, multiple: true, scope: true

  attr_accessible :title, :summary, :subject_areas, :grade_level, :deadline, :duration,
                  :num_classes, :num_students, :total_budget, :requested_funds,
                  :funds_will_pay_for, :budget_desc, :purpose, :methods, :background,
                  :n_collaborators, :collaborators, :comments, :video, :image, :school_id,
                  :other_funds, :remote_image_url
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :image_width, :image_height

  belongs_to :recipient
  belongs_to :school
  has_one :crowdfunder, class_name: 'Crowdfund'
  has_one :preapproved_grant

  delegate :id, :goal, :pledged_total, :progress, to: :crowdfunder, prefix: true
  delegate :name, to: :school, prefix: true
  delegate :name, to: :recipient, prefix: true

  extend Searchable :title, :summary, :subject_areas, :school_name, :teacher_name

  before_validation do |grant|
    grant.subject_areas = grant.subject_areas.to_a.reject &:empty?
  end

  before_save do |grant|
    self.school_name = school.name
    self.teacher_name = recipient.name
  end

  before_validation :check_funds_for

  after_save :crop_image

  with_options if: :parent? do |grant|
    grant.validates :title, presence: true, length: { maximum: 40 }
    grant.validate :valid_subject_areas
    grant.validate :valid_other
    grant.validates :deadline, presence: true
    grant.validate :valid_deadline, if: "self.deadline_changed?"
    grant.validates :summary, presence: true, length: { maximum: 200 }
    grant.validates :grade_level, presence: true
    grant.validate :duration, presence: true
    grant.validates :num_classes, :num_students, numericality: { only_integer: true }
    grant.validates :total_budget, numericality: true
    grant.validates :budget_desc, :funds_will_pay_for, presence: true
    grant.validates :purpose, :methods, :background,
                    presence: true, length: { maximum: 1200 }
    grant.validates :comments, length: { maximum: 1200 }
    grant.validates :n_collaborators, numericality: { greater_than_or_equal_to: 0 }
    grant.validates :collaborators, length: { maximum: 1200 }
    grant.validate :valid_collaborators
  end

  mount_uploader :image, ImageUploader

  def crop_image
    image.recreate_versions! if crop_x.present?
    if type.blank? && crop_x.present?
      self[:crop_x],self[:crop_y],self[:crop_w],self[:crop_h] = nil
      self.save
    end
  end

  scope :submitted,           -> { where type: nil }
  scope :pending_grants,      -> { with_state :pending }
  scope :complete_grants,     -> { with_state :complete }
  scope :accepted_grants,     -> { with_state [:complete, :crowdfunding, :crowdfund_pending]}
  scope :rejected_grants,     -> { with_state :rejected }
  scope :crowdfunding_grants, -> { with_state :crowdfunding }
  scope :crowdpending_grants, -> { with_state :crowdfund_pending }
  scope :newest, limit: 5, order: 'created_at DESC'

  state_machine initial: :pending do

    after_transition on: :fund, do: :process_payments
    after_transition [:pending, :crowdfund_pending] => :rejected, do: :grant_rejected
    after_transition :crowdfunding => :complete, do: [:crowdsuccess, :grant_funded]
    after_transition [:pending, :crowdfund_pending] => :complete, do: :grant_funded
    after_transition :pending => :crowdfunding, do: :grant_crowdfunding
    after_transition :crowdfunding => :crowdfund_pending, do: :crowdfailed

    event :reject do
      transition [:pending, :crowdfund_pending] => :rejected
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
    @payments = Payment.where crowdfund_id: crowdfunder
    @payments.each do |payment|
      unless payment.charge_id
        user = User.find payment.user_id
        payment.status = "Cancelled"
        payment.save!
        UserCrowdfailedJob.new.async.perform(user,self)
      end
    end
  end

  # Magic
  def check_funds_for
    if self[:funds_will_pay_for][0] == ""
      self[:funds_will_pay_for].shift
    end
    self[:funds_will_pay_for] = self[:funds_will_pay_for] + other_funds.split(", ") unless (other_funds.blank? || other_funds.split(", ")[-1] == self[:funds_will_pay_for][-1])
  end

  def crowdsuccess
    @admins = SuperUser.all
    @admins.each do |admin|
      AdminCrowdsuccessJob.new.async.perform(self, admin)
    end
  end

  def has_collaborators?
      n_collaborators && n_collaborators > 0
  end

  def days_left
    (deadline - Date.today).to_i
  end

  def current_funds
    if crowdfunder
      crowdfunder.pledged_total
    else
      0
    end
  end

  def has_pledges?
    crowdfunder && crowdfunder.pledged_total > 0
  end

  def past_deadline?
    days_left <= 0
  end

  def grant_funded
    GrantFundedJob.new.async.perform(self)
  end

  def grant_crowdfunding
    GrantCrowdfundingJob.new.async.perform(self)
  end

  def crowdfailed
    @admins = SuperUser.all
    @admins.each do |admin|
      AdminCrowdfailedJob.new.async.perform(self, admin)
    end
    GrantCrowdfailedJob.new.async.perform(self)
  end

  # Callback to process payments after a successful crowdfund
  def process_payments
    @payments = Payment.where crowdfund_id: crowdfunder
    @payments.each do |payment|
      unless payment.charge_id
        begin
          user = User.find payment.user_id
          grant = payment.crowdfund.grant
          amount = (payment.amount * 100).to_i
          charge = Stripe::Charge.create amount: amount,
            currency: "usd",
            customer: user.stripe_token,
            # This should get updated depending on the environment.
            # TODO: Refactor so this logic happens in the controller
            description: "F&F Grant - Teacher: #{grant.teacher_name}, Grant: #{grant}, Grant ID: #{payment.crowdfund.grant.id}"
          payment.charge_id = charge.id
          payment.status = "Charged"
          payment.save!
          UserCrowdsuccessJob.new.async.perform(user,self)
        rescue Stripe::InvalidRequestError, Stripe::CardError => err
          logger.error "Stripe error: #{err.message}"
          logger.error "#{user}"
          payment.status = "Invalid"
          payment.charge_id = "Invalid"
          payment.save!
        end
      end
    end
  end

  def to_s
    title
  end

  def status
    if complete?
      "Funded"
    elsif rejected?
      "Rejected"
    elsif pending?
      "Pending"
    elsif crowdfund_pending?
      "Crowdfund Pending"
    elsif past_deadline?
      "Past Deadline"
    else
      "Crowdfunding: " + self.crowdfunder.progress
    end
  end

  def order_status
    if complete?
      5
    elsif rejected?
      6
    elsif pending?
      1
    elsif crowdfund_pending?
      3
    elsif past_deadline?
      4
    else
      2
    end
  end

  def crowdfunding?
    state == "crowdfunding"
  end

  def with_admin_cost
    # 9% cost added
    (total_budget * 1.09).to_i
  end

  def admin_cost
    with_admin_cost - total_budget
  end

  def valid_collaborators
    errors.add(:collaborators, "can't be blank") if
      collaborators.blank? && n_collaborators && n_collaborators > 0
  end

  def has_comments?
    !comments.blank?
  end

  def self.grant_check
    @grants = Grant.crowdfunding_grants
    @grants.each do |grant|
      if grant.days_left == 3
        GrantEndingJob.new.async.perform(grant)
        @supers = SuperUser.all
        @supers.each do |admin|
          SuperCrowdendingJob.new.async.perform(grant, admin)
        end
      end
    end
    false
  end

  def self.close_to_goal
    close = []
    Grant.crowdfunding_grants.each do |grant|
      cf = grant.crowdfunder
      if cf.pledged_total >= cf.goal * 0.9
        close << grant
      end
    end
    close
  end

  def clone_into_draft!
    draft = dup.becomes DraftGrant
    draft.type = 'DraftGrant'
    draft.state = 'pending'
    draft.remote_image_url = self.image_url
    draft.save
    draft
  end

  private
    BLACKLISTED_ATTRIBUTES = %w{background n_collaborators collaborators
                                comments video image}
    def transfer_attributes_to_new_preapproved_grant
      return false if preapproved?
      preapproved_grant = PreapprovedGrant.new
      valid_attributes = PreapprovedGrant.accessible_attributes.reject(&:empty?) -
                         BLACKLISTED_ATTRIBUTES
      preapproved_grant.attributes = attributes.slice *valid_attributes
      preapproved_grant.image = image.file
      preapproved_grant.grant_id = id
      preapproved_grant.save
    end

    def valid_subject_areas
      errors.add :subject_areas, "can't be empty" unless !subject_areas.empty?
    end

    def valid_deadline
      errors.add(:deadline, "should be later than today") if
        deadline.blank? || deadline <= Date.today
    end

    def valid_other
      errors.add(:other_funds, "should be filled") if
        self[:funds_will_pay_for][-1] == "Other" and other_funds.blank?
    end

    def parent?
      type.nil?
    end
end
