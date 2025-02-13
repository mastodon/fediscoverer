# This migration comes from fasp_data_sharing (originally 20241211140048)
class CreateFaspDataSharingActors < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_data_sharing_actors do |t|
      t.text :private_key_pem, null: false

      t.timestamps
    end
  end
end
