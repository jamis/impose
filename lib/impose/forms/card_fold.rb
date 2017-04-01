require 'impose/form'

module Impose
  module Forms
    module CardFold
      class Octavo < Form
        per_signature 1

        layout :page_numbers

        recto %w(*3 *2 *1 *8),
              %w(.4 .5 .6 .7)
      end

      class Quarto < Form
        per_signature 1

        recto %w(*0 0*),
              %w(.1 1.)
      end
    end
  end
end
