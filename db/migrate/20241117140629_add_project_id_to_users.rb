class AddProjectIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :project, null: false, foreign_key: true
  end
end
