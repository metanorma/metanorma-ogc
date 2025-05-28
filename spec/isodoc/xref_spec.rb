require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "cross-references list items" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
          <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <title>Introduction</title>
          <ol id="N01">
        <li id="N1"><p>A</p></li>
      </ol>
        <clause id="xyz"><title>Preparatory</title>
           <ol id="N02" type="arabic">
        <li id="N2"><p>A</p></li>
      </ol>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <ol id="N0" type="roman">
        <li id="N"><p>A</p></li>
      </ol>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <ol id="note1l" type="alphabet">
        <li id="note1"><p>A</p></li>
      </ol>
          <ol id="note2l" type="roman_upper">
        <li id="note2"><p>A</p></li>
      </ol>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <ol id="ANl" type="alphabet_upper">
        <li id="AN"><p>A</p></li>
      </ol>
          </clause>
          <clause id="annex1b">
          <ol id="Anote1l" type="roman" start="4">
        <li id="Anote1"><p>A</p></li>
      </ol>
          <ol id="Anote2l">
        <li id="Anote2"><p>A</p></li>
      </ol>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
         <foreword id="_" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Preface</semx>
           </fmt-xref-label>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-xref-container">
                      <semx element="title" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <semx element="autonum" source="N1">a</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="N2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="intro">II</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="xyz">A</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <semx element="autonum" source="N2">1</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="N" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="scope">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <semx element="autonum" source="N">i</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="note1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="widgets">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="widgets1">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">List</span>
                   <semx element="autonum" source="note1l">1</semx>
                   <semx element="autonum" source="note1">a</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="note2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="note2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Clause</span>
                      <semx element="autonum" source="widgets">3</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="widgets1">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">List</span>
                   <semx element="autonum" source="note2l">2</semx>
                   <semx element="autonum" source="note2">I</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="AN" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="AN">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex1">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1a">1</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <semx element="autonum" source="AN">A</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="Anote1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote1">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex1">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">List</span>
                   <semx element="autonum" source="Anote1l">1</semx>
                   <semx element="autonum" source="Anote1">iv</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="Anote2" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="Anote2">
                   <span class="fmt-xref-container">
                      <span class="fmt-element-name">Annex</span>
                      <semx element="autonum" source="annex1">A</semx>
                      <span class="fmt-autonum-delim">.</span>
                      <semx element="autonum" source="annex1b">2</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <span class="fmt-element-name">List</span>
                   <semx element="autonum" source="Anote2l">2</semx>
                   <semx element="autonum" source="Anote2">a</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references list items of steps class" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
          <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N11"/>
          <xref target="N12"/>
          </p>
          </foreword>
          <introduction id="intro">
          <title>Introduction</title>
          <ol id="N01" class="steps">
        <li id="N1"><p>A</p>
          <ol id="N011">
        <li id="N11"><p>A</p>
          <ol id="N012">
        <li id="N12"><p>A</p>
         </li>
      </ol></li></ol></li></ol>
        <clause id="xyz"><title>Preparatory</title>
           <ol id="N02" type="arabic">
        <li id="N2"><p>A</p></li>
      </ol>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <ol id="N0" type="roman">
        <li id="N"><p>A</p></li>
      </ol>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <ol id="note1l" type="alphabet">
        <li id="note1"><p>A</p></li>
      </ol>
          <ol id="note2l" type="roman_upper">
        <li id="note2"><p>A</p></li>
      </ol>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <ol id="ANl" type="alphabet_upper">
        <li id="AN"><p>A</p></li>
      </ol>
          </clause>
          <clause id="annex1b">
          <ol id="Anote1l" type="roman" start="4">
        <li id="Anote1"><p>A</p></li>
      </ol>
          <ol id="Anote2l">
        <li id="Anote2"><p>A</p></li>
      </ol>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword id="_" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Preface</semx>
           </fmt-xref-label>
          <p>
             <xref target="N1" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N1">
                   <span class="fmt-xref-container">
                      <semx element="title" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <semx element="autonum" source="N1">1</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="N11" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N11">
                   <span class="fmt-xref-container">
                      <semx element="title" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <semx element="autonum" source="N1">1</semx>
                   <span class="fmt-autonum-delim">)</span>
                   <semx element="autonum" source="N11">1</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
             <xref target="N12" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="N12">
                   <span class="fmt-xref-container">
                      <semx element="title" source="intro">Introduction</semx>
                   </span>
                   <span class="fmt-comma">,</span>
                   <semx element="autonum" source="N1">1</semx>
                   <span class="fmt-autonum-delim">)</span>
                   <semx element="autonum" source="N11">1</semx>
                   <span class="fmt-autonum-delim">)</span>
                   <semx element="autonum" source="N12">1</semx>
                   <span class="fmt-autonum-delim">)</span>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references preface subclauses" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
      <preface>
      <foreword>
      <p>
      <xref target="A"/>
      <xref target="B"/>
      <xref target="C"/>
      <xref target="D"/>
      <xref target="E"/>
      <xref target="F"/>
      <xref target="G"/>
      <xref target="H"/>
      <xref target="I"/>
      </p>
      </foreword>
      <introduction id="A"><title>Introduction</title>
      <clause id="B">
      <clause id="C">
      <clause id="D">
      <clause id="E">
      <clause id="F">
      <clause id="G">
      <clause id="H">
      <clause id="I">
      </clause>
      </clause>
      </clause>
      </clause>
      </clause>
      </clause>
      </clause>
      </clause>
      </introduction>
      </preface>
      </sections/>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword id="_" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Preface</semx>
           </fmt-xref-label>
          <p>
             <xref target="A" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A">
                   <semx element="title" source="A">Introduction</semx>
                </fmt-xref>
             </semx>
             <xref target="B" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                </fmt-xref>
             </semx>
             <xref target="C" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="C">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">1</semx>
                </fmt-xref>
             </semx>
             <xref target="D" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="D">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">1</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="D">a</semx>
                </fmt-xref>
             </semx>
             <xref target="E" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="E">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">1</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="D">a</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="E">i</semx>
                </fmt-xref>
             </semx>
             <xref target="F" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="F">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">1</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="D">a</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="E">i</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="F">(1)</semx>
                </fmt-xref>
             </semx>
             <xref target="G" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="G">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">1</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="D">a</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="E">i</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="F">(1)</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="G">(a)</semx>
                </fmt-xref>
             </semx>
             <xref target="H" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="H">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">1</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="D">a</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="E">i</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="F">(1)</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="G">(a)</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="H">(i)</semx>
                </fmt-xref>
             </semx>
             <xref target="I" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="I">
                   <span class="fmt-element-name">Clause</span>
                   <semx element="autonum" source="A">II</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">1</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="D">a</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="E">i</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="F">(1)</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="G">(a)</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="H">(i)</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="I">1</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references preface subclauses" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
      <preface>
      <foreword><title>Foreword</title>
      <p>
      <xref target="A"/>
      <xref target="B"/>
      <xref target="C"/>
      </p>
      </foreword>
      </preface>
      <annex id="A">
      <title>Glossary</title>
      <terms><title>Terms</title>
      <term id="B"><preferred>Term B</preferred></term>
      <term id="C"><preferred>Term C</preferred></term>
      </terms>
      </annex>
      <iso-standard>
    INPUT
    output = <<~OUTPUT
         <foreword id="_" displayorder="2">
           <title id="_">Foreword</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Foreword</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Foreword</semx>
           </fmt-xref-label>
          <p>
             <xref target="A" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="A">
                   <span class="fmt-element-name">Annex</span>
                   <semx element="autonum" source="A">A</semx>
                </fmt-xref>
             </semx>
             <xref target="B" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="B">
                   <span class="fmt-element-name">Annex</span>
                   <semx element="autonum" source="_">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="B">1</semx>
                </fmt-xref>
             </semx>
             <xref target="C" id="_"/>
             <semx element="xref" source="_">
                <fmt-xref target="C">
                   <span class="fmt-element-name">Annex</span>
                   <semx element="autonum" source="_">A</semx>
                   <span class="fmt-autonum-delim">.</span>
                   <semx element="autonum" source="C">2</semx>
                </fmt-xref>
             </semx>
          </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references requirements" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <requirement id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <requirement id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
         <foreword id="_" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Preface</semx>
           </fmt-xref-label>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="N1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="N">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="note1">3</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="note2">4</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references recommendations" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <recommendation id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <clause id="xyz"><title>Preparatory</title>
          <recommendation id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <recommendation id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <recommendation id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <recommendation id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          <clause id="annex1b">
          <recommendation id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword id="_" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Preface</semx>
           </fmt-xref-label>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="N1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="N">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="note1">3</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="note2">4</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references permissions" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
                  <preface>
          <foreword>
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note2"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          </p>
          </foreword>
          <introduction id="intro">
          <permission id="N1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <clause id="xyz"><title>Preparatory</title>
          <permission id="N2" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <permission id="N" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <permission id="note1" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="note2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <permission id="AN" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex1b">
          <permission id="Anote1" unnumbered="true" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="Anote2" model="default">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword id="_" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Preface</semx>
           </fmt-xref-label>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="N1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="N">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="note1">3</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="note2">4</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Anote2">2</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "labels and cross-references nested requirements" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata/>
              <preface>
      <foreword>
      <p>
      <xref target="N1"/>
      <xref target="N2"/>
      <xref target="N"/>
      <xref target="Q1"/>
      <xref target="R1"/>
      <xref target="AN1"/>
      <xref target="AN2"/>
      <xref target="AN"/>
      <xref target="AQ1"/>
      <xref target="AR1"/>
      </p>
      </foreword>
      </preface>
      <sections>
      <clause id="xyz"><title>Preparatory</title>
      <permission id="N1" model="default">
      <permission id="N2" model="default">
      <permission id="N" model="default">
      </permission>
      </permission>
      <requirement id="Q1" model="default">
      </requirement>
      <recommendation id="R1" model="default">
      </recommendation>
      </permission>
      </clause>
      </sections>
      <annex id="Axyz"><title>Preparatory</title>
      <permission id="AN1" model="default">
      <permission id="AN2" model="default">
      <permission id="AN" model="default">
      </permission>
      </permission>
      <requirement id="AQ1" model="default">
      </requirement>
      <recommendation id="AR1" model="default">
      </recommendation>
      </permission>
      </annex>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
         <foreword id="_" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title depth="1" id="_">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="_">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="_">Preface</semx>
           </fmt-xref-label>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="N1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Q1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Q1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="Q1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="R1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="R1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="N1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="R1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN1">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN2">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Permission</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN2">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AQ1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AQ1">
                    <span class="fmt-element-name">Requirement</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AQ1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="AR1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AR1">
                    <span class="fmt-element-name">Recommendation</span>
                    <semx element="autonum" source="Axyz">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN1">1</semx>
                    <span class="fmt-autonum-delim">-</span>
                    <semx element="autonum" source="AR1">1</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "cross-references figure classes" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
              <preface>
          <foreword id="fwd">
          <p>
          <xref target="N1"/>
          <xref target="N2"/>
          <xref target="N"/>
          <xref target="note1"/>
          <xref target="note3"/>
          <xref target="note4"/>
          <xref target="note2"/>
          <xref target="note5"/>
          <xref target="AN"/>
          <xref target="Anote1"/>
          <xref target="Anote2"/>
          <xref target="Anote3"/>
          <xref target="Anote31"/>
          <xref target="Anote32"/>
          <xref target="Anote4"/>
          </p>
          </foreword>
              <introduction id="intro">
              <figure id="N1">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <clause id="xyz"><title>Preparatory</title>
              <figure id="N2" unnumbered="true">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
              <figure id="N" class="diagram">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
      <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
              <figure id="note1" class="plate">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <figure id="note3" class="pseudocode">
        <p>pseudocode</p>
        </figure>
        <sourcecode id="note4" class="diagram"><name>Source! Code!</name>
        A B C
        </sourcecode>
        <figure id="note5">
        <sourcecode id="note51">
        A B C
        </sourcecode>
        </figure>
          <figure id="note2" class="diagram">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
              <figure id="AN" class="diagram">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </clause>
          <clause id="annex1b">
              <figure id="Anote1" unnumbered="true" class="plate">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          <figure id="Anote2">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
        <sourcecode id="Anote3"><name>Source! Code!</name>
        A B C
        </sourcecode>
        <figure id="Anote31" class="pseudocode">
        <p>pseudocode</p>
        </figure>
          <figure id="Anote32">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </clause>
          </annex>
          <bibliography><references normative="false" id="biblio"><title>Bibliographical Section</title>
          <figure id="Anote4">
        <name>Split-it-right sample divider</name>
        <image src="rice_images/rice_image1.png" id="_8357ede4-6d44-4672-bac4-9a85e82ab7f0" mimetype="image/png"/>
        </figure>
          </references></bibliography>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
        <foreword id="fwd" displayorder="2">
           <title id="_">Preface</title>
           <fmt-title id="_" depth="1">
              <span class="fmt-caption-label">
                 <semx element="autonum" source="fwd">I</semx>
                 <span class="fmt-autonum-delim">.</span>
              </span>
              <span class="fmt-caption-delim">
                 <tab/>
              </span>
              <semx element="title" source="_">Preface</semx>
           </fmt-title>
           <fmt-xref-label>
              <semx element="title" source="fwd">Preface</semx>
           </fmt-xref-label>
           <p>
              <xref target="N1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N1">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="N2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N2">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="N2">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="N" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="N">
                    <span class="fmt-element-name">Diagram</span>
                    <semx element="autonum" source="N">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note1">
                    <span class="fmt-element-name">Plate</span>
                    <semx element="autonum" source="note1">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note3">
                    <span class="fmt-element-name">Listing</span>
                    <semx element="autonum" source="note3">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="note4" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note4">
                    <span class="fmt-element-name">Listing</span>
                    <semx element="autonum" source="note4">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note2">
                    <span class="fmt-element-name">Diagram</span>
                    <semx element="autonum" source="note2">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="note5" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="note5">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="note5">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="AN" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="AN">
                    <span class="fmt-element-name">Diagram</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="AN">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote1" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote1">
                    <span class="fmt-element-name">Plate</span>
                    <semx element="autonum" source="Anote1">(??)</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote2" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote2">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Anote2">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote3" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote3">
                    <span class="fmt-element-name">Listing</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Anote3">1</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote31" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote31">
                    <span class="fmt-element-name">Listing</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Anote31">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote32" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote32">
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="annex1">A</semx>
                    <span class="fmt-autonum-delim">.</span>
                    <semx element="autonum" source="Anote32">2</semx>
                 </fmt-xref>
              </semx>
              <xref target="Anote4" id="_"/>
              <semx element="xref" source="_">
                 <fmt-xref target="Anote4">
                    <span class="fmt-xref-container">
                       <semx element="references" source="biblio">Bibliographical Section</semx>
                    </span>
                    <span class="fmt-comma">,</span>
                    <span class="fmt-element-name">Figure</span>
                    <semx element="autonum" source="Anote4">1</semx>
                 </fmt-xref>
              </semx>
           </p>
        </foreword>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
