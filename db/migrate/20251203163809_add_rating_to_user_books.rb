class AddRatingToUserBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :user_books, :rating, :integer
  end
end
