class AddBlockedToActors < ActiveRecord::Migration[8.0]
  def change
    add_column :actors, :blocked, :boolean, null: false, default: false
  end
end
