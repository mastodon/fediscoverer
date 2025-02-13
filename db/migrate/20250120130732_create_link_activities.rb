class CreateLinkActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :link_activities do |t|
      t.references :link, null: false, foreign_key: true
      t.datetime :hour_of_activity, null: false
      t.integer :total_uses, null: false, default: 0
      t.integer :distinct_users, null: false, default: 0
      t.integer :shares, null: false, default: 0
      t.integer :likes, null: false, default: 0
      t.integer :replies, null: false, default: 0
      t.float :score, null: false, default: 0.0
      t.string :language

      t.timestamps
    end
    add_index :link_activities, [ :link_id, :hour_of_activity, :language ], unique: true
  end
end
