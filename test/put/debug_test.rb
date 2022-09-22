require "test_helper"

module Put
  class DebugTest < Minitest::Test
    Dingus = Struct.new(:name, keyword_init: true)

    def setup
      @subject = Debug.new
    end

    def test_sortable_stuff_doesnt_fail
      dinguses = [Dingus.new(name: "Jerry"), Dingus.new(name: "Justin")]

      result = @subject.call(dinguses.map { |dingus|
        [Put.asc(dingus.name)]
      })

      assert result.success?
      assert_equal 0, result.incomparables.size
    end
  end
end
