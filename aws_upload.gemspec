# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_upload/version'

Gem::Specification.new do |spec|
  spec.name          = "aws_upload"
  spec.version       = AwsUpload::VERSION
  spec.authors       = ["ykmr1224"]
  spec.email         = ["ykmr1224@gmail.com"]
  spec.description   = %q{This gem offers a helper method to build a form HTML to upload directry to Amazon S3 storage by using POST method.}
  spec.summary       = %q{This gem offers a helper method to build a form HTML to upload directry to Amazon S3 storage by using POST method.}
  spec.homepage      = "https://github.com/ykmr1224"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk"
  spec.add_dependency "activesupport"
  spec.add_dependency "actionview"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
