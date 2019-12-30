module Loqate
  module Geocoding
    # A result from the position to country API call.
    class Country < Dry::Struct
      # The name of the country where the position belongs to.
      #
      # @return [String]
      #
      attribute :country_name, Types::Strict::String

      # The ISO2 of the country.
      #
      # @return [String]
      #
      attribute :country_iso2, Types::Strict::String

      # The ISO3 of the country.
      #
      # @return [String]
      #
      attribute :country_iso3, Types::Strict::String

      # The ISO number of the country.
      #
      # @return [Integer]
      #
      attribute :country_iso_number, Types::Strict::Integer
    end
  end
end
