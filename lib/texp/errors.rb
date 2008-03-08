module TExp

  # Base error for TExp specific exceptions.
  class Error < StandardError
  end

  
  # Thrown by internal methods in the date() builder.  These
  # exceptions are caught and uniformly reraised as Ruby
  # ArgumentErrors.
  class DateArgumentError < Error
  end

  # Thrown if an error is encountered during the parsing of a temporal
  # expression.
  class ParseError < Error
  end
end
