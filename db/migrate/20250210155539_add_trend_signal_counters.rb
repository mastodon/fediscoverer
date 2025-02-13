class AddTrendSignalCounters < ActiveRecord::Migration[8.0]
  def change
    add_column :content_objects, :trend_signals, :integer, null: false, default: 0
    add_column :content_activities, :trend_signals, :integer, null: false, default: 0
    add_column :hashtag_activities, :trend_signals, :integer, null: false, default: 0
    add_column :link_activities, :trend_signals, :integer, null: false, default: 0
  end
end
