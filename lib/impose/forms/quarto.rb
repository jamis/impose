require 'impose/form'

module Impose
  module Forms
    class Quarto < Form
      per_signature 4

      recto %w(3* *3),
            %w(0. .0)

      verso %w(*2 2*),
            %w(.1 1.)
    end
  end
end

# 0 | 1 . 8
# 1 | 2 . 7
# 2 | 3 . 6
# 3 | 4 . 5
