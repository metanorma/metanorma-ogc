require "spec_helper"

RSpec.describe IsoDoc::Ogc do

  it "processes default metadata" do
    csdc = IsoDoc::Ogc::HtmlConvert.new({})
    input = <<~"INPUT"
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
         <docsubtype>conceptual-model-and-encoding</docsubtype>
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
{:accesseddate=>"XXX",
:agency=>"OGC",
:authors=>["Barney Rubble"],
:circulateddate=>"XXX",
:confirmeddate=>"XXX",
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
:obsoleteddate=>"XXX",
:pdf=>"http://www.example.com/pdf",
:publisheddate=>"2002-01-01",
:publisher=>"OGC",
:receiveddate=>"XXX",
:revdate=>"2000-01-01",
:revdate_monthyear=>"January 2000",
:stage=>"SWG Work",
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

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s).gsub(/, :/, ",\n:")).to be_equivalent_to output
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
      IsoDoc::Ogc::HtmlConvert.new({}).
      convert("test", input, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
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
    <ogc-standard xmlns='https://standards.opengeospatial.org/document'>
         <bibdata>
           <keyword>ABC</keyword>
           <keyword>DEF</keyword>
         </bibdata>
         <preface>
           <clause id="_" type='keyword'>
             <title depth='1'>i.<tab/>Keywords</title>
             <p>The following are keywords to be used by search engines and document catalogues.</p>
             <p>ABC, DEF</p>
           </clause>
         </preface>
         <sections/>
       </ogc-standard>
       OUTPUT

    output = (<<~"OUTPUT")
        #{HTML_HDR}
        <div class="Section3" id="_">
        <h1 class="IntroTitle">i.&#160; Keywords</h1>
        <p>The following are keywords to be used by search engines and document catalogues.</p>
        <p>ABC, DEF</p>
      </div>
      <p class="zzSTDTitle1"/>
    </div>
  </body>
    OUTPUT

      expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(
      IsoDoc::Ogc::HtmlConvert.new({}).
      convert("test", presxml, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
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
    <ogc-standard xmlns='https://standards.opengeospatial.org/document'>
         <bibdata>
           <keyword>ABC</keyword>
           <keyword>DEF</keyword>
         </bibdata>
         <preface>
         <abstract id='A'>
  <title>i.</title>
</abstract>
           <clause id="_" type='keyword'>
             <title depth='1'>ii.<tab/>Keywords</title>
             <p>The following are keywords to be used by search engines and document catalogues.</p>
             <p>ABC, DEF</p>
           </clause>
         </preface>
         <sections/>
       </ogc-standard>
       OUTPUT

    output = (<<~"OUTPUT")
        #{HTML_HDR}
           <br/>
           <div id='A'>
             <h1 class='AbstractTitle'>i.</h1>
           </div>
           <div class='Section3' id='_'>
             <h1 class='IntroTitle'>ii.&#160; Keywords</h1>
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

      expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(
      IsoDoc::Ogc::HtmlConvert.new({}).
      convert("test", presxml, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
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
    <ogc-standard xmlns='https://standards.opengeospatial.org/document'>
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
  <clause id='_' type='submitting_orgs'>
    <title depth='1'>i.<tab/>Submitting Organizations</title>
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

    output = (<<~"OUTPUT")
        #{HTML_HDR}
        <div class="Section3" id="_">
        <h1 class="IntroTitle">i.&#160; Submitting Organizations</h1>
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

      expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(output)
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
</preface>
<sections/>
</ogc-standard>
    INPUT

    presxml = <<~OUTPUT
    <ogc-standard xmlns='https://standards.opengeospatial.org/document'>
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
           <abstract id='A'>
             <title>i.</title>
           </abstract>
           <clause id='_' type='submitting_orgs'>
             <title depth='1'>
               ii.
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

    output = (<<~"OUTPUT")
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
      <h1 class='AbstractTitle'>i.</h1>
    </div>
    <div class='Section3' id='_'>
      <h1 class='IntroTitle'> ii. &#160; Submitting Organizations </h1>
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

      expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true)))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(output)
  end


  it "processes simple terms & definitions" do
    input = <<~"INPUT"
     <ogc-standard xmlns="https://standards.opengeospatial.org/document">
       <sections>
       <terms id="H" obligation="normative"><title>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
         <term id="J">
         <name>1.1.</name>
         <preferred>Term2</preferred>
       </term>
        </terms>
        </sections>
        </ogc-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
             <p class="zzSTDTitle1"/>
             <div id="H"><h1>1.&#160; Terms, Definitions, Symbols and Abbreviated Terms</h1>
       <p class="TermNum" id="J">1.1.</p>
         <p class="Terms" style="text-align:left;">Term2</p>
       </div>
           </div>
         </body>
    OUTPUT

    expect(xmlpp(
      IsoDoc::Ogc::HtmlConvert.new({}).
      convert("test", input, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
    )).to be_equivalent_to output
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
    <iso-standard xmlns='http://riboseinc.com/isoxml'>
         <preface>
           <foreword id='A'>
             <title depth='1'>i.<tab/>Preface</title>
             <admonition id='_70234f78-64e5-4dfc-8b6f-f3f037348b6a' type='caution'>
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
                 <h1 class="ForewordTitle">i.&#160; Preface</h1>
                 <div  id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">CAUTION</p>
         <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </div>
               </div>
               <p class="zzSTDTitle1"/>
             </div>
           </body>
    OUTPUT
      expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
      expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
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
    <iso-standard xmlns='http://riboseinc.com/isoxml'>
         <preface>
           <foreword id='A'>
             <title depth='1'>i.<tab/>Preface</title>
             <admonition id='_70234f78-64e5-4dfc-8b6f-f3f037348b6a' type='warning'>
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
                 <h1 class="ForewordTitle">i.&#160; Preface</h1>
                 <div id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" class="Admonition.Warning"><p class="AdmonitionTitle" style="text-align:center;">WARNING</p>
         <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </div>
               </div>
               <p class="zzSTDTitle1"/>
             </div>
           </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
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
    <iso-standard xmlns='http://riboseinc.com/isoxml'>
         <preface>
           <foreword id='A'>
             <title depth='1'>i.<tab/>Preface</title>
             <admonition id='_70234f78-64e5-4dfc-8b6f-f3f037348b6a' type='important'>
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
                 <h1 class="ForewordTitle">i.&#160; Preface</h1>
                 <div  id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" class="Admonition.Important"><p class="AdmonitionTitle" style="text-align:center;">IMPORTANT</p>
         <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </div>
               </div>
               <p class="zzSTDTitle1"/>
             </div>
           </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
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
<iso-standard xmlns='http://riboseinc.com/isoxml'>
  <preface>
    <foreword id='A'><title depth='1'>i.<tab/>Preface</title>

      <example id='_'>
        <name>Example &#xA0;&#x2014; Example Title</name>
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
        <h1 class="ForewordTitle">i.&#160; Preface</h1>
        <p class='SourceTitle' style='text-align:center;'>Example &#160;&#8212; Example Title</p>
        <div id="_" class="example">
<p id="_">This is an example</p>
<p id="_">Amen</p></div>
      </div>
      <p class="zzSTDTitle1"/>
    </div>
  </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
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
<iso-standard xmlns='http://riboseinc.com/isoxml'>
  <preface>
    <foreword id='A'><title>i.</title>
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
        <h1 class="ForewordTitle">i.</h1>
        <p class='SourceTitle' style='text-align:center;'>Example </p>
        <div id="_" class="example">
<p id="_">This is an example</p>
<p id="_">Amen</p></div>
      </div>
      <p class="zzSTDTitle1"/>
    </div>
  </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
  end


  it "processes section names" do
    input = <<~"INPUT"
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <preface>
       <abstract obligation="informative" id="1"><title>Abstract</title>
       <p>XYZ</p>
       </abstract>
      <foreword obligation="informative" id="2"><title>Preface</title>
         <p id="A">This is a preamble</p>
       </foreword>
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
       <definitions id="K">
         <dl>
         <dt>Symbol</dt>
         <dd>Definition</dd>
         </dl>
       </definitions>
       </clause>
       <definitions id="L">
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
       </annex><bibliography><references id="R" obligation="informative" normative="true">
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
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
         <preface>
          <abstract obligation="informative" id="1"><title depth="1">i.<tab/>Abstract</title>
          <p>XYZ</p>
          </abstract>
         <foreword obligation="informative" id="2"><title depth="1">ii.<tab/>Preface</title>
            <p id="A">This is a preamble</p>
          </foreword>
          <submitters obligation="informative" id="3">
          <title depth="1">iii.<tab/>Submitters</title>
          <p>ABC</p>
          </submitters>
          <clause id="5"><title depth="1">iv.<tab/>Dedication</title>
          <clause id="6"><title depth="2">iv.1.<tab/>Note to readers</title></clause>
           </clause>
          <acknowledgements obligation="informative" id="4">
          <title depth='1'>v.<tab/>Acknowlegements</title>
          <p>ABC</p>
          </acknowledgements>
           </preface><sections>
          <clause id="D" obligation="normative" type="scope">
            <title depth="1">1.<tab/>Scope</title>
            <p id="E">Text</p>
          </clause>
          <clause id="D1" obligation="normative" type="conformance">
            <title depth="1">2.<tab/>Conformance</title>
            <p id="E1">Text</p>
          </clause>

          <clause id="H" obligation="normative"><title depth="1">4.<tab/>Terms, definitions, symbols and abbreviated terms</title><terms id="I" obligation="normative">
            <title depth="2">4.1.<tab/>Normal Terms</title>
            <term id="J"><name>4.1.1.</name>
            <preferred>Term2</preferred>
          </term>
          </terms>
          <definitions id="K"><title>4.2.</title>
            <dl>
            <dt>Symbol</dt>
            <dd>Definition</dd>
            </dl>
          </definitions>
          </clause>
          <definitions id="L"><title>5.</title>
            <dl>
            <dt>Symbol</dt>
            <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative"><title depth="1">6.<tab/>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
            <title depth="2">6.1.<tab/>Introduction</title>
          </clause>
          <clause id="O" inline-header="false" obligation="normative">
            <title depth="2">6.2.<tab/>Clause 4.2</title>
          </clause></clause>

          </sections><annex id="P" inline-header="false" obligation="normative">
            <title><strong>Annex A</strong><br/>(normative)<br/><strong>Annex</strong></title>
            <clause id="Q" inline-header="false" obligation="normative">
            <title depth="2">A.1.<tab/>Annex A.1</title>
            <clause id="Q1" inline-header="false" obligation="normative">
            <title depth="3">A.1.1.<tab/>Annex A.1a</title>
            </clause>
          </clause>
          </annex><bibliography><references id="R" obligation="informative" normative="true">
            <title depth="1">3.<tab/>Normative References</title>
          </references><clause id="S" obligation="informative">
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
             <div id="1">
               <h1 class="AbstractTitle">i.&#160; Abstract</h1>
               <p>XYZ</p>
             </div>
             <br/>
             <div id="2">
               <h1 class="ForewordTitle">ii.&#160; Preface</h1>
               <p id="A">This is a preamble</p>
             </div>
             <div class="Section3" id="3">
               <h1 class="IntroTitle">iii.&#160; Submitters</h1>
               <p>ABC</p>
             </div>
             <div class='Section3' id='5'>
  <h1 class='IntroTitle'>iv.&#160; Dedication</h1>
      <div id='6'>
      <h2>iv.1.&#160; Note to readers</h2>
    </div>
</div>
<div class='Section3' id='4'>
  <h1 class='IntroTitle'>v.&#160; Acknowlegements</h1>
  <p>ABC</p>
</div>
             <p class="zzSTDTitle1"/>
             <div id="D">
               <h1>1.&#160; Scope</h1>
               <p id="E">Text</p>
             </div>
             <div id="D1">
                <h1>2.&#160; Conformance</h1>
                <p id="E1">Text</p>
            </div>
             <div>
               <h1>3.&#160; Normative References</h1>
             </div>
             <div id="H"><h1>4.&#160; Terms, definitions, symbols and abbreviated terms</h1>
       <div id="I">
          <h2>4.1.&#160; Normal Terms</h2>
          <p class="TermNum" id="J">4.1.1.</p>
          <p class="Terms" style="text-align:left;">Term2</p>

        </div><div id="K"><h2>4.2.</h2>
          <dl><dt><p>Symbol</p></dt><dd>Definition</dd></dl>
        </div></div>
             <div id="L" class="Symbols">
               <h1>5.</h1>
               <dl>
                 <dt>
                   <p>Symbol</p>
                 </dt>
                 <dd>Definition</dd>
               </dl>
             </div>
             <div id="M">
               <h1>6.&#160; Clause 4</h1>
               <div id="N">
          <h2>6.1.&#160; Introduction</h2>
        </div>
               <div id="O">
          <h2>6.2.&#160; Clause 4.2</h2>
        </div>
             </div>
             <br/>
             <div id="P" class="Section3">
                <h1 class="Annex"><b>Annex A</b><br/>(normative)<br/><b>Annex</b></h1>
               <div id="Q">
          <h2>A.1.&#160; Annex A.1</h2>
          <div id="Q1">
          <h3>A.1.1.&#160; Annex A.1a</h3>
          </div>
        </div>
             </div>
             <br/>
             <div>
               <h1 class="Section3">Bibliography</h1>
               <div>
                 <h2 class="Section3">Bibliography Subsection</h2>
               </div>
             </div>
           </div>
         </body>
    OUTPUT

    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(
      IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).
      gsub(%r{^.*<body}m, "<body").
      gsub(%r{</body>.*}m, "</body>")
    )).to be_equivalent_to output
  end

  it "injects JS into blank html" do
    system "rm -f test.html"
    input = <<~"INPUT"
      = Document title
      Author
      :docfile: test.adoc
      :novalid:
      :no-pdf:
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</ogc-standard>
    OUTPUT

    expect(xmlpp(strip_guid(Asciidoctor.convert(input, backend: :ogc, header_footer: true)))).to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Overpass})
  end

  it "processes permissions" do
    input = <<~INPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A"><title>Preface</title>
    <permission id="A1">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit><eref type="inline" bibitemid="rfc2616" citeas="RFC 2616">RFC 2616 (HTTP/1.1)</eref></inherit>
  <subject>user</subject>
  <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
  <dl>
  <dt>A</dt><dd>B</dd>
  <dt>C</dt><dd>D</dd>
  </dl>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="_">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</permission>
    </foreword></preface>
    <bibliography><references id="_bibliography" obligation="informative" normative="false">
