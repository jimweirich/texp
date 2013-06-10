require 'test_helper'

module TExp

  # Extensions is the standard module for TExp extensions.
  module Extensions

    # You should put your extensions inside your own namespace module.
    # This will help avoid collisions with with other extensions.
    module MyExt

      # Create a Temporal Expression class.  Inheriting from
      # TExp::Base allows you to reuse some common functionality
      # defined there.  Other choices are:
      #
      # (1) TExp::TermsBase -- Defines a parsing method for handling
      #     lists of temporal expressions as argument lists.
      #
      class Never < Base

        # Register your parsing token.  Include your namespace as part
        # of the token to avoid naming collisions with other
        # extensions.
        register_parse_callback("<MyExt::never>")

        # Define how your temporal expression class handles dates.
        # Our example is easy because we always return false.
        def includes?(date)
          false
        end

        # Define an encoder for your temporal expression.  Your
        # encoder should push tokens onto +codes+ in a manner that
        # your +parse_handler+ can handle them.  Remember that the
        # temporal expressions mini-language is a stack machine that
        # pushs arguments onto the stack before your parse handler
        # sees them.
        def encode(codes)
          codes << "<MyExt::never>"
        end

        # Define a parse handler that will handle your registered
        # parse token.  At the point the handler is called,
        # arguments will have been pushed onto the stack.  All you
        # have to do is pop them off, construct your temporal
        # expression and push it back onto the stack.
        #
        # See TExp::DayInterval for an example of an expression that
        # handle arguments.
        #
        def self.parse_callback(stack)
          stack.push new
        end
      end

    end

  end
end

class ExtensionsTest < Minitest::Test
  def test_never
    te = TExp::Extensions::MyExt::Never.new
    assert ! te.includes?(Date.today)
  end

  def test_parse_never
    te = TExp.parse("<MyExt::never>")
    assert ! te.includes?(Date.today)
  end

  def test_parsing_round_trip
    assert_equal "<MyExt::never>", TExp.parse("<MyExt::never>").to_s
  end
end
