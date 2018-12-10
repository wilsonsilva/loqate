require 'loqate/client'
require 'loqate/result'
require 'loqate/geocoding/direction'
require 'loqate/mappers/error_mapper'
require 'loqate/mappers/generic_mapper'

module Loqate
  module Geocoding
    # Retrieves
    class Gateway
      DIRECTIONS_ENDPOINT = '/DistancesAndDirections/Interactive/Directions/v2.00/json3.ws'.freeze

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

      private

      # @api private
      attr_reader :client, :mapper, :error_mapper

      # @api private
      def build_error_from(item)
        error = error_mapper.map_one(item)
        Failure(error)
      end

      # @api private
      def build_directions_from(item)
        direction = mapper.map(item, Direction)
        Success(direction)
      end
    end
  end
end
