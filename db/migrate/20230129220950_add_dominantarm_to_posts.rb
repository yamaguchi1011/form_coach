class AddDominantarmToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :dominant_arm, :string, null: false
  end
end
