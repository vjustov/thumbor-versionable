module Versionable
  class Configuration
    def initialize(&block)
      instance_eval(&block) if block_given?
    end

    def thumbor_server(value = nil)
      if value
        @server = value
      else
        @server ||= 'thumbor_server.example.com'
      end
    end

    def secret_key(value = nil)
      if value
        @secret_key = value
      else
        @secret_key ||= 'S3CR37_K3Y'
      end
    end
  end
end

