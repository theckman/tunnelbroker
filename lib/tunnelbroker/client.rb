# -*- coding: UTF-8 -*-
require 'tunnelbroker/configuration'
require 'tunnelbroker/messenger'

module TunnelBroker
  # TunnelBroker client for communication with the API
  #
  class Client
    ENDPOINT ||= 'https://ipv4.tunnelbroker.net/nic/update'

    def configure
      yield(config) if Kernel.block_given?
    end

    def submit_update
      c = build_messenger_config
      tb = TunnelBroker::Messenger.new(c)
      tb.call_api
    end

    private

    def config
      @config ||= TunnelBroker::Configuration.new
    end

    def build_messenger_config
      url = config.url || ENDPOINT
      conf = {}
      conf.merge!(url: url)
      conf.merge!(username: config.username) unless config.username.nil?
      conf.merge!(update_key: config.update_key) unless config.update_key.nil?
      conf.merge!(tunnelid: config.tunnelid) unless config.tunnelid.nil?
      conf.merge!(ip4addr: config.ip4addr) unless config.ip4addr.nil?
      conf
    end
  end
end
