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
  SUBJECTS = ['Art & Music', 'Supplies', 'Reading', 'Science & Math', 'Field Trips', 'Other']
  enumerize :subject_areas, in: SUBJECTS, multiple: true
  serialize :subject_areas, Array

  attr_accessible :title, :summary, :subject_areas, :grade_level, :duration,
                  :num_classes, :num_students, :total_budget, :requested_funds,
                  :funds_will_pay_for, :budget_desc, :purpose, :methods,
                  :background, :n_collaborators, :collaborators, :comments,
                  :video, :image_url, :school_id
  belongs_to :recipient
  belongs_to :school

  before_validation do |grant|
    grant.subject_areas = grant.subject_areas.to_a.reject &:empty?
  end

  validates :title, presence: true, length: { maximum: 40 }
  validates_presence_of :recipient_id, if: 'type.nil?'
  validates_length_of :summary, within: 1..200, too_short: 'cannot be blank', allow_nil: true
  validates_length_of :duration, :budget_desc,
                      minimum: 1, too_short: 'cannot be blank', allow_nil: true
  include GradeValidation
  validate :grade_format
  validates_length_of :purpose, :methods, :background, :comments,
                      within: 1..1200, too_short: 'cannot be blank', allow_nil: true
  validates_length_of :collaborators, within: 1..1200,
                      too_short: 'cannot be blank', allow_nil: true,
                      if: "n_collaborators && n_collaborators > 0"

  mount_uploader :image_url, ImageUploader

  def school_name
    school.name
  end

  def submit_and_destroy
    if transfer_attributes_to_new_grant
      GrantSubmittedJob.new.async.perform(self)
      Admin.all.each do |admin|
        AdminGrantsubmittedJob.new.async.perform(self, admin)
      end
      destroy
    end
  end

  private
    def transfer_attributes_to_new_grant
      grant = Grant.new
      valid_attributes = Grant.accessible_attributes.reject &:empty?
      grant.attributes = attributes.slice *valid_attributes
      grant.recipient_id = recipient_id
      grant.save
    end
end
