require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ogc do
  it "processes submitters" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      [abstract]
      Abstract

      == Acknowledgements

      == Clause
      Clause 1

      == Submitters
      Clause 2

      |===
      |Name |Affiliation |OGC member

      |Steve Liang | University of Calgary, Canada / SensorUp Inc. | Yes
      |===
    INPUT

    output = <<~"OUTPUT"
          <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
      <preface><foreword id="_" obligation="informative">
      <title>Preface</title><p id="_">This is a preamble</p></foreword>
      <acknowledgements id='_' anchor="_acknowledgements" obligation='informative'>
        <title>Acknowledgements</title>
      </acknowledgements>
      #{SECURITY}
      <clause type="submitters" obligation="informative" id="_" anchor="_submitters">
      <title>Submitters</title>
        <p id="_">Clause 2</p>
                <table id='_' unnumbered='true'>
           <thead>
             <tr>
               <th id="_" valign='middle' align='left'>Name</th>
               <th id="_" valign='middle' align='left'>Affiliation</th>
               <th id="_" valign='middle' align='left'>OGC member</th>
             </tr>
           </thead>
           <tbody>
             <tr>
               <td id="_" valign='middle' align='left'>Steve Liang</td>
               <td id="_" valign='middle' align='left'>University of Calgary, Canada / SensorUp Inc.</td>
               <td id="_" valign='middle' align='left'>Yes</td>
             </tr>
           </tbody>
         </table>
      </clause>
      </preface><sections>
      <clause id="_" anchor="_clause" obligation="normative">
        <title>Clause</title>
        <p id="_">Clause 1</p>
      </clause></sections>
      </metanorma>
    OUTPUT

    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
              "//xmlns:metanorma-extension").each(&:remove)
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)

    output = <<~OUTPUT
              <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
      <preface><foreword id="_" obligation="informative">
      <title>Preface</title><p id="_">This is a preamble</p></foreword>
      <acknowledgements id='_' anchor="_acknowledgements" obligation='informative'>
        <title>Acknowledgements</title>
      </acknowledgements>
      #{SECURITY}
      <clause obligation="informative" id="_" anchor="_contributors" type="contributors">
      <title>Contributors</title>
        <p id="_">Clause 2</p>
                <table id='_' unnumbered='true'>
           <thead>
             <tr>
               <th id="_" valign='middle' align='left'>Name</th>
               <th id="_" valign='middle' align='left'>Affiliation</th>
               <th id="_" valign='middle' align='left'>OGC member</th>
             </tr>
           </thead>
           <tbody>
             <tr>
               <td id="_" valign='middle' align='left'>Steve Liang</td>
               <td id="_" valign='middle' align='left'>University of Calgary, Canada / SensorUp Inc.</td>
               <td id="_" valign='middle' align='left'>Yes</td>
             </tr>
           </tbody>
         </table>
      </clause>
      </preface><sections>
      <clause id="_" anchor="_clause" obligation="normative">
        <title>Clause</title>
        <p id="_">Clause 1</p>
      </clause></sections>
      </metanorma>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor
      .convert(input.sub("Submitters", "Contributors"), *OPTIONS))
    xml.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
              "//xmlns:metanorma-extension").each(&:remove)
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes submitters in Engineering Reports" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR.sub(':nodoc:', ":doctype: engineering-report\n:nodoc:")}
      This is a preamble

      [abstract]
      Abstract

      == Acknowledgements

      == Clause
      Clause 1

      == Submitters
      Clause 2

      |===
      |Name |Affiliation |OGC member

      |Steve Liang | University of Calgary, Canada / SensorUp Inc. | Yes
      |===
    INPUT

    output = <<~"OUTPUT"
          <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
      <preface><foreword id="_" obligation="informative">
      <title>Preface</title><p id="_">This is a preamble</p></foreword>
      <acknowledgements id='_' anchor="_acknowledgements" obligation='informative'>
        <title>Acknowledgements</title>
      </acknowledgements>
      <clause type="submitters" obligation="informative" id="_" anchor="_submitters">
      <title>Submitters</title>
        <p id="_">Clause 2</p>
                <table id='_' unnumbered='true'>
           <thead>
             <tr>
               <th id="_" valign='middle' align='left'>Name</th>
               <th id="_" valign='middle' align='left'>Affiliation</th>
               <th id="_" valign='middle' align='left'>OGC member</th>
             </tr>
           </thead>
           <tbody>
             <tr>
               <td id="_" valign='middle' align='left'>Steve Liang</td>
               <td id="_" valign='middle' align='left'>University of Calgary, Canada / SensorUp Inc.</td>
               <td id="_" valign='middle' align='left'>Yes</td>
             </tr>
           </tbody>
         </table>
      </clause>
      </preface><sections>
      <clause id="_" anchor="_clause" obligation="normative">
        <title>Clause</title>
        <p id="_">Clause 1</p>
      </clause></sections>
      </metanorma>
    OUTPUT

    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
              "//xmlns:metanorma-extension").each(&:remove)
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)

    xml = Nokogiri::XML(Asciidoctor
      .convert(input.sub("Submitters", "Contributors"), *OPTIONS))
    xml.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
              "//xmlns:metanorma-extension").each(&:remove)
    output = <<~OUTPUT
          <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
      <preface><foreword id="_" obligation="informative">
      <title>Preface</title><p id="_">This is a preamble</p></foreword>
      <acknowledgements id='_' anchor="_acknowledgements" obligation='informative'>
        <title>Acknowledgements</title>
      </acknowledgements>
      <clause obligation="informative" id="_" anchor="_contributors" type="contributors">
      <title>Contributors</title>
        <p id="_">Clause 2</p>
                <table id='_' unnumbered='true'>
           <thead>
             <tr>
               <th id="_" valign='middle' align='left'>Name</th>
               <th id="_" valign='middle' align='left'>Affiliation</th>
               <th id="_" valign='middle' align='left'>OGC member</th>
             </tr>
           </thead>
           <tbody>
             <tr>
               <td id="_" valign='middle' align='left'>Steve Liang</td>
               <td id="_" valign='middle' align='left'>University of Calgary, Canada / SensorUp Inc.</td>
               <td id="_" valign='middle' align='left'>Yes</td>
             </tr>
           </tbody>
         </table>
      </clause>
      </preface><sections>
      <clause id="_" anchor="_clause" obligation="normative">
        <title>Clause</title>
        <p id="_">Clause 1</p>
      </clause></sections>
      </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes contributors plus submitters" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      [abstract]
      Abstract

      == Acknowledgements

      == Clause
      Clause 1

      == Submitters
      Clause 2

      |===
      |Name |Affiliation |OGC member

      |Steve Liang | University of Calgary, Canada / SensorUp Inc. | Yes
      |===

      == Contributors
      Clause 3
    INPUT

    output = <<~"OUTPUT"
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
      <preface><foreword id="_" obligation="informative">
      <title>Preface</title><p id="_">This is a preamble</p></foreword>
      <acknowledgements id='_' anchor="_acknowledgements" obligation='informative'>
        <title>Acknowledgements</title>
      </acknowledgements>
      #{SECURITY}
      <clause type="submitters" obligation="informative" id="_" anchor="_submitters" >
      <title>Submitters</title>
        <p id="_">Clause 2</p>
                <table id='_' unnumbered='true'>
           <thead>
             <tr>
               <th id="_" valign='middle' align='left'>Name</th>
               <th id="_" valign='middle' align='left'>Affiliation</th>
               <th id="_" valign='middle' align='left'>OGC member</th>
             </tr>
           </thead>
           <tbody>
             <tr>
               <td id="_" valign='middle' align='left'>Steve Liang</td>
               <td id="_" valign='middle' align='left'>University of Calgary, Canada / SensorUp Inc.</td>
               <td id="_" valign='middle' align='left'>Yes</td>
             </tr>
           </tbody>
         </table>
      </clause>
          <clause obligation="informative" id="_" anchor="_contributors" type="contributors">
      <title>Contributors</title>
      <p id="_">Clause 3</p>
      </clause>
      </preface><sections>
      <clause id="_" anchor="_clause" obligation="normative">
        <title>Clause</title>
        <p id="_">Clause 1</p>
      </clause></sections>
      </metanorma>
    OUTPUT

    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:bibdata | //xmlns:boilerplate | " \
              "//xmlns:metanorma-extension").each(&:remove)
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes References" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}

      [bibliography]
      == References
    INPUT

    output = Xml::C14n.format(<<~OUTPUT)
      <bibliography><references id="_" anchor="_references" obligation="informative" normative="true">
        <title>Normative references</title>
        <p id="_">There are no normative references in this document.</p>
      </references></bibliography>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml = xml.at("//xmlns:bibliography")
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to output
  end

  it "strips inline header" do
    input = <<~"INPUT"
      #{ASCIIDOC_BLANK_HDR}
      This is a preamble

      == Section 1
    INPUT

    output = Xml::C14n.format(<<~"OUTPUT")
      #{blank_hdr_gen}
               <preface><foreword id="_" obligation="informative">
           <title>Preface</title>
           <p id="_">This is a preamble</p>
         </foreword>
         #{SECURITY}</preface>
          <sections>
         <clause id="_" anchor="_section_1" obligation="normative">
           <title>Section 1</title>
         </clause></sections>
         </metanorma>
    OUTPUT

    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to output
  end

  it "leaves user boilerplate alone in terms & definitions" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Terms and Definitions

      This is a prefatory paragraph

    INPUT
    output = <<~OUTPUT
        #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
          <sections><terms id="_" anchor="_terms_and_definitions" obligation="normative">
           <title>Terms and definitions</title><p id="_">No terms and definitions are listed in this document.</p>
           <p id="_">This is a prefatory paragraph</p>
         </terms>
         </sections>
         </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes preface section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Preface

      This is a prefatory paragraph

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
       <preface>
           <foreword id='_' anchor="_preface" obligation='informative'>
             <title>Preface</title>
             <p id='_'>This is a prefatory paragraph</p>
           </foreword>
           #{SECURITY}
         </preface>
         <sections> </sections>
       </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes conformance section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Conformance

    INPUT
    output = <<~OUTPUT
        #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
         <sections>
             <clause id='_' anchor="_conformance" obligation='normative' type="conformance">
               <title>Conformance</title>
             </clause>
           </sections>
         </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes security consideration section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Security Considerations

      This is a security consideration

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
       <preface>
           <clause id='_' anchor="_security_considerations" obligation='informative' type="security">
             <title>Security Considerations</title>
             <p id="_">This is a security consideration</p>
           </clause>
         </preface>
         <sections/>
       </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)

    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Clause

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
        <preface>
        <clause type="security" id="_" obligation="informative">
          <title>Security considerations</title>
          <p id="_">No security considerations have been made for this document.</p>
        </clause>
      </preface>
         <sections><clause id="_" anchor="_clause" obligation="normative">
            <title>Clause</title>
         </sections>
       </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "ignores security consideration sections in engineering reports" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR.sub(':nodoc:', ":nodoc:\n:doctype: engineering-report")}

      == Security Considerations

      This is a security consideration

    INPUT
    output = <<~OUTPUT
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
      <sections>
          <clause id='_' anchor="_security_considerations" obligation='normative'>
            <title>Security Considerations</title>
            <p id="_">This is a security consideration</p>
          </clause>
        </sections>
      </metanorma>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:metanorma-extension")
      .each(&:remove)
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)

    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR.sub(':nodoc:', ":nodoc:\n:doctype: engineering-report")}

      == Clause

    INPUT
    output = <<~OUTPUT
      <metanorma xmlns="https://www.metanorma.org/ns/standoc" type="semantic" version="#{Metanorma::Ogc::VERSION}" flavor="ogc">
               <sections>
           <clause id="_" anchor="_clause" obligation="normative">
             <title>Clause</title>
           </clause>
         </sections>
      </metanorma>
    OUTPUT
    xml = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
    xml.xpath("//xmlns:bibdata | //xmlns:boilerplate | //xmlns:metanorma-extension")
      .each(&:remove)
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes executive summary section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Executive Summary

      This is an executive summary

      [abstract]
      == Abstract

      This is an abstract

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen.sub(%r{</script>}, '</script><abstract><p>This is an abstract</p></abstract>')}
      <preface>
      <abstract id='_' anchor="_abstract">
        <title>Abstract</title>
        <p id='_'>This is an abstract</p>
      </abstract>
           <executivesummary id="_" anchor="_executive_summary" obligation='informative'>
             <title>Executive summary</title>
             <p id='_'>This is an executive summary</p>
           </executivesummary>
           <clause type='security' id='_' obligation='informative'>
             <title>Security considerations</title>
             <p id='_'>No security considerations have been made for this document.</p>
           </clause>
         </preface>
         <sections>
         </sections>
       </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "does not recognise 'Foreword' or 'Introduction' as a preface section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Foreword

      This is a prefatory paragraph

      == Introduction

      And so is this

    INPUT
    output = <<~OUTPUT
            #{blank_hdr_gen}
            <preface>#{SECURITY}</preface>
                 <sections>
            <clause id='_' anchor="_foreword" obligation='normative'>
              <title>Foreword</title>
              <p id='_'>This is a prefatory paragraph</p>
            </clause>
            <clause id='_' anchor="_introduction" obligation='normative'>
        <title>Introduction</title>
        <p id='_'>And so is this</p>
      </clause>
          </sections>
        </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes glossary annex" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix]
      == Glossary

      === Term

      [appendix]
      == Appendix

      term:[Term]
    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
      <sections> </sections>
      <annex id='_' anchor="_appendix" obligation='informative'>
        <title>Appendix</title>
        <p id='_'>
          <concept>
            <refterm>Term</refterm>
            <renderterm>Term</renderterm>
            <xref target='term-Term'/>
          </concept>
        </p>
      </annex>
            <annex id='_' anchor="_glossary" obligation='informative'>
        <title>Glossary</title>
        <terms id='_' obligation='normative'>
          <term id="_" anchor="term-Term">
            <preferred><expression><name>Term</name></expression></preferred>
          </term>
        </terms>
      </annex>
      </metanorma>
    OUTPUT
    mock_preserve_idrefs
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)

    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix,heading=glossary]
      == Glossarium

      === Glossaire

    INPUT
    output = <<~OUTPUT
            #{blank_hdr_gen}
          <preface>#{SECURITY}</preface>
          <sections> </sections>
      <annex id='_' anchor="_glossarium" obligation='informative'>
        <title>Glossarium</title>
        <terms id='_' obligation='normative'>
          <term id="_" anchor="term-Glossaire">
            <preferred><expression><name>Glossaire</name></expression></preferred>
          </term>
        </terms>
      </annex>
      </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "processes glossary annex with terms section" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      == Terms, definitions, symbols and abbreviated terms

      === Terms and definitions

      ==== Term

      === Abbreviated terms

      ==== Term2

      [appendix]
      [heading='terms and definitions']
      == Glossary

      === Term Collection

      ==== Term

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
      <sections>
      <clause id='_' anchor="_terms_definitions_symbols_and_abbreviated_terms" obligation='normative' type="terms">
      <title>Terms, definitions, symbols and abbreviated terms</title>
      <p id='_'>This document uses the terms defined in
        <link target='https://portal.ogc.org/public_ogc/directives/directives.php'>OGC Policy Directive 49</link>,
        which is based on the ISO/IEC Directives, Part 2, Rules for the
        structure and drafting of International Standards. In particular, the
        word &#8220;shall&#8221; (not &#8220;must&#8221;) is the verb form used
        to indicate a requirement to be strictly followed to conform to this
        document and OGC documents do not use the equivalent phrases in the
        ISO/IEC Directives, Part 2.</p>
      <p id='_'>This document also uses terms defined in the OGC Standard for Modular
        specifications (<link target='https://portal.opengeospatial.org/files/?artifact_id=34762'>OGC 08-131r3</link>),
        also known as the &#8216;ModSpec&#8217;. The definitions of terms
        such as standard, specification, requirement, and conformance test are
        provided in the ModSpec.</p>
      <p id='_'>For the purposes of this document, the following additional terms and
        definitions apply.</p>
      <terms id='_' anchor="_terms_and_definitions" obligation='normative'>
        <title>Terms and definitions</title>
        <term id="_" anchor="term-Term">
          <preferred><expression><name>Term</name></expression></preferred>
        </term>
      </terms>
      <definitions id='_' anchor="_abbreviated_terms" type='abbreviated_terms' obligation='normative'>
        <title>Abbreviated terms</title>
        <definitions id='_' anchor="_term2" obligation='normative'>
          <title>Symbols and abbreviated terms</title>
        </definitions>
      </definitions>
      </clause>
               </sections>
               <annex id='_' anchor="_glossary" obligation='informative'>
                 <title>Glossary</title>
                   <terms id='_' anchor="_term_collection" obligation='normative'>
                     <title>Term Collection</title>
                     <term id="_" anchor="term-Term-1">
                       <preferred><expression><name>Term</name></expression></preferred>
                     </term>
                   </terms>
               </annex>
             </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "differentiates Normative References and References" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [bibliography]
      == Normative References

      [bibliography]
      == References

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
        <preface>#{SECURITY}</preface>
         <sections> </sections>
        <bibliography>
          <references id='_' anchor="_normative_references" normative='true' obligation='informative'>
            <title>Normative references</title>
            <p id='_'>There are no normative references in this document.</p>
                  </references>
          <references id='_' anchor="_references" normative='false' obligation='informative'>
            <title>References</title>
          </references>
        </bibliography>
      </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "sorts annexes" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix]
      == A

      [appendix]
      == Revision History

      [appendix]
      == B

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
      <sections> </sections>
        <annex id='_' anchor="_a" obligation='informative'>
          <title>A</title>
        </annex>
        <annex id='_' anchor="_b" obligation='informative'>
          <title>B</title>
        </annex>
        <annex id='_' anchor="_revision_history"  obligation='informative'>
          <title>Revision History</title>
        </annex>
      </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end

  it "sorts annexes #2" do
    input = <<~INPUT
      #{ASCIIDOC_BLANK_HDR}

      [appendix]
      == A

      [appendix]
      == Revision History

      [appendix]
      == Glossary

      === Term

      [appendix]
      == B

    INPUT
    output = <<~OUTPUT
      #{blank_hdr_gen}
      <preface>#{SECURITY}</preface>
      <sections> </sections>
        <annex id='_' anchor="_a" obligation='informative'>
          <title>A</title>
        </annex>
        <annex id='_' anchor="_b" obligation='informative'>
          <title>B</title>
        </annex>
        <annex id='_' anchor="_glossary" obligation='informative'>
          <title>Glossary</title>
          <terms id='_' obligation='normative'>
            <term id="_" anchor="term-Term">
              <preferred>
                <expression>
                  <name>Term</name>
                </expression>
              </preferred>
            </term>
          </terms>
        </annex>
        <annex id='_' anchor="_revision_history" obligation='informative'>
          <title>Revision History</title>
        </annex>
      </metanorma>
    OUTPUT
    expect(Xml::C14n.format(strip_guid(Asciidoctor.convert(input, *OPTIONS))))
      .to be_equivalent_to Xml::C14n.format(output)
  end
end
