# This migration comes from fasp_base (originally 20250508115122)
class CreateFaspBaseInvitationCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :fasp_base_invitation_codes do |t|
      t.string :code, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
