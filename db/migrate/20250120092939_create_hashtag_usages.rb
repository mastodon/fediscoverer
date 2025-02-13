class CreateHashtagUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :hashtag_usages do |t|
      t.references :content_object, null: false, foreign_key: true
      t.references :hashtag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :hashtag_usages, [ :content_object_id, :hashtag_id ], unique: true
  end
end
