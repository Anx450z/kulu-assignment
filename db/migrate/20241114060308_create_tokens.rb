class CreateTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :tokens do |t|
      t.references :user, foreign_key: true
      t.string :content, null: false, default: ""
      t.integer :active_status, default: 0

      t.timestamps
    end
    add_index :tokens, :content,  unique: true
  end
end
