class AddBlockedToServers < ActiveRecord::Migration[8.0]
  def change
    add_column :servers, :blocked, :boolean, null: false, default: false
  end
end
