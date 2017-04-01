# Impose

`Impose` is a utility and library for reformatting PDF files, in order to lay out multiple pages of the original document on a single page. The original pages are arranged in such a way that the new page may be folded and cut to produce a _signature_--a small booklet in which the pages are in the expected order. In this way, an existing PDF can be printed, folded, cut, and bound into a handmade book or booklet.

This process of laying out pages in this way is called [_imposition_](https://en.wikipedia.org/wiki/Imposition).


## Installation

Impose and its dependencies may be installed via RubyGems:

    $ gem install pdf-impose


## Usage

The easiest way to use Impose is via the command-line tool:

    $ impose -h
    Usage: impose [options] <input.pdf>
      -l, --layout LAYOUT    The form to use when laying out pages for imposition.
                             Default is "quarto".
                             (Specify "list" to see all available forms.)
      -o, --orient ORIENT    How each sheet should be oriented.
                             Possible options are "portrait" or "landscape".
                             Default is "portrait".
      -f, --forms COUNT      The number of forms to use for each signature.
                             Default is dependent on the form used.
      -d, --dimensions DIM   Either the name of a paper size, or a WxH (width/height)
                             specification. Measurements must be in points.
                             Default is "LETTER".
                             (Specify "list" to see all named paper sizes.)
      -m, --margin SIZE      The minimum margin (in points) for the chosen form.
                             Default is 36 points.
      -s, --start PAGE       The page at which to start imposing.
                             Default is 1.
      -e, --end PAGE         The page at which to stop imposing.
                             Default is the last page of the source document.
      -M, --[no-]marks       Whether or not to include registration marks.
                             Default is to include registration marks.
      -O, --output FILENAME  The name of the file to which to write the resulting PDF.
                             Default is the original filename with "imposed" appended.
      -h, --help             This help screen.

To impose an existing PDF in quarto on A4 sheets, the following would suffice:

    $ impose -l quarto -d A4 my-document.pdf

This would produce a new PDF called `my-document-imposed.pdf`.


## Layouts and Forms

The process of imposition takes a source document and lays out its pages in a particular form. The form used depends on how many pages you want to fit on a single sheet, and how many times you want to fold the paper to produce a signature.

`Impose` supports several common imposition forms, which should satisfy most needs. If you need a specific layout, though, it is not hard to define a custom imposition form. (See the "minibook" example in this repository.)
