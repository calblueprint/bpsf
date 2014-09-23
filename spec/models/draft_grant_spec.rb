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

require 'spec_helper'

describe DraftGrant do
  it { should allow_mass_assignment_of :title }
  it { should allow_mass_assignment_of :summary }
  it { should allow_mass_assignment_of :subject_areas }
  it { should allow_mass_assignment_of :grade_level }
  it { should allow_mass_assignment_of :duration }
  it { should allow_mass_assignment_of :num_classes }
  it { should allow_mass_assignment_of :num_students }
  it { should allow_mass_assignment_of :total_budget }
  it { should allow_mass_assignment_of :requested_funds }
  it { should allow_mass_assignment_of :funds_will_pay_for }
  it { should allow_mass_assignment_of :budget_desc }
  it { should allow_mass_assignment_of :purpose }
  it { should allow_mass_assignment_of :methods }
  it { should allow_mass_assignment_of :background }
  it { should allow_mass_assignment_of :n_collaborators }
  it { should allow_mass_assignment_of :collaborators }
  it { should allow_mass_assignment_of :comments }
  it { should allow_mass_assignment_of :video }
  it { should allow_mass_assignment_of :image_url }
  it { should allow_mass_assignment_of :school_id }
  it { should_not allow_mass_assignment_of :recipient_id }

  it { should belong_to :recipient }
  it { should belong_to :school }

  it { should validate_presence_of :title }
  it { should ensure_length_of(:title).is_at_most 40 }

  it { should validate_presence_of :recipient_id }

  it { should ensure_length_of(:summary).is_at_most 200 }

  it { should allow_value('K,3, 5-12').for :grade_level }
  it { should_not allow_value('a, 5-13').for :grade_level }

  it { should ensure_length_of(:duration).is_at_least(1)
                                         .with_message(/cannot be blank/) }
  it { should ensure_length_of(:budget_desc).is_at_least(1)
                                            .with_message(/cannot be blank/) }

  it { should ensure_length_of(:purpose).is_at_most 1200 }
  it { should ensure_length_of(:methods).is_at_most 1200 }
  it { should ensure_length_of(:background).is_at_most 1200 }
  it { should ensure_length_of(:comments).is_at_most 1200 }

end
