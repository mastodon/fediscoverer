class AddIndexesToActivities < ActiveRecord::Migration[8.1]
  def change
    add_index :content_activities, :hour_of_activity
    add_index :hashtag_activities, [ :hour_of_activity, :language ]
    add_index :link_activities, [ :hour_of_activity, :language ]
  end
end
