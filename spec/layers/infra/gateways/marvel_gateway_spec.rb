# frozen_string_literal: true

require 'rails_helper'

describe Infra::Gateways::MarvelGateway do
  context 'when searching for comics' do
    it 'delegates the request to the http client' do
      http_client = spy('http_client')
      url = 'some_url'
      hash = '6df23dc03f9b54cc38a0fc1483df6e21'
      ts = 'foo'
      private_key = 'bar'
      api_key = 'baz'

      described_class.new(
        http_client: http_client,
        comics_url: url,
        ts: ts,
        private_key: private_key,
        api_key: api_key
      ).find_all
      params = { ts: ts, apikey: api_key, hash: hash }
      expect(http_client).to have_received(:get).with(url, hash_including(params))
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

    context 'when receiving the character name' do
      it 'calls the character api and pass the char id to the comics call' do
        http_client = spy('http_client')
        char_name = 'deadpool'
        full_response = build_full_response
        comics_url = 'comics_url'
        char_url = 'char_url'
        first_char_id = 111_222_333
        char_result = build_char_result(first_char_id)
        hash = '6df23dc03f9b54cc38a0fc1483df6e21'
        ts = 'foo'
        private_key = 'bar'
        api_key = 'baz'
        params = { ts: ts, apikey: api_key, hash: hash }
        allow(http_client).to receive(:get).with(char_url, params.merge(name: char_name)).and_return(char_result)
        allow(http_client).to receive(:get).with(comics_url,
                                                 params.merge(characters: first_char_id, limit: 20, offset: 0)).and_return(build_full_response)
        result = described_class.new(
          http_client: http_client,
          comics_url: comics_url,
          char_url: char_url,
          ts: ts,
          private_key: private_key,
          api_key: api_key
        ).find_all(character_name: char_name)

        expect(http_client).to have_received(:get).with(comics_url, params.merge(characters: first_char_id, limit: 20, offset: 0))
      end
    end

    context 'when receiving the page number' do
      it 'calls the character api and pass the page number' do
        http_client = spy('http_client')
        full_response = build_full_response
        comics_url = 'comics_url'
        first_char_id = 111_222_333
        char_result = build_char_result(first_char_id)
        hash = '6df23dc03f9b54cc38a0fc1483df6e21'
        ts = 'foo'
        private_key = 'bar'
        api_key = 'baz'
        params = { ts: ts, apikey: api_key, hash: hash }
        allow(http_client).to receive(:get).and_return(build_full_response)
        result = described_class.new(
          http_client: http_client,
          comics_url: comics_url,
          ts: ts,
          private_key: private_key,
          api_key: api_key
        ).find_all(page: 2)

        pagination_params = {
          limit: 20,
          offset: 20
        }
        expected_params =  params.merge(pagination_params)
        expect(http_client).to have_received(:get).with(comics_url,expected_params)
      end
    end
  end

  def build_char_result(id = 1_009_268)
    {
      "code": 200,
      "status": 'Ok',
      "copyright": '© 2021 MARVEL',
      "attributionText": 'Data provided by Marvel. © 2021 MARVEL',
      "attributionHTML": '<a href="http://marvel.com">Data provided by Marvel. © 2021 MARVEL</a>',
      "etag": '74dadabfd9c324e56b932a0015d3811282a73e9b',
      "data": {
        "offset": 0,
        "limit": 20,
        "total": 1,
        "count": 1,
        "results": [
          {
            "id": id,
            "name": 'Deadpool'
          },
          {
            "id": 1234,
            "name": 'Deadpool2'
          }
        ]
      }
    }
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