<title>Bibliography</title>
<bibitem id="rfc2616" type="standard"> <fetched>2020-03-27</fetched> <title format="text/plain" language="en" script="Latn">Hypertext Transfer Protocol — HTTP/1.1</title> <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri> <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri> <docidentifier type="IETF">RFC 2616</docidentifier> <docidentifier type="rfc-anchor">RFC2616</docidentifier> <docidentifier type="DOI">10.17487/RFC2616</docidentifier> <date type="published">  <on>1999-06</on> </date> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">R. Fielding</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Gettys</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Mogul</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">H. Frystyk</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">L. Masinter</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">P. Leach</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">T. Berners-Lee</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <language>en</language> <script>Latn</script> <abstract format="text/plain" language="en" script="Latn">HTTP has been in use by the World-Wide Web global information initiative since 1990. This specification defines the protocol referred to as “HTTP/1.1”, and is an update to RFC 2068. [STANDARDS-TRACK]</abstract> <series type="main">  <title format="text/plain" language="en" script="Latn">RFC</title>  <number>2616</number> </series> <place>Fremont, CA</place></bibitem>
</references></bibliography>
    </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
           <preface><foreword id="A"><title depth='1'>i.<tab/>Preface</title>
           <permission id="A1"><name>Permission 1</name>
         <label>/ogc/recommendation/wfs/2</label>
         <inherit>/ss/584/2015/level/1</inherit>
         <inherit><eref type="inline" bibitemid="rfc2616" citeas="RFC 2616">RFC 2616 (HTTP/1.1)</eref></inherit>
         <subject>user</subject>
         <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
         <description>
           <p id="_">I recommend <em>this</em>.</p>
         </description>
         <specification exclude="true" type="tabular">
           <p id="_">This is the object of the recommendation:</p>
           <table id="_">
             <tbody>
               <tr>
                 <td style="text-align:left;">Object</td>
                 <td style="text-align:left;">Value</td>
                 <td style="text-align:left;">Accomplished</td>
               </tr>
             </tbody>
           </table>
         </specification>
         <description>
         <dl>
         <dt>A</dt><dd>B</dd>
         <dt>C</dt><dd>D</dd>
         </dl>
         </description>
         <measurement-target exclude="false">
           <p id="_">The measurement target shall be measured as:</p>
           <formula id="_"><name>1</name>
             <stem type="AsciiMath">r/1 = 0</stem>
           </formula>
         </measurement-target>
         <verification exclude="false">
           <p id="_">The following code will be run for verification:</p>
           <sourcecode id="_">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
         </verification>
         <import exclude="true">
           <sourcecode id="_">success-response()</sourcecode>
         </import>
       </permission>
           </foreword></preface>
           <bibliography><references id="_bibliography" obligation="informative" normative="false">
       <title depth="1">Bibliography</title>
  <bibitem id="rfc2616" type="standard"> <fetched>2020-03-27</fetched> <title format="text/plain" language="en" script="Latn">Hypertext Transfer Protocol&#x2009;&#x2014;&#x2009;HTTP/1.1</title> <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri> <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri> <docidentifier type="IETF">RFC 2616</docidentifier> <docidentifier type="rfc-anchor">RFC2616</docidentifier> <docidentifier type="DOI">10.17487/RFC2616</docidentifier> <date type="published"> <on>1999-06</on> </date> <contributor> <role type="author"/> <person>  <name>  <completename language="en">R. Fielding</completename>  </name>  <affiliation>  <organization>   <name>IETF</name>   <abbreviation>IETF</abbreviation>  </organization>  </affiliation> </person> </contributor> <contributor> <role type="author"/> <person>  <name>  <completename language="en">J. Gettys</completename>  </name>  <affiliation>  <organization>   <name>IETF</name>   <abbreviation>IETF</abbreviation>  </organization>  </affiliation> </person> </contributor> <contributor> <role type="author"/> <person>  <name>  <completename language="en">J. Mogul</completename>  </name>  <affiliation>  <organization>   <name>IETF</name>   <abbreviation>IETF</abbreviation>  </organization>  </affiliation> </person> </contributor> <contributor> <role type="author"/> <person>  <name>  <completename language="en">H. Frystyk</completename>  </name>  <affiliation>  <organization>   <name>IETF</name>   <abbreviation>IETF</abbreviation>  </organization>  </affiliation> </person> </contributor> <contributor> <role type="author"/> <person>  <name>  <completename language="en">L. Masinter</completename>  </name>  <affiliation>  <organization>   <name>IETF</name>   <abbreviation>IETF</abbreviation>  </organization>  </affiliation> </person> </contributor> <contributor> <role type="author"/> <person>  <name>  <completename language="en">P. Leach</completename>  </name>  <affiliation>  <organization>   <name>IETF</name>   <abbreviation>IETF</abbreviation>  </organization>  </affiliation> </person> </contributor> <contributor> <role type="author"/> <person>  <name>  <completename language="en">T. Berners-Lee</completename>  </name>  <affiliation>  <organization>   <name>IETF</name>   <abbreviation>IETF</abbreviation>  </organization>  </affiliation> </person> </contributor> <language>en</language> <script>Latn</script> <abstract format="text/plain" language="en" script="Latn">HTTP has been in use by the World-Wide Web global information initiative since 1990. This specification defines the protocol referred to as &#x201C;HTTP/1.1&#x201D;, and is an update to RFC 2068. [STANDARDS-TRACK]</abstract> <series type="main"> <title format="text/plain" language="en" script="Latn">RFC</title> <number>2616</number> </series> <place>Fremont, CA</place></bibitem>
       </references></bibliography>
       </ogc-standard>
    OUTPUT

    html = <<~OUTPUT
    #{HTML_HDR}
     <br/>
           <div id='A'>
             <h1 class='ForewordTitle'>i.&#160; Preface</h1>
             <table id='A1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>
                     <a href='#rfc2616'>RFC 2616 (HTTP/1.1)</a>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Control-class</td>
                   <td style='vertical-align:top;' class='recommend'>Technical</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Priority</td>
                   <td style='vertical-align:top;' class='recommend'>P0</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p id='_'>
                       I recommend
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p id='_'>The measurement target shall be measured as:</p>
                     <div id='_'>
                       <div class='formula'>
                         <p>
                           <span class='stem'>(#(r/1 = 0)#)</span>
                           &#160; (1)
                         </p>
                       </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p id='_'>The following code will be run for verification:</p>
                     <pre id='_' class='prettyprint '>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; if
                       (success)
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                       recommendation(label: success-response)
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; end
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                     </pre>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='zzSTDTitle1'/>
           <br/>
           <div>
             <h1 class='Section3'>Bibliography</h1>
             <p id='rfc2616' class='Biblio'>
               [1]&#160; IETF RFC 2616,
               <i>Hypertext Transfer Protocol&#8201;&#8212;&#8201;HTTP/1.1</i>
               . Fremont, CA (1999-06).
             </p>
           </div>
         </div>
       </body>
    OUTPUT

    word = <<~OUTPUT
       <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr style='background:#A5A5A5;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>
                     <a href='#rfc2616'>RFC 2616 (HTTP/1.1)</a>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Control-class</td>
                   <td style='vertical-align:top;' class='recommend'>Technical</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Priority</td>
                   <td style='vertical-align:top;' class='recommend'>P0</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       I recommend 
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div>
                       <a name='_' id='_'/>
                       <div class='formula'>
                         <p class='MsoNormal'>
                           <span class='stem'>
                             <m:oMath>
                               <m:f>
                                 <m:fPr>
                                   <m:type m:val='bar'/>
                                 </m:fPr>
                                 <m:num>
                                   <m:r>
                                     <m:t>r</m:t>
                                   </m:r>
                                 </m:num>
                                 <m:den>
                                   <m:r>
                                     <m:t>1</m:t>
                                   </m:r>
                                 </m:den>
                               </m:f>
                               <m:r>
                                 <m:t>=0</m:t>
                               </m:r>
                             </m:oMath>
                           </span>
                           <span style='mso-tab-count:1'>&#xA0; </span>
                           (1)
                         </p>
                       </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The following code will be run for verification:
                     </p>
                     <p class='Sourcecode'>
                       <a name='_' id='_'/>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if
                       (success)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;
                       recommendation(label: success-response)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; 
                     </p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
           <p class='MsoNormal'>
             <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
           </p>
           <div>
             <h1 class='Section3'>Bibliography</h1>
             <p class='Biblio'>
               <a name='rfc2616' id='rfc2616'/>
               [1]
               <span style='mso-tab-count:1'>&#xA0; </span>
               IETF RFC 2616, 
               <i>Hypertext Transfer Protocol&#x2009;&#x2014;&#x2009;HTTP/1.1</i>
               . Fremont, CA (1999-06).
             </p>
           </div>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
    OUTPUT



        expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
         FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
    expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)

  end

    it "processes permission verifications" do
    input = <<~INPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface>
        <foreword id="A"><title>Preface</title>
    <permission id="A1" type="verification">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <subject>user</subject>
  <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
  <dl>
  <dt>A</dt><dd>B</dd>
  <dt>C</dt><dd>D</dd>
  </dl>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="_">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</permission>
    </foreword></preface>
    </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface>
                <foreword id="A"><title depth='1'>i.<tab/>Preface</title>
            <permission id="A1" type="verification"><name>Permission Test 1</name>
          <label>/ogc/recommendation/wfs/2</label>
          <inherit>/ss/584/2015/level/1</inherit>
          <subject>user</subject>
          <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
          <description>
            <p id="_">I recommend <em>this</em>.</p>
          </description>
          <specification exclude="true" type="tabular">
            <p id="_">This is the object of the recommendation:</p>
            <table id="_">
              <tbody>
                <tr>
                  <td style="text-align:left;">Object</td>
                  <td style="text-align:left;">Value</td>
                  <td style="text-align:left;">Accomplished</td>
                </tr>
              </tbody>
            </table>
          </specification>
          <description>
          <dl>
          <dt>A</dt><dd>B</dd>
          <dt>C</dt><dd>D</dd>
          </dl>
          </description>
          <measurement-target exclude="false">
            <p id="_">The measurement target shall be measured as:</p>
            <formula id="_"><name>1</name>
              <stem type="AsciiMath">r/1 = 0</stem>
            </formula>
          </measurement-target>
          <verification exclude="false">
            <p id="_">The following code will be run for verification:</p>
            <sourcecode id="_">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
          </verification>
          <import exclude="true">
            <sourcecode id="_">success-response()</sourcecode>
          </import>
        </permission>
            </foreword></preface>
            </ogc-standard>
