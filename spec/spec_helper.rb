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
require "relaton_iso"
require "canon"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

OPTIONS = [backend: :ogc, header_footer: true, agree_to_terms: true].freeze

def presxml_options
  { semanticxmlinsert: "false" }
end

def metadata(xml)
  xml.sort.to_h.delete_if do |_k, v|
    v.nil? || (v.respond_to?(:empty?) && v.empty?)
  end
end

def strip_guid(xml)
  xml.gsub(%r{ id="_[^"]+"}, ' id="_"')
    .gsub(%r{ semx-id="[^"]*"}, '')
    .gsub(%r{ target="_[^"]+"}, ' target="_"')
    .gsub(%r{ source="_[^"]+"}, ' source="_"')
    .gsub(%r{ name="_[^"]+"}, ' name="_"')
    .gsub(%r{<fetched>[^<]+</fetched>}, "<fetched/>")
    .gsub(%r{ schema-version="[^"]+"}, "")
end

def htmlencode(xml)
  HTMLEntities.new.encode(xml, :hexadecimal)
    .gsub("&#x3e;", ">").gsub("&#xa;", "\n")
    .gsub("&#x22;", '"').gsub("&#x3c;", "<")
    .gsub("&#x26;", "&").gsub("&#x27;", "'")
    .gsub(/\\u(....)/) { |_s| "&#x#{$1.downcase};" }
end

ASCIIDOC_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:

HDR

VALIDATING_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:

HDR

LOCAL_CACHED_ISOBIB_BLANK_HDR = <<~HDR.freeze
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :novalid:
  :local-cache: spec/relatondb

HDR

def boilerplate_read(file, xmldoc)
  conv = Metanorma::Ogc::Converter.new(:ogc, {})
  conv.init(Asciidoctor::Document.new([]))
  x = conv.boilerplate_isodoc(xmldoc).populate_template(file, nil)
  ret = conv.boilerplate_file_restructure(x)
  ret.to_xml(encoding: "UTF-8", indent: 2,
             save_with: Nokogiri::XML::Node::SaveOptions::AS_XML)
    .gsub(/<(\/)?sections>/, "<\\1boilerplate>")
    .gsub(/ id="_[^"]+"/, " id='_'")
end

def boilerplate(xmldoc)
  boilerplate_read(
    File.read(
      File.join(File.dirname(__FILE__), "..", "lib", "metanorma", "ogc",
                "boilerplate.adoc"), encoding: "utf-8"
    ),
    xmldoc,
  )
end

METANORMA_EXTENSION = <<~"HDR".freeze
  <metanorma-extension>
             <semantic-metadata>
                <stage-published>true</stage-published>
             </semantic-metadata>
             <presentation-metadata>
                <document-scheme>2022</document-scheme>
         <color-admonition-caution>rgb(79, 129, 189)</color-admonition-caution>
         <color-admonition-editor>rgb(79, 129, 189)</color-admonition-editor>
         <color-admonition-important>rgb(79, 129, 189)</color-admonition-important>
         <color-admonition-note>rgb(79, 129, 189)</color-admonition-note>
         <color-admonition-safety-precaution>rgb(79, 129, 189)</color-admonition-safety-precaution>
         <color-admonition-tip>rgb(79, 129, 189)</color-admonition-tip>
         <color-admonition-todo>rgb(79, 129, 189)</color-admonition-todo>
         <color-admonition-warning>rgb(79, 129, 189)</color-admonition-warning>
         <color-background-definition-description>rgb(242, 251, 255)</color-background-definition-description>
         <color-background-definition-term>rgb(215, 243, 255)</color-background-definition-term>
         <color-background-page>rgb(33, 55, 92)</color-background-page>
         <color-background-table-header>rgb(33, 55, 92)</color-background-table-header>
         <color-background-table-row-even>rgb(252, 246, 222)</color-background-table-row-even>
         <color-background-table-row-odd>rgb(254, 252, 245)</color-background-table-row-odd>
         <color-background-term-admitted-label>rgb(223, 236, 249)</color-background-term-admitted-label>
         <color-background-term-deprecated-label>rgb(237, 237, 238)</color-background-term-deprecated-label>
         <color-background-term-preferred-label>rgb(249, 235, 187)</color-background-term-preferred-label>
         <color-background-text-label-legacy>rgb(33, 60, 107)</color-background-text-label-legacy>
         <color-secondary-shade-1>rgb(0, 177, 255)</color-secondary-shade-1>
         <color-secondary-shade-2>rgb(0, 177, 255)</color-secondary-shade-2>
         <color-text>rgb(88, 89, 91)</color-text>
         <color-text-title>rgb(33, 55, 92)</color-text-title>
         <toc-heading-levels>2</toc-heading-levels>
         <html-toc-heading-levels>2</html-toc-heading-levels>
         <doc-toc-heading-levels>2</doc-toc-heading-levels>
         <pdf-toc-heading-levels>2</pdf-toc-heading-levels>
             </presentation-metadata>
    </metanorma-extension>
HDR

BLANK_HDR = <<~"HDR".freeze
  <?xml version="1.0" encoding="UTF-8"?>
  <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
  <bibdata type="standard">

   <title language="en" type="main">Document title</title>
    <contributor>
      <role type="publisher"/>
      <organization>
        <name>Open Geospatial Consortium</name>
        <abbreviation>OGC</abbreviation>
      </organization>
    </contributor>

    <language>en</language>
    <script>Latn</script>

    <status> <stage>approved</stage> </status>

    <copyright>
      <from>#{Time.new.year}</from>
      <owner>
        <organization>
          <name>Open Geospatial Consortium</name>
        <abbreviation>OGC</abbreviation>
        </organization>
      </owner>
    </copyright>
    <ext>
    <doctype>standard</doctype>
    <subdoctype>implementation</subdoctype>
    <flavor>ogc</flavor>
    </ext>
  </bibdata>
  #{METANORMA_EXTENSION}
HDR

def blank_hdr_gen
  <<~"HDR"
    #{BLANK_HDR}
    #{boilerplate(Nokogiri::XML("#{BLANK_HDR}</metanorma>"))}
  HDR
end

SECURITY = <<~HDR.freeze
  <clause type='security' id='_' obligation='informative'>
    <title id="_">Security considerations</title>
    <p id='_'>No security considerations have been made for this document.</p>
  </clause>
HDR

HTML_HDR = <<~HDR.freeze
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
    <br/>
      <div class="TOC" id="_">
      <h1 class="IntroTitle">Contents</h1>
    </div>
HDR

WORD_HDR = <<~HDR.freeze
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

def mock_pdf
  allow(Mn2pdf).to receive(:convert) do |url, output, _c, _d|
    FileUtils.cp(url.delete('"'), output.delete('"'))
  end
end
