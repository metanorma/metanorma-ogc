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
          <role type="contributor"/>
          <person>
            <name>
              <forename>Pearl</forename>
              <surname>Slaghoople</surname>
            </name>
          </person>
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
      <sections/>
      </ogc-standard>
    INPUT

    output = <<~"OUTPUT"
      {:abstract=>"This is a description. This is a blockquote within a description.",
      :accesseddate=>"XXX",
      :adapteddate=>"XXX",
      :agency=>"OGC",
      :announceddate=>"XXX",
      :authors=>["Barney Rubble"],
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :contributors=>["Pearl Slaghoople"],
      :copieddate=>"XXX",
      :copyright_holder=>"OGC, ISO, and IEC",
      :correcteddate=>"XXX",
      :createddate=>"1999-01-01",
      :doc=>"http://www.example.com/doc",
      :doclanguage=>"English",
      :docnumber=>"1000",
      :docnumeric=>"1000",
      :docsubtype=>"Conceptual Model And Encoding",
      :docsubtype_abbr=>"CME",
      :doctitle=>"Main Title",
      :doctype=>"Standard",
      :doctype_abbr=>"IS",
      :docyear=>"2001",
      :draft=>"3.4",
      :draftinfo=>" (draft 3.4, 2000-01-01)",
      :edition=>"2.0",
      :editors=>["Fred Flintstone"],
      :externalid=>"http://www.example2.com",
      :html=>"http://www.example.com/html",
      :implementeddate=>"XXX",
      :issueddate=>"2001-01-01",
      :keywords=>["A", "B"],
      :lang=>"en",
      :logo_new=>"#{File.join(logoloc, 'logo.2021.svg')}",
      :logo_old=>"#{File.join(logoloc, 'logo.png')}",
      :logo_word=>"#{File.join(logoloc, 'logo.png')}",
      :obsoleteddate=>"XXX",
      :pdf=>"http://www.example.com/pdf",
      :publisheddate=>"2002-01-01",
      :publisher=>"OGC",
      :receiveddate=>"XXX",
      :revdate=>"2000-01-01",
      :revdate_monthyear=>"January 2000",
      :script=>"Latn",
      :stable_untildate=>"XXX",
      :stage=>"SWG Work",
      :stage_display=>"SWG Work",
      :stageabbr=>"SW",
      :tc=>"TC",
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :url=>"http://www.example.com",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX",
      :xml=>"http://www.example.com/xml"}
    OUTPUT
    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(", :", ",\n:")).to be_equivalent_to output
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
    output = <<~OUTPUT
      {:accesseddate=>"XXX",
      :adapteddate=>"XXX",
      :announceddate=>"XXX",
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :copieddate=>"XXX",
      :copyright_holder=>"Open Geospatial Consortium",
      :correcteddate=>"XXX",
      :createddate=>"XXX",
      :doclanguage=>"English",
      :docnumber=>"1000",
      :docnumeric=>"1000",
      :doctitle=>"Main Title",
      :externalid=>"http://www.example2.com",
      :implementeddate=>"XXX",
      :issueddate=>"XXX",
      :lang=>"en",
      :logo_new=>"#{File.join(logoloc, 'logo.2021.svg')}",
      :logo_old=>"#{File.join(logoloc, 'logo.png')}",
      :logo_word=>"#{File.join(logoloc, 'logo.2021.svg')}",
      :obsoleteddate=>"XXX",
      :publisheddate=>"2030-01-01",
      :receiveddate=>"XXX",
      :script=>"Latn",
      :stable_untildate=>"XXX",
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}
    OUTPUT
    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(", :", ",\n:")).to be_equivalent_to output
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
    output = <<~OUTPUT
      {:accesseddate=>"XXX",
      :adapteddate=>"XXX",
      :announceddate=>"XXX",
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :copieddate=>"XXX",
      :copyright_holder=>"Open Geospatial Consortium",
      :correcteddate=>"XXX",
      :createddate=>"XXX",
      :doclanguage=>"English",
      :docnumber=>"1000",
      :docnumeric=>"1000",
      :doctitle=>"Main Title",
      :externalid=>"http://www.example2.com",
      :implementeddate=>"XXX",
      :issueddate=>"XXX",
      :lang=>"en",
      :logo_new=>"#{File.join(logoloc, 'logo.2021.svg')}",
      :logo_old=>"#{File.join(logoloc, 'logo.png')}",
      :logo_word=>"#{File.join(logoloc, 'logo.2021.svg')}",
      :obsoleteddate=>"XXX",
      :publisheddate=>"yyyy-mm-dd",
      :receiveddate=>"XXX",
      :script=>"Latn",
      :stable_untildate=>"XXX",
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}
    OUTPUT
    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(", :", ",\n:")).to be_equivalent_to output
  end
end
