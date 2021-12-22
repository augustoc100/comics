# frozen_string_literal: true

module Infra
  class HttpClient
    def initialize(http_adapter: Faraday)
      @http_adapter = http_adapter
    end

    def get(url)
      response = @http_adapter.get(url)

      parse_body(response)
    end

    private

    def parse_body(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
