require 'json'
module Versionable
  class Image
    class InvalidMetadata < StandardError; end

    attr_reader :width, :height
    def initialize(model, column, accessor, &blk)
      @model = model
      @column = column
      @accessor = accessor
      @versions = {}

      instance_eval(&blk) if block_given?
    end

    def url
      blank?(model.send(column)) ? legacy_url(accessor) : model.send(column)
    end

    def respond_to?(method, include_private = false)
      super || @versions.key?(method)
    end

    def to_json(_options = nil)
      JSON.generate(as_json)
    end

    def as_json(_options = nil)
      serializable_hash
    end

    def fetch_metadata
      metadata_url = URI.parse(Versionable::Version.new(self, meta: true).url)
      json_data = Net::HTTP.get(metadata_url)
      blank?(json_data) ? nil : JSON.parse(Net::HTTP.get(metadata_url))
    end

    def height_from_metadata(hash)
      @height = hash['thumbor']['source']['height']
    rescue
      raise InvalidMetadata,
            'Argument is not valid thumbor metadata. " +
            "Use #fetch_metadata to get it.'
    end

    def width_from_metadata(hash)
      @width = hash['thumbor']['source']['width']
    rescue
      raise InvalidMetadata,
            'Argument is not valid thumbor metadata. " +
            "Use #fetch_metadata to get it.'
    end

    private

    attr_reader :model, :column, :accessor, :versions

    def method_missing(name, *args, &blk)
      if versions.respond_to?(:key?) && versions.key?(name)
        versions[name]
      else
        super
      end
    end

    def version(name, options, &blk)
      @versions[name] = Versionable::Version.new(self, options, &blk)
    end

    def serializable_hash(_options = nil)
      # TODO: Add serializable_attributes to Version,
      # so that we dont hardcode url as the only attribute that gets serialized.
      { 'url' => url }.merge Hash[@versions.map do |name, version|
        [name, { 'url' => version.url }]
      end]
    end

    def blank?(obj)
      obj.respond_to?(:empty?) ? !!obj.empty? : !obj
    end
  end
end

