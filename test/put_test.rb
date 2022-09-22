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
      # jaden = Golfer.new(name: "Jaden", age: 13, handicap: 18, member: true),
      # arden = Golfer.new(name: "Arden", age: 13, handicap: 18, member: true),
      # dakota = Golfer.new(name: "Dakota", age: 13, handicap: 18, member: true),
      # finley = Golfer.new(name: "Finley", age: 13, handicap: 18, member: true),
      # hayden = Golfer.new(name: "Hayden", age: 13, handicap: 18, member: true),
      # lennox = Golfer.new(name: "Lennox", age: 13, handicap: 18, member: true)
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
      Put.asc("B", nils_first: false),
      nil,
      Put.asc(nil, nils_first: false),
      nil,
      Put.asc("A", nils_first: false),
      nil,
      Put.asc(nil, nils_first: false)
    ].sort.map { |o| o.respond_to?(:value) ? o.value : o }, [
      "A", "B", nil, nil, nil, nil, nil, nil
    ])
  end
end
