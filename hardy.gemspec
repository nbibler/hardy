# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hardy/version'

Gem::Specification.new do |gem|
  gem.name          = "hardy"
  gem.version       = Hardy::VERSION
  gem.authors       = ["Nathaniel Bibler"]
  gem.email         = ["contact@nathanielbibler.com"]
  gem.description   = %q{Convert an HTTP Archive (HAR) into a siege URLs file with Content-Type request support.}
  gem.summary       = %q{Convert HTTP Archive (HAR) files to siege URL files}
  gem.homepage      = "https://github.com/nbibler/hardy"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'addressable', '~>2.0'
  gem.add_dependency 'har'
  gem.add_dependency 'mime-types', '~>1.0'
  gem.add_dependency 'thor'
end
