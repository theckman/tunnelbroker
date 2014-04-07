# -*- coding: UTF-8 -*-
require 'tunnelbroker/api_response'
require 'httparty'

module TunnelBroker
  # The class for communicating with the API
  #
  class Messenger
    include HTTParty

    def initialize(opts)
      opts_to_inst(opts)
    end

    def call_api
      TunnelBroker::APIResponse.new(call_endpoint)
    end

    private

    def opts_to_inst(opts)
      opts.each do |k, v|
        instance_variable_set(:"@#{k}", v)
      end
    end

    def call_endpoint
      auth = { username: @username, password: @update_key }
      query = {
        username: @username, password: @update_key, hostname: @tunnelid
      }
      query.merge!(myip: @ip4addr) if defined?(@ip4addr)
      self.class.get(@url, basic_auth: auth, query: query)
    end
  end
end
