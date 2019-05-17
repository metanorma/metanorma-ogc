require "spec_helper"

RSpec.describe Asciidoctor::Ogc do
      it "Warns of illegal doctype" do
    expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(/pizza is not a legal document type/).to_stderr
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :doctype: pizza

  text
  INPUT
end

      it "Warns of illegal status" do
    expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(/pizza is not a recognised status/).to_stderr
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :status: pizza

  text
  INPUT
end

  it "does not issue section order warnings unless document is a standard" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.not_to output(%r{Prefatory material must be followed by \(clause\) Scope}).to_stderr
    = Document title
    Author
    :docfile: test.adoc
    :nodoc:
    :doctype: engineering-report

    == Symbols and Abbreviated Terms
  INPUT
  end

  it "Warning if do not start with scope or introduction" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{Prefatory material must be followed by \(clause\) Scope}).to_stderr
  #{VALIDATING_BLANK_HDR}

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

it "Warning if introduction not followed by scope" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{Prefatory material must be followed by \(clause\) Scope}).to_stderr
  #{VALIDATING_BLANK_HDR}

  .Foreword 
  Foreword

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

it "Warning if scope not followed by conformance" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{Scope must be followed by Conformance}).to_stderr
  #{VALIDATING_BLANK_HDR}

  .Foreword
  Foreword

  == Scope

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

it "Warning if normative references not followed by terms and definitions" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{Normative References must be followed by Terms and Definitions}).to_stderr
  #{VALIDATING_BLANK_HDR}

  .Foreword 
  Foreword

  == Scope

  [bibliography]
  == Normative References

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

it "Warning if there are no clauses in the document" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{Document must contain at least one clause}).to_stderr
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
end

it "Warning if no normative references" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{Normative References are mandatory}).to_stderr
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
end

end
