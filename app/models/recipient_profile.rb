class RecipientProfile < ActiveRecord::Base
  attr_accessible :about, :image_url, :school_id, :recipient_id
  belongs_to :recipient
end
