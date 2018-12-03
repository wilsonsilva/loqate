module Loqate
  module Bank
    # Result of an international bank account validation.
    class InternationalAccountValidation < Dry::Struct::Value
      # Indicates whether the account number and sortcode are valid.
      #
      # @return [Boolean]
      #
      attribute :is_correct, Types::Strict::Bool
      alias correct? is_correct
    end
  end
end
