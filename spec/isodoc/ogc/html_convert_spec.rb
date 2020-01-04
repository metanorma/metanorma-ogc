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
         <ext>
         <doctype>standard</doctype>
         <docsubtype>conceptual-model-and-encoding</docsubtype>
         <editorialgroup>
           <committee type="A">TC</committee>
           <committee type="B">TC1</committee>
           <subcommittee type="C" number="1">SC1</committee>
           <workgroup type="D" number="2">WG1</committee>
         </editorialgroup>
         <keyword>A</keyword>
         <keyword>B</keyword>
         </ext>
       </bibdata>
       <sections/>
       </ogc-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
    {:accesseddate=>"XXX", :authors=>["Barney Rubble"], :circulateddate=>"XXX", :confirmeddate=>"XXX", :copieddate=>"XXX", :createddate=>"1999-01-01", :doc=>"http://www.example.com/doc", :docnumber=>"1000", :docsubtype=>"Conceptual Model And Encoding", :doctitle=>"Main Title", :doctype=>"Implementation Standard", :docyear=>"2001", :draft=>"3.4", :draftinfo=>" (draft 3.4, 2000-01-01)", :edition=>"2.0", :editors=>["Fred Flintstone"], :externalid=>"http://www.example2.com", :html=>"http://www.example.com/html", :implementeddate=>"XXX", :issueddate=>"2001-01-01", :keywords=>["A", "B"], :language=>["eng", "", "en", "English", "anglais"], :obsoleteddate=>"XXX", :pdf=>"http://www.example.com/pdf", :publisheddate=>"2002-01-01", :receiveddate=>"XXX", :revdate=>"2000-01-01", :revdate_monthyear=>"January 2000", :stage=>"Swg work", :tc=>"TC", :transmitteddate=>"XXX", :unchangeddate=>"XXX", :unpublished=>true, :updateddate=>"XXX", :url=>"http://www.example.com", :xml=>"http://www.example.com/xml"}
    OUTPUT

    docxml, filename, dir = csdc.convert_init(input, "test", true)
    expect(xmlpp(htmlencode(Hash[csdc.info(docxml, nil).sort].to_s))).to be_equivalent_to output
  end

  it "processes pre" do
    input = <<~"INPUT"
<ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
<preface><foreword id="A">
<pre>ABC</pre>
</foreword></preface>
</ogc-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{HTML_HDR}
             <br/>
             <div id="A">
               <h1 class="ForewordTitle">i.&#160; Preface</h1>
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

  it "processes keyword" do
    input = <<~"INPUT"
<ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
<bibdata>
<ext>
<keyword>ABC</keyword>
</ext>
</bibdata>
</ogc-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
        <div class="Section3">
        <h1 class="IntroTitle">i.&#160; Keywords</h1>
        <p>The following are keywords to be used by search engines and document catalogues.</p>
        <p>ABC</p>
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

  it "processes simple terms & definitions" do
    input = <<~"INPUT"
     <ogc-standard xmlns="https://standards.opengeospatial.org/document">
       <sections>
       <terms id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title>
         <term id="J">
         <preferred>Term2</preferred>
       </term>
        </terms>
        </sections>
        </ogc-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
             <p class="zzSTDTitle1"/>
             <div id="H"><h1>1.&#160; Terms and definitions</h1>
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
      expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
    <iso-standard xmlns="http://riboseinc.com/isoxml">
    <preface><foreword id="A">
    <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="caution">
  <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
</admonition>
    </foreword></preface>
    </iso-standard>
    INPUT
        #{HTML_HDR}
               <br/>
               <div id="A">
                 <h1 class="ForewordTitle">i.&#160; Preface</h1>
                 <div class="Admonition"><p class="AdmonitionTitle" style="text-align:center;">CAUTION</p>
         <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </div>
               </div>
               <p class="zzSTDTitle1"/>
             </div>
           </body>
    OUTPUT
  end

      it "processes warning admonitions" do
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
    <iso-standard xmlns="http://riboseinc.com/isoxml">
    <preface><foreword id="A">
    <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="warning">
  <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
