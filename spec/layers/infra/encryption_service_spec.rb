# frozen_string_literal: true

require 'rails_helper'

describe Infra::EncryptionService do
  context 'when encrypt a list of parameters' do
    it 'returns a encrypted hash' do
      result = described_class.encrypt('foo', 'bar', 'baz')

      expect(result).to eq '6df23dc03f9b54cc38a0fc1483df6e21'
    end
  end
end
