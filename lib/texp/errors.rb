module TExp

  # Base error for TExp specific exceptions.
  Error = Class.new(StandardError)

  # Raised when the units on the every method are not recognized.
  TExpUnitError    = Class.new(TExp::Error)

  # Raised if an error is encountered during the parsing of a temporal
  # expression.
  ParseError = Class.new(TExp::Error)
end
