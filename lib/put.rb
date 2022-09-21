require_relative "put/version"

module NilExtension
  def <=>(other)
    if ::PutsThings === other
      -(other <=> self)
    else
      super
    end
  end
end
::NilClass.prepend(NilExtension)

class PutsThings
  def <=>(other)
    if value.nil? && (other.nil? || other&.value.nil?)
      0
    elsif value.nil?
      nils_first? ? -1 : 1
    elsif other.nil? || other&.value.nil?
      nils_first? ? 1 : -1
    elsif other && !other.reverse?
      value <=> other.value
    elsif other&.reverse?
      other.value <=> value
    else
      value <=> 0
    end
  end

  def reverse?
    false
  end

  def nils_first?
    false
  end

  class First < PutsThings
    def value
      -Float::INFINITY
    end
  end

  class Last < PutsThings
    def value
      Float::INFINITY
    end

    def nils_first?
      true
    end
  end

  class InOrder < PutsThings
    def initialize(value, nils_first:)
      @value = value
      @nils_first = nils_first
    end

    attr_reader :value

    def nils_first?
      @nils_first
    end
  end

  class Ascending < InOrder
  end

  class Descending < InOrder
    def reverse?
      true
    end
  end
end

module Put
  def self.first
    @@first ||= PutsThings::First.new.freeze
  end

  def self.last
    @@last ||= PutsThings::Last.new.freeze
  end

  def self.desc(value, nils_first: false)
    PutsThings::Descending.new(value, nils_first: nils_first)
  end

  def self.asc(value, nils_first: false)
    PutsThings::Ascending.new(value, nils_first: nils_first)
  end
end
