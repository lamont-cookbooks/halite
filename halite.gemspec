# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'halite/version'

Gem::Specification.new do |spec|
  spec.name = 'halite'
  spec.version = Halite::VERSION
  spec.authors = ['Noah Kantrowitz']
  spec.email = %w{noah@coderanger.net}
  spec.description = %q||
  spec.summary = %q||
  spec.homepage = 'https://github.com/coderanger/halite'
  spec.license = 'Apache 2.0'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib}

  spec.add_dependency 'stove', '~> 3.2.3'
  spec.add_dependency 'logify', '~> 0.2.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rspec', '~> 3.1.0'
  spec.add_development_dependency 'rspec-its', '~> 1.1.0'
  spec.add_development_dependency 'fuubar', '~> 2.0.0'
  spec.add_development_dependency 'pry'
end