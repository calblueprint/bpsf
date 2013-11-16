class RecipientProfile < ActiveRecord::Base
  attr_accessible :about, :image_url, :school_id, :recipient_id, :grade, :subject, :started_teaching
  belongs_to :recipient

  def years_teaching
    Date.today.year - self.started_teaching.year
  end
end
