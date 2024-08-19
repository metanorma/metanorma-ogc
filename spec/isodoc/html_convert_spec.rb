require "spec_helper"

RSpec.describe IsoDoc::Ogc do
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
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(html)
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
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    xml.at("//xmlns:localized-strings").remove
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
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    xml.at("//xmlns:localized-strings").remove
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
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    xml.at("//xmlns:localized-strings").remove
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
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    xml.at("//xmlns:localized-strings").remove
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
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    xml.at("//xmlns:localized-strings").remove
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
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
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
