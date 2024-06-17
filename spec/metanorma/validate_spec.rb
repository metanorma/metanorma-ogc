require "spec_helper"

RSpec.describe Metanorma::Ogc do
  context "when xref_error.adoc compilation" do
    around do |example|
      FileUtils.rm_f "spec/assets/xref_error.err.html"
      example.run
      Dir["spec/assets/xref_error*"].each do |file|
        next if file.match?(/adoc$/)

        FileUtils.rm_f(file)
      end
    end

    it "generates error file" do
      expect do
        mock_pdf
        Metanorma::Compile
          .new
          .compile("spec/assets/xref_error.adoc", type: "ogc", install_fonts: false)
      end.to(change { File.exist?("spec/assets/xref_error.err.html") }
              .from(false).to(true))
    end
  end

  it "Warns of version on engineering-report" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :edition: 1
      :nodoc:
      :no-isobib:
      :docfile: test.adoc
      :doctype: engineering-report

      text
    INPUT
    expect(File.read("test.err.html")).to include "Version not permitted for engineering-report"
  end

  it "Warns of missing version on document type other than engineering-report or discussion paper" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :nodoc:
      :no-isobib:
      :docfile: test.adoc
      :doctype: standard

      text
    INPUT
    expect(File.read("test.err.html")).to include "Version required for standard"
  end

  it "Warns of illegal doctype" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: pizza

      text
    INPUT
    expect(File.read("test.err.html")).to include "'pizza' is not a legal document type"
  end

  it "Warns of illegal doc subtype" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :doctype: standard
      :docsubtype: pizza

      text
    INPUT
    expect(File.read("test.err.html")).to include \
      "'pizza' is not a permitted subtype of Standard:​ reverting to 'implementation'"
  end

  it "Warns of illegal status" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :status: pizza

      text
    INPUT
    expect(File.read("test.err.html")).to include "pizza is not a recognised status"
  end

  it "Warns of status inconsistent with doctype" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :no-isobib:
      :status: draft
      :doctype: abstract-specification-topic

      text
    INPUT
    expect(File.read("test.err.html")).to include "draft is not an allowed status for abstract-specification-topic"
  end

  it "does not issue section order warnings unless document is a standard" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :doctype: engineering-report

      == Symbols and Abbreviated Terms
    INPUT
    expect(File.read("test.err.html")).not_to include "Prefatory material must be followed by (clause) Scope"
  end

  it "Warning if do not start with scope or introduction" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Prefatory material must be followed by (clause) Scope"
  end

  it "Warning if introduction not followed by scope" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      .Foreword
      Foreword

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Prefatory material must be followed by (clause) Scope"
  end

  it "Warning if scope not followed by conformance" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      .Foreword
      Foreword

      == Scope

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Scope must be followed by Conformance"
  end

  it "Warning if normative references not followed by terms and definitions" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      .Foreword
      Foreword

      == Scope

      [bibliography]
      == Normative References

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Normative References must be followed by Terms and Definitions"
  end

  it "Warning if there are no clauses in the document" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      .Foreword
      Foreword

      == Scope

      == Conformance

      [bibliography]
      == Normative References

      == Terms and Definitions

      == Symbols and Abbreviated Terms

    INPUT
    expect(File.read("test.err.html")).to include "Document must contain at least one clause"
  end

  it "Warning if no normative references" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      .Foreword
      Foreword

      == Scope

      == Conformance

      == Terms and Definitions

      == Clause

      [appendix]
      == Appendix A

      [appendix]
      == Appendix B

      [appendix]
      == Appendix C

    INPUT
    expect(File.read("test.err.html")).to include "Normative References are mandatory"
  end

  it "Warning if missing abstract" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Abstract is missing"
  end

  it "Warning if missing keywords" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Keywords are missing"
  end

  it "Warning if missing preface" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Preface is missing"
  end

  it "Warning if missing submitting organizations" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Submitting Organizations is missing"
  end

  it "Warning if missing submitters" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).to include "Submitters is missing"
  end

  it "does not warn if not missing abstract" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      [abstract]
      == Abstract

      X

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).not_to include "Abstract is missing"
  end

  it "does not warn if not missing keywords" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :keywords: A

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).not_to include "Keywords are missing"
  end

  it "does not warn if not missing preface" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      .Title

      Preface

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).not_to include "Preface is missing"
  end

  it "does not warn if not missing submitting organizations" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :submitting-organizations: University of Bern, Switzerland; Amazon, USA

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).not_to include "Submitting Organizations is missing"
  end

  it "does not warn if not missing submitters" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true)
      #{VALIDATING_BLANK_HDR}

      == Submitters

      X

      == Symbols and Abbreviated Terms

      Paragraph
    INPUT
    expect(File.read("test.err.html")).not_to include "Submitters is missing"
  end

  it "warns of missing executive summary in engineering report" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :doctype: engineering-report

      Paragraph
    INPUT
    expect(File.read("test.err.html"))
      .to include "Executive Summary required for Engineering Reports!"

    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :doctype: engineering-report

      == Executive Summary

      Paragraph
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "Executive Summary required for Engineering Reports!"
  end

  it "warns of missing executive summary outside of engineering report" do
    FileUtils.rm_f "test.err.html"
    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:

      Paragraph
    INPUT
    expect(File.read("test.err.html"))
      .not_to include "Executive Summary only allowed for Engineering Reports!"

    Asciidoctor.convert(<<~INPUT, backend: :ogc, header_footer: true)
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:

      == Executive Summary

      Paragraph
    INPUT
    expect(File.read("test.err.html"))
      .to include "Executive Summary only allowed for Engineering Reports!"
  end
end
