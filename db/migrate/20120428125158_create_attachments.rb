class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string  :slave_document_type, null: false
      t.boolean :removable,           null: false, default: false
      t.string  :slave_document_id,   null: false
      t.string  :master_document_id,  null: false
    end
  end
end
