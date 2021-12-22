module Domain
  class Comics
    attr_reader :title, :date, :image_path, :id

    def initialize(attributes)
      @id = attributes.fetch(:id)
      @title = attributes.fetch(:title)
      @date =  attributes.fetch(:date).to_date
      @image_path = attributes.fetch(:image)
    end
  end
end
