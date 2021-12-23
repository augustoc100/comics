# frozen_string_literal: true

require 'rails_helper'

describe Infra::Repositories::ComicsRepository do
  context 'when searching for comics' do
    it 'returns the comics found' do
      marvel_gateway = instance_double('marvel_gateway')
      response = build_response
      allow(marvel_gateway).to receive(:find_all).and_return(response)
      comics = described_class.new(marvel_gateway: marvel_gateway).find_all

      comic = comics.first
      expect(comics.size).to eq 1
      expect(comic.id).to eq 1961
      expect(comic.title).to eq 'Punisher: The Cell (2005) #1'
      expect(comic.date).to eq Date.parse('2006-05-11')
      expect(comic.image_path).to eq 'http://i.annihil.us/u/prod/marvel/i/mg/b/e0/4bc63cb71c42e/portrait_xlarge.jpg'
    end

    context 'when receiving the character name' do
      it 'delegates the the char name to the gateway' do
        marvel_gateway = spy('marvel_gateway')
        character_name = 'deadpool'
        response = build_response
        allow(marvel_gateway).to receive(:find_all).and_return(response)
        comics = described_class.new(marvel_gateway: marvel_gateway).find_all(character_name: character_name)

        expect(marvel_gateway).to have_received(:find_all).with(character_name: character_name)
      end
    end
  end

  def build_response
    JSON.parse([
      {
        "id": 1961,
        "title": 'Punisher: The Cell (2005) #1',
        "dates": [
          {
            "type": 'onsaleDate',
            "date": '2005-05-11T00:00:00-0400'
          },
          {
            "type": 'focDate',
            "date": '2006-05-11T00:00:00-0400'
          }
        ],
        "thumbnail": {
          "path": 'http://i.annihil.us/u/prod/marvel/i/mg/b/e0/4bc63cb71c42e',
          "extension": 'jpg'
        }
      }
    ].to_json, symbolize_names: true)
  end
end
