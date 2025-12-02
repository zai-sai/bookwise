class CreateUserBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :user_books do |t|
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status
      t.string :book_format
      t.date :date_started
      t.date :date_finished

      t.timestamps
    end
  end
end
