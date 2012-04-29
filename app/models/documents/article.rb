class Article < ActiveRecord::Base
  attr_accessible :content, :description, :status, :title, :creator_id
    
  STATUSES= %w[ published moderated in_moderation in_work removed ]

  # validations
  validates :title,      presence: true
  validates :content,    presence: true
  validates :status,     presence: true, inclusion: { in: STATUSES }
  validates :creator_id, presence: true
  
  # associations
  has_many :attachment_links, as: :master,     dependent: :destroy
  has_many :attachment_links, as: :attachment, dependent: :destroy
  has_many :attachments, through: :attachment_links
  has_many :masters,     through: :attachment_links
end
