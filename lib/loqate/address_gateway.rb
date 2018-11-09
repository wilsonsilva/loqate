require 'loqate/address'
require 'loqate/detailed_address'
require 'loqate/error'
require 'loqate/client'
require 'loqate/result'
require 'loqate/mappers/error_mapper'
require 'loqate/mappers/generic_mapper'

module Loqate
  # Address Verification consists of two main API requests: a Find request is used to narrow down a possible
  # list of addresses; and a Retrieve request is used to retrieve a fully formatted address.
  #
  # A typical address search is made up of a series of Find requests, followed by a Retrieve based on the
  # user selection. Choose a service below to find out how to use each request.
  #
  class AddressGateway
    FIND_ENDPOINT     = '/Capture/Interactive/Find/v1.00/json3.ws'.freeze
    RETRIEVE_ENDPOINT = '/Capture/Interactive/Retrieve/v1.00/json3.ws'.freeze

    include Result::Mixin

    # Creates an address gateway
    #
    # @param [Client] client The client responsible for the HTTP interactions
    #
    def initialize(client)
      @client       = client
      @mapper       = Mappers::GenericMapper.new
      @error_mapper = Mappers::ErrorMapper.new
    end

    # Find addresses and places.
    #
    # @param [Hash] options The options to find an address or a list of addresses.
    # @option options [String] :text The search text to find. Ideally a postcode or the start of the address.
    # @option options [String] countries A comma separated list of ISO 2 or 3 character country codes to limit
    #   the search within.
    # @option options [String] origin A starting location for the search. This can be the name or ISO 2 or 3 character
    #   code of a country, WGS84 coordinates (comma separated) or IP address to search from.
    # @option options [String] container A container for the search. This should only be another Id previously returned
    #   from this service when the Type of the result was not 'Address'.
    # @option options [Integer] limit The maximum number of results to return.
    # @option options [String] language The preferred language for results. This should be a 2 or 4 character language
    #   code e.g. (en, fr, en-gb, en-us etc).
    #
    # @example Retrieving an address in the UK
    #   address = address_gateway.find(countries: 'GB', text: 'Scrubs Lane')
    #
    # @return [Result] A result wrapping a list of addresses
    #
    def find(options)
      response = client.get(FIND_ENDPOINT, options)

      response.errors? && build_error_from(response.items.first) || build_addresses_from(response.items)
    end

    # Returns the full address details based on the id.
    #
    # @param [Hash] options The options to retrieve the address.
    # @option options [String] :id The Id from a Find method to retrieve the details for.
    # @option options [String] :field_1_format Format of a custom address field.
    # @option options [String] :field_2_format Format of a custom address field.
    # @option options [String] :field_3_format Format of a custom address field.
    # @option options [String] :field_4_format Format of a custom address field.
    # @option options [String] :field_5_format Format of a custom address field.
    #
    # @example Retrieving the details of an address
    #   detailed_address = gateway.retrieve(id: 'GB|RM|ENG|6RB-NW10')
    #
    # @return [Result] A result wrapping a detailed address
    #
    def retrieve(options)
      response = client.get(RETRIEVE_ENDPOINT, options)

      response.errors? && build_error_from(response.items.first) || build_detailed_address_from(response.items.first)
    end

    # Find addresses and places.
    #
    # @param [Hash] options The options to find an address or a list of addresses.
    # @option options [String] :text The search text to find. Ideally a postcode or the start of the address.
    # @option options [String] countries A comma separated list of ISO 2 or 3 character country codes to limit
    #   the search within.
    # @option options [String] origin A starting location for the search. This can be the name or ISO 2 or 3 character
    #   code of a country, WGS84 coordinates (comma separated) or IP address to search from.
    # @option options [String] container A container for the search. This should only be another Id previously returned
    #   from this service when the Type of the result was not 'Address'.
    # @option options [Integer] limit The maximum number of results to return.
    # @option options [String] language The preferred language for results. This should be a 2 or 4 character language
    #   code e.g. (en, fr, en-gb, en-us etc).
    #
    # @example Retrieving addresses in the UK
    #   addresses = address_gateway.find!(countries: 'GB', text: 'Scrubs Lane')
    #
    # @raise [Error] If the result is not a success
    #
    # @return [Array<Address>] A list of addresses
    #
    def find!(options)
      unwrap_result_or_raise { find(options) }
    end

    # Returns the full address details based on the id.
    #
    # @param [Hash] options The options to retrieve the address.
    # @option options [String] :id The Id from a Find method to retrieve the details for.
    # @option options [String] :field_1_format Format of a custom address field.
    # @option options [String] :field_2_format Format of a custom address field.
    # @option options [String] :field_3_format Format of a custom address field.
    # @option options [String] :field_4_format Format of a custom address field.
    # @option options [String] :field_5_format Format of a custom address field.
    #
    # @example Retrieving the details of an address
    #   detailed_address = gateway.retrieve!(id: 'GB|RM|ENG|6RB-NW10')
    #
    # @raise [Error] If the result is not a success
    #
    # @return [DetailedAddress] A detailed address
    #
    def retrieve!(options)
      unwrap_result_or_raise { retrieve(options) }
    end

    private

    # @api private
    attr_reader :client, :mapper, :error_mapper

    # @api private
    def build_error_from(item)
      error = error_mapper.map_one(item)
      Failure(error)
    end

    # @api private
    def build_addresses_from(items)
      address = mapper.map(items, Address)
      Success(address)
    end

    # @api private
    def build_detailed_address_from(item)
      detailed_address = mapper.map_one(item, DetailedAddress)
      Success(detailed_address)
    end
  end
end
