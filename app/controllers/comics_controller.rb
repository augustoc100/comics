# frozen_string_literal: true

class ComicsController < ApplicationController
  def index
    @comics = ::Infra::Repositories::ComicsRepository.new.find_all(character_name: params[:character_name])
  end
end
