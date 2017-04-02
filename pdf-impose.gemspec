$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'pdf/impose/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'pdf-impose'
  s.version     = PDF::Impose::VERSION
  s.authors     = ['Jamis Buck']
  s.email       = ['jamis@jamisbuck.org']
  s.homepage    = 'http://github.com/jamis/impose'
  s.summary     = 'A utility and library for imposition -- arranging pages on a sheet of paper for optimal printing'
  s.description = <<-DESC
    Arrange pages of existing PDF documents so they fit on a single page, and
    so they can be folded and cut to produce signatures that may then be assembled
    to form a bound book.
  DESC
  s.license = 'MIT'

  s.files = Dir['{bin,lib}/**/*', 'MIT-LICENSE', 'README.md']
  s.executables << 'impose'

  s.add_dependency 'prawn', '~> 2.0'
  s.add_dependency 'prawn-templates', '~> 0.0'
  s.add_dependency 'pdf-reader', '~> 1.4'
end
