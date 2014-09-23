# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_storer_client/version'

Gem::Specification.new do |spec|
  spec.name          = "s3_storer_client"
  spec.version       = S3StorerClient::VERSION
  spec.authors       = ["Thorbjørn Hermansen"]
  spec.email         = ["thhermansen@gmail.com"]
  spec.summary       = %q{Thin Riuby wrapper arount HTTP service s3_storer}
  spec.description   = %q{API client for https://github.com/skalar/s3_storer}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "httpi", ['>= 2.1.0', '< 2.3']


  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1.0"
  spec.add_development_dependency "webmock", "~> 1.18.0"
end
