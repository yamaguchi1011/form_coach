class ChangeCloumnsNotnullAddPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :video, :string, null: false
  end
end
