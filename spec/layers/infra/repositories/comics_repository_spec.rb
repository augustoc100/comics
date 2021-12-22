require 'rails_helper'

describe Infra::Repositories::ComicsRepository do
  context 'when searching for comics' do
    it 'returns the first 20 comics ordered by creation date' do
      marvel_gateway = instance_double('marvel_gateway')
      response = build_response
      allow(marvel_gateway).to receive(:find_all).and_return(response)
      comics = described_class.new(marvel_gateway: marvel_gateway).find_all

      comic = comics.first
      expect(comics.size).to eq 1
      expect(comic.id).to eq 1961
      expect(comic.title).to eq 'Punisher: The Cell (2005) #1'
      expect(comic.date).to eq Date.parse('2005-05-11')
      expect(comic.image_path).to eq 'http://i.annihil.us/u/prod/marvel/i/mg/b/e0/4bc63cb71c42e/portrait_xlarge.jpg'
    end
  end

  def build_response
    JSON.parse([
      {
        "id": 1961,
        "digitalId": 0,
        "title": 'Punisher: The Cell (2005) #1',
        "issueNumber": 1,
        "variantDescription": '',
        "description": "From the darkest bowels of Riker's prison, the old men preside over their empire.  Nothing goes down without their say-so; no one draws a breath without their permission.   And when a riot explodes, they need only fortify their defenses and ride it out.  But someone else is weaving his way through the bloodstained halls, their newest neighbor: Frank Castle.\r<br>56 PGS./Parental Advisory ...$4.99\r<br>",
        "modified": '-0001-11-30T00:00:00-0500',
        "isbn": '',
        "upc": '5960605626-00111',
        "diamondCode": '',
        "ean": '',
        "issn": '',
        "format": 'Comic',
        "pageCount": 0,
        "textObjects": [
          {
            "type": 'issue_solicit_text',
            "language": 'en-us',
            "text": "From the darkest bowels of Riker's prison, the old men preside over their empire.  Nothing goes down without their say-so; no one draws a breath without their permission.   And when a riot explodes, they need only fortify their defenses and ride it out.  But someone else is weaving his way through the bloodstained halls, their newest neighbor: Frank Castle.\r<br>56 PGS./Parental Advisory ...$4.99\r<br>"
          }
        ],
        "resourceURI": 'http://gateway.marvel.com/v1/public/comics/1961',
        "urls": [
          {
            "type": 'detail',
            "url": 'http://marvel.com/comics/issue/1961/punisher_the_cell_2005_1?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0'
          }
        ],
        "series": {
          "resourceURI": 'http://gateway.marvel.com/v1/public/series/815',
          "name": 'Punisher: The Cell (2005)'
        },
        "variants": [],
        "collections": [],
        "collectedIssues": [],
        "dates": [
          {
            "type": 'onsaleDate',
            "date": '2005-05-11T00:00:00-0400'
          },
          {
            "type": 'focDate',
            "date": '-0001-11-30T00:00:00-0500'
          }
        ],
        "prices": [
          {
            "type": 'printPrice',
            "price": 4.99
          }
        ],
        "thumbnail": {
          "path": 'http://i.annihil.us/u/prod/marvel/i/mg/b/e0/4bc63cb71c42e',
          "extension": 'jpg'
        },
        "images": [
          {
            "path": 'http://i.annihil.us/u/prod/marvel/i/mg/b/e0/4bc63cb71c42e',
            "extension": 'jpg'
          }
        ],
        "creators": {
          "available": 6,
          "collectionURI": 'http://gateway.marvel.com/v1/public/comics/1961/creators',
          "items": [
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/creators/1',
              "name": 'Tim Bradstreet',
              "role": 'penciller (cover)'
            },
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/creators/8635',
              "name": 'Vc Randy Gentile',
              "role": 'letterer'
            },
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/creators/486',
              "name": 'Scott Koblish',
              "role": 'inker'
            },
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/creators/549',
              "name": 'Lewis Larosa',
              "role": 'penciller'
            },
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/creators/30',
              "name": 'Stan Lee',
              "role": 'writer'
            },
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/creators/670',
              "name": 'Raul Trevino',
              "role": 'colorist'
            }
          ],
          "returned": 6
        },
        "characters": {
          "available": 0,
          "collectionURI": 'http://gateway.marvel.com/v1/public/comics/1961/characters',
          "items": [],
          "returned": 0
        },
        "stories": {
          "available": 2,
          "collectionURI": 'http://gateway.marvel.com/v1/public/comics/1961/stories',
          "items": [
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/stories/4155',
              "name": '1 of 1',
              "type": 'cover'
            },
            {
              "resourceURI": 'http://gateway.marvel.com/v1/public/stories/4156',
              "name": '1 of 1',
              "type": 'interiorStory'
            }
          ],
          "returned": 2
        },
        "events": {
          "available": 0,
          "collectionURI": 'http://gateway.marvel.com/v1/public/comics/1961/events',
          "items": [],
          "returned": 0
        }
      }
    ].to_json, symbolize_names: true)
  end
end
