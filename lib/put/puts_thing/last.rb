module Put
  class PutsThing
    class Last < PutsThing
      def value
        Float::INFINITY
      end

      def nils_first?
        true
      end
    end
  end
end
