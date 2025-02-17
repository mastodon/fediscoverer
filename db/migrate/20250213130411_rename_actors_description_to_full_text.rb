class RenameActorsDescriptionToFullText < ActiveRecord::Migration[8.0]
  def change
    rename_column :actors, :description, :full_text
  end
end
