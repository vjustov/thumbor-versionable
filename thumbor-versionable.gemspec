# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'versionable'

Gem::Specification.new do |spec|
  spec.name          = 'thumbor-versionable'
  spec.version       = Versionable.version
  spec.authors       = ['Viktor Justo']
  spec.email         = ['viktor@vjustov.me']
  spec.description   = 'A Thumbor client to specify versions of given image.'
  spec.summary       = 'A Thumbor client to specify versions of given image.'
  spec.homepage      = ''
  spec.license       = 'Mozilla Public License, version 2.0'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'rake', '~> 10.4'
end

