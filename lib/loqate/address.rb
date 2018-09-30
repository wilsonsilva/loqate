module Loqate
  # A result from the address find service.
  class Address
    # An address ID or a container ID for further results
    #
    # @return [String]
    #
    attr_reader :id

    # If the Type is 'Address' then the ID can be passed to the Retrieve service.
    # Any other ID should be passed as the Container to a further Find request to get more results.
    #
    # @return [String]
    #
    attr_reader :type

    # The name of the result
    #
    # @return [String]
    #
    attr_reader :text

    # A list of number ranges identifying the matched characters in the Text and Description
    #
    # @return [String]
    #
    attr_reader :highlight

    # Descriptive information about the result
    #
    # @return [String]
    #
    attr_reader :description

    # Creates an address
    #
    # @param [String] id An address ID or a container ID for further results
    # @param [String] type If the Type is 'Address' then the ID can be passed to the Retrieve service.
    #   Any other ID should be passed as the Container to a further Find request to get more results.
    # @param [String] text The name of the result
    # @param [String] highlight A list of number ranges identifying the matched characters in the Text and Description
    # @param [String] description Descriptive information about the result
    #
    def initialize(id:, type:, text:, highlight:, description:)
      @id = id
      @type = type
      @text = text
      @highlight = highlight
      @description = description
    end

    # @!visibility private
    # @api private
    def ==(other)
      attributes == other.send(:attributes)
    end

    private

    # @api private
    def attributes
      @attributes ||= {
        id: id,
        type: type,
        text: text,
        highlight: highlight,
        description: description
      }
    end
  end
end
