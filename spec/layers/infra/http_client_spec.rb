# frozen_string_literal: true

require 'rails_helper'

describe Infra::HttpClient do
  context 'when making a request' do
    it 'delegates the request to the http_adapter' do
      http_adapter = spy('adapter')
      url = 'some_url'
      response = build_response
      allow(http_adapter).to receive(:get).and_return(response)
      described_class.new(http_adapter: http_adapter).get(url)

      expect(http_adapter).to have_received(:get).with(url, params = {}, headers = {})
    end

    it 'tranforms the response into a symbolized hash' do
      url = 'some_url'
      response_body = { 'foo': 'foo', 'bar': 'bar' }
      response = build_response(response_body)
      http_adapter = double('adapter')
      allow(http_adapter).to receive(:get).and_return(response)

      result = described_class.new(http_adapter: http_adapter).get(url)

      expect(result).to eq response_body.symbolize_keys
    end
  end

  def build_response(_response_body = { 'foo': 'foo', 'bar': 'bar' })
    result_body = { 'foo': 'foo', 'bar': 'bar' }
    result = double('result', body: result_body.to_json)
  end
end
