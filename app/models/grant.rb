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
#  school_id          :string(255)
#

class Grant < ActiveRecord::Base
  attr_accessible :title, :organization, :sum, :summary, :subject_areas,
                  :grade_level, :duration, :num_classes, :num_students, :total_budget,
                  :requested_funds, :funds_will_pay_for, :budget_desc, :purpose, :methods,
                  :background, :n_collaborators, :collaborators, :comments, :video
  belongs_to :recipient
  belongs_to :school

  scope :pending_grants, -> { with_state :pending }
  scope :complete_grants, -> { with_state :complete }
  scope :crowdfunding_grants, -> { with_state :crowdfunding }

  state_machine initial: :pending do

    after_transition :on => :fund, :do => :process_payments

    event :reject do
      transition [:pending, :crowdfund_pending] => :rejected
      def self.grant_rejected
        UserMailer.grant_rejected(self).deliver
      end
    end

    event :reconsider do
      transition [:rejected, :crowdfund_pending, :crowdfunding, :complete] => :pending
    end

    event :fund do
      def self.crowdsuccess  
        if self.crowdfunding?
          UserMailer.admin_crowdsuccess(self).deliver
          @payments = Payment.where(:crowdfund_id => self.id)
          for payment in @payments do
            user = User.find(payment.user_id)
            UserMailer.user_crowdsuccess(user,self).deliver
          end
        end
      end
      transition [:pending, :crowdfund_pending, :crowdfunding] => :complete
      def self.grant_funded
        UserMailer.grant_funded(self).deliver
      end
    end

    event :crowdfund do
      transition :pending => :crowdfunding
      def self.grant_crowdfunding
        UserMailer.grant_crowdfunding(self).deliver
      end
    end

    event :crowdfunding_failed do
      transition :crowdfunding => :crowdfund_pending
      def self.crowdfailed
        UserMailer.admin_crowdfailed(self).deliver
        UserMailer.grant_crowdfailed(self).deliver
      end
    end
  end

  def process_payments
    @payments = Payment.where(:crowdfund_id => self.id)
    for payment in @payments do
      user = User.find(payment.user_id)
      puts "processing"
      puts payment.amount
      charge = Stripe::Charge.create(
        :amount => payment.amount,
        :currency => "usd",
        :customer => user.stripe_token,
        :description => "Donation to BPSF")
      payment.charge_id = charge.id
      payment.save
      def self.user_pledge
        UserMailer.user_pledge(user,self).deliver
      end
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error: #{e.message}"
  end
end
