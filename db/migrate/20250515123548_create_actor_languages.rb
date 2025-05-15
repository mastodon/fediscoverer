class CreateActorLanguages < ActiveRecord::Migration[8.0]
  def change
    create_table :actor_languages do |t|
      t.references :actor, null: false, foreign_key: true
      t.string :language, null: false

      t.timestamps
    end
    add_index :actor_languages, [ :actor_id, :language ], unique: true
  end
end
