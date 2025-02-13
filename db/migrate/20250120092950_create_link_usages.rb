class CreateLinkUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :link_usages do |t|
      t.references :content_object, null: false, foreign_key: true
      t.references :link, null: false, foreign_key: true

      t.timestamps
    end
    add_index :link_usages, [ :content_object_id, :link_id ], unique: true
  end
end
