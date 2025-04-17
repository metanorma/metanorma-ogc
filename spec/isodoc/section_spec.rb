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
                   <fmt-title depth="1">Contents</fmt-title>
                </clause>
             </preface>
             <sections>
                <clause id="A" type="scope" displayorder="2">
                   <fmt-title depth="1">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="A">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="A">1</semx>
                   </fmt-xref-label>
                </clause>
                <clause id="B" displayorder="4">
                   <fmt-title depth="1">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="B">3</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="B">3</semx>
                   </fmt-xref-label>
                </clause>
                <clause id="C" displayorder="5">
                   <fmt-title depth="1">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="C">4</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="C">4</semx>
                   </fmt-xref-label>
                </clause>
                <terms id="D" displayorder="3">
                   <title id="_">Terms</title>
                   <fmt-title depth="1">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="D">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Terms</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="D">2</semx>
                   </fmt-xref-label>
                </terms>
             </sections>
          </bibdata>
       </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension")&.remove
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
                  <fmt-title depth="1">Contents</fmt-title>
               </clause>
            </preface>
            <sections>
               <clause id="A" type="scope" displayorder="2">
                  <fmt-title depth="1">
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="A">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-title>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Clause</span>
                     <semx element="autonum" source="A">1</semx>
                  </fmt-xref-label>
               </clause>
               <clause id="B" displayorder="3">
                  <fmt-title depth="1">
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="B">2</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-title>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Clause</span>
                     <semx element="autonum" source="B">2</semx>
                  </fmt-xref-label>
               </clause>
               <clause id="C" displayorder="4">
                  <fmt-title depth="1">
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="C">3</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-title>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Clause</span>
                     <semx element="autonum" source="C">3</semx>
                  </fmt-xref-label>
               </clause>
               <terms id="D" displayorder="5">
                  <title id="_">Terms</title>
                  <fmt-title depth="1">
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="D">4</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                     <span class="fmt-caption-delim">
                        <tab/>
                     </span>
                     <semx element="title" source="_">Terms</semx>
                  </fmt-title>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Clause</span>
                     <semx element="autonum" source="D">4</semx>
                  </fmt-xref-label>
               </terms>
            </sections>
         </bibdata>
      </ogc-standard>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension")&.remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
  end

  it "processes simple terms & definitions" do
    input = <<~INPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
      <bibdata/>
        <metanorma-extension>
                       #{METANORMA_EXTENSION}
        </metanorma-extension>
        <sections>
        <terms id="H" obligation="normative"><title>Terms, Definitions, Symbols and Abbreviated Terms</title>
          <term id="J">
          <preferred><expression><name>Term2</name></expression></preferred>
          <admitted><expression><name>Term2A</name></expression></admitted>
          <admitted><expression><name>Term2B</name></expression></admitted>
          <deprecates><expression><name>Term2C</name></expression></deprecates>
          <deprecates><expression><name>Term2D</name></expression></deprecates>
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
        <metanorma-extension>
                       #{METANORMA_EXTENSION}
        </metanorma-extension>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
          </preface>
          <sections>
             <terms id="H" obligation="normative" displayorder="2">
                <title id="_">Terms, Definitions, Symbols and Abbreviated Terms</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms, Definitions, Symbols and Abbreviated Terms</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="H">1</semx>
                </fmt-xref-label>
                <term id="J">
                   <fmt-name>
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="J">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                   </fmt-name>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="H">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="J">1</semx>
                   </fmt-xref-label>
                   <preferred id="_">
                      <expression>
                         <name>Term2</name>
                      </expression>
                   </preferred>
                   <fmt-preferred>
                      <p>
                         <semx element="preferred" source="_">
                            <strong>Term2</strong>
                         </semx>
                      </p>
                   </fmt-preferred>
                   <admitted id="_">
                      <expression>
                         <name>Term2A</name>
                      </expression>
                   </admitted>
                   <admitted id="_">
                      <expression>
                         <name>Term2B</name>
                      </expression>
                   </admitted>
                   <fmt-admitted>
                      <p>
                         <semx element="admitted" source="_">Term2A</semx>
      #{'                    '}
                         <span class="AdmittedLabel">ALTERNATIVE</span>
                      </p>
                      <p>
                         <semx element="admitted" source="_">Term2B</semx>
      #{'                    '}
                         <span class="AdmittedLabel">ALTERNATIVE</span>
                      </p>
                   </fmt-admitted>
                   <deprecates id="_">
                      <expression>
                         <name>Term2C</name>
                      </expression>
                   </deprecates>
                   <deprecates id="_">
                      <expression>
                         <name>Term2D</name>
                      </expression>
                   </deprecates>
                   <fmt-deprecates>
                      <p>
                         <semx element="deprecates" source="_">Term2C</semx>
      #{'                    '}
                         <span class="DeprecatedLabel">DEPRECATED</span>
                      </p>
                      <p>
                         <semx element="deprecates" source="_">Term2D</semx>
      #{'                    '}
                         <span class="DeprecatedLabel">DEPRECATED</span>
                      </p>
                   </fmt-deprecates>
                   <termsource status="modified" id="_">
                      <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                         <locality type="clause">
                            <referenceFrom>3.1</referenceFrom>
                         </locality>
                      </origin>
                      <modification>
                         <p original-id="_e73a417d-ad39-417d-a4c8-20e4e2529489">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</p>
                      </modification>
                   </termsource>
                   <fmt-termsource status="modified">
                      [
                      <strong>SOURCE:</strong>
                      <semx element="termsource" source="_">
                         <origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011" id="_">
                            <locality type="clause">
                               <referenceFrom>3.1</referenceFrom>
                            </locality>
                         </origin>
                         <semx element="origin" source="_">
                            <fmt-origin bibitemid="ISO7301" type="inline" citeas="ISO 7301:2011">
                               <locality type="clause">
                                  <referenceFrom>3.1</referenceFrom>
                               </locality>
                               ISO 7301:2011, Clause 3.1
                            </fmt-origin>
                         </semx>
                         , modified —
                         <semx element="modification" source="_">The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here</semx>
                      </semx>
                      ]
                   </fmt-termsource>
                </term>
             </terms>
          </sections>
       </ogc-standard>
    INPUT

    html = Xml::C14n.format(<<~OUTPUT)
      <div id="H">
         <h1 id="_">
           <a class="anchor" href="#H"/>
           <a class="header" href="#H">1.  Terms, Definitions, Symbols and Abbreviated Terms</a>
         </h1>
         <div id="J">
           <h2 class="TermNum" style="text-align:left;" id="_">
             <a class="anchor" href="#J"/>
             <a class="header" href="#J">1.1. <b>Term2</b></a>
           </h2>
         </div>
         <p class="AltTerms" style="text-align:left;">
           Term2A#{' '}
           <span class="AdmittedLabel">ALTERNATIVE</span>
         </p>
         <p class="AltTerms" style="text-align:left;">
           Term2B#{' '}
           <span class="AdmittedLabel">ALTERNATIVE</span>
         </p>
         <p class="DeprecatedTerms" style="text-align:left;">
           Term2C#{' '}
           <span class="DeprecatedLabel">DEPRECATED</span>
         </p>
         <p class="DeprecatedTerms" style="text-align:left;">
           Term2D#{' '}
           <span class="DeprecatedLabel">DEPRECATED</span>
         </p>
         <p>
           [
           <b>SOURCE:</b>
           ISO 7301:2011, Clause 3.1, modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
         </p>
       </div>
    OUTPUT
    doc = Xml::C14n.format(<<~OUTPUT)
      <body>
          <div class="WordSection3">
             <div>
                <a name="H" id="H"/>
                <h1>
                   1.
                   <span style="mso-tab-count:1">  </span>
                   Terms, Definitions, Symbols and Abbreviated Terms
                </h1>
                <p class="TermNum" style="text-align:left;">
                   <a name="J" id="J"/>
                   1.1. <b>Term2</b>
                </p>
                <p class="AltTerms" style="text-align:left;">
                   Term2A#{' '}
                   <span class="AdmittedLabel">ALTERNATIVE</span>
                </p>
                <p class="AltTerms" style="text-align:left;">
                   Term2B#{' '}
                   <span class="AdmittedLabel">ALTERNATIVE</span>
                </p>
                <p class="DeprecatedTerms" style="text-align:left;">
                   Term2C#{' '}
                   <span class="DeprecatedLabel">DEPRECATED</span>
                </p>
                <p class="DeprecatedTerms" style="text-align:left;">
                   Term2D#{' '}
                   <span class="DeprecatedLabel">DEPRECATED</span>
                </p>
                <p class="MsoNormal">
                   [
                   <b>SOURCE:</b>
                   ISO 7301:2011, Clause 3.1, modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
                </p>
             </div>
          </div>
          <div style="mso-element:footnote-list"/>
       </body>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", pres_output, false)
    xml = Nokogiri::XML(File.read("test.html"))
    xml = xml.at("//div[@id = 'H']")
    expect(Xml::C14n.format(strip_guid(xml.to_xml))).to be_equivalent_to html
    IsoDoc::Ogc::WordConvert.new({ filename: "test" })
      .convert("test", pres_output, false)
    expect(Xml::C14n.format(File.read("test.doc")
      .gsub(%r{^.*<div class="WordSection3">}m,
            "<body><div class='WordSection3'>")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to doc
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
               <ext><doctype>technical-paper</doctype></ext>
        </bibdata>
        <metanorma-extension>
        #{METANORMA_EXTENSION}
        </metanorma-extension>
        <preface>
         <abstract obligation="informative" id="1"><title>Abstract</title>
         <p>XYZ</p>
         </abstract>
        <foreword obligation="informative" id="2"><title>Preface</title>
           <p id="A">This is a preamble</p>
         </foreword>
         <executivesummary id="DD0" obligation="normative">
           <title>Executive Summary</title>
           <p id="EE0">Text</p>
         </executivesummary>
         <clause id="DD1" obligation="normative" type="security">
           <title>Security</title>
           <p id="EE1">Text</p>
         </clause>
         <clause type="submitters" obligation="informative" id="3">
         <title>Submitters</title>
         <p>ABC</p>
         </clause>
         <clause type="contributors" obligation="informative" id="3a">
         <title>Contributors</title>
         <p>ABC</p>
         </clause>
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
           <preferred><expression><name>Term2</name></expression></preferred>
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
            <preferred><expression><name>Glossary</name></expression></preferred>
          </term>
        </terms>
      </annex>
      <annex id='QQ' obligation='normative'>
                 <title>Glossary</title>
                   <terms id='QQ1' obligation='normative'>
                     <title>Term Collection</title>
                     <term id='term-term-1'>
                       <preferred><expression><name>Term</name></expression></preferred>
                     </term>
                   </terms>
                   <terms id='QQ2' obligation='normative'>
                     <title>Term Collection 2</title>
                     <term id='term-term-2'>
                       <preferred><expression><name>Term</name></expression></preferred>
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
        <ext><doctype>technical-paper</doctype></ext>
      </bibdata>
        <metanorma-extension>
        #{METANORMA_EXTENSION}
        </metanorma-extension>
          <preface>
             <clause type="toc" id="_" displayorder="1">
                <fmt-title depth="1">Contents</fmt-title>
             </clause>
             <abstract obligation="informative" id="1" displayorder="2">
                <title id="_">Abstract</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="1">I</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Abstract</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="1">Abstract</semx>
                </fmt-xref-label>
                <p>XYZ</p>
             </abstract>
             <executivesummary id="DD0" obligation="normative" displayorder="3">
                <title id="_">Executive Summary</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="DD0">II</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Executive Summary</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="DD0">Executive Summary</semx>
                </fmt-xref-label>
                <p id="EE0">Text</p>
             </executivesummary>
             <clause id="_" type="keywords" displayorder="4">
                <title id="_">Keywords</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">III</semx>
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
                <p>A, B</p>
             </clause>
             <foreword obligation="informative" id="2" displayorder="5">
                <title id="_">Preface</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="2">IV</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Preface</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="2">Preface</semx>
                </fmt-xref-label>
                <p id="A">This is a preamble</p>
             </foreword>
             <clause id="DD1" obligation="normative" type="security" displayorder="6">
                <title id="_">Security</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="DD1">V</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Security</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="DD1">Security</semx>
                </fmt-xref-label>
                <p id="EE1">Text</p>
             </clause>
             <clause id="_" type="submitting_orgs" displayorder="7">
                <title id="_">Submitting Organizations</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="_">VI</semx>
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
                <ul>
            <li>
               <fmt-name>
                  <semx element="autonum" source="">•</semx>
               </fmt-name>
               OGC
            </li>
            <li>
               <fmt-name>
                  <semx element="autonum" source="">•</semx>
               </fmt-name>
               DEF
            </li>
                </ul>
             </clause>
             <clause type="submitters" obligation="informative" id="3" displayorder="8">
                <title id="_">Submitters</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="3">VII</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Submitters</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="3">Submitters</semx>
                </fmt-xref-label>
                <p>ABC</p>
             </clause>
             <clause type="contributors" obligation="informative" id="3a" displayorder="9">
                <title id="_">Contributors</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="3a">VIII</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Contributors</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="3a">Contributors</semx>
                </fmt-xref-label>
                <p>ABC</p>
             </clause>
             <clause id="5" displayorder="10">
                <title id="_">Dedication</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="5">IX</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Dedication</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="5">Dedication</semx>
                </fmt-xref-label>
                <clause id="6">
                   <title id="_">Note to readers</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="5">IX</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="6">A</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Note to readers</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="5">IX</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="6">A</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
             <acknowledgements obligation="informative" id="4" displayorder="11">
                <title id="_">Acknowlegements</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="4">X</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Acknowlegements</semx>
                </fmt-title>
                <fmt-xref-label>
                   <semx element="title" source="4">Acknowlegements</semx>
                </fmt-xref-label>
                <p>ABC</p>
             </acknowledgements>
          </preface>
          <sections>
             <clause id="D" obligation="normative" type="scope" displayorder="12">
                <title id="_">Scope</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="D">1</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Scope</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="D">1</semx>
                </fmt-xref-label>
                <p id="E">Text</p>
             </clause>
             <clause id="D1" obligation="normative" type="conformance" displayorder="13">
                <title id="_">Conformance</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="D1">2</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Conformance</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="D1">2</semx>
                </fmt-xref-label>
                <p id="E1">Text</p>
             </clause>
             <clause id="H" obligation="normative" displayorder="15">
                <title id="_">Terms, definitions, symbols and abbreviated terms</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="H">4</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Terms, definitions, symbols and abbreviated terms</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="H">4</semx>
                </fmt-xref-label>
                <terms id="I" obligation="normative">
                   <title id="_">Normal Terms</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">4</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="I">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Normal Terms</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="H">4</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="I">1</semx>
                   </fmt-xref-label>
                   <term id="J">
                      <fmt-name>
                         <span class="fmt-caption-label">
                            <semx element="autonum" source="H">4</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="I">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                            <semx element="autonum" source="J">1</semx>
                            <span class="fmt-autonum-delim">.</span>
                         </span>
                      </fmt-name>
                      <fmt-xref-label>
                         <span class="fmt-element-name">Clause</span>
                         <semx element="autonum" source="H">4</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="I">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="J">1</semx>
                      </fmt-xref-label>
                      <preferred id="_">
                         <expression>
                            <name>Term2</name>
                         </expression>
                      </preferred>
                      <fmt-preferred>
                         <p>
                            <semx element="preferred" source="_">
                               <strong>Term2</strong>
                            </semx>
                         </p>
                      </fmt-preferred>
                   </term>
                </terms>
                <definitions id="K">
                   <title id="_">Definitions</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="H">4</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="K">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Definitions</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="H">4</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="K">2</semx>
                   </fmt-xref-label>
                   <dl>
                      <dt>Symbol</dt>
                      <dd>Definition</dd>
                   </dl>
                </definitions>
             </clause>
             <definitions id="L" displayorder="16">
                <title id="_">Definitions</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="L">5</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Definitions</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="L">5</semx>
                </fmt-xref-label>
                <dl>
                   <dt>Symbol</dt>
                   <dd>Definition</dd>
                </dl>
             </definitions>
             <clause id="M" inline-header="false" obligation="normative" displayorder="17">
                <title id="_">Clause 4</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="M">6</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Clause 4</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="M">6</semx>
                </fmt-xref-label>
                <clause id="N" inline-header="false" obligation="normative">
                   <title id="_">Introduction</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="M">6</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="N">1</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Introduction</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="M">6</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="N">1</semx>
                   </fmt-xref-label>
                </clause>
                <clause id="O" inline-header="false" obligation="normative">
                   <title id="_">Clause 4.2</title>
                   <fmt-title depth="2">
                      <span class="fmt-caption-label">
                         <semx element="autonum" source="M">6</semx>
                         <span class="fmt-autonum-delim">.</span>
                         <semx element="autonum" source="O">2</semx>
                         <span class="fmt-autonum-delim">.</span>
                      </span>
                      <span class="fmt-caption-delim">
                         <tab/>
                      </span>
                      <semx element="title" source="_">Clause 4.2</semx>
                   </fmt-title>
                   <fmt-xref-label>
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="M">6</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="O">2</semx>
                   </fmt-xref-label>
                </clause>
             </clause>
             <references id="R" obligation="informative" normative="true" displayorder="14">
                <title id="_">Normative References</title>
                <fmt-title depth="1">
                   <span class="fmt-caption-label">
                      <semx element="autonum" source="R">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                   </span>
                   <span class="fmt-caption-delim">
                      <tab/>
                   </span>
                   <semx element="title" source="_">Normative References</semx>
                </fmt-title>
                <fmt-xref-label>
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="R">3</semx>
                </fmt-xref-label>
             </references>
          </sections>
    OUTPUT

    presxml1 = <<~OUTPUT
         <annex id="P" inline-header="false" obligation="normative" autonum="A" displayorder="18">
            <title id="_">
               <strong>Annex</strong>
            </title>
            <fmt-title>
               <strong>
                  <span class="fmt-caption-label">
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="P">A</semx>
                  </span>
               </strong>
               <br/>
               <span class="fmt-obligation">(normative)</span>
               <span class="fmt-caption-delim">
                  <br/>
               </span>
               <semx element="title" source="_">
                  <strong>Annex</strong>
               </semx>
            </fmt-title>
            <fmt-xref-label>
               <span class="fmt-element-name">Annex</span>
               <semx element="autonum" source="P">A</semx>
            </fmt-xref-label>
            <clause id="Q" inline-header="false" obligation="normative" autonum="A.1">
               <title id="_">Annex A.1</title>
               <fmt-title depth="2">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="P">A</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="Q">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Annex A.1</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Annex</span>
                  <semx element="autonum" source="P">A</semx>
                  <span class="fmt-autonum-delim">.</span>
                  <semx element="autonum" source="Q">1</semx>
               </fmt-xref-label>
               <clause id="Q1" inline-header="false" obligation="normative" autonum="A.1.1">
                  <title id="_">Annex A.1a</title>
                  <fmt-title depth="3">
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="P">A</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="Q">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="Q1">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                     <span class="fmt-caption-delim">
                        <tab/>
                     </span>
                     <semx element="title" source="_">Annex A.1a</semx>
                  </fmt-title>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="P">A</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="Q">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="Q1">1</semx>
                  </fmt-xref-label>
               </clause>
            </clause>
         </annex>
         <annex id="PP" obligation="normative" autonum="B" displayorder="19">
            <title id="_">
               <strong>Glossary</strong>
            </title>
            <fmt-title>
               <strong>
                  <span class="fmt-caption-label">
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="PP">B</semx>
                  </span>
               </strong>
               <br/>
               <span class="fmt-obligation">(normative)</span>
               <span class="fmt-caption-delim">
                  <br/>
               </span>
               <semx element="title" source="_">
                  <strong>Glossary</strong>
               </semx>
            </fmt-title>
            <fmt-xref-label>
               <span class="fmt-element-name">Annex</span>
               <semx element="autonum" source="PP">B</semx>
            </fmt-xref-label>
            <terms id="PP1" obligation="normative">
               <term id="term-glossary" autonum="B.1">
                  <fmt-name>
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="PP1">B</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="term-glossary">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="PP1">B</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="term-glossary">1</semx>
                  </fmt-xref-label>
                              <preferred id="_">
             <expression>
                <name>Glossary</name>
             </expression>
          </preferred>
          <fmt-preferred>
             <p>
                <semx element="preferred" source="_"><strong>Glossary</strong></semx>
             </p>
          </fmt-preferred>
               </term>
            </terms>
         </annex>
         <annex id="QQ" obligation="normative" autonum="C" displayorder="20">
            <title id="_">
               <strong>Glossary</strong>
            </title>
            <fmt-title>
               <strong>
                  <span class="fmt-caption-label">
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="QQ">C</semx>
                  </span>
               </strong>
               <br/>
               <span class="fmt-obligation">(normative)</span>
               <span class="fmt-caption-delim">
                  <br/>
               </span>
               <semx element="title" source="_">
                  <strong>Glossary</strong>
               </semx>
            </fmt-title>
            <fmt-xref-label>
               <span class="fmt-element-name">Annex</span>
               <semx element="autonum" source="QQ">C</semx>
            </fmt-xref-label>
            <terms id="QQ1" obligation="normative" autonum="C.1">
               <title id="_">Term Collection</title>
               <fmt-title depth="2">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ1">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Term Collection</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Annex</span>
                  <semx element="autonum" source="QQ">C</semx>
                  <span class="fmt-autonum-delim">.</span>
                  <semx element="autonum" source="QQ1">1</semx>
               </fmt-xref-label>
               <term id="term-term-1" autonum="C.1.1">
                  <fmt-name>
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="QQ">C</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="QQ1">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="term-term-1">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ1">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="term-term-1">1</semx>
                  </fmt-xref-label>
          <preferred id="_">
             <expression>
                <name>Term</name>
             </expression>
          </preferred>
          <fmt-preferred>
             <p>
                <semx element="preferred" source="_"><strong>Term</strong></semx>
             </p>
          </fmt-preferred>
               </term>
            </terms>
            <terms id="QQ2" obligation="normative" autonum="C.2">
               <title id="_">Term Collection 2</title>
               <fmt-title depth="2">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ2">2</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Term Collection 2</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Annex</span>
                  <semx element="autonum" source="QQ">C</semx>
                  <span class="fmt-autonum-delim">.</span>
                  <semx element="autonum" source="QQ2">2</semx>
               </fmt-xref-label>
               <term id="term-term-2" autonum="C.2.1">
                  <fmt-name>
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="QQ">C</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="QQ2">2</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="term-term-2">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ2">2</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="term-term-2">1</semx>
                  </fmt-xref-label>
          <preferred id="_">
             <expression>
                <name>Term</name>
             </expression>
          </preferred>
          <fmt-preferred>
             <p>
                <semx element="preferred" source="_"><strong>Term</strong></semx>
             </p>
          </fmt-preferred>
               </term>
            </terms>
         </annex>
         <bibliography>
            <clause id="S" obligation="informative" displayorder="21">
               <title id="_">Bibliography</title>
               <fmt-title depth="1">
                  <semx element="title" source="_">Bibliography</semx>
               </fmt-title>
               <references id="T" obligation="informative" normative="false">
                  <title id="_">Bibliography Subsection</title>
                  <fmt-title depth="2">
                     <semx element="title" source="_">Bibliography Subsection</semx>
                  </fmt-title>
               </references>
            </clause>
         </bibliography>
      </ogc-standard>
    OUTPUT

    output = <<~"OUTPUT"
      #{HTML_HDR}
             <br/>
              <div id="1">
                 <h1 class="AbstractTitle">I.  Abstract</h1>
                 <p>XYZ</p>
              </div>
              <br/>
              <div class="Section3" id="DD0">
                 <h1 class="IntroTitle">II.  Executive Summary</h1>
                 <p id="EE0">Text</p>
              </div>
              <div class="Section3" id="_">
                 <h1 class="IntroTitle">III.  Keywords</h1>
                 <p>The following are keywords to be used by search engines and document catalogues.</p>
                 <p>A, B</p>
              </div>
              <br/>
              <div id="2">
                 <h1 class="ForewordTitle">IV.  Preface</h1>
                 <p id="A">This is a preamble</p>
              </div>
              <div class="Section3" id="DD1">
                 <h1 class="IntroTitle">V.  Security</h1>
                 <p id="EE1">Text</p>
              </div>
              <div class="Section3" id="_">
                 <h1 class="IntroTitle">VI.  Submitting Organizations</h1>
                 <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
                 <div class="ul_wrap">
                    <ul>
                       <li>OGC</li>
                       <li>DEF</li>
                    </ul>
                 </div>
              </div>
              <div class="Section3" id="3">
                 <h1 class="IntroTitle">VII.  Submitters</h1>
                 <p>ABC</p>
              </div>
              <div class="Section3" id="3a">
                 <h1 class="IntroTitle">VIII.  Contributors</h1>
                 <p>ABC</p>
              </div>
              <div class="Section3" id="5">
                 <h1 class="IntroTitle">IX.  Dedication</h1>
                 <div id="6">
                    <h2>IX.A.  Note to readers</h2>
                 </div>
              </div>
              <div class="Section3" id="4">
                 <h1 class="IntroTitle">X.  Acknowlegements</h1>
                 <p>ABC</p>
              </div>
              <div id="D">
                 <h1>1.  Scope</h1>
                 <p id="E">Text</p>
              </div>
              <div id="D1">
                 <h1>2.  Conformance</h1>
                 <p id="E1">Text</p>
              </div>
              <div>
                 <h1>3.  Normative References</h1>
              </div>
              <div id="H">
                 <h1>4.  Terms, definitions, symbols and abbreviated terms</h1>
                 <div id="I">
                    <h2>4.1.  Normal Terms</h2>
                    <p class="TermNum" id="J">4.1.1.</p>
                    <p class="Terms" style="text-align:left;"><b>Term2</b></p>
                 </div>
                 <div id="K">
                    <h2>4.2.  Definitions</h2>
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
                 <h1>5.  Definitions</h1>
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
                 <h1>6.  Clause 4</h1>
                 <div id="N">
                    <h2>6.1.  Introduction</h2>
                 </div>
                 <div id="O">
                    <h2>6.2.  Clause 4.2</h2>
                 </div>
              </div>
              <br/>
    OUTPUT

    output1 = <<~OUTPUT
            <div id="P" class="Section3">
               <h1 class="Annex">
                  <b>Annex A</b>
                  <br/>
                  (normative)
                  <br/>
                  <b>Annex</b>
               </h1>
               <div id="Q">
                  <h2>A.1.  Annex A.1</h2>
                  <div id="Q1">
                     <h3>A.1.1.  Annex A.1a</h3>
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
                  <p class="Terms" style="text-align:left;"><b>Glossary</b></p>
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
                  <h2>C.1.  Term Collection</h2>
                  <p class="TermNum" id="term-term-1">C.1.1.</p>
                  <p class="Terms" style="text-align:left;"><b>Term</b></p>
               </div>
               <div id="QQ2">
                  <h2>C.2.  Term Collection 2</h2>
                  <p class="TermNum" id="term-term-2">C.2.1.</p>
                  <p class="Terms" style="text-align:left;"><b>Term</b></p>
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

    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml + presxml1)
    expect(Xml::C14n.format(strip_guid(
                              IsoDoc::Ogc::HtmlConvert.new({})
                       .convert("test", pres_output, true)
                              .gsub(%r{^.*<body}m, "<body")
                              .gsub(%r{</body>.*}m, "</body>"),
                            )))
      .to be_equivalent_to Xml::C14n.format(output + output1)

    presxml2 = <<~OUTPUT
         <annex id="P" inline-header="false" obligation="normative" autonum="A" displayorder="19">
            <title id="_">
               <strong>Annex</strong>
            </title>
            <fmt-title>
               <strong>
                  <span class="fmt-caption-label">
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="P">A</semx>
                  </span>
               </strong>
               <br/>
               <span class="fmt-obligation">(normative)</span>
               <span class="fmt-caption-delim">
                  <br/>
               </span>
               <semx element="title" source="_">
                  <strong>Annex</strong>
               </semx>
            </fmt-title>
            <fmt-xref-label>
               <span class="fmt-element-name">Annex</span>
               <semx element="autonum" source="P">A</semx>
            </fmt-xref-label>
            <clause id="Q" inline-header="false" obligation="normative" autonum="A.1">
               <title id="_">Annex A.1</title>
               <fmt-title depth="2">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="P">A</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="Q">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Annex A.1</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Annex</span>
                  <semx element="autonum" source="P">A</semx>
                  <span class="fmt-autonum-delim">.</span>
                  <semx element="autonum" source="Q">1</semx>
               </fmt-xref-label>
               <clause id="Q1" inline-header="false" obligation="normative" autonum="A.1.1">
                  <title id="_">Annex A.1a</title>
                  <fmt-title depth="3">
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="P">A</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="Q">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="Q1">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                     <span class="fmt-caption-delim">
                        <tab/>
                     </span>
                     <semx element="title" source="_">Annex A.1a</semx>
                  </fmt-title>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="P">A</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="Q">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="Q1">1</semx>
                  </fmt-xref-label>
               </clause>
            </clause>
         </annex>
         <annex id="PP" obligation="normative" autonum="B" displayorder="20">
            <title id="_">
               <strong>Glossary</strong>
            </title>
            <fmt-title>
               <strong>
                  <span class="fmt-caption-label">
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="PP">B</semx>
                  </span>
               </strong>
               <br/>
               <span class="fmt-obligation">(normative)</span>
               <span class="fmt-caption-delim">
                  <br/>
               </span>
               <semx element="title" source="_">
                  <strong>Glossary</strong>
               </semx>
            </fmt-title>
            <fmt-xref-label>
               <span class="fmt-element-name">Annex</span>
               <semx element="autonum" source="PP">B</semx>
            </fmt-xref-label>
            <terms id="PP1" obligation="normative">
               <term id="term-glossary" autonum="B.1">
                  <fmt-name>
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="PP1">B</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="term-glossary">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="PP1">B</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="term-glossary">1</semx>
                  </fmt-xref-label>
                  <preferred id="_">
                     <expression>
                        <name>Glossary</name>
                     </expression>
                  </preferred>
                  <fmt-preferred>
                     <p>
                        <semx element="preferred" source="_"><strong>Glossary</strong></semx>
                     </p>
                  </fmt-preferred>
               </term>
            </terms>
         </annex>
         <annex id="QQ" obligation="normative" autonum="C" displayorder="21">
            <title id="_">
               <strong>Glossary</strong>
            </title>
            <fmt-title>
               <strong>
                  <span class="fmt-caption-label">
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="QQ">C</semx>
                  </span>
               </strong>
               <br/>
               <span class="fmt-obligation">(normative)</span>
               <span class="fmt-caption-delim">
                  <br/>
               </span>
               <semx element="title" source="_">
                  <strong>Glossary</strong>
               </semx>
            </fmt-title>
            <fmt-xref-label>
               <span class="fmt-element-name">Annex</span>
               <semx element="autonum" source="QQ">C</semx>
            </fmt-xref-label>
            <terms id="QQ1" obligation="normative" autonum="C.1">
               <title id="_">Term Collection</title>
               <fmt-title depth="2">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ1">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Term Collection</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Annex</span>
                  <semx element="autonum" source="QQ">C</semx>
                  <span class="fmt-autonum-delim">.</span>
                  <semx element="autonum" source="QQ1">1</semx>
               </fmt-xref-label>
               <term id="term-term-1" autonum="C.1.1">
                  <fmt-name>
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="QQ">C</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="QQ1">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="term-term-1">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ1">1</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="term-term-1">1</semx>
                  </fmt-xref-label>
                  <preferred id="_">
                     <expression>
                        <name>Term</name>
                     </expression>
                  </preferred>
                  <fmt-preferred>
                     <p>
                        <semx element="preferred" source="_"><strong>Term</strong></semx>
                     </p>
                  </fmt-preferred>
               </term>
            </terms>
            <terms id="QQ2" obligation="normative" autonum="C.2">
               <title id="_">Term Collection 2</title>
               <fmt-title depth="2">
                  <span class="fmt-caption-label">
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ2">2</semx>
                     <span class="fmt-autonum-delim">.</span>
                  </span>
                  <span class="fmt-caption-delim">
                     <tab/>
                  </span>
                  <semx element="title" source="_">Term Collection 2</semx>
               </fmt-title>
               <fmt-xref-label>
                  <span class="fmt-element-name">Annex</span>
                  <semx element="autonum" source="QQ">C</semx>
                  <span class="fmt-autonum-delim">.</span>
                  <semx element="autonum" source="QQ2">2</semx>
               </fmt-xref-label>
               <term id="term-term-2" autonum="C.2.1">
                  <fmt-name>
                     <span class="fmt-caption-label">
                        <semx element="autonum" source="QQ">C</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="QQ2">2</semx>
                        <span class="fmt-autonum-delim">.</span>
                        <semx element="autonum" source="term-term-2">1</semx>
                        <span class="fmt-autonum-delim">.</span>
                     </span>
                  </fmt-name>
                  <fmt-xref-label>
                     <span class="fmt-element-name">Annex</span>
                     <semx element="autonum" source="QQ">C</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="QQ2">2</semx>
                     <span class="fmt-autonum-delim">.</span>
                     <semx element="autonum" source="term-term-2">1</semx>
                  </fmt-xref-label>
                  <preferred id="_">
                     <expression>
                        <name>Term</name>
                     </expression>
                  </preferred>
                  <fmt-preferred>
                     <p>
                        <semx element="preferred" source="_"><strong>Term</strong></semx>
                     </p>
                  </fmt-preferred>
               </term>
            </terms>
         </annex>
         <bibliography>
            <clause id="S" obligation="informative" unnumbered="true" displayorder="18">
               <title id="_">Bibliography</title>
               <fmt-title depth="1">
                  <semx element="title" source="_">Bibliography</semx>
               </fmt-title>
               <references id="T" obligation="informative" normative="false">
                  <title id="_">Bibliography Subsection</title>
                  <fmt-title depth="2">
                     <semx element="title" source="_">Bibliography Subsection</semx>
                  </fmt-title>
               </references>
            </clause>
         </bibliography>
      </ogc-standard>
    OUTPUT

    output2 = <<~OUTPUT
            <div>
          <h1 class="Section3">Bibliography</h1>
          <div>
            <h2 class="Section3">Bibliography Subsection</h2>
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
                  <h2>A.1.  Annex A.1</h2>
                  <div id="Q1">
                     <h3>A.1.1.  Annex A.1a</h3>
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
                  <p class="Terms" style="text-align:left;"><b>Glossary</b></p>
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
                  <h2>C.1.  Term Collection</h2>
                  <p class="TermNum" id="term-term-1">C.1.1.</p>
                  <p class="Terms" style="text-align:left;"><b>Term</b></p>
               </div>
               <div id="QQ2">
                  <h2>C.2.  Term Collection 2</h2>
                  <p class="TermNum" id="term-term-2">C.2.1.</p>
                  <p class="Terms" style="text-align:left;"><b>Term</b></p>
               </div>
            </div>
         </div>
      </body>
    OUTPUT

    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input.sub("technical-paper", "engineering-report"), true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(
        presxml.sub("technical-paper", "engineering-report") + presxml2,
      )
    expect(Xml::C14n.format(strip_guid(
                              IsoDoc::Ogc::HtmlConvert.new({})
                       .convert("test", pres_output, true)
                              .gsub(%r{^.*<body}m, "<body")
                              .gsub(%r{</body>.*}m, "</body>"),
                            ))).to be_equivalent_to Xml::C14n.format(output + output2)
  end
end
