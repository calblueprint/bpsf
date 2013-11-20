# == Schema Information
#
# Table name: recipient_profiles
#
#  id               :integer          not null, primary key
#  school_id        :integer
#  image_url        :string(255)
#  about            :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipient_id     :integer
#  started_teaching :datetime
#  subject          :string(255)
#  grade            :string(255)
#

require 'spec_helper'

describe RecipientProfile do
  pending "add some examples to (or delete) #{__FILE__}"
end
