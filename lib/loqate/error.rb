module Loqate
  # Generic error returned from an API call
  class Error
    # Unique identifier for the error
    #
    # @return [Integer]
    #
    attr_reader :id

    # Descriptive information about the error
    #
    # @return [String]
    #
    attr_reader :description

    # What caused the error
    #
    # @return [String]
    #
    attr_reader :cause

    # How to solve the error
    #
    # @return [String]
    #
    attr_reader :resolution

    # Instantiates an error
    #
    # @param [Integer] id Unique identifier for the error
    # @param [String] description Descriptive information about the error
    # @param [String] cause What caused the error
    # @param [String] resolution How to solve the error
    #
    def initialize(id:, description:, cause:, resolution:)
      @id = id
      @cause = cause
      @resolution = resolution
      @description = description
    end

    # Compare the equality of this error with +other+. Two errors are considered equal if they have the same +id+.
    #
    # @param [Error] other Another error
    #
    # @return [Boolean]
    #
    # @api private
    #
    def ==(other)
      other.is_a?(Error) && id == other.id
    end
  end
end
