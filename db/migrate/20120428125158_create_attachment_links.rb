class CreateAttachmentLinks < ActiveRecord::Migration
  def change
    create_table :attachment_links do |t|
      t.string   :attachment_type,  null: false
      t.string   :master_type,      null: false
      t.boolean  :removable,        null: false, default: false
      t.integer  :attachment_id,    null: false
      t.integer  :master_id,        null: false
    end
  end
end
