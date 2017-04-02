require 'pdf/impose/page'

module PDF
  module Impose
    # A Form represents a collection of pages that will be printed together on a
    # single sheet of paper, in a particular (grid) layout.
    #
    # Form subclasses define the layout of individual pages via the `recto` and
    # `verso` methods (`recto` == front, `verso` == back).
    #
    #    class Quarto < Form
    #      per_signature 4
    #
    #      recto %w(3* *3),
    #            %w(0. .0)
    #
    #      verso %w(1* *1),
    #            %w(2. .2)
    #    end
    #
    # Each row of the recto/verso configuration is a series of cells, representing
    # individual pages. They take the following format:
    #
    #   *n OR .n OR n* OR n.
    #
    # 'n' is which pair from the signature is to be set in this position. If the
    # dot or asterisk comes before the number, then the first element of the pair
    # is used (the lower page number). If the dot or asterisk comes after, then
    # the last element of the pair is used (the higher page number).
    #
    # A '.' means the page is set without rotation. A '*' means the page is
    # rotated 180 degrees to turn it upside down.

    class Form
      class <<self
        attr_reader :rows_per_form, :columns_per_form

        def per_signature(n = nil)
          @per_signature = n || @per_signature
        end

        def pages_per_form
          rows_per_form * columns_per_form
        end

        def cut_row(*rows)
          @cut_row = rows.any? ? rows : @cut_row
        end

        def cut_col(*cols)
          @cut_col = cols.any? ? cols : @cut_col
        end

        # method can be :pages or :signatures (the default), and determines what
        # the numbers in the recto/verso layouts represent.
        def layout(method = nil)
          @layout = method || @layout
        end

        def recto(*rows)
          if rows.any?
            @recto = _parse_configuration(rows)
          else
            @recto
          end
        end

        def verso(*rows)
          if rows.any?
            @verso = _parse_configuration(rows)
          else
            @verso
          end
        end

        def layout_signatures(signatures)
          l = layout || :signatures
          signatures.each do |signature|
            offset = 0
            while offset < signature.pairs.length
              [recto, verso].compact.each do |side|
                pages = []

                side.each do |element|
                  n = if l == :signatures
                        idx = offset + element.offset
                        signature.pairs[idx].send(element.which)
                      else
                        signature.pairs[offset].first + element.offset - 1
                      end

                  pages << PDF::Impose::Page.new(element.column, element.row,
                                                 n, element.flip)
                end

                yield self.new(pages)
              end

              offset += pages_per_form
            end
          end

          self
        end

        class LayoutElement < Struct.new(:column, :row, :offset, :which, :flip)
        end

        def _parse_configuration(rows)
          @rows_per_form = rows.length
          @columns_per_form = rows[0].length

          [].tap do |config|
            rows.each.with_index do |columns, row|
              columns.each.with_index do |cell, column|
                if cell !~ /^\s*([*.])?(\d+)([*.])?\s*$/
                  raise "invalid form specification: #{cell.inspect}"
                end

                first = $1
                ofs   = $2.to_i
                last  = $3

                if first.nil? && last.nil?
                  raise "invalid form specification: #{cell.inspect}"
                end

                flip = (first || last) == '*'
                config << LayoutElement.new(column, row, ofs,
                                            first ? :first : :last, flip)
              end
            end
          end
        end
      end

      attr_reader :pages

      def initialize(pages)
        @pages = pages
      end

      def each_page
        @pages.each { |page| yield page }
        self
      end
    end
  end
end
