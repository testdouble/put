require "test_helper"

module Put
  class PutsThing
    class AscendingTest < Minitest::Test
      def test_asc_nils_first
        assert_equal([
          Put.asc("B", nils_first: true),
          Put.asc(nil, nils_first: true),
          Put.asc("A", nils_first: true),
          Put.asc(nil, nils_first: true)
        ].sort.map(&:value), [
          nil, nil, "A", "B"
        ])
      end

      def test_asc_nils_last
        assert_equal([
          nil,
          Put.asc(45, nils_first: false),
          nil,
          Put.asc(nil, nils_first: false),
          nil,
          Put.asc(33, nils_first: false),
          nil,
          Put.asc(nil, nils_first: false)
        ].sort.map { |o| o.respond_to?(:value) ? o.value : o }, [
          33, 45, nil, nil, nil, nil, nil, nil
        ])
      end
    end
  end
end
