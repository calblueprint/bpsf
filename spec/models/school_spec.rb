# == Schema Information
#
# Table name: schools
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  donations_received :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe School do
  pending "add some examples to (or delete) #{__FILE__}"
end
