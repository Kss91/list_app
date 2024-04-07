class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :content
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
    add_index :lists, [:list_id, :created_at]
  end
end
