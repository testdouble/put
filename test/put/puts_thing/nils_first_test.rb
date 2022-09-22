require "test_helper"

module Put
  class PutsThing
    class NilsFirstTest < Minitest::Test
      def test_the_nils_go_first
        result = ["B", nil, "A", nil].sort_by { |thing|
          [Put.nils_first(thing)]
        }

        assert_equal [nil, nil, "B", "A"], result
      end
    end
  end
end
