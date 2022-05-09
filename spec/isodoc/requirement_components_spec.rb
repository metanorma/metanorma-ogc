require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "processes requirement components" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
        <preface><foreword id="A"><title>Preface</title>
        <recommendation id="_">
      <label>/ogc/recommendation/wfs/2</label>
      <inherit>/ss/584/2015/level/1</inherit>
      <subject>user</subject>
      <description><p id="_">I recommend <em>1</em>.</p></description>
      <component class="test-purpose"><p>TEST PURPOSE</p></component>
      <description><p id="_">I recommend <em>2</em>.</p></description>
      <component class="conditions"><p>CONDITIONS</p></component>
      <description><p id="_">I recommend <em>3</em>.</p></description>
      <component class="part"><p>FIRST PART</p></component>
      <description><p id="_">I recommend <em>4</em>.</p></description>
      <component class="part"><p>SECOND PART</p></component>
      <description><p id="_">I recommend <em>5</em>.</p></description>
      <component class="test-method"><p>TEST METHOD</p></component>
      <description><p id="_">I recommend <em>6</em>.</p></description>
      <component class="part"><p>THIRD PART</p></component>
      <description><p id="_">I recommend <em>7</em>.</p></description>
      <component class="panda GHz express"><p>PANDA PART</p></component>
      <description><p id="_">I recommend <em>8</em>.</p></description>
      </recommendation>
      </foreword>
      </preface>
      </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
           <preface><foreword id="A" displayorder="1"><title depth="1">I.<tab/>Preface</title>
           <table id="_" class="recommendation" type="recommend">
         <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Recommendation 1</p></th></tr></thead><tbody><tr><td colspan="2"><p class='RecommendationLabel'>/ogc/recommendation/wfs/2</p></td></tr><tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td colspan="2"><p id="_">I recommend <em>1</em>.</p></td></tr><tr><td>Test purpose</td><td><p>TEST PURPOSE</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>2</em>.</p></td></tr><tr><td>Conditions</td><td><p>CONDITIONS</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>3</em>.</p></td></tr><tr><td>A</td><td><p>FIRST PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>4</em>.</p></td></tr><tr><td>B</td><td><p>SECOND PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>5</em>.</p></td></tr><tr><td>Test method</td><td><p>TEST METHOD</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>6</em>.</p></td></tr><tr><td>C</td><td><p>THIRD PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>7</em>.</p></td></tr><tr><td>Panda GHz express</td><td><p>PANDA PART</p></td></tr><tr><td colspan="2"><p id="_">I recommend <em>8</em>.</p></td></tr></tbody></table>
         </foreword>
         </preface>
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
               <h1 class='ForewordTitle'>I.&#160; Preface</h1>
               <table id='_' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                       <p class='RecommendationTitle'>Recommendation 1</p>
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
                         <i>1</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>Test purpose</td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p>TEST PURPOSE</p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p id='_'>
                         I recommend
                         <i>2</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>Conditions</td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p>CONDITIONS</p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p id='_'>
                         I recommend
                         <i>3</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>A</td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p>FIRST PART</p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p id='_'>
                         I recommend
                         <i>4</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>B</td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p>SECOND PART</p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p id='_'>
                         I recommend
                         <i>5</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>Test method</td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p>TEST METHOD</p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p id='_'>
                         I recommend
                         <i>6</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>C</td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p>THIRD PART</p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p id='_'>
                         I recommend
                         <i>7</i>
                         .
                       </p>
                     </td>
                   </tr>
                   <tr>
                     <td style='vertical-align:top;' class='recommend'>Panda GHz express</td>
                     <td style='vertical-align:top;' class='recommend'>
                       <p>PANDA PART</p>
                     </td>
                   </tr>
                   <tr>
                     <td colspan='2' style='vertical-align:top;' class='recommend'>
                       <p id='_'>
                         I recommend
                         <i>8</i>
                         .
                       </p>
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
                      <p class='RecommendationTitle'>Recommendation 1</p>
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
                        <i>1</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Test purpose</td>
                    <td style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>TEST PURPOSE</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td colspan='2' style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend
                        <i>2</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Conditions</td>
                    <td style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>CONDITIONS</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td colspan='2' style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend
                        <i>3</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>A</td>
                    <td style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>FIRST PART</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td colspan='2' style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend
                        <i>4</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>B</td>
                    <td style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>SECOND PART</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td colspan='2' style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend
                        <i>5</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Test method</td>
                    <td style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>TEST METHOD</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td colspan='2' style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend
                        <i>6</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>C</td>
                    <td style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>THIRD PART</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td colspan='2' style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend
                        <i>7</i>
                        .
                      </p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Panda GHz express</td>
                    <td style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>PANDA PART</p>
                    </td>
                  </tr>
                  <tr style='background:#C9C9C9;'>
                    <td colspan='2' style='vertical-align:top;' class='recommend'>
                      <p class='MsoNormal'>
                        <a name='_' id='_'/>
                        I recommend
                        <i>8</i>
                        .
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

    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
    FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
    expect(xmlpp(File.read("test.doc")
      .gsub(%r{^.*<a name="A" id="A">}m,
            "<body xmlns:m=''><div><div><a name='A' id='A'>")
              .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(word)
  end

  it "processes labels with rich text" do
    input = <<~INPUT
              <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface>
              <foreword id="A"><title>Preface</title>
          <permission id="A1" type="verification">
        <label><strong>A</strong> <xref target="A"/></label>
        <inherit>/ss/584/2015/level/1</inherit>
        <subject>user</subject>
        <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
        <description>
          <p id="_">I recommend <em>this</em>.</p>
        </description>
      </permission>
          </foreword></preface>
          </ogc-standard>
    INPUT
    presxml = <<~PRESXML
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
        <preface>
          <foreword id='A' displayorder='1'>
            <title depth='1'>
              I.
              <tab/>
              Preface
            </title>
            <table id='A1' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Permission test 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>
                    <p class='RecommendationLabel'><strong>A</strong><xref target='A'>Preface</xref></p>
                  </td>
                </tr>
                <tr>
                  <td>Requirement</td>
                  <td>user</td>
                </tr>
                <tr>
                  <td>Dependency</td>
                  <td>/ss/584/2015/level/1</td>
                </tr>
                <tr>
                  <td>Control-class</td>
                  <td>Technical</td>
                </tr>
                <tr>
                  <td>Priority</td>
                  <td>P0</td>
                </tr>
                <tr>
                  <td>Family</td>
                  <td>System and Communications Protection</td>
                </tr>
                <tr>
                  <td>Family</td>
                  <td>System and Communications Protocols</td>
                </tr>
                <tr>
                  <td colspan='2'>
                    <p id='_'>
                      I recommend
                      <em>this</em>
                      .
                    </p>
                  </td>
                </tr>
              </tbody>
            </table>
          </foreword>
        </preface>
      </ogc-standard>
    PRESXML
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
  end

  it "processes nested requirement steps" do
    input = <<~INPUT
                <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface>
                <foreword id="A"><title>Preface</title>
                    <requirement id='A1'>
        <component exclude='false' class='test method type'>
          <p id='_'>Manual Inspection</p>
        </component>
        <component exclude='false' class='test-method'>
          <p id='1'>
            <component exclude='false' class='step'>
              <p id='2'>For each UML class defined or referenced in the Tunnel Package:</p>
              <component exclude='false' class='step'>
                <p id='3'>
                  Validate that the Implementation Specification contains a data
                  element which represents the same concept as that defined for
                  the UML class.
                </p>
              </component>
              <component exclude='false' class='step'>
                <p id='4'>
                  Validate that the data element has the same relationships with
                  other elements as those defined for the UML class. Validate that
                  those relationships have the same source, target, direction,
                  roles, and multiplicies as those documented in the Conceptual
                  Model.
                </p>
              </component>
            </component>
          </p>
        </component>
      </requirement>
            </foreword></preface>
            </ogc-standard>
    INPUT
    presxml = <<~PRESXML
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
        <preface>
          <foreword id='A' displayorder='1'>
            <title depth='1'>
              I.
              <tab/>
              Preface
            </title>
            <table id='A1' class='requirement' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Requirement 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Test method type</td>
                  <td>
                    <p id='_'>Manual Inspection</p>
                  </td>
                </tr>
                <tr>
                  <td>Test method</td>
                  <td>
                    <p id='1'>
                      <ol class="steps">
                        <li>
                          <p id='2'>For each UML class defined or referenced in the Tunnel Package:</p>
                          <ol class="steps">
                            <li>
                              <p id='3'>
                                 Validate that the Implementation Specification
                                contains a data element which represents the same
                                concept as that defined for the UML class.
                              </p>
                            </li>
                            <li>
                              <p id='4'>
                                 Validate that the data element has the same
                                relationships with other elements as those defined for
                                the UML class. Validate that those relationships have
                                the same source, target, direction, roles, and
                                multiplicies as those documented in the Conceptual
                                Model.
                              </p>
                            </li>
                          </ol>
                        </li>
                      </ol>
                    </p>
                  </td>
                </tr>
              </tbody>
            </table>
          </foreword>
        </preface>
      </ogc-standard>
    PRESXML
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
            <h1 class='ForewordTitle'> I. &#160; Preface </h1>
            <table id='A1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
              <thead>
                <tr>
                  <th colspan='2' style='vertical-align:top;' scope='colgroup' class='recommend'>
                    <p class='RecommendationTitle'>Requirement 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td style='vertical-align:top;' class='recommend'>Test method type</td>
                  <td style='vertical-align:top;' class='recommend'>
                    <p id='_'>Manual Inspection</p>
                  </td>
                </tr>
                <tr>
                  <td style='vertical-align:top;' class='recommend'>Test method</td>
                  <td style='vertical-align:top;' class='recommend'>
                    <p id='1'>
                      <ol type='1'>
                        <li>
                          <p id='2'>For each UML class defined or referenced in the Tunnel Package:</p>
                          <ol type='a'>
                            <li>
                              <p id='3'>
                                 Validate that the Implementation Specification
                                contains a data element which represents the same
                                concept as that defined for the UML class.
                              </p>
                            </li>
                            <li>
                              <p id='4'>
                                 Validate that the data element has the same
                                relationships with other elements as those defined for
                                the UML class. Validate that those relationships have
                                the same source, target, direction, roles, and
                                multiplicies as those documented in the Conceptual
                                Model.
                              </p>
                            </li>
                          </ol>
                        </li>
                      </ol>
                    </p>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <p class='zzSTDTitle1'/>
        </div>
      </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .gsub(%r{^.*<body}m, "<body")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end

  it "processes bidirectional requirement/conformance tests" do
    input = <<~INPUT
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <preface>
          <foreword id="A"><title>Preface</title>
              <requirement id='A1' type="general">
              <label>/ogc/recommendation/wfs/1</label>
              </requirement>
              <requirement id='A2' type="verification">
              <label>/ogc/recommendation/wfs/2</label>
              <subject><xref target="A1"/></subject>
              </requirement>
              <requirement id='A3' type="class">
              <label>/ogc/recommendation/wfs/3</label>
              </requirement>
              <requirement id='A4' type="conformanceclass">
              <label>/ogc/recommendation/wfs/4</label>
              <subject><xref target="A3"/></subject>
              </requirement>
      </foreword></preface>
      </ogc-standard>
    INPUT
    presxml = <<~PRESXML
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type='presentation'>
         <preface>
           <foreword id='A' displayorder='1'>
             <title depth='1'>
               I.
               <tab/>
               Preface
             </title>
             <table id='A1' type='recommend' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Requirement 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/1</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Conformance test</td>
                   <td>
                     <xref target='A2'>
                       Preface, Requirement test 1:
                       <tt>/ogc/recommendation/wfs/2</tt>
                     </xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='A2' type='recommendtest' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTestTitle'>Requirement test 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Requirement</td>
                   <td>
                     <xref target='A1'>
                       Preface, Requirement 1:
                       <tt>/ogc/recommendation/wfs/1</tt>
                     </xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='A3' type='recommendclass' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Requirements class 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/3</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Conformance test</td>
                   <td>
                     <xref target='A4'>
                       Preface, Conformance class 1:
                       <tt>/ogc/recommendation/wfs/4</tt>
                     </xref>
                   </td>
                 </tr>
               </tbody>
             </table>
             <table id='A4' type='recommendclass' class='requirement'>
               <thead>
                 <tr>
                   <th scope='colgroup' colspan='2'>
                     <p class='RecommendationTitle'>Conformance class 1</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td colspan='2'>
                     <p class='RecommendationLabel'>/ogc/recommendation/wfs/4</p>
                   </td>
                 </tr>
                 <tr>
                   <td>Requirements class</td>
                   <td>
                     <xref target='A3'>
                       Preface, Requirements class 1:
                       <tt>/ogc/recommendation/wfs/3</tt>
                     </xref>
                   </td>
                 </tr>
               </tbody>
             </table>
           </foreword>
         </preface>
       </ogc-standard>
    PRESXML
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)))
      .to be_equivalent_to xmlpp(presxml)
  end
end
