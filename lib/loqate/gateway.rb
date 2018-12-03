require 'loqate/address/gateway'
require 'loqate/bank/gateway'
require 'loqate/email_gateway'
require 'loqate/phone_gateway'

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

    # Gateway to the Phone number API.
    #
    # @return [PhoneGateway] An instance of a phone gateway.
    #
    def phone
      @phone ||= PhoneGateway.new(client)
    end

    # Gateway to the Email verification APIs.
    #
    # @return [EmailGateway] An instance of an email gateway.
    #
    def email
      @email ||= EmailGateway.new(client)
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
