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
      <foreword displayorder='2'>
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
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
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
      <foreword displayorder='2'>
        <p>
          <xref target='N1'>Introduction, 1)</xref>
          <xref target='N11'>Introduction, 1) 1)</xref>
          <xref target='N12'>Introduction, 1) 1) 1)</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
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
      <foreword displayorder="2">
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
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
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
      <foreword displayorder='2'>
      <title depth='1'>Foreword</title>
        <p>
          <xref target='A'>Annex A</xref>
          <xref target='B'>Annex A.1</xref>
          <xref target='C'>Annex A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
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
          <foreword displayorder='2'>
            <p>
              <xref target='N1'>Requirement 1</xref>
      <xref target='N2'>Requirement (??)</xref>
      <xref target='N'>Requirement 2</xref>
      <xref target='note1'>Requirement 3</xref>
      <xref target='note2'>Requirement 4</xref>
      <xref target='AN'>Requirement A.1</xref>
      <xref target='Anote1'>Requirement (??)</xref>
      <xref target='Anote2'>Requirement A.2</xref>
            </p>
          </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
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
          <foreword displayorder='2'>
            <p>
              <xref target='N1'>Recommendation 1</xref>
      <xref target='N2'>Recommendation (??)</xref>
      <xref target='N'>Recommendation 2</xref>
      <xref target='note1'>Recommendation 3</xref>
      <xref target='note2'>Recommendation 4</xref>
      <xref target='AN'>Recommendation A.1</xref>
      <xref target='Anote1'>Recommendation (??)</xref>
      <xref target='Anote2'>Recommendation A.2</xref>
            </p>
          </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
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
                 <foreword displayorder='2'>
                   <p>
                     <xref target='N1'>Permission 1</xref>
      <xref target='N2'>Permission (??)</xref>
      <xref target='N'>Permission 2</xref>
      <xref target='note1'>Permission 3</xref>
      <xref target='note2'>Permission 4</xref>
      <xref target='AN'>Permission A.1</xref>
      <xref target='Anote1'>Permission (??)</xref>
      <xref target='Anote2'>Permission A.2</xref>
                   </p>
                 </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
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
                <foreword displayorder='2'>
                  <p>
                     <xref target='N1'>Permission 1</xref>
      <xref target='N2'>Permission 1-1</xref>
      <xref target='N'>Permission 1-1-1</xref>
      <xref target='Q1'>Requirement 1-1</xref>
      <xref target='R1'>Recommendation 1-1</xref>
      <xref target='AN1'>Permission A.1</xref>
      <xref target='AN2'>Permission A.1-1</xref>
      <xref target='AN'>Permission A.1-1-1</xref>
      <xref target='AQ1'>Requirement A.1-1</xref>
      <xref target='AR1'>Recommendation A.1-1</xref>
                  </p>
                </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end
end
