class CreateShelfBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :shelf_books do |t|
      t.references :user_book, null: false, foreign_key: true
      t.references :shelf, null: false, foreign_key: true

      t.timestamps
    end
  end
end
