# == Schema Information
#
# Table name: grants
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  crowdfunding       :boolean          default(FALSE)
#  crowdfund_pending  :boolean          default(FALSE)
#  pending            :boolean          default(TRUE)
#  complete           :boolean          default(FALSE)
#  rejected           :boolean          default(FALSE)
#  user_id            :integer
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
#

class Grant < ActiveRecord::Base
  attr_accessible :title, :organization, :sum, :summary, :subject_areas, 
                  :grade_level, :duration, :num_classes, :num_students, :total_budget, 
                  :requested_funds, :funds_will_pay_for, :budget_desc, :purpose, :methods, 
                  :background, :n_collaborators, :collaborators, :comments
end
