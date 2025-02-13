# This migration comes from fasp_base (originally 20241115111921)
class CreateFaspBaseServers < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_base_servers do |t|
      t.string :base_url, null: false, index: { unique: true }
      t.references :user, null: false

      t.timestamps
    end
    add_foreign_key :fasp_base_servers, :fasp_base_users, column: :user_id
  end
end
