class Document < ActiveRecord::Base
  attr_accessible :content, :creator_id, :description, :title
  
  # validations
  validates :creator_id, presence: true
  validates :title,      presence: true
  
  # associations
  belongs_to :creator
  has_many :attachment_links, foreign_key: :master_id,     dependent: :destroy
  has_many :attachment_links, foreign_key: :attachment_id, dependent: :destroy
  has_many :attachments, through: :attachment_links
  has_many :masters,     through: :attachment_links
end
