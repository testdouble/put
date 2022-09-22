require "test_helper"

module Put
  class PutsThing
    class AnywhereTest < Minitest::Test
      def test_it_seems_to_shuffle_stuff
        stuff = [1, 2, 3, 4, 5]

        result_1 = stuff.sort_by { |thing|
          [Put.anywhere]
        }
        result_2 = stuff.sort_by { |thing|
          [Put.anywhere]
        }

        refute_equal [1, 2, 3, 4, 5], result_1
        refute_equal result_1, result_2
      end
    end
  end
end
