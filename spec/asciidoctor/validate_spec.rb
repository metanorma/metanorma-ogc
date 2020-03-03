require "spec_helper"

RSpec.describe Asciidoctor::Ogc do
  it "Warns of version on engineering-report" do
    expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(/Version not permitted for engineering-report/).to_stderr
  = Document title
  Author
  :edition: 1
  :nodoc:
  :no-isobib:
  :doctype: engineering-report

  text
  INPUT
end

    it "Warns of missing version on document type other than engineering-report or discussion paper" do
    expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(/Version required for standard/).to_stderr
  = Document title
  Author
  :nodoc:
  :no-isobib:
  :doctype: standard

  text
  INPUT
end

      it "Warns of illegal doctype" do
    expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(/'pizza' is not a legal document type/).to_stderr
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :doctype: pizza

  text
  INPUT
end

      it "Warns of illegal doc subtype" do
    expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(/'pizza' is not a permitted subtype of Standard: reverting to 'implementation'/).to_stderr
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :no-isobib:
  :doctype: standard
  :docsubtype: pizza

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

  it "Warning if missing abstract" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{OGC style: Abstract is missing}).to_stderr
  #{VALIDATING_BLANK_HDR}

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "Warning if missing keywords" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{OGC style: Keywords are missing}).to_stderr
  #{VALIDATING_BLANK_HDR}

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "Warning if missing preface" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{OGC style: Preface is missing}).to_stderr
  #{VALIDATING_BLANK_HDR}

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "Warning if missing submitting organizations" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{OGC style: Submitting Organizations is missing}).to_stderr
  #{VALIDATING_BLANK_HDR}

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "Warning if missing submitters" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.to output(%r{OGC style: Submitters is missing}).to_stderr
  #{VALIDATING_BLANK_HDR}

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

    it "does not warn if not missing abstract" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.not_to output(%r{OGC style: Abstract is missing}).to_stderr
  #{VALIDATING_BLANK_HDR}

  [abstract]
  == Abstract

  X

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "does not warn if not missing keywords" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.not_to output(%r{OGC style: Keyworrds are missing}).to_stderr
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :keywords: A

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "does not warn if not missing preface" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.not_to output(%r{OGC style: Preface is missing}).to_stderr
  #{VALIDATING_BLANK_HDR}
  
  .Title

  Preface

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "does not warn if not missing submitting organizations" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.not_to output(%r{OGC style: Submitting Organizations is missing}).to_stderr
  = Document title
  Author
  :docfile: test.adoc
  :nodoc:
  :submitting-organizations: University of Bern, Switzerland; Amazon, USA

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end

  it "does not warn if not missing submitters" do
  expect { Asciidoctor.convert(<<~"INPUT", backend: :ogc, header_footer: true) }.not_to output(%r{OGC style: Submitters is missing}).to_stderr
  #{VALIDATING_BLANK_HDR}

  == Submitters

  X

  == Symbols and Abbreviated Terms

  Paragraph
  INPUT
end


end
