require "spec_helper"

logoloc = File.expand_path(
  File.join(File.dirname(__FILE__), "..", "..",
            "lib", "isodoc", "ogc", "html"),
)

logo_2026_svg = File.read(File.join(logoloc, "Logos_2026", "1_Blue_Logos",
                                    "OGC-new-logo.svg"))
  #.sub("<svg ", '<svg preserveaspectratio="xMidYMin slice" ')
logo_2026_white_svg = File.read(File.join(logoloc, "Logos_2026",
                                          "3_Reverse_Logos", "OGC-new-logo-white.svg"))
  #.sub("<svg ", '<svg preserveaspectratio="xMidYMin slice" ')
logo_2026_png = File.join(logoloc, "Logos_2026", "1_Blue_Logos",
                          "OGC-new-logo.png")
logo_2022_svg = File.read(File.join(logoloc, "logo.2021.svg"))
  .sub("<svg ", '<svg preserveaspectratio="xMidYMin slice" ')
logo_2022_white_svg = File.read(File.join(logoloc, "logo.2021-white.svg"))
  .sub("<svg ", '<svg preserveaspectratio="xMidYMin slice" ')
logo_2022_png = File.join(logoloc, "logo.2021.png")
logo_2018_png = File.join(logoloc, "logo.2018.png")
logo_2018_white_png = File.join(logoloc, "logo.2018-white.png")

