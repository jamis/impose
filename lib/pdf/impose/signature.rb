module PDF
  module Impose
    # A signature is composed of one or more forms.
    class Signature
      attr_reader :first, :last, :pairs

      def initialize(first, last)
        @first = first
        @last = last

        @pairs = []
        f, l = first, last
        while f < l
          @pairs << [f, l]
          f += 1
          l -= 1
        end
      end
    end
  end
end
