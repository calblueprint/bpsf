# == Schema Information
#
# Table name: user_recipients
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User::Recipient < ActiveRecord::Base
  # attr_accessible :title, :body
end
