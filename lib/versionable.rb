module Versionable
  class << self
    attr_reader :config

    def version
      "0.2.7"
    end

    def configure(&blk)
      @config ||= Configuration.new(&blk)
    end

    def included(base)
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    attr_reader :versions, :image

    def versionable(accessor, column, &blk)
      instance_eval <<-EOF
      define_method(accessor) do
        @#{accessor} ||= Image.new(self, :#{column}, :#{accessor}, &blk)
      end
      EOF
    end
  end
end

require 'versionable/configuration'
require 'versionable/image'
require 'versionable/version'
