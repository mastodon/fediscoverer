class AddRecommendedToActors < ActiveRecord::Migration[8.0]
  def change
    add_column :actors, :recommended, :boolean, null: false, default: false
  end
end
