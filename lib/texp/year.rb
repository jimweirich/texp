module TExp
  class Year < Base
    register_parse_callback('y')

    def initialize(years)
      @years = listize(years)
    end

    def include?(date)
      @years.include?(date.year)
    end

    def inspect
      "the year is " + humanize_list(@years)
    end

    def encode(codes)
      encode_list(codes, @years)
      codes << 'y'
    end
    
    def to_hash
      { 'type' => 'y', 'y1' => @years.map { |y| y.to_s } }
    end
  end
end
