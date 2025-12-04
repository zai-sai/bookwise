class ShelfBooksController < ApplicationController

# Add a book to my shelf at a later date (POST)
# Remove a book from my shelf at a later date (DELETE)

  def destroy
    # Removing a book from users shelf
    shelf_book = ShelfBook.find(params[:id])
    @shelf = shelf_book.shelf
    shelf_book.destroy
    redirect_to edit_shelf_path(@shelf), status: :see_other
  end

    private

    def shelf_book_params
      params.require(:shelf_book).permit(:book_id)
    end
end
