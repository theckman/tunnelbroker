# -*- coding: UTF-8 -*-
require 'English'
require 'tunnelbroker/exceptions'

module TunnelBroker
  # class to give some helpful handling of the TunnelBroker API response
  #
  class APIResponse
    attr_reader :response

    BADAUTH = /^(badauth)$/
    CHANGE = /^(good)\s(\d+\.\d+\.\d+\.\d+)$/
    NO_CHANGE = /^(nochg)\s(\d+\.\d+\.\d+\.\d+)$/

    def initialize(response)
      parse_response(response.lines.first)
    end

    def successful?
      if @successful.nil?
        false
      else
        @successful
      end
    end

    def changed?
      if @changed.nil?
        false
      else
        @changed
      end
    end

    private

    def parse_response(firstline)
      if BADAUTH.match(firstline)
        bad_auth($LAST_MATCH_INFO)
      elsif CHANGE.match(firstline)
        change($LAST_MATCH_INFO)
      elsif NO_CHANGE.match(firstline)
        no_change($LAST_MATCH_INFO)
      end
    end

    def bad_auth(match)
      @successful = false
      @changed = false
      @response = { msg: match[1], data: {} }
    end

    def change(match)
      @successful = true
      @changed = true
      matched_response(match)
    end

    def no_change(match)
      @successful = true
      @changed = false
      matched_response(match)
    end

    def matched_response(match)
      @response = { msg: match[1], data: { ip: match[2] } }
    end
  end
end