OUTPUT

    html = <<~OUTPUT
    #{HTML_HDR}
<br/>
            <div id='A'>
              <h1 class='ForewordTitle'>i.&#160; Preface</h1>
              <table id='A1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                <thead>
                  <tr>
                    <th style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='RecommendationTestTitle'>Permission Test 1:</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p>/ogc/recommendation/wfs/2</p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Subject</td>
                    <td style='vertical-align:top;' class='recommend'>user</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Control-class</td>
                    <td style='vertical-align:top;' class='recommend'>Technical</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Priority</td>
                    <td style='vertical-align:top;' class='recommend'>P0</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Family</td>
                    <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Family</td>
                    <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>
                        I recommend 
                        <i>this</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>A</td>
                    <td style='vertical-align:top;' class='recommend'>B</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>C</td>
                    <td style='vertical-align:top;' class='recommend'>D</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>The measurement target shall be measured as:</p>
                      <div id='_'>
                        <div class='formula'>
                          <p>
                            <span class='stem'>(#(r/1 = 0)#)</span>
                            &#160; (1)
                          </p>
                        </div>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>The following code will be run for verification:</p>
                      <pre id='_' class='prettyprint '>
                        CoreRoot(success): HttpResponse
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; if
                        (success)
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                        recommendation(label: success-response)
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; end
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160; 
                      </pre>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p class='zzSTDTitle1'/>
          </div>
        </body>
OUTPUT

word = <<~OUTPUT
       <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr style='background:#C9C9C9;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Permission Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Control-class</td>
                   <td style='vertical-align:top;' class='recommend'>Technical</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Priority</td>
                   <td style='vertical-align:top;' class='recommend'>P0</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       I recommend 
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div>
                       <a name='_' id='_'/>
                       <div class='formula'>
                         <p class='MsoNormal'>
                           <span class='stem'>
                             <m:oMath>
                               <m:f>
                                 <m:fPr>
                                   <m:type m:val='bar'/>
                                 </m:fPr>
                                 <m:num>
                                   <m:r>
                                     <m:t>r</m:t>
                                   </m:r>
                                 </m:num>
                                 <m:den>
                                   <m:r>
                                     <m:t>1</m:t>
                                   </m:r>
                                 </m:den>
                               </m:f>
                               <m:r>
                                 <m:t>=0</m:t>
                               </m:r>
                             </m:oMath>
                           </span>
                           <span style='mso-tab-count:1'>&#xA0; </span>
                           (1)
                         </p>
                       </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The following code will be run for verification:
                     </p>
                     <p class='Sourcecode'>
                       <a name='_' id='_'/>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if
                       (success)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;
                       recommendation(label: success-response)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; 
                     </p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
OUTPUT

        expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
         FileUtils.rm_f "test.doc"
        IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
         expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)
    end

    it "processes abstract tests" do
    input = <<~INPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface>
        <foreword id="A"><title>Preface</title>
    <permission id="A1" type="abstracttest">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <subject>user</subject>
  <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
  <dl>
  <dt>A</dt><dd>B</dd>
  <dt>C</dt><dd>D</dd>
  </dl>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="_">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</permission>
    </foreword></preface>
    </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface>
                <foreword id="A"><title depth='1'>i.<tab/>Preface</title>
            <permission id="A1" type="abstracttest"><name>Abstract Test 1</name>
          <label>/ogc/recommendation/wfs/2</label>
          <inherit>/ss/584/2015/level/1</inherit>
          <subject>user</subject>
          <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
          <description>
            <p id="_">I recommend <em>this</em>.</p>
          </description>
          <specification exclude="true" type="tabular">
            <p id="_">This is the object of the recommendation:</p>
            <table id="_">
              <tbody>
                <tr>
                  <td style="text-align:left;">Object</td>
                  <td style="text-align:left;">Value</td>
                  <td style="text-align:left;">Accomplished</td>
                </tr>
              </tbody>
            </table>
          </specification>
          <description>
          <dl>
          <dt>A</dt><dd>B</dd>
          <dt>C</dt><dd>D</dd>
          </dl>
          </description>
          <measurement-target exclude="false">
            <p id="_">The measurement target shall be measured as:</p>
            <formula id="_"><name>1</name>
              <stem type="AsciiMath">r/1 = 0</stem>
            </formula>
          </measurement-target>
          <verification exclude="false">
            <p id="_">The following code will be run for verification:</p>
            <sourcecode id="_">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
          </verification>
          <import exclude="true">
            <sourcecode id="_">success-response()</sourcecode>
          </import>
        </permission>
            </foreword></preface>
            </ogc-standard>
