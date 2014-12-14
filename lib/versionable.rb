module Versionable

  class << self
    attr_reader :config
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :versions, :image

    def imageable accessor, column, &blk
      instance_eval <<-EOF
      define_method(accessor) do
        @#{accessor} ||= Versionable::Image.new(self, :#{column}, :#{accessor}, &blk)
      end
      EOF
    end
  end

  def self.configure(&blk)
    @config ||= Configuration.new(&blk)
  end
end
