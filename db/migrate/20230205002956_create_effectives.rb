class CreateEffectives < ActiveRecord::Migration[7.0]
  def change
    create_table :effectives do |t|
      t.references :user, null: false, foreign_key: true
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end

    add_index :effectives, [:user_id, :comment_id], unique: true
  end
end
