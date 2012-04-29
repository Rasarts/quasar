class Article < ActiveRecord::Base
  attr_accessible :content, :description, :status, :title, :user_id
    
  STATUSES= %w[ published moderated in_moderation in_work removed ]

  # validations
  validates :title,   presence: true
  validates :content, presence: true
  validates :status,  presence: true, inclusion: { in: STATUSES }
  validates :user_id, presence: true
  
end
