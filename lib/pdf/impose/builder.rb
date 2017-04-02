require 'pdf/reader'
require 'prawn'
require 'prawn/templates'

require 'pdf/impose/ext'
require 'pdf/impose/forms/card_fold'
require 'pdf/impose/forms/duodecimo'
require 'pdf/impose/forms/folio'
require 'pdf/impose/forms/quarto'
require 'pdf/impose/forms/octavo'
require 'pdf/impose/forms/sexto'
require 'pdf/impose/forms/sextodecimo'
require 'pdf/impose/signature'

module PDF
  module Impose
    class Builder
      PRIMARY_LAYOUTS = {
        'card-fold4' => PDF::Impose::Forms::CardFold::Quarto,
        'card-fold8' => PDF::Impose::Forms::CardFold::Octavo,
        'folio' => PDF::Impose::Forms::Folio,
        'quarto' => PDF::Impose::Forms::Quarto,
        'sexto' => PDF::Impose::Forms::Sexto,
        'octavo' => PDF::Impose::Forms::Octavo,
        'duodecimo' => PDF::Impose::Forms::Duodecimo::OneCutOutside,
        'duodecimo-i' => PDF::Impose::Forms::Duodecimo::OneCutInside,
        'duodecimo-2c' => PDF::Impose::Forms::Duodecimo::TwoCut,
        'sextodecimo' => PDF::Impose::Forms::Sextodecimo::Nested
      }.freeze

      ALIASES = {
        'card-fold4' => %w( card-fold ),
        'card-fold8' => %w( ),
        'folio' => %w( f fo ),
        'quarto' => %w( 4to ),
        'sexto' => %w( 6to 6mo ),
        'octavo' => %w( 8vo octavo ),
        'duodecimo' => %w( twelvemo 12mo ),
        'duodecimo-i' => %w( twelvemo-i 12mo-i ),
        'duodecimo-2c' => %w( twelvemo-2c 12mo-2c ),
        'sextodecimo' => %w( sixteenmo 16mo )
      }.freeze

      LAYOUTS = ALIASES.keys.each_with_object({}) do |key, hash|
        hash[key] = PRIMARY_LAYOUTS[key]
        ALIASES[key].each { |name| hash[name] = hash[key] }
      end.freeze

      # source: the name of a PDF document to lay out
      # options:
      #   layout: quarto, octavo, etc.
      #   page_size: passed through to Prawn
      #   orientation: passed through to Prawn as :page_layout
      #   forms_per_signature: defaults to layout.per_signature
      #   margin: point size of margin of page (default = 32 points)
      #   start_page: defaults to 1
      #   end_page: defaults to last page of source document
      #   marks: true or false, whether to include registration marks (default true)
      def initialize(source, options={})
        layout_arg = options[:layout]

        @layout = if layout_arg.respond_to?(:recto)
                    layout_arg
                  else
                    LAYOUTS[options[:layout].to_s.downcase]
                  end

        raise "`#{options[:layout]}' is not a supported layout" if @layout.nil?

        @margin = options[:margin] || 36 # half inch
        @marks = options.fetch(:marks, true)

        @source = PDF::Reader.new(source)
        @destination = Prawn::Document.new(
          skip_page_creation: true, margin: 0,
          page_size: options[:page_size], page_layout: options[:orientation])

        @start_page = options[:start_page] || 1
        @end_page = [options[:end_page] || 1e6, @source.page_count].min

        @page_count = @end_page - @start_page + 1

        @forms_per_signature = options[:forms_per_signature] ||
                               @layout.per_signature
        @pages_per_signature = @forms_per_signature * @layout.pages_per_form

        @signature_count = (@page_count + @pages_per_signature - 1) /
                           @pages_per_signature

        @signatures = (1..@signature_count).map do |s|
          first = (s - 1) * @pages_per_signature + @start_page
          last = first + @pages_per_signature - 1
          Signature.new(first, last)
        end

        _apply
      end

      def emit(filename)
        @destination.render_file filename
      end

      def _apply
        source_width = @source.page(1).page_object[:MediaBox][2]
        source_height = @source.page(1).page_object[:MediaBox][3]

        height = @destination.margin_box.height

        sheet_width = @destination.margin_box.width - @margin * 2
        sheet_height = height - @margin * 2

        max_cell_width = sheet_width / @layout.columns_per_form
        max_cell_height = sheet_height / @layout.rows_per_form

        width_ratio = max_cell_width.to_f / source_width
        height_ratio = max_cell_height.to_f / source_height
        scale = [width_ratio, height_ratio].min

        cell_width = source_width * scale
        cell_height = source_height * scale

        form_width = cell_width * @layout.columns_per_form
        form_height = cell_height * @layout.rows_per_form

        recto = true
        @layout.layout_signatures(@signatures) do |form|
          left = if recto
                   @destination.margin_box.width - @margin - form_width
                 else
                   @margin
                 end

          @destination.start_new_page

          _draw_guides(recto, form_width, form_height) if @marks

          form.each_page do |page|
            x = page.column * cell_width + left
            y = height - (page.row + 1) * cell_height - @margin
            @destination.page.import_page @source, page.number - 1,
                                          x, y, cell_width, cell_height,
                                          page.mirror?
          end

          recto = !recto
        end

        self
      end

      def _draw_guides(recto, width, height)
        if recto
          x2 = @destination.margin_box.width - @margin
          x1 = x2 - width
        else
          x1 = @margin
          x2 = x1 + width
        end

        y2 = @destination.margin_box.height - @margin
        y1 = y2 - height

        l1 = x1 - @margin / 2.0
        l2 = l1 + @margin / 4.0
        r1 = x2 + @margin / 4.0
        r2 = x2 + @margin / 2.0

        b1 = y1 - @margin / 2.0
        b2 = y1 - @margin / 4.0
        t1 = y2 + @margin / 4.0
        t2 = y2 + @margin / 2.0

        cx = recto ? (r1 + r2) / 2 : (l1 + l2) / 2
        cy = (t1 + t2) / 2
        radius = (r2 - r1) / 2

        @destination.stroke do
          @destination.line([l1, y1], [l2, y1])
          @destination.line([l1, y2], [l2, y2])
          @destination.line([r1, y1], [r2, y1])
          @destination.line([r1, y2], [r2, y2])

          @destination.line([x1, t1], [x1, t2])
          @destination.line([x2, t1], [x2, t2])
          @destination.line([x1, b1], [x1, b2])
          @destination.line([x2, b1], [x2, b2])

          @destination.circle([cx, cy], radius)
          @destination.line([cx - 1.5 * radius, cy], [cx + 1.5 * radius, cy])
          @destination.line([cx, cy - 1.5 * radius], [cx, cy + 1.5 * radius])
        end

        cut_rows = @layout.cut_row || []
        if cut_rows.any?
          row_height = height.to_f / @layout.rows_per_form

          @destination.stroke do
            cut_rows.each do |row|
              y = y2 - row_height * row
              @destination.line([l1, y], [l2, y])
              @destination.line([r1, y], [r2, y])
            end
          end
        end

        cut_cols = @layout.cut_col || []
        if cut_cols.any?
          col_width = width.to_f / @layout.columns_per_form

          @destination.stroke do
            cut_cols.each do |col|
              x = x1 + col_width * col
              @destination.line([x, t1], [x, t2])
              @destination.line([x, b1], [x, b2])
            end
          end
        end
      end
    end
  end
end
