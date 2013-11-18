# == Schema Information
#
# Table name: crowdfunds
#
#  id            :integer          not null, primary key
#  deadline      :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  goal          :integer
#  pledged_total :integer
#  grant_id      :integer
#

require 'spec_helper'

describe Crowdfund do
  pending "add some examples to (or delete) #{__FILE__}"
end
