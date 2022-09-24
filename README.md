# Put puts your objects in order 💎

Put pairs with
[Enumerable#sort_by](https://ruby-doc.org/core-3.1.2/Enumerable.html#method-i-sort_by)
to provide a more expressive, fault-tolerant, and configurable approach to
sorting Ruby objects with multiple criteria.

## Put "put" in your Gemfile

You've probably already put a few gems in there, so why not put Put, too:

```ruby
gem "put"
```

Of course after you push Put, your colleagues will wonder why you put Put there.

## Before you tell me where to put it

A neat trick when applying complex sorting rules to a collection is to map them
to an array of arrays of comparable values in priority order. It's a common
approach (and a special subtype of what's called a [Schwartzian
transform](https://en.wikipedia.org/wiki/Schwartzian_transform)), but the
pattern doesn't have a widely-accepted name yet, so let's use code to explain.

Suppose you have some people:

```ruby
Person = Struct.new(:name, :age, :rubyist?, keyword_init: true)

people = [
  Person.new(name: "Tam", age: 22),
  Person.new(name: "Zak", age: 33),
  Person.new(name: "Axe", age: 33),
  Person.new(name: "Qin", age: 18, rubyist?: true),
  Person.new(name: "Zoe", age: 28, rubyist?: true)
]
```

And you want to sort these people in the following priority order:

1. Put any Rubyists at the _top_ of the list, as is right and good
2. If both are (or are not) Rubyists, break the tie by sorting by age descending
3. Finally, break any remaining ties by sorting by name ascending

Here's what the aforementioned pattern to accomplish this usually looks like
using
[Enumerable#sort_by](https://ruby-doc.org/core-3.1.2/Enumerable.html#method-i-sort_by):

```ruby
people.sort_by { |person|
  [
    person.rubyist? ? 0 : 1,
    person.age * -1,
    person.name
  ]
} # => Zoe, Qin, Axe, Zak, Tam
```

The above will return everyone in the right order. This has a few drawbacks,
though:

* Unless you're already familiar with this pattern that nobody's bothered to
give a name before, this code isn't very expressive. As a result, each line
is almost begging for a code comment above it to explain its intent
* Ternary operators are confusing, especially with predicate methods like
`rubyist?` and especially when returning [magic
number](https://en.wikipedia.org/wiki/Magic_number_(programming))'s like `1` and
`0`.
* Any `nil` values will result in a bad time. If a person's `age` is nil, you'll
get "_undefined method '*' for nil:NilClass_" `NoMethodError`
* Relatedly, if any two items aren't comparable (i.e. `<=>` returns nil), you'll
  be greeted with an inscrutable `ArgumentError` that just says "_comparison of
  Array with Array failed_"

Here's the same code example if you put Put in there:

```ruby
people.sort_by { |person|
  [
    (Put.first if person.rubyist?),
    Put.desc(person.age),
    Put.asc(person.name)
  ]
} # => Zoe, Qin, Axe, Zak, Tam
```

The Put gem solves every one of the above issues:

* Put's methods have actual names. In fact, let's just call this the "Put
  pattern" while we're at it
* No ternaries necessary
* It's quite `nil` friendly
* It ships with a `Put.debug` method that helps you introspect those
  impenetrable `ArgumentError` messages whenever any two values turn out not to
  be comparable

After reading this, your teammates will be glad they put you in charge of
putting gems like Put in the Gemfile.

## When you Put it that way

Put's API is short and sweet. In fact, you've already put up with most of it.

### Put.first

When a particular condition indicates an item should go to the top of a list,
you'll want to designate a position in your mapped `sort_by` arrays to return
either `Put.first` or `nil`, like this:

```ruby
[42, 12, 65, 99, 49].sort_by { |n|
  [(Put.first if n.odd?)]
} # => 65, 99, 49, 42, 12
```

### Put.last

When a sort criteria should go to the bottom of the list, you can do the same
sort of conditional expression with `Put.last`:

```ruby
%w[Jin drinks Gin on Gym day].sort_by { |s|
  [(Put.last unless s.match?(/[A-Z]/))]
} # => ["Jin", "Gin", "Gym", "drinks", "on", "day"]
```

### Put.asc(value, nils_first: false)

The `Put.asc` method provides a nil-safe way to sort a value in ascending order:

```ruby
%w[The quick brown fox].sort_by { |s|
  [Put.asc(s)]
} # => ["The", "brown", "fox", "quick"]
```

It also supports an optional `nils_first` keyword argument that defaults to
false (translation: nils are sorted last by default), which looks like this:

```ruby
[3, nil, 1, 5].sort_by { |n|
  [Put.asc(n, nils_first: true)]
} # => [nil, 1, 3, 5]
```

### Put.desc(value, nils_first: false)

The opposite of `Put.asc` is `Put.desc`, and it works as you might suspect:

```ruby
%w[Aardvark Zebra].sort_by { |s|
  [Put.desc(s)]
} # => ["Zebra", "Aardvark"]
```

And also like `Put.asc`, `Put.desc` has an optional `nils_first` keyword
argument when you want nils on top:

```ruby
[1, nil, 2, 3].sort_by { |n|
  [Put.desc(n, nils_first: true)]
} # => [nil, 3, 2, 1]
```

### Put.anywhere

You're sorting stuff, so naturally _order matters_. But when building a compound
`sort_by` expression, order matters less as you add more and more tiebreaking
criteria. In fact, sometimes shuffling items is the more appropriate than
leaving things in their original order. Enter `Put.anywhere`, which can be
called without any argument at any index in the mapped sorting array:

```ruby
[1, 3, 4, 7, 8, 9].sort_by { |n|
  [
    (Put.first if n.even?),
    Put.anywhere
  ]
} # => [8, 4, 1, 7, 9, 3]
```

### Put.nils_first(value)

If you're sorting items and you know some not-comparable `nil` values are going
to appear, you can put all the nils on top with `Put.nil_first(value)`. Note
that _unlike_ `Put.asc` and `Put.desc`, it won't actually sort the values—it'll
just pull all the nils up!

```ruby
[:fun, :stuff, nil, :here].sort_by { |val|
  [Put.nils_first(val)]
} # => [nil, :fun, :stuff, :here]
```

### Put.nils_last(value)

As you might be able to guess, `Put.nils_last` puts the nils last:

```ruby
[:every, nil, :counts].sort_by { |val|
  [Put.nils_last(val)]
} # => [:every, :counts, nil]
```

### Put.debug(sorting_arrays)

If you see "comparison of Array with Array failed" and you don't have any idea
what is going on, try debugging by changing `sort_by` to `map` and passing it
to `Put.debug`.

For an interactive example of how to debug this issue with `Put.debug`, take a
look [at this test case](/test/put_test.rb#L53-L98).

## Put your hands together! 👏

Many thanks to [Matt Jones](https://github.com/al2o3cr) and [Matthew
Draper](https://github.com/matthewd) for answering a bunch of obscure questions
about comparisons in Ruby and implementing the initial prototype, respectively.
👏👏👏

## Code of Conduct

This project follows Test Double's [code of
conduct](https://testdouble.com/code-of-conduct) for all community interactions,
including (but not limited to) one-on-one communications, public posts/comments,
code reviews, pull requests, and GitHub issues. If violations occur, Test Double
will take any action they deem appropriate for the infraction, up to and
including blocking a user from the organization's repositories.
