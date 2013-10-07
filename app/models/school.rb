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

class School < ActiveRecord::Base
  attr_accessible :district, :donations_received, :name
end
