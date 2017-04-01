require 'impose/form'

module Impose
  module Forms
    class Octavo < Form
      per_signature 2

      recto %w(3* *3 *0 0*),
            %w(4. .4 .7 7.)

      verso %w(1* *1 *2 2*),
            %w(6. .6 .5 5.)
    end
  end
end

# 0 | 1 . 16
# 1 | 2 . 15
# 2 | 3 . 14
# 3 | 4 . 13
# 4 | 5 . 12
# 5 | 6 . 11
# 6 | 7 . 10
# 7 | 8 . 9
