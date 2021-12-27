# frozen_string_literal: true

module Infra
  module Repositories
    class ComicsRepository
      IMAGE_SIZE = 'portrait_xlarge'

      def initialize(attributes = {})
        @marvel_gateway = attributes.fetch(:marvel_gateway, ::Infra::Gateways::MarvelGateway.new)
        @like_repository = attributes.fetch(:like_repository)
      end

      def find_all(character_name: '', page: 1)
        comics_data = @marvel_gateway.find_all(character_name: character_name, page: page)
        likes = @like_repository.all

        comics_data.map do |data|
          ::Domain::Comics.new(prepare_data(data, likes))
        end
      end

      private

      def prepare_data(response_data, likes)
        id = response_data.fetch(:id)
        {
          id: id,
          title: response_data.fetch(:title),
          date: response_data.fetch(:dates).find { _1[:type] == 'focDate'}[:date],
          image: adjust_image_path(response_data.fetch(:thumbnail)),
          liked: likes[id.to_s.to_sym]
        }
      end

      def adjust_image_path(image_path)
        "#{image_path[:path]}/#{IMAGE_SIZE}.#{image_path[:extension]}"
      end
    end
  end
end
