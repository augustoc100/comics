# frozen_string_literal: true

class ComicsController < ApplicationController
  def index
    @search = SearchParameters.new('/', params)
    @comics = ::Infra::Repositories::ComicsRepository.new(like_repository: like_repository).find_all(
      character_name: @search.character_name, page: @search.current_page
    )
  rescue SearchComicsError => e
    flash[:alert] = "error searching by #{params[:character_name]}"
    redirect_to root_path
  end

  def create
    comic_id = params[:comic_id]
    liked = params[:liked]

    like_repository.save(comic_id, liked)

    redirect_to request.url
  end

  private

  def like_repository
    ::Infra::Repositories::LikesRepository.new(cookies)
  end
end
