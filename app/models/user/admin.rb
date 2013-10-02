# == Schema Information
#
# Table name: user_admins
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User::Admin < ActiveRecord::Base
  # attr_accessible :title, :body
end
