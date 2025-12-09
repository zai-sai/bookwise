class UserBooksController < ApplicationController
  def index
    @current_query = params[:query]
    @shelves = current_user.shelves
    @user_books = current_user.user_books
    @featured_shelves = @shelves.limit(6)
    if @current_query.present?
      @book_ids = @user_books.map { |ub| ub.book.id }
      @books = Book.where(id: @book_ids)
      @books = @books.search_by_title_and_author(@current_query)
      @user_books = current_user.user_books.select {|ub| @books.include?(ub.book) }
    else
      @user_books = current_user.user_books
    end
  end

  def edit
    @user_book = current_user.user_books.find(params[:id])
  end

  def update
    @user_book = current_user.user_books.find(params[:id])
    if @user_book.update(user_book_params)
      redirect_to user_books_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def add_to_library
    book = Book.find(params[:book_id])
    user_book = current_user.user_books.find_or_create_by(book: book)
    user_books = UserBook.where(user: current_user)
    if user_books.include?(book: @book)
      flash[:notice] = "This books is already part of your library!"

    else
      @user_book = UserBook.new(book: @book, user: current_user)
      if user_book.save
        flash[:notice] = "Book added successfully!"
        redirect_to user_books_path
      else
        flash[:alert] = "Sorry, unable to add this book to your library."

      end
    end
  end

  private

  def user_book_params
    params.require(:user_book).permit(:status, :date_started, :date_finished, :rating)
  end
end
