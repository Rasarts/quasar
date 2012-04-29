class Article < ActiveRecord::Base
  attr_accessible :content, :description, :status, :title, :creator_id
    
  STATUSES= %w[ published moderated in_moderation in_work removed ]

  # validations
  validates :title,      presence: true
  validates :content,    presence: true
  validates :status,     presence: true, inclusion: { in: STATUSES }
  validates :creator_id, presence: true
  
end
