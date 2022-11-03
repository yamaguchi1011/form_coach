class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :video
      t.text :body
      t.decimal :angle
      t.string :image
      t.integer :pitching_form

      t.timestamps
    end
  end
end
