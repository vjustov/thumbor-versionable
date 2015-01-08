require 'openssl'
require 'base64'
require 'uri'

module Versionable
  class Version
    FIT_IN = 'fit-in'.freeze
    SMART = 'smart'.freeze
    UNSAFE = 'unsafe'.freeze
    META = 'meta'.freeze
    HALIGNEMENTS = %w(left center right).freeze
    VALIGNEMENTS = %w(top middle bottom).freeze

    attr_reader :width, :height
    def initialize(image, parameters, &blk)
      @image = image
      @height = parameters.fetch(:height) { 0 }
      @width = parameters.fetch(:width) { 0 }
      @fit_in = parameters.fetch(:fit_in) { false }
      @smart = parameters.fetch(:smart) { false }
      @meta = parameters.fetch(:meta) { false }
      @filters = []

      instance_eval(&blk) if block_given?
    end

    def url
      [
        server,
        sign,
        options_url
      ].reject(&:nil?).join('/')
    end

    def calculate_metadata
      {
        width: calculate_width,
        height: calculate_height
      }
    end

    private

    attr_reader :image, :fit_in, :smart, :filters

    def calculate_width
      @width = width != 0 ? width : (image.width * height) / image.height
    end

    def calculate_height
      @height = height != 0 ? height : (image.height * width) / image.width
    end

    def options_url
      [
        meta,
        crop,
        fit_in,
        measurements,
        horizontal_align,
        vertical_align,
        smart,
        filters,
        decoded_url
      ].reject(&:nil?).join('/')
    end

    def image_url
      image.url
    end

    def decoded_url
      URI.decode(image_url).gsub(/[+ ]/, '%20')
      # We need gsub to change '+' to ' ' when the url is decoded,
      # but it doesn't, so we karate-chop 'em into place.
    end

    def filter(name, values = nil)
      @filters << { name => values }
    end

    def horizontal_align(value = nil)
      value && HALIGNEMENTS.include?("#{value}") ? @halign = value : @halign
    end

    def vertical_align(value = nil)
      value && VALIGNEMENTS.include?("#{value}") ? @valign = value : @valign
    end

    # Serves as getter and setter.
    def crop(hash = {})
      if hash.empty?
        @crop
      else
        @crop = Crop.from(hash[:from]).to(hash[:to]).create!
      end
    end

    def measurements
      "#{width}x#{height}"
    end

    def server
      Versionable.config.thumbor_server
    end

    def sign
      key =  Versionable.config.secret_key
      Base64.urlsafe_encode64(OpenSSL::HMAC.digest('sha1', key, options_url))
    end

    def meta
      @meta ? META : nil
    end

    def fit_in
      @fit_in ? FIT_IN : nil
    end

    def smart
      @smart ? SMART : nil
    end

    def filters
      @filters.inject('filters') do |result, filter|
        result + ":#{filter_name(filter)}(#{args_from filter_params(filter)})"
      end unless @filters.empty?
    end

    def filter_name(filter)
      filter.keys.first
    end

    def filter_params(filter)
      filter.values.first
    end

    def args_from(filter_value)
      filter_value.kind_of?(Array) ? filter_value.join(',') : filter_value
    end

    class Crop
      def self.from(hash)
        @x1 = hash[:x]
        @y1 = hash[:y]
        self
      end

      def self.to(hash)
        @x2 = hash[:x]
        @y2 = hash[:y]
        self
      end

      def self.create!
        new(@x1, @y1, @x2, @y2)
      end

      def initialize(x1, y1, x2, y2)
        @x1, @y1, @x2, @y2 = x1, y1, x2, y2
      end

      def to_str
        "#{@x1}x#{@y1}:#{@x2}x#{@y2}"
      end
      alias_method :to_s, :to_str
    end
  end
end

