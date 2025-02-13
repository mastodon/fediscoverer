# This migration comes from fasp_data_sharing (originally 20241210105911)
class CreateFaspDataSharingSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_data_sharing_subscriptions do |t|
      t.references :fasp_base_server, null: false, foreign_key: true
      t.string :remote_id, null: false
      t.string :category, null: false
      t.string :subscription_type, null: false
      t.integer :max_batch_size
      t.integer :threshold_timeframe
      t.integer :threshold_shares
      t.integer :threshold_likes
      t.integer :threshold_replies

      t.timestamps
    end
  end
end
