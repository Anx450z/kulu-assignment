class CreateInvites < ActiveRecord::Migration[7.2]
  def change
    create_table :invites do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, default: 0
      t.integer :role, default: 0

      t.timestamps
    end

    add_index :invites, [ :project_id, :user_id ], unique: true
  end
end
