require "spec_helper"

logoloc = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "isodoc", "ogc", "html"))

RSpec.describe IsoDoc::Ogc do

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
           <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="A1" class="permission" type="recommend">
       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Permission 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Dependency</td><td><eref type="inline" bibitemid="rfc2616" citeas="RFC 2616">RFC 2616 (HTTP/1.1)</eref></td></tr><tr><td>Control-class</td><td>Technical</td></tr><tr><td>Priority</td><td>P0</td></tr><tr><td>Family</td><td>System and Communications Protection</td></tr><tr><td>Family</td><td>System and Communications Protocols</td></tr><tr><td colspan="2">
           <p id="_">I recommend <em>this</em>.</p>
         </td></tr><tr><td>A</td><td>B</td></tr><tr><td>C</td><td>D</td></tr><tr><td colspan="2">
           <p id="_">The measurement target shall be measured as:</p>
           <formula id="_"><name>1</name>
             <stem type="AsciiMath">r/1 = 0</stem>
           </formula>
         </td></tr><tr><td colspan="2">
           <p id="_">The following code will be run for verification:</p>
           <sourcecode id="_">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
         </td></tr></tbody></table>
           </foreword></preface>
           <bibliography><references id="_bibliography" obligation="informative" normative="false">
       <title depth="1">Bibliography</title>
       <bibitem id="rfc2616" type="standard"> <fetched>2020-03-27</fetched> <title format="text/plain" language="en" script="Latn">Hypertext Transfer Protocol&#x2009;&#x2014;&#x2009;HTTP/1.1</title> <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri> <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri> <docidentifier type="IETF">RFC 2616</docidentifier> <docidentifier type="rfc-anchor">RFC2616</docidentifier> <docidentifier type="DOI">10.17487/RFC2616</docidentifier> <date type="published">  <on>1999</on> </date> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">R. Fielding</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Gettys</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Mogul</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">H. Frystyk</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">L. Masinter</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">P. Leach</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">T. Berners-Lee</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <language>en</language> <script>Latn</script> <abstract format="text/plain" language="en" script="Latn">HTTP has been in use by the World-Wide Web global information initiative since 1990. This specification defines the protocol referred to as &#x201C;HTTP/1.1&#x201D;, and is an update to RFC 2068. [STANDARDS-TRACK]</abstract> <series type="main">  <title format="text/plain" language="en" script="Latn">RFC</title>  <number>2616</number> </series> <place>Fremont, CA</place></bibitem>
       </references></bibliography>
           </ogc-standard>
    OUTPUT

    html = <<~OUTPUT
    #{HTML_HDR}
        <br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
           <br/>
           <div>
             <h1 class='Section3'>Bibliography</h1>
             <p id='rfc2616' class='Biblio'>
               [1]&#160; R. Fielding, J. Gettys, J. Mogul, H. Frystyk, L. Masinter, P. Leach, T. Berners-Lee: IETF RFC 2616,
               <i>Hypertext Transfer Protocol&#8201;&#8212;&#8201;HTTP/1.1</i>
               . Fremont, CA (1999). <a href='https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml'>https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</a>
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='A1' id='A1'/>
                 <thead>
                   <tr style='background:#A5A5A5;'>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Permission 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                                 <span style='font-style:normal;'>
  <m:r>
    <m:rPr>
      <m:sty m:val='p'/>
    </m:rPr>
    <m:t>=</m:t>
  </m:r>
</span>
                                 <m:r>
                                   <m:t>0</m:t>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
               R. Fielding, J. Gettys, J. Mogul, H. Frystyk, L. Masinter, P. Leach, T. Berners-Lee: IETF RFC 2616, 
               <i>Hypertext Transfer Protocol&#x2009;&#x2014;&#x2009;HTTP/1.1</i>
               . Fremont, CA (1999).  <a href='https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml'>https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</a>
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
            <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface>
               <foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="A1" type="recommendtest" class="permission">
         
         
         
         
         
         
         
         
         
         
       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTestTitle">Permission Test 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Control-class</td><td>Technical</td></tr><tr><td>Priority</td><td>P0</td></tr><tr><td>Family</td><td>System and Communications Protection</td></tr><tr><td>Family</td><td>System and Communications Protocols</td></tr><tr><td colspan="2">
           <p id="_">I recommend <em>this</em>.</p>
         </td></tr><tr><td>A</td><td>B</td></tr><tr><td>C</td><td>D</td></tr><tr><td colspan="2">
           <p id="_">The measurement target shall be measured as:</p>
           <formula id="_"><name>1</name>
             <stem type="AsciiMath">r/1 = 0</stem>
           </formula>
         </td></tr><tr><td colspan="2">
           <p id="_">The following code will be run for verification:</p>
           <sourcecode id="_">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
         </td></tr></tbody></table>
           </foreword></preface>
           </ogc-standard>
