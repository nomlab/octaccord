# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octaccord/version'

Gem::Specification.new do |spec|
  spec.name          = "octaccord"
  spec.version       = Octaccord::VERSION
  spec.authors       = ["Nomura Laboratory", "Yoshinari Nomura"]
  spec.email         = ["nom@quickhack.net"]
  spec.summary       = %q{Issue-manipulation tool for the GitHub.}
  spec.description   = %q{Octaccord is a small issue-manipulation tool for GitHub.}
  spec.homepage      = "https://github.com/nomlab/octaccord"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
