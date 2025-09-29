require "spec_helper"

logoloc = File.expand_path(
  File.join(File.dirname(__FILE__), "..", "..",
            "lib", "isodoc", "ogc", "html"),
)

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
            <name>OGC</name>
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
            <name>OGC</name>
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
              <name>OGC</name>
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
      #{METANORMA_EXTENSION.sub("<stage-published>true", "<stage-published>false")}
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
        copyright_holder: "OGC, ISO, and IEC",
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
        editors: ["Fred Flintstone"],
        externalid: "http://www.example2.com",
        html: "http://www.example.com/html",
        implementeddate: "XXX",
        issueddate: "2001-01-01",
        keywords: ["A", "B"],
        lang: "en",
        logo_new: File.join(logoloc, "logo.2021.svg"),
        logo_old: File.join(logoloc, "logo.png"),
        logo_word: File.join(logoloc, "logo.png"),
        obsoleteddate: "XXX",
        pdf: "http://www.example.com/pdf",
        "presentation_metadata_DOC TOC Heading Levels": ["2"],
        "presentation_metadata_HTML TOC Heading Levels": ["2"],
        "presentation_metadata_PDF TOC Heading Levels": ["2"],
        "presentation_metadata_TOC Heading Levels": ["2"],
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
        "presentation_metadata_document-scheme": ["current"],
        publisheddate: "2002-01-01",
        publisher: "OGC",
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
    docxml, = csdc.convert_init(input, "test", true)
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to output

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

  it "processes metadata with new logo" do
    csdc = IsoDoc::Ogc::HtmlConvert.new({})
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata type="standard">
        <title language="en" format="text/plain">Main Title</title>
        <docidentifier type="ogc-external">http://www.example2.com</docidentifier>
        <docidentifier type="ogc-internal">1000</docidentifier>
        <docnumber>1000</docnumber>
        <date type="published">
          <on>2030-01-01</on>
        </date>
      </bibdata>
      </ogc-standard>
    INPUT
    output =
      { accesseddate: "XXX",
        adapteddate: "XXX",
        announceddate: "XXX",
        circulateddate: "XXX",
        confirmeddate: "XXX",
        copieddate: "XXX",
        copyright_holder: "Open Geospatial Consortium",
        correcteddate: "XXX",
        createddate: "XXX",
        doclanguage: "English",
        docnumber: "1000",
        docnumeric: "1000",
        doctitle: "Main Title",
        externalid: "http://www.example2.com",
        implementeddate: "XXX",
        issueddate: "XXX",
        lang: "en",
        logo_new: File.join(logoloc, "logo.2021.svg"),
        logo_old: File.join(logoloc, "logo.png"),
        logo_word: File.join(logoloc, "logo.2021.svg"),
        obsoleteddate: "XXX",
        publisheddate: "2030-01-01",
        receiveddate: "XXX",
        script: "Latn",
        stable_untildate: "XXX",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: false,
        updateddate: "XXX",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX" }
    docxml, = csdc.convert_init(input, "test", true)
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to output
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
      </bibdata>
      </ogc-standard>
    INPUT
    output =
      { accesseddate: "XXX",
        adapteddate: "XXX",
        announceddate: "XXX",
        circulateddate: "XXX",
        confirmeddate: "XXX",
        copieddate: "XXX",
        copyright_holder: "Open Geospatial Consortium",
        correcteddate: "XXX",
        createddate: "XXX",
        doclanguage: "English",
        docnumber: "1000",
        docnumeric: "1000",
        doctitle: "Main Title",
        externalid: "http://www.example2.com",
        implementeddate: "XXX",
        issueddate: "XXX",
        lang: "en",
        logo_new: File.join(logoloc, "logo.2021.svg"),
        logo_old: File.join(logoloc, "logo.png"),
        logo_word: File.join(logoloc, "logo.2021.svg"),
        obsoleteddate: "XXX",
        publisheddate: "yyyy-mm-dd",
        receiveddate: "XXX",
        script: "Latn",
        stable_untildate: "XXX",
        transmitteddate: "XXX",
        unchangeddate: "XXX",
        unpublished: false,
        updateddate: "XXX",
        vote_endeddate: "XXX",
        vote_starteddate: "XXX" }
    docxml, = csdc.convert_init(input, "test", true)
    expect(metadata(csdc.info(docxml, nil)))
      .to be_equivalent_to output
  end
end
