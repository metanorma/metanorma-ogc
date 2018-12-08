require "spec_helper"
require "fileutils"

RSpec.describe Asciidoctor::Ogc do
  it "generates output for the Rice document" do
    FileUtils.rm_rf %w(spec/examples/rfc6350.doc spec/examples/rfc6350.html spec/examples/rfc6350.pdf)
    FileUtils.cd "spec/examples"
    Asciidoctor.convert_file "rfc6350.adoc", {:attributes=>{"backend"=>"ogc"}, :safe=>0, :header_footer=>true, :requires=>["metanorma-ogc"], :failure_level=>4, :mkdirs=>true, :to_file=>nil}
    FileUtils.cd "../.."
    expect(File.exist?("spec/examples/rfc6350.doc")).to be true
    expect(File.exist?("spec/examples/rfc6350.html")).to be true
    expect(File.exist?("spec/examples/rfc6350.pdf")).to be true
  end

  it "processes a blank document" do
    input = <<~"INPUT"
    #{ASCIIDOC_BLANK_HDR}
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
<sections/>
</ogc-standard>
    OUTPUT

    expect(Asciidoctor.convert(input, backend: :ogc, header_footer: true)).to be_equivalent_to output
  end

  it "converts a blank document" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
<sections/>
</ogc-standard>
    OUTPUT

    FileUtils.rm_f "test.html"
    expect(Asciidoctor.convert(input, backend: :ogc, header_footer: true)).to be_equivalent_to output
    expect(File.exist?("test.html")).to be true
  end

  it "processes default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docnumber: 1000
      :doctype: implementation-standard
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
      :role: editor
      :previous-uri: PREVIOUS URI
      :submitting-organizations: University of Bern, Switzerland; Amazon, USA
      :keywords: a, b, c
    INPUT

    output = <<~"OUTPUT"
       <ogc-standard xmlns="https://standards.opengeospatial.org/document">
       <bibdata type="standard">
         <title language="en" format="text/plain">Main Title</title>
         <source>http://www.example.com</source>
         <source type="previous">PREVIOUS URI</source>
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
             <name>Amazon, USA</name>
           </organization>
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
           <role type="author"/>
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
             <name>OGC</name>
           </organization>
         </contributor>
         <language>en</language>
         <script>Latn</script>
         <status format="plain">SWG Work</status>
         <copyright>
           <from>2001</from>
           <owner>
             <organization>
               <name>OGC</name>
             </organization>
           </owner>
         </copyright>
         <editorialgroup>
           <committee>TC</committee>
           <subcommittee type="B" number="2">SC</subcommittee>
           <workgroup type="C" number="3">WG</workgroup>
         </editorialgroup>
         <keyword>a</keyword>
        <keyword>b</keyword>
        <keyword>c</keyword>
       </bibdata><version>
         <edition>2.0</edition>
         <revision-date>2000-01-01</revision-date>
         <draft>3.4</draft>
       </version>
       <sections/>
       </ogc-standard>
    OUTPUT

    expect(Asciidoctor.convert(input, backend: :ogc, header_footer: true)).to be_equivalent_to output
  end

    it "processes OGC synonyms for default metadata" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docReference: 1000
      :doctype: engineering-report
      :edition: 2.0
      :revdate: 2000-01-01
      :draft: 3.4
      :copyrightYear: 2001
      :status: SWG Work
      :iteration: 3
      :language: en
      :title: Main Title
      :publicationDate: 2002-01-01
      :approvalDate: 2001-01-01
      :created-date: 1999-01-01
      :submissionDate: 1999-06-01
      :uri: http://www.example.com
      :external-id: http://www.example2.com
      :referenceURLID: http://www.example2.com
      :fullname: Fred Flintstone
      :role: author
      :surname_2: Rubble
      :givenname_2: Barney
      :role: editor
      :editor: Wilma Flintstone
    INPUT

    output = <<~"OUTPUT"
           <ogc-standard xmlns="https://standards.opengeospatial.org/document">
       <bibdata type="engineering-report">
         <title language="en" format="text/plain">Main Title</title>
         <source>http://www.example.com</source>
         <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
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
           <role type="author"/>
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
             <name>OGC</name>
           </organization>
         </contributor>
         <language>en</language>
         <script>Latn</script>
         <status format="plain">SWG Work</status>
         <copyright>
           <from>2001</from>
           <owner>
             <organization>
               <name>OGC</name>
             </organization>
           </owner>
         </copyright>
         <editorialgroup>
           <committee>technical</committee>
         </editorialgroup>
       </bibdata><version>
         <edition>2.0</edition>
         <revision-date>2000-01-01</revision-date>
         <draft>3.4</draft>
       </version>
       <sections/>
       </ogc-standard>
OUTPUT
    expect(Asciidoctor.convert(input, backend: :ogc, header_footer: true)).to be_equivalent_to output
  end

  it "processes submitters" do
        input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      [abstract]
      Abstract

      == Clause
      Clause 1

      == Submitters
      Clause 2
    INPUT

    output = <<~"OUTPUT"
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
<bibdata type="standard">

  <contributor>
    <role type="publisher"/>
    <organization>
      <name>OGC</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status format="plain">published</status>
  <copyright>
    <from>2018</from>
    <owner>
      <organization>
        <name>OGC</name>
      </organization>
    </owner>
  </copyright>
  <editorialgroup>
    <committee>technical</committee>
  </editorialgroup>
