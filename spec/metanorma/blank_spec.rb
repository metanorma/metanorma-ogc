require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ogc do
  it "processes a blank document" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
          <preface>#{SECURITY}</preface>
      <sections/>
      </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:

      == Clause
    INPUT

    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
          <preface>#{SECURITY}</preface>
      <sections>
      <clause id='_' obligation='normative'>
             <title>Clause</title>
             </clause>
             </sections>
      </ogc-standard>
    OUTPUT

    FileUtils.rm_f "test.html"
    FileUtils.rm_f "test.doc"
    FileUtils.rm_f "test.pdf"
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
    expect(File.exist?("test.doc")).to be true
    expect(File.exist?("test.pdf")).to be true
  end
end
