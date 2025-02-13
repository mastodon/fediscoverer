# This migration comes from fasp_data_sharing (originally 20241211094856)
class CreateFaspDataSharingBackfillRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_data_sharing_backfill_requests do |t|
      t.references :fasp_base_server, null: false, foreign_key: true
      t.string :remote_id, null: false
      t.string :category, null: false
      t.integer :max_count
      t.string :cursor

      t.timestamps
    end
  end
end
