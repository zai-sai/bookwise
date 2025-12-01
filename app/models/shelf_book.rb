class ShelfBook < ApplicationRecord
  belongs_to :user_book
  belongs_to :shelf
end
