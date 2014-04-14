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

    def config
      @config ||= TunnelBroker::Configuration.new
    end

    private

    def build_messenger_config
      conf = {}
      TunnelBroker::Configuration::FIELDS.each do |k|
        conf.merge!(config_hash_item(k))
      end
      conf
    end

    def config_hash_item(key)
      c = config.send(key)
      if c.nil? && key == :url
        { key => ENDPOINT }
      elsif c.nil?
        {}
      else
        { key => c }
      end
    end
  end
end
