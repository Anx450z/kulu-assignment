class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, limit: 255
      t.text :description
      t.references :project, null: false, foreign_key: true
      t.datetime :completed_at
      t.datetime :due_date

      t.timestamps
    end

    add_index :tasks, [:project_id, :completed_at]
  end
end
