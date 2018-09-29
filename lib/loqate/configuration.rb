module Loqate
  # Configuration for the gem
  class Configuration
    DEFAULT_LANGUAGE = 'en-gb'.freeze
    DEFAULT_HOST = 'https://api.addressy.com'.freeze

    # API key that will give you access to all services.
    #
    # @return [String]
    attr_reader :api_key

    # Base URL for Loqate's services. Defaults to https://api.addressy.com
    #
    # @return [String]
    attr_reader :host

    # Preferred language for results. This should be a 2 or 4 character language code e.g. (en, fr, en-gb, etc).
    #
    # @return [String]
    attr_reader :language

    # Instantiates the gem configuration
    #
    # @param [String] api_key API key that will give you access to all services
    # @param [String] host Base URL for Loqate's services
    # @param [String] language Preferred language for results
    #
    def initialize(api_key:, host: DEFAULT_HOST, language: DEFAULT_LANGUAGE)
      @api_key  = api_key
      @host     = host
      @language = language
    end
  end
end
