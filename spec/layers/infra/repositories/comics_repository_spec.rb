require 'rails_helper'

describe Infra::Repositories::ComicsRepository do
  context 'when searching for comics' do
    it 'returns the first 20 comics ordered by creation date' do
      result = described_class.new.find_all

      expect(result).to eq 'foo'
    end
  end
end