OUTPUT

    html = <<~OUTPUT
    #{HTML_HDR}
        <br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTestTitle'>Permission Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>The following code will be run for verification:</p>
                     <pre id='_' class='prettyprint '>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#160;&#160;&#160; if (success)
                       <br/>
                       &#160;&#160;&#160; recommendation(label: success-response)
                       <br/>
                       &#160;&#160;&#160; end
                       <br/>
                       &#160; 
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='A1' id='A1'/>
                 <thead>
                   <tr style='background:#C9C9C9;'>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTestTitle'>Permission Test 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                                 <span style='font-style:normal;'>
  <m:r>
    <m:rPr>
      <m:sty m:val='p'/>
    </m:rPr>
    <m:t>=</m:t>
  </m:r>
</span>
                                 <m:r>
                                   <m:t>0</m:t>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         The following code will be run for verification:
                       </p>
                       <p class='Sourcecode'>
                         <a name='_' id='_'/>
                         CoreRoot(success): HttpResponse
                         <br/>
                         &#xA0;&#xA0;&#xA0; if (success)
                         <br/>
                         &#xA0;&#xA0;&#xA0; recommendation(label: success-response)
                         <br/>
                         &#xA0;&#xA0;&#xA0; end
                         <br/>
                         &#xA0; 
                       </p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
           <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface>
               <foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="A1" type="recommendtest" class="permission">
         
         
         
         
         
         
         
         
         
         
       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTestTitle">Abstract Test 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Control-class</td><td>Technical</td></tr><tr><td>Priority</td><td>P0</td></tr><tr><td>Family</td><td>System and Communications Protection</td></tr><tr><td>Family</td><td>System and Communications Protocols</td></tr><tr><td colspan="2">
           <p id="_">I recommend <em>this</em>.</p>
         </td></tr><tr><td>A</td><td>B</td></tr><tr><td>C</td><td>D</td></tr><tr><td colspan="2">
           <p id="_">The measurement target shall be measured as:</p>
           <formula id="_"><name>1</name>
             <stem type="AsciiMath">r/1 = 0</stem>
           </formula>
         </td></tr><tr><td colspan="2">
           <p id="_">The following code will be run for verification:</p>
           <sourcecode id="_">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
         </td></tr></tbody></table>
           </foreword></preface>
           </ogc-standard>
OUTPUT

        html = <<~OUTPUT
        #{HTML_HDR}
        <br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTestTitle'>Abstract Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>The following code will be run for verification:</p>
                     <pre id='_' class='prettyprint '>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#160;&#160;&#160; if (success)
                       <br/>
                       &#160;&#160;&#160; recommendation(label: success-response)
                       <br/>
                       &#160;&#160;&#160; end
                       <br/>
                       &#160;
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='A1' id='A1'/>
                 <thead>
                   <tr style='background:#C9C9C9;'>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTestTitle'>Abstract Test 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                                 <span style='font-style:normal;'>
  <m:r>
    <m:rPr>
      <m:sty m:val='p'/>
    </m:rPr>
    <m:t>=</m:t>
  </m:r>
</span>
                                 <m:r>
                                   <m:t>0</m:t>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         The following code will be run for verification:
                       </p>
                       <p class='Sourcecode'>
                         <a name='_' id='_'/>
                         CoreRoot(success): HttpResponse
                         <br/>
                         &#xA0;&#xA0;&#xA0; if (success)
                         <br/>
                         &#xA0;&#xA0;&#xA0; recommendation(label: success-response)
                         <br/>
                         &#xA0;&#xA0;&#xA0; end
                         <br/>
                         &#xA0; 
                       </p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
    <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="A1" type="recommendclass" keep-with-next="true" keep-lines-together="true" class="permission">







       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Permission Class 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Target Type</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/2</td></tr>

         <tr><td><p>Permission 1:</p></td><td><p>/ogc/recommendation/wfs/10</p></td></tr>

         <tr><td><p>Requirement 1-1:</p></td><td><p>Requirement 1</p></td></tr>

         <tr><td><p>Recommendation 1-1:</p></td><td><p>Recommendation 1</p></td></tr></tbody></table>

       <table id="B1" class="permission" type="recommend">

       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Permission 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/10</p></td></tr></tbody></table>

           </foreword></preface>
           </ogc-standard>
