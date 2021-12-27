# frozen_string_literal: true

class Search
  attr_reader :current_page, :character_name

  def initialize(url, params)
    @url = url
    @current_page = params.fetch(:page, 1).to_i
    @character_name = params[:character_name]
  end

  def next_page
    prepare_url(@current_page + 1)
  end

  def previous_page
    new_page = @current_page.zero? ? 0 : @current_page - 1
    prepare_url(new_page)
  end

  private

  def prepare_url(page)
    "#{@url}?character_name=#{@character_name}&page=#{page}"
  end
end

class ComicsController < ApplicationController
  def index
    @search = Search.new('/', params)
    # @comics = [] #::Infra::Repositories::ComicsRepository.new.find_all(character_name: params[:character_name])
    @comics = ::Infra::Repositories::ComicsRepository.new.find_all(character_name: @search.character_name,
                                                                   page: @search.current_page)
  rescue SearchComicsError => e
    flash[:alert] = "error searching by #{params[:character_name]}"
    redirect_to root_path
  end
end
