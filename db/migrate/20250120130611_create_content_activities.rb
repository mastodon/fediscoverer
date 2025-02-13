class CreateContentActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :content_activities do |t|
      t.references :content_object, null: false, foreign_key: true
      t.datetime :hour_of_activity, null: false
      t.integer :shares, null: false, default: 0
      t.integer :likes, null: false, default: 0
      t.integer :replies, null: false, default: 0
      t.float :score, null: false, default: 0.0

      t.timestamps
    end
    add_index :content_activities, [ :content_object_id, :hour_of_activity ], unique: true
  end
end