RSpec.describe IsoDoc::Ogc do
  it "processes default metadata" do
    csdc = IsoDoc::Ogc::HtmlConvert.new({})
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <uri>http://www.example.com</uri>
        <uri type="html">http://www.example.com/html</uri>
        <uri type="xml">http://www.example.com/xml</uri>
        <uri type="pdf">http://www.example.com/pdf</uri>
        <uri type="doc">http://www.example.com/doc</uri>
        <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
        <docidentifier type="ogc-internal">1000</docidentifier>
        <docnumber>1000</docnumber>
        <abstract><p>This is a description.</p>
        <quote>This is a <em>blockquote</em> within a description.</quote>
        </abstract>
        <date type="published">
          <on>2002-01-01</on>
        </date>
        <date type="created">
          <on>1999-01-01</on>
        </date>
        <date type="issued">
          <on>2001-01-01</on>
        </date>
        <contributor>
          <role type="author"/>
          <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
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
          <role type="author"/>
          <person>
            <name>
              <forename>Pearl</forename>
              <surname>Slaghoople</surname>
            </name>
          </person>
        </contributor>
      <contributor>
         <role type="author">
            <description>Committee</description>
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
            <description>Committee</description>
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
        <status><stage>SWG Work</stage></status>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
            </organization>
          </owner>
        </copyright>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
              <name>ISO</name>
            </organization>
          </owner>
        </copyright>
        <copyright>
          <from>2001</from>
          <owner>
            <organization>
              <name>IEC</name>
            </organization>
          </owner>
        </copyright>
        <keyword>A</keyword>
        <keyword>B</keyword>
        <ext>
        <doctype>standard</doctype>
        <subdoctype>conceptual-model-and-encoding</subdoctype>
        <editorialgroup>
          <committee type="A">TC</committee>
          <committee type="B">TC1</committee>
          <subcommittee type="C" number="1">SC1</committee>
          <workgroup type="D" number="2">WG1</committee>
        </editorialgroup>
        </ext>
      </bibdata>
      #{METANORMA_EXTENSION.sub('<stage-published>true', '<stage-published>false')}
      <sections/>
      </ogc-standard>
    INPUT

    output =
      { abstract: "This is a description. This is a blockquote within a description.",
        accesseddate: "XXX",
        adapteddate: "XXX",
        agency: "OGC",
        announceddate: "XXX",
        authors: ["Barney Rubble", "Pearl Slaghoople"],
        circulateddate: "XXX",
        confirmeddate: "XXX",
        copieddate: "XXX",
        copyright_holder: "Open Geospatial Consortium, ISO, and IEC",
        correcteddate: "XXX",
        createddate: "1999-01-01",
        doc: "http://www.example.com/doc",
        doclanguage: "English",
        docnumber: "1000",
        docnumeric: "1000",
        docsubtype: "Conceptual Model And Encoding",
        docsubtype_abbr: "CME",
        doctitle: "Main Title",
        doctype: "Standard",
        doctype_abbr: "IS",
        docyear: "2001",
        draft: "3.4",
        draftinfo: " (draft 3.4, 2000-01-01)",
        edition: "2.0",
        edition_display: "edition 2.0",
        editors: ["Fred Flintstone"],
        externalid: "http://www.example2.com",
        html: "http://www.example.com/html",
        implementeddate: "XXX",
        issueddate: "2001-01-01",
        keywords: ["A", "B"],
        lang: "en",
        obsoleteddate: "XXX",
        pdf: "http://www.example.com/pdf",
        "presentation_metadata_color-admonition-caution": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-admonition-editor": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-admonition-important": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-admonition-note": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-admonition-safety-precaution": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-admonition-tip": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-admonition-todo": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-admonition-warning": ["rgb(79, 129, 189)"],
        "presentation_metadata_color-background-definition-description": ["rgb(242, 251, 255)"],
        "presentation_metadata_color-background-definition-term": ["rgb(215, 243, 255)"],
        "presentation_metadata_color-background-page": ["rgb(33, 55, 92)"],
        "presentation_metadata_color-background-table-header": ["rgb(33, 55, 92)"],
        "presentation_metadata_color-background-table-row-even": ["rgb(252, 246, 222)"],
        "presentation_metadata_color-background-table-row-odd": ["rgb(254, 252, 245)"],
        "presentation_metadata_color-background-term-admitted-label": ["rgb(223, 236, 249)"],
        "presentation_metadata_color-background-term-deprecated-label": ["rgb(237, 237, 238)"],
        "presentation_metadata_color-background-term-preferred-label": ["rgb(249, 235, 187)"],
        "presentation_metadata_color-background-text-label-legacy": ["rgb(33, 60, 107)"],
        "presentation_metadata_color-secondary-shade-1": ["rgb(0, 177, 255)"],
        "presentation_metadata_color-secondary-shade-2": ["rgb(0, 177, 255)"],
        "presentation_metadata_color-text": ["rgb(88, 89, 91)"],
        "presentation_metadata_color-text-title": ["rgb(33, 55, 92)"],
        "presentation_metadata_doc-toc-heading-levels": ["2"],
        "presentation_metadata_document-scheme": ["2026"],
        "presentation_metadata_html-toc-heading-levels": ["2"],
        "presentation_metadata_pdf-toc-heading-levels": ["2"],
        "presentation_metadata_toc-heading-levels": ["2"],
        publisheddate: "2002-01-01",
        publisher: "Open Geospatial Consortium",
        receiveddate: "XXX",
        revdate: "2000-01-01",
        revdate_monthyear: "January 2000",
        script: "Latn",
        stable_untildate: "XXX",
        stage: "SWG Work",
        stage_display: "SWG Work",
        stageabbr: "SW",
        tc: "TC",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: true,
        updateddate: "XXX",
        url: "http://www.example.com",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX",
        xml: "http://www.example.com/xml" }

    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    docxml, = csdc.convert_init(pres_output, "test", true)
    m = metadata(csdc.info(docxml, nil))
    m.delete(:logo_html)
    m.delete(:logo_html_white)
    m.delete(:logo_html_blue)
    m.delete(:logo_word)
    expect(m).to be_equivalent_to output

    html = <<~HTML
       <meta name="keywords" content="A, B" /><meta name="DC.subject" lang="en" content="A, B" xml:lang="en" /><meta name="description" content="This is a description. This is a blockquote within a description." />
      <meta name="DC.description" lang="en" content="This is a description. This is a blockquote within a description." xml:lang="en" />
      <meta name="DC.creator" lang="en" content="Barney Rubble, Pearl Slaghoople" xml:lang="en" />
      <meta name="DC.date" content="2000-01-01" /><meta name="DC.title" lang="en" content="Main Title" xml:lang="en" />
      <link rel="profile" href="http://dublincore.org/documents/2008/08/04/dc-html/" />
      <link rel="schema.DC" href="http://purl.org/dc/elements/1.1/" />
      <meta name="DC.language" content="en" />
      <meta name="DC.rights" lang="en" content="CC-BY-4.0" xml:lang="en" />
      <link rel="schema.DCTERMS" href="http://purl.org/dc/terms/" />
      <link rel="DCTERMS.license" href="https://www.ogc.org/license" />
    HTML
    FileUtils.rm_f("test.html")
    csdc.convert("test", input, false)
    expect(File.read("test.html")
      .gsub(%r{^.*<meta name="keywords"}m, '<meta name="keywords"')
      .gsub(%r{</head>.*$}m, ""))
      .to be_equivalent_to html
  end

  it "processes metadata with 2026 logo" do
    csdc = IsoDoc::Ogc::HtmlConvert.new({})
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
        <docidentifier type="ogc-internal">1000</docidentifier>
        <docnumber>1000</docnumber>
        <date type="published"><on>1900-01-01</on></date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
          </organization>
        </contributor>
      </bibdata>
      <metaorma-extension>
      <presentation-metadata><document-scheme>2026</document-scheme></presentation-metadata>
      </metaorma-extension>
      </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <contributor>
       <role type="publisher"/>
          <organization>
             <name>Open Geospatial Consortium</name>
             <abbreviation>OGC</abbreviation>
             <logo type="html-blue">
                <image src="" mimetype="image/svg+xml">
            #{logo_2026_svg}
            </image>
            </logo>
             <logo type="html-white">
                <image src="" mimetype="image/svg+xml">
            #{logo_2026_white_svg}
            </image>
            </logo>
            <logo type="word">
                <image src="#{logo_2026_png}" mimetype="image/png"/>
             </logo>
          </organization>
       </contributor>
    OUTPUT

    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    test = Nokogiri::XML(pres_output).at("//xmlns:contributor[xmlns:role/@type='publisher']").to_xml
    expect(strip_guid(test))
      .to be_xml_equivalent_to presxml
    docxml, = csdc.convert_init(pres_output, "test", true)
    m = metadata(csdc.info(docxml, nil))
    expect(m[:logo_html]).to be_equivalent_to logo_2026_white_svg
    expect(m[:logo_html_white]).to be_equivalent_to logo_2026_white_svg
    expect(m[:logo_html_blue]).to be_equivalent_to logo_2026_svg
    expect(m[:logo_word])
      .to be_equivalent_to logo_2026_png
  end

  it "processes metadata with 2022 logo" do
    csdc = IsoDoc::Ogc::HtmlConvert.new({})
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
        <docidentifier type="ogc-internal">1000</docidentifier>
        <docnumber>1000</docnumber>
        <date type="published">
          <on>2026-01-01</on>
        </date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
          </organization>
        </contributor>
      </bibdata>
      <presentation-metadata><document-scheme>2022</document-scheme></presentation-metadata>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <contributor>
       <role type="publisher"/>
          <organization>
             <name>Open Geospatial Consortium</name>
             <abbreviation>OGC</abbreviation>
             <logo type="html-blue">
                <image src="" mimetype="image/svg+xml">
            #{logo_2022_svg}
            </image>
            </logo>
             <logo type="html-white">
                <image src="" mimetype="image/svg+xml">
            #{logo_2022_white_svg}
            </image>
            </logo>
            <logo type="word">
                <image src="#{logo_2022_png}" mimetype="image/png"/>
             </logo>
          </organization>
       </contributor>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    test = Nokogiri::XML(pres_output).at("//xmlns:contributor[xmlns:role/@type='publisher']").to_xml
    expect(strip_guid(test))
      .to be_xml_equivalent_to presxml
    docxml, = csdc.convert_init(pres_output, "test", true)
    m = metadata(csdc.info(docxml, nil))
    expect(m[:logo_html]).to be_equivalent_to logo_2022_svg
    expect(m[:logo_html_blue]).to be_equivalent_to logo_2022_svg
    expect(m[:logo_html_white]).to be_equivalent_to logo_2022_white_svg
    expect(m[:logo_word]).to be_equivalent_to logo_2022_png
  end

  it "processes metadata with 2018 logo" do
    csdc = IsoDoc::Ogc::HtmlConvert.new({})
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
        <docidentifier type="ogc-internal">1000</docidentifier>
        <docnumber>1000</docnumber>
        <date type="published"><on>2040-01-01</on></date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
          </organization>
        </contributor>
      </bibdata>
      <metaorma-extension>
      <presentation-metadata><document-scheme>2018</document-scheme></presentation-metadata>
      </metaorma-extension>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
         <contributor>
      <role type="publisher"/>
         <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
            <logo type="html-blue">
               <image src="#{logo_2018_png}" mimetype="image/png"/>
           </logo>
            <logo type="html-white">
               <image src="#{logo_2018_white_png}" mimetype="image/png"/>
           </logo>
           <logo type="word">
               <image src="#{logo_2018_png}" mimetype="image/png"/>
            </logo>
         </organization>
      </contributor>
    OUTPUT

    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    test = Nokogiri::XML(pres_output).at("//xmlns:contributor[xmlns:role/@type='publisher']").to_xml
    expect(strip_guid(test))
      .to be_xml_equivalent_to presxml
    docxml, = csdc.convert_init(pres_output, "test", true)
    m = metadata(csdc.info(docxml, nil))
    expect(m[:logo_html]).to be_equivalent_to <<~XML
      <img src="#{logo_2018_png}" mimetype="image/png"/>
    XML
    expect(m[:logo_html_blue]).to be_equivalent_to <<~XML
      <img src="#{logo_2018_png}" mimetype="image/png"/>
    XML
    expect(m[:logo_html_white]).to be_equivalent_to <<~XML
      <img src="#{logo_2018_white_png}" mimetype="image/png"/>
    XML
    expect(m[:logo_word])
      .to be_equivalent_to logo_2018_png
  end

  it "uses new logo for invalid data" do
    csdc = IsoDoc::Ogc::HtmlConvert.new({})
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
        <docidentifier type="ogc-internal">1000</docidentifier>
        <docnumber>1000</docnumber>
        <date type="published">
          <on>yyyy-mm-dd</on>
        </date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
          </organization>
        </contributor>
      </bibdata>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
          <contributor>
         <role type="publisher"/>
         <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
            <logo type="html-blue">
               <image src="" mimetype="image/svg+xml">
           #{logo_2026_svg}
           </image>
           </logo>
            <logo type="html-white">
               <image src="" mimetype="image/svg+xml">
           #{logo_2026_white_svg}
           </image>
           </logo>
           <logo type="word">
               <image src="#{logo_2026_png}" mimetype="image/png"/>
            </logo>
         </organization>
      </contributor>
    OUTPUT

    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    test = Nokogiri::XML(pres_output).at("//xmlns:contributor[xmlns:role/@type='publisher']").to_xml
    expect(strip_guid(test))
      .to be_xml_equivalent_to presxml
    docxml, = csdc.convert_init(pres_output, "test", true)
    m = metadata(csdc.info(docxml, nil))
    expect(m[:logo_html]).to be_equivalent_to logo_2026_white_svg
    expect(m[:logo_word])
      .to be_equivalent_to logo_2026_png
  end
end
