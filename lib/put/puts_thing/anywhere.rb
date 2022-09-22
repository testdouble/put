module Put
  class PutsThing
    class Anywhere < PutsThing
      def initialize(seed)
        @random = seed.nil? ? Random.new : Random.new(seed)
      end

      def value
        @random.rand
      end
    end
  end
end