</bibdata>
<preface><submitters id="_">
  <p id="_">Clause 2</p>
</submitters><foreword obligation="informative"><title>Foreword</title><p id="_">This is a preamble</p>
</foreword></preface><sections>
<clause id="_" obligation="normative">
  <title>Clause</title>
  <p id="_">Clause 1</p>
</clause></sections>
</ogc-standard>
        OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :ogc, header_footer: true))).to be_equivalent_to output
  end

    it "processes References" do
      input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [bibliography]
      == References
      INPUT

          output = <<~"OUTPUT"
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
<bibdata type="standard">

  <contributor>
    <role type="publisher"/>
    <organization>
      <name>OGC</name>
    </organization>
  </contributor>
  <language>en</language>
  <script>Latn</script>
  <status format="plain">published</status>
  <copyright>
    <from>2018</from>
    <owner>
      <organization>
        <name>OGC</name>
      </organization>
    </owner>
  </copyright>
  <editorialgroup>
    <committee>technical</committee>
  </editorialgroup>
</bibdata>
<sections>


</sections><bibliography><references id="_" obligation="informative">
  <title>Normative References</title>
</references></bibliography>
</ogc-standard>
OUTPUT
    expect(strip_guid(Asciidoctor.convert(input, backend: :ogc, header_footer: true))).to be_equivalent_to output
    end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = <<~"OUTPUT"
    #{BLANK_HDR}
             <preface><foreword obligation="informative">
         <title>Foreword</title>
         <p id="_">This is a preamble</p>
       </foreword></preface><sections>
       <clause id="_" obligation="normative">
         <title>Section 1</title>
       </clause></sections>
       </ogc-standard>
    OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :ogc, header_footer: true))).to be_equivalent_to output
  end

  it "uses default fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :ogc, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "Overpass", sans-serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "Overpass", sans-serif;]m)
  end

  it "uses Chinese fonts" do
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :script: Hans
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :ogc, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^}]+font-family: "Space Mono", monospace;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: "SimSun", serif;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: "SimHei", sans-serif;]m)
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
    INPUT

    FileUtils.rm_f "test.html"
    Asciidoctor.convert(input, backend: :ogc, header_footer: true)

    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r[\.Sourcecode[^{]+\{[^{]+font-family: Andale Mono;]m)
    expect(html).to match(%r[ div[^{]+\{[^}]+font-family: Zapf Chancery;]m)
    expect(html).to match(%r[h1, h2, h3, h4, h5, h6 \{[^}]+font-family: Comic Sans;]m)
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

    output = <<~"OUTPUT"
            #{BLANK_HDR}
       <sections>
        <p id="_"><em>emphasis</em>
       <strong>strong</strong>
       <tt>monospace</tt>
       "double quote"
       'single quote'
       super<sup>script</sup>
       sub<sub>script</sub>
       <stem type="AsciiMath">a_90</stem>
       <stem type="MathML"><math xmlns="http://www.w3.org/1998/Math/MathML"><msub> <mrow> <mrow> <mi mathvariant="bold-italic">F</mi> </mrow> </mrow> <mrow> <mrow> <mi mathvariant="bold-italic">Α</mi> </mrow> </mrow> </msub> </math></stem>
       <keyword>keyword</keyword>
       <strike>strike</strike>
       <smallcap>smallcap</smallcap></p>
       </sections>
       </ogc-standard>
    OUTPUT

    expect(strip_guid(Asciidoctor.convert(input, backend: :ogc, header_footer: true))).to be_equivalent_to output
  end

  it "uses user-specified HTML stylesheets" do
    FileUtils.rm_f "spec/assets/test.html"
    system "metanorma -t ogc -r metanorma-ogc spec/assets/test.adoc"
    html = File.read("spec/assets/test.html", encoding: "utf-8")
    expect(html).to match(%r[I am an HTML stylesheet])
    expect(html).to match(%r[I am an HTML cover page])
    expect(html).to match(%r[I am an HTML intro page])
    expect(html).to match(%r[I am an HTML scripts page])
  end

  it "uses user-specified Word stylesheets" do
    FileUtils.rm_f "spec/assets/test.doc"
    system "metanorma -t ogc -r metanorma-ogc spec/assets/test.adoc"
    html = File.read("spec/assets/test.doc", encoding: "utf-8")
    expect(html).to match(%r[I am a Word stylesheet])
    expect(html).to match(%r[I am a Standard stylesheet])
    expect(html).to match(%r[I am a Word cover page])
    expect(html).to match(%r[I am a Word intro page])
    # expect(html).to match(%r[I am a Word header file]) -- binhexed:
    expect(html).to match(%r[\nPCEtLSBJIGFtIGEgV29yZCBIZWFkZXIgZmlsZSAtLT4K\n])
  end
end
