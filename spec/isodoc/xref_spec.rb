require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "cross-references list items" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
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
      <foreword displayorder='1'>
        <p>
          <xref target='N1'>Introduction, a)</xref>
          <xref target='N2'>Clause II.A, 1)</xref>
          <xref target='N'>Clause 1, i)</xref>
          <xref target='note1'>Clause 3.1, List 1 a)</xref>
          <xref target='note2'>Clause 3.1, List 2 I)</xref>
          <xref target='AN'>Annex A.1, A)</xref>
          <xref target='Anote1'>Annex A.2, List 1 iv)</xref>
          <xref target='Anote2'>Annex A.2, List 2 a)</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references list items of steps class" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
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
      <foreword displayorder='1'>
        <p>
          <xref target='N1'>Introduction, 1)</xref>
          <xref target='N11'>Introduction, 1) 1)</xref>
          <xref target='N12'>Introduction, 1) 1) 1)</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references preface subclauses" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
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
      <foreword displayorder="1">
        <p>
          <xref target='A'>Introduction</xref>
          <xref target='B'>Clause II.A</xref>
          <xref target='C'>Clause II.A.1</xref>
          <xref target='D'>Clause II.A.1.a</xref>
          <xref target='E'>Clause II.A.1.a.i</xref>
          <xref target='F'>Clause II.A.1.a.i.(1)</xref>
          <xref target='G'>Clause II.A.1.a.i.(1).(a)</xref>
          <xref target='H'>Clause II.A.1.a.i.(1).(a).(i)</xref>
          <xref target='I'>Clause II.A.1.a.i.(1).(a).(i).1</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references preface subclauses" do
    input = <<~INPUT
                  <iso-standard xmlns="http://riboseinc.com/isoxml">
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
      <foreword displayorder='1'>
      <title depth='1'>Foreword</title>
        <p>
          <xref target='A'>Annex A</xref>
          <xref target='B'>Annex A.1</xref>
          <xref target='C'>Annex A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end
end