OUTPUT

html = <<~OUTPUT
#{HTML_HDR}
<br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;page-break-after: avoid;page-break-inside: avoid;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Permission Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Permission 1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>/ogc/recommendation/wfs/10</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1</p>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='B1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;page-break-after: avoid;page-break-inside: avoid;'>
                 <a name='A1' id='A1'/>
                 <thead>
                   <tr>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Permission Class 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Permission 1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>/ogc/recommendation/wfs/10</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
             <div align='center' class='table_container'>
               <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='B1' id='B1'/>
                 <thead>
                   <tr style='background:#A5A5A5;'>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Permission 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>/ogc/recommendation/wfs/10</p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
    <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="A1" type="recommendclass" class="permission">







       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Conformance Class 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Target Type</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/2</td></tr>

         <tr><td><p>Permission 1-1:</p></td><td><p>Permission 1</p></td></tr>

         <tr><td><p>Requirement 1-1:</p></td><td><p>Requirement 1</p></td></tr>

         <tr><td><p>Recommendation 1-1:</p></td><td><p>Recommendation 1</p></td></tr></tbody></table>
           </foreword></preface>
           </ogc-standard>
OUTPUT

html = <<~OUTPUT
                #{HTML_HDR}
                <br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Conformance Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Permission 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Permission 1</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1</p>
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='A1' id='A1'/>
                 <thead>
                   <tr>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Conformance Class 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Permission 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Permission 1</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
    <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="A1" type="recommendclass" class="requirement">







       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Requirement Class 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Target Type</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/2</td></tr>

         <tr><td><p>Permission 1-1:</p></td><td><p>Permission 1</p></td></tr>

         <tr><td><p>Requirement 1-1:</p></td><td><p>Requirement 1</p></td></tr>

         <tr><td><p>Recommendation 1-1:</p></td><td><p>Recommendation 1</p></td></tr></tbody></table>
           </foreword></preface>
           </ogc-standard>
OUTPUT

html = <<~OUTPUT
        #{HTML_HDR}
<br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Requirement Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Permission 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Permission 1</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1</p>
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='A1' id='A1'/>
                 <thead>
                   <tr>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Requirement Class 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Permission 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Permission 1</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
            <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="A1" type="recommendclass" class="recommendation">
         
         
         
         
         
         
         
       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Recommendation Class 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Target Type</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/2</td></tr>
         
         <tr><td><p>Permission 1-1:</p></td><td><p>Permission 1</p></td></tr>
         
         <tr><td><p>Requirement 1-1:</p></td><td><p>Requirement 1</p></td></tr>
         
         <tr><td><p>Recommendation 1-1:</p></td><td><p>Recommendation 1</p></td></tr></tbody></table>
           </foreword></preface>
           </ogc-standard>
OUTPUT

                    html = <<~OUTPUT
        #{HTML_HDR}
<br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A1' class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Recommendation Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Permission 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Permission 1</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Requirement 1</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1-1:</p>
                   </td>
                   <td style='vertical-align:top;' class='recommend'>
                     <p>Recommendation 1</p>
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='A1' id='A1'/>
                 <thead>
                   <tr>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Recommendation Class 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Permission 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Permission 1</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1-1:</p>
                     </td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
            <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A0"><title depth="1">I.<tab/>Preface</title>
           <table id="A" unnumbered="true" class="requirement" type="recommend">
         
         
         
         
         
         
         
         
         
         
       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Requirement: A New Requirement</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td colspan="2">
           <p id="_">I recommend <em>this</em>.</p>
         </td></tr><tr><td colspan="2">
           <p id="_">As for the measurement targets,</p>
         </td></tr><tr><td colspan="2">
           <p id="_">The measurement target shall be measured as:</p>
           <formula id="B"><name>1</name>
             <stem type="AsciiMath">r/1 = 0</stem>
           </formula>
         </td></tr><tr><td colspan="2">
           <p id="_">The following code will be run for verification:</p>
           <sourcecode id="_">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
         </td></tr></tbody></table>
           </foreword></preface>
           </ogc-standard>
OUTPUT

