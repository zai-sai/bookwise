class Shelf < ApplicationRecord
  belongs_to :user
  has_many :shelf_books
end
