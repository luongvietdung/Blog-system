class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :body
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :entries, :users
    add_index :entries, [:user_id, :created_at]
  end
end
