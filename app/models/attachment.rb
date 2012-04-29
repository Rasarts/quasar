class Attachment < ActiveRecord::Base
  attr_accessible :removable, :slave_document_id, :slave_document_type, :master_document_id
  
  # validations
  validates :slave_document_id,    presence: true
  validates :master_document_id,   presence: true   
  validates :slave_document_type,  presence: true
  validates :master_document_type, presence: true

  # associations
  belongs_to :master_document, class_name: 'Document'
  belongs_to :slave_document,  class_name: 'Document'
end
