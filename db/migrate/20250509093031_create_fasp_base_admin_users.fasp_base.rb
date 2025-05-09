# This migration comes from fasp_base (originally 20250507095511)
class CreateFaspBaseAdminUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_base_admin_users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest

      t.timestamps
    end
  end
end
