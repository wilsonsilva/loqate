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

    private

    # @api private
    attr_reader :client
  end
end
