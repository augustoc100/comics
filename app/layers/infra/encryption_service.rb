# frozen_string_literal: true

require 'digest'

module Infra
  class EncryptionService
    def self.encrypt(*params)
      Digest::MD5.hexdigest(params.join)
    end
  end
end
