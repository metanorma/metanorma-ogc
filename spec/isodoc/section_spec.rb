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
        <metanorma-extension>
                       #{METANORMA_EXTENSION}
        </metanorma-extension>
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

    html = Xml::C14n.format(<<~OUTPUT)
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
           <span class="DeprecatedLabel">DEPRECATED</span>
         </p>
         <p class="DeprecatedTerms" style="text-align:left;">
           Term2D 
           <span class="DeprecatedLabel">DEPRECATED</span>
         </p>
         <p>
           [
           <b>SOURCE:</b>
           ISO 7301:2011, Clause 3.1 , modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
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
                   1.1. Term2
                </p>
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
                   <span class="DeprecatedLabel">DEPRECATED</span>
                </p>
                <p class="DeprecatedTerms" style="text-align:left;">
                   Term2D 
                   <span class="DeprecatedLabel">DEPRECATED</span>
                </p>
                <p class="MsoNormal">
                   [
                   <b>SOURCE:</b>
                   ISO 7301:2011, Clause 3.1 , modified — The term "cargo rice" is shown as deprecated, and Note 1 to entry is not included here]
                </p>
             </div>
          </div>
          <div style="mso-element:footnote-list"/>
       </body>
    OUTPUT
    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    IsoDoc::Ogc::HtmlConvert.new({ filename: "test" })
      .convert("test", presxml, false)
    xml = Nokogiri::XML(File.read("test.html"))
    xml = xml.at("//div[@id = 'H']")
    expect(Xml::C14n.format(strip_guid(xml.to_xml))).to be_equivalent_to html
    IsoDoc::Ogc::WordConvert.new({ filename: "test" })
      .convert("test", presxml, false)
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
        <ext><doctype>technical-paper</doctype></ext>
      </bibdata>
        <metanorma-extension>
                       #{METANORMA_EXTENSION}
        </metanorma-extension>
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
    OUTPUT

    presxml1 = <<~OUTPUT
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

    output = <<~"OUTPUT"
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
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml + presxml1)
    expect(Xml::C14n.format(
             IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml + presxml1, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to Xml::C14n.format(output + output1)

    presxml1 = <<~OUTPUT
        <annex id="P" inline-header="false" obligation="normative" displayorder="19">
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
        <annex id="PP" obligation="normative" displayorder="20">
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
        <annex id="QQ" obligation="normative" displayorder="21">
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
          <clause id="S" obligation="informative" unnumbered="true" displayorder="18">
            <title depth="1">Bibliography</title>
            <references id="T" obligation="informative" normative="false">
              <title depth="2">Bibliography Subsection</title>
            </references>
          </clause>
        </bibliography>
      </ogc-standard>
    OUTPUT

    output1 = <<~OUTPUT
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
        </div>
      </body>
    OUTPUT

    xml = Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input.sub("technical-paper", "engineering-report"),
               true))
    xml.at("//xmlns:localized-strings").remove
    xml.at("//xmlns:metanorma-extension/xmlns:render").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(
        presxml.sub("technical-paper", "engineering-report") + presxml1,
      )
    expect(Xml::C14n.format(
             IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml.sub("technical-paper",
                                   "engineering-report") + presxml1, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to Xml::C14n.format(output + output1)
  end
end
