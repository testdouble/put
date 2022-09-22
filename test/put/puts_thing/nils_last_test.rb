require "test_helper"

module Put
  class PutsThing
    class NilsLastTest < Minitest::Test
      def test_the_nils_go_last
        result = ["B", nil, "A", nil].sort_by { |thing|
          [Put.nils_last(thing)]
        }

        assert_equal ["B", "A", nil, nil], result
      end
    end
  end
end
