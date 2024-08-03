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
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
      <foreword displayorder='2'>
        <p>
          <xref target='N1'>Introduction, 1)</xref>
          <xref target='N11'>Introduction, 1) 1)</xref>
          <xref target='N12'>Introduction, 1) 1) 1)</xref>
        </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
      <foreword displayorder='2'>
      <title depth='1'>Foreword</title>
        <p>
          <xref target='A'>Annex A</xref>
          <xref target='B'>Annex A.1</xref>
          <xref target='C'>Annex A.2</xref>
        </p>
      </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri::XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
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
         <title>I.</title>
         <p>
           <xref target="N1">Figure 1</xref>
           <xref target="N2">Figure (??)</xref>
           <xref target="N">Diagram 1</xref>
           <xref target="note1">Plate 1</xref>
           <xref target="note3">Listing 1</xref>
           <xref target="note4">Listing 2</xref>
           <xref target="note2">Diagram 2</xref>
           <xref target="note5">Figure 2</xref>
           <xref target="AN">Diagram A.1</xref>
           <xref target="Anote1">Plate (??)</xref>
           <xref target="Anote2">Figure A.1</xref>
           <xref target="Anote3">Listing A.1</xref>
           <xref target="Anote31">Listing A.2</xref>
           <xref target="Anote32">Figure A.2</xref>
           <xref target="Anote4">Bibliographical Section, Figure 1</xref>
         </p>
       </foreword>
    OUTPUT
    expect(Xml::C14n.format(Nokogiri.XML(IsoDoc::Ogc::PresentationXMLConvert
      .new(presxml_options)
      .convert("test", input, true))
      .at("//xmlns:foreword").to_xml))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