</admonition>
    </foreword></preface>
    </iso-standard>
    INPUT
        #{HTML_HDR}
               <br/>
               <div id="A">
                 <h1 class="ForewordTitle">i.&#160; Preface</h1>
                 <div class="Admonition.Warning"><p class="AdmonitionTitle" style="text-align:center;">WARNING</p>
         <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </div>
               </div>
               <p class="zzSTDTitle1"/>
             </div>
           </body>
    OUTPUT
  end

        it "processes important admonitions" do
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
    <iso-standard xmlns="http://riboseinc.com/isoxml">
    <preface><foreword id="A">
    <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="important">
  <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
</admonition>
    </foreword></preface>
    </iso-standard>
    INPUT
        #{HTML_HDR}
               <br/>
               <div id="A">
                 <h1 class="ForewordTitle">i.&#160; Preface</h1>
                 <div class="Admonition.Important"><p class="AdmonitionTitle" style="text-align:center;">IMPORTANT</p>
         <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
       </div>
               </div>
               <p class="zzSTDTitle1"/>
             </div>
           </body>
    OUTPUT
  end

  it "processes examples with titles" do
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
    <iso-standard xmlns="http://riboseinc.com/isoxml">
    <preface><foreword id="A">
          <example id="_"><name>Example Title</name><p id="_">This is an example</p>
<p id="_">Amen</p></example>
    </foreword></preface>
    </iso-standard>
    INPUT
        #{HTML_HDR}
        <br/>
      <div id="A">
        <h1 class="ForewordTitle">i.&#160; Preface</h1>
        <p class='SourceTitle' style='text-align:center;'>Figure &#160;&#8212; Example Title</p>
        <div id="_" class="example"><p class="example-title">EXAMPLE&#160;&#8212; Example Title</p><p id="_">This is an example</p>
<p id="_">Amen</p></div>
      </div>
      <p class="zzSTDTitle1"/>
    </div>
  </body>
    OUTPUT
  end


  it "processes section names" do
    input = <<~"INPUT"
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
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
         <ext>
      <keyword>A</keyword>
      <keyword>B</keyword>
      </ext>
      </bibdata>
      <preface>
       <abstract obligation="informative" id="1">
       <p>XYZ</p>
       </abstract>
      <foreword obligation="informative" id="2">
         <title>Foreword</title>
         <p id="A">This is a preamble</p>
       </foreword>
       <submitters obligation="informative" id="3">
       <p>ABC</p>
       </submitters>
        </preface><sections>
       <clause id="D" obligation="normative">
         <title>Scope</title>
         <p id="E">Text</p>
       </clause>
       <clause id="D1" obligation="normative">
         <title>Conformance</title>
         <p id="E1">Text</p>
       </clause>

       <clause id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title><terms id="I" obligation="normative">
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
       </annex><bibliography><references id="R" obligation="informative">
         <title>Normative References</title>
       </references><clause id="S" obligation="informative">
         <title>Bibliography</title>
         <references id="T" obligation="informative">
         <title>Bibliography Subsection</title>
       </references>
       </clause>
       </bibliography>
       </ogc-standard>
    INPUT

    output = xmlpp(<<~"OUTPUT")
        #{HTML_HDR}
        <br/>
             <div id="1">
               <h1 class="AbstractTitle">i.&#160; Abstract</h1>
               <p>XYZ</p>
             </div>
             <div class="Section3">
               <h1 class="IntroTitle">ii.&#160; Keywords</h1>
               <p>The following are keywords to be used by search engines and document catalogues.</p>
               <p>A, B</p>
             </div>
             <br/>
             <div id="2">
               <h1 class="ForewordTitle">iii.&#160; Preface</h1>
               <p id="A">This is a preamble</p>
             </div>
             <div class="Section3">
               <h1 class="IntroTitle">iv.&#160; Submitting Organizations</h1>
               <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
               <ul>
                 <li>OGC</li>
                 <li>DEF</li>
               </ul>
             </div>
             <div class="Section3">
               <h1 class="IntroTitle">v.&#160; Submitters</h1>
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
               <h1>3.&#160; Normative references</h1>
             </div>
             <div id="H"><h1>4.&#160; Terms, definitions, symbols and abbreviated terms</h1>
       <div id="I">
          <h2>4.1.&#160; Normal Terms</h2>
          <p class="TermNum" id="J">4.1.1.</p>
          <p class="Terms" style="text-align:left;">Term2</p>

        </div><div id="K"><h2>4.2.&#160; Symbols and abbreviated terms</h2>
          <dl><dt><p>Symbol</p></dt><dd>Definition</dd></dl>
        </div></div>
             <div id="L" class="Symbols">
               <h1>5.&#160; Symbols and abbreviated terms</h1>
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

    expect(xmlpp(
      IsoDoc::Ogc::HtmlConvert.new({}).convert("test", input, true).
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
    INPUT

    output = xmlpp(<<~"OUTPUT")
    #{BLANK_HDR}
<sections/>
</ogc-standard>
    OUTPUT

    expect(xmlpp(Asciidoctor.convert(input, backend: :ogc, header_footer: true))).to be_equivalent_to output
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Overpass})
  end

  it "processes permissions" do
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
        <p id="_"><xref target="A1"/></p>
    <permission id="A1">
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
    #{HTML_HDR}
     <br/>
           <div id='A'>
             <h1 class='ForewordTitle'>i.&#160; Preface</h1>
             <p id='_'>
  <a href='#A1'>Permission 1</a>
