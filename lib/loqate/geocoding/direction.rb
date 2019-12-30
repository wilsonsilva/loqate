module Loqate
  module Geocoding
    # A result from the directions API call.
    class Direction < Dry::Struct
      # A zero based counter indicating the row number.
      #
      # @return [Integer]
      #
      attribute :segment_number, Types::Strict::Integer

      # A zero based counter indicating the row number.
      #
      # @return [Integer]
      #
      attribute :step_number, Types::Strict::Integer

      # The type of routing instruction.
      #
      # @return [String]
      #
      attribute :action, Types::Strict::String

      # Textual description of the routing instruction.
      #
      # @return [String]
      #
      attribute :description, Types::Strict::String

      # The name of the road to turn onto.
      #
      # @return [String]
      #
      attribute :road, Types::Strict::String

      # The time in seconds for this part of the route.
      #
      # @return [Integer]
      #
      attribute :step_time, Types::Strict::Integer

      # The distance in metres for this part of the route.
      #
      # @return [Integer]
      #
      attribute :step_distance, Types::Strict::Integer

      # The total time in seconds for the route.
      #
      # @return [Integer]
      #
      attribute :total_time, Types::Strict::Integer

      # The total distance in metres for the route.
      #
      # @return [Integer]
      #
      attribute :total_distance, Types::Strict::Integer
    end
  end
end
