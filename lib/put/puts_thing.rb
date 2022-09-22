module Put
  class PutsThing
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
  end
end
