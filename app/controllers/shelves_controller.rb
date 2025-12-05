class ShelvesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @shelves = Shelf.all
    @shelf_books = current_user
  end

  def new
    @shelf = Shelf.new
  end

  def create
    @shelf = Shelf.new(shelf_params)
    @shelf.user = current_user
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
  # usersbooks = UserBook.where(user: current_user)
  # if usersbooks.include?(book: @book)
  #   @user_book = usersbooks.find(book: @book)
  # else
  #   @user_book = UserBook.new(@book, current_user)
  # end
  shelf_book = ShelfBook.new(user_book: user_book, shelf: shelf)
  if shelf_book.save
    redirect_to home_path
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
    set_shelf
    @shelf_books = @shelf.shelf_books
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
