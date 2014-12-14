# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'new_idea_cms/version'

Gem::Specification.new do |spec|
	spec.name          = "thumbor-versionable"
	spec.version       = Versionable::VERSION
	spec.authors       = ["Viktor Justo"]
	spec.email         = ["viktor@vjustov.me"]
	spec.description   = %q{}
	spec.summary       = %q{}
	spec.homepage      = ""
	spec.license       = "Mozilla Public License, version 2.0"

	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib", "app"]

	spec.add_development_dependency "rspec", "~> 3.1.7"
end
