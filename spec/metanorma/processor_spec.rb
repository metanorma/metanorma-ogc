require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ogc::Processor do
  registry = Metanorma::Registry.instance
  registry.register(Metanorma::Ogc::Processor)

  let(:processor) do
    registry.find_processor(:ogc)
  end

  it "registers against metanorma" do
    expect(processor).not_to be nil
  end

  it "registers output formats against metanorma" do
    output = <<~OUTPUT
      [[:doc, "doc"], [:html, "html"], [:pdf, "pdf"], [:presentation, "presentation.xml"], [:rxl, "rxl"], [:xml, "xml"]]
    OUTPUT

    expect(processor.output_formats.sort.to_s).to be_equivalent_to output
  end

  it "registers version against metanorma" do
    expect(processor.version.to_s).to match(%r{^Metanorma::Ogc })
  end

  it "generates IsoDoc XML from a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = <<~"OUTPUT"
          #{blank_hdr_gen}
          <preface>#{SECURITY}</preface>
      <sections/>
      </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(processor
      .input_to_isodoc(input, nil)))).to be_equivalent_to (Xml::C14n.format(output))
  end

  it "generates HTML from IsoDoc XML" do
    FileUtils.rm_f "test.xml"
    input = <<~INPUT
      <metanorma xmlns="https://standards.opengeospatial.org/document">
        #{METANORMA_EXTENSION}
        <sections>
          <terms id="H" obligation="normative" displayorder="1">
          <fmt-title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</fmt-title>
            <term id="J">
            <fmt-name>1.1.</fmt-name>
              <fmt-preferred><p>Term2</p></fmt-preferred>
            </term>
          </terms>
        </sections>
      </metanorma>
    INPUT

    output = Xml::C14n.format(<<~OUTPUT)
       <main class="main-section">
         <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
         <div id="H">
           <h1 id="_">
             <a class="anchor" href="#H"/>
             <a class="header" href="#H">1.  Terms, Definitions, Symbols and Abbreviated Terms</a>
           </h1>
           <div id="J">
             <h2 class="TermNum" style="text-align:left;" id="_">
               <a class="anchor" href="#J"/>
               <a class="header" href="#J">1.1. Term2</a>
             </h2>
           </div>
         </div>
       </main>
    OUTPUT

    processor.output(input, "test.xml", "test.html", :html)

    expect(
      Xml::C14n.format(strip_guid(File.read("test.html", encoding: "utf-8")
      .gsub(%r{^.*<main}m, "<main")
      .gsub(%r{</main>.*}m, "</main>"))),
    ).to be_equivalent_to output
  end
end
