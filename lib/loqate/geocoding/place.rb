module Loqate
  module Geocoding
    # A result from the API call to find the nearest places.
    class Place < Dry::Struct::Value
      # The postcode that is nearest to the given location.
      #
      # @return [String]
      #
      attribute :location, Types::Strict::String

      # The distance in KM from the CentrePoint to this record.
      #
      # @return [Float]
      #
      attribute :distance, Types::Coercible::Float

      # The WGS84 latitude coordinate of the location.
      #
      # @return [Float]
      #
      attribute :latitude, Types::Coercible::Float

      # The WGS84 longitude coordinate of the location.
      #
      # @return [Float]
      #
      attribute :longitude, Types::Coercible::Float
    end
  end
end
