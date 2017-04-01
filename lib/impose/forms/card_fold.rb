require 'impose/form'

module Impose
  module Forms
    module CardFold
      class Octavo < Form
        per_signature 1

        recto %w(0. .0 .1 .2),
              %w(1* 2* 3* *3)
      end

      class Quarto < Form
        per_signature 1

        recto %w(0. .0),
              %w(1* *1)
      end
    end
  end
end
