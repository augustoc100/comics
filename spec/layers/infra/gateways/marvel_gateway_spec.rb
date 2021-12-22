# frozen_string_literal: true

require 'rails_helper'

describe Infra::Gateways::MarvelGateway do
  context 'when searching for comics' do
    it 'delegates the request to the http client' do
      http_client = spy('http_client')
      url = 'some_url'

      described_class.new(http_client: http_client).find_all

      expect(http_client).to have_received(:get).with(url)
    end

    it 'returns only the result data' do
      http_client = spy('http_client')
      result_data = [
        { title: 'title1', id: 1 },
        { title: 'title2', id: 2 },
        { title: 'title3', id: 3 }
      ]
      full_response = build_full_response(result_data)
      allow(http_client).to receive(:get).and_return(full_response)

      result = described_class.new(http_client: http_client).find_all

      expect(result).to eq result_data
    end
  end

  def build_full_response(result_data = [{ foo: 'foo' }])
    {
      "code": 200,
      "status": 'Ok',
      "copyright": '© 2021 MARVEL',
      "attributionText": 'Data provided by Marvel. © 2021 MARVEL',
      "attributionHTML": '<a href="http://marvel.com">Data provided by Marvel. © 2021 MARVEL</a>',
      "etag": '92fbc57b2e0ae8bb3f17329a80caba29c760e2f7',
      "data": {
        "offset": 0,
        "limit": 20,
        "total": 34_100,
        "count": 20,
        "results": result_data
      }
    }
  end
end
