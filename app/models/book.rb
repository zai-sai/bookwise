class Book < ApplicationRecord
  has_many :user_books

  include PgSearch::Model

  pg_search_scope :search_by_title_and_author,
    against: [:title, :author],
    using: {
      tsearch: { prefix: true }  # allows searching with partial words
    }
end
