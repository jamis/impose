# This takes a PDF and fits either 72 (MiniBook::Octavo) or 84
# (MiniBook::TripleQuarto) leaves on a single sheet of paper. If
# used with LETTER size paper, this can produce a text block that
# is roughly 1.25 inches by 1 inch.
#
# See https://twitter.com/jamis/status/847497088950599685

require 'pdf/impose/builder'

# Notes on book structure:
#
# * blank sheet is glued to cover and first signature (endpapers)
#
# * half-title - page 1
# * blank - 2 (verso of 1)
# * title - 3
# * colophon - 4 (verso of 3)
# * dedication - 5
# * blank - 6 (verso of 5)
# * contents - 7 - end
#
# * blank sheet is glued to cover and last signature (endpapers)
#
# 72 double-sided leaves => 144 pages
# 84 double-sided leaves => 168 pages
#
# Thus, if using a traditional book structure, you reserve the
# first six pages and produce content for the rest (138 or 162).

module MiniBook
  class TripleQuarto < PDF::Impose::Form
    per_signature 2

    cut_row 1, 2, 3, 4, 5, 6, 7
    cut_col 4, 8

    layout :page_numbers

    recto %w(.24 .1 .4 .21 .20 .5 .8 .17 .16 .9 .12 .13),
          %w(.48 .25 .28 .45 .44 .29 .32 .41 .40 .33 .36 .37),
          %w(.72 .49 .52 .69 .68 .53 .56 .65 .64 .57 .60 .61),
          %w(.96 .73 .76 .93 .92 .77 .80 .89 .88 .81 .84 .85),
          %w(.120 .97 .100 .117 .116 .101 .104 .113 .112 .105 .108 .109),
          %w(.144 .121 .124 .141 .140 .125 .128 .137 .136 .129 .132 .133),
          %w(.168 .145 .148 .165 .164 .149 .152 .161 .160 .153 .156 .157)

    verso %w(.14 .11 .10 .15 .18 .7 .6 .19 .22 .3 .2 .23),
          %w(.38 .35 .34 .39 .42 .31 .30 .43 .46 .27 .26 .47),
          %w(.62 .59 .58 .63 .66 .55 .54 .67 .70 .51 .50 .71),
          %w(.86 .83 .82 .87 .90 .79 .78 .91 .94 .75 .74 .95),
          %w(.110 .107 .106 .111 .114 .103 .102 .115 .118 .99 .98 .119),
          %w(.134 .131 .130 .135 .138 .127 .126 .139 .142 .123 .122 .143),
          %w(.158 .155 .154 .159 .162 .151 .150 .163 .166 .147 .146 .167)
  end

  class Octavo < PDF::Impose::Form
    per_signature 2

    layout :page_numbers

    cut_row 2, 4
    cut_col 4, 8

    recto %w(*1 *16 *9 *8 *17 *32 *25 *24 *33 *48 *41 *40),
          %w(.4 .13 .12 .5 .20 .29 .28 .21 .36 .45 .44 .37),
          %w(*49 *64 *57 *56 *65 *80 *73 *72 *81 *96 *89 *88),
          %w(.52 .61 .60 .53 .68 .77 .76 .69 .84 .93 .92 .85),
          %w(*97 *112 *105 *104 *113 *128 *121 *120 *129 *144 *137 *136),
          %w(.100 .109 .108 .101 .116 .125 .124 .117 .132 .141 .140 .133)

    verso %w(*39 *42 *47 *34 *23 *26 *31 *18 *7 *10 *15 *2),
          %w(.38 .43 .46 .35 .22 .27 .30 .19 .6 .11 .14 .3),
          %w(*87 *90 *95 *82 *71 *74 *79 *66 *55 *58 *63 *50),
          %w(.86 .91 .94 .83 .70 .75 .78 .67 .54 .59 .62 .51),
          %w(*135 *138 *143 *130 *119 *122 *127 *114 *103 *106 *111 *98),
          %w(.134 .139 .142 .131 .118 .123 .126 .115 .102 .107 .110 .99)
  end
end


filename = ARGV[0] or abort 'please specify a filename to read'

imposer = PDF::Impose::Builder.new(filename,
                                   orientation: :landscape,
                                   layout: MiniBook::Octavo)

imposer.emit 'minibook.pdf'
