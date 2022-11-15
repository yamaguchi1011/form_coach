class AddColumnPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :body, :text, null: false
    add_reference :posts, :user, foreign_key: true
    change_column :posts, :video, :string, null: false
  end
end
