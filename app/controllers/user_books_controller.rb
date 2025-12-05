class UserBooksController < ApplicationController
  def index
    @user_books = current_user.user_books
    @shelves = current_user.shelves
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
    params.require(:user_book).permit(:status, :date_started, :date_finished, :rating)
  end
end
