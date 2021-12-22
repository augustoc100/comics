module Infra
  module Repositories
    class ComicsRepository
      def initialize(atributes)
        @marvel_gateway = atributes.fetch(:marvel_gateway, ::Infra::Gateways::MarvelGateway.new)
      end

      def find_all
        comics_data = @marvel_gateway.find_all

        comics_data.map do |data|
          ::Domain::Comics.new(prepare_data(data))
        end
      end

      private

      def prepare_data(response_data)
        {
          id: response_data.fetch(:id),
          title: response_data.fetch(:title),
          date: response_data.fetch(:dates).find { _1[:type] == 'onsaleDate'}[:date],
          image: adjust_image_path(response_data.fetch(:images).first)
        }
      end

      def adjust_image_path(image_path)
        image_path[:path] + '/portrait_xlarge.' + image_path[:extension]
      end
    end
  end
end
