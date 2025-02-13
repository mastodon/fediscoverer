class CreateActors < ActiveRecord::Migration[8.0]
  def change
    create_table :actors do |t|
      t.references :server, null: false, foreign_key: true
      t.string :uri, null: false, index: { unique: true }
      t.string :actor_type, null: false, default: "Person"
      t.boolean :discoverable, null: false, default: false
      t.boolean :indexable, null: false, default: false
      t.text :description
      t.column :pg_text_search_configuration, :regconfig, null: false, default: "english"

      t.timestamps
    end
    add_index :actors, "to_tsvector(pg_text_search_configuration, description)", using: :gin, name: "actors_description_idx"
  end
end
