# This migration comes from fasp_data_sharing (originally 20250103141700)
class ReplaceCursorWithFulfilledFlag < ActiveRecord::Migration[8.0]
  def change
    remove_column :fasp_data_sharing_backfill_requests, :cursor, :string
    add_column :fasp_data_sharing_backfill_requests, :fulfilled, :boolean, null: false, default: false
  end
end
