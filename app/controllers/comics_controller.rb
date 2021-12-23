# frozen_string_literal: true

class ComicsController < ApplicationController
  def index
    @comics = ::Infra::Repositories::ComicsRepository.new.find_all(character_name: params[:character_name])

  rescue SearchComicsError => e
    flash[:alert] = "error searching by #{params[:character_name]}"
    redirect_to root_path
  end
end
