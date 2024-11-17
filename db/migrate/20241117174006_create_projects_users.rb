class CreateProjectsUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :projects_users, id: false do |t|
      t.belongs_to :project
      t.belongs_to :user
    end
    add_index :projects_users, [ :project_id, :user_id ], unique: true
  end
end