OUTPUT

        html = <<~OUTPUT
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
             <h1 class='ForewordTitle'>i.&#160; Preface</h1>
             <table id='A1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Abstract Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Control-class</td>
                   <td style='vertical-align:top;' class='recommend'>Technical</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Priority</td>
                   <td style='vertical-align:top;' class='recommend'>P0</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p id='_'>
                       I recommend
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p id='_'>The measurement target shall be measured as:</p>
                     <div id='_'>
                       <div class='formula'>
                         <p>
                           <span class='stem'>(#(r/1 = 0)#)</span>
                           &#160; (1)
                         </p>
                       </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p id='_'>The following code will be run for verification:</p>
                     <pre id='_' class='prettyprint '>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; if
                       (success)
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                       recommendation(label: success-response)
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; end
                       <br/>
                       &#160;&#160;&#160;&#160;&#160;&#160;&#160;
                     </pre>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='zzSTDTitle1'/>
         </div>
       </body>
OUTPUT

word = <<~OUTPUT
<body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr style='background:#C9C9C9;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Abstract Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Control-class</td>
                   <td style='vertical-align:top;' class='recommend'>Technical</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Priority</td>
                   <td style='vertical-align:top;' class='recommend'>P0</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       I recommend
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div>
                       <a name='_' id='_'/>
                       <div class='formula'>
                         <p class='MsoNormal'>
                           <span class='stem'>
                             <m:oMath>
                               <m:f>
                                 <m:fPr>
                                   <m:type m:val='bar'/>
                                 </m:fPr>
                                 <m:num>
                                   <m:r>
                                     <m:t>r</m:t>
                                   </m:r>
                                 </m:num>
                                 <m:den>
                                   <m:r>
                                     <m:t>1</m:t>
                                   </m:r>
                                 </m:den>
                               </m:f>
                               <m:r>
                                 <m:t>=0</m:t>
                               </m:r>
                             </m:oMath>
                           </span>
                           <span style='mso-tab-count:1'>&#xA0; </span>
                           (1)
                         </p>
                       </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The following code will be run for verification:
                     </p>
                     <p class='Sourcecode'>
                       <a name='_' id='_'/>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if
                       (success)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;
                       recommendation(label: success-response)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;
                     </p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
OUTPUT

        expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
                FileUtils.rm_f "test.doc"
        IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
                expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)
        end

        it "processes permission classes" do
          input = <<~INPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A"><title>Preface</title>
    <permission id="A1" type="class" keep-with-next="true" keep-lines-together="true">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <permission id="A2">
  <label>/ogc/recommendation/wfs/10</label>
  </permission>
  <requirement id="A3">
  <label>Requirement 1</label>
  </requirement>
  <recommendation id="A4">
  <label>Recommendation 1</label>
  </recommendation>
