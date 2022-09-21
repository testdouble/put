require_relative "put/version"

class Put
  def self.first
    First
  end

  def self.last
    Last
  end

  def initialize(value)
    @value = value
  end

  First = new(-1).freeze
  Last = new(1).freeze

  def <=>(other)
    @value <=> if other
      other.value
    else
      0
    end
  end

  module NilExtension
    def <=>(other)
      if ::Put === other
        -(other <=> self)
      else
        super
      end
    end
  end

  ::NilClass.prepend(NilExtension)
end
