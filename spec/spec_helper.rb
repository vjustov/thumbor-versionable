# Dir[File.'../lib/**/*.rb'].each { |file| require file }
require 'versionable'
require 'versionable/image'
require 'versionable/version'
require 'versionable/configuration'
RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation # :progress, :html, :textmate
end
