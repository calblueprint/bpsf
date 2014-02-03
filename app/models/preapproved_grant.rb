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
#  rating_average     :decimal(6, 2)    default(0.0)
#  school_name        :string(255)
#  teacher_name       :string(255)
#  type               :string(255)
#

class PreapprovedGrant < DraftGrant
  belongs_to :grant
  validates :grant_id, presence: true

  def clone_into_draft_for!(recipient_id)
    draft = dup
    draft.recipient_id = recipient_id
    draft.becomes DraftGrant
    draft.save
  end
end
