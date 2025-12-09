class ShelfBook < ApplicationRecord
  belongs_to :user_book
  belongs_to :shelf

  delegate :book, :title, :author, :description, :image_link, :tag, :status, to: :user_book

  include PgSearch::Model

  pg_search_scope :search_by_title_and_author,
  against: [:title, :author],
  using: {
    tsearch: { prefix: true }  # allows searching with partial words
  }

end
