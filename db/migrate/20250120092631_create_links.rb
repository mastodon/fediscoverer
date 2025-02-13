class CreateLinks < ActiveRecord::Migration[8.0]
  def change
    create_table :links do |t|
      t.string :url, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
