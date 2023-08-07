require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "processes terms and definitions" do
    FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~INPUT, false)
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
          <preface/>
          <sections>
          <terms id="_terms_and_definitions" obligation="normative" displayorder="1">
        <title>1.<tab/>Terms and definitions</title><p id="_bf202ad0-7300-4cca-80ae-87ef7008f0fd">For the purposes of this document,
          the following terms and definitions apply.</p>
      <term id="_bounding_volume">
      <name>1.1.</name>
      <preferred>Bounding Volume</preferred>
      <definition><p id="_5e741d88-63d0-45f2-966b-b6f9fb0a5cdb">A closed volume completely containing the union of a set of geometric objects.</p></definition>
      </term>
      </terms>
      </sections>
      </ogc-standard>
    INPUT
    expect(xmlpp(File.read("test.doc")
      .gsub(%r{^.*<div class="WordSection3">}m,
            "<body><div class='WordSection3'>")
      .gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(<<~OUTPUT)
        <body>
          <div class='WordSection3'>
            <div>
              <a name='_terms_and_definitions' id='_terms_and_definitions'/>
              <h1>
                1.
                <span style='mso-tab-count:1'>&#xA0; </span>
                Terms and definitions
              </h1>
              <p class='MsoNormal'>
                <a name='_bf202ad0-7300-4cca-80ae-87ef7008f0fd' id='_bf202ad0-7300-4cca-80ae-87ef7008f0fd'/>
                For the purposes of this document, the following terms and definitions
                apply.
              </p>
              <p class='TermNum' style='text-align:left;'>
                <a name='_bounding_volume' id='_bounding_volume'/>
                1.1.&#xA0;Bounding Volume
              </p>
              <p class='MsoNormal'>
                <a name='_5e741d88-63d0-45f2-966b-b6f9fb0a5cdb' id='_5e741d88-63d0-45f2-966b-b6f9fb0a5cdb'/>
                A closed volume completely containing the union of a set of geometric
                objects.
              </p>
            </div>
          </div>
          <div style='mso-element:footnote-list'/>
        </body>
      OUTPUT
  end

  it "populates Word ToC" do
    FileUtils.rm_f "test.doc"
    input = <<~INPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml">
                <metanorma-extension>
                  <toc type="figure"><title>List of Figures</title></toc>
                  <toc type="table"><title>List of Tables</title></toc>
                  <toc type="recommendation"><title>List of Recommendations</title></toc>
                </metanorma-extension>
              <sections>
                     <clause id="A" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">
               <title>Introduction<bookmark id="Q"/> to this<fn reference="1">
        <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p>
      </fn></title>
             </clause>
             <clause id="O" inline-header="false" obligation="normative">
               <title>Clause 4.2</title>
               <recommendation id="AC" type="abstracttest" model="ogc">
        <identifier>/ogc/recommendation/wfs/3</identifier>
        </recommendation>
               <recommendation id="AA" model="ogc">
        <identifier>/ogc/recommendation/wfs/2</identifier>
        </recommendation>
               <recommendation id="AB" type="abstracttest" model="ogc">
        <label>/ogc/recommendation/wfs/3</label>
        </recommendation>
        <figure id="BA"><name>First figure</name></figure>
        <table id="CA"><name>First table</name></table>
               <p>A<fn reference="1">
        <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p>
      </fn></p>
      <clause id="P" inline-header="false" obligation="normative">
      <title>Clause 4.2.1</title>
      </clause>
             </clause></clause>
              </sections>
              </iso-standard>
    INPUT
    presxml = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
      .convert("test", input, true)
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
    word = File.read("test.doc")
      .sub(/^.*<div class="WordSection2">/m, '<div class="WordSection2">')
      .sub(%r{^.*<p class="zzContents" style="margin-top:0cm">}m,
           "<div><p class='zzContents' style='margin-top:0cm'>")
      .gsub(%r{<o:p>&#xA0;</o:p>}, "")
      .sub(%r{<p class="MsoNormal">\s*<br clear="all" class="section"/>\s*</p>\s*<div class="WordSection3">.*$}m, "")
      .sub(%r{</span>\s*<p class="MsoNormal">&#xA0;</p>\s*</div>\s*$}, "</div>")
    expect(xmlpp(strip_guid(word.gsub(/_Toc\d\d+/, "_Toc"))))
      .to be_equivalent_to xmlpp(<<~'OUTPUT')
            <div class="WordSection2">
          <div class="license">
            <div>
              <a name="boilerplate-license-destination" id="boilerplate-license-destination"/>
            </div>
          </div>
          <span lang="EN-US" style="font-size:12.0pt;font-family:&quot;Times New Roman&quot;,serif; mso-fareast-font-family:&quot;Times New Roman&quot;;mso-ansi-language:EN-US;mso-fareast-language: EN-US;mso-bidi-language:AR-SA" xml:lang="EN-US">
            <br clear="all" style="mso-special-character:line-break;page-break-before:always">
        </br>
          </span>
          <p class="MsoNormal">
            <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
          </p>
          <div class="TOC">
          <a name="_" id="_"/>
            <p class="zzContents">Contents</p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-begin"/>
                <span style="mso-spacerun:yes"> </span>
                TOC \o "1-2" \h \z \u
                <span style="mso-element:field-separator"/>
              </span>
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    1. Clause 4
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc2">
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    1.1. Introduction to this
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc2">
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    1.2. Clause 4.2
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-end"/>
              </span>
              <span lang="EN-GB" xml:lang="EN-GB"/>
            </p>
            <p class="TOCTitle">List of Tables</p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-begin"/>
                <span style="mso-spacerun:yes"> </span>
                TOC \h \z \t TableTitle,tabletitle
                <span style="mso-element:field-separator"/>
              </span>
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    Table 1 — First table
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-end"/>
              </span>
              <span lang="EN-GB" xml:lang="EN-GB"/>
            </p>
            <p class="TOCTitle">List of Figures</p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-begin"/>
                <span style="mso-spacerun:yes"> </span>
                TOC \h \z \t FigureTitle,figuretitle
                <span style="mso-element:field-separator"/>
              </span>
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    Figure 1 — First figure
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-end"/>
              </span>
              <span lang="EN-GB" xml:lang="EN-GB"/>
            </p>
            <p class="TOCTitle">List of Recommendations</p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-begin"/>
                <span style="mso-spacerun:yes"> </span>
                TOC \h \z \t RecommendationTitle,RecommendationTestTitle,recommendationtitle,recommendationtesttitle
                <span style="mso-element:field-separator"/>
              </span>
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    Recommendation 1
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc1">
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    Abstract test 1
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc1">
              <span class="MsoHyperlink">
                <span lang="EN-GB" style="mso-no-proof:yes" xml:lang="EN-GB">
                  <a href="#_Toc">
                    Abstract test 2
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-tab-count:1 dotted">. </span>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-begin"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"> PAGEREF _Toc \h </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-separator"/>
                    </span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">1</span>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB"/>
                    <span lang="EN-GB" class="MsoTocTextSpan" xml:lang="EN-GB">
                      <span style="mso-element:field-end"/>
                    </span>
                  </a>
                </span>
              </span>
            </p>
            <p class="MsoToc1">
              <span lang="EN-GB" xml:lang="EN-GB">
                <span style="mso-element:field-end"/>
              </span>
              <span lang="EN-GB" xml:lang="EN-GB"/>
            </p>
          </div>
          <p class="MsoNormal"> </p>
        </div>
      OUTPUT
  end

  it "processes boilerplate" do
    FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert
      .new({ wordcoverpage: "lib/isodoc/ogc/html/word_ogc_titlepage.html" })
      .convert("test", <<~INPUT, false)
            <ogc-standard xmlns="https://standards.opengeospatial.org/document">
            <preface/>
            <boilerplate>
            <copyright-statement>
            <clause>
            <title>Copyright notice</title>
            <p>A</p>
            </clause>
            <clause>
            <title>Note</title>
            <p>B</p>
            </clause>
            </copyright-statement>
            <license-statement>
            <clause>
            <title>License Agreement</title>
            <p>C</p>
            </clause>
            </license-statement>
            </boilerplate>
            <sections>
            <terms id="_terms_and_definitions" obligation="normative"><title>Terms and definitions</title><p id="_bf202ad0-7300-4cca-80ae-87ef7008f0fd">For the purposes of this document,
            the following terms and definitions apply.</p>
        <term id="_bounding_volume">
        <preferred>Bounding Volume</preferred>
        <definition><p id="_5e741d88-63d0-45f2-966b-b6f9fb0a5cdb">A closed volume completely containing the union of a set of geometric objects.</p></definition>
        </term>
        </terms>
        </sections>
        </ogc-standard>
      INPUT
    expect(xmlpp(File.read("test.doc")
      .gsub(%r{^.*<div class="boilerplate-copyright">}m,
            "<div class='boilerplate-copyright'>")
      .gsub(%r{<div class="warning">.*}m, "")))
      .to be_equivalent_to xmlpp(<<~OUTPUT)
        <div class='boilerplate-copyright'>
            <div><p class="TitlePageSubhead">Copyright notice</p>
            <p align="center" class="MsoNormal">A</p>
            </div>
            <div><p class="TitlePageSubhead">Note</p>
            <p class="MsoNormal">B</p>
            </div>
            </div>
      OUTPUT
    expect(xmlpp(File.read("test.doc")
      .gsub(%r{^.*<div class="boilerplate-license">}m,
            "<div class='boilerplate-license'>")
      .gsub(%r{<p class="license">.*}m, '<p class="license"/></div></div>')))
      .to be_equivalent_to xmlpp(<<~OUTPUT)
        <div class='boilerplate-license'>
            <div><p class="TitlePageSubhead">License Agreement</p>
            <p class="license"/></div></div>
      OUTPUT
  end

  it "processes modspec permissions" do
    presxml = <<~OUTPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
                <preface><foreword id="A" displayorder="1"><title>Preface</title>
                <table id="A1" class="modspec" type="recommend">
            <thead><tr><th scope="colgroup" colspan="2"><p class="RecommendationTitle">Permission 1</p></th></tr></thead>
            <tbody>
              <tr><td scope='colgroup' colspan='2'><tt>/ogc/recommendation/wfs/2</tt></td></tr>
              <tr><td>Subject</td><td>user</td></tr><tr><td>Dependency</td><td>/ss/584/2015/level/1</td></tr><tr><td>Dependency</td><td>RFC 2616 (HTTP/1.1)</td></tr>
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
      </table>
      </foreword></preface></ogc-standard>
    OUTPUT
    doc = <<~OUTPUT
      <table class="MsoISOTable" style="mso-table-anchor-horizontal:column;mso-table-overlap:never;border-spacing:0;border-width:1px;" width="100%">
         <a name="A1" id="A1"/>
         <thead>
           <tr>
             <th colspan="2" style="font-weight:bold;border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:avoid;">
              <p class="RecommendationTitle" style="page-break-after:avoid">Permission 1</p>
             </th>
           </tr>
         </thead>
         <tbody>
           <tr>
             <td colspan="2" style="border-top:solid windowtext 1.5pt;mso-border-top-alt:solid windowtext 1.5pt;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">
               <tt>/ogc/recommendation/wfs/2</tt>
             </td>
           </tr>
           <tr>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">Subject</td>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">user</td>
           </tr>
           <tr>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">Dependency</td>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">/ss/584/2015/level/1</td>
           </tr>
           <tr>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">Dependency</td>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">RFC 2616 (HTTP/1.1)</td>
           </tr>
           <tr>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">Control-class</td>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">Technical</td>
           </tr>
           <tr>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">Priority</td>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">P0</td>
           </tr>
           <tr>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">Family</td>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.0pt;mso-border-bottom-alt:solid windowtext 1.0pt;page-break-after:avoid;">System and Communications Protection</td>
           </tr>
           <tr>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">Family</td>
             <td style="border-top:none;mso-border-top-alt:none;border-bottom:solid windowtext 1.5pt;mso-border-bottom-alt:solid windowtext 1.5pt;page-break-after:auto;">System and Communications Protocols</td>
           </tr>
         </tbody>
       </table>
    OUTPUT
    IsoDoc::Ogc::WordConvert.new({}).convert("test", presxml, false)
    expect(xmlpp(File.read("test.doc")
      .gsub(%r{^.*<table}m, "<table")
      .gsub(%r{</table>.*$}m, "</table>")))
      .to be_equivalent_to xmlpp(doc)
  end
end
