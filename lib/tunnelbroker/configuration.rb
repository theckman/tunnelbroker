# -*- coding: UTF-8 -*-

module TunnelBroker
  # Configuration class for the TunnelBroker client
  #
  class Configuration
    FIELDS = [:url, :ip4addr, :username, :update_key, :tunnelid]
    attr_accessor(*FIELDS)

    def initialize
      set_default_values
    end

    private

    def set_default_values
      @ip4addr = nil
      @username = nil
      @update_key = nil
      @tunnelid = nil
      @url = nil
    end
  end
end
