require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ogc do
  it "has a version number" do
    expect(Metanorma::Ogc::VERSION).not_to be nil
  end

  it "processes default metadata" do
    input = <<~INPUT
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
      :surname_3: Slaghoople
      :givenname_3: Pearl
      :role_3: contributor
      :previous-uri: PREVIOUS URI
      :submitting-organizations: University of Bern, Switzerland; Proctor & Gamble
      :keywords: a, b, c
    INPUT

    output = <<~"OUTPUT"
      <?xml version='1.0' encoding='UTF-8'?>
         <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
         <bibdata type="standard">
           <title language="en" type="main">Main Title</title>
           <title language="en" type='abbrev'>MT</title>
           <uri>http://www.example.com</uri>
           <uri type="previous">PREVIOUS URI</uri>
           <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
           <docidentifier type="ogc-external">ABC</docidentifier>
           <docidentifier primary="true" type="ogc-internal">1000</docidentifier>
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
              <role type='author'><description>contributor</description></role>
              <person>
              <name>
              <forename>Pearl</forename>
              <surname>Slaghoople</surname>
            </name>
          </person>
          </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>Open Geospatial Consortium</name>
            <subdivision type="Committee" subtype="A">
               <name>TC</name>
               <identifier>A 1</identifier>
               <identifier type="full">A 1/B 2/C 3</identifier>
            </subdivision>
            <subdivision type="Subcommittee" subtype="B">
               <name>SC</name>
               <identifier>B 2</identifier>
            </subdivision>
            <subdivision type="Workgroup" subtype="C">
               <name>WG</name>
               <identifier>C 3</identifier>
            </subdivision>
            <abbreviation>OGC</abbreviation>
         </organization>
      </contributor>
      <contributor>
         <role type="author">
            <description>committee</description>
         </role>
         <organization>
            <name>Open Geospatial Consortium</name>
            <subdivision type="Committee" subtype="B">
               <name>TC1</name>
               <identifier>B 1</identifier>
               <identifier type="full">B 1</identifier>
            </subdivision>
            <abbreviation>OGC</abbreviation>
         </organization>
      </contributor>
           <contributor>
             <role type="publisher"/>
             <organization>
               <name>Open Geospatial Consortium</name>
               <abbreviation>OGC</abbreviation>
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
               <abbreviation>OGC</abbreviation>
               </organization>
             </owner>
           </copyright>
           <keyword>a</keyword>
          <keyword>b</keyword>
          <keyword>c</keyword>
           <ext>
           <doctype>standard</doctype>
           <subdoctype>conceptual-model</subdoctype>
           <flavor>ogc</flavor>
          </ext>
         </bibdata>
                  <boilerplate>
           <copyright-statement>
             <clause id="_" obligation="normative">
               <title id="_">Copyright notice</title>
               <p id="_" align="center">
                 Copyright © 2001 Open Geospatial Consortium
                 <br/>
                 To obtain additional rights of use, visit
                 <link target="https://www.ogc.org/legal"/>
               </p>
             </clause>
             <clause id="_" obligation="normative">
               <title id="_">Note</title>
               <p id="_" align="left">Attention is drawn to the possibility that some of the elements of this document may be the subject of patent rights. The Open Geospatial Consortium shall not be held responsible for identifying any or all such patent rights.</p>
               <p id="_" align="left">Recipients of this document are requested to submit, with their comments, notification of any relevant patent claims or other intellectual property rights of which they may be aware that might be infringed by any implementation of the standard set forth in this document, and to provide supporting documentation.</p>
             </clause>
           </copyright-statement>
           <license-statement>
             <clause id="_" obligation="normative">
               <title id="_">License Agreement</title>
               <p id="_">
                 Use of this document is subject to the license agreement at
                 <link target="https://www.ogc.org/license"/>
               </p>
             </clause>
           </license-statement>
           <legal-statement>
             <clause id="_" obligation="normative">
               <title id="_">Notice for Drafts</title>
               <p id="_">This document is not an OGC Standard. This document is distributed for review and comment. This document is subject to change without notice and may not be referred to as an OGC Standard.</p>
               <p id="_">Recipients of this document are invited to submit, with their comments, notification of any relevant patent rights of which they are aware and to provide supporting documentation.</p>
             </clause>
           </legal-statement>
           <feedback-statement>
             <clause id="_" anchor="boilerplate-standard-feedback" obligation="normative">
               <p id="_">
                 Suggested additions, changes and comments on this document are welcome and encouraged. Such suggestions may be submitted using the online change request form on OGC web site:
                 <link target="http://ogc.standardstracker.org/"/>
               </p>
             </clause>
           </feedback-statement>
         </boilerplate>
      <preface>#{SECURITY}</preface>
         <sections/>
         </metanorma>
    OUTPUT

    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:metanorma-extension").each(&:remove)
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes OGC synonyms for default metadata, default template for external-id, docidentifier override for internal-id" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :docReference: 1000
      :doctype: technical-paper
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
      :docidentifier: OVERRIDE
    INPUT

    output = <<~"OUTPUT"
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
      <bibdata type="standard">
        <title language="en" type="main">Main Title</title>
        <title language="en" type='abbrev'>A</title>
        <uri>http://www.example.com</uri>
        <docidentifier type='ogc-external'>http://www.opengis.net/doc/TP/A/2.0</docidentifier>
        <docidentifier type='ogc-external'>http://www.example2.com</docidentifier>
        <docidentifier primary="true" type="ogc-internal">OVERRIDE</docidentifier>
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
               <abbreviation>OGC</abbreviation>
          </organization>
        </contributor>
      <edition>2.0</edition>
         <version>
        <revision-date>2000-01-01</revision-date>
        <draft>2.0</draft>
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
               <abbreviation>OGC</abbreviation>
            </organization>
          </owner>
        </copyright>
        <ext>
        <doctype>white-paper</doctype>
           <flavor>ogc</flavor>
        </ext>
      </bibdata>
      <preface>#{SECURITY.sub('standard', 'document')}</preface>
      <sections/>
      </metanorma>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:boilerplate | " \
              "//xmlns:metanorma-extension").each(&:remove)
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "uses default fonts" do
    input = <<~INPUT
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

  it "changes document colours based on document schema" do
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT
    output = <<~OUTPUT
       <metanorma-extension>
          <semantic-metadata>
             <stage-published>true</stage-published>
          </semantic-metadata>
          <presentation-metadata>
             <name>document-scheme</name>
             <value>current</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-caution</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-editor</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-important</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-note</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-safety-precaution</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-tip</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-todo</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-warning</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-definition-description</name>
             <value>rgb(242, 251, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-definition-term</name>
             <value>rgb(215, 243, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-page</name>
             <value>rgb(33, 55, 92)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-table-header</name>
             <value>rgb(33, 55, 92)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-table-row-even</name>
             <value>rgb(252, 246, 222)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-table-row-odd</name>
             <value>rgb(254, 252, 245)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-term-admitted-label</name>
             <value>rgb(223, 236, 249)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-term-deprecated-label</name>
             <value>rgb(237, 237, 238)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-term-preferred-label</name>
             <value>rgb(249, 235, 187)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-text-label-legacy</name>
             <value>rgb(33, 60, 107)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-secondary-shade-1</name>
             <value>rgb(0, 177, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-secondary-shade-2</name>
             <value>rgb(0, 177, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-text</name>
             <value>rgb(88, 89, 91)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-text-title</name>
             <value>rgb(33, 55, 92)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>PDF TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
       </metanorma-extension>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml = xml.xpath("//xmlns:metanorma-extension")
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
        xml = Nokogiri::XML(Asciidoctor.convert(input
      .sub(/:novalid:/, ":novalid:\n:copyright-year: 2023"), *OPTIONS))
    xml = xml.xpath("//xmlns:metanorma-extension")
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)

    output = <<~OUTPUT
      <metanorma-extension>
           <semantic-metadata>
              <stage-published>true</stage-published>
           </semantic-metadata>
           <presentation-metadata>
              <name>document-scheme</name>
              <value>2021</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-caution</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-editor</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-important</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-note</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-safety-precaution</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-tip</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-todo</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-admonition-warning</name>
              <value>rgb(79, 129, 189)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-definition-description</name>
              <value>rgb(242, 251, 255)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-definition-term</name>
              <value>rgb(215, 243, 255)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-page</name>
              <value>rgb(33, 55, 92)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-table-header</name>
              <value>rgb(33, 55, 92)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-table-row-even</name>
              <value>rgb(252, 246, 222)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-table-row-odd</name>
              <value>rgb(254, 252, 245)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-term-admitted-label</name>
              <value>rgb(223, 236, 249)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-term-deprecated-label</name>
              <value>rgb(237, 237, 238)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-term-preferred-label</name>
              <value>rgb(249, 235, 187)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-background-text-label-legacy</name>
              <value>rgb(33, 60, 107)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-secondary-shade-1</name>
              <value>rgb(237, 193, 35)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-secondary-shade-2</name>
              <value>rgb(246, 223, 140)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-text</name>
              <value>rgb(88, 89, 91)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>color-text-title</name>
              <value>rgb(33, 55, 92)</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>TOC Heading Levels</name>
              <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>HTML TOC Heading Levels</name>
              <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>DOC TOC Heading Levels</name>
              <value>2</value>
           </presentation-metadata>
           <presentation-metadata>
              <name>PDF TOC Heading Levels</name>
              <value>2</value>
           </presentation-metadata>
        </metanorma-extension>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input
      .sub(/:novalid:/, ":novalid:\n:document-scheme: 2021"), *OPTIONS))
    xml = xml.xpath("//xmlns:metanorma-extension")
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
    xml = Nokogiri::XML(Asciidoctor.convert(input
      .sub(/:novalid:/, ":novalid:\n:copyright-year: 2020"), *OPTIONS))
    xml = xml.xpath("//xmlns:metanorma-extension")
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)

    output = <<~OUTPUT
       <metanorma-extension>
          <semantic-metadata>
             <stage-published>true</stage-published>
          </semantic-metadata>
          <presentation-metadata>
             <name>document-scheme</name>
             <value>current</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-caution</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-editor</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-important</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-note</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-safety-precaution</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-tip</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-todo</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-admonition-warning</name>
             <value>rgb(79, 129, 189)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-definition-description</name>
             <value>rgb(242, 251, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-definition-term</name>
             <value>rgb(215, 243, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-page</name>
             <value>rgb(68, 84, 106)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-table-header</name>
             <value>rgb(33, 55, 92)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-table-row-even</name>
             <value>rgb(252, 246, 222)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-table-row-odd</name>
             <value>rgb(254, 252, 245)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-term-admitted-label</name>
             <value>rgb(223, 236, 249)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-term-deprecated-label</name>
             <value>rgb(237, 237, 238)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-term-preferred-label</name>
             <value>rgb(249, 235, 187)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-background-text-label-legacy</name>
             <value>rgb(33, 60, 107)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-secondary-shade-1</name>
             <value>rgb(0, 177, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-secondary-shade-2</name>
             <value>rgb(0, 177, 255)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-text</name>
             <value>rgb(88, 89, 91)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>color-text-title</name>
             <value>rgb(68, 84, 106)</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>HTML TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>DOC TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
          <presentation-metadata>
             <name>PDF TOC Heading Levels</name>
             <value>2</value>
          </presentation-metadata>
       </metanorma-extension>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input
      .sub(/:novalid:/, ":novalid:\n:doctype: white-paper"), *OPTIONS))
    xml = xml.xpath("//xmlns:metanorma-extension")
    expect(Canon.format_xml(strip_guid(xml.to_xml))).to be_equivalent_to Canon.format_xml(output)
  end

  it "uses specified fonts" do
    input = <<~INPUT
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
        #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
         <sections>
           <example id="_"><name id="_">Example Title</name><p id="_">This is an example</p>
         <p id="_">Amen</p></example>
         </sections>
         </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes highlight text" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      This is #highlihgted text# inline.
    INPUT
    output = <<~OUTPUT
            #{blank_hdr_gen}
          <preface>#{SECURITY}</preface>
             <sections>
             <p id='_'>
        This is
        <span class="fmt-hi">highlihgted text</span>
         inline.
      </p>
             </sections>
             </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
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
      #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
      <sections>
        <table id='_'>
          <thead>
            <tr id="_">
              <th id="_" valign='middle' align='left'>a</th>
              <th id="_" valign='middle' align='left'>b</th>
            </tr>
          </thead>
          <tbody>
            <tr id="_">
              <td id="_" valign='middle' align='center'>c</td>
              <td id="_" valign='middle' align='right'>d</td>
            </tr>
          </tbody>
        </table>
      </sections>
      </metanorma>
    OUTPUT
    expect(Canon.format_xml(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "applies default requirement model" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [[A]]
      [.permission]
      ====
      I permit this


      [[B]]
      [.permission]
      =====
      I also permit this

      . List
      . List
      =====
      ====
    INPUT

    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    expect(xml.at("//xmlns:permission[@anchor = 'A']/@model").text).to eq("ogc")
    expect(xml.at("//xmlns:permission/xmlns:permission/@model").text)
      .to eq("ogc")
  end

  it "sorts symbols lists #1" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [[L]]
      == Symbols and abbreviated terms

      α:: Definition 1
      Xa:: Definition 2
      x_1_:: Definition 3
      x_m_:: Definition 4
      x:: Definition 5
      stem:[n]:: Definition 6
      m:: Definition 7
      2d:: Definition 8
    INPUT
    output = <<~OUTPUT
      <definitions id="_" anchor="L" obligation="normative">
         <title id="_">Symbols and abbreviated terms</title>
         <dl id="_">
            <dt anchor="symbol-_d" id="_">2d</dt>
            <dd id="_">
               <p id="_">Definition 8</p>
            </dd>
            <dt anchor="symbol-m" id="_">m</dt>
            <dd id="_">
               <p id="_">Definition 7</p>
            </dd>
            <dt anchor="symbol-n" id="_">
               <stem block="false" type="MathML">
                  <math xmlns="http://www.w3.org/1998/Math/MathML">
                     <mstyle displaystyle="false">
                        <mi>n</mi>
                     </mstyle>
                  </math>
                  <asciimath>n</asciimath>
               </stem>
            </dt>
            <dd id="_">
               <p id="_">Definition 6</p>
            </dd>
            <dt anchor="symbol-x" id="_">x</dt>
            <dd id="_">
               <p id="_">Definition 5</p>
            </dd>
            <dt anchor="symbol-x_1_" id="_">x_1_</dt>
            <dd id="_">
               <p id="_">Definition 3</p>
            </dd>
            <dt anchor="symbol-x_m_" id="_">x_m_</dt>
            <dd id="_">
               <p id="_">Definition 4</p>
            </dd>
            <dt anchor="symbol-Xa" id="_">Xa</dt>
            <dd id="_">
               <p id="_">Definition 2</p>
            </dd>
            <dt anchor="symbol-α" id="_">α</dt>
            <dd id="_">
               <p id="_">Definition 1</p>
            </dd>
         </dl>
      </definitions>
    OUTPUT
    doc = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml = doc.at("//xmlns:definitions")
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "processes document history in misc-container" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [.preface]
      == Misc-container

      === document history

      [source,yaml]
      ----
      - date:
        - type: published
          value:  2012-04-02
        version:
          draft: Draft
        contributor:
          person:
            name:
              completename: R Thakkar
        amend:
          location: whole
          description: Original draft document
      - date:
        - type: published
          value:  2002-08-30
        version:
          draft: 0.1 02-077
        contributor:
          - person:
             name:
                completename: Kurt Buehler
             role:
               type: editor
          - person:
             name:
                completename: George Percivall
             role:
               type: editor
          - person:
             name:
                completename: Sam Bacharach
             role:
               type: editor
          - person:
             name:
                completename: Carl Reed
             role:
               type: editor
          - person:
             name:
                completename: Cliff Kottman
             role:
               type: editor
          - person:
             name:
                completename: Chuck Heazel
             role:
               type: editor
          - person:
             name:
                completename: John Davidson
             role:
               type: editor
          - person:
             name:
                completename: Yaser Bisher
             role:
               type: editor
          - person:
             name:
                completename: Harry Niedzwiadek
             role:
               type: editor
          - person:
             name:
                completename: John Evans
             role:
               type: editor
          - person:
              name:
                completename: Jeffrey Simon
              role:
               type: editor
        amend:
          description: Initial version of ORM. Doc OGC
      - date:
        - type: published
          value:  2018-06-04
        version:
          draft: 1.0
        contributor:
          person:
            name:
              completename: Gabby Getz
        amend:
          location: annex=A
          description: |
            * Put _3D Tiles_ specification document into OGC document template
            * Miscellaneous updates
      ----
    INPUT
    output = <<~OUTPUT
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
        <status>
          <stage>approved</stage>
        </status>
        <copyright>
          <from>#{Date.today.year}</from>
          <owner>
            <organization>
              <name>Open Geospatial Consortium</name>
              <abbreviation>OGC</abbreviation>
            </organization>
          </owner>
        </copyright>
        <relation type="updatedBy">
          <bibitem>
            <date type="published">
              <on>2012-04-02</on>
            </date>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>R Thakkar</completename>
                </name>
              </person>
            </contributor>
            <version>
              <draft>Draft</draft>
            </version>
            <amend change="modify">
              <description>
                <p id="_">Original draft document</p>
              </description>
              <location>
                <localityStack>
                  <locality type="whole"/>
                </localityStack>
              </location>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <date type="published">
              <on>2002-08-30</on>
            </date>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Kurt Buehler</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>George Percivall</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Sam Bacharach</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Carl Reed</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Cliff Kottman</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Chuck Heazel</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>John Davidson</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Yaser Bisher</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Harry Niedzwiadek</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>John Evans</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Jeffrey Simon</completename>
                </name>
              </person>
            </contributor>
            <version>
              <draft>0.1 02-077</draft>
            </version>
            <amend change="modify">
              <description>
                <p id="_">Initial version of ORM. Doc OGC</p>
              </description>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <date type="published">
              <on>2018-06-04</on>
            </date>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Gabby Getz</completename>
                </name>
              </person>
            </contributor>
            <version>
              <draft>1.0</draft>
            </version>
            <amend change="modify">
              <description>
                <ul id="_">
                  <li>
                    <p id="_">
                      Put
                      <em>3D Tiles</em>
                      specification document into OGC document template
                    </p>
                  </li>
                  <li>
                    <p id="_">Miscellaneous updates</p>
                  </li>
                </ul>
              </description>
              <location>
          <localityStack>
            <locality type="annex">
              <referenceFrom>A</referenceFrom>
            </locality>
          </localityStack>
        </location>
            </amend>
          </bibitem>
        </relation>
        <ext>
          <doctype>standard</doctype>
          <subdoctype>implementation</subdoctype>
           <flavor>ogc</flavor>
        </ext>
      </bibdata>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml = xml.at("//xmlns:bibdata")
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end

  it "applies engineering report style attribues" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR.sub(':nodoc:', ":doctype: engineering-report\n:nodoc:")}

      [executive_summary]
      == Exec Summ

      [overview]
      == Ovrvw

      [future_outlook]
      == F O

      [value_proposition]
      == V P

      [contributors]
      == Contr

      [random]
      == Rand

      [introduction]
      == Introduction

      [aims]
      === Aims

      [objectives]
      === Objectives

      [topics]
      == Topics

      [outlook]
      == Outlook

      [security]
      == Security etc
    INPUT

    output = <<~OUTPUT
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
             <preface>
             <clause id="_" type="overview" obligation="informative">
                <title id="_">Ovrvw</title>
             </clause>
             <clause id="_" type="future_outlook" obligation="informative">
                <title id="_">F O</title>
             </clause>
             <clause id="_" type="value_proposition" obligation="informative">
                <title id="_">V P</title>
             </clause>
             <executivesummary id="_" obligation="informative">
                <title id="_">Executive summary</title>
             </executivesummary>
             <clause id="_" type="contributors" obligation="informative">
                <title id="_">Contr</title>
             </clause>
          </preface>
          <sections>
             <clause id="_" obligation="normative">
                <title id="_">Rand</title>
             </clause>
             <clause id="_" obligation="normative">
                <title id="_">Introduction</title>
                <clause id="_" type="aims" obligation="normative">
                   <title id="_">Aims</title>
                </clause>
                <clause id="_" type="objectives" obligation="normative">
                   <title id="_">Objectives</title>
                </clause>
             </clause>
             <clause id="_" type="topics" obligation="normative">
                <title id="_">Topics</title>
             </clause>
             <clause id="_" type="outlook" obligation="normative">
                <title id="_">Outlook</title>
             </clause>
             <clause id="_" obligation="normative">
                <title id="_">Security etc</title>
             </clause>
          </sections>
       </metanorma>
    OUTPUT

    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:boilerplate | //xmlns:bibdata | //xmlns:metanorma-extension")
      .each(&:remove)
    expect(Canon.format_xml(strip_guid(xml.to_xml)))
      .to be_equivalent_to Canon.format_xml(output)
  end
end
