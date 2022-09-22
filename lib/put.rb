require_relative "put/debug"
require_relative "put/version"
require_relative "put/nil_ext"
require_relative "put/puts_thing"
require_relative "put/puts_thing/anywhere"
require_relative "put/puts_thing/first"
require_relative "put/puts_thing/last"
require_relative "put/puts_thing/in_order"
require_relative "put/puts_thing/ascending"
require_relative "put/puts_thing/descending"

module Put
  def self.first
    @@first ||= PutsThing::First.new.freeze
  end

  def self.last
    @@last ||= PutsThing::Last.new.freeze
  end

  def self.desc(value, nils_first: false)
    PutsThing::Descending.new(value, nils_first: nils_first)
  end

  def self.asc(value, nils_first: false)
    PutsThing::Ascending.new(value, nils_first: nils_first)
  end

  def self.anywhere(seed: nil)
    PutsThing::Anywhere.new(seed)
  end

  def self.debug(sorting_arrays)
    Debug.new.call(sorting_arrays)
  end
end
