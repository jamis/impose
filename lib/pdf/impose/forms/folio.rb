require 'pdf/impose/form'

module PDF
  module Impose
    module Forms
      module Folio
        class Standard < Form
          per_signature 8

          recto %w(0. .0)
          verso %w(.1 1.)
        end

        class Recto < Form
          per_signature 1

          cut_col 1

          layout :page_numbers

          recto %w(.1 .2)
        end
      end
    end
  end
end
