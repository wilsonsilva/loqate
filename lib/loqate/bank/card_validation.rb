module Loqate
  module Bank
    # Result of a card validation.
    class CardValidation < Dry::Struct
      # The cleaned card number.
      #
      # @return [String]
      #
      attribute :card_number, Types::Strict::String

      # The card type (e.g. Visa, Mastercard etc).
      #
      # @return [String]
      #
      attribute :card_type, Types::Strict::String
    end
  end
end