</permission>

<permission id="B1">
  <label>/ogc/recommendation/wfs/10</label>
</permission>

    </foreword></preface>
    </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
     <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface><foreword id="A"><title depth="1">i.<tab/>Preface</title>
            <permission id="A1" type="class" keep-with-next="true" keep-lines-together="true"><name>Permission Class 1</name>
          <label>/ogc/recommendation/wfs/2</label>
          <inherit>/ss/584/2015/level/1</inherit>
          <inherit>/ss/584/2015/level/2</inherit>
          <subject>user</subject>
          <permission id="A2"><name>Permission 1</name>
          <label>/ogc/recommendation/wfs/10</label>
          </permission>
          <requirement id="A3"><name>Requirement 1-1</name>
          <label>Requirement 1</label>
          </requirement>
          <recommendation id="A4"><name>Recommendation 1-1</name>
          <label>Recommendation 1</label>
          </recommendation>
        </permission>

        <permission id="B1"><name>Permission 1</name>
          <label>/ogc/recommendation/wfs/10</label>
        </permission>

            </foreword></preface>
            </ogc-standard>
OUTPUT

html = <<~OUTPUT
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
             <h1 class='ForewordTitle'>i.&#160; Preface</h1>
             <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;page-break-after: avoid;page-break-inside: avoid;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Target Type</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                 </tr>
                 <table id='A2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Permission 1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td style='vertical-align:top;' class='recommend' colspan='2'>
                         <p>/ogc/recommendation/wfs/10</p>
                       </td>
                     </tr>
                   </tbody>
                 </table>
                 <table id='A3' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Requirement 1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td style='vertical-align:top;' class='recommend' colspan='2'>
                         <p>Requirement 1</p>
                       </td>
                     </tr>
                   </tbody>
                 </table>
                 <table id='A4' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Recommendation 1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td style='vertical-align:top;' class='recommend' colspan='2'>
                         <p>Recommendation 1</p>
                       </td>
                     </tr>
                   </tbody>
                 </table>
               </tbody>
             </table>
             <table id='B1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p>/ogc/recommendation/wfs/10</p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='zzSTDTitle1'/>
         </div>
       </body>
