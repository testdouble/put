module Put
  class PutsThing
    class NilsLast < NilOrder
      def nils_first?
        false
      end
    end
  end
end
