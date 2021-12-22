# frozen_string_literal: true

class ComicsController < ApplicationController
  def index
    @comics = ::Infra::Repositories::ComicsRepository.new.find_all
  end
end
