# frozen_string_literal: true

require 'digest'

module Infra
  module Gateways
    class MarvelGateway
      URL = 'https://gateway.marvel.com:443/v1/public/comics?format=comic&formatType=comic&noVariants=false&orderBy=-focDate'

      def initialize(attributes = {})
        @http_client = attributes.fetch(:http_client, ::Infra::HttpClient.new)
        @url = attributes.fetch(:url, URL)
        @ts = attributes.fetch(:ts, DateTime.now.to_i.to_s)
        @api_key = attributes.fetch(:api_key, '07e3e205bebd46de31d15ee9a76d85c2')
        @private_key = attributes.fetch(:private_key, 'cb116416e7b6451df4226e110970d61e15dcf22f')

        @hash = attributes.fetch(:hash, build_hash)
      end

      def find_all
        result = @http_client.get(prepare_url)

        data = result.fetch(:data).fetch(:results)
      end

      private

      def build_hash
        ::Infra::EncryptionService.encrypt(@ts, @private_key, @api_key)
      end

      def prepare_url
        "#{@url}&ts=#{@ts}&apikey=#{@api_key}&hash=#{@hash}"
      end

      # def result
      # JSON.parse(
      #     [
      #         {
      #             "id": 1961,
      #             "digitalId": 0,
      #             "title": "Punisher: The Cell (2005) #1",
      #             "issueNumber": 1,
      #             "variantDescription": "",
      #             "description": "From the darkest bowels of Riker's prison, the old men preside over their empire.  Nothing goes down without their say-so; no one draws a breath without their permission.   And when a riot explodes, they need only fortify their defenses and ride it out.  But someone else is weaving his way through the bloodstained halls, their newest neighbor: Frank Castle.\r<br>56 PGS./Parental Advisory ...$4.99\r<br>",
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "5960605626-00111",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "From the darkest bowels of Riker's prison, the old men preside over their empire.  Nothing goes down without their say-so; no one draws a breath without their permission.   And when a riot explodes, they need only fortify their defenses and ride it out.  But someone else is weaving his way through the bloodstained halls, their newest neighbor: Frank Castle.\r<br>56 PGS./Parental Advisory ...$4.99\r<br>"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/1961",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/1961/punisher_the_cell_2005_1?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/815",
      #                 "name": "Punisher: The Cell (2005)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "2005-05-11T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 4.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/e0/4bc63cb71c42e",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/e0/4bc63cb71c42e",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 6,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/1961/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1",
      #                         "name": "Tim Bradstreet",
      #                         "role": "penciller (cover)"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/8635",
      #                         "name": "Vc Randy Gentile",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/486",
      #                         "name": "Scott Koblish",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/549",
      #                         "name": "Lewis Larosa",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/30",
      #                         "name": "Stan Lee",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/670",
      #                         "name": "Raul Trevino",
      #                         "role": "colorist"
      #                     }
      #                 ],
      #                 "returned": 6
      #             },
      #             "characters": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/1961/characters",
      #                 "items": [],
      #                 "returned": 0
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/1961/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/4155",
      #                         "name": "1 of 1",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/4156",
      #                         "name": "1 of 1",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/1961/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 2502,
      #             "digitalId": 0,
      #             "title": "Marvel Milestones (2005) #8",
      #             "issueNumber": 8,
      #             "variantDescription": "",
      #             "description": "His name is...Blade! A box-office phenom is born as the half-human, half-immortal vampire-slayer begins his quest to take back the night in TOMB OF DRACULA #10 (July 1973)! Plus: What evil lurks in the brackish waters of the swamp? See for yourself in ADVENTURE INTO FEAR #16 (September 1973), the story that inspired the MAN-THING movie! And introducing Satana, from VAMPIRE TALES #2 (October 1973).\r<br>\r<br>48 PGS./T+ SUGGESTED FOR TEENS AND UP ...$3.99\r<br>",
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "75960605721400811",
      #             "diamondCode": "AUG051930",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "His name is...Blade! A box-office phenom is born as the half-human, half-immortal vampire-slayer begins his quest to take back the night in TOMB OF DRACULA #10 (July 1973)! Plus: What evil lurks in the brackish waters of the swamp? See for yourself in ADVENTURE INTO FEAR #16 (September 1973), the story that inspired the MAN-THING movie! And introducing Satana, from VAMPIRE TALES #2 (October 1973).\r<br>\r<br>48 PGS./T+ SUGGESTED FOR TEENS AND UP ...$3.99\r<br>"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/2502",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/2502/marvel_milestones_2005_8?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/901",
      #                 "name": "Marvel Milestones (2005 - 2007)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "2005-10-12T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/90/4bc61eedd349f",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/90/4bc61eedd349f",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/2502/creators",
      #                 "items": [],
      #                 "returned": 0
      #             },
      #             "characters": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/2502/characters",
      #                 "items": [],
      #                 "returned": 0
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/2502/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/4821",
      #                         "name": "1 of 1",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/4822",
      #                         "name": "1 of 1",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/2502/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 533,
      #             "digitalId": 3420,
      #             "title": "New X-Men (2004) #3",
      #             "issueNumber": 3,
      #             "variantDescription": "",
      #             "description": "All high schools have cliques, but what school besides the Xavier Institute also has code-names, uniforms, and combat training sessions in the Danger Room?!  All-out war threatens to break out as the New Mutants take on the Hellions!",
      #             "modified": "2010-12-10T14:40:37-0500",
      #             "isbn": "",
      #             "upc": "75960605544900311",
      #             "diamondCode": "MAY041663",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_preview_text",
      #                     "language": "en-us",
      #                     "text": "All high schools have cliques, but what school besides the Xavier Institute also has code-names, uniforms, and combat training sessions in the Danger Room?!  All-out war threatens to break out as the New Mutants take on the Hellions!"
      #                 },
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "\"CHOOSING SIDES\" PART 3 (OF 6) All high schools have cliques, but what school besides the Xavier Institute also has code-names, uniforms, and combat training sessions in the Danger Room?!  All-out war threatens to break out as the New Mutants take on the Hellions!"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/533",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/533/new_x-men_2004_3?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "purchase",
      #                     "url": "http://comicstore.marvel.com/New-X-Men-Academy-X-3/digital-comic/3420?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=3420&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "inAppLink",
      #                     "url": "https://applink.marvel.com/issue/3420?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/749",
      #                 "name": "New X-Men (2004 - 2008)"
      #             },
      #             "variants": [],
      #             "collections": [
      #                 {
      #                     "resourceURI": "http://gateway.marvel.com/v1/public/comics/1458",
      #                     "name": "New X-Men: Academy X Vol. 1: Choosing Sides (Trade Paperback)"
      #                 }
      #             ],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "2004-07-21T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2007-11-13T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "digitalPurchaseDate",
      #                     "date": "2010-04-01T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 },
      #                 {
      #                     "type": "digitalPurchasePrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/5/b0/5c40a2651e06d",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/5/b0/5c40a2651e06d",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 9,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/533/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/562",
      #                         "name": "Tom Chu",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13339",
      #                         "name": "Pete Pantazis",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13449",
      #                         "name": "Chris Sotomayor",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/9201",
      #                         "name": "Nunzio Defilippis",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/411",
      #                         "name": "Christina Weir",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/338",
      #                         "name": "Staz Johnson",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/423",
      #                         "name": "Rick Ketcham",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13145",
      #                         "name": "Sean Parsons",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/8429",
      #                         "name": "Dave Sharpe",
      #                         "role": "letterer"
      #                     }
      #                 ],
      #                 "returned": 9
      #             },
      #             "characters": {
      #                 "available": 17,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/533/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009257",
      #                         "name": "Cyclops"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009453",
      #                         "name": "Dani Moonstar"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009285",
      #                         "name": "Dust"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011082",
      #                         "name": "Elixir"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009310",
      #                         "name": "Emma Frost"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010678",
      #                         "name": "Hellion"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011271",
      #                         "name": "New X-Men"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011030",
      #                         "name": "Prodigy"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1014434",
      #                         "name": "Prodigy (David Alleyne)"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010692",
      #                         "name": "Rockslide"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010695",
      #                         "name": "Surge"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011042",
      #                         "name": "Tag"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010849",
      #                         "name": "Wallflower"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011009",
      #                         "name": "Wind Dancer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011043",
      #                         "name": "Wither"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009717",
      #                         "name": "Wolfsbane"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009726",
      #                         "name": "X-Men"
      #                     }
      #                 ],
      #                 "returned": 17
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/533/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/3357",
      #                         "name": "New X-Men (2004) #3",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/3358",
      #                         "name": "Interior #3358",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/533/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 4166,
      #             "digitalId": 0,
      #             "title": "Ultimate Marvel Flip Magazine (2005) #12",
      #             "issueNumber": 12,
      #             "variantDescription": "",
      #             "description": "72 PGS./Rated A ...$4.99",
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "5960605738-01211",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "72 PGS./Rated A ...$4.99"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/4166",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/4166/ultimate_marvel_flip_magazine_2005_12?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/928",
      #                 "name": "Ultimate Marvel Flip Magazine (2005 - 2007)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "2006-05-03T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 4.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
      #                 "extension": "jpg"
      #             },
      #             "images": [],
      #             "creators": {
      #                 "available": 8,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4166/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/24",
      #                         "name": "Brian Michael Bendis",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/676",
      #                         "name": "Warren Ellis",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/88",
      #                         "name": "Mark Millar",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/986",
      #                         "name": "Tom Derenick",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/175",
      #                         "name": "Andy Kubert",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/987",
      #                         "name": "Matt Wagner",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/192",
      #                         "name": "Stuart Immonen",
      #                         "role": "penciller (cover)"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2879",
      #                         "name": "Adam Kubert",
      #                         "role": "penciller (cover)"
      #                     }
      #                 ],
      #                 "returned": 8
      #             },
      #             "characters": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4166/characters",
      #                 "items": [],
      #                 "returned": 0
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4166/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/5031",
      #                         "name": "Ultimate Fantastic Four 12/Ultimate X-Men 12/Ultimate Marvel Team-Up 1 (Part 1)",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/5032",
      #                         "name": "Ultimate Fantastic Four 12/Ultimate X-Men 12/Ultimate Marvel Team-Up 1 (Part 1)",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4166/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 4456,
      #             "digitalId": 2209,
      #             "title": "Marvel Westerns (2006) #5",
      #             "issueNumber": 5,
      #             "variantDescription": "",
      #             "description": "Three all-new tales of the Mighty Marvel West! Do you remember the MAN CALLED HURRICANE? Over a hundred bounty hunters and cowboys looking for revenge do. The \"Fastest Man in the West\" doesn't have much of a choice but to face them at once. Question is, does he have enough bullets? By Jeff Parker and Tomm Coker.\r<br>RED WOLF is a considered superstition by many, but a group of thugs are about to find out how much is fiction and how much is true. Surviving their challenge is another thing all together for RED WOLF. By Karl Kesel and Carmine Di Giandomenico.\r<br>Major Brett Saber is known as the MAN FROM FORT RANGO, hard-nosed leader of a rag-tag group of frontier soldiers. His unruly men are no match for a deadly band of Indians intent on holding their stronghold, but a mythical man-beast poses a deadlier threat to both sides. By Fred Van Lente and Homs.\r<br>PLUS: Re-presenting the origin of RAWHIDE KID by Jack \"King\" Kirby!\r<br>48 PGS./Rated T+ ...$3.99\r<br>",
      #             "modified": "2016-10-19T17:23:11-0400",
      #             "isbn": "",
      #             "upc": "5960605862-00111",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "Three all-new tales of the Mighty Marvel West! Do you remember the MAN CALLED HURRICANE? Over a hundred bounty hunters and cowboys looking for revenge do. The \"Fastest Man in the West\" doesn't have much of a choice but to face them at once. Question is, does he have enough bullets? By Jeff Parker and Tomm Coker.\r<br>RED WOLF is a considered superstition by many, but a group of thugs are about to find out how much is fiction and how much is true. Surviving their challenge is another thing all together for RED WOLF. By Karl Kesel and Carmine Di Giandomenico.\r<br>Major Brett Saber is known as the MAN FROM FORT RANGO, hard-nosed leader of a rag-tag group of frontier soldiers. His unruly men are no match for a deadly band of Indians intent on holding their stronghold, but a mythical man-beast poses a deadlier threat to both sides. By Fred Van Lente and Homs.\r<br>PLUS: Re-presenting the origin of RAWHIDE KID by Jack \"King\" Kirby!\r<br>48 PGS./Rated T+ ...$3.99\r<br>"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/4456",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/4456/marvel_westerns_2006_5?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=2209&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/1028",
      #                 "name": "Marvel Westerns (2006)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "2006-10-19T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2007-11-13T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 3.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/e0/5807e2fe9b17d",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/e0/5807e2fe9b17d",
      #                     "extension": "jpg"
      #                 },
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/6/f0/58069b8cad916",
      #                     "extension": "jpg"
      #                 },
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/90/4bc32e3bb12e6",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4456/creators",
      #                 "items": [],
      #                 "returned": 0
      #             },
      #             "characters": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4456/characters",
      #                 "items": [],
      #                 "returned": 0
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4456/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/5742",
      #                         "name": "1 of 1",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/5743",
      #                         "name": "1 of 1",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/4456/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 6022,
      #             "digitalId": 8474,
      #             "title": "New Excalibur (2005) #17",
      #             "issueNumber": 17,
      #             "variantDescription": "",
      #             "description": "\"FALLEN FRIEND\" Part 2 (of 2)\r<br>Chris Claremont makes his triumphant return to NEW EXCALIBUR with one of the most personal stories of his career.  One of the team's members suddenly succumbs to an all-too-real tragedy. The team must pull together and care for their fallen friend while their own lives fall to pieces. Also, this issue features the debut of all-new ongoing penciler, Scot Eaton! Plus covers from legendary X-Artist Salvador Larroca!\r<br>32 PGS./Rated A ...$2.99",
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "5960605746-01711",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "\"FALLEN FRIEND\" Part 2 (of 2)\r<br>Chris Claremont makes his triumphant return to NEW EXCALIBUR with one of the most personal stories of his career.  One of the team's members suddenly succumbs to an all-too-real tragedy. The team must pull together and care for their fallen friend while their own lives fall to pieces. Also, this issue features the debut of all-new ongoing penciler, Scot Eaton! Plus covers from legendary X-Artist Salvador Larroca!\r<br>32 PGS./Rated A ...$2.99"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/6022",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/6022/new_excalibur_2005_17?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "purchase",
      #                     "url": "http://comicstore.marvel.com/New-Excalibur-17/digital-comic/8474?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=8474&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "inAppLink",
      #                     "url": "https://applink.marvel.com/issue/8474?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/935",
      #                 "name": "New Excalibur (2005 - 2007)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "2007-02-28T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2008-02-01T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "digitalPurchaseDate",
      #                     "date": "2012-08-28T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 2.99
      #                 },
      #                 {
      #                     "type": "digitalPurchasePrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/a0/5c4b2a9f4692d",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/a0/5c4b2a9f4692d",
      #                     "extension": "jpg"
      #                 },
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/4bb893fdb983a",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 9,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6022/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/44",
      #                         "name": "Chris Claremont",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/8028",
      #                         "name": "Andrew Crossley",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/652",
      #                         "name": "Peter Pantazis",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/359",
      #                         "name": "John Dell",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/423",
      #                         "name": "Rick Ketcham",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/5106",
      #                         "name": "Scot George Eaton",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/420",
      #                         "name": "Sandu Florea",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/791",
      #                         "name": "Tom Orzechowski",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/434",
      #                         "name": "Michael Ryan",
      #                         "role": "penciller (cover)"
      #                     }
      #                 ],
      #                 "returned": 9
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6022/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010771",
      #                         "name": "Excalibur"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6022/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/7744",
      #                         "name": "NEW EXCALIBUR (2005) #17",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/7745",
      #                         "name": "2 of 4 - Magic Stroke",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6022/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 6632,
      #             "digitalId": 33273,
      #             "title": "The Amazing Spider-Man (1963) #234",
      #             "issueNumber": 234,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "2014-05-08T14:31:01-0400",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/6632",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/6632/the_amazing_spider-man_1963_234?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=33273&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/1987",
      #                 "name": "The Amazing Spider-Man (1963 - 1998)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1982-11-01T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2014-04-30T15:33:50-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/40/536bcd435cdcf",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/40/536bcd435cdcf",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 5,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6632/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1326",
      #                         "name": "Dan Green",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13196",
      #                         "name": "John Romita Jr.",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1759",
      #                         "name": "Joe Rosen",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1832",
      #                         "name": "Bob Sharen",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/958",
      #                         "name": "Roger Stern",
      #                         "role": "writer"
      #                     }
      #                 ],
      #                 "returned": 5
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6632/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009610",
      #                         "name": "Spider-Man (Peter Parker)"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 5,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6632/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/13846",
      #                         "name": "Cover #13846",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/13847",
      #                         "name": "Now Shall Will-O'-The-Wisp Have His Revenge!",
      #                         "type": "interiorStory"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/13848",
      #                         "name": "The Marvel Guide to Collecting Comics",
      #                         "type": "text article"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/187170",
      #                         "name": "cover from The Amazing Spider-Man (1963) #234",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/187171",
      #                         "name": "story from The Amazing Spider-Man (1963) #234",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 5
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6632/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 6963,
      #             "digitalId": 27008,
      #             "title": "Avengers (1963) #109",
      #             "issueNumber": 109,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "2015-04-28T11:53:47-0400",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/6963",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/6963/avengers_1963_109?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "purchase",
      #                     "url": "http://comicstore.marvel.com/Avengers-109/digital-comic/27008?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=27008&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "inAppLink",
      #                     "url": "https://applink.marvel.com/issue/27008?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/1991",
      #                 "name": "Avengers (1963 - 1996)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1973-03-01T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2012-06-12T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "digitalPurchaseDate",
      #                     "date": "2014-09-09T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 },
      #                 {
      #                     "type": "digitalPurchasePrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/f0/58764560ec17e",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/f0/58764560ec17e",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 4,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6963/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/104",
      #                         "name": "Steve Englehart",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/962",
      #                         "name": "Stan Goldberg",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/305",
      #                         "name": "Don Heck",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2136",
      #                         "name": "Frank Mclaughlin",
      #                         "role": "inker"
      #                     }
      #                 ],
      #                 "returned": 4
      #             },
      #             "characters": {
      #                 "available": 8,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6963/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009165",
      #                         "name": "Avengers"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009187",
      #                         "name": "Black Panther"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009220",
      #                         "name": "Captain America"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009338",
      #                         "name": "Hawkeye"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009368",
      #                         "name": "Iron Man"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009562",
      #                         "name": "Scarlet Witch"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009664",
      #                         "name": "Thor"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009697",
      #                         "name": "Vision"
      #                     }
      #                 ],
      #                 "returned": 8
      #             },
      #             "stories": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6963/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/14463",
      #                         "name": "AVENGERS (1963) #109",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/14464",
      #                         "name": "The Measure of a Man!",
      #                         "type": "interiorStory"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/146924",
      #                         "name": "story from Avengers (1963) #109",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/6963/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 7431,
      #             "digitalId": 46950,
      #             "title": "Cable (1993) #54",
      #             "issueNumber": 54,
      #             "variantDescription": "",
      #             "description": "After nearly losing his life against Donald Pierce, Cable accidentally finds himself in Wakanda where he becomes a guest of its monarch…the Black Panther! But a team-up is soon in order, as Ulysses Klaw invades Wakanda seeking its precious vibranium deposits!\n",
      #             "modified": "2017-11-01T14:20:39-0400",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "After nearly losing his life against Donald Pierce, Cable accidentally finds himself in Wakanda where he becomes a guest of its monarch…the Black Panther! But a team-up is soon in order, as Ulysses Klaw invades Wakanda seeking its precious vibranium deposits!\n"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/7431",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/7431/cable_1993_54?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=46950&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/1995",
      #                 "name": "Cable (1993 - 2002)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1998-05-01T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2017-11-06T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/80/59fa2e9ac2e5b",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/80/59fa2e9ac2e5b",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 8,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7431/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/159",
      #                         "name": "Joe Casey",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/3996",
      #                         "name": "Jose Ladronn",
      #                         "role": "penciller (cover)"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/4628",
      #                         "name": "Jason Liebig",
      #                         "role": "editor"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/3710",
      #                         "name": "Mark Powers",
      #                         "role": "editor"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/350",
      #                         "name": "Richard Starkings",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2533",
      #                         "name": "Saida Temofonte",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/4050",
      #                         "name": "Gloria Vasquez",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/413",
      #                         "name": "Juan Vlasco",
      #                         "role": "inker"
      #                     }
      #                 ],
      #                 "returned": 8
      #             },
      #             "characters": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7431/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009187",
      #                         "name": "Black Panther"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009214",
      #                         "name": "Cable"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009390",
      #                         "name": "Klaw"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7431/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/24286",
      #                         "name": "Stranger in a Strange Land",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/24287",
      #                         "name": "Jungle Action",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7431/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 7756,
      #             "digitalId": 30925,
      #             "title": "Captain America (1968) #375",
      #             "issueNumber": 375,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "2013-12-16T12:09:27-0500",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/7756",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/7756/captain_america_1968_375?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "purchase",
      #                     "url": "http://comicstore.marvel.com/Captain-America-375/digital-comic/30925?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=30925&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "inAppLink",
      #                     "url": "https://applink.marvel.com/issue/30925?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/1996",
      #                 "name": "Captain America (1968 - 1996)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1990-08-30T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2013-07-29T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "digitalPurchaseDate",
      #                     "date": "2014-06-03T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 },
      #                 {
      #                     "type": "digitalPurchasePrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/4/03/5266a52d28703",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/4/03/5266a52d28703",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 9,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7756/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/87",
      #                         "name": "Mark Bagley",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/658",
      #                         "name": "Ron Lim",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1909",
      #                         "name": "Steve Buccellato",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2056",
      #                         "name": "Nel Yomtov",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/5823",
      #                         "name": "Danilo Bulanadi",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1914",
      #                         "name": "Dan Panosian",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13261",
      #                         "name": "Phil Felix",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1759",
      #                         "name": "Joe Rosen",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/259",
      #                         "name": "Mark Gruenwald",
      #                         "role": "writer"
      #                     }
      #                 ],
      #                 "returned": 9
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7756/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009220",
      #                         "name": "Captain America"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 4,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7756/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/18035",
      #                         "name": "Cover #18035",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/18036",
      #                         "name": "The Devil You Know",
      #                         "type": ""
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/18037",
      #                         "name": "The Steel Balloon",
      #                         "type": ""
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/187719",
      #                         "name": "story from Captain America (1968) #375",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 4
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/7756/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 8090,
      #             "digitalId": 43610,
      #             "title": "Daredevil (1964) #114",
      #             "issueNumber": 114,
      #             "variantDescription": "",
      #             "description": "The Man-Thing proves a silent stalker when he helps Daredevil take out Gladiator. The full barrage of Death-Stalker's powers incapacitates both Man-Thing and Hornhead!",
      #             "modified": "2018-08-08T14:27:50-0400",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_solicit_text",
      #                     "language": "en-us",
      #                     "text": "The Man-Thing proves a silent stalker when he helps Daredevil take out Gladiator. The full barrage of Death-Stalker's powers incapacitates both Man-Thing and Hornhead!"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/8090",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/8090/daredevil_1964_114?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=43610&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2002",
      #                 "name": "Daredevil (1964 - 1998)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1974-10-10T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2018-08-13T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0.25
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/90/5b47baeb0f060",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/90/5b47baeb0f060",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 9,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8090/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1212",
      #                         "name": "Dan Adkins",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1523",
      #                         "name": "Vince Colletta",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/106",
      #                         "name": "Bob Brown",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/144",
      #                         "name": "Steve Gerber",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1747",
      #                         "name": "Petra Goldberg",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2135",
      #                         "name": "Charlotte Jetter",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1754",
      #                         "name": "Gaspar Saladino",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/148",
      #                         "name": "Gil Kane",
      #                         "role": "penciller (cover)"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2909",
      #                         "name": "Roy Thomas",
      #                         "role": "editor"
      #                     }
      #                 ],
      #                 "returned": 9
      #             },
      #             "characters": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8090/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009262",
      #                         "name": "Daredevil"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009420",
      #                         "name": "Man-Thing"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8090/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/15739",
      #                         "name": "The Man-Thing Stalks the Swamp!",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/15740",
      #                         "name": "A Quiet Night In the Swamp!",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8090/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 8415,
      #             "digitalId": 39187,
      #             "title": "Daredevil (1964) #65",
      #             "issueNumber": 65,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/8415",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/8415/daredevil_1964_65?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=39187&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2002",
      #                 "name": "Daredevil (1964 - 1998)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1970-06-01T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2016-03-07T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/8/b0/5b43bc153b3c6",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/8/b0/5b43bc153b3c6",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 4,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8415/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/270",
      #                         "name": "Gene Colan",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1256",
      #                         "name": "Syd Shores",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13093",
      #                         "name": "Art Simek",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2909",
      #                         "name": "Roy Thomas",
      #                         "role": "writer"
      #                     }
      #                 ],
      #                 "returned": 4
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8415/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009262",
      #                         "name": "Daredevil"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8415/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/16420",
      #                         "name": "The Murderous Menace of the Man Called Brimstone!",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/16421",
      #                         "name": "The Killing of Brother Brimstone",
      #                         "type": "interiorStory"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/188718",
      #                         "name": "story from Daredevil (1964) #65",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8415/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 8743,
      #             "digitalId": 0,
      #             "title": "Ghost Rider (1973) #36",
      #             "issueNumber": 36,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/8743",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/8743/ghost_rider_1973_36?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2013",
      #                 "name": "Ghost Rider (1973 - 1983)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1979-06-10T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0.4
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
      #                 "extension": "jpg"
      #             },
      #             "images": [],
      #             "creators": {
      #                 "available": 6,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8743/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1394",
      #                         "name": "Bob Budiansky",
      #                         "role": "penciller (cover)"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1236",
      #                         "name": "Michael Fleisher",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/964",
      #                         "name": "Don Perlin",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1821",
      #                         "name": "Ben Sean",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/958",
      #                         "name": "Roger Stern",
      #                         "role": "editor"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/5205",
      #                         "name": "Irving Watanabe",
      #                         "role": "letterer"
      #                     }
      #                 ],
      #                 "returned": 6
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8743/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009318",
      #                         "name": "Ghost Rider (Johnny Blaze)"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8743/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/20259",
      #                         "name": "Cover #20259",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/20260",
      #                         "name": "A Demon In Denver",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/8743/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 9132,
      #             "digitalId": 32662,
      #             "title": "Incredible Hulk (1962) #321",
      #             "issueNumber": 321,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "2013-11-11T10:42:28-0500",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/9132",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/9132/incredible_hulk_1962_321?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=32662&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2021",
      #                 "name": "Incredible Hulk (1962 - 1999)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1986-07-01T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2014-06-02T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/50/5280fabca23a2",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/50/5280fabca23a2",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9132/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1284",
      #                         "name": "Michael Higgins",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/435",
      #                         "name": "Al Milgrom",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1819",
      #                         "name": "Rick Parker",
      #                         "role": "letterer"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9132/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009351",
      #                         "name": "Hulk"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 4,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9132/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/18791",
      #                         "name": "Death-Match",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/18792",
      #                         "name": "...And the Walls Came Tumbling Down",
      #                         "type": "interiorStory"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/191409",
      #                         "name": "cover from Incredible Hulk (1962) #321",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/191410",
      #                         "name": "story from Incredible Hulk (1962) #321",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 4
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9132/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 9468,
      #             "digitalId": 2034,
      #             "title": "Iron Man (1968) #226",
      #             "issueNumber": 226,
      #             "variantDescription": "",
      #             "description": "Iron Man goes rogue, so Tony Stark fires him! But wait, aren't they the same person? As Armor Wars continues, Iron Man reclaims Stark's technology in a deadly battle with the villainous Raiders -- but when he attacks scientist and hero Stingray, public opinion of the Golden Avenger falls lower than ever! How will Stark get out of this one?",
      #             "modified": "2016-05-20T13:15:29-0400",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [
      #                 {
      #                     "type": "issue_preview_text",
      #                     "language": "en-us",
      #                     "text": "Iron Man goes rogue, so Tony Stark fires him! But wait, aren't they the same person? As Armor Wars continues, Iron Man reclaims Stark's technology in a deadly battle with the villainous Raiders -- but when he attacks scientist and hero Stingray, public opinion of the Golden Avenger falls lower than ever! How will Stark get out of this one?"
      #                 }
      #             ],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/9468",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/9468/iron_man_1968_226?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "purchase",
      #                     "url": "http://comicstore.marvel.com/Iron-Man-226/digital-comic/2034?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=2034&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "inAppLink",
      #                     "url": "https://applink.marvel.com/issue/2034?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2029",
      #                 "name": "Iron Man (1968 - 1996)"
      #             },
      #             "variants": [],
      #             "collections": [
      #                 {
      #                     "resourceURI": "http://gateway.marvel.com/v1/public/comics/5872",
      #                     "name": "Iron Man: Armor Wars (Trade Paperback)"
      #                 }
      #             ],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1988-01-10T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2007-11-13T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "digitalPurchaseDate",
      #                     "date": "2010-05-05T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0.75
      #                 },
      #                 {
      #                     "type": "digitalPurchasePrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/70/52c5a394851c5",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/70/52c5a394851c5",
      #                     "extension": "jpg"
      #                 },
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/a/60/4f7ef5197fc73",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9468/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/259",
      #                         "name": "Mark Gruenwald",
      #                         "role": "editor"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/2784",
      #                         "name": "David Michelinie",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1832",
      #                         "name": "Bob Sharen",
      #                         "role": "colorist"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9468/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009368",
      #                         "name": "Iron Man"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9468/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/19416",
      #                         "name": "",
      #                         "type": ""
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/19417",
      #                         "name": "",
      #                         "type": ""
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/66569",
      #                         "name": "IRON MAN (1968) #226",
      #                         "type": "cover"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "events": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/9468/events",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/events/231",
      #                         "name": "Armor Wars"
      #                     }
      #                 ],
      #                 "returned": 1
      #             }
      #         },
      #         {
      #             "id": 12363,
      #             "digitalId": 885,
      #             "title": "X-Men Annual (1970) #3",
      #             "issueNumber": 3,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 52,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/12363",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/12363/x-men_annual_1970_3?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=885&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2100",
      #                 "name": "X-Men Annual (1970 - 1994)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1979-01-03T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2008-09-17T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0.75
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/c0/4f675b712d861",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/c0/4f675b712d861",
      #                     "extension": "jpg"
      #                 },
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/80/4bc4812f194fe",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 8,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12363/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/11063",
      #                         "name": "Terry Kevin Austin",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/44",
      #                         "name": "Chris Claremont",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1778",
      #                         "name": "Dan Crespi",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/791",
      #                         "name": "Tom Orzechowski",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/17",
      #                         "name": "Frank Miller",
      #                         "role": "penciller (cover)"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1872",
      #                         "name": "Glynis Oliver",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/103",
      #                         "name": "George Perez",
      #                         "role": "penciller"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/958",
      #                         "name": "Roger Stern",
      #                         "role": "editor"
      #                     }
      #                 ],
      #                 "returned": 8
      #             },
      #             "characters": {
      #                 "available": 9,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12363/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009168",
      #                         "name": "Banshee"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009243",
      #                         "name": "Colossus"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009257",
      #                         "name": "Cyclops"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009368",
      #                         "name": "Iron Man"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009472",
      #                         "name": "Nightcrawler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009629",
      #                         "name": "Storm"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009664",
      #                         "name": "Thor"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009718",
      #                         "name": "Wolverine"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009726",
      #                         "name": "X-Men"
      #                     }
      #                 ],
      #                 "returned": 9
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12363/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/19872",
      #                         "name": "X-Men Annual (1970) #3",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/19873",
      #                         "name": "A Fire In the Sky!",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12363/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 12704,
      #             "digitalId": 0,
      #             "title": "Alpha Flight (1983) #42",
      #             "issueNumber": 42,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "-0001-11-30T00:00:00-0500",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/12704",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/12704/alpha_flight_1983_42?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2116",
      #                 "name": "Alpha Flight (1983 - 1994)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1987-01-01T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
      #                 "extension": "jpg"
      #             },
      #             "images": [],
      #             "creators": {
      #                 "available": 5,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12704/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13769",
      #                         "name": "Bill Mantlo",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/399",
      #                         "name": "Jim Novak",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/10824",
      #                         "name": "Whilce Portacio",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/12538",
      #                         "name": "Dave Ross",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1832",
      #                         "name": "Bob Sharen",
      #                         "role": "colorist"
      #                     }
      #                 ],
      #                 "returned": 5
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12704/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010370",
      #                         "name": "Alpha Flight"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 2,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12704/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/21242",
      #                         "name": "Cover #21242",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/21243",
      #                         "name": "Auction",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 2
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/12704/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 13075,
      #             "digitalId": 5904,
      #             "title": "Fantastic Four (1961) #262",
      #             "issueNumber": 262,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "2016-03-29T16:20:05-0400",
      #             "isbn": "",
      #             "upc": "",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/13075",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/13075/fantastic_four_1961_262?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "purchase",
      #                     "url": "http://comicstore.marvel.com/Fantastic-Four-262/digital-comic/5904?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=5904&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "inAppLink",
      #                     "url": "https://applink.marvel.com/issue/5904?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2121",
      #                 "name": "Fantastic Four (1961 - 1998)"
      #             },
      #             "variants": [],
      #             "collections": [
      #                 {
      #                     "resourceURI": "http://gateway.marvel.com/v1/public/comics/17461",
      #                     "name": "FANTASTIC FOUR VISIONARIES: JOHN BYRNE VOL. 4 TPB (Trade Paperback)"
      #                 }
      #             ],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1984-01-01T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2009-04-06T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "digitalPurchaseDate",
      #                     "date": "2014-10-07T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 },
      #                 {
      #                     "type": "digitalPurchasePrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/e/f0/5bb50ccd53fc5",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/e/f0/5bb50ccd53fc5",
      #                     "extension": "jpg"
      #                 },
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/6/20/4c36641a0d38f",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13075/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1827",
      #                         "name": "John Byrne",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/399",
      #                         "name": "Jim Novak",
      #                         "role": "letterer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1872",
      #                         "name": "Glynis Oliver",
      #                         "role": "colorist"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "characters": {
      #                 "available": 9,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13075/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009299",
      #                         "name": "Fantastic Four"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009312",
      #                         "name": "Galactus"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009356",
      #                         "name": "Human Torch"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009366",
      #                         "name": "Invisible Woman"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009402",
      #                         "name": "Lilandra"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009459",
      #                         "name": "Mr. Fantastic"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009477",
      #                         "name": "Nova"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009480",
      #                         "name": "Odin"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009662",
      #                         "name": "Thing"
      #                     }
      #                 ],
      #                 "returned": 9
      #             },
      #             "stories": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13075/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/12792",
      #                         "name": "The Trial of Reed Richards",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/12793",
      #                         "name": "The Trial of Reed Richards",
      #                         "type": "interiorStory"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/190393",
      #                         "name": "story from Fantastic Four (1961) #262",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13075/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 13408,
      #             "digitalId": 2895,
      #             "title": "X-Statix (2002) #12",
      #             "issueNumber": 12,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "2018-06-08T10:00:25-0400",
      #             "isbn": "",
      #             "upc": "75960605332201211",
      #             "diamondCode": "JUN031604",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 0,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/13408",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/13408/x-statix_2002_12?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=2895&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/462",
      #                 "name": "X-Statix (2002 - 2004)"
      #             },
      #             "variants": [],
      #             "collections": [
      #                 {
      #                     "resourceURI": "http://gateway.marvel.com/v1/public/comics/1265",
      #                     "name": "X-Statix Vol. 3: Back from the Dead (Trade Paperback)"
      #                 }
      #             ],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "2003-09-01T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2007-11-13T00:00:00-0500"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/10/4bc46d18b841a",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/9/10/4bc46d18b841a",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13408/creators",
      #                 "items": [],
      #                 "returned": 0
      #             },
      #             "characters": {
      #                 "available": 1,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13408/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1010806",
      #                         "name": "X-Statix"
      #                     }
      #                 ],
      #                 "returned": 1
      #             },
      #             "stories": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13408/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/25965",
      #                         "name": "",
      #                         "type": ""
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/67251",
      #                         "name": "X-STATIX 12 cover",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/162520",
      #                         "name": "story from X-Statix (2002) #12",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13408/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         },
      #         {
      #             "id": 13912,
      #             "digitalId": 30838,
      #             "title": "Uncanny X-Men (1981) #371",
      #             "issueNumber": 371,
      #             "variantDescription": "",
      #             "description": nil,
      #             "modified": "2014-09-18T14:51:35-0400",
      #             "isbn": "",
      #             "upc": "75960602461237111",
      #             "diamondCode": "",
      #             "ean": "",
      #             "issn": "",
      #             "format": "Comic",
      #             "pageCount": 36,
      #             "textObjects": [],
      #             "resourceURI": "http://gateway.marvel.com/v1/public/comics/13912",
      #             "urls": [
      #                 {
      #                     "type": "detail",
      #                     "url": "http://marvel.com/comics/issue/13912/uncanny_x-men_1981_371?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "purchase",
      #                     "url": "http://comicstore.marvel.com/Uncanny-X-Men-371/digital-comic/30838?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "reader",
      #                     "url": "http://marvel.com/digitalcomics/view.htm?iid=30838&utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 },
      #                 {
      #                     "type": "inAppLink",
      #                     "url": "https://applink.marvel.com/issue/30838?utm_campaign=apiRef&utm_source=0803ac54e9aa8cbbe036f1c7b3b3d1c0"
      #                 }
      #             ],
      #             "series": {
      #                 "resourceURI": "http://gateway.marvel.com/v1/public/series/2258",
      #                 "name": "Uncanny X-Men (1963 - 2011)"
      #             },
      #             "variants": [],
      #             "collections": [],
      #             "collectedIssues": [],
      #             "dates": [
      #                 {
      #                     "type": "onsaleDate",
      #                     "date": "1999-08-01T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "focDate",
      #                     "date": "-0001-11-30T00:00:00-0500"
      #                 },
      #                 {
      #                     "type": "unlimitedDate",
      #                     "date": "2013-07-15T00:00:00-0400"
      #                 },
      #                 {
      #                     "type": "digitalPurchaseDate",
      #                     "date": "2014-03-11T00:00:00-0400"
      #                 }
      #             ],
      #             "prices": [
      #                 {
      #                     "type": "printPrice",
      #                     "price": 0
      #                 },
      #                 {
      #                     "type": "digitalPurchasePrice",
      #                     "price": 1.99
      #                 }
      #             ],
      #             "thumbnail": {
      #                 "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/e0/5115325a29b09",
      #                 "extension": "jpg"
      #             },
      #             "images": [
      #                 {
      #                     "path": "http://i.annihil.us/u/prod/marvel/i/mg/f/e0/5115325a29b09",
      #                     "extension": "jpg"
      #                 }
      #             ],
      #             "creators": {
      #                 "available": 6,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13912/creators",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/357",
      #                         "name": "Jim Cheung",
      #                         "role": "penciler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/13348",
      #                         "name": "Liquid! Color",
      #                         "role": "colorist"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/16",
      #                         "name": "Alan Davis",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/1162",
      #                         "name": "Terry Kavanagh",
      #                         "role": "writer"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/454",
      #                         "name": "Mark Morales",
      #                         "role": "inker"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/creators/350",
      #                         "name": "Richard Starkings",
      #                         "role": "letterer"
      #                     }
      #                 ],
      #                 "returned": 6
      #             },
      #             "characters": {
      #                 "available": 12,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13912/characters",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009243",
      #                         "name": "Colossus"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009312",
      #                         "name": "Galactus"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009313",
      #                         "name": "Gambit"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009425",
      #                         "name": "Marrow"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009471",
      #                         "name": "Nick Fury"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009472",
      #                         "name": "Nightcrawler"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009504",
      #                         "name": "Professor X"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009546",
      #                         "name": "Rogue"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009599",
      #                         "name": "Skrulls"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009629",
      #                         "name": "Storm"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009718",
      #                         "name": "Wolverine"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/characters/1009726",
      #                         "name": "X-Men"
      #                     }
      #                 ],
      #                 "returned": 12
      #             },
      #             "stories": {
      #                 "available": 3,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13912/stories",
      #                 "items": [
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/28285",
      #                         "name": "UNCANNY X-MEN (1963) #371",
      #                         "type": "cover"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/28286",
      #                         "name": "Rage Against the Machine Part 1: Crossed Wires",
      #                         "type": "interiorStory"
      #                     },
      #                     {
      #                         "resourceURI": "http://gateway.marvel.com/v1/public/stories/162343",
      #                         "name": "story from Uncanny X-Men (1963) #371",
      #                         "type": "interiorStory"
      #                     }
      #                 ],
      #                 "returned": 3
      #             },
      #             "events": {
      #                 "available": 0,
      #                 "collectionURI": "http://gateway.marvel.com/v1/public/comics/13912/events",
      #                 "items": [],
      #                 "returned": 0
      #             }
      #         }
      #     ].to_json,
      # symbolize_names: true)
      # end
    end
  end
end
