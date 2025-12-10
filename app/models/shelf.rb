class Shelf < ApplicationRecord
  belongs_to :user
  has_many :shelf_books, dependent: :destroy
  has_many :user_books, through: :shelf_books
  has_many :books, through: :shelf_books

  validates :name, presence: true
end
