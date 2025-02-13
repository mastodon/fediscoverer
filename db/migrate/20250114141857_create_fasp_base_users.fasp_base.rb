# This migration comes from fasp_base (originally 20241115111858)
class CreateFaspBaseUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_base_users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest

      t.timestamps
    end
  end
end
