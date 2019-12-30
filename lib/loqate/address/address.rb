module Loqate
  module Address
    # A result from the address find service.
    class Address < Dry::Struct
      # An address ID or a container ID for further results
      #
      # @return [String]
      #
      attribute :id, Types::Strict::String

      # If the Type is 'Address' then the ID can be passed to the Retrieve service.
      # Any other ID should be passed as the Container to a further Find request to get more results.
      #
      # @return [String]
      #
      attribute :type, Types::Strict::String

      # The name of the result
      #
      # @return [String]
      #
      attribute :text, Types::Strict::String

      # A list of number ranges identifying the matched characters in the Text and Description
      #
      # @return [String]
      #
      attribute :highlight, Types::Strict::String

      # Descriptive information about the result
      #
      # @return [String]
      #
      attribute :description, Types::Strict::String
    end
  end
end
