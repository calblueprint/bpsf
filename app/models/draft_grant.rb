# == Schema Information
#
# Table name: draft_grants
#
#  id                 :integer          not null, primary key
#  recipient_id       :integer
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
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  video              :string(255)
#  image_url          :string(255)
#  school_id          :integer
#  type               :string(255)
#  grant_id           :integer
#

class DraftGrant < ActiveRecord::Base
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
  enumerize :funds_will_pay_for, in: FUNDS
  enumerize :subject_areas, in: SUBJECTS, multiple: true
  serialize :subject_areas, Array

  attr_accessible :title, :summary, :subject_areas, :grade_level, :duration,
                  :num_classes, :num_students, :total_budget, :requested_funds,
                  :funds_will_pay_for, :budget_desc, :purpose, :methods,
                  :background, :n_collaborators, :collaborators, :comments,
                  :video, :image_url, :school_id, :recipient_id
  belongs_to :recipient
  belongs_to :school
  delegate :name, to: :school, prefix: true

  before_validation do |grant|
    grant.subject_areas = grant.subject_areas.to_a.reject &:empty?
  end

  validates :title, presence: true, length: { maximum: 40 }
  validates :recipient_id, :school_id, presence: true, if: 'type.nil?'
  validates :summary, length: { maximum: 200 }
  include GradeValidation
  validate :grade_format
  validates :purpose, :methods, :background, :comments, length: { maximum: 1200 }
  validates :n_collaborators, allow_blank: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :collaborators, length: { maximum: 1200 },
            if: 'n_collaborators && n_collaborators > 0'

  mount_uploader :image_url, ImageUploader

  def has_collaborators?
    n_collaborators && n_collaborators > 0
  end

  def has_comments?
    comments
  end
  def submit_and_destroy
    if transfer_attributes_to_new_grant
      GrantSubmittedJob.new.async.perform(self)
      admins = Admin.all + SuperUser.all
      admins.each do |admin|
        AdminGrantsubmittedJob.new.async.perform(self, admin)
      end
      destroy
    end
  end

  private
    def transfer_attributes_to_new_grant
      grant = recipient.grants.build
      valid_attributes = Grant.accessible_attributes.reject &:empty?
      grant.attributes = attributes.slice *valid_attributes
      grant.image_url = image_url.file
      grant.save
    end
end