</p>
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
                   <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
                     <div id='_' class='formula'>
                       <p>
                         <span class='stem'>(#(r/1 = 0)#)</span>
                         &#160; (1)
                       </p>
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

  end

    it "processes permission verifications" do
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface>
        <foreword id="A">
        <p id="_"><xref target="A1"/></p>
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
    #{HTML_HDR}
    <br/>
        <div id='A'>
      <h1 class='ForewordTitle'>i.&#160; Preface</h1>
      <p id='_'>
        <a href='#A1'>Permission Test 1</a>
      </p>
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
            <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
              <div id='_' class='formula'>
                <p>
                  <span class='stem'>(#(r/1 = 0)#)</span>
                  &#160; (1)
                </p>
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
    end

  it "processes requirements" do
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A0">
    <requirement id="A" unnumbered="true">
  <title>A New Requirement</title>
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
                   <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
                     <div id='B' class='formula'>
                       <p>
                         <span class='stem'>(#(r/1 = 0)#)</span>
                         &#160; (1)
                       </p>
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

  end

  it "processes recommendations" do
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
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
                   <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
                     <div id='_' class='formula'>
                       <p>
                         <span class='stem'>(#(r/1 = 0)#)</span>
                         &#160; (1)
                       </p>
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
  end

  it "processes bibliographies" do
        expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata>
    <language>en</language>
    </bibdata>
    <preface><foreword id="A">
  <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
  <eref bibitemid="ISO712"/>
  <eref bibitemid="ISO16634"/>
  <eref bibitemid="ISO20483"/>
  <eref bibitemid="ref1"/>
  <eref bibitemid="ref10"/>
  </p>
    </foreword></preface>
    <bibliography><references id="_normative_references" obligation="informative"><title>Normative References</title>
               <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
<bibitem id="ISO712" type="standard">
  <title format="text/plain">Cereals or cereal products</title>
  <title type="main" format="text/plain">Cereals and cereal products</title>
  <docidentifier type="ISO">ISO 712</docidentifier>
  <date type="published">
    <on>2018</on>
  </date>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Organization for Standardization</name>
      <abbreviation>ISO</abbreviation>
    </organization>
  </contributor>
  <place>Geneva</place>
</bibitem>
<bibitem id="ISO16634" type="standard">
  <title language="x" format="text/plain">Cereals, pulses, milled cereal products, xxxx, oilseeds and animal feeding stuffs</title>
  <title language="en" format="text/plain">Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</title>
  <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
  <date type="published">
    <from>2018</from>
    <to>2019</to>
  </date>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Organization for Standardization</name>
      <abbreviation>ISO</abbreviation>
    </organization>
  </contributor>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Electrotechnical Commission</name>
      <abbreviation>IEC</abbreviation>
    </organization>
  </contributor>
  <note format="text/plain" reference="1">ISO DATE: Under preparation. (Stage at the time of publication ISO/DIS 16634)</note>
  <extent type="part">
  <referenceFrom>all</referenceFrom>
  </extent>

</bibitem>
<bibitem id="ISO20483" type="standard">
  <title format="text/plain">Cereals and pulses</title>
  <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
  <date type="published"><from>2013</from><to>2014</to></date>
  <contributor>
    <role type="publisher"/>
    <organization>
      <name>International Organization for Standardization</name>
    </organization>
  </contributor>
</bibitem>
<bibitem id="ref1">
  <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
  <docidentifier type="ICC">167</docidentifier>
</bibitem>
</references><references id="_bibliography" obligation="informative">
  <title>Bibliography</title>
<bibitem id="ISO3696" type="standard">
  <title format="text/plain">Water for analytical laboratory use</title>
  <docidentifier type="ISO">ISO 3696</docidentifier>
  <contributor>
    <role type="publisher"/>
    <organization>
      <abbreviation>ISO</abbreviation>
    </organization>
  </contributor>
</bibitem>
<bibitem id="ref10">
  <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
  <docidentifier type="metanorma">[10]</docidentifier>
</bibitem>
<bibitem id="ref11">
  <title>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</title>
  <docidentifier type="IETF">RFC 10</docidentifier>
</bibitem>


</references>
</bibliography>
    </ogc-standard>

INPUT
    #{HTML_HDR}
             <br/>
             <div id="A">
               <h1 class="ForewordTitle">i.&#160; Preface</h1>
               <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
         <a href="#ISO712">ISO 712</a>
         <a href="#ISO16634">ISO 16634:-- (all parts)</a>
         <a href="#ISO20483">ISO 20483:2013-2014</a>
         <a href="#ref1">ICC 167</a>
         <a href="#ref10">[10]</a>
         </p>
             </div>
             <p class="zzSTDTitle1"/>
             <div>
               <h1>1.&#160; Normative references</h1>
               <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
               <p id="ISO712" class="NormRef">ISO: ISO 712, <i>Cereals and cereal products</i>. <span>International Organization for Standardization</span>, Geneva (2018).</p>
               <p id="ISO16634" class="NormRef">ISO/IEC: ISO 16634:-- (all parts), <i>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</i>. <span>International Organization for Standardization</span> and <span>International Electrotechnical Commission</span> (2018&#8211;2019).</p>
               <p id="ISO20483" class="NormRef">International Organization for Standardization: ISO 20483:2013-2014, <i>Cereals and pulses</i>. <span>International Organization for Standardization</span> (2013&#8211;2014).</p>
               <p id="ref1" class="NormRef"><span style="font-variant:small-caps;">Standard No I.C.C 167</span>. <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i> (see <a href="http://www.icc.or.at">http://www.icc.or.at</a>)</p>
             </div>
             <br/>
             <div>
               <h1 class="Section3">Bibliography</h1>
               <p id="ISO3696" class="Biblio">[1]&#160; ISO 3696, <i>Water for analytical laboratory use</i>. </p>
               <p id="ref10" class="Biblio">[10]&#160; <span style="font-variant:small-caps;">Standard No I.C.C 167</span>. <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i> (see <a href="http://www.icc.or.at">http://www.icc.or.at</a>)</p>
               <p id="ref11" class="Biblio">[3]&#160; IETF RFC 10, <i>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</i>. </p>
             </div>
           </div>
         </body>
OUTPUT
  end


end
