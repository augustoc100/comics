require 'rails_helper'

describe Infra::Gateways::MarvelGateway do
  context 'when searching for comics' do
    it 'delegates the request to the http client' do
      http_client = spy('http_client')
      url = 'some_url'

      described_class.new(http_client: http_client).find_all

      expect(http_client).to have_received(:get).with(url)
    end
  end
end
