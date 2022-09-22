module Put
  class PutsThing
    class NilOrder < PutsThing
      def initialize(value)
        @value = value
      end

      def value
        if @value.nil?
          nil
        else
          0
        end
      end
    end
  end
end
