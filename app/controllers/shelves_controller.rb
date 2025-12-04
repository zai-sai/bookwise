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

  private

  def shelf_params
    params.require(:shelf).permit(:name, :id)
  end

  def set_shelf
    @shelf = Shelf.find(params[:id])
  end
end
