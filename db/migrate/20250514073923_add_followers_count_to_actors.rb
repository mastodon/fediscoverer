class AddFollowersCountToActors < ActiveRecord::Migration[8.0]
  def change
    add_column :actors, :followers_count, :integer, null: false, default: 0
  end
end
