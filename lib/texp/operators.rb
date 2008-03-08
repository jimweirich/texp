module TExp
  class Base
    def +(texp)
      TExp::Or.new(self, texp)
    end
    def *(texp)
      TExp::And.new(self, texp)
    end
    def -(texp)
      TExp::And.new(self, TExp::Not.new(texp))
    end
    def -@()
      TExp::Not.new(self)
    end
  end
end
