class ShelfBooksController < ApplicationController

  # TODO: Adding a book to my shelf at a later date (create route already in routes)
  def create
  end

  # Removing a book from my shelf at a later date:
  def destroy
    @shelf_book = ShelfBook.find(params[:id])
    @shelf = @shelf_book.shelf
    @shelf_book.destroy
    redirect_to @shelf, notice: "Book successfully removed from your shelf!", status: :see_other
  end

  private

  def shelf_book_params
    params.require(:shelf_book).permit(:book_id)
  end

end
