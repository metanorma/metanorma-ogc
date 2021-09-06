require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::Ogc do
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

  it "processes default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: IS
      :docsubtype: CM
      :edition: 2.0
      :revdate: 2000-01-01
      :draft: 3.4
      :committee: TC
      :committee-number: 1
      :committee-type: A
      :committee_2: TC1
      :committee-number_2: 1
      :committee-type_2: B
      :subcommittee: SC
      :subcommittee-number: 2
      :subcommittee-type: B
      :workgroup: WG
      :workgroup-number: 3
      :workgroup-type: C
      :secretariat: SECRETARIAT
      :copyright-year: 2001
      :status: SWG Work
      :iteration: 3
      :language: en
      :title: Main Title
      :abbrev: MT
      :published-date: 2002-01-01
      :issued-date: 2001-01-01
      :created-date: 1999-01-01
      :received-date: 1999-06-01
      :uri: http://www.example.com
      :external-id: http://www.example2.com
      :referenceURLID: ABC
      :fullname: Fred Flintstone
      :role: author
      :surname_2: Rubble
      :givenname_2: Barney
      :role_2: editor
      :previous-uri: PREVIOUS URI
      :submitting-organizations: University of Bern, Switzerland; Proctor & Gamble
      :keywords: a, b, c
    INPUT

    output = xmlpp(<<~"OUTPUT")
      <?xml version='1.0' encoding='UTF-8'?>
         <ogc-standard xmlns="https://www.metanorma.org/ns/ogc" type="semantic" version="#{Metanorma::Ogc::VERSION}">
         <bibdata type="standard">
           <title language="en" format="text/plain">Main Title</title>
           <title format='text/plain' type='abbrev'>MT</title>
           <uri>http://www.example.com</uri>
           <uri type="previous">PREVIOUS URI</uri>
           <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
           <docidentifier type="ogc-external">ABC</docidentifier>
           <docidentifier type="ogc-internal">1000</docidentifier>
           <docnumber>1000</docnumber>
           <date type="published">
             <on>2002-01-01</on>
           </date>
           <date type="created">
             <on>1999-01-01</on>
           </date>
           <date type="issued">
             <on>2001-01-01</on>
           </date>
           <date type="received">
          <on>1999-06-01</on>
          </date>
           <contributor>
             <role type="author"/>
             <organization>
               <name>University of Bern, Switzerland</name>
             </organization>
           </contributor>
           <contributor>
             <role type="author"/>
             <organization>
               <name>Proctor &amp; Gamble</name>
             </organization>
           </contributor>
           <contributor>
             <role type="author"/>
             <person>
               <name>
                 <completename>Fred Flintstone</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type="editor"/>
             <person>
               <name>
                 <forename>Barney</forename>
                 <surname>Rubble</surname>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type="publisher"/>
             <organization>
               <name>Open Geospatial Consortium</name>
             </organization>
           </contributor>
           <edition>2.0</edition>
          <version>
           <revision-date>2000-01-01</revision-date>
           <draft>3.4</draft>
         </version>
           <language>en</language>
           <script>Latn</script>
           <status>
             <stage>SWG Work</stage>
             <iteration>3</iteration>
           </status>
           <copyright>
             <from>2001</from>
             <owner>
               <organization>
                 <name>Open Geospatial Consortium</name>
               </organization>
             </owner>
           </copyright>
           <keyword>a</keyword>
          <keyword>b</keyword>
          <keyword>c</keyword>
           <ext>
           <doctype>standard</doctype>
           <subdoctype>conceptual-model</subdoctype>
           <editorialgroup>
             <committee>TC</committee>
             <subcommittee type="B" number="2">SC</subcommittee>
             <workgroup type="C" number="3">WG</workgroup>
           </editorialgroup>
          </ext>
         </bibdata>
      #{BOILERPLATE.sub(/#{Date.today.year} Open Geospatial Consortium/, '2001 Open Geospatial Consortium').sub(%r{<title>Notice</title>}, '<title>Notice for Drafts</title>').sub(/This document is an OGC Member approved international standard. This document is available on a royalty free, non-discriminatory basis\. Recipients of this document are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation\.\s*/, "This document is not an OGC Standard. This document is distributed for review and comment. This document is subject to change without notice and may not be referred to as an OGC Standard.</p><p id='_'>Recipients of this document are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation.")}
      <preface>#{SECURITY}</preface>
         <sections/>
         </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes OGC synonyms for default metadata, and default template for external-id" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docReference: 1000
      :doctype: engineering-report
      :version: 2.0
      :revdate: 2000-01-01
      :draft: 3.4
      :copyrightYear: 2001
      :status: published
      :iteration: 3
      :language: en
      :title: Main Title
      :publicationDate: 2002-01-01
      :approvalDate: 2001-01-01
      :created-date: 1999-01-01
      :submissionDate: 1999-06-01
      :uri: http://www.example.com
      :referenceURLID: http://www.example2.com
      :fullname: Fred Flintstone
      :role: author
      :surname_2: Rubble
      :givenname_2: Barney
      :role: editor
      :editor: Wilma Flintstone
      :abbrev: A
    INPUT

    output = xmlpp(<<~"OUTPUT")
          <ogc-standard xmlns="https://www.metanorma.org/ns/ogc" type="semantic" version="#{Metanorma::Ogc::VERSION}">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <title format='text/plain' type='abbrev'>A</title>
        <uri>http://www.example.com</uri>
        <docidentifier type='ogc-external'>http://www.opengis.net/doc/ER/A/2.0</docidentifier>
        <docidentifier type="ogc-external">http://www.opengis.net/doc/PER/t14-http://www.example2.com</docidentifier>
        <docidentifier type="ogc-internal">1000</docidentifier>
        <docnumber>1000</docnumber>
                 <date type="created">
          <on>1999-01-01</on>
        </date>
        <date type="received">
          <on>1999-06-01</on>
        </date>
        <date type="published">
          <on>2002-01-01</on>
        </date>
        <date type="issued">
          <on>2001-01-01</on>
        </date>
        <contributor>
          <role type="editor"/>
          <person>
            <name>
              <completename>Wilma Flintstone</completename>
            </name>
          </person>
        </contributor>
        <contributor>
          <role type="editor"/>
          <person>
            <name>
              <completename>Fred Flintstone</completename>
            </name>
          </person>
        </contributor>
        <contributor>
          <role type="editor"/>
          <person>
            <name>
              <forename>Barney</forename>
              <surname>Rubble</surname>
            </name>
          </person>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
          </organization>
        </contributor>
      <edition>2.0</edition>
         <version>
        <revision-date>2000-01-01</revision-date>
        <draft>3.4</draft>
      </version>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>approved</stage>
          <iteration>3</iteration>
        </status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
              <name>Open Geospatial Consortium</name>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>engineering-report</doctype>
        </ext>
      </bibdata>
      <preface>#{SECURITY.sub(/standard/, 'document')}</preface>
      <sections/>
      </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS)
      .sub(%r{<boilerplate.*</boilerplate>}m, ""))))
      .to be_equivalent_to output
  end

  it "processes submitters" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      [abstract]
      Abstract

      == Acknowledgements

      == Clause
      Clause 1

      == Submitters
      Clause 2
    INPUT

    output = xmlpp(<<~"OUTPUT")
          <ogc-standard xmlns="https://www.metanorma.org/ns/ogc" type="semantic" version="#{Metanorma::Ogc::VERSION}">
      <bibdata type="standard">
       <title language="en" format="text/plain">Document title</title>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
          </organization>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <status><stage>approved</stage></status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
              <name>Open Geospatial Consortium</name>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>standard</doctype>
        <subdoctype>implementation</subdoctype>
        </ext>
      </bibdata>
      #{BOILERPLATE}
      <preface><foreword id="_" obligation="informative">
      <title>Preface</title><p id="_">This is a preamble</p></foreword>
      <acknowledgements id='_' obligation='informative'>
        <title>Acknowledgements</title>
      </acknowledgements>
      #{SECURITY}
      <submitters id="_">
      <title>Submitters</title>
        <p id="_">Clause 2</p>
      </submitters>
      </preface><sections>
      <clause id="_" obligation="normative">
        <title>Clause</title>
        <p id="_">Clause 1</p>
      </clause></sections>
      </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes References" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [bibliography]
      == References
    INPUT

    output = xmlpp(<<~"OUTPUT")
                <ogc-standard xmlns="https://www.metanorma.org/ns/ogc" type="semantic" version="#{Metanorma::Ogc::VERSION}">
      <bibdata type="standard">
      <title language="en" format="text/plain">Document title</title>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
          </organization>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <status><stage>approved</stage></status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
              <name>Open Geospatial Consortium</name>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>standard</doctype>
        <subdoctype>implementation</subdoctype>
        </ext>
      </bibdata>
      #{BOILERPLATE}
      <preface>#{SECURITY}</preface>
      <sections>
      </sections><bibliography><references id="_" obligation="informative" normative="true">
        <title>Normative references</title>
        <p id="_">There are no normative references in this document.</p>
      </references></bibliography>
      </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{BLANK_HDR}
               <preface><foreword id="_" obligation="informative">
           <title>Preface</title>
           <p id="_">This is a preamble</p>
         </foreword>
         #{SECURITY}</preface>
          <sections>
         <clause id="_" obligation="normative">
           <title>Section 1</title>
         </clause></sections>
         </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, *OPTIONS)

    html = File.read("test.html", encoding: "utf-8")
    expect(html)
      .to match(%r[\bpre[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html)
      .to match(%r[ div[^{]+\{[^}]+font-family: "Overpass", sans-serif;]m)
    expect(html)
      .to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "Overpass", sans-serif;]m)
  end

  it "uses specified fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
      :body-font: Zapf Chancery
      :header-font: Comic Sans
      :monospace-font: Andale Mono
      :no-pdf:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, *OPTIONS)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\bpre[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html)
      .to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
  end

  it "processes inline_quoted formatting" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      _emphasis_
      *strong*
      `monospace`
      "double quote"
      'single quote'
      super^script^
      sub~script~
      stem:[a_90]
      stem:[<mml:math><mml:msub xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">F</mml:mi> </mml:mrow> </mml:mrow> <mml:mrow> <mml:mrow> <mml:mi mathvariant="bold-italic">&#x391;</mml:mi> </mml:mrow> </mml:mrow> </mml:msub> </mml:math>]
      [keyword]#keyword#
      [strike]#strike#
      [smallcap]#smallcap#
    INPUT

    output = xmlpp(<<~"OUTPUT")
                  #{BLANK_HDR}
          <preface>#{SECURITY}</preface>
             <sections>
              <p id="_"><em>emphasis</em>
             <strong>strong</strong>
             <tt>monospace</tt>
             “double quote”
             ‘single quote’
             super<sup>script</sup>
             sub<sub>script</sub>
             <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub><mrow>
        <mi>a</mi>
      </mrow>
      <mrow>
        <mn>90</mn>
      </mrow>
      </msub></math></stem>
             <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
             <keyword>keyword</keyword>
             <strike>strike</strike>
             <smallcap>smallcap</smallcap></p>
             </sections>
             </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "processes examples" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [example]
      .Example Title
      ====
      This is an example

      Amen
      ====
    INPUT
    output = <<~OUTPUT
        #{BLANK_HDR}
      <preface>#{SECURITY}</preface>
         <sections>
           <example id="_"><name>Example Title</name><p id="_">This is an example</p>
         <p id="_">Amen</p></example>
         </sections>
         </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "leaves user boilerplate alone in terms & definitions" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Terms and Definitions

      This is a prefatory paragraph

    INPUT
    output = <<~OUTPUT
        #{BLANK_HDR}
      <preface>#{SECURITY}</preface>
          <sections><terms id="_" obligation="normative">
           <title>Terms and definitions</title><p id="_">No terms and definitions are listed in this document.</p>
           <p id="_">This is a prefatory paragraph</p>
         </terms>
         </sections>
         </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes preface section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Preface

      This is a prefatory paragraph

    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
       <preface>
           <foreword id='_' obligation='informative'>
             <title>Preface</title>
             <p id='_'>This is a prefatory paragraph</p>
           </foreword>
           #{SECURITY}
         </preface>
         <sections> </sections>
       </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes conformance section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Conformance

    INPUT
    output = <<~OUTPUT
        #{BLANK_HDR}
      <preface>#{SECURITY}</preface>
         <sections>
             <clause id='_' obligation='normative' type="conformance">
               <title>Conformance</title>
             </clause>
           </sections>
         </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes security consideration section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Security Considerations

      This is a security consideration

    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
       <preface>
           <clause id='_' obligation='informative' type="security">
             <title>Security Considerations</title>
             <p id="_">This is a security consideration</p>
           </clause>
         </preface>
         <sections/>
       </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "does not recognise 'Foreword' or 'Introduction' as a preface section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Foreword

      This is a prefatory paragraph

      == Introduction

      And so is this

    INPUT
    output = <<~OUTPUT
            #{BLANK_HDR}
            <preface>#{SECURITY}</preface>
                 <sections>
            <clause id='_' obligation='normative'>
              <title>Foreword</title>
              <p id='_'>This is a prefatory paragraph</p>
            </clause>
            <clause id='_' obligation='normative'>
        <title>Introduction</title>
        <p id='_'>And so is this</p>
      </clause>
          </sections>
        </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes highlight text" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      This is #highlihgted text# inline.
    INPUT
    output = <<~OUTPUT
            #{BLANK_HDR}
          <preface>#{SECURITY}</preface>
             <sections>
             <p id='_'>
        This is
        <hi>highlihgted text</hi>
         inline.
      </p>
             </sections>
             </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes glossary annex" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix]
      == Glossary

      === Term

      [appendix]
      == Appendix

      term:[Term]
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
      <preface>#{SECURITY}</preface>
      <sections> </sections>
      <annex id='_' obligation='normative'>
        <title>Glossary</title>
        <terms id='_' obligation='normative'>
          <term id='term-term'>
            <preferred>Term</preferred>
          </term>
        </terms>
      </annex>
      <annex id='_' obligation='normative'>
        <title>Appendix</title>
        <p id='_'>
          <concept>
            <refterm>Term</refterm>
            <renderterm>Term</renderterm>
            <xref target='term-term'/>
          </concept>
        </p>
      </annex>
      </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)

    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix,heading=glossary]
      == Glossarium

      === Glossaire

    INPUT
    output = <<~OUTPUT
            #{BLANK_HDR}
          <preface>#{SECURITY}</preface>
          <sections> </sections>
      <annex id='_' obligation='normative'>
        <title>Glossarium</title>
        <terms id='_' obligation='normative'>
          <term id='term-glossaire'>
            <preferred>Glossaire</preferred>
          </term>
        </terms>
      </annex>
      </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes glossary annex with terms section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Terms and definitions

      === Term

      [appendix]
      [heading='terms and definitions']
      == Glossary

      === Term Collection

      ==== Term

    INPUT
    output = <<~OUTPUT
            #{BLANK_HDR}
            <preface>#{SECURITY}</preface>
                     <sections>
                 <terms id='_' obligation='normative'>
                   <title>Terms and definitions</title>
                   <p id='_'>
        This document uses the terms defined in
        <link target='https://portal.ogc.org/public_ogc/directives/directives.php'>OGC Policy Directive 49</link>
        , which is based on the ISO/IEC Directives, Part 2, Rules for the
        structure and drafting of International Standards. In particular, the
        word &#8220;shall&#8221; (not &#8220;must&#8221;) is the verb form used
        to indicate a requirement to be strictly followed to conform to this
        standard and OGC documents do not use the equivalent phrases in the
        ISO/IEC Directives, Part 2.
      </p>
      <p id='_'>
        This document also uses terms defined in the OGC Standard for Modular
        specifications (
        <link target='https://portal.opengeospatial.org/files/?artifact_id=34762'>OGC 08-131r3</link>
        ), also known as the &#8216;ModSpec&#8217;. The definitions of terms
        such as standard, specification, requirement, and conformance test are
        provided in the ModSpec.
      </p>
      <p id='_'>
        For the purposes of this document, the following additional terms and
        definitions apply.
      </p>
                   <term id='term-term'>
                     <preferred>Term</preferred>
                   </term>
                 </terms>
               </sections>
               <annex id='_' obligation='normative'>
                 <title>Glossary</title>
                 <clause id='_' obligation='normative'>
                   <terms id='_' obligation='normative'>
                     <title>Term Collection</title>
                     <term id='term-term-1'>
                       <preferred>Term</preferred>
                     </term>
                   </terms>
                 </clause>
               </annex>
             </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end

  it "overrides table valign" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      |===
      <.<|a |b

      ^.^|c >.>|d
      |===
    INPUT
    output = <<~OUTPUT
      #{BLANK_HDR}
      <preface>#{SECURITY}</preface>
      <sections>
        <table id='_'>
          <thead>
            <tr>
              <th valign='middle' align='left'>a</th>
              <th valign='middle' align='left'>b</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td valign='middle' align='center'>c</td>
              <td valign='middle' align='right'>d</td>
            </tr>
          </tbody>
        </table>
      </sections>
      </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to xmlpp(output)
  end
end
