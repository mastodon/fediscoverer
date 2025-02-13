# This migration comes from fasp_base (originally 20241118142403)
class AddKeypairAndServerInfoToServers < ActiveRecord::Migration[8.0]
  def change
    add_column :fasp_base_servers, :fasp_private_key_pem, :string, null: false
    add_column :fasp_base_servers, :fasp_remote_id, :string
    add_column :fasp_base_servers, :public_key_pem, :string
    add_column :fasp_base_servers, :registration_completion_uri, :string
  end
end