OUTPUT

word = %Q{
       <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;page-break-after: avoid;page-break-inside: avoid;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Target Type</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Permission 1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>/ogc/recommendation/wfs/10</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Requirement 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Recommendation 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <a name='B1' id='B1'/>
               <thead>
                 <tr style='background:#A5A5A5;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/10</p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
}

        expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
                FileUtils.rm_f "test.doc"
        IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
                expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)
      end

               it "processes conformance classes" do
                 input = <<~INPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A"><title>Preface</title>
    <permission id="A1" type="conformanceclass">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <permission id="A2">
  <label>Permission 1</label>
  </permission>
  <requirement id="A3">
  <label>Requirement 1</label>
  </requirement>
  <recommendation id="A4">
  <label>Recommendation 1</label>
  </recommendation>
</permission>
    </foreword></preface>
    </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
<ogc-standard xmlns='https://standards.opengeospatial.org/document'>
  <preface>
    <foreword id='A'><title depth='1'>i.<tab/>Preface</title>
      <permission id='A1' type='conformanceclass'>
        <name>Conformance Class 1</name>
        <label>/ogc/recommendation/wfs/2</label>
        <inherit>/ss/584/2015/level/1</inherit>
        <inherit>/ss/584/2015/level/2</inherit>
        <subject>user</subject>
        <permission id='A2'>
          <name>Permission 1-1</name>
          <label>Permission 1</label>
        </permission>
        <requirement id='A3'>
          <name>Requirement 1-1</name>
          <label>Requirement 1</label>
        </requirement>
        <recommendation id='A4'>
          <name>Recommendation 1-1</name>
          <label>Recommendation 1</label>
        </recommendation>
      </permission>
    </foreword>
  </preface>
</ogc-standard>
OUTPUT

html = <<~OUTPUT
                #{HTML_HDR}
    <br/>
    <div id='A'>
      <h1 class='ForewordTitle'>i.&#160; Preface</h1>
      <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
        <thead>
          <tr>
            <th style='vertical-align:top;' class='recommend' colspan='2'>
              <p class='RecommendationTitle'>Conformance Class 1:</p>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td style='vertical-align:top;' class='recommend' colspan='2'>
              <p>/ogc/recommendation/wfs/2</p>
            </td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Target Type</td>
            <td style='vertical-align:top;' class='recommend'>user</td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Dependency</td>
            <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Dependency</td>
            <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
          </tr>
          <table id='A2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Permission 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Permission 1</p>
                </td>
              </tr>
            </tbody>
          </table>
          <table id='A3' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Requirement 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Requirement 1</p>
                </td>
              </tr>
            </tbody>
          </table>
          <table id='A4' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Recommendation 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Recommendation 1</p>
                </td>
              </tr>
            </tbody>
          </table>
        </tbody>
      </table>
    </div>
    <p class='zzSTDTitle1'/>
  </div>
</body>
OUTPUT

