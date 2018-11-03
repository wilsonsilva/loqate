module Loqate
  # Generic return value of an operation. Provides a consistent way to determine if an operation
  # has succeeded or failed.
  class Result
    # Creates a new Result
    #
    # @param [Object] value The original return value of an operation.
    # @param [Symbol] code A code to describe the kind of result.
    #
    # @example Creating a new +Result+
    #   Result.new(value: person.errors, code: :not_updated)
    #
    def initialize(value:, code: nil)
      @value = value
      @code  = code
    end

    # A code to describe the kind of result.
    #
    # @return [Symbol]
    #
    attr_reader :code

    # The original return value of an operation.
    #
    # @return [Object]
    #
    attr_reader :value

    # Wraps the result of a successful operation.
    class Success < Result
      # Always true
      #
      # @return [TrueClass]
      #
      def success?
        true
      end

      # Always false
      #
      # @return [FalseClass]
      #
      def failure?
        false
      end
    end

    # Wraps the result of a failed operation.
    class Failure < Result
      # Always false
      #
      # @return [FalseClass]
      #
      def success?
        false
      end

      # Always true
      #
      # @return [TrueClass]
      #
      def failure?
        true
      end

      alias error value
    end

    # Utility methods to conveniently return +Success+ or +Failure+ results.
    module Mixin
      Success = Success
      Failure = Failure

      # Wraps the result of an operation in a +Success+ result.
      #
      # @param [Object] value The original return value of an operation.
      #
      # @example Creating a success result
      #   Success(value: Person.new)
      #
      # @return [Success]
      #
      def Success(value)
        Success.new(value: value)
      end

      # Wraps the result of an operation in a +Failure+ result.
      #
      # @param [Object] value The original return value of an operation.
      # @param [Symbol] code A unique
      #
      # @example Creating a failure result
      #   error = { message: 'Name cannot be blank' }
      #   Success(value: error, code: :not_persisted)
      #
      # @return [Success]
      #
      def Failure(value, code: nil)
        Failure.new(value: value, code: code)
      end
    end
  end
end
