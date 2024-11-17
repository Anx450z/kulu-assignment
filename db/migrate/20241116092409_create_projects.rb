class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.references :user, foreign_key: true
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
