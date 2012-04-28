class Attachment < ActiveRecord::Base
  attr_accessible :slave_document_type, :master_document_id, :removable, :slave_document_id
end
