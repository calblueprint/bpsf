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

class DraftGrant < ActiveRecord::Base
  extend Enumerize
  SUBJECTS = ['Art & Music', 'Supplies', 'Reading', 'Science & Math', 'Field Trips', 'Other']
  enumerize :subject_areas, in: SUBJECTS, multiple: true
  serialize :subject_areas, Array

  attr_accessible :title, :summary, :subject_areas, :grade_level, :duration,
                  :num_classes, :num_students, :total_budget, :requested_funds,
                  :funds_will_pay_for, :budget_desc, :purpose, :methods,
                  :background, :n_collaborators, :collaborators, :comments,
                  :video, :image_url
  belongs_to :recipient
  belongs_to :school

  before_validation do |grant|
    grant.subject_areas = grant.subject_areas.to_a.reject(&:empty?)
  end

  validates :title, presence: true, length: { maximum: 40 }
  validates_presence_of :recipient_id
  validates_length_of :summary, within: 1..200, too_short: 'cannot be blank', allow_nil: true
  validates_length_of :duration, :budget_desc,
                      minimum: 1, too_short: 'cannot be blank', allow_nil: true
  validates :grade_level, valid_grade: true, allow_nil: true
  validates_length_of :purpose, :methods, :background, :collaborators, :comments, 
                      within: 1..1200, too_short: 'cannot be blank', allow_nil: true

  mount_uploader :image_url, ImageUploader

  def submit_and_destroy
    grant = Grant.new
    valid_attributes = Grant.accessible_attributes.reject { |attr| attr.empty? }
    grant.attributes = attributes.slice *valid_attributes
    grant.recipient_id = recipient_id
    grant.school_id = school_id
    if grant.save
      UserMailer.grant_submitted(self).deliver
      @admins = Admin.all
      @admins.each do |admin|
        UserMailer.admin_grantsubmitted(self,admin).deliver
      end
      destroy
    end
  end
end
