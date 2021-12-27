# frozen_string_literal: true

module Infra
  module Repositories
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
  end
end
