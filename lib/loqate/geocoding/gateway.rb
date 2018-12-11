require 'loqate/client'
require 'loqate/result'
require 'loqate/geocoding/country'
require 'loqate/geocoding/direction'
require 'loqate/geocoding/location'
require 'loqate/mappers/error_mapper'
require 'loqate/mappers/generic_mapper'

module Loqate
  module Geocoding
    # Performs API requests to the geocoding services.
    class Gateway
      DIRECTIONS_ENDPOINT = '/DistancesAndDirections/Interactive/Directions/v2.00/json3.ws'.freeze
      GEOCODE_ENDPOINT = '/Geocoding/International/Geocode/v1.10/json3.ws'.freeze
      POSITION_TO_COUNTRY_ENDPOINT = '/Geocoding/International/PositionToCountry/v1.00/json3.ws'.freeze

      include Result::Mixin

      # Creates a geocoding gateway.
      #
      # @param [Client] client The client responsible for the HTTP interactions
      #
      def initialize(client)
        @client       = client
        @mapper       = Mappers::GenericMapper.new
        @error_mapper = Mappers::ErrorMapper.new
      end

      # Returns the directions between two or more points.
      #
      # @param [Hash] options The options to find directions.
      # @option options [String|Array<String>] :start The coordinates (latitude, longitude or easting, northing) of
      #   the start of the route. A postcode is also valid.
      # @option options [String|Array<String>] :finish The coordinates (latitude, longitude or easting, northing) of
      #   the finish of the route. A postcode is also valid.
      # @option options [String|Array<String>] :way_points The coordinates (latitude, longitude or easting, northing)
      #   of any waypoints. Postcodes are also valid.
      # @option options [String] :distance_type Specifies how the distances between the stores are calculated. It can
      #   either be 'Fastest' or 'Shortest'.
      # @option options [String] :start_day The day of the week the route is to start on. Provide this parameter
      #   only if you wish to utilise superior 'Speed Profiles' historic traffic speed data over time for avoiding
      #   rush hours and such.
      # @option options [String] :start_time The time of day the route is to start on, measured in whole minutes
      #   from midnight. (E.g. 8:30am is entered as 510.) Provide this parameter only if you wish to utilise
      #   superior 'Speed Profiles' historic traffic speed data over time for avoiding rush hours and such.
      #
      # @example Finding directions using latitude and longitude coordinates
      #   directions = geocoding_gateway.directions(
      #     start: ['51.5211057', '-0.0989496'],
      #     finish: ['51.5213087', '-0.0981853']
      #   )
      #
      # @example Finding directions using easting and northing coordinates
      #   directions = geocoding_gateway.directions(
      #     start: [381600, 259400],
      #     finish: [380600, 258400],
      #   )
      #
      # @example Finding directions using postcodes
      #   directions = geocoding_gateway.directions(
      #     start: 'EC1A 4JA',
      #     finish: 'EC1A 4ER'
      #   )
      #
      # @example Finding directions using waypoints
      #   directions = geocoding_gateway.directions(
      #     start: 'EC1A 4JA',
      #     finish: 'EC1A 4ER',
      #     way_points: ['EC1A 4JQ']
      #   )
      #
      # @example Finding directions in a given time
      #   directions = geocoding_gateway.directions(
      #     start: ['51.5211057', '-0.0989496'],
      #     finish: ['51.5213087', '-0.0981853']
      #     start_day: 'Monday',
      #     start_time: 510
      #   )
      #
      # @return [Result] A result wrapping a list of directions.
      #
      def directions(options)
        %i[start finish way_points].each do |key|
          options[key] = options[key].join(',') if options[key].respond_to?(:join)
        end

        response = client.get(DIRECTIONS_ENDPOINT, options)

        response.errors? && build_error_from(response.items.first) || build_directions_from(response.items)
      end

      # Returns the directions between two or more points.
      #
      # @raise [Error] If the result is not a success
      #
      # @see Loqage::Geocoding::Geocoding#directions
      #
      # @return [Array<Direction>] A list of directions.
      #
      def directions!(options)
        unwrap_result_or_raise { directions(options) }
      end

      # Returns the WGS84 latitude and longitude for the given location. Supports most international locations.
      #
      # @param [Hash] options The options to geocode.
      # @option options [String] :country The name or ISO 2 or 3 character code for the country to search in.
      #   Most country names will be recognised but the use of the ISO country code is recommended for clarity.
      # @option options [String] :location The location to geocode. This can be a postal code or place name.
      #
      # @example
      #   result = geocoding_gateway.geocode(country: 'US', location: '90210')
      #
      # @return [Result] A result wrapping a location.
      #
      def geocode(options)
        response = client.get(GEOCODE_ENDPOINT, options)

        response.errors? && build_error_from(response.items.first) || build_location_from(response.items.first)
      end

      # Returns the WGS84 latitude and longitude for the given location. Supports most international locations.
      #
      # @raise [Error] If the result is not a success
      #
      # @see Loqate::Geocoding::Geocoding#geocode
      #
      # @return [Location] A location.
      #
      def geocode!(options)
        unwrap_result_or_raise { geocode(options) }
      end

      # Returns the country based on the WGS84 latitude and longitude supplied. No result is returned if
      # the coordinates are in international waters.
      #
      # @param [Hash] options The coordinates of the position to search against.
      # @option options [Float] :latitude The latitude of the position to search against.
      # @option options [Float] :longitude The longitude of the position to search against.
      #
      # @example
      #   result = geocoding_gateway.position_to_country(latitude: 52.1321, longitude: -2.1001)
      #
      # @return [Result|nil] A result wrapping a country.
      #
      def position_to_country(options)
        response = client.get(POSITION_TO_COUNTRY_ENDPOINT, options)

        return Success(nil) if response.items.empty?

        response.errors? && build_error_from(response.items.first) || build_country_from(response.items.first)
      end

      # Returns the country based on the WGS84 latitude and longitude supplied. No result is returned if
      # the coordinates are in international waters.
      #
      # @raise [Error] If the result is not a success
      #
      # @see Loqate::Geocoding::Geocoding#position_to_country
      #
      # @return [Country] A country.
      #
      def position_to_country!(options)
        unwrap_result_or_raise { position_to_country(options) }
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
      def build_directions_from(items)
        direction = mapper.map(items, Direction)
        Success(direction)
      end

      # @api private
      def build_location_from(item)
        location = mapper.map_one(item, Location)
        Success(location)
      end

      # @api private
      def build_country_from(item)
        country = mapper.map_one(item, Country)
        Success(country)
      end
    end
  end
end
