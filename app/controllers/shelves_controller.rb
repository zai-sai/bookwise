class ShelvesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  def index
    @current_query = params[:query]
    @user_books = UserBook.where(user: current_user)
    @shelves = Shelf.where(user: current_user)
  end

  def new
    @shelf = Shelf.new
  end

  def create
    @shelf = Shelf.new(shelf_params)
    @shelf.user = current_user
    if params[:book_id].present?
      @book = Book.find(params[:book_id])
      user_books = UserBook.where(user: current_user)
      if user_books.include?(book: @book)
        @user_book = user_books.find(book: @book)
      else
        @user_book = UserBook.new(book: @book, user: current_user)
      end
      @shelf.shelf_books.build(user_book: @user_book)
    end
    if @shelf.save
      redirect_to shelf_path(@shelf), status: :see_other, notice: "#{@shelf.name} successfully created!"
    else
      render :new, status: :unprocessable_content
    end
  end

def add_to_collection
  shelf = Shelf.find(params[:shelf_id])
  book = Book.find(params[:book_id])
  user_book = current_user.user_books.find_or_create_by(book: book)
  shelf_book = ShelfBook.new(user_book: user_book, shelf: shelf)
  if shelf_book.save
    redirect_to shelf_path(shelf), notice: "#{book.title} added successfully!"
  else
    render error: "Sorry, unable to add book."
  end
end

  def edit
    set_shelf
  end

  def update
    set_shelf
    @shelf.update(shelf_params)
    redirect_to shelf_path(@shelf)
  end

  def show
    @shelf = Shelf.find(params[:id])
    @current_query = params[:query]
    if @current_query.present?
      @shelf_books = @shelf.shelf_books
      @book_ids = @shelf_books.map {|sb| sb.book.id }
      @books = Book.where(id: @book_ids)
      @books = @books.search_by_title_and_author(@current_query)
      @shelf_books = @shelf.shelf_books.select {|sb| @books.include?(sb.book) }
    else
      @shelf_books = @shelf.shelf_books
    end
  end

  def destroy
    set_shelf
    @shelf.destroy
    redirect_to shelves_path, status: :see_other
  end

  private

  def shelf_params
    params.require(:shelf).permit(:name, :id)
  end

  def set_shelf
    @shelf = Shelf.find(params[:id])
  end
end
