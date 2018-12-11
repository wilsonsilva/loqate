module Loqate
  module Geocoding
    # A result from the geocode API call.
    class Location < Dry::Struct::Value
      # The name of the location found.
      #
      # @return [String]
      #
      attribute :name, Types::Strict::String

      # The WGS84 latitude of the found location.
      #
      # @return [Float]
      #
      attribute :latitude, Types::Strict::Float

      # The WGS84 longitude of the found location.
      #
      # @return [Float]
      #
      attribute :longitude, Types::Strict::Float
    end
  end
end
