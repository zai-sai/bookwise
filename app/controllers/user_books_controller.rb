class UserBooksController < ApplicationController
  def index
    @user_books = current_user.books
  end

  def edit
    @user_book = current_user.books.find(params[:id])
  end

  def update
    @user_book = current_user.books.find(params[:id])
    if @user_book.update(user_book_params)
      redirect_to user_books_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_book_params
    params.require(:book).permit(:title, :author, :rating)
  end
end
