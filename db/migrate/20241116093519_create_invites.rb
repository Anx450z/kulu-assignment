class CreateInvites < ActiveRecord::Migration[7.2]
  def change
    create_table :invites do |t|
      t.references :user, foreign_key: true
      t.integer :status, default: 0
      t.integer :role, default: 0
      t.string :email, null: false
      t.references :project, null: false, foreign_key: true
      t.timestamps
    end
    add_index :invites, [ :email, :project_id ], unique: true
  end
end
