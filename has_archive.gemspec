# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'has_archive/version'

Gem::Specification.new do |spec|
  spec.name          = "has_archive"
  spec.version       = HasArchive::VERSION
  spec.authors       = ["Matt Morris"]
  spec.email         = ["double.emms@gmail.com"]

  spec.summary       = %q{Add archives to your ActiveRecord models}
  spec.description   = %q{Add archives to your ActiveRecord models}
  spec.homepage      = "http://github.com/matt-morris/has_archive"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
