module Impose
  # A Page represents a single page from the source document. It
  # indicates the page (by number), as well as where on the form (column/row)
  # it should go, and whether it should be mirrored (inverted, by rotation)
  # on the form.
  class Page
    attr_reader :column, :row
    attr_reader :number
    attr_reader :mirror

    alias mirror? mirror

    def initialize(column, row, number, mirror = false)
      @column = column
      @row = row
      @number = number
      @mirror = mirror
    end
  end
end
