# frozen_string_literal: true

class Search
  attr_reader :current_page, :character_name

  def initialize(url, params)
    @url = url
    @current_page = params.fetch(:page, 1).to_i
    @character_name = params.fetch(:character_name, '')
  end

  def next_page
    prepare_url(@current_page + 1)
  end

  def previous_page
    new_page = @current_page.zero? ? 0 : @current_page - 1
    prepare_url(new_page)
  end

  def current_url
    return "#{@url}?page=#{@current_page}" if @character_name.blank?

    "#{@url}?character_name=#{@character_name}&page=#{@current_page}"
  end

  private

  def prepare_url(page)
    "#{@url}?character_name=#{@character_name}&page=#{page}"
  end
end

class LikesRepository
  def initialize(cookies)
    @cookies = cookies
  end

  def save(comic_id, liked)
    comics_list = decoded_list
    comics_list[comic_id.to_s.to_sym] = liked.to_s == 'true'

    # @cookies[:likes] = {value: encode(comics_list), expires: 30 * 60}
    @cookies[:likes] = encode(comics_list)
  end

  def all
    decoded_list.symbolize_keys
  end

  private

  def decoded_list
    @decoded_list ||= JSON.parse(@cookies[:likes] || {}.to_s)
  end

  def encode(comics)
    JSON.dump(comics)
  end
end

class ComicsController < ApplicationController
  def index
    @search = Search.new('/', params)
    # @comics = [] #::Infra::Repositories::ComicsRepository.new.find_all(character_name: params[:character_name])
    comics = ::Infra::Repositories::ComicsRepository.new(like_repository: LikesRepository.new(cookies)).find_all(
      character_name: @search.character_name, page: @search.current_page
    )

    # likes = LikesRepository.new(cookies).all

    # comics.each do |c|
    #   c.set_like(likes[c.id.to_s.to_sym])
    # end

    @comics = comics
  rescue SearchComicsError => e
    flash[:alert] = "error searching by #{params[:character_name]}"
    redirect_to root_path
  end

  def create
    comic_id = params[:comic_id]
    liked = params[:liked]
    p comic_id, liked, params[:title]
    LikesRepository.new(cookies).save(comic_id, liked)

    p 'coockies'
    p LikesRepository.new(cookies).all

    redirect_to request.url
  end
end
