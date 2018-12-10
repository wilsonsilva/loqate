require 'loqate/address/gateway'
require 'loqate/bank/gateway'
require 'loqate/email/gateway'
require 'loqate/geocoding/gateway'
require 'loqate/phone/gateway'

module Loqate
  # Acts as a single point of entry for a defined group of API's.
  class Gateway
    # The gem configuration.
    #
    # @return [Configuration]
    #
    attr_reader :config

    # Creates a new gateway.
    #
    # @param [Hash] options Options to configure the gem.
    # @option options [String] :api_key API key that will give you access to all services
    # @option options [String] :host Base URL for Loqate's services
    # @option options [String] :language Preferred language for results
    #
    # @see Configuration
    #
    def initialize(options)
      @config = Configuration.new(options)
      @client = Client.new(config)
    end

    # Gateway to the Address APIs.
    #
    # @return [Address::Gateway] An instance of an address gateway.
    #
    def address
      @address ||= Address::Gateway.new(client)
    end

    # Gateway to the Geocoding APIs.
    #
    # @return [Geocoding::Gateway] An instance of a geocoding gateway.
    #
    def geocoding
      @geocoding ||= Geocoding::Gateway.new(client)
    end

    # Gateway to the Phone number API.
    #
    # @return [Phone::Gateway] An instance of a phone gateway.
    #
    def phone
      @phone ||= Phone::Gateway.new(client)
    end

    # Gateway to the Email verification APIs.
    #
    # @return [Email::Gateway] An instance of an email gateway.
    #
    def email
      @email ||= Email::Gateway.new(client)
    end

    # Gateway to the Bank verification APIs.
    #
    # @return [Bank::Gateway] An instance of a bank gateway.
    #
    def bank
      @bank ||= Bank::Gateway.new(client)
    end

    private

    # @api private
    attr_reader :client
  end
end
