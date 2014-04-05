# -*- coding: UTF-8 -*-

module TunnelBroker
  # Configuration class for the TunnelBroker client
  #
  class Configuration
    attr_accessor(
      :ipv4addr, :passkey, :userid, :tunnelid, :username, :password
    )
    def initialize
      set_default_values
    end

    private

    def set_default_values
      @ipv4addr = 'auto'
      @passkey = nil
      @userid = nil
      @tunnelid = nil
      @username = nil
      @password = nil
    end
  end
end
