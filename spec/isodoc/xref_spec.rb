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
          <xref target='N11'>Introduction, 1.1)</xref>
          <xref target='N12'>Introduction, 1.1.1)</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references requirements" do
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
          <requirement id="N1">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note2">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <requirement id="AN">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="Anote2">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Requirement 1</xref>
          <xref target='N2'>Clause II.A, Requirement (??)</xref>
          <xref target='N'>Clause 1, Requirement 2</xref>
          <xref target='note1'>Clause 3.1, Requirement 3</xref>
          <xref target='note2'>Clause 3.1, Requirement 4</xref>
          <xref target='AN'>Annex A.1, Requirement A.1</xref>
          <xref target='Anote1'>Annex A.2, Requirement (??)</xref>
          <xref target='Anote2'>Annex A.2, Requirement A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references requirements with labels" do
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
          <requirement id="N1">
          <label>/ogc/req1</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true">
          <label>/ogc/req2</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N">
          <label>/ogc/req3</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1">
          <label>/ogc/req4</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note2">
          <label>/ogc/req5</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <requirement id="AN">
          <label>/ogc/req6</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true">
          <label>/ogc/req7</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="Anote2">
          <label>/ogc/req8</label>
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
              <p>
                   <xref target='N1'>
           Introduction, Requirement 1:
           <tt>/ogc/req1</tt>
         </xref>
         <xref target='N2'>
           Clause II.A, Requirement (??):
           <tt>/ogc/req2</tt>
         </xref>
         <xref target='N'>
           Clause 1, Requirement 2:
           <tt>/ogc/req3</tt>
         </xref>
         <xref target='note1'>
           Clause 3.1, Requirement 3:
           <tt>/ogc/req4</tt>
         </xref>
         <xref target='note2'>
           Clause 3.1, Requirement 4:
           <tt>/ogc/req5</tt>
         </xref>
         <xref target='AN'>
           Annex A.1, Requirement A.1:
           <tt>/ogc/req6</tt>
         </xref>
         <xref target='Anote1'>
           Annex A.2, Requirement (??):
           <tt>/ogc/req7</tt>
         </xref>
         <xref target='Anote2'>
           Annex A.2, Requirement A.2:
           <tt>/ogc/req8</tt>
         </xref>
              </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references requirement parts" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <preface>
          <foreword>
          <p>
          <xref target="N1a"/>
          <xref target="N1b"/>
          <xref target="N2a"/>
          <xref target="N2b"/>
          <xref target="Na"/>
          <xref target="Nb"/>
          <xref target="note1a"/>
          <xref target="note1b"/>
          <xref target="note2a"/>
          <xref target="note2b"/>
          <xref target="ANa"/>
          <xref target="ANb"/>
          <xref target="Anote1a"/>
          <xref target="Anote1b"/>
          <xref target="Anote2a"/>
          <xref target="Anote2b"/>
          </p>
          </foreword>
          <introduction id="intro">
          <requirement id="N1">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="N1a"/>
        <component class="part" id="N1b"/>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="N2a"/>
        <component class="part" id="N2b"/>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="Na"/>
        <component class="part" id="Nb"/>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="note1a"/>
        <component class="part" id="note1b"/>
        </requirement>
          <requirement id="note2">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="note2a"/>
        <component class="part" id="note2b"/>
        </requirement>
        <p>    <xref target="note1a"/> <xref target="note2b"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <requirement id="AN">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="ANa"/>
        <component class="part" id="ANb"/>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="Anote1a"/>
        <component class="part" id="Anote1b"/>
        </requirement>
          <requirement id="Anote2">
        <stem type="AsciiMath">r = 1 %</stem>
        <component class="part" id="Anote2a"/>
        <component class="part" id="Anote2b"/>
        </requirement>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder='1'>
        <p>
          <xref target='N1a'>Introduction, Requirement A</xref>
          <xref target='N1b'>Introduction, Requirement B</xref>
          <xref target='N2a'>Clause II.A, Requirement A</xref>
          <xref target='N2b'>Clause II.A, Requirement B</xref>
          <xref target='Na'>Clause 1, Requirement A</xref>
          <xref target='Nb'>Clause 1, Requirement B</xref>
          <xref target='note1a'>Clause 3.1, Requirement A</xref>
          <xref target='note1b'>Clause 3.1, Requirement B</xref>
          <xref target='note2a'>Clause 3.1, Requirement A</xref>
          <xref target='note2b'>Clause 3.1, Requirement B</xref>
          <xref target='ANa'>Annex A.1, Requirement A</xref>
          <xref target='ANb'>Annex A.1, Requirement B</xref>
          <xref target='Anote1a'>Annex A.2, Requirement A</xref>
          <xref target='Anote1b'>Annex A.2, Requirement B</xref>
          <xref target='Anote2a'>Annex A.2, Requirement A</xref>
          <xref target='Anote2b'>Annex A.2, Requirement B</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references requirement tests" do
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
          <requirement id="N1" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <clause id="xyz"><title>Preparatory</title>
          <requirement id="N2" unnumbered="true" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <requirement id="N" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <requirement id="note1" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="note2" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <requirement id="AN" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          <clause id="annex1b">
          <requirement id="Anote1" unnumbered="true" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          <requirement id="Anote2" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </requirement>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Requirement test 1</xref>
          <xref target='N2'>Clause II.A, Requirement test (??)</xref>
          <xref target='N'>Clause 1, Requirement test 2</xref>
          <xref target='note1'>Clause 3.1, Requirement test 3</xref>
          <xref target='note2'>Clause 3.1, Requirement test 4</xref>
          <xref target='AN'>Annex A.1, Requirement test A.1</xref>
          <xref target='Anote1'>Annex A.2, Requirement test (??)</xref>
          <xref target='Anote2'>Annex A.2, Requirement test A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references recommendations" do
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
          <recommendation id="N1">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <clause id="xyz"><title>Preparatory</title>
          <recommendation id="N2" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <recommendation id="N">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <recommendation id="note1">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="note2">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <recommendation id="AN">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          <clause id="annex1b">
          <recommendation id="Anote1" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="Anote2">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Recommendation 1</xref>
          <xref target='N2'>Clause II.A, Recommendation (??)</xref>
          <xref target='N'>Clause 1, Recommendation 2</xref>
          <xref target='note1'>Clause 3.1, Recommendation 3</xref>
          <xref target='note2'>Clause 3.1, Recommendation 4</xref>
          <xref target='AN'>Annex A.1, Recommendation A.1</xref>
          <xref target='Anote1'>Annex A.2, Recommendation (??)</xref>
          <xref target='Anote2'>Annex A.2, Recommendation A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references recommendation tests" do
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
          <recommendation id="N1" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <clause id="xyz"><title>Preparatory</title>
          <recommendation id="N2" unnumbered="true" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <recommendation id="N" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <recommendation id="note1" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="note2" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <recommendation id="AN" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          <clause id="annex1b">
          <recommendation id="Anote1" unnumbered="true" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          <recommendation id="Anote2" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </recommendation>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Recommendation test 1</xref>
          <xref target='N2'>Clause II.A, Recommendation test (??)</xref>
          <xref target='N'>Clause 1, Recommendation test 2</xref>
          <xref target='note1'>Clause 3.1, Recommendation test 3</xref>
          <xref target='note2'>Clause 3.1, Recommendation test 4</xref>
          <xref target='AN'>Annex A.1, Recommendation test A.1</xref>
          <xref target='Anote1'>Annex A.2, Recommendation test (??)</xref>
          <xref target='Anote2'>Annex A.2, Recommendation test A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references permissions" do
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
          <permission id="N1">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <clause id="xyz"><title>Preparatory</title>
          <permission id="N2" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <permission id="N">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <permission id="note1">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="note2">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <permission id="AN">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex1b">
          <permission id="Anote1" unnumbered="true">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="Anote2">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Permission 1</xref>
          <xref target='N2'>Clause II.A, Permission (??)</xref>
          <xref target='N'>Clause 1, Permission 2</xref>
          <xref target='note1'>Clause 3.1, Permission 3</xref>
          <xref target='note2'>Clause 3.1, Permission 4</xref>
          <xref target='AN'>Annex A.1, Permission A.1</xref>
          <xref target='Anote1'>Annex A.2, Permission (??)</xref>
          <xref target='Anote2'>Annex A.2, Permission A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references permission tests" do
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
          <permission id="N1" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <clause id="xyz"><title>Preparatory</title>
          <permission id="N2" unnumbered="true" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <permission id="N" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <permission id="note1" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="note2" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <permission id="AN" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex1b">
          <permission id="Anote1" unnumbered="true" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="Anote2" type="verification">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Permission test 1</xref>
          <xref target='N2'>Clause II.A, Permission test (??)</xref>
          <xref target='N'>Clause 1, Permission test 2</xref>
          <xref target='note1'>Clause 3.1, Permission test 3</xref>
          <xref target='note2'>Clause 3.1, Permission test 4</xref>
          <xref target='AN'>Annex A.1, Permission test A.1</xref>
          <xref target='Anote1'>Annex A.2, Permission test (??)</xref>
          <xref target='Anote2'>Annex A.2, Permission test A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "labels and cross-references nested requirements" do
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
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
      <permission id="N1">
      <permission id="N2" type="verification">
      <permission id="N">
      </permission>
      </permission>
      <requirement id="Q1">
      </requirement>
      <recommendation id="R1">
      </recommendation>
      <permission id="N3" type="verification"/>
      <permission id="N4"/>
      </permission>
      </clause>
      </sections>
      <annex id="Axyz"><title>Preparatory</title>
      <permission id="AN1" type="verification">
      <permission id="AN2">
      <permission id="AN" type="verification">
      </permission>
      </permission>
      <requirement id="AQ1">
      </requirement>
      <recommendation id="AR1">
      </recommendation>
      <permission id="AN3" type="verification"/>
      <permission id="AN4"/>
      </permission>
      </annex>
      </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Clause 1, Permission 1</xref>
          <xref target='N2'>Clause 1, Permission test 1-1</xref>
          <xref target='N'>Clause 1, Permission 1-1-1</xref>
          <xref target='Q1'>Clause 1, Requirement 1-1</xref>
          <xref target='R1'>Clause 1, Recommendation 1-1</xref>
          <xref target='AN1'>Annex A, Permission test A.1</xref>
          <xref target='AN2'>Annex A, Permission A.1-1</xref>
          <xref target='AN'>Annex A, Permission test A.1-1-1</xref>
          <xref target='AQ1'>Annex A, Requirement A.1-1</xref>
          <xref target='AR1'>Annex A, Recommendation A.1-1</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references abstract tests" do
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
          <permission id="N1" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <clause id="xyz"><title>Preparatory</title>
          <permission id="N2" unnumbered="true" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <permission id="N" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <permission id="note1" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="note2" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <permission id="AN" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex1b">
          <permission id="Anote1" unnumbered="true" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="Anote2" type="abstracttest">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Abstract test 1</xref>
          <xref target='N2'>Clause II.A, Abstract test (??)</xref>
          <xref target='N'>Clause 1, Abstract test 2</xref>
          <xref target='note1'>Clause 3.1, Abstract test 3</xref>
          <xref target='note2'>Clause 3.1, Abstract test 4</xref>
          <xref target='AN'>Annex A.1, Abstract test A.1</xref>
          <xref target='Anote1'>Annex A.2, Abstract test (??)</xref>
          <xref target='Anote2'>Annex A.2, Abstract test A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(xmlpp(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to xmlpp(output)
  end

  it "cross-references conformance classes" do
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
          <permission id="N1" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <clause id="xyz"><title>Preparatory</title>
          <permission id="N2" unnumbered="true" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
      </clause>
          </introduction>
          </preface>
          <sections>
          <clause id="scope" type="scope"><title>Scope</title>
          <permission id="N" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p><xref target="N"/></p>
          </clause>
          <terms id="terms"/>
          <clause id="widgets"><title>Widgets</title>
          <clause id="widgets1">
          <permission id="note1" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="note2" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
        <p>    <xref target="note1"/> <xref target="note2"/> </p>
          </clause>
          </clause>
          </sections>
          <annex id="annex1">
          <clause id="annex1a">
          <permission id="AN" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          <clause id="annex1b">
          <permission id="Anote1" unnumbered="true" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          <permission id="Anote2" type="conformanceclass">
        <stem type="AsciiMath">r = 1 %</stem>
        </permission>
          </clause>
          </annex>
          </iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder="1">
        <p>
          <xref target='N1'>Introduction, Conformance class 1</xref>
          <xref target='N2'>Clause II.A, Conformance class (??)</xref>
          <xref target='N'>Clause 1, Conformance class 2</xref>
          <xref target='note1'>Clause 3.1, Conformance class 3</xref>
          <xref target='note2'>Clause 3.1, Conformance class 4</xref>
          <xref target='AN'>Annex A.1, Conformance class A.1</xref>
          <xref target='Anote1'>Annex A.2, Conformance class (??)</xref>
          <xref target='Anote2'>Annex A.2, Conformance class A.2</xref>
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
      <foreword>
      <p>
      <xref target="A"/>
      <xref target="B"/>
      <xref target="C"/>
      </p>
      </foreword>
      </preface>
      <annex id="A">
      <title>Glossary</title>
      <terms>
      <term id="B"><preferred>Term B</preferred></term>
      <term id="C"><preferred>Term C</preferred></term>
      </terms>
      </annex>
      <iso-standard>
    INPUT
    output = <<~OUTPUT
      <foreword displayorder='1'>
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
