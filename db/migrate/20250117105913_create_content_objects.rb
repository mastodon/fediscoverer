class CreateContentObjects < ActiveRecord::Migration[8.0]
  def change
    create_table :content_objects do |t|
      t.references :actor, null: false, foreign_key: true
      t.string :uri, null: false, index: { unique: true }
      t.string :object_type, null: false
      t.datetime :published_at, null: false
      t.datetime :last_edited_at, null: false
      t.boolean :sensitive, null: false
      t.string :language
      t.integer :attached_images, null: false, default: 0
      t.integer :attached_videos, null: false, default: 0
      t.integer :attached_audio, null: false, default: 0
      t.integer :replies, null: false, default: 0
      t.integer :likes, null: false, default: 0
      t.integer :shares, null: false, default: 0
      t.text :full_text
      t.column :pg_text_search_configuration, :regconfig, null: false, default: "english"

      t.timestamps
    end
    add_index :content_objects, "to_tsvector(pg_text_search_configuration, full_text)", using: :gin, name: "content_objects_full_text_idx"
  end
end
