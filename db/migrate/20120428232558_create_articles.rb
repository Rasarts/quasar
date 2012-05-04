class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string  :title,             null: false
      t.text    :description,       null: false, default: ''
      t.text    :content,           null: false
      t.string  :status,            null: false, default: 'in_work'
      t.integer :creator_id,        null: false
      t.integer :masters_count,     null: false, default: 0
      t.integer :attachments_count, null: false, default: 0
      
      t.timestamps
    end
  end
end
