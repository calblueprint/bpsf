module StrictValidations
  extend ActiveSupport::Concern

  included do
    validates :title, presence: true, length: { maximum: 40 }
    validate :valid_subject_areas
    validates :summary, presence: true, length: { maximum: 200 }
    validates :grade_level, presence: true
    validate :grade_format
    validate :duration, presence: true
    validates :num_classes, :num_students, numericality: { only_integer: true }
    validates :requested_funds, :total_budget, numericality: true
    validates :budget_desc, :funds_will_pay_for, presence: true
    validates :purpose, :methods, :background,
              presence: true, length: { maximum: 1200 }
    validates :comments, length: { maximum: 1200 }
    validates :n_collaborators, numericality: { greater_than_or_equal_to: 0 }
    validates :collaborators, length: { maximum: 1200 },
              presence: true, if: 'n_collaborators && n_collaborators > 0'
  end
end
