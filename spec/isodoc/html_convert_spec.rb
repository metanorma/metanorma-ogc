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
      :agency=>"OGC",
      :authors=>["Barney Rubble"],
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :contributors=>["Pearl Slaghoople"],
      :copieddate=>"XXX",
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
      .gsub(/, :/, ",\n:")).to be_equivalent_to output
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
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :copieddate=>"XXX",
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
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}
    OUTPUT
    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(/, :/, ",\n:")).to be_equivalent_to output
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
      :circulateddate=>"XXX",
      :confirmeddate=>"XXX",
      :copieddate=>"XXX",
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
      :transmitteddate=>"XXX",
      :unchangeddate=>"XXX",
      :unpublished=>true,
      :updateddate=>"XXX",
      :vote_endeddate=>"XXX",
      :vote_starteddate=>"XXX"}
    OUTPUT
    docxml, = csdc.convert_init(input, "test", true)
    expect(htmlencode(metadata(csdc.info(docxml, nil)).to_s)
      .gsub(/, :/, ",\n:")).to be_equivalent_to output
  end

  it "processes contributor" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <status>
      <stage>approved</stage>
      </status>
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
      <ext>
      <doctype>community-practice</doctype>
      </ext>
      </bibdata>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
           <bibdata>
             <status>
               <stage language=''>published</stage>
               <stage language='en'>Published</stage>
             </status>
      <contributor>
        <role type='editor'/>
        <person>
          <name>
            <completename>Fred Flintstone</completename>
          </name>
        </person>
      </contributor>
      <contributor>
        <role type='author'/>
        <person>
          <name>
            <forename>Barney</forename>
            <surname>Rubble</surname>
          </name>
        </person>
      </contributor>
      <contributor>
        <role type='contributor'/>
        <person>
          <name>
            <forename>Pearl</forename>
            <surname>Slaghoople</surname>
          </name>
        </person>
      </contributor>
             <ext>
               <doctype>community-practice</doctype>
             </ext>
           </bibdata>
           <sections/>
      </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "changes approved to published" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <status>
      <stage>approved</stage>
      </status>
      <ext>
      <doctype>community-practice</doctype>
      </ext>
      </bibdata>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <bibdata>
           <status>
             <stage language=''>published</stage>
             <stage language='en'>Published</stage>
           </status>
           <ext>
             <doctype>community-practice</doctype>
           </ext>
         </bibdata>
         <sections/>
       </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "renders white-paper as technical-paper after cutoff date" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <date type="published">2021-12-16</date>
      <status>
      <stage>approved</stage>
      </status>
      <ext>
      <doctype>white-paper</doctype>
      </ext>
      </bibdata>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <bibdata>
           <date type="published">2021-12-16</date>
           <status>
             <stage language=''>published</stage>
             <stage language='en'>Published</stage>
           </status>
           <ext>
             <doctype>technical-paper</doctype>
           </ext>
         </bibdata>
         <sections/>
       </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "renders white-paper as white-paper before cutoff date" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <date type="issued">2021-12-15</date>
      <status>
      <stage>approved</stage>
      </status>
      <ext>
      <doctype>white-paper</doctype>
      </ext>
      </bibdata>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <bibdata>
           <date type="issued">2021-12-15</date>
           <status>
             <stage language=''>published</stage>
             <stage language='en'>Published</stage>
           </status>
           <ext>
             <doctype>white-paper</doctype>
           </ext>
         </bibdata>
         <sections/>
       </ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes pre" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <preface><foreword id="A"><title>Preface</title>
      <pre>ABC</pre>
      </foreword></preface>
      </ogc-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
      #{HTML_HDR}
               <br/>
               <div id="A">
                 <h1 class="ForewordTitle">Preface</h1>
                 <pre>ABC</pre>
               </div>
               <p class="zzSTDTitle1"/>
             </div>
           </body>
    OUTPUT

    expect(xmlpp(
             IsoDoc::Ogc::HtmlConvert.new({})
             .convert("test", input, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to output
  end

  it "processes keyword with no preface" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <keyword>ABC</keyword>
      <keyword>DEF</keyword>
      </bibdata>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type="presentation">
           <bibdata>
             <keyword>ABC</keyword>
             <keyword>DEF</keyword>
           </bibdata>
           <preface>
             <clause id="_" type='keywords' displayorder="1">
               <title depth='1'>I.<tab/>Keywords</title>
               <p>The following are keywords to be used by search engines and document catalogues.</p>
               <p>ABC, DEF</p>
             </clause>
           </preface>
           <sections/>
         </ogc-standard>
    OUTPUT

    output = <<~"OUTPUT"
            #{HTML_HDR}
            <div class="Section3" id="_">
            <h1 class="IntroTitle">I.&#160; Keywords</h1>
            <p>The following are keywords to be used by search engines and document catalogues.</p>
            <p>ABC, DEF</p>
          </div>
          <p class="zzSTDTitle1"/>
        </div>
      </body>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(
             IsoDoc::Ogc::HtmlConvert.new({})
             .convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to xmlpp(output)
  end

  it "processes keyword with preface" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <keyword>ABC</keyword>
      <keyword>DEF</keyword>
      </bibdata>
      <preface>
      <abstract id="A"/>
      </preface>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type="presentation">
               <bibdata>
                 <keyword>ABC</keyword>
                 <keyword>DEF</keyword>
               </bibdata>
               <preface>
               <abstract id='A' displayorder="1">
        <title>I.</title>
      </abstract>
                 <clause id="_" type='keywords' displayorder="2">
                   <title depth='1'>II.<tab/>Keywords</title>
                   <p>The following are keywords to be used by search engines and document catalogues.</p>
                   <p>ABC, DEF</p>
                 </clause>
               </preface>
               <sections/>
             </ogc-standard>
    OUTPUT

    output = <<~"OUTPUT"
       #{HTML_HDR}
          <br/>
          <div id='A'>
            <h1 class='AbstractTitle'>I.</h1>
          </div>
          <div class='Section3' id='_'>
            <h1 class='IntroTitle'>II.&#160; Keywords</h1>
            <p>
              The following are keywords to be used by search engines and document
              catalogues.
            </p>
            <p>ABC, DEF</p>
          </div>
          <p class='zzSTDTitle1'/>
        </div>
      </body>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(
             IsoDoc::Ogc::HtmlConvert.new({})
             .convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to xmlpp(output)
  end

  it "processes submitting organisations with no preface" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
       <bibdata>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>OGC</name>
                 </organization>
               </contributor>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>DEF</name>
                 </organization>
               </contributor>
            </bibdata>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type="presentation">
          <bibdata>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>OGC</name>
                 </organization>
               </contributor>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>DEF</name>
                 </organization>
               </contributor>
            </bibdata>
            <preface>
        <clause id='_' type='submitting_orgs' displayorder="1">
          <title depth='1'>I.<tab/>Submitting Organizations</title>
          <p>The following organizations submitted this Document to the Open
            Geospatial Consortium (OGC):</p>
          <ul>
            <li>OGC</li>
            <li>DEF</li>
          </ul>
        </clause>
            </preface>
      <sections/>
      </ogc-standard>
    OUTPUT

    output = <<~"OUTPUT"
              #{HTML_HDR}
              <div class="Section3" id="_">
              <h1 class="IntroTitle">I.&#160; Submitting Organizations</h1>
              <p>The following organizations submitted this Document to the Open
      Geospatial Consortium (OGC):</p>
      <ul>
        <li>OGC</li>
        <li>DEF</li>
      </ul>
            </div>
            <p class="zzSTDTitle1"/>
          </div>
        </body>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes submitting organisations with preface" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
       <bibdata>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>OGC</name>
                 </organization>
               </contributor>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>DEF</name>
                 </organization>
               </contributor>
            </bibdata>
      <preface>
      <abstract id="A"/>
      <clause type="security" id="B"/>
      </preface>
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type="presentation">
          <bibdata>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>OGC</name>
                 </organization>
               </contributor>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>DEF</name>
                 </organization>
               </contributor>
            </bibdata>
            <preface>
                 <abstract id='A' displayorder="1">
                   <title>I.</title>
                 </abstract>
                 <clause type='security' id='B' displayorder="2">
        <title>II.</title>
      </clause>
                 <clause id='_' type='submitting_orgs' displayorder="3">
                   <title depth='1'>
                     III.
                     <tab/>
                     Submitting Organizations
                   </title>
                   <p>The following organizations submitted this Document to the Open
      Geospatial Consortium (OGC):</p>
                   <ul>
                     <li>OGC</li>
                     <li>DEF</li>
                   </ul>
                 </clause>
               </preface>
      <sections/>
      </ogc-standard>
    OUTPUT

    output = <<~OUTPUT
          <body lang='EN-US' xml:lang='EN-US' link='blue' vlink='#954F72' class='container'>
        <div class='title-section'>
          <p>&#160;</p>
        </div>
        <br/>
        <div class='prefatory-section'>
          <p>&#160;</p>
        </div>
        <br/>
        <div class='main-section'>
          <br/>
          <div id='A'>
            <h1 class='AbstractTitle'>I.</h1>
          </div>
          <div class='Section3' id='B'>
        <h1 class='IntroTitle'>II.</h1>
      </div>
          <div class='Section3' id='_'>
            <h1 class='IntroTitle'> III. &#160; Submitting Organizations </h1>
            <p>
              The following organizations submitted this Document to the Open
              Geospatial Consortium (OGC):
            </p>
            <ul>
              <li>OGC</li>
              <li>DEF</li>
            </ul>
          </div>
          <p class='zzSTDTitle1'/>
        </div>
      </body>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes keyword and abstract in HTML head" do
    presxml = <<~OUTPUT
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type="presentation">
               <bibdata>
                 <keyword>ABC</keyword>
                 <keyword>DEF</keyword>
                 <abstract><p>This is a description.</p>
              <quote>This is a <em>blockquote</em> within a description.</quote>
                 </abstract>
               </bibdata>
               <preface>
               <abstract id='A' displayorder="1">
        <title>I.</title>
      </abstract>
                 <clause id="_" type='keywords' displayorder="2">
                   <title depth='1'>II.<tab/>Keywords</title>
                   <p>The following are keywords to be used by search engines and document catalogues.</p>
                   <p>ABC, DEF</p>
                 </clause>
               </preface>
               <sections/>
             </ogc-standard>
    OUTPUT

    output = <<~OUTPUT
      <meta name="keywords" content="ABC, DEF"/>
      <meta name="description" content="This is a description. This is a blockquote within a description."/>
    OUTPUT

    FileUtils.rm_f("test.html")
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    doc = Nokogiri::XML(File.read("test.html"))
    out = doc.xpath("//head/meta[@name = 'keywords' or @name = 'description']")
    expect(xmlpp(out.to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "processes simple terms & definitions" do
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <sections>
        <terms id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title>
          <term id="J">
          <preferred>Term2</preferred>
          <admitted>Term2A</admitted>
          <admitted>Term2B</admitted>
          <deprecates>Term2C</deprecates>
          <deprecates>Term2D</deprecates>
          <termsource status="modified">
        <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011"><locality type="clause"><referenceFrom>3.1</referenceFrom></locality></origin>
          <modification>
          <p id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
        </modification>
      </termsource>
        </term>
         </terms>
         </sections>
         </ogc-standard>
    INPUT

    presxml = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document" type='presentation'>
        <sections>
        <terms id="H" obligation="normative" displayorder='1'><title depth='1'>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
          <term id="J">
          <name>1.1.</name>
          <preferred>Term2</preferred>
          <admitted>Term2A&#xa0;<span class="AdmittedLabel">ADMITTED</span></admitted>
          <admitted>Term2B&#xa0;<span class="AdmittedLabel">ADMITTED</span></admitted>
          <deprecates>Term2C&#xa0;<span class="AdmittedLabel">DEPRECATED</span></deprecates>
          <deprecates>Term2D&#xa0;<span class="AdmittedLabel">DEPRECATED</span></deprecates>
          <termsource status='modified'>[<strong>SOURCE:</strong>
                 <origin bibitemid='ISO7301' type='inline' citeas='ISO 7301:2011'>
                   <locality type='clause'>
                     <referenceFrom>3.1</referenceFrom>
                   </locality>
                   ISO&#xa0;7301:2011, Clause 3.1
                 </origin>, modified &#x2013; The term "cargo rice" is shown as deprecated, and
                 Note 1 to entry is not included here]
               </termsource>
        </term>
         </terms>
         </sections>
         </ogc-standard>
    INPUT

    output = xmlpp(<<~OUTPUT)
      <div id='H'>
         <h1 id='_'>1.&#xA0; Terms, Definitions, Symbols and Abbreviated Terms</h1>
         <h2 class='TermNum' style='text-align:left;' id='J'>1.1.&#xA0;Term2</h2>
         <p class='AltTerms' style="text-align:left;">
           Term2A&#xA0;
           <span class='AdmittedLabel'>ADMITTED</span>
         </p>
         <p class='AltTerms' style="text-align:left;">
           Term2B&#xA0;
           <span class='AdmittedLabel'>ADMITTED</span>
         </p>
         <p class='DeprecatedTerms' style="text-align:left;">
           Term2C&#xA0;
           <span class='AdmittedLabel'>DEPRECATED</span>
         </p>
         <p class='DeprecatedTerms' style="text-align:left;">
           Term2D&#xA0;
           <span class='AdmittedLabel'>DEPRECATED</span>
         </p>
         <p>
           [
           <b>SOURCE:</b>
           ISO&#xa0;7301:2011, Clause 3.1
           , modified &#x2013; The term "cargo rice" is shown as deprecated, and Note 1
           to entry is not included here]
         </p>
       </div>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
     .convert("test", input, true)
     .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    expect(xmlpp(strip_guid(
                   File.read("test.html")
                .gsub(%r{^.*<div id="H">}m, '<div id="H">')
                .gsub(%r{</div>.*}m, "</div>"),
                 ))).to be_equivalent_to output
  end

  it "processes admonitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A"><title>Preface</title>
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="caution">
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
           <preface>
             <foreword id='A' displayorder="1">
               <title depth='1'>I.<tab/>Preface</title>
               <admonition id='_70234f78-64e5-4dfc-8b6f-f3f037348b6a' type='caution'>
               <name>CAUTION</name>
                 <p id='_e94663cc-2473-4ccc-9a72-983a74d989f2'>Only use paddy or parboiled rice for the determination of husked rice yield.</p>
               </admonition>
             </foreword>
           </preface>
         </iso-standard>
    OUTPUT

    html = <<~OUTPUT
       #{HTML_HDR}
              <br/>
              <div id="A">
                <h1 class="ForewordTitle">I.&#160; Preface</h1>
                <div  id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">CAUTION</p>
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </div>
              </div>
              <p class="zzSTDTitle1"/>
            </div>
          </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end

  it "processes warning admonitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A"><title>Preface</title>
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="warning">
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
           <preface>
             <foreword id='A' displayorder="1">
               <title depth='1'>I.<tab/>Preface</title>
               <admonition id='_70234f78-64e5-4dfc-8b6f-f3f037348b6a' type='warning'>
               <name>WARNING</name>
                 <p id='_e94663cc-2473-4ccc-9a72-983a74d989f2'>Only use paddy or parboiled rice for the determination of husked rice yield.</p>
               </admonition>
             </foreword>
           </preface>
         </iso-standard>
    OUTPUT

    html = <<~OUTPUT
       #{HTML_HDR}
              <br/>
              <div id="A">
                <h1 class="ForewordTitle">I.&#160; Preface</h1>
                <div id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" class="Admonition.Warning"><p class="AdmonitionTitle" style="text-align:center;">WARNING</p>
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </div>
              </div>
              <p class="zzSTDTitle1"/>
            </div>
          </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end

  it "processes important admonitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A"><title>Preface</title>
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="important">
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
           <preface>
             <foreword id='A' displayorder="1">
               <title depth='1'>I.<tab/>Preface</title>
               <admonition id='_70234f78-64e5-4dfc-8b6f-f3f037348b6a' type='important'>
               <name>IMPORTANT</name>
                 <p id='_e94663cc-2473-4ccc-9a72-983a74d989f2'>Only use paddy or parboiled rice for the determination of husked rice yield.</p>
               </admonition>
             </foreword>
           </preface>
         </iso-standard>
    OUTPUT

    html = <<~OUTPUT
       #{HTML_HDR}
              <br/>
              <div id="A">
                <h1 class="ForewordTitle">I.&#160; Preface</h1>
                <div  id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" class="Admonition.Important"><p class="AdmonitionTitle" style="text-align:center;">IMPORTANT</p>
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </div>
              </div>
              <p class="zzSTDTitle1"/>
            </div>
          </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end

  it "processes examples with titles" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A"><title>Preface</title>
                <example id="_"><name>Example Title</name><p id="_">This is an example</p>
      <p id="_">Amen</p></example>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <preface>
          <foreword id='A' displayorder="1"><title depth='1'>I.<tab/>Preface</title>
            <example id='_'>
              <name>Example&#xA0;&#x2014; Example Title</name>
              <p id='_'>This is an example</p>
              <p id='_'>Amen</p>
            </example>
          </foreword>
        </preface>
      </iso-standard>
    OUTPUT

    html = <<~OUTPUT
              #{HTML_HDR}
              <br/>
            <div id="A">
              <h1 class="ForewordTitle">I.&#160; Preface</h1>
              <p class='SourceTitle' style='text-align:center;'>Example&#160;&#8212; Example Title</p>
              <div id="_" class="example">
      <p id="_">This is an example</p>
      <p id="_">Amen</p></div>
            </div>
            <p class="zzSTDTitle1"/>
          </div>
        </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end

  it "processes examples without titles" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A">
                <example id="_"><p id="_">This is an example</p>
      <p id="_">Amen</p></example>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
        <preface>
          <foreword id='A' displayorder="1"><title>I.</title>
            <example id='_'>
              <name>Example </name>
              <p id='_'>This is an example</p>
              <p id='_'>Amen</p>
            </example>
          </foreword>
        </preface>
      </iso-standard>
    OUTPUT

    html = <<~OUTPUT
              #{HTML_HDR}
              <br/>
            <div id="A">
              <h1 class="ForewordTitle">I.</h1>
              <p class='SourceTitle' style='text-align:center;'>Example </p>
              <div id="_" class="example">
      <p id="_">This is an example</p>
      <p id="_">Amen</p></div>
            </div>
            <p class="zzSTDTitle1"/>
          </div>
        </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end

  it "processes section names" do
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <bibdata>
        <keyword>A</keyword>
        <keyword>B</keyword>
                       <contributor>
                 <role type="author"/>
                 <organization>
                   <name>OGC</name>
                 </organization>
               </contributor>
               <contributor>
                 <role type="author"/>
                 <organization>
                   <name>DEF</name>
                 </organization>
               </contributor>
        </bibdata>
        <preface>
         <abstract obligation="informative" id="1"><title>Abstract</title>
         <p>XYZ</p>
         </abstract>
        <foreword obligation="informative" id="2"><title>Preface</title>
           <p id="A">This is a preamble</p>
         </foreword>
         <clause id="DD0" obligation="normative" type="executivesummary">
           <title>Executive Summary</title>
           <p id="EE0">Text</p>
         </clause>
         <clause id="DD1" obligation="normative" type="security">
           <title>Security</title>
           <p id="EE1">Text</p>
         </clause>
         <submitters obligation="informative" id="3">
         <title>Submitters</title>
         <p>ABC</p>
         </submitters>
         <clause id="5"><title>Dedication</title>
         <clause id="6"><title>Note to readers</title></clause>
          </clause>
         <acknowledgements obligation="informative" id="4">
         <title>Acknowlegements</title>
         <p>ABC</p>
         </acknowledgements>
          </preface><sections>
         <clause id="D" obligation="normative" type="scope">
           <title>Scope</title>
           <p id="E">Text</p>
         </clause>
         <clause id="D1" obligation="normative" type="conformance">
           <title>Conformance</title>
           <p id="E1">Text</p>
         </clause>

         <clause id="H" obligation="normative"><title>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
           <title>Normal Terms</title>
           <term id="J">
           <preferred>Term2</preferred>
         </term>
         </terms>
         <definitions id="K"><title>Definitions</title>
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         </clause>
         <definitions id="L"><title>Definitions</title>
           <dl>
           <dt>Symbol</dt>
           <dd>Definition</dd>
           </dl>
         </definitions>
         <clause id="M" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
           <title>Introduction</title>
         </clause>
         <clause id="O" inline-header="false" obligation="normative">
           <title>Clause 4.2</title>
         </clause></clause>

         </sections><annex id="P" inline-header="false" obligation="normative">
           <title>Annex</title>
           <clause id="Q" inline-header="false" obligation="normative">
           <title>Annex A.1</title>
           <clause id="Q1" inline-header="false" obligation="normative">
           <title>Annex A.1a</title>
           </clause>
         </clause>
         </annex>
         <annex id='PP' obligation='normative'>
        <title>Glossary</title>
        <terms id='PP1' obligation='normative'><title>Title</title>
          <term id='term-glossary'>
            <preferred>Glossary</preferred>
          </term>
        </terms>
      </annex>
      <annex id='QQ' obligation='normative'>
                 <title>Glossary</title>
                   <terms id='QQ1' obligation='normative'>
                     <title>Term Collection</title>
                     <term id='term-term-1'>
                       <preferred>Term</preferred>
                     </term>
                   </terms>
                   <terms id='QQ2' obligation='normative'>
                     <title>Term Collection 2</title>
                     <term id='term-term-2'>
                       <preferred>Term</preferred>
                     </term>
                   </terms>
               </annex>
          <bibliography><references id="R" obligation="informative" normative="true">
           <title>Normative References</title>
         </references><clause id="S" obligation="informative">
           <title>Bibliography</title>
           <references id="T" obligation="informative" normative="false">
           <title>Bibliography Subsection</title>
         </references>
         </clause>
         </bibliography>
         </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
         <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <bibdata>
           <keyword>A</keyword>
           <keyword>B</keyword>
              <contributor>
        <role type='author'/>
        <organization>
          <name>OGC</name>
        </organization>
      </contributor>
      <contributor>
        <role type='author'/>
        <organization>
          <name>DEF</name>
        </organization>
      </contributor>
           </bibdata>
           <preface>
            <abstract obligation="informative" id="1" displayorder="1"><title depth="1">I.<tab/>Abstract</title>
            <p>XYZ</p>
            </abstract><clause id="DD0" obligation="normative" type="executivesummary" displayorder="2">
              <title depth="1">II.<tab/>Executive Summary</title>
              <p id="EE0">Text</p>
            </clause><clause id="_" type="keywords" displayorder="3">
         <title depth="1">III.<tab/>Keywords</title>
         <p>The following are keywords to be used by search engines and
             document catalogues.</p>
         <p>A, B</p></clause>
           <foreword obligation="informative" id="2" displayorder="4"><title depth="1">IV.<tab/>Preface</title>
              <p id="A">This is a preamble</p>
            </foreword><clause id="DD1" obligation="normative" type="security" displayorder="5">
              <title depth="1">V.<tab/>Security</title>
              <p id="EE1">Text</p>
            </clause>
            <clause id="_" type="submitting_orgs" displayorder="6">
             <title depth="1">VI.<tab/>Submitting Organizations</title>
             <p>The following organizations submitted this Document to the
                Open Geospatial Consortium (OGC):</p>
                <ul> <li>OGC</li> <li>DEF</li> </ul>
                </clause>
            <submitters obligation="informative" id="3" displayorder="7">
            <title depth="1">VII.<tab/>Submitters</title>
            <p>ABC</p>
            </submitters>
            <clause id="5" displayorder="8"><title depth="1">VIII.<tab/>Dedication</title>
            <clause id="6"><title depth="2">VIII.A.<tab/>Note to readers</title></clause>
             </clause>
            <acknowledgements obligation="informative" id="4" displayorder="9">
            <title depth="1">IX.<tab/>Acknowlegements</title>
            <p>ABC</p>
            </acknowledgements>
             </preface><sections>
            <clause id="D" obligation="normative" type="scope" displayorder="10">
              <title depth="1">1.<tab/>Scope</title>
              <p id="E">Text</p>
            </clause>
            <clause id="D1" obligation="normative" type="conformance" displayorder="11">
              <title depth="1">2.<tab/>Conformance</title>
              <p id="E1">Text</p>
            </clause>
            <clause id="H" obligation="normative" displayorder="13"><title depth="1">4.<tab/>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
              <title depth="2">4.1.<tab/>Normal Terms</title>
              <term id="J"><name>4.1.1.</name>
              <preferred>Term2</preferred>
            </term>
            </terms>
            <definitions id="K"><title depth="2">4.2.<tab/>Definitions</title>
              <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
              </dl>
            </definitions>
            </clause>
            <definitions id="L" displayorder="14"><title depth="1">5.<tab/>Definitions</title>
              <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
              </dl>
            </definitions>
            <clause id="M" inline-header="false" obligation="normative" displayorder="15"><title depth="1">6.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
              <title depth="2">6.1.<tab/>Introduction</title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">6.2.<tab/>Clause 4.2</title>
            </clause></clause>
            </sections><annex id="P" inline-header="false" obligation="normative" displayorder="16">
              <title><strong>Annex A</strong><br/>(normative)<br/><strong>Annex</strong></title>
              <clause id="Q" inline-header="false" obligation="normative">
              <title depth="2">A.1.<tab/>Annex A.1</title>
              <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">A.1.1.<tab/>Annex A.1a</title>
              </clause>
            </clause>
            </annex>
            <annex id="PP" obligation="normative" displayorder="17">
           <title><strong>Annex B</strong><br/>(normative)<br/><strong>Glossary</strong></title>
           <terms id="PP1" obligation="normative">
             <term id="term-glossary"><name>B.1.</name>
               <preferred>Glossary</preferred>
             </term>
           </terms>
         </annex>
         <annex id="QQ" obligation="normative" displayorder="18">
                    <title><strong>Annex C</strong><br/>(normative)<br/><strong>Glossary</strong></title>
                      <terms id="QQ1" obligation="normative">
                        <title depth="2">C.1.<tab/>Term Collection</title>
                        <term id="term-term-1"><name>C.1.1.</name>
                          <preferred>Term</preferred>
                        </term>
                      </terms>
                      <terms id="QQ2" obligation="normative">
                        <title depth="2">C.2.<tab/>Term Collection 2</title>
                        <term id="term-term-2"><name>C.2.1.</name>
                          <preferred>Term</preferred>
                        </term>
                      </terms>
                  </annex>
             <bibliography><references id="R" obligation="informative" normative="true" displayorder="12">
              <title depth="1">3.<tab/>Normative References</title>
            </references><clause id="S" obligation="informative" displayorder="19">
              <title depth="1">Bibliography</title>
              <references id="T" obligation="informative" normative="false">
              <title depth="2">Bibliography Subsection</title>
            </references>
            </clause>
            </bibliography>
            </ogc-standard>
    OUTPUT

    output = xmlpp(<<~"OUTPUT")
             #{HTML_HDR}
          <br/>
          <div id='1'>
            <h1 class='AbstractTitle'>I.&#160; Abstract</h1>
            <p>XYZ</p>
          </div>
          <div class='Section3' id='DD0'>
            <h1 class='IntroTitle'>II.&#160; Executive Summary</h1>
            <p id='EE0'>Text</p>
          </div>
          <div class='Section3' id='_'>
            <h1 class='IntroTitle'>III.&#160; Keywords</h1>
            <p>
              The following are keywords to be used by search engines and document
              catalogues.
            </p>
            <p>A, B</p>
          </div>
          <br/>
          <div id='2'>
            <h1 class='ForewordTitle'>IV.&#160; Preface</h1>
            <p id='A'>This is a preamble</p>
          </div>
          <div class='Section3' id='DD1'>
            <h1 class='IntroTitle'>V.&#160; Security</h1>
            <p id='EE1'>Text</p>
          </div>
          <div class='Section3' id='_'>
            <h1 class='IntroTitle'>VI.&#160; Submitting Organizations</h1>
            <p>
              The following organizations submitted this Document to the Open
              Geospatial Consortium (OGC):
            </p>
            <ul> <li>OGC</li> <li>DEF</li> </ul>
          </div>
          <div class='Section3' id='3'>
            <h1 class='IntroTitle'>VII.&#160; Submitters</h1>
            <p>ABC</p>
          </div>
          <div class='Section3' id='5'>
            <h1 class='IntroTitle'>VIII.&#160; Dedication</h1>
            <div id='6'>
              <h2>VIII.A.&#160; Note to readers</h2>
            </div>
          </div>
          <div class='Section3' id='4'>
            <h1 class='IntroTitle'>IX.&#160; Acknowlegements</h1>
            <p>ABC</p>
          </div>
          <p class='zzSTDTitle1'/>
          <div id='D'>
            <h1>1.&#160; Scope</h1>
            <p id='E'>Text</p>
          </div>
          <div id='D1'>
            <h1>2.&#160; Conformance</h1>
            <p id='E1'>Text</p>
          </div>
          <div>
            <h1>3.&#160; Normative References</h1>
          </div>
          <div id='H'>
            <h1>4.&#160; Terms, definitions, symbols and abbreviated terms</h1>
            <div id='I'>
              <h2>4.1.&#160; Normal Terms</h2>
              <p class='TermNum' id='J'>4.1.1.</p>
              <p class='Terms' style='text-align:left;'>Term2</p>
            </div>
            <div id='K'>
              <h2>4.2.&#160; Definitions</h2>
              <dl>
                <dt>
                  <p>Symbol</p>
                </dt>
                <dd>Definition</dd>
              </dl>
            </div>
          </div>
          <div id='L' class='Symbols'>
            <h1>5.&#160; Definitions</h1>
            <dl>
              <dt>
                <p>Symbol</p>
              </dt>
              <dd>Definition</dd>
            </dl>
          </div>
          <div id='M'>
            <h1>6.&#160; Clause 4</h1>
            <div id='N'>
              <h2>6.1.&#160; Introduction</h2>
            </div>
            <div id='O'>
              <h2>6.2.&#160; Clause 4.2</h2>
            </div>
          </div>
          <br/>
          <div id='P' class='Section3'>
            <h1 class='Annex'>
              <b>Annex A</b>
              <br/>
              (normative)
              <br/>
              <b>Annex</b>
            </h1>
            <div id='Q'>
              <h2>A.1.&#160; Annex A.1</h2>
              <div id='Q1'>
                <h3>A.1.1.&#160; Annex A.1a</h3>
              </div>
            </div>
          </div>
          <br/>
          <div id='PP' class='Section3'>
            <h1 class='Annex'>
              <b>Annex B</b>
              <br/>
              (normative)
              <br/>
              <b>Glossary</b>
            </h1>
            <div id='PP1'>
              <p class='TermNum' id='term-glossary'>B.1.</p>
              <p class='Terms' style='text-align:left;'>Glossary</p>
            </div>
          </div>
          <br/>
          <div id='QQ' class='Section3'>
            <h1 class='Annex'>
              <b>Annex C</b>
              <br/>
              (normative)
              <br/>
              <b>Glossary</b>
            </h1>
            <div id='QQ1'>
              <h2>C.1.&#160; Term Collection</h2>
              <p class='TermNum' id='term-term-1'>C.1.1.</p>
              <p class='Terms' style='text-align:left;'>Term</p>
            </div>
            <div id='QQ2'>
              <h2>C.2.&#160; Term Collection 2</h2>
              <p class='TermNum' id='term-term-2'>C.2.1.</p>
              <p class='Terms' style='text-align:left;'>Term</p>
            </div>
          </div>
          <br/>
          <div>
            <h1 class='Section3'>Bibliography</h1>
            <div>
              <h2 class='Section3'>Bibliography Subsection</h2>
            </div>
          </div>
        </div>
      </body>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, "")
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(
             IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to output
  end

  it "processes hi" do
    presxml = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface><foreword id="A"><title>Preface</title>
      <p id="_">Amen <hi>highlight</hi> Amen</p>
          </foreword></preface>
          </iso-standard>
    INPUT

    html = <<~OUTPUT
              #{HTML_HDR}
              <br/>
            <div id="A">
            <h1 class='ForewordTitle'>Preface</h1>
      <p id='_'>
        Amen
        <span class='hi'>highlight</span>
         Amen
      </p>
            </div>
            <p class="zzSTDTitle1"/>
          </div>
        </body>
    OUTPUT

    doc = <<~OUTPUT
      <body lang='EN-US' link='blue' vlink='#954F72'>
           <div class='WordSection1'>
             <p>&#160;</p>
           </div>
           <p>
             <br clear='all' class='section'/>
           </p>
           <div class='WordSection2'>
             <p>
               <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
             </p>
             <div id='A'>
               <h1 class='ForewordTitle'>Preface</h1>
               <p id='_'>
                 Amen
                 <span class='hi'>highlight</span>
                  Amen
               </p>
             </div>
             <p>&#160;</p>
           </div>
           <p>
             <br clear='all' class='section'/>
           </p>
           <div class='WordSection3'>
             <p class='zzSTDTitle1'/>
           </div>
         </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
    expect(xmlpp(IsoDoc::Ogc::WordConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(doc)
  end

  it "injects JS into blank html" do
    system "rm -f test.html"
    input = <<~INPUT
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT
    output = xmlpp(<<~"OUTPUT")
          #{BLANK_HDR}
          <preface>#{SECURITY}</preface>
      <sections/>
      </ogc-standard>
    OUTPUT
    expect(xmlpp(strip_guid(Asciidoctor
      .convert(input, backend: :ogc, header_footer: true))))
      .to be_equivalent_to xmlpp(output)
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Overpass})
  end
end
