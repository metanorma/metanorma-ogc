require "spec_helper"

RSpec.describe IsoDoc::Ogc do
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
           <preface>
               <clause type="toc" id="_" displayorder="1">
            <fmt-title id="_" depth="1">Contents</fmt-title>
          </clause>
           </preface>
          <sections/>
      </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension")&.remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
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
           <preface> <clause type="toc" id="_" displayorder="1"> <fmt-title id="_" depth="1">Contents</fmt-title> </clause> </preface>
         <sections/>
       </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension")&.remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
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
           <preface> <clause type="toc" id="_" displayorder="1"> <fmt-title id="_" depth="1">Contents</fmt-title> </clause> </preface>
         <sections/>
       </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension")&.remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
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
           <preface> <clause type="toc" id="_" displayorder="1"> <fmt-title id="_" depth="1">Contents</fmt-title> </clause> </preface>
         <sections/>
       </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension")&.remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes keyword with no preface" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <keyword>ABC</keyword>
      <keyword>DEF</keyword>
      </bibdata>
      #{METANORMA_EXTENSION}
      <sections/>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns='https://standards.opengeospatial.org/document' type="presentation">
           <bibdata>
             <keyword>ABC</keyword>
             <keyword>DEF</keyword>
           </bibdata>
        #{METANORMA_EXTENSION}
           <preface>
               <clause type="toc" id="_" displayorder="1"> <fmt-title id="_" depth="1">Contents</fmt-title> </clause>
             <clause id="_" type='keywords' displayorder="2">
                      <title id="_">Keywords</title>
         <fmt-title id="_" depth="1">
            <span class="fmt-caption-label">
               <semx element="autonum" source="_">I</semx>
               <span class="fmt-autonum-delim">.</span>
            </span>
            <span class="fmt-caption-delim">
               <tab/>
            </span>
            <semx element="title" source="_">Keywords</semx>
         </fmt-title>
         <fmt-xref-label>
            <semx element="title" source="_">Keywords</semx>
         </fmt-xref-label>
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
        </div>
      </body>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(
                              IsoDoc::Ogc::HtmlConvert.new({})
                              .convert("test", pres_output, true)
                              .gsub(%r{^.*<body}m, "<body")
                              .gsub(%r{</body>.*}m, "</body>"),
                            ))).to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes keyword with preface" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata>
      <keyword>ABC</keyword>
      <keyword>DEF</keyword>
      </bibdata>
      #{METANORMA_EXTENSION}
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
       #{METANORMA_EXTENSION}
                 <preface>
            <clause type="toc" id="_" displayorder="1">
               <fmt-title id="_" depth="1">Contents</fmt-title>
            </clause>
            <abstract id="A" displayorder="2">
               <fmt-title id="_" depth="1">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="A">I</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
               </fmt-title>
               <fmt-xref-label>
                  <semx element="title" source="A"/>
               </fmt-xref-label>
            </abstract>
            <clause id="_" type="keywords" displayorder="3">
               <title id="_">Keywords</title>
               <fmt-title id="_" depth="1">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="_">II</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Keywords</semx>
               </fmt-title>
               <fmt-xref-label>
                  <semx element="title" source="_">Keywords</semx>
               </fmt-xref-label>
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
        </div>
      </body>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(strip_guid(
                              IsoDoc::Ogc::HtmlConvert.new({})
                              .convert("test", pres_output, true)
                              .gsub(%r{^.*<body}m, "<body")
                              .gsub(%r{</body>.*}m, "</body>"),
                            ))).to be_equivalent_to Xml::C14n.format(output)
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
      #{METANORMA_EXTENSION}
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
      #{METANORMA_EXTENSION}
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Contents</fmt-title>
             </clause>
             <clause id="_" type="submitting_orgs" displayorder="2">
                <title id="_">Submitting Organizations</title>
                <fmt-title id="_" depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Submitting Organizations</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="_">Submitting Organizations</semx>
                </fmt-xref-label>
                <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
                <ul id="_">
                   <li id="_">
                      <fmt-name id="_">
                         <semx element="autonum" source="_">•</semx>
                      </fmt-name>
                      OGC
                   </li>
                   <li id="_">
                      <fmt-name id="_">
                         <semx element="autonum" source="_">•</semx>
                      </fmt-name>
                      DEF
                   </li>
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
      <div class="ul_wrap">
      <ul id="_">
        <li id="_">OGC</li>
        <li id="_">DEF</li>
      </ul>
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
      .to be_equivalent_to Xml::C14n.format(output)
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
      #{METANORMA_EXTENSION}
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
      #{METANORMA_EXTENSION}
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title id="_" depth="1">Contents</fmt-title>
             </clause>
             <abstract id="A" displayorder="2">
                <fmt-title id="_" depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="A">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="A"/>
                </fmt-xref-label>
             </abstract>
             <clause type="security" id="B" displayorder="3">
                <fmt-title id="_" depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="B">II</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="B"/>
                </fmt-xref-label>
             </clause>
             <clause id="_" type="submitting_orgs" displayorder="4">
                <title id="_">Submitting Organizations</title>
                <fmt-title id="_" depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">III</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Submitting Organizations</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="_">Submitting Organizations</semx>
                </fmt-xref-label>
                <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
                <ul id="_">
                   <li id="_">
                      <fmt-name id="_">
                         <semx element="autonum" source="_">•</semx>
                      </fmt-name>
                      OGC
                   </li>
                   <li id="_">
                      <fmt-name id="_">
                         <semx element="autonum" source="_">•</semx>
                      </fmt-name>
                      DEF
                   </li>
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
          <div id="_" class="TOC">
          <h1 class="IntroTitle">Contents</h1>
        </div>
        <br/>
          <div id='A'>
            <h1 class='AbstractTitle'>I.</h1>
          </div>
          <div class='Section3' id='B'>
        <h1 class='IntroTitle'>II.</h1>
      </div>
          <div class='Section3' id='_'>
          <h1 class="IntroTitle">III.  Submitting Organizations</h1>
            <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
            <div class="ul_wrap">
            <ul id="_">
              <li id="_">OGC</li>
              <li id="_">DEF</li>
            </ul>
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
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes keyword and abstract in HTML head" do
    presxml = <<~OUTPUT
          <ogc-standard xmlns='https://standards.opengeospatial.org/document' type="presentation">
               <bibdata>
                 <keyword>ABC</keyword>
                 <keyword>DEF</keyword>
                 <keyword>"Double &#x3c;quote&#x3e;"</keyword>
                 <keyword>'Single quote'</keyword>
                 <abstract><p>This is a &#x3c;description&#x3e;.</p>
              <quote>This is a <em>blockquote</em> within a description. "Double quote" and 'Single quote'.</quote>
                 </abstract>
               </bibdata>
      #{METANORMA_EXTENSION}
               <preface>
                <clause type="toc" id="_" displayorder="1"> <fmt-title id="_" depth="1">Contents</fmt-title> </clause>
               <abstract id='A' displayorder="2">
        <title>I.</title>
      </abstract>
                 <clause id="_" type='keywords' displayorder="3">
                   <fmt-title id="_" depth='1'>II.<tab/>Keywords</fmt-title>
                   <p>The following are keywords to be used by search engines and document catalogues.</p>
                   <p>ABC, DEF</p>
                 </clause>
               </preface>
               <sections/>
             </ogc-standard>
    OUTPUT

    output = <<~OUTPUT
      <html>
         <meta name="keywords" content="ABC, DEF, &quot;Double &lt;quote&gt;&quot;, 'Single quote'"/>
         <meta name="description" content="This is a &lt;description&gt;. This is a blockquote within a description. &quot;Double quote&quot; and 'Single quote'."/>
      </html>
    OUTPUT

    FileUtils.rm_f("test.html")
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    doc = Nokogiri::XML(File.read("test.html"))
    out = doc.xpath("//head/meta[@name = 'keywords' or @name = 'description']")
    expect(Xml::C14n.format("<html>#{out.to_xml}</html>"))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes document history" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
            <bibdata type="standard">
        <title language="en" format="text/plain">Document title</title>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
            <abbreviation>OGC</abbreviation>
          </organization>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <status>
          <stage>approved</stage>
        </status>
        <copyright>
          <from>2024</from>
          <owner>
            <organization>
              <name>Open Geospatial Consortium</name>
              <abbreviation>OGC</abbreviation>
            </organization>
          </owner>
        </copyright>
        <relation type="updatedBy">
          <bibitem>
            <date type="published">
              <on>2012-04-02</on>
            </date>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>R Thakkar</completename>
                </name>
              </person>
            </contributor>
            <version>
              <draft>Draft</draft>
            </version>
            <amend change="modify">
              <description>
                <p id="_">Original draft document</p>
              </description>
              <location>
                <localityStack>
                  <locality type="whole"/>
                </localityStack>
              </location>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <date type="published">
              <on>2002-08-30</on>
            </date>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Kurt Buehler</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>George Percivall</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Sam Bacharach</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Carl Reed</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Cliff Kottman</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Chuck Heazel</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>John Davidson</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Yaser Bisher</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Harry Niedzwiadek</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>John Evans</completename>
                </name>
              </person>
            </contributor>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Jeffrey Simon</completename>
                </name>
              </person>
            </contributor>
            <version>
              <draft>0.1 02-077</draft>
            </version>
            <amend change="modify">
              <description>
                <p id="_">Initial version of ORM. Doc OGC</p>
              </description>
            </amend>
          </bibitem>
        </relation>
        <relation type="updatedBy">
          <bibitem>
            <date type="published">
              <on>2018-06-04</on>
            </date>
            <contributor>
              <role type="author"/>
              <person>
                <name>
                  <completename>Gabby Getz</completename>
                </name>
              </person>
            </contributor>
            <version>
              <draft>1.0</draft>
            </version>
            <amend change="modify">
              <description>
                <ul id="_">
                  <li id="_">
                    <p id="_">
                      Put
                      <em>3D Tiles</em>
                      specification document into OGC document template
                    </p>
                  </li>
                  <li id="_">
                    <p id="_">Miscellaneous updates</p>
                  </li>
                </ul>
              </description>
                      <location>
          <localityStack>
            <locality type="annex">
              <referenceFrom>A</referenceFrom>
            </locality>
          </localityStack>
        </location>
            </amend>
          </bibitem>
        </relation>
        <ext>
          <doctype>standard</doctype>
          <subdoctype>implementation</subdoctype>
        </ext>
      </bibdata>
      <sections/>
      </ogc-standard>
    INPUT
    presxml = <<~OUTPUT
        <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1" id="_">Contents</fmt-title>
             </clause>
          </preface>
          <sections/>
          <annex id="_" obligation="informative" autonum="A" displayorder="2">
             <title id="_">
                <strong>Revision history</strong>
             </title>
             <fmt-title id="_">
                <strong>
                   <span class="fmt-caption-label">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="_">A</semx>
                   </span>
                </strong>
                <br/>
                <span class="fmt-obligation">(informative)</span>
                <span class="fmt-caption-delim">
                   <br/>
                </span>
                <semx element="title" source="_">
                   <strong>Revision history</strong>
                </semx>
             </fmt-title>
             <fmt-xref-label>
                <span class="fmt-element-name">Annex</span>
                <semx element="autonum" source="_">A</semx>
             </fmt-xref-label>
             <table unnumbered="true" id="_">
                <thead>
                   <tr id="_">
                      <th id="_">Date</th>
                      <th id="_">Release</th>
                      <th id="_">Author</th>
                      <th id="_">Paragraph Modified</th>
                      <th id="_">Description</th>
                   </tr>
                </thead>
                <tbody>
                   <tr id="_">
                      <td id="_">2012-04-02</td>
                      <td id="_">Draft</td>
                      <td id="_">R Thakkar</td>
                      <td id="_">All</td>
                      <td id="_">
                         <p id="_">Original draft document</p>
                      </td>
                   </tr>
                   <tr id="_">
                      <td id="_">2002-08-30</td>
                      <td id="_">0.1 02-077</td>
                      <td id="_">Kurt Buehler, George Percivall, Sam Bacharach, Carl Reed, Cliff Kottman, Chuck Heazel, John Davidson, Yaser Bisher, Harry Niedzwiadek, John Evans, Jeffrey Simon</td>
                      <td id="_">All</td>
                      <td id="_">
                         <p id="_">Initial version of ORM. Doc OGC</p>
                      </td>
                   </tr>
                   <tr id="_">
                      <td id="_">2018-06-04</td>
                      <td id="_">1.0</td>
                      <td id="_">Gabby Getz</td>
                      <td id="_">Annex A</td>
                      <td id="_">
                         <ul id="_">
                            <li id="_">
                               <fmt-name id="_">
                                  <semx element="autonum" source="_">•</semx>
                               </fmt-name>
                               <p id="_">
                                  Put
                                  <em>3D Tiles</em>
                                  specification document into OGC document template
                               </p>
                            </li>
                            <li id="_">
                               <fmt-name id="_">
                                  <semx element="autonum" source="_">•</semx>
                               </fmt-name>
                               <p id="_">Miscellaneous updates</p>
                            </li>
                         </ul>
                      </td>
                   </tr>
                </tbody>
             </table>
          </annex>
       </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension")&.remove
    xml.at("//xmlns:bibdata").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end
end
