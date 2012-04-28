class Document < ActiveRecord::Base
  attr_accessible :content, :creator_id, :description, :title
  
  # validations
  validates :creator_id, presence: true
  validates :title,      presence: true
  
  # associations
  belongs_to :creator
end
