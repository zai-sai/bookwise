class ShelfBook < ApplicationRecord
  belongs_to :user_book
  belongs_to :shelf

  delegate :book, :title, :author, :description, :image_link, :tag, to: :user_book
end
