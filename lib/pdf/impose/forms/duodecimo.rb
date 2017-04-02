require 'pdf/impose/form'

module PDF
  module Impose
    module Forms
      module Duodecimo
        # cut into three 4to strips
        class TwoCut < Form
          per_signature 2

          cut_row 1, 2

          recto %w(.3 3. 0. .0),
                %w(.7 7. 4. .4),
                %w(.11 11. 8. .8)

          verso %w(.1 1. 2. .2),
                %w(.5 5. 6. .6),
                %w(.9 9. 10. .10)
        end

        # one-cut, 4to on outside
        class OneCutOutside < Form
          per_signature 2

          cut_row 2

          recto %w(*4 4* 11* *11),
                %w(.7 7. 8. .8),
                %w(.3 3. 0. .0)

          verso %w(*10 10* 5* *5),
                %w(.9 9. 6. .6),
                %w(.1 1. 2. .2)
        end

        # one-cut, 4to on inside
        class OneCutInside < Form
          per_signature 2

          cut_row 2

          recto %w(*0 0* 7* *7),
                %w(.3 3. 4. .4),
                %w(.11 11. 8. .8)

          verso %w(*6 6* 1* *1),
                %w(.5 5. 2. .2),
                %w(.9 9. 10. .10)
        end
      end
    end
  end
end

# 0 | 1 . 24
# 1 | 2 . 23
# 2 | 3 . 22
# 3 | 4 . 21
# 4 | 5 . 20
# 5 | 6 . 19
# 6 | 7 . 18
# 7 | 8 . 17
# 8 | 9 . 16
# 9 | 10 . 15
# 10 | 11 . 14
# 11 | 12 . 13
