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

class DraftGrant < Grant
  validates :title, presence: true, length: { maximum: 200 }
  validates :recipient_id, :school_id, presence: true, if: 'type.nil?'
  validates :summary, length: { maximum: 200 }
  validates :purpose, :methods, :background, :comments, length: { maximum: 1200 }
  validates :n_collaborators, allow_blank: true,
            numericality: { greater_than_or_equal_to: 0 }
  validates :collaborators, length: { maximum: 1200 }

  def has_comments?
    comments
  end

  def submit_and_destroy
    new_grant = transfer_attributes_to_new_grant
    if new_grant
      GrantSubmittedJob.new.async.perform(new_grant)
      admins = Admin.all + SuperUser.all
      admins.each do |admin|
        AdminGrantsubmittedJob.new.async.perform(new_grant, admin)
      end
      destroy
    end
  end

  private
    ATTRS_TO_COPY = ['subject_areas', 'funds_will_pay_for']
    def transfer_attributes_to_new_grant
      temp = dup.becomes Grant
      ATTRS_TO_COPY.map { |a| temp.send("#{a}=", attributes[a]) }
      temp.type = nil
      temp.remote_image_url = self.image_url :banner
      if temp.valid? then
        temp.save
        return temp
      else
        get_errors_and_destroy(temp)
      end
    end

    def get_errors_and_destroy(temp)
      temp.errors.messages.each { |attr, e| errors.add(attr, e[0]) }
      false
    end
end
