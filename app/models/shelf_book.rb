class ShelfBook < ApplicationRecord
  belongs_to :user_book
  belongs_to :shelf

  delegate :title, :description, :author, :image_link, to: :user_book

end
