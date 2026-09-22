require "test_helper"

module Put
  class PutsThing
    class EnumTest < Minitest::Test
      def test_matched_values_sort_by_order_position
        result = [:director, :staff, :manager].sort_by { |role|
          [Put.enum(role, order: [:staff, :manager, :director])]
        }

        assert_equal [:staff, :manager, :director], result
      end

      def test_unmatched_value_sorts_after_every_matched_value_and_before_nil
        result = [nil, :contractor, :director, :staff].sort_by { |role|
          [Put.enum(role, order: [:staff, :director])]
        }

        assert_equal [:staff, :director, :contractor, nil], result
      end

      def test_nil_sorts_last_by_default
        result = [nil, :staff, :director].sort_by { |role|
          [Put.enum(role, order: [:staff, :director])]
        }

        assert_equal [:staff, :director, nil], result
      end

      def test_nil_sorts_first_when_nils_first_is_true
        result = [:staff, nil, :director].sort_by { |role|
          [Put.enum(role, order: [:staff, :director], nils_first: true)]
        }

        assert_equal [nil, :staff, :director], result
      end

      def test_nil_sorts_after_matched_and_unmatched_values_by_default
        result = [nil, :contractor, :director, :staff].sort_by { |role|
          [Put.enum(role, order: [:staff, :director])]
        }

        assert_equal [:staff, :director, :contractor, nil], result
      end

      def test_nil_sorts_before_matched_and_unmatched_values_when_nils_first_is_true
        result = [:staff, :contractor, nil, :director].sort_by { |role|
          [Put.enum(role, order: [:staff, :director], nils_first: true)]
        }

        assert_equal [nil, :staff, :director, :contractor], result
      end

      def test_repeated_order_entry_ranks_by_first_occurrence
        result = [:director, :staff].sort_by { |role|
          [Put.enum(role, order: [:staff, :director, :staff])]
        }

        assert_equal [:staff, :director], result
      end

      def test_nil_entry_in_order_has_no_effect_on_ranking
        result = [nil, :director, :staff].sort_by { |role|
          [Put.enum(role, order: [nil, :staff, :director])]
        }

        assert_equal [:staff, :director, nil], result
      end

      def test_same_rank_values_compare_as_equal
        a = Put.enum(:staff, order: [:staff, :director])
        b = Put.enum(:staff, order: [:staff, :director])

        assert_equal 0, a <=> b
      end
    end
  end
end
