# This migration comes from fasp_base (originally 20250508125745)
class CreateFaspBaseSettings < ActiveRecord::Migration[8.0]
  def up
    create_table :fasp_base_settings do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :value

      t.timestamps
    end
    FaspBase::Setting.create!(name: "registration", value: "open")
  end

  def down
    drop_table :fasp_base_settings
  end
end
