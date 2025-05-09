# This migration comes from fasp_base (originally 20250507143155)
class AddActiveToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :fasp_base_users, :active, :boolean, null: false, default: true
  end
end
