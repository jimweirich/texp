module TExp

  # ------------------------------------------------------------------
  # Class methods.
  #
  class << self
    PARSE_CALLBACKS = {}        # :nodoc:

    # Lexical Definitions
    TOKEN_PATTERNS = [
      # Dates
      '\d\d\d\d-\d\d-\d\d',
      # Numbers
      '[+-]?\d+',
      # Extension Tokens
      '<(?:[a-zA-Z_][a-zA-Z0-9_]*::)?[a-zA-Z_][a-zA-Z0-9_]*>',
      # Everything else is a single character
      # (except commas and spaces which are ignored)
      '[^, ]',
    ].join('|')                           # :nodoc:
    TOKEN_RE = Regexp.new(TOKEN_PATTERNS) # :nodoc:

    # Register a parsing callback.  Individual Temporal Expression
    # classes will register their own callbacks as needed.  A handful
    # of non-class based parser callbacks are registered below.
    def register_parse_callback(token, callback)
      PARSE_CALLBACKS[token] = callback
    end
  
    # Return the temporal expression encoded by string.
    def parse(string)
      @stack = []
      string.scan(TOKEN_RE) do |tok|
        compile(tok)
      end
      fail ParseError, "Incomplete expression" if @stack.size > 1
      @stack.pop
    end

    def parse_callbacks
      PARSE_CALLBACKS
    end
    
    private

    # Compile the token into the current definition.
    def compile(tok)
      handler = PARSE_CALLBACKS[tok]
      if handler
        handler.parse_callback(@stack)
      else
        case tok
        when /^\d\d\d\d-\d\d-\d\d/
          @stack.push Date.parse(tok)
        when /^[-+]?\d+$/
          @stack.push tok.to_i
        else
          fail ParseError, "Unrecoginized TExp Token '#{tok}'"
        end
      end
    end

  end # << TExp

  # Convenience class for creating parse callbacks.
  class ParseCallback
    def initialize(&block)
      @callback = block
    end
    def parse_callback(stack)
      @callback.call(stack)
    end
  end
  
  # List parsing handlers
  
  # Mark the end of the list.
  MARK = :mark                  # :nodoc:
  
  # Push a mark on the stack to start a list.
  register_parse_callback('[',
    ParseCallback.new do |stack|
      stack.push MARK
    end)
  
  # Pop the stack and build a list until you find a mark.
  register_parse_callback(']',
    ParseCallback.new do |stack|
      list = []
      while ! stack.empty? && stack.last != MARK
        list.unshift stack.pop
      end
      fail ParseError, "Expression stack exhausted" if stack.empty?
      stack.pop
      stack.push list
    end
    )
end # module TExp
