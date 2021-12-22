module Infra
  module Gateways
    class MarvelGateway
      def initialize(http_client: ::Infra::HttpClient)
        @http_client = http_client
        @url = 'some_url'
      end

      def find_all
        @http_client.get(@url)
      end
    end
  end
end
