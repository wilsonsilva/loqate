module Loqate
  # Provides methods for string manipulation
  #
  # @api private
  module Util
    module_function

    # Converts a string to snake case
    #
    # @param [String|Symbol] term The term to be converted.
    #
    def underscore(term)
      term
        .to_s
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
        .to_sym
    end

    # Converts a string to camel case
    #
    # @param [String|Symbol] term The term to be converted.
    #
    def camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/, &:capitalize)
      string.gsub!(%r{(?:_|(/))([a-z\d]*)}) { "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}" }
      string.gsub!('/'.freeze, '::'.freeze)
      string
    end
  end
end
