# frozen_string_literal: true
class CreateBookInfoCoverImages < ActiveRecord::Migration[5.0]
  def change
    create_table :book_info_cover_images do |t|
      t.string :isbn, limit: 32
      t.string :image
      t.integer :width
      t.integer :height

      t.timestamps
    end

    add_index :book_info_cover_images, :isbn
  end
end
