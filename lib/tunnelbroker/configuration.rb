# -*- coding: UTF-8 -*-

module TunnelBroker
  # Configuration class for the TunnelBroker client
  #
  class Configuration
    attr_accessor :ip, :username, :update_key, :tunnelid

    def initialize
      set_default_values
    end

    private

    def set_default_values
      @ip = nil
      @username = nil
      @update_key = nil
      @tunnelid = nil
    end
  end
end
