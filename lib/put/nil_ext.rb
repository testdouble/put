module Put
  module NilExtension
    def <=>(other)
      if ::Put::PutsThing === other
        -(other <=> self)
      else
        super
      end
    end
  end
  ::NilClass.prepend(NilExtension)
end
