class AttachmentLink < ActiveRecord::Base
  attr_accessible :removable, :attachment_id, :attachment_type, :master_id, :master_type
  
  # validations
  validates :attachment_id,    presence: true
  validates :master_id,        presence: true   
  validates :attachment_type,  presence: true
  validates :master_type,      presence: true

  # associations
  belongs_to :master,      class_name: 'Document'
  belongs_to :attachment,  class_name: 'Document'
end
