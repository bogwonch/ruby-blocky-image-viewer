# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'biv/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby-blocky-image-viewer'
  spec.version       = Biv::VERSION
  spec.authors       = ['Joseph Hallett']
  spec.email         = ['bogwonch@bogwonch.net']
  spec.summary       = 'Display images on the commandline.  Badly.'
  spec.description   = 'Display images on the commandline.  Badly.'
  spec.homepage      = 'https://github.com/bogwonch/ruby-blocky-image-viewer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_runtime_dependency 'rmagick', '~> 2.15.3'
  spec.add_runtime_dependency 'ruby-terminfo', '~> 0.1.1'
  spec.add_runtime_dependency 'trollop', '~> 2.1.2'
end