word = <<~OUTPUT
<body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Conformance Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Target Type</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Permission 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Permission 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Requirement 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Recommendation 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
OUTPUT

        expect((IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
            expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)
           end

              it "processes requirement classes" do
                input = <<~INPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A"><title>Preface</title>
    <requirement id="A1" type="class">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <permission id="A2">
  <label>Permission 1</label>
  </permission>
  <requirement id="A3">
  <label>Requirement 1</label>
  </requirement>
  <recommendation id="A4">
  <label>Recommendation 1</label>
  </recommendation>
</requirement>
    </foreword></preface>
    </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface><foreword id="A"><title depth="1">i.<tab/>Preface</title>
            <requirement id="A1" type="class"><name>Requirement Class 1</name>
          <label>/ogc/recommendation/wfs/2</label>
          <inherit>/ss/584/2015/level/1</inherit>
          <inherit>/ss/584/2015/level/2</inherit>
          <subject>user</subject>
          <permission id="A2"><name>Permission 1-1</name>
          <label>Permission 1</label>
          </permission>
          <requirement id="A3"><name>Requirement 1-1</name>
          <label>Requirement 1</label>
          </requirement>
          <recommendation id="A4"><name>Recommendation 1-1</name>
          <label>Recommendation 1</label>
          </recommendation>
        </requirement>
            </foreword></preface>
            </ogc-standard>
OUTPUT

html = <<~OUTPUT
        #{HTML_HDR}
            <br/>
    <div id='A'>
      <h1 class='ForewordTitle'>i.&#160; Preface</h1>
      <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
        <thead>
          <tr>
            <th style='vertical-align:top;' class='recommend' colspan='2'>
              <p class='RecommendationTitle'>Requirement Class 1:</p>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td style='vertical-align:top;' class='recommend' colspan='2'>
              <p>/ogc/recommendation/wfs/2</p>
            </td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Target Type</td>
            <td style='vertical-align:top;' class='recommend'>user</td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Dependency</td>
            <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Dependency</td>
            <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
          </tr>
          <table id='A2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Permission 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Permission 1</p>
                </td>
              </tr>
            </tbody>
          </table>
          <table id='A3' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Requirement 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Requirement 1</p>
                </td>
              </tr>
            </tbody>
          </table>
          <table id='A4' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Recommendation 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Recommendation 1</p>
                </td>
              </tr>
            </tbody>
          </table>
        </tbody>
      </table>
    </div>
    <p class='zzSTDTitle1'/>
  </div>
</body>
OUTPUT

word = <<~OUTPUT
<body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
  i.
  <span style='mso-tab-count:1'>&#xA0; </span>
  Preface
</h1>
             <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Requirement Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Target Type</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Permission 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Permission 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Requirement 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Recommendation 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
OUTPUT

        expect((IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
            expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)

      end

               it "processes recommendation classes" do
                 input = <<~INPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A"><title>Preface</title>
    <recommendation id="A1" type="class">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <permission id="A2">
  <label>Permission 1</label>
  </permission>
  <requirement id="A3">
  <label>Requirement 1</label>
  </requirement>
  <recommendation id="A4">
  <label>Recommendation 1</label>
  </recommendation>
</recommendation>
    </foreword></preface>
    </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface><foreword id="A"><title depth="1">i.<tab/>Preface</title>
            <recommendation id="A1" type="class"><name>Recommendation Class 1</name>
          <label>/ogc/recommendation/wfs/2</label>
          <inherit>/ss/584/2015/level/1</inherit>
          <inherit>/ss/584/2015/level/2</inherit>
          <subject>user</subject>
          <permission id="A2"><name>Permission 1-1</name>
          <label>Permission 1</label>
          </permission>
          <requirement id="A3"><name>Requirement 1-1</name>
          <label>Requirement 1</label>
          </requirement>
          <recommendation id="A4"><name>Recommendation 1-1</name>
          <label>Recommendation 1</label>
          </recommendation>
        </recommendation>
            </foreword></preface>
            </ogc-standard>
OUTPUT

                    html = <<~OUTPUT
        #{HTML_HDR}
    <br/>
    <div id='A'>
      <h1 class='ForewordTitle'>i.&#160; Preface</h1>
      <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
        <thead>
          <tr>
            <th style='vertical-align:top;' class='recommend' colspan='2'>
              <p class='RecommendationTitle'>Recommendation Class 1:</p>
            </th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td style='vertical-align:top;' class='recommend' colspan='2'>
              <p>/ogc/recommendation/wfs/2</p>
            </td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Target Type</td>
            <td style='vertical-align:top;' class='recommend'>user</td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Dependency</td>
            <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
          </tr>
          <tr>
            <td style='vertical-align:top;' class='recommend'>Dependency</td>
            <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
          </tr>
          <table id='A2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Permission 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Permission 1</p>
                </td>
              </tr>
            </tbody>
          </table>
          <table id='A3' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Requirement 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Requirement 1</p>
                </td>
              </tr>
            </tbody>
          </table>
          <table id='A4' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
            <thead>
              <tr>
                <th style='vertical-align:top;' class='recommend' colspan='2'>
                  <p class='RecommendationTitle'>Recommendation 1-1:</p>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='vertical-align:top;' class='recommend' colspan='2'>
                  <p>Recommendation 1</p>
                </td>
              </tr>
            </tbody>
          </table>
        </tbody>
      </table>
    </div>
    <p class='zzSTDTitle1'/>
  </div>
</body>
OUTPUT

word = <<~OUTPUT
 <body xmlns:m=''>
          <div>
            <div>
              <a name='A' id='A'/>
              <h1 class='ForewordTitle'>
  i.
  <span style='mso-tab-count:1'>&#xA0; </span>
  Preface
</h1>
              <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
                <a name='A1' id='A1'/>
                <thead>
                  <tr>
                    <th style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='RecommendationTitle'>Recommendation Class 1:</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Target Type</td>
                    <td style='vertical-align:top;' class='recommend'>user</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='1'>
                      <p class='MsoNormal'>Permission 1-1:</p>
                      <td style='vertical-align:top;' class='recommend' colspan='1'>
                        <p class='MsoNormal'>Permission 1</p>
                      </td>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='1'>
                      <p class='MsoNormal'>Requirement 1-1:</p>
                      <td style='vertical-align:top;' class='recommend' colspan='1'>
                        <p class='MsoNormal'>Requirement 1</p>
                      </td>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='1'>
                      <p class='MsoNormal'>Recommendation 1-1:</p>
                      <td style='vertical-align:top;' class='recommend' colspan='1'>
                        <p class='MsoNormal'>Recommendation 1</p>
                      </td>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p class='MsoNormal'>&#xA0;</p>
          </div>
          <p class='MsoNormal'>
            <br clear='all' class='section'/>
          </p>
          <div class='WordSection3'>
            <p class='zzSTDTitle1'/>
          </div>
          <div style='mso-element:footnote-list'/>
        </body>
OUTPUT


        expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
         FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
     expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)
      end

it "processes requirements" do
                    input = <<~INPUT
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A0"><title>Preface</title>
    <requirement id="A" unnumbered="true">
  <title>A New Requirement</title>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <subject>user</subject>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular" keep-with-next="true" keep-lines-together="true">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
        </tr>
        <tr>
          <td style="text-align:left;">Mission</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
    <p id="_">As for the measurement targets,</p>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="B">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</requirement>
    </foreword></preface>
    </ogc-standard>
INPUT
presxml = <<~OUTPUT
            <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface><foreword id="A0"><title depth="1">i.<tab/>Preface</title>
            <requirement id="A" unnumbered="true"><name>Requirement</name>
          <title>A New Requirement</title>
          <label>/ogc/recommendation/wfs/2</label>
          <inherit>/ss/584/2015/level/1</inherit>
          <subject>user</subject>
          <description>
            <p id="_">I recommend <em>this</em>.</p>
          </description>
          <specification exclude="true" type="tabular" keep-with-next="true" keep-lines-together="true">
            <p id="_">This is the object of the recommendation:</p>
            <table id="_">
              <tbody>
                <tr>
                  <td style="text-align:left;">Object</td>
                  <td style="text-align:left;">Value</td>
                </tr>
                <tr>
                  <td style="text-align:left;">Mission</td>
                  <td style="text-align:left;">Accomplished</td>
                </tr>
              </tbody>
            </table>
          </specification>
          <description>
            <p id="_">As for the measurement targets,</p>
          </description>
          <measurement-target exclude="false">
            <p id="_">The measurement target shall be measured as:</p>
            <formula id="B"><name>1</name>
              <stem type="AsciiMath">r/1 = 0</stem>
            </formula>
          </measurement-target>
          <verification exclude="false">
            <p id="_">The following code will be run for verification:</p>
            <sourcecode id="_">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
          </verification>
          <import exclude="true">
            <sourcecode id="_">success-response()</sourcecode>
          </import>
        </requirement>
            </foreword></preface>
            </ogc-standard>
OUTPUT

html = <<~OUTPUT
    #{HTML_HDR}
     <br/>
            <div id='A0'>
              <h1 class='ForewordTitle'>i.&#160; Preface</h1>
              <table id='A' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                <thead>
                  <tr>
                    <th style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='RecommendationTitle'>Requirement: A New Requirement</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p>/ogc/recommendation/wfs/2</p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Subject</td>
                    <td style='vertical-align:top;' class='recommend'>user</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>
                        I recommend
                        <i>this</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>As for the measurement targets,</p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>The measurement target shall be measured as:</p>
                      <div id='B'>
                        <div class='formula'>
                          <p>
                            <span class='stem'>(#(r/1 = 0)#)</span>
                            &#160; (1)
                          </p>
                        </div>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>The following code will be run for verification:</p>
                      <pre id='_' class='prettyprint '>
                        CoreRoot(success): HttpResponse
                        <br/>
                        &#160;&#160;&#160;&#160;&#160; if (success)
                        <br/>
                        &#160;&#160;&#160;&#160;&#160; recommendation(label:
                        success-response)
                        <br/>
                        &#160;&#160;&#160;&#160;&#160; end
                        <br/>
                        &#160;&#160;&#160;
                      </pre>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p class='zzSTDTitle1'/>
          </div>
        </body>
    OUTPUT

    word = <<~OUTPUT
       <body xmlns:m=''>
          <div>
            <div>
              <a name='A0' id='A0'/>
              <h1 class='ForewordTitle'>
                i.
                <span style='mso-tab-count:1'>&#xA0; </span>
                Preface
              </h1>
              <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                <a name='A' id='A'/>
                <thead>
                  <tr style='background:#A5A5A5;'>
                    <th style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='RecommendationTitle'>Requirement: A New Requirement</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td style='vertical-align:top;' class='recommend'>Subject</td>
                    <td style='vertical-align:top;' class='recommend'>user</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend 
                        <i>this</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        As for the measurement targets,
                      </p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        The measurement target shall be measured as:
                      </p>
                      <div>
                        <a name='B' id='B'/>
                        <div class='formula'>
                          <p class='MsoNormal'>
                            <span class='stem'>
                              <m:oMath>
                                <m:f>
                                  <m:fPr>
                                    <m:type m:val='bar'/>
                                  </m:fPr>
                                  <m:num>
                                    <m:r>
                                      <m:t>r</m:t>
                                    </m:r>
                                  </m:num>
                                  <m:den>
                                    <m:r>
                                      <m:t>1</m:t>
                                    </m:r>
                                  </m:den>
                                </m:f>
                                <m:r>
                                  <m:t>=0</m:t>
                                </m:r>
                              </m:oMath>
                            </span>
                            <span style='mso-tab-count:1'>&#xA0; </span>
                            (1)
                          </p>
                        </div>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        The following code will be run for verification:
                      </p>
                      <p class='Sourcecode'>
                        <a name='_' id='_'/>
                        CoreRoot(success): HttpResponse
                        <br/>
                        &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if (success)
                        <br/>
                        &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; recommendation(label:
                        success-response)
                        <br/>
                        &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                        <br/>
                        &#xA0;&#xA0;&#xA0; 
                      </p>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p class='MsoNormal'>&#xA0;</p>
          </div>
          <p class='MsoNormal'>
            <br clear='all' class='section'/>
          </p>
          <div class='WordSection3'>
            <p class='zzSTDTitle1'/>
          </div>
          <div style='mso-element:footnote-list'/>
        </body>
    OUTPUT

        expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
     expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A0" id="A0">}m, "<body xmlns:m=''><div><div><a name='A0' id='A0'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)
  end

  it "processes recommendations" do
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A"><title>Preface</title>
    <recommendation id="_">
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <subject>user</subject>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
        </tr>
        <tr>
          <td style="text-align:left;">Mission</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
    <p id="_">As for the measurement targets,</p>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="_">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</recommendation>
    </foreword></preface>
    </ogc-standard>
