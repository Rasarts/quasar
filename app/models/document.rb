class Document < ActiveRecord::Base
  attr_accessible :content, :creator_id, :description, :title
  
  # validations
  validates :creator_id, presence: true
  validates :title,      presence: true
  
  # associations
  belongs_to :creator
  has_many :attachments, dependent: :destroy, foreign_key: :master_document_id
  has_many :attachments, dependent: :destroy, foreign_key: :slave_document_id
  has_many :slave_documents,  through: :attachments
  has_many :master_documents, through: :attachments
end
