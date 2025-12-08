class SearchesController < ApplicationController
  def index
    @current_query = params[:query]
    @shelves = current_user.shelves
    @api_key = ENV['OPENAI_API_KEY']

    @books =
    if @api_key.present?
      if @current_query.present?
        embed_query = RubyLLM.embed(@current_query)
        Book.nearest_neighbors(:embedding, embed_query.vectors, distance: "euclidean").first(2)
      else
        Book.all
      end
    else
      if @current_query.present?
        Book.search_by_title_and_author(@current_query)
      else
        Book.all
      end
    end
  end

  def create
    redirect_to searches_path(query: params[:query])
  end
end