html = <<~OUTPUT
    #{HTML_HDR}
    <br/>
           <div id='A0'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='A' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Requirement: A New Requirement</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>
                       I recommend
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>As for the measurement targets,</p>
                   </td>
                 </tr>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>The following code will be run for verification:</p>
                     <pre id='_' class='prettyprint '>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#160;&#160;&#160; if (success)
                       <br/>
                       &#160;&#160;&#160; recommendation(label: success-response)
                       <br/>
                       &#160;&#160;&#160; end
                       <br/>
                       &#160;
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='A' id='A'/>
                 <thead>
                   <tr style='background:#A5A5A5;'>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Requirement: A New Requirement</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         I recommend
                         <i>this</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         As for the measurement targets,
                       </p>
                     </td>
                   </tr>
                   <tr style='background:#C9C9C9;'>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                                 <span style='font-style:normal;'>
  <m:r>
    <m:rPr>
      <m:sty m:val='p'/>
    </m:rPr>
    <m:t>=</m:t>
  </m:r>
</span>
                                 <m:r>
                                   <m:t>0</m:t>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         The following code will be run for verification:
                       </p>
                       <p class='Sourcecode'>
                         <a name='_' id='_'/>
                         CoreRoot(success): HttpResponse
                         <br/>
                         &#xA0;&#xA0;&#xA0; if (success)
                         <br/>
                         &#xA0;&#xA0;&#xA0; recommendation(label: success-response)
                         <br/>
                         &#xA0;&#xA0;&#xA0; end
                         <br/>
                         &#xA0;
                       </p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
            <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A"><title depth="1">I.<tab/>Preface</title>
           <table id="_" class="recommendation" type="recommend">
         
         
         
         
         
         
         
         
         
       <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Recommendation 1:</p></th></tr></thead><tbody><tr><td colspan="2"><p>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td colspan="2">
           <p id="_">I recommend <em>this</em>.</p>
         </td></tr><tr><td colspan="2">
           <p id="_">As for the measurement targets,</p>
         </td></tr><tr><td colspan="2">
           <p id="_">The measurement target shall be measured as:</p>
           <formula id="_"><name>1</name>
             <stem type="AsciiMath">r/1 = 0</stem>
           </formula>
         </td></tr><tr><td colspan="2">
           <p id="_">The following code will be run for verification:</p>
           <sourcecode id="_">CoreRoot(success): HttpResponse
             if (success)
             recommendation(label: success-response)
             end
           </sourcecode>
         </td></tr></tbody></table>
           </foreword></preface>
           </ogc-standard>
OUTPUT

html = <<~OUTPUT
    #{HTML_HDR}
    <br/>
           <div id='A'>
             <h1 class='ForewordTitle'>I.&#160; Preface</h1>
             <table id='_' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                     <p class='RecommendationTitle'>Recommendation 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>
                       I recommend
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>As for the measurement targets,</p>
                   </td>
                 </tr>
                 <tr>
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                   <td colspan='2' style='vertical-align:top;' class='recommend'>
                     <p id='_'>The following code will be run for verification:</p>
                     <pre id='_' class='prettyprint '>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#160;&#160;&#160; if (success)
                       <br/>
                       &#160;&#160;&#160; recommendation(label: success-response)
                       <br/>
                       &#160;&#160;&#160; end
                       <br/>
                       &#160;
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
               I.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <div align='center' class='table_container'>
               <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <a name='_' id='_'/>
                 <thead>
                   <tr style='background:#A5A5A5;'>
                     <th colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='RecommendationTitle'>Recommendation 1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         I recommend
                         <i>this</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         As for the measurement targets,
                       </p>
                     </td>
                   </tr>
                   <tr style='background:#C9C9C9;'>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
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
                                 <span style='font-style:normal;'>
                                   <m:r>
                                     <m:rPr>
                                       <m:sty m:val='p'/>
                                     </m:rPr>
                                     <m:t>=</m:t>
                                   </m:r>
                                 </span>
                                 <m:r>
                                   <m:t>0</m:t>
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
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p class='MsoNormal'>
                         <a name='_' id='_'/>
                         The following code will be run for verification:
                       </p>
                       <p class='Sourcecode'>
                         <a name='_' id='_'/>
                         CoreRoot(success): HttpResponse
                         <br/>
                         &#xA0;&#xA0;&#xA0; if (success)
                         <br/>
                         &#xA0;&#xA0;&#xA0; recommendation(label: success-response)
                         <br/>
                         &#xA0;&#xA0;&#xA0; end
                         <br/>
                         &#xA0;
                       </p>
                     </td>
                   </tr>
                 </tbody>
               </table>
             </div>
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
