# == Schema Information
#
# Table name: grants
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  organization :string(255)
#  sum          :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  type         :string(255)
#

class LargeGrant < Grant
  
end
