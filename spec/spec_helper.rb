require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "metanorma-ogc"
require "rspec/matchers"
require "equivalent-xml"
require "htmlentities"
require "metanorma"
require "rexml/document"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def strip_guid(x)
  x.gsub(%r{ id="_[^"]+"}, ' id="_"').gsub(%r{ target="_[^"]+"}, ' target="_"')
end

def htmlencode(x)
  HTMLEntities.new.encode(x, :hexadecimal).gsub(/&#x3e;/, ">").gsub(/&#xa;/, "\n").
    gsub(/&#x22;/, '"').gsub(/&#x3c;/, "<").gsub(/&#x26;/, '&').gsub(/&#x27;/, "'").
    gsub(/\\u(....)/) { |s| "&#x#{$1.downcase};" }
end

def xmlpp(x)
  s = ""
  f = REXML::Formatters::Pretty.new(2)
  f.compact = true
  f.write(REXML::Document.new(x),s)
  s
end

ASCIIDOC_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:

HDR

VALIDATING_BLANK_HDR = <<~"HDR"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:

HDR

BOILERPLATE =
  HTMLEntities.new.decode(
  File.read(File.join(File.dirname(__FILE__), "..", "lib", "asciidoctor", "ogc", "boilerplate.xml"), encoding: "utf-8").
  gsub(/<legal-statement>.+<\/legal-statement>/m, "<legal-statement><clause> <title>Warning</title> <p>This document is an OGC Member approved international standard. This document is available on a royalty free, non-discriminatory basis. Recipients of this document are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation.  </p> </clause></legal-statement>").
  gsub(/\{% if doctype == "Standard" or doctype == "Community Standard" %\}\s*(<feedback-statement>.+?)\{% endif %\}/m, "\\1").
  gsub(/\{\{ docyear \}\}/, Date.today.year.to_s).
  gsub(/<p>/, '<p id="_">').
  gsub(/<p align="center">/, '<p align="center" id="_">').
  gsub(/"Licensor"/, "“Licensor”").gsub(/"AS/, "“AS").gsub(/IS"/, "IS”").
  gsub(/\{% if unpublished %\}.+?\{% endif %\}/m, "").
  gsub(/\{% if ip_notice_received %\}\{% else %\}not\{% endif %\}/m, ""))

BLANK_HDR = <<~"HDR"
       <?xml version="1.0" encoding="UTF-8"?>
       <ogc-standard xmlns="https://www.metanorma.org/ns/ogc">
       <bibdata type="standard">

        <title language="en" format="text/plain">Document title</title>
         <contributor>
           <role type="publisher"/>
           <organization>
             <name>#{Metanorma::Ogc::ORGANIZATION_NAME_SHORT}</name>
           </organization>
         </contributor>

         <language>en</language>
         <script>Latn</script>

         <status> <stage>published</stage> </status>

         <copyright>
           <from>#{Time.new.year}</from>
           <owner>
             <organization>
               <name>#{Metanorma::Ogc::ORGANIZATION_NAME_SHORT}</name>
             </organization>
           </owner>
         </copyright>
         <ext>
         <doctype>standard</doctype>
         <docsubtype>implementation</docsubtype>
         </ext>
       </bibdata>
       #{BOILERPLATE}
HDR

HTML_HDR = <<~"HDR"
           <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container">
           <div class="title-section">
             <p>&#160;</p>
           </div>
           <br/>
           <div class="prefatory-section">
             <p>&#160;</p>
           </div>
           <br/>
           <div class="main-section">
HDR

WORD_HDR = <<~"HDR"
<body lang='EN-US' link='blue' vlink='#954F72'>
         <div class='WordSection1'>
           <p>&#160;</p>
         </div>
         <p>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection2'>
           <p>
             <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
           </p>
HDR

