# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.name = "rnexus"
  s.version = "0.0.7"
  s.platform = Gem::Platform::RUBY
  s.authors = ["Darrin Holst"]
  s.email = ["darrinholst@gmail.com"]
  s.homepage = "http://github.com/darrinholst/rnexus"
  s.summary = "a ruby wrapper to interact with a nexus maven repository"
  s.require_paths = ["lib"]
  s.required_rubygems_version = ">= 1.3.6"
  s.add_runtime_dependency("rest-client", "~> 1.6.1")
  s.add_runtime_dependency("crack", "~> 0.1.3")
  s.add_development_dependency("fakeweb", "~> 1.3.0")
  s.files = Dir.glob("lib/**/*") + %w(LICENSE README.rdoc)
  s.test_files = Dir.glob("test/**/*")
end

