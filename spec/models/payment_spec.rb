# == Schema Information
#
# Table name: payments
#
#  id           :integer          not null, primary key
#  amount       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  crowdfund_id :integer
#  charge_id    :string(255)
#

require 'spec_helper'

describe Payment do
  pending "add some examples to (or delete) #{__FILE__}"
end
