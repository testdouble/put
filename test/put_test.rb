require "test_helper"

class PutTest < Minitest::Test
  Golfer = Struct.new(:name, :age, :handicap, :member, keyword_init: true) {
    def minor?
      return if age.nil?

      age < 21
    end
  }

  def test_sorting_golfers
    golfers = [
      noah = Golfer.new(name: "Noah", age: 13, handicap: 18, member: true),
      eve = Golfer.new(name: "Eve", age: 42, handicap: 8, member: true),
      nate = Golfer.new(name: "Nate", age: 31, handicap: 12, member: false),
      logan = Golfer.new(name: "Logan", age: 31, handicap: 14, member: false),
      harper = Golfer.new(name: "Harper", age: 32, handicap: 22, member: false),
      nill = Golfer.new(name: nil, age: 31, handicap: 18, member: false),
      avery = Golfer.new(name: "Avery", age: nil, handicap: 0, member: true)
    ]

    result = golfers.sort_by { |golfer|
      [
        (Put.last if golfer.minor?),
        (Put.first if golfer.member),
        Put.desc(golfer.age, nils_first: true),
        Put.asc(golfer.name)
      ]
    }

    assert_equal([
      avery,
      eve,
      harper,
      logan,
      nate,
      nill,
      noah
    ], result)
  end

  end
