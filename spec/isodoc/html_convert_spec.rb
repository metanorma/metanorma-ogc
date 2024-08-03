require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "orders terms in normal documents" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <ext>
      <doctype>technical-paper</doctype>
      </ext>
      <sections>
      <clause id="A" type="scope"/>
      <clause id="B"/>
      <clause id="C"/>
      <terms id="D"><title>Terms</title></terms>
      </sections>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
         <bibdata>
           <ext>
             <doctype>technical-paper</doctype>
           </ext>
           <preface>
             <clause type="toc" id="_" displayorder="1">
               <title depth="1">Contents</title>
             </clause>
           </preface>
           <sections>
             <clause id="A" type="scope" displayorder="2">
               <title>1.</title>
             </clause>
             <clause id="B" displayorder="4">
               <title>3.</title>
             </clause>
             <clause id="C" displayorder="5">
               <title>4.</title>
             </clause>
             <terms id="D" displayorder="3">
               <title depth="1">2.<tab/>Terms</title>
             </terms>
           </sections>
         </bibdata>
       </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "orders terms in engineering reports" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <ext>
      <doctype>engineering-report</doctype>
      </ext>
      <sections>
      <clause id="A" type="scope"/>
      <clause id="B"/>
      <clause id="C"/>
      <terms id="D"><title>Terms</title></terms>
      </sections>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
         <bibdata>
           <ext>
             <doctype>engineering-report</doctype>
           </ext>
           <preface>
             <clause type="toc" id="_" displayorder="1">
               <title depth="1">Contents</title>
             </clause>
           </preface>
           <sections>
             <clause id="A" type="scope" displayorder="2">
               <title>1.</title>
             </clause>
             <clause id="B" displayorder="3">
               <title>2.</title>
             </clause>
             <clause id="C" displayorder="4">
               <title>3.</title>
             </clause>
             <terms id="D" displayorder="5">
               <title depth="1">
                 4.
                 <tab/>
                 Terms
               </title>
             </terms>
           </sections>
         </bibdata>
       </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes pre" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
        #{METANORMA_EXTENSION}
      <preface>
      <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
      <foreword id="A" displayorder="2"><title>Preface</title>
      <pre>ABC</pre>
      </foreword></preface>
      </ogc-standard>
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{HTML_HDR}
               <br/>
               <div id="A">
                 <h1 class="ForewordTitle">Preface</h1>
                 <pre>ABC</pre>
               </div>
             </div>
           </body>
    OUTPUT

    expect(Xml::C14n.format(
             IsoDoc::Ogc::HtmlConvert.new({})
             .convert("test", input, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to output
  end

  it "processes simple terms & definitions" do
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata/>
        #{METANORMA_EXTENSION}
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
      <bibdata/>
        #{METANORMA_EXTENSION}
        <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause></preface>
        <sections>
        <terms id="H" obligation="normative" displayorder='2'><title depth='1'>1.<tab/>Terms, Definitions, Symbols and Abbreviated Terms</title>
          <term id="J">
          <name>1.1.</name>
          <preferred>Term2</preferred>
          <admitted>Term2A&#xa0;<span class="AdmittedLabel">ALTERNATIVE</span></admitted>
          <admitted>Term2B&#xa0;<span class="AdmittedLabel">ALTERNATIVE</span></admitted>
          <deprecates>Term2C&#xa0;<span class="DeprecatedLabel">DEPRECATED</span></deprecates>
          <deprecates>Term2D&#xa0;<span class="DeprecatedLabel">DEPRECATED</span></deprecates>
          <termsource status='modified'>[<strong>SOURCE:</strong>
                 <origin bibitemid='ISO7301' type='inline' citeas='ISO 7301:2011'>
                   <locality type='clause'>
                     <referenceFrom>3.1</referenceFrom>
                   </locality>
                   ISO&#xa0;7301:2011, Clause 3.1
                 </origin>, modified &#x2014; The term "cargo rice" is shown as deprecated, and
                 Note 1 to entry is not included here]
               </termsource>
        </term>
         </terms>
         </sections>
         </ogc-standard>
    INPUT

    output = Xml::C14n.format(<<~OUTPUT)
       <div id="H">
         <h1 id="_">
           <a class="anchor" href="#H"/>
           <a class="header" href="#H">1.  Terms, Definitions, Symbols and Abbreviated Terms</a>
         </h1>
         <div id="J">
           <h2 class="TermNum" style="text-align:left;" id="_">
             <a class="anchor" href="#J"/>
             <a class="header" href="#J">1.1. Term2</a>
           </h2>
         </div>
         <p class="AltTerms" style="text-align:left;">
           Term2A 
           <span class="AdmittedLabel">ALTERNATIVE</span>
         </p>
         <p class="AltTerms" style="text-align:left;">
           Term2B 
           <span class="AdmittedLabel">ALTERNATIVE</span>
         </p>
         <p class="DeprecatedTerms" style="text-align:left;">
           Term2C 
           <span class="AdmittedLabel">DEPRECATED</span>
         </p>
         <p class="DeprecatedTerms" style="text-align:left;">
           Term2D 
           <span class="AdmittedLabel">DEPRECATED</span>
         </p>
         <p>
           [
           <b>SOURCE:</b>
           ISO 7301:2011, Clause 3.1 , modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
         </p>
       </div>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    xml = Nokogiri::XML(File.read("test.html"))
    xml = xml.at("//div[@id = 'H']")
    expect(Xml::C14n.format(strip_guid(xml.to_xml))).to be_equivalent_to output
  end

  it "processes requirement and requirement test" do
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata/>
        #{METANORMA_EXTENSION}
           <preface>
            <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
             <foreword id='A' displayorder="2">
               <title depth='1'>I.<tab/>Preface</title>
                               <table id="A1" class="modspec" type="recommend">
            <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Permission 1</p></th></tr></thead>
            <tbody>
              <tr><th>Identifier</th><td><tt>/ogc/recommendation/wfs/2</tt></td></tr>
              <tr><th>Subject</th><td>user</td></tr>
              <tr><th>Prerequisites</th><td>/ss/584/2015/level/1<br/>
              <xref type="inline" target="rfc2616">RFC 2616 (HTTP/1.1)</xref></td></tr>
            <tr>
        <th>Control-CLASS</th>
        <td>Technical</td>
      </tr>
      <tr>
        <th>Priority</th>
        <td>P0</td>
      </tr>
      <tr>
        <th>Family</th>
        <td>System and Communications Protection<br/>System and Communications Protocols</td>
      </tr>
      <tr>
      <th>Statement</th>
        <td>
          <p id='_'>I recommend <em>this</em>.</p>
        </td>
      </tr>
      <tr>
        <th>A</th>
        <td>B</td>
      </tr>
      <tr>
        <th>C</th>
        <td>D</td>
      </tr>
      <tr>
        <td colspan='2'>
          <p id='_'>The measurement target shall be measured as:</p>
          <formula id='_'>
            <name>1</name>
            <stem type='AsciiMath'>r/1 = 0</stem>
          </formula>
        </td>
      </tr>
      <tr>
        <td colspan='2'>
          <p id='_'>The following code will be run for verification:</p>
          <sourcecode id="_">CoreRoot(success): HttpResponse
            if (success)
            recommendation(label: success-response)
            end
          </sourcecode>
        </td>
      </tr>
      </tbody></table>
               <table id='A2' class='modspec' type='recommendtest'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTestTitle'>Conformance test 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                 <th>Identifier</th>
                <td><tt>/ogc/recommendation/wfs/2</tt></td>
                </tr>
                 <tr>
                   <th>Subject</th>
                   <td>user</td>
                 </tr>
                 <tr>
                   <th>Prerequisite</th>
                   <td>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <th>Control-class</th>
                   <td>Technical</td>
                 </tr>
                 <tr>
                   <th>Priority</th>
                   <td>P0</td>
                 </tr>
                 <tr>
                   <th>Family</th>
                   <td>System and Communications Protection<br/>
                   System and Communications Protocols</td>
                 </tr>
                 <tr>
                 <th>Description</th>
                 <td>
                     <p id='_'>
                       I recommend
                       <em>this</em>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <th>A</th>
                   <td>B</td>
                 </tr>
                 <tr>
                   <th>C</th>
                   <td>D</td>
                 </tr>
                 <tr>
                   <td colspan="2">
                     <p id='_'>The measurement target shall be measured as:</p>
                     <formula id='_'>
                       <name>1</name>
                       <stem type='AsciiMath'>r/1 = 0</stem>
                     </formula>
                   </td>
                 </tr>
                 <tr>
                   <td colspan='2'>
                     <p id='_'>The following code will be run for verification:</p>
                     <sourcecode id='_'>
                       CoreRoot(success): HttpResponse if (success)
                       recommendation(label: success-response) end
                     </sourcecode>
                   </td>
                 </tr>
               </tbody>
             </table>
             </foreword>
           </preface>
         </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      <div id="A">
         <h1 class="ForewordTitle" id="_">
           <a class="anchor" href="#A"/>
           <a class="header" href="#A">I.  Preface</a>
         </h1>
         <table id="A1" class="modspec" style="border-width:1px;border-spacing:0;">
           <thead>
             <tr>
               <th colspan="2" style="font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;" scope="colgroup">
                 <p class="RecommendationTitle">
                   <a class="anchor" href="#A1"/>
                   <a class="header" href="#A1">Permission 1</a>
                 </p>
               </th>
             </tr>
           </thead>
           <tbody>
             <tr>
               <th style="font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="row">Identifier</th>
               <td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">
                 <tt>/ogc/recommendation/wfs/2</tt>
               </td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Subject</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">user</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Prerequisites</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">
                 /ss/584/2015/level/1
                 <br/>
                 <a href="#rfc2616">RFC 2616 (HTTP/1.1)</a>
               </td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Control-CLASS</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">Technical</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Priority</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">P0</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Family</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">
                 System and Communications Protection
                 <br/>
                 System and Communications Protocols
               </td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Statement</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">
                 <p id="_">
                   I recommend
                   <i>this</i>
                   .
                 </p>
               </td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">A</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">B</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">C</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">D</td>
             </tr>
             <tr>
               <td colspan="2" style="border-top:none;border-bottom:solid windowtext 1.0pt;">
                 <p id="_">The measurement target shall be measured as:</p>
                 <div id="_">
                   <div class="formula">
                     <p>
                       <span class="stem">(#(r/1 = 0)#)</span>
                         (1)
                     </p>
                   </div>
                 </div>
               </td>
             </tr>
             <tr>
               <td colspan="2" style="border-top:none;border-bottom:solid windowtext 1.5pt;">
                 <p id="_">The following code will be run for verification:</p>
                 <pre id="_" class="sourcecode">
                   CoreRoot(success): HttpResponse
                   <br/>
                         if (success)
                   <br/>
                         recommendation(label: success-response)
                   <br/>
                         end
                   <br/>
                      
                 </pre>
               </td>
             </tr>
           </tbody>
         </table>
         <table id="A2" class="modspec" style="border-width:1px;border-spacing:0;">
           <thead>
             <tr>
               <th colspan="2" style="font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;" scope="colgroup">
                 <p class="RecommendationTestTitle">
                   <a class="anchor" href="#A2"/>
                   <a class="header" href="#A2">Conformance test 1</a>
                 </p>
               </th>
             </tr>
           </thead>
           <tbody>
             <tr>
               <th style="font-weight:bold;border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;" scope="row">Identifier</th>
               <td style="border-top:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;">
                 <tt>/ogc/recommendation/wfs/2</tt>
               </td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Subject</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">user</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Prerequisite</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">/ss/584/2015/level/1</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Control-class</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">Technical</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Priority</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">P0</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Family</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">
                 System and Communications Protection
                 <br/>
                 System and Communications Protocols
               </td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">Description</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">
                 <p id="_">
                   I recommend
                   <i>this</i>
                   .
                 </p>
               </td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">A</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">B</td>
             </tr>
             <tr>
               <th style="font-weight:bold;border-top:none;border-bottom:solid windowtext 1.0pt;" scope="row">C</th>
               <td style="border-top:none;border-bottom:solid windowtext 1.0pt;">D</td>
             </tr>
             <tr>
               <td colspan="2" style="border-top:none;border-bottom:solid windowtext 1.0pt;">
                 <p id="_">The measurement target shall be measured as:</p>
                 <div id="_">
                   <div class="formula">
                     <p>
                       <span class="stem">(#(r/1 = 0)#)</span>
                         (1)
                     </p>
                   </div>
                 </div>
               </td>
             </tr>
             <tr>
               <td colspan="2" style="border-top:none;border-bottom:solid windowtext 1.5pt;">
                 <p id="_">The following code will be run for verification:</p>
                 <pre id="_" class="sourcecode">
                   <br/>
                                    CoreRoot(success): HttpResponse if (success)
                   <br/>
                                    recommendation(label: success-response) end
                   <br/>
                                 
                 </pre>
               </td>
             </tr>
           </tbody>
         </table>
       </div>
    OUTPUT
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    xml = Nokogiri::XML(File.read("test.html"))
    xml = xml.at("//div[@id = 'A']")
    expect(Xml::C14n.format(strip_guid(xml.to_xml))).to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes admonitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata/>
              #{METANORMA_EXTENSION}
          <preface><foreword id="A"><title>Preface</title>
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="caution">
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata/>
              #{METANORMA_EXTENSION}
           <preface>
            <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
             <foreword id='A' displayorder="2">
               <title depth='1'>I.<tab/>Preface</title>
               <admonition id='_' type='caution'>
               <name>CAUTION</name>
                 <p id='_'>Only use paddy or parboiled rice for the determination of husked rice yield.</p>
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
                <div  id="_" class="Admonition Caution"><p class="AdmonitionTitle" style="text-align:center;">CAUTION</p>
        <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </div>
              </div>
            </div>
          </body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes warning admonitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata/>
              #{METANORMA_EXTENSION}
          <preface><foreword id="A"><title>Preface</title>
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="warning">
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata/>
              #{METANORMA_EXTENSION}
           <preface>
            <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
             <foreword id='A' displayorder="2">
               <title depth='1'>I.<tab/>Preface</title>
               <admonition id='_' type='warning'>
               <name>WARNING</name>
                 <p id='_'>Only use paddy or parboiled rice for the determination of husked rice yield.</p>
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
                <div id="_" class="Admonition Warning"><p class="AdmonitionTitle" style="text-align:center;">WARNING</p>
        <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </div>
              </div>
            </div>
          </body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes important admonitions" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata/>
              #{METANORMA_EXTENSION}
          <preface><foreword id="A"><title>Preface</title>
          <admonition id="_70234f78-64e5-4dfc-8b6f-f3f037348b6a" type="important">
        <p id="_e94663cc-2473-4ccc-9a72-983a74d989f2">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </admonition>
          </foreword></preface>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata/>
              #{METANORMA_EXTENSION}
           <preface>
            <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
             <foreword id='A' displayorder="2">
               <title depth='1'>I.<tab/>Preface</title>
               <admonition id='_' type='important'>
               <name>IMPORTANT</name>
                 <p id='_'>Only use paddy or parboiled rice for the determination of husked rice yield.</p>
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
                <div  id="_" class="Admonition Important"><p class="AdmonitionTitle" style="text-align:center;">IMPORTANT</p>
        <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
      </div>
              </div>
            </div>
          </body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes examples with titles" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata/>
              #{METANORMA_EXTENSION}
          <preface><foreword id="A"><title>Preface</title>
                <example id="_"><name>Example Title</name><p id="_">This is an example</p>
      <p id="_">Amen</p></example>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata/>
              #{METANORMA_EXTENSION}
        <preface>
         <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
          <foreword id='A' displayorder="2"><title depth='1'>I.<tab/>Preface</title>
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
          </div>
        </body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes examples without titles" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata/>
              #{METANORMA_EXTENSION}
          <preface><foreword id="A">
                <example id="_"><p id="_">This is an example</p>
      <p id="_">Amen</p></example>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata/>
              #{METANORMA_EXTENSION}
        <preface>
         <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
          <foreword id='A' displayorder="2"><title>I.</title>
            <example id='_'>
              <name>Example</name>
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
          </div>
        </body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes figures and sourcecode" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata/>
              #{METANORMA_EXTENSION}
          <preface><foreword id="A">
                <figure id="B"><p id="_">This is an example</p></figure>
                <figure id="C" class="pseudocode"><p id="_">This is an example</p></figure>
                <sourcecode id="D"><p id="_">This is an example</p></sourcecode>
          </foreword></preface>
          </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         <bibdata/>
              #{METANORMA_EXTENSION}
         <preface>
           <clause type="toc" id="_" displayorder="1">
             <title depth="1">Contents</title>
           </clause>
           <foreword id="A" displayorder="2">
             <title>I.</title>
             <figure id="B">
               <name>Figure 1</name>
               <p id="_">This is an example</p>
             </figure>
             <figure id="C" class="pseudocode">
               <name>Listing 1</name>
               <p id="_">This is an example</p>
             </figure>
             <sourcecode id="D">
               <name>Listing 2</name>
               <p id="_">This is an example</p>
             </sourcecode>
           </foreword>
         </preface>
       </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      #{HTML_HDR}
              <br/>
              <div id="A">
             <h1 class="ForewordTitle">I.</h1>
             <div id="B" class="figure">
               <p id="_">This is an example</p>
               <p class="FigureTitle" style="text-align:center;">Figure 1</p>
             </div>
             <div id="C" class="pseudocode">
               <p id="_">This is an example</p>
               <p class="SourceTitle" style="text-align:center;">Listing 1</p>
             </div>
             <pre id="D" class="sourcecode">
               <br/>
                       
               <br/>
                       
               <p id="_">This is an example</p>
               <br/>
                     
             </pre>
             <p class="SourceTitle" style="text-align:center;">Listing 2</p>
           </div>
         </div>
       </body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
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
              #{METANORMA_EXTENSION}
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
         <submitters type="contributors" obligation="informative" id="3a">
         <title>Contributors</title>
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
              #{METANORMA_EXTENSION}
        <preface>
          <clause type="toc" id="_" displayorder="1">
            <title depth="1">Contents</title>
          </clause>
          <abstract obligation="informative" id="1" displayorder="2">
            <title depth="1">
              I.
              <tab/>
              Abstract
            </title>
            <p>XYZ</p>
          </abstract>
          <clause id="DD0" obligation="normative" type="executivesummary" displayorder="3">
            <title depth="1">
              II.
              <tab/>
              Executive Summary
            </title>
            <p id="EE0">Text</p>
          </clause>
          <clause id="_" type="keywords" displayorder="4">
            <title depth="1">
              III.
              <tab/>
              Keywords
            </title>
            <p>The following are keywords to be used by search engines and document catalogues.</p>
            <p>A, B</p>
          </clause>
          <foreword obligation="informative" id="2" displayorder="5">
            <title depth="1">
              IV.
              <tab/>
              Preface
            </title>
            <p id="A">This is a preamble</p>
          </foreword>
          <clause id="DD1" obligation="normative" type="security" displayorder="6">
            <title depth="1">
              V.
              <tab/>
              Security
            </title>
            <p id="EE1">Text</p>
          </clause>
          <clause id="_" type="submitting_orgs" displayorder="7">
            <title depth="1">
              VI.
              <tab/>
              Submitting Organizations
            </title>
            <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
            <ul>
              <li>OGC</li>
              <li>DEF</li>
            </ul>
          </clause>
          <submitters obligation="informative" id="3" displayorder="8">
            <title depth="1">
              VII.
              <tab/>
              Submitters
            </title>
            <p>ABC</p>
          </submitters>
          <submitters type="contributors" obligation="informative" id="3a" displayorder="9">
            <title depth="1">
              VIII.
              <tab/>
              Contributors
            </title>
            <p>ABC</p>
          </submitters>
          <clause id="5" displayorder="10">
            <title depth="1">
              IX.
              <tab/>
              Dedication
            </title>
            <clause id="6">
              <title depth="2">
                IX.A.
                <tab/>
                Note to readers
              </title>
            </clause>
          </clause>
          <acknowledgements obligation="informative" id="4" displayorder="11">
            <title depth="1">
              X.
              <tab/>
              Acknowlegements
            </title>
            <p>ABC</p>
          </acknowledgements>
        </preface>
        <sections>
          <clause id="D" obligation="normative" type="scope" displayorder="12">
            <title depth="1">
              1.
              <tab/>
              Scope
            </title>
            <p id="E">Text</p>
          </clause>
          <clause id="D1" obligation="normative" type="conformance" displayorder="13">
            <title depth="1">
              2.
              <tab/>
              Conformance
            </title>
            <p id="E1">Text</p>
          </clause>
          <clause id="H" obligation="normative" displayorder="15">
            <title depth="1">
              4.
              <tab/>
              Terms, definitions, symbols and abbreviated terms
            </title>
            <terms id="I" obligation="normative">
              <title depth="2">
                4.1.
                <tab/>
                Normal Terms
              </title>
              <term id="J">
                <name>4.1.1.</name>
                <preferred>Term2</preferred>
              </term>
            </terms>
            <definitions id="K">
              <title depth="2">
                4.2.
                <tab/>
                Definitions
              </title>
              <dl>
                <dt>Symbol</dt>
                <dd>Definition</dd>
              </dl>
            </definitions>
          </clause>
          <definitions id="L" displayorder="16">
            <title depth="1">
              5.
              <tab/>
              Definitions
            </title>
            <dl>
              <dt>Symbol</dt>
              <dd>Definition</dd>
            </dl>
          </definitions>
          <clause id="M" inline-header="false" obligation="normative" displayorder="17">
            <title depth="1">
              6.
              <tab/>
              Clause 4
            </title>
            <clause id="N" inline-header="false" obligation="normative">
              <title depth="2">
                6.1.
                <tab/>
                Introduction
              </title>
            </clause>
            <clause id="O" inline-header="false" obligation="normative">
              <title depth="2">
                6.2.
                <tab/>
                Clause 4.2
              </title>
            </clause>
          </clause>
          <references id="R" obligation="informative" normative="true" displayorder="14">
            <title depth="1">
              3.
              <tab/>
              Normative References
            </title>
          </references>
        </sections>
        <annex id="P" inline-header="false" obligation="normative" displayorder="18">
          <title>
            <strong>Annex A</strong>
            <br/>
            (normative)
            <br/>
            <strong>Annex</strong>
          </title>
          <clause id="Q" inline-header="false" obligation="normative">
            <title depth="2">
              A.1.
              <tab/>
              Annex A.1
            </title>
            <clause id="Q1" inline-header="false" obligation="normative">
              <title depth="3">
                A.1.1.
                <tab/>
                Annex A.1a
              </title>
            </clause>
          </clause>
        </annex>
        <annex id="PP" obligation="normative" displayorder="19">
          <title>
            <strong>Annex B</strong>
            <br/>
            (normative)
            <br/>
            <strong>Glossary</strong>
          </title>
          <terms id="PP1" obligation="normative">
            <term id="term-glossary">
              <name>B.1.</name>
              <preferred>Glossary</preferred>
            </term>
          </terms>
        </annex>
        <annex id="QQ" obligation="normative" displayorder="20">
          <title>
            <strong>Annex C</strong>
            <br/>
            (normative)
            <br/>
            <strong>Glossary</strong>
          </title>
          <terms id="QQ1" obligation="normative">
            <title depth="2">
              C.1.
              <tab/>
              Term Collection
            </title>
            <term id="term-term-1">
              <name>C.1.1.</name>
              <preferred>Term</preferred>
            </term>
          </terms>
          <terms id="QQ2" obligation="normative">
            <title depth="2">
              C.2.
              <tab/>
              Term Collection 2
            </title>
            <term id="term-term-2">
              <name>C.2.1.</name>
              <preferred>Term</preferred>
            </term>
          </terms>
        </annex>
        <bibliography>
          <clause id="S" obligation="informative" displayorder="21">
            <title depth="1">Bibliography</title>
            <references id="T" obligation="informative" normative="false">
              <title depth="2">Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </ogc-standard>
    OUTPUT

    output = Xml::C14n.format(<<~"OUTPUT")
            #{HTML_HDR}
          <br/>
          <div id="1">
            <h1 class="AbstractTitle">
              I.
               
              Abstract
            </h1>
            <p>XYZ</p>
          </div>
          <div class="Section3" id="DD0">
            <h1 class="IntroTitle">
              II.
               
              Executive Summary
            </h1>
            <p id="EE0">Text</p>
          </div>
          <div class="Section3" id="_">
            <h1 class="IntroTitle">
              III.
               
              Keywords
            </h1>
            <p>The following are keywords to be used by search engines and document catalogues.</p>
            <p>A, B</p>
          </div>
          <br/>
          <div id="2">
            <h1 class="ForewordTitle">
              IV.
               
              Preface
            </h1>
            <p id="A">This is a preamble</p>
          </div>
          <div class="Section3" id="DD1">
            <h1 class="IntroTitle">
              V.
               
              Security
            </h1>
            <p id="EE1">Text</p>
          </div>
          <div class="Section3" id="_">
            <h1 class="IntroTitle">
              VI.
               
              Submitting Organizations
            </h1>
            <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
            <div class="ul_wrap">
              <ul>
                <li>OGC</li>
                <li>DEF</li>
              </ul>
            </div>
          </div>
          <div class="Section3" id="3">
            <h1 class="IntroTitle">
              VII.
               
              Submitters
            </h1>
            <p>ABC</p>
          </div>
          <div class="Section3" id="3a">
            <h1 class="IntroTitle">
              VIII.
               
              Contributors
            </h1>
            <p>ABC</p>
          </div>
          <div class="Section3" id="5">
            <h1 class="IntroTitle">
              IX.
               
              Dedication
            </h1>
            <div id="6">
              <h2>
                IX.A.
                 
                Note to readers
              </h2>
            </div>
          </div>
          <div class="Section3" id="4">
            <h1 class="IntroTitle">
              X.
               
              Acknowlegements
            </h1>
            <p>ABC</p>
          </div>
          <div id="D">
            <h1>
              1.
               
              Scope
            </h1>
            <p id="E">Text</p>
          </div>
          <div id="D1">
            <h1>
              2.
               
              Conformance
            </h1>
            <p id="E1">Text</p>
          </div>
          <div>
            <h1>
              3.
               
              Normative References
            </h1>
          </div>
          <div id="H">
            <h1>
              4.
               
              Terms, definitions, symbols and abbreviated terms
            </h1>
            <div id="I">
              <h2>
                4.1.
                 
                Normal Terms
              </h2>
              <p class="TermNum" id="J">4.1.1.</p>
              <p class="Terms" style="text-align:left;">Term2</p>
            </div>
            <div id="K">
              <h2>
                4.2.
                 
                Definitions
              </h2>
              <div class="figdl">
                <dl>
                  <dt>
                    <p>Symbol</p>
                  </dt>
                  <dd>Definition</dd>
                </dl>
              </div>
            </div>
          </div>
          <div id="L" class="Symbols">
            <h1>
              5.
               
              Definitions
            </h1>
            <div class="figdl">
              <dl>
                <dt>
                  <p>Symbol</p>
                </dt>
                <dd>Definition</dd>
              </dl>
            </div>
          </div>
          <div id="M">
            <h1>
              6.
               
              Clause 4
            </h1>
            <div id="N">
              <h2>
                6.1.
                 
                Introduction
              </h2>
            </div>
            <div id="O">
              <h2>
                6.2.
                 
                Clause 4.2
              </h2>
            </div>
          </div>
          <br/>
          <div id="P" class="Section3">
            <h1 class="Annex">
              <b>Annex A</b>
              <br/>
              (normative)
              <br/>
              <b>Annex</b>
            </h1>
            <div id="Q">
              <h2>
              A.1.
               
              Annex A.1
            </h2>
              <div id="Q1">
                <h3>
                A.1.1.
                 
                Annex A.1a
              </h3>
              </div>
            </div>
          </div>
          <br/>
          <div id="PP" class="Section3">
            <h1 class="Annex">
              <b>Annex B</b>
              <br/>
              (normative)
              <br/>
              <b>Glossary</b>
            </h1>
            <div id="PP1">
              <p class="TermNum" id="term-glossary">B.1.</p>
              <p class="Terms" style="text-align:left;">Glossary</p>
            </div>
          </div>
          <br/>
          <div id="QQ" class="Section3">
            <h1 class="Annex">
              <b>Annex C</b>
              <br/>
              (normative)
              <br/>
              <b>Glossary</b>
            </h1>
            <div id="QQ1">
              <h2>
              C.1.
               
              Term Collection
            </h2>
              <p class="TermNum" id="term-term-1">C.1.1.</p>
              <p class="Terms" style="text-align:left;">Term</p>
            </div>
            <div id="QQ2">
              <h2>
              C.2.
               
              Term Collection 2
            </h2>
              <p class="TermNum" id="term-term-2">C.2.1.</p>
              <p class="Terms" style="text-align:left;">Term</p>
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

    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(
             IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to output
  end

  it "processes hi" do
    presxml = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
              #{METANORMA_EXTENSION}
          <preface> <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
        <foreword id="A" displayorder="2"><title>Preface</title>
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
          </div>
        </body>
    OUTPUT

    doc = <<~OUTPUT
      <body lang='EN-US' link='blue' vlink='#954F72'>
           <div class='WordSection1'>
             <p>&#160;</p>
           </div>
           <p class="section-break">
             <br clear='all' class='section'/>
           </p>
           <div class='WordSection2'>
             <p class="page-break">
               <br clear='all' style='mso-special-character:line-break;page-break-before:always'/>
             </p>
                 <div class="TOC" id="_">
            <p class="zzContents">Contents</p>
          </div>
          <p class="page-break">
            <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
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
           <p class="section-break">
             <br clear='all' class='section'/>
           </p>
           <div class='WordSection3'>
           </div>
         </body>
    OUTPUT
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(IsoDoc::Ogc::WordConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(doc)
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
    output = Xml::C14n.format(<<~"OUTPUT")
          #{blank_hdr_gen}
          <preface>#{SECURITY}</preface>
      <sections/>
      </ogc-standard>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor
      .convert(input, backend: :ogc, header_footer: true))))
      .to be_equivalent_to Xml::C14n.format(output)
    html = File.read("test.html", encoding: "utf-8")
    expect(html).to match(%r{jquery\.min\.js})
    expect(html).to match(%r{Overpass})
  end

  it "processes preprocessing XSLT" do
    input = <<~INPUT
      <iso-standard xmlns="https://www.metanorma.org/ns/ogc">
      <bibdata/>
              #{METANORMA_EXTENSION}
      <preface>
      <foreword id="A">
      <note id="B"><p>Hello</p></note>
      </foreword>
      </preface>
      <sections>
      <clause id="C"><title>Clause</title>
      <note id="D"><p>Hello</p></note>
      </clause>
      </sections>
      </iso-standard>
    INPUT
    presxml = <<~OUTPUT
      <iso-standard xmlns="https://www.metanorma.org/ns/ogc" type="presentation">
                     <bibdata/>
               <metanorma-extension>
                       #{METANORMA_EXTENSION.gsub(%r{</?metanorma-extension>}, '')}
                 <render>
                 <preprocess-xslt>
        <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mn="https://www.metanorma.org/ns/ogc" version="1.0">
          <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
          <xsl:preserve-space elements="*"/>
          <xsl:template match="@* | node()">
            <xsl:copy><xsl:apply-templates select="@* | node()"/></xsl:copy>
          </xsl:template>
          <xsl:template match="mn:note/mn:name">
            <xsl:copy><xsl:apply-templates select="@*|node()"/><xsl:if test="normalize-space() != ''">:<mn:tab/></xsl:if></xsl:copy>
          </xsl:template>
        </xsl:stylesheet>
      </preprocess-xslt>
                 </render>
               </metanorma-extension>
              <preface>
                  <clause type="toc" id="_" displayorder="1"> <title depth="1">Contents</title> </clause>
                <foreword id="A" displayorder="2">
                  <title>I.</title>
                  <note id="B">
                    <name>NOTE</name>
                    <p>Hello</p>
                  </note>
                </foreword>
              </preface>
              <sections>
                <clause id="C" displayorder="3">
                  <title depth="1">
                    1.
                    <tab/>
                    Clause
                  </title>
                  <note id="D">
                    <name>NOTE</name>
                    <p>Hello</p>
                  </note>
                </clause>
              </sections>
            </iso-standard>
    OUTPUT
    html = <<~OUTPUT
      <body lang="EN-US" link="blue" vlink="#954F72" xml:lang="EN-US" class="container"><div class="title-section"><p> </p></div><br/><div class="prefatory-section"><p> </p></div><br/><div class="main-section">    <br/>
        <div class="TOC" id="_">
          <h1 class="IntroTitle">Contents</h1>
        </div>
        <br/><div id="A"><h1 class="ForewordTitle">I.</h1><div id="B" class="Note"><p><span class="note_label">NOTE:  </span>  Hello</p></div></div><div id="C"><h1>
          1.
           
          Clause
        </h1><div id="D" class="Note"><p><span class="note_label">NOTE:  </span>  Hello</p></div></div></div></body>
    OUTPUT
    word = <<~OUTPUT
      <body lang="EN-US" link="blue" vlink="#954F72"><div class="WordSection1"><p> </p></div><p class="section-break"><br clear="all" class="section"/></p><div class="WordSection2"><p class="page-break"><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
          <div class="TOC" id="_">
      <p class="zzContents">Contents</p>
      </div>
      <p class="page-break">
       <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
        <div id="A"><h1 class="ForewordTitle">I.</h1><div id="B" class="Note"><p class="Note"><span class="note_label">NOTE:<span style="mso-tab-count:1">  </span></span><span style="mso-tab-count:1">  </span>Hello</p></div></div><p> </p></div><p class="section-break"><br clear="all" class="section"/></p><div class="WordSection3"><div id="C"><h1>
          1.
          <span style="mso-tab-count:1">  </span>
          Clause
        </h1><div id="D" class="Note"><p class="Note"><span class="note_label">NOTE:<span style="mso-tab-count:1">  </span></span><span style="mso-tab-count:1">  </span>Hello</p></div></div></div></body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(
             IsoDoc::Ogc::HtmlConvert.new({}).convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(
             IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to Xml::C14n.format(word)
  end
end
