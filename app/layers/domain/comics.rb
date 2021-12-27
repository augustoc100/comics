# frozen_string_literal: true

module Domain
  class Comics
    attr_reader :title, :date, :image_path, :id, :liked

    def initialize(attributes)
      @id = attributes.fetch(:id)
      @title = attributes.fetch(:title)
      @date =  attributes.fetch(:date).to_date
      @image_path = attributes.fetch(:image)
      @liked = attributes.fetch(:liked).to_s == 'true'
    end
  end
end
