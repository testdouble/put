require_relative "put/version"
require_relative "put/nil_ext"
require_relative "put/puts_thing"

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
end
