require 'http'
require 'loqate/configuration'
require 'loqate/api_result'

module Loqate
  # Responsible for the HTTP interactions. The only entity aware of HTTP concerns such as status codes and headers.
  class Client
    # Instantiates a new client
    #
    # @example
    #   configuration = Configuration.new(api_key: 'EA69-CD23-CV99-HL18')
    #   client = Client.new(configuration)
    #
    # @param [Configuration] configuration The configuration of the gem
    #
    def initialize(configuration)
      @configuration = configuration
    end

    # Performs a GET request to Loqate's API. Every request returns the status code 200.
    #
    # @example Retrieving a resource
    #   client = Client.new
    #   result = client.get('/Capture/Interactive/Find/v1.00/json3.ws')
    #
    # @example Retrieving a resource using options
    #   client = Client.new
    #   result = client.get('/Capture/Interactive/Find/v1.00/json3.ws', countries: 'GB', text: 'Scrubs Lane')
    #
    # @param [String] endpoint URL of the API endpoint where the GET request
    # @param [Hash] params Options for the GET request
    #
    # @return [APIResult] Generic response of a request to Loqate's API
    #
    def get(endpoint, params = {})
      authenticated_params = authenticate_params(params)
      formatted_params = format_params(authenticated_params)

      response = HTTP.get(configuration.host + endpoint, params: formatted_params)

      body = JSON.parse(response.body)
      APIResult.new(body.fetch('Items'))
    end

    private

    # @api private
    attr_reader :configuration

    # @api private
    def authenticate_params(params)
      params.merge(key: configuration.api_key)
    end

    # @api private
    def format_params(params)
      params.transform_keys { |key| Util.camelize(key) }
    end
  end
end
