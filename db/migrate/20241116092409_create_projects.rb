class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.references :user, foreign_key: true
      t.integer :owner_id, null: false
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
