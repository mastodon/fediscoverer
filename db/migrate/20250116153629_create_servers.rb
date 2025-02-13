class CreateServers < ActiveRecord::Migration[8.0]
  def change
    create_table :servers do |t|
      t.string :domain_name, null: false, index: { unique: true }
      t.boolean :available, null: false, default: true
      t.datetime :last_queried_at
      t.integer :connection_failures, null: false, default: 0
      t.datetime :pause_until

      t.timestamps
    end
  end
end
