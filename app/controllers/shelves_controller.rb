class ShelvesController < ApplicationController
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
  end

  private

  def shelf_params
    params.require(:shelf).permit(:name)
  end
end
