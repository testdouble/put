require "test_helper"

class PutTest < Minitest::Test
  Golfer = Struct.new(:name, :age, :handicap, :member, keyword_init: true) {
    def minor?
      return if age.nil?

      age < 21
    end
  }

  def test_put
    golfers = [
      noah = Golfer.new(name: "Noah", age: 13, handicap: 18, member: true),
      eve = Golfer.new(name: "Eve", age: 42, handicap: 8, member: true),
      nate = Golfer.new(name: "Nate", age: 31, handicap: 12, member: false),
      logan = Golfer.new(name: "Logan", age: 31, handicap: 14, member: false),
      tam = Golfer.new(name: "Tam", age: 31, handicap: nil, member: false),
      tom = Golfer.new(name: "Tom", age: 31, handicap: 33, member: false),
      noah2 = Golfer.new(name: "Noah", age: 13, handicap: 16, member: true),
      harper = Golfer.new(name: "Harper", age: 32, handicap: 22, member: false),
      nill = Golfer.new(name: nil, age: 31, handicap: 18, member: false),
      avery = Golfer.new(name: "Avery", age: nil, handicap: 0, member: true)
    ]

    result = golfers.sort_by { |golfer|
      [
        (Put.last if golfer.minor?),
        (Put.first if golfer.member),
        Put.desc(golfer.age, nils_first: true),
        Put.nils_last(golfer.handicap),
        Put.asc(golfer.name),
        Put.anywhere
      ]
    }

    assert_equal([
      avery,
      eve,
      harper,
      logan,
      nate,
      tom,
      nill,
      tam
    ], result.first(8))
    assert_includes result.last(2), noah
    assert_includes result.last(2), noah2
  end

  Bot = Struct.new(:model, :age, keyword_init: true)

  def test_debug
    # Given you have heterogeneous, not comparable things:
    bots = [
      Bot.new(model: "X", age: 1),
      Bot.new(model: "Y", age: 2),
      Bot.new(model: 3, age: 2)
    ]
    # When you try to compare them anyway:
    expected_error = assert_raises do
      bots.sort_by { |bot|
        [
          Put.desc(bot.age),
          Put.asc(bot.model)
        ]
      }
    end
    # Then you'll get this unhelpful, hard to debug error
    assert_kind_of ArgumentError, expected_error
    assert_equal "comparison of Array with Array failed", expected_error.message

    # When debugging this, you can change the `sort_by` to a `map`
    bot_sorts = bots.map { |bot|
      [
        Put.desc(bot.age),
        Put.asc(bot.model)
      ]
    }
    # And pass the results to Put.debug
    result = Put.debug(bot_sorts)
    # Then see if sort_by would have raised an error:
    refute result.success?
    assert_equal 2, result.incomparables.size
    # And you can see which items were incomparable:
    x_and_3, y_and_3 = result.incomparables
    # And comparaison failed in the second item in the sorting array (i.e. Put.asc(bot.model) failed)
    assert_equal 1, x_and_3.sorting_index
    # And specifically first and third elements aren't comparable in this way:
    assert_equal 0, x_and_3.left_index
    assert_equal 2, x_and_3.right_index
    # And their values are "X" and 3
    assert_equal "X", x_and_3.left_value
    assert_equal 3, x_and_3.right_value
    assert_equal "Sorting comparator at index 1 failed, because items at indices 0 and 2 were not comparable. Their values were `\"X\"' and `3', respectively.", x_and_3.inspect
    # Same goes for the comparison of "Y" and 3:
    assert_equal "Sorting comparator at index 1 failed, because items at indices 1 and 2 were not comparable. Their values were `\"Y\"' and `3', respectively.", y_and_3.inspect
  end
end
