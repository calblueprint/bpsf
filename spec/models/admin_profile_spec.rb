# == Schema Information
#
# Table name: admin_profiles
#
#  id            :integer          not null, primary key
#  about         :string(255)
#  position      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  admin_id      :integer
#  super_user_id :integer
#

require 'spec_helper'

describe AdminProfile do
  pending "add some examples to (or delete) #{__FILE__}"
end
