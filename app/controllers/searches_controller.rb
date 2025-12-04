class SearchesController < ApplicationController
  def index
    @query = params[:query]

    @books =
    if @query.present?
      Book.search_by_title_and_author(@query)
    else
      []
    end
  end

  def create
    redirect_to searches_path(query: params[:query])
  end
end
