class SearchesController < ApplicationController
  def index
<<<<<<< HEAD
    @current_query = params[:query]
    @shelves = current_user.shelevs

    @books =
    if @current_query.present?
      Book.search_by_title_and_author(@query)
    else
      []
    end
  end

  def create
    redirect_to searches_path(query: params[:query])
  end
end
