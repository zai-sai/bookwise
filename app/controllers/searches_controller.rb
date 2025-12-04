class SearchesController < ApplicationController
  def index
    @current_query = "Sci-Fi"
    @results = Book.first(6)
    # @results = ["The First Result", "Book result", "book", "a book", "A book", "Another book", "and another book", "another one"]
    @shelves = ["All books", "Read", "Unread", "My epic novels shelf", "The Fifth Shelf", "Another shelf", "The Last Shelf"]
    @shelf_books = [0,1,2,3,4,5,6,7,8,9,10,11,12]

  end
end
