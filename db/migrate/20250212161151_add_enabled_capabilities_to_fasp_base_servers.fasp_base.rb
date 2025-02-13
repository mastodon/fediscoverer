# This migration comes from fasp_base (originally 20250212113456)
class AddEnabledCapabilitiesToFaspBaseServers < ActiveRecord::Migration[8.0]
  def change
    add_column :fasp_base_servers, :enabled_capabilities, :json
  end
end
