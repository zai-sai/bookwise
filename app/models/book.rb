class Book < ApplicationRecord
  has_many :user_books
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags
  has_neighbors :embedding
  after_create :set_embedding

  include PgSearch::Model

  pg_search_scope :search_by_title_and_author,
    against: [:title, :author],
    using: {
      tsearch: { prefix: true }  # allows searching with partial words
    }

  private

  def set_embedding
    embedding = RubyLLM.embed("Title: #{title}. Author: #{author}. Tags: #{tags.pluck(:name).join(", ")}. Description: #{description}. ")
    update(embedding: embedding.vectors)
  end
end
