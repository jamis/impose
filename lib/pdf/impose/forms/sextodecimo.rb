require 'pdf/impose/form'

module PDF
  module Impose
    module Forms
      module Sextodecimo
        # two 8vo forms that nest one inside the other
        class Nested < Form
          per_signature 2

          cut_row 2

          recto %w(7* *7 *0 0*),
                %w(4. .4 .3 3.),
                %w(15* *15 *8 8*),
                %w(12. .12 .11 11.)

          verso %w(1* *1 *6 6*),
                %w(2. .2 .5 5.),
                %w(9* *9 *14 14*),
                %w(10. .10 .13 13.)
        end
      end
    end
  end
end

# 0 | 1 . 32
# 1 | 2 . 31
# 2 | 3 . 30
# 3 | 4 . 29
# 4 | 5 . 28
# 5 | 6 . 27
# 6 | 7 . 26
# 7 | 8 . 25
# 8 | 9 . 24
# 9 | 10 . 23
# 10 | 11 . 22
# 11 | 12 . 21
# 12 | 13 . 20
# 13 | 14 . 19
# 14 | 15 . 18
# 15 | 16 . 17
