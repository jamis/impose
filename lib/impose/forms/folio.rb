require 'impose/form'

module Impose
  module Forms
    class Folio < Form
      per_signature 8

      recto %w(0. .0)
      verso %w(.1 1.)
    end
  end
end
