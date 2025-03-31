require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "processes pre" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
       #{METANORMA_EXTENSION}
      <preface>
      <clause type="toc" id="_" displayorder="1"> <fmt-title depth="1">Contents</fmt-title> </clause>
      <foreword id="A" displayorder="2"><fmt-title>Preface</fmt-title>
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

    expect(Xml::C14n.format(strip_guid(
                              IsoDoc::Ogc::HtmlConvert.new({})
                              .convert("test", input, true)
                              .gsub(%r{^.*<body}m, "<body")
                              .gsub(%r{</body>.*}m, "</body>"),
                            ))).to be_equivalent_to output
  end

  it "processes requirement and requirement test" do
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
      <bibdata/>
       #{METANORMA_EXTENSION}
           <preface>
            <clause type="toc" id="_" displayorder="1"> <fmt-title depth="1">Contents</fmt-title> </clause>
             <foreword id='A' displayorder="2">
               <fmt-title depth='1'>I.<tab/>Preface</fmt-title>
                               <table id="A1" class="modspec" type="recommend">
            <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Permission 1</p></th></tr></thead>
            <tbody>
              <tr><th>Identifier</th><td><tt>/ogc/recommendation/wfs/2</tt></td></tr>
              <tr><th>Subject</th><td>user</td></tr>
              <tr><th>Prerequisites</th><td>/ss/584/2015/level/1<br/>
              <fmt-xref type="inline" target="rfc2616">RFC 2616 (HTTP/1.1)</fmt-xref></td></tr>
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
            <fmt-name>(1)</fmt-name>
            <fmt-stem type='AsciiMath'>r/1 = 0</fmt-stem>
          </formula>
        </td>
      </tr>
      <tr>
        <td colspan='2'>
          <p id='_'>The following code will be run for verification:</p>
          <sourcecode id="_"><fmt-sourcecode>CoreRoot(success): HttpResponse
            if (success)
            recommendation(label: success-response)
            end
          </fmt-sourcecode></sourcecode>
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
                       <fmt-name>(1)</fmt-name>
                       <fmt-stem type='AsciiMath'>r/1 = 0</fmt-stem>
                     </formula>
                   </td>
                 </tr>
                 <tr>
                   <td colspan='2'>
                     <p id='_'>The following code will be run for verification:</p>
                     <sourcecode id='_'><fmt-sourcecode>
                       CoreRoot(success): HttpResponse if (success)
                       recommendation(label: success-response) end
                     </fmt-sourcecode></sourcecode>
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
                      <p class="collapsible active"> </p>
                      <pre id="_" class="sourcecode hidable">
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
                      <p class="collapsible active"> </p>
                      <pre id="_" class="sourcecode hidable">
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
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <foreword id="A" displayorder="2">
                <title id="_">Preface</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Preface</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="A">Preface</semx>
                </fmt-xref-label>
                <admonition id="_" type="caution">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">CAUTION</span>
                      </span>
                   </fmt-name>
                   <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
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
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))))
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
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <foreword id="A" displayorder="2">
                <title id="_">Preface</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Preface</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="A">Preface</semx>
                </fmt-xref-label>
                <admonition id="_" type="warning">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">WARNING</span>
                      </span>
                   </fmt-name>
                   <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
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
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))))
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
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <foreword id="A" displayorder="2">
                <title id="_">Preface</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Preface</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="A">Preface</semx>
                </fmt-xref-label>
                <admonition id="_" type="important">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">IMPORTANT</span>
                      </span>
                   </fmt-name>
                   <p id="_">Only use paddy or parboiled rice for the determination of husked rice yield.</p>
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
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))))
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
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <foreword id="A" displayorder="2">
                 <title id="_">Preface</title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="A">I</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">Preface</semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <semx element="title" source="A">Preface</semx>
                 </fmt-xref-label>
                 <example id="_" autonum="">
                    <name id="_">Example Title</name>
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Example</span>
                       </span>
                       <span class="fmt-caption-delim"> — </span>
                       <semx element="name" source="_">Example Title</semx>
                    </fmt-name>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Example</span>
                    </fmt-xref-label>
            <fmt-xref-label container="A">
               <span class="fmt-xref-container">
                  <semx element="title" source="A">Preface</semx>
               </span>
               <span class="fmt-comma">,</span>
               <span class="fmt-element-name">Example</span>
            </fmt-xref-label>
                    <p id="_">This is an example</p>
                    <p id="_">Amen</p>
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
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes examples without titles" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
      <bibdata/>
       #{METANORMA_EXTENSION}
          <preface><foreword id="A">
                   <title depth="1">
            Preface
         </title>
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
              <clause type="toc" id="_" displayorder="1">
                 <fmt-title depth="1">Contents</fmt-title>
              </clause>
              <foreword id="A" displayorder="2">
                 <title depth="1" id="_">
              Preface
           </title>
                 <fmt-title depth="1">
                    <span class="fmt-caption-label">
                       <semx element="autonum" source="A">I</semx>
                       <span class="fmt-autonum-delim">.</span>
                    </span>
                    <span class="fmt-caption-delim">
                       <tab/>
                    </span>
                    <semx element="title" source="_">
              Preface
           </semx>
                 </fmt-title>
                 <fmt-xref-label>
                    <semx element="title" source="A">
              Preface
           </semx>
                 </fmt-xref-label>
                 <example id="_" autonum="">
                    <fmt-name>
                       <span class="fmt-caption-label">
                          <span class="fmt-element-name">Example</span>
                       </span>
                    </fmt-name>
                    <fmt-xref-label>
                       <span class="fmt-element-name">Example</span>
                    </fmt-xref-label>
                                       <fmt-xref-label container="A">
                      <span class="fmt-xref-container">
                         <semx element="title" source="A">
             Preface
          </semx>
                      </span>
                      <span class="fmt-comma">,</span>
                      <span class="fmt-element-name">Example</span>
                   </fmt-xref-label>
                    <p id="_">This is an example</p>
                    <p id="_">Amen</p>
                 </example>
              </foreword>
           </preface>
        </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      #{HTML_HDR}
              <br/>
             <div id="A">
                <h1 class="ForewordTitle">I. 
             Preface
          </h1>
                <p class="SourceTitle" style="text-align:center;">Example</p>
                <div id="_" class="example">
                   <p id="_">This is an example</p>
                   <p id="_">Amen</p>
                </div>
             </div>
          </div>
       </body>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))))
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
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <foreword id="A" displayorder="2">
                <title id="_">Preface</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Preface</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="A">Preface</semx>
                </fmt-xref-label>
                <figure id="B" autonum="1">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Figure</span>
                         <semx element="autonum" source="B">1</semx>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Figure</span>
                      <semx element="autonum" source="B">1</semx>
                   </fmt-xref-label>
                   <p id="_">This is an example</p>
                </figure>
                <figure id="C" class="pseudocode" autonum="1">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Listing</span>
                         <semx element="autonum" source="C">1</semx>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Listing</span>
                      <semx element="autonum" source="C">1</semx>
                   </fmt-xref-label>
                   <p original-id="_">This is an example</p>
                   <fmt-figure class="pseudocode" autonum="1">
                      <p id="_">This is an example</p>
                   </fmt-figure>
                </figure>
                <sourcecode id="D" autonum="2">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">Listing</span>
                         <semx element="autonum" source="D">2</semx>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Listing</span>
                      <semx element="autonum" source="D">2</semx>
                   </fmt-xref-label>
                   <p original-id="_">This is an example</p>
                   <fmt-sourcecode autonum="2">
                      <p id="_">This is an example</p>
                   </fmt-sourcecode>
                </sourcecode>
             </foreword>
          </preface>
       </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      #{HTML_HDR}
              <br/>
              <div id="A">
              <h1 class="ForewordTitle">I.  Preface</h1>
             <div id="B" class="figure">
               <p id="_">This is an example</p>
             </div>
               <p class="FigureTitle" style="text-align:center;">Figure 1</p>
             <div id="C" class="pseudocode">
               <p id="_">This is an example</p>
               <p class="SourceTitle" style="text-align:center;">Listing 1</p>
             </div>
             <pre id="D" class="sourcecode">
               <p id="_">This is an example</p>
             </pre>
             <p class="SourceTitle" style="text-align:center;">Listing 2</p>
           </div>
         </div>
       </body>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))))
      .to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes hi" do
    presxml = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
           #{METANORMA_EXTENSION}
          <preface> <clause type="toc" id="_" displayorder="1"> <fmt-title depth="1">Contents</fmt-title> </clause>
        <foreword id="A" displayorder="2"><fmt-title>Preface</fmt-title>
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

  it "processes notes" do
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
               </metanorma-extension>
         <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <foreword id="A" displayorder="2">
                <title id="_">Preface</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Preface</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="A">Preface</semx>
                </fmt-xref-label>
                <note id="B" autonum="">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">NOTE</span>
                      </span>
                      <span class="fmt-label-delim">
                         :
                         <tab/>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Note</span>
                   </fmt-xref-label>
                   <fmt-xref-label container="A">
                      <span class="fmt-xref-container">
                         <semx element="title" source="A">Preface</semx>
                      </span>
                      <span class="fmt-comma">,</span>
                      <span class="fmt-element-name">Note</span>
                   </fmt-xref-label>
                   <p>Hello</p>
                </note>
             </foreword>
          </preface>
          <sections>
             <clause id="C" displayorder="3">
                <title id="_">Clause</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="C">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Clause</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="C">1</semx>
                </fmt-xref-label>
                <note id="D" autonum="">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <span class="fmt-element-name">NOTE</span>
                      </span>
                      <span class="fmt-label-delim">
                         :
                         <tab/>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Note</span>
                   </fmt-xref-label>
                   <fmt-xref-label container="C">
                      <span class="fmt-xref-container">
                         <span class="fmt-element-name">Clause</span>
                         <semx element="autonum" source="C">1</semx>
                      </span>
                      <span class="fmt-comma">,</span>
                      <span class="fmt-element-name">Note</span>
                   </fmt-xref-label>
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
        <br/><div id="A">
        <h1 class="ForewordTitle">I.  Preface</h1>
        <div id="B" class="Note"><p><span class="note_label">NOTE:  </span>Hello</p></div></div><div id="C">
        <h1>1.  Clause</h1>
        <div id="D" class="Note"><p><span class="note_label">NOTE:  </span>Hello</p></div></div></div></body>
    OUTPUT
    word = <<~OUTPUT
      <body lang="EN-US" link="blue" vlink="#954F72"><div class="WordSection1"><p> </p></div><p class="section-break"><br clear="all" class="section"/></p><div class="WordSection2"><p class="page-break"><br clear="all" style="mso-special-character:line-break;page-break-before:always"/></p>
          <div class="TOC" id="_">
      <p class="zzContents">Contents</p>
      </div>
      <p class="page-break">
       <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
      </p>
        <div id="A"><h1 class="ForewordTitle">I.<span style="mso-tab-count:1">  </span>Preface</h1><div id="B" class="Note"><p class="Note"><span class="note_label">NOTE:<span style="mso-tab-count:1">  </span></span>Hello</p></div></div><p> </p></div><p class="section-break"><br clear="all" class="section"/></p><div class="WordSection3"><div id="C"><h1>
          1.
          <span style="mso-tab-count:1">  </span>
          Clause
        </h1><div id="D" class="Note"><p class="Note"><span class="note_label">NOTE:<span style="mso-tab-count:1">  </span></span>Hello</p></div></div></div></body>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(
                              IsoDoc::Ogc::HtmlConvert.new({}).convert("test", pres_output, true)
                              .gsub(%r{^.*<body}m, "<body")
                              .gsub(%r{</body>.*}m, "</body>"),
                            ))).to be_equivalent_to Xml::C14n.format(html)
    expect(Xml::C14n.format(strip_guid(
                              IsoDoc::Ogc::WordConvert.new({}).convert("test", pres_output, true)
                              .gsub(%r{^.*<body}m, "<body")
                       .gsub(%r{</body>.*}m, "</body>"),
                            ))).to be_equivalent_to Xml::C14n.format(word)
  end

  it "processes collapsible sourcecode" do
    presxml = <<~OUTPUT
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
       #{METANORMA_EXTENSION}
        <preface>
      <foreword displayorder="1" id="A">
            <sourcecode lang='ruby' id='samplecode'>
              <fmt-name>
                Figure 1&#xA0;&#x2014; Ruby
                <em>code</em>
              </fmt-name>
               puts x
            </sourcecode>
            <sourcecode unnumbered='true' linenums="true">Hey
             Que? </sourcecode>

          <sourcecode id="_97ec68f1-13df-2fec-f96e-412fe9940eff" lang="json" linenums="true"><body>"time" : {
              "interval": [
                  "1969-07-16",
                  "1969-07-24"
              ]
          }</body><fmt-sourcecode lang="json" linenums="true"><table class="rouge-line-table"><tbody><tr id="line-1" class="lineno"><td class="rouge-gutter gl" style="-moz-user-select: none;-ms-user-select: none;-webkit-user-select: none;user-select: none;"><pre>1</pre></td><td class="rouge-code"><sourcecode><span class="nl">"time"</span><span class="w"> </span><span class="p">:</span><span class="w"> </span><span class="p">{</span></sourcecode></td></tr></tbody></table></fmt-sourcecode></sourcecode>
          </foreword>
        </preface>
        <sections/>
      </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      <main class="main-section">
          <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
          <br/>
          <div id="A">
             <h1 class="ForewordTitle">
                <a class="anchor" href="#A"/>
                <a class="header" href="#A"/>
             </h1>
             <p class="collapsible active"> </p>
             <pre id="samplecode" class="sourcecode hidable">
                <br/>
                       
                <br/>
                         puts x
                <br/>
                     
             </pre>
             <p class="SourceTitle" style="text-align:center;">
                Figure 1 — Ruby
                <i>code</i>
             </p>
             <p class="collapsible active"> </p>
             <pre class="sourcecode hidable">
                Hey
                <br/>
                       Que?
             </pre>
             <p class="collapsible active"> </p>
             <div id="_97ec68f1-13df-2fec-f96e-412fe9940eff" class="sourcecode hidable">
                <table class="rouge-line-table" style="">
                   <tbody>
                      <tr>
                         <td style="-moz-user-select: none;-ms-user-select: none;-webkit-user-select: none;user-select: none;;" class="rouge-gutter gl">
                            <pre>1</pre>
                         </td>
                         <td style="" class="rouge-code">
                            <pre class="sourcecode">
                               <span class="nl">"time"</span>
                               <span class="w"> </span>
                               <span class="p">:</span>
                               <span class="w"> </span>
                               <span class="p">{</span>
                            </pre>
                         </td>
                      </tr>
                   </tbody>
                </table>
             </div>
          </div>
       </main>
    OUTPUT
    FileUtils.rm_f "test.html"
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    out = File.read("test.html")
      .sub(/^.*<main/m, "<main")
      .sub(%r{</main>.*$}m, "</main>")
    expect(Xml::C14n.format(out)).to be_equivalent_to Xml::C14n.format(html)
  end

  it "processes collapsible figures" do
    presxml = <<~OUTPUT
        <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
         #{METANORMA_EXTENSION}
            <preface>
      <clause type="toc" id="_" displayorder="1">
        <fmt-title depth="1">Table of contents</fmt-title>
      </clause>
            <foreword displayorder="2" id="A">
            <figure id="figureA-1" keep-with-next="true" keep-lines-together="true">
          <fmt-name>Figure 1&#xA0;&#x2014; Split-it-right <em>sample</em> divider</fmt-name>
          <image src="data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7" height="20" width="auto" id="_" mimetype="image/png"/>
          <image src='data:application/xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjw/eG1sLXN0eWxlc2hlZXQgdHlwZT0idGV4dC94c2wiIGhyZWY9Ii4uLy4uLy4uL3hzbC9yZXNfZG9jL2ltZ2ZpbGUueHNsIj8+CjwhRE9DVFlQRSBpbWdmaWxlLmNvbnRlbnQgU1lTVEVNICIuLi8uLi8uLi9kdGQvdGV4dC5lbnQiPgo8aW1nZmlsZS5jb250ZW50IG1vZHVsZT0iZnVuZGFtZW50YWxzX29mX3Byb2R1Y3RfZGVzY3JpcHRpb25fYW5kX3N1cHBvcnQiIGZpbGU9ImFjdGlvbl9zY2hlbWFleHBnMS54bWwiPgo8aW1nIHNyYz0iYWN0aW9uX3NjaGVtYWV4cGcxLmdpZiI+CjxpbWcuYXJlYSBzaGFwZT0icmVjdCIgY29vcmRzPSIyMTAsMTg2LDM0MywyMjciIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9iYXNpY19hdHRyaWJ1dGVfc2NoZW1hL2Jhc2ljX2F0dHJpYnV0ZV9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMTAsMTAsOTYsNTEiIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9hY3Rpb25fc2NoZW1hL2FjdGlvbl9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMjEwLDI2NCwzNTgsMzA1IiBocmVmPSIuLi8uLi9yZXNvdXJjZXMvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEueG1sIiAvPgo8L2ltZz4KPC9pbWdmaWxlLmNvbnRlbnQ+Cg==' height='20' width='auto' id='_' mimetype='application/xml'/>
          <dl>
          <dt>A</dt>
          <dd><p>B</p></dd>
          </dl>
          <source status="generalisation">[SOURCE: <fmt-xref target="ISO712" type="inline">ISO&#xa0;712, Section 1</fmt-xref> &#x2014; with adjustments ; <fmt-xref type="inline" target="ISO712">ISO 712, Section 2</fmt-xref>]</source>
        </figure>
        <figure id="figure-B">
        <fmt-name>Figure 2</fmt-name>
        <pre alt="A B">A &#x3c;
        B</pre>
        </figure>
        <figure id="figure-C" unnumbered="true">
        <pre>A &#x3c;
        B</pre>
        </figure>
            </foreword></preface>
                     <sections>
             </sections>
           <bibliography>
           </bibliography>
            </iso-standard>
    OUTPUT
    html = <<~OUTPUT
         <main class="main-section">
         <button onclick="topFunction()" id="myBtn" title="Go to top">Top</button>
         <br/>
         <br/>
         <div id="A">
            <h1 class="ForewordTitle">
               <a class="anchor" href="#A"/>
               <a class="header" href="#A"/>
            </h1>
            <p class="collapsible active"> </p>
            <div id="figureA-1" class="figure hidable" style="page-break-after: avoid;page-break-inside: avoid;">
               <img src="data:image/gif;base64,R0lGODlhEAAQAMQAAORHHOVSKudfOulrSOp3WOyDZu6QdvCchPGolfO0o/XBs/fNwfjZ0frl3/zy7////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BAkAABAALAAAAAAQABAAAAVVICSOZGlCQAosJ6mu7fiyZeKqNKToQGDsM8hBADgUXoGAiqhSvp5QAnQKGIgUhwFUYLCVDFCrKUE1lBavAViFIDlTImbKC5Gm2hB0SlBCBMQiB0UjIQA7" height="20" width="20"/>
               <img src="data:application/xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIj8+Cjw/eG1sLXN0eWxlc2hlZXQgdHlwZT0idGV4dC94c2wiIGhyZWY9Ii4uLy4uLy4uL3hzbC9yZXNfZG9jL2ltZ2ZpbGUueHNsIj8+CjwhRE9DVFlQRSBpbWdmaWxlLmNvbnRlbnQgU1lTVEVNICIuLi8uLi8uLi9kdGQvdGV4dC5lbnQiPgo8aW1nZmlsZS5jb250ZW50IG1vZHVsZT0iZnVuZGFtZW50YWxzX29mX3Byb2R1Y3RfZGVzY3JpcHRpb25fYW5kX3N1cHBvcnQiIGZpbGU9ImFjdGlvbl9zY2hlbWFleHBnMS54bWwiPgo8aW1nIHNyYz0iYWN0aW9uX3NjaGVtYWV4cGcxLmdpZiI+CjxpbWcuYXJlYSBzaGFwZT0icmVjdCIgY29vcmRzPSIyMTAsMTg2LDM0MywyMjciIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9iYXNpY19hdHRyaWJ1dGVfc2NoZW1hL2Jhc2ljX2F0dHJpYnV0ZV9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMTAsMTAsOTYsNTEiIGhyZWY9Ii4uLy4uL3Jlc291cmNlcy9hY3Rpb25fc2NoZW1hL2FjdGlvbl9zY2hlbWEueG1sIiAvPgo8aW1nLmFyZWEgc2hhcGU9InJlY3QiIGNvb3Jkcz0iMjEwLDI2NCwzNTgsMzA1IiBocmVmPSIuLi8uLi9yZXNvdXJjZXMvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEvc3VwcG9ydF9yZXNvdXJjZV9zY2hlbWEueG1sIiAvPgo8L2ltZz4KPC9pbWdmaWxlLmNvbnRlbnQ+Cg==" height="20" width="0"/>
               <div class="figdl">
                  <dl>
                     <dt>
                        <p>A</p>
                     </dt>
                     <dd>
                        <p>B</p>
                     </dd>
                  </dl>
               </div>
               <div class="BlockSource">
                  <p>
                     [SOURCE:
                     <a href="#ISO712">ISO 712, Section 1</a>
                     — with adjustments ;
                     <a href="#ISO712">ISO 712, Section 2</a>
                     ]
                  </p>
               </div>
            </div>
            <p class="FigureTitle" style="text-align:center;">
               Figure 1 — Split-it-right
               <i>sample</i>
               divider
            </p>
            <p class="collapsible active"> </p>
            <div id="figure-B" class="figure hidable">
               <pre>A &lt;
        B</pre>
            </div>
            <p class="FigureTitle" style="text-align:center;">Figure 2</p>
            <p class="collapsible active"> </p>
            <div id="figure-C" class="figure hidable">
               <pre>A &lt;
        B</pre>
            </div>
         </div>
      </main>
    OUTPUT
    FileUtils.rm_f "test.html"
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    out = File.read("test.html")
      .sub(/^.*<main/m, "<main")
      .sub(%r{</main>.*$}m, "</main>")
    expect(Xml::C14n.format(out)).to be_equivalent_to Xml::C14n.format(html)
  end
end
