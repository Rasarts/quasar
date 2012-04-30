class Article < ActiveRecord::Base
  attr_accessible :content, :description, :status, :title, :creator_id
    
  STATUSES= %w[ published moderated in_moderation in_work removed ]

  # validations
  validates :title,      presence: true
  validates :content,    presence: true
  validates :status,     presence: true, inclusion: { in: STATUSES }
  validates :creator_id, presence: true
  
  # associations
  belongs_to :creator, class_name: 'User'
  
  has_many :attachment_links, as: :master,     dependent: :destroy
  has_many :master_links,     as: :attachment, dependent: :destroy, class_name: "AttachmentLink"
  has_many :attachments, through: :attachment_links
  has_many :masters,     through: :attachment_links
  
  # def attach(attachment)
  #  attlink = self.attachment_links.new
  #  attlink.attachment = attachment
  #  attlink.save
  # end
end
