class CreateTasksUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks_users do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tasks_users, [:task_id, :user_id], unique: true
    add_index :tasks_users, [:user_id, :task_id]
  end
end
