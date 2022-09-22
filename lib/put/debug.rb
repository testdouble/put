module Put
  class Debug
    Result = Struct.new(:success?, :incomparables, keyword_init: true)
    Incomparable = Struct.new(
      :sorting_index, :left, :left_index, :left_value,
      :right, :right_index, :right_value, keyword_init: true
    ) {
      def inspect
        both_puts_things = left.is_a?(PutsThing) && right.is_a?(PutsThing)
        left_desc = (both_puts_things ? left_value : left).inspect
        right_desc = (both_puts_things ? right_value : right).inspect
        "Sorting comparator at index #{sorting_index} failed, because items at indices #{left_index} and #{right_index} were not comparable. Their values were `#{left_desc}' and `#{right_desc}', respectively."
      end
    }

    def call(sorting_arrays)
      sorting_arrays.sort
      Result.new(success?: true, incomparables: [])
    rescue ArgumentError
      # TODO this is O(n^lol)
      incomparables = sorting_arrays.transpose.map.with_index { |comparables, sorting_index|
        comparables.map.with_index { |comparable, comparable_index|
          comparables.map.with_index { |other, other_index|
            next if comparable_index == other_index
            if (comparable <=> other).nil?
              Incomparable.new(
                sorting_index: sorting_index,
                left: comparable,
                left_index: comparable_index,
                left_value: (comparable.value if comparable.is_a?(PutsThing)),
                right: other,
                right_index: other_index,
                right_value: (other.value if other.is_a?(PutsThing))
              )
            end
          }
        }
      }.flatten.compact.uniq { |inc|
        # Remove dupes where two items are incomparable in both <=> directions:
        [inc.sorting_index] + [inc.left_index, inc.right_index].sort
      }
      Result.new(success?: false, incomparables: incomparables)
    end
  end
end
