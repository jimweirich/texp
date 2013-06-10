module TExp
  module DSL

    # Utility methods used by the DSL methods. We put the utility
    # methods in their own module to avoid name pollution when the DSL
    # module is included into client code.
    #
    module Util
      module_function

      WEEKNAMES = {
        "fi" => 1,
        "se" => 2,
        "th" => 3,
        "fo" => 4,
        "fi" => 5,
        "la" => -1
      }
      MONTHNAMES = Date::MONTHNAMES.collect { |mn| mn ? mn[0,3].downcase : nil }
      DAYNAMES = Date::DAYNAMES.collect { |dn| dn[0,2].downcase }

      UNIT_MULTIPLIERS = {
        :day => 1,      :days => 1,
        :week => 7,     :weeks => 7,
        :month => 30,   :months => 30,
        :year => 365,   :years => 365,
      }

      def apply_units(unit, value)
        multiplier = UNIT_MULTIPLIERS[unit]
        raise TExpUnitError, "Unknown unit #{unit}" unless multiplier
        multiplier * value
      end

      def coerce_date(date)
        case date
        when Date
          date
        when String
          try_parsing(date)
        else
          fail ArgumentError, "Unknown date '#{date}'"
        end
      end

      def try_parsing(string)
        Date.parse(string)
      rescue ArgumentError => ex
        fail ArgumentError, "Unknown date '#{string}' (#{ex.message})"
      end

      def dm_args(args)
        day, month = args
        month = normalize_month(month)
        check_valid_day_month(day, month)
        [day, month]
      end

      def dmy_args(args)
        day, month, year = args
        month = normalize_month(month)
        check_valid_day_month(day, month)
        [day, month, year]
      end

      def check_valid_day_month(day, month)
        unless day.kind_of?(Integer) &&
            day >= 1 &&
            day <= 31
          fail ArgumentError, "bad day '#{month}'"
        end
        unless month.kind_of?(Integer) &&
            month >= 1 &&
            month <= 12
          fail ArgumentError, "bad month '#{month}'"
        end
      end

      def normalize_weeks(weeks)
        weeks.collect { |w| normalize_week(w) }
      end

      def normalize_week(week)
        case week
        when Integer
          week
        else
          WEEKNAMES[week.to_s[0,2].downcase]
        end
      end

      def normalize_months(months)
        months.collect { |m| normalize_month(m) }
      end

      def normalize_month(month_thing)
        case month_thing
        when Integer
          month_thing
        else
          MONTHNAMES.index(month_thing.to_s[0,3].downcase)
        end
      end

      def normalize_dows(dow_list)
        dow_list.collect { |dow| normalize_dow(dow) }
      end

      def normalize_dow(dow_thing)
        case dow_thing
        when Integer
          dow_thing
        else
          DAYNAMES.index(dow_thing.to_s[0,2].downcase)
        end
      end

      # Evaluate a temporal expression in the TExp environment.
      # Redirect missing method calls to the containing environment.
      def evaluate_expression_in_environment(&block) # :nodoc:
        env = EvalEnvironment.new(block.binding)
        env.instance_eval(&block)
      end

      def normalize_units(args)   # :nodoc:
        result = []
        while ! args.empty?
          arg = args.shift
          case arg
          when Numeric
            result.push(arg)
          when Symbol
            result.push(Util.apply_units(arg, result.pop))
          else
            fail ArgumentError, "Unabled to recognize #{arg.inspect}"
          end
        end
        result
      end
    end
  end


  # Internal class that provides an evaluation environment for
  # temporal expressions.  The temporal expression DSL methods are
  # not generally exposed outside of the TExp module, meaning that
  # any coded temporal expression must be prefixed with the TExp
  # module name.  This is cumbersome for a DSL.
  #
  # One solution is to just include the TExp module wherever you
  # wish to use temporal expressions.  Including at the top level
  # would make them available everywhere, but would also pollute the
  # top level namespace with all of TExp's methods.
  #
  # An alternate solution is to use a block that is instance_eval'ed
  # in the TExp namespace.  Within in the block you can reference the
  # TExp DSL methods freely, but they do not pollute any namespaces
  # outside the block.
  #
  # Unfortunately, the instance_eval technique will cut off access to
  # methods defined in the calling namespace (since we are using
  # TExp's environment instead).  The EvalEnvironment handles this by
  # directing any unknown methods to the calling environment, making
  # the instance_eval technique much more friendly.
  #
  # See the +texp+ method to see how this class is used.
  #
  class EvalEnvironment
    include DSL

    # Create a TExp environment for evaluating temporal expressions.
    # Use the block binding to find the object where the block is
    # embeded.
    def initialize(containing_env)
      @container = eval "self", containing_env
    end

    # The methods identified by +sym+ is not found in the TExp
    # namespace.  Try calling it in the containing namespace.
    def method_missing(sym, *args, &block)
      @container.send(sym, *args, &block)
    end
  end

end
