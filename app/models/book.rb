class Book < ApplicationRecord
  has_many :user_books
  has_many :book_tags
  has_many :tags, through: :book_tags

  include PgSearch::Model

  pg_search_scope :search_by_title_and_author,
    against: [:title, :author],
    using: {
      tsearch: { prefix: true }  # allows searching with partial words
    }
end
