# frozen_string_literal: true

class SearchParameters
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