INPUT
presxml = <<~OUTPUT
<ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface><foreword id="A"><title depth='1'>i.<tab/>Preface</title>
            <recommendation id="_"><name>Recommendation 1</name>
          <label>/ogc/recommendation/wfs/2</label>
          <inherit>/ss/584/2015/level/1</inherit>
          <subject>user</subject>
          <description>
            <p id="_">I recommend <em>this</em>.</p>
          </description>
          <specification exclude="true" type="tabular">
            <p id="_">This is the object of the recommendation:</p>
            <table id="_">
              <tbody>
                <tr>
                  <td style="text-align:left;">Object</td>
                  <td style="text-align:left;">Value</td>
                </tr>
                <tr>
                  <td style="text-align:left;">Mission</td>
                  <td style="text-align:left;">Accomplished</td>
                </tr>
              </tbody>
            </table>
          </specification>
          <description>
            <p id="_">As for the measurement targets,</p>
          </description>
          <measurement-target exclude="false">
            <p id="_">The measurement target shall be measured as:</p>
            <formula id="_"><name>1</name>
              <stem type="AsciiMath">r/1 = 0</stem>
            </formula>
          </measurement-target>
          <verification exclude="false">
            <p id="_">The following code will be run for verification:</p>
            <sourcecode id="_">CoreRoot(success): HttpResponse
              if (success)
              recommendation(label: success-response)
              end
            </sourcecode>
          </verification>
          <import exclude="true">
            <sourcecode id="_">success-response()</sourcecode>
          </import>
        </recommendation>
            </foreword></preface>
            </ogc-standard>
OUTPUT

html = <<~OUTPUT
    #{HTML_HDR}
    <br/>
            <div id='A'>
              <h1 class='ForewordTitle'>i.&#160; Preface</h1>
              <table id='_' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                <thead>
                  <tr>
                    <th style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='RecommendationTitle'>Recommendation 1:</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p>/ogc/recommendation/wfs/2</p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Subject</td>
                    <td style='vertical-align:top;' class='recommend'>user</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>
                        I recommend
                        <i>this</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>As for the measurement targets,</p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>The measurement target shall be measured as:</p>
                      <div id='_'>
                        <div class='formula'>
                          <p>
                            <span class='stem'>(#(r/1 = 0)#)</span>
                            &#160; (1)
                          </p>
                        </div>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p id='_'>The following code will be run for verification:</p>
                      <pre id='_' class='prettyprint '>
                        CoreRoot(success): HttpResponse
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; if (success)
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; recommendation(label: success-response)
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; end
                        <br/>
                        &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                      </pre>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p class='zzSTDTitle1'/>
          </div>
        </body>
    OUTPUT

    word = <<~OUTPUT
        <body xmlns:m=''>
          <div>
            <div>
              <a name='A' id='A'/>
              <h1 class='ForewordTitle'>
                i.
                <span style='mso-tab-count:1'>&#xA0; </span>
                Preface
              </h1>
              <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                <a name='_' id='_'/>
                <thead>
                  <tr style='background:#A5A5A5;'>
                    <th style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='RecommendationTitle'>Recommendation 1:</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td style='vertical-align:top;' class='recommend'>Subject</td>
                    <td style='vertical-align:top;' class='recommend'>user</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend 
                        <i>this</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        As for the measurement targets,
                      </p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        The measurement target shall be measured as:
                      </p>
                      <div>
                        <a name='_' id='_'/>
                        <div class='formula'>
                          <p class='MsoNormal'>
                            <span class='stem'>
                              <m:oMath>
                                <m:f>
                                  <m:fPr>
                                    <m:type m:val='bar'/>
                                  </m:fPr>
                                  <m:num>
                                    <m:r>
                                      <m:t>r</m:t>
                                    </m:r>
                                  </m:num>
                                  <m:den>
                                    <m:r>
                                      <m:t>1</m:t>
                                    </m:r>
                                  </m:den>
                                </m:f>
                                <m:r>
                                  <m:t>=0</m:t>
                                </m:r>
                              </m:oMath>
                            </span>
                            <span style='mso-tab-count:1'>&#xA0; </span>
                            (1)
                          </p>
                        </div>
                      </div>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        The following code will be run for verification:
                      </p>
                      <p class='Sourcecode'>
                        <a name='_' id='_'/>
                        CoreRoot(success): HttpResponse
                        <br/>
                        &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if (success)
                        <br/>
                        &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; recommendation(label: success-response)
                        <br/>
                        &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                        <br/>
                        &#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0; 
                      </p>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p class='MsoNormal'>&#xA0;</p>
          </div>
          <p class='MsoNormal'>
            <br clear='all' class='section'/>
          </p>
          <div class='WordSection3'>
            <p class='zzSTDTitle1'/>
          </div>
          <div style='mso-element:footnote-list'/>
        </body>
OUTPUT

        expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", input, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(presxml)
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(html)
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
    expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(word)
  end


end
