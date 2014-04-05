# -*- coding: UTF-8 -*-
require 'English'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'tunnelbroker/version'

Gem::Specification.new do |spec|
  spec.name        = 'lita-forecast'
  spec.version     = TunnelBroker::VERSION
  spec.date        = Time.now.strftime('%Y-%m-%d')
  spec.description = 'Hurricane Electric IPv6 TunnelBroker API client'
  spec.summary     = 'HE TunnelBroker API Client'
  spec.authors     = ['Tim Heckman']
  spec.email       = 'tim@timheckman.net'
  spec.homepage    = 'https://github.com/theckman/tunnelbroker'
  spec.license     = 'MIT'
  spec.required_ruby_version = '>= 2.0.0'
  spec.metadata = { 'lita_plugin_type' => 'handler' }

  spec.test_files  = %x(git ls-files spec/*).split
  spec.files       = %x(git ls-files).split

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.2.2'
  spec.add_development_dependency 'rubocop', '~> 0.19.1'
  spec.add_development_dependency 'rspec', '>= 3.0.0.beta2'
  spec.add_development_dependency 'fuubar', '~> 1.3.2'
  spec.add_development_dependency 'coveralls', '~> 0.7.0'
  spec.add_development_dependency 'simplecov', '~> 0.8.2'

  spec.add_runtime_dependency 'httparty', '~> 0.12.0'
end