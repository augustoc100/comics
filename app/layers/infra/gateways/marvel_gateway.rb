# frozen_string_literal: true

class SearchComicsError < StandardError
end

module Infra
  module Gateways
    class MarvelGateway
      COMICS_URL = 'https://gateway.marvel.com:443/v1/public/comics?format=comic&formatType=comic&noVariants=false&orderBy=-focDate'
      CHAR_URL = 'https://gateway.marvel.com:443/v1/public/characters?name=deadpool&orderBy=name'
      DEFAULT_PAGE = 1
      ITEMS_PER_PAGE = 20

      def initialize(attributes = {})
        @http_client = attributes.fetch(:http_client, ::Infra::HttpClient.new)
        @comics_url = attributes.fetch(:comics_url, COMICS_URL)
        @char_url = attributes.fetch(:char_url, CHAR_URL)
        @ts = attributes.fetch(:ts, DateTime.now.to_i.to_s)
        @api_key = attributes.fetch(:api_key, '07e3e205bebd46de31d15ee9a76d85c2')
        @private_key = attributes.fetch(:private_key, 'cb116416e7b6451df4226e110970d61e15dcf22f')

        @hash = attributes.fetch(:hash, build_hash)
      end

      def find_all(character_name: '', page: DEFAULT_PAGE)
        if character_name.blank?
          comics_response = @http_client.get(@comics_url, prepare_parameters(page_parameters(page)))
        else
          char_response = @http_client.get(@char_url, prepare_parameters(name: character_name))
          char_data = char_response.fetch(:data).fetch(:results)[0]
          comics_response = @http_client.get(@comics_url, prepare_parameters(page_parameters(page).merge(characters: char_data[:id])))
        end

         comics_response.fetch(:data).fetch(:results)
      rescue StandardError => e
        raise SearchComicsError, e.message
      end

      private

      def page_parameters(page)
        page = page.to_i
        offset = (page - 1) * ITEMS_PER_PAGE
        {
          limit: ITEMS_PER_PAGE,
          offset: offset
        }
      end

      def prepare_parameters(custom_params = {})
        auth_parameters
          .merge(custom_params)
      end

      def auth_parameters
        {
          ts: @ts,
          apikey: @api_key,
          hash: @hash
        }
      end

      def build_hash
        ::Infra::EncryptionService.encrypt(@ts, @private_key, @api_key)
      end
    end
  end
end
