require 'pdf/impose/form'

module PDF
  module Impose
    module Forms
      class Sexto < Form
        per_signature 4

        recto %w(0. .0),
              %w(3* *3),
              %w(4. .4)

        verso %w(.1 1.),
              %w(*2 2*),
              %w(.5 5.)
      end
    end
  end
end

# 0 | 1 . 12
# 1 | 2 . 11
# 2 | 3 . 10
# 3 | 4 . 9
# 4 | 5 . 8
# 5 | 6 . 7
