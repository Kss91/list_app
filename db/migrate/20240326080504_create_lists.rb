class CreateLists < ActiveRecord::Migration[7.0]
  def change
    create_table :lists do |t|
      t.string :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :lists, [:user_id, :created_at]
  end
end
