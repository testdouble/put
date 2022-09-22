module Put
  class PutsThing
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
  end
end
