module Put
  class PutsThing
    class Enum < InOrder
      def initialize(value, order:, nils_first: false)
        rank = value.nil? ? nil : (order.index(value) || Float::INFINITY)
        super(rank, nils_first: nils_first)
      end
    end
  end
end
