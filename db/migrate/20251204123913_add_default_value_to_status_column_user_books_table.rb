class AddDefaultValueToStatusColumnUserBooksTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_books, :status
    add_column :user_books, :status, :integer, default: 0, null: false
  end
end
