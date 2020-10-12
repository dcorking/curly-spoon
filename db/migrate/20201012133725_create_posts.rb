class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.datetime :expires
      t.date :valid_from

      t.timestamps
    end
  end
end
