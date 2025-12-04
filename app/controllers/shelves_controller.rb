class ShelvesController < ApplicationController
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

  def edit
    # Editing the name of one bookshelf
  end

  def show
    @shelf = Shelf.find(params[:id])
    @shelf_books = @shelf.shelf_books
  end

  private

  def shelf_params
    params.require(:shelf).permit(:name, :id)
  end
end
