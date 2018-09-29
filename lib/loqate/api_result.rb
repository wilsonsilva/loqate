module Loqate
  # Generic response of a request to Loqate's API
  class APIResult
    # Array of hashes representing each item in the response body
    #
    # @return [Array<Hash>]
    #
    attr_reader :items

    # Instantiates a new API result
    #
    # @param [Array<Hash>] items Array of hashes representing each item in the response body
    #
    def initialize(items)
      @items = items
    end

    # Whether the response contains errors
    #
    # @return [Boolean] true if the response has errors and false otherwise
    #
    def errors?
      !items.dig(0, 'Error').nil?
    end
  end
end
