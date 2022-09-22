module Put
  class PutsThing
    def <=>(other)
      if value.nil? && (other.nil? || other&.value.nil?)
        0
      elsif value.nil?
        nils_first? ? -1 : 1
      elsif other.nil? || other&.value.nil?
        nils_first? ? 1 : -1
      elsif other && !other.reverse?
        value <=> other.value
      elsif other&.reverse?
        other.value <=> value
      else
        value <=> 0
      end
    end

    def reverse?
      false
    end

    def nils_first?
      false
    end

    class First < PutsThing
      def value
        -Float::INFINITY
      end
    end

    class Last < PutsThing
      def value
        Float::INFINITY
      end

      def nils_first?
        true
      end
    end

    class InOrder < PutsThing
      def initialize(value, nils_first:)
        @value = value
        @nils_first = nils_first
      end

      attr_reader :value

      def nils_first?
        @nils_first
      end
    end

    class Ascending < InOrder
    end

    class Descending < InOrder
      def reverse?
        true
      end
    end
  end
end
