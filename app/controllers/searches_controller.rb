class SearchesController < ApplicationController
  def index
    @current_query = "Sci-Fi"
    @results = ["The First Result", "Book result", "book", "a book", "A book", "Another book", "and another book", "another one"]
  end
end
