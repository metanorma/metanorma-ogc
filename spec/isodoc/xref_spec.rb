require "spec_helper"

RSpec.describe IsoDoc::Ogc do
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
           <preface>
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
        <introduction id='intro' displayorder="2">
              <title>II.</title>
              <table id='N1' class='requirement' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Requirement 1</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <clause id='xyz'>
                <title depth='2'>
                  II.A.
                  <tab/>
                  Preparatory
                </title>
                <table id='N2' unnumbered='true' class='requirement' type='recommend'>
                  <thead>
                    <tr>
                      <th scope='colgroup' colspan='2'>
                        <p class='RecommendationTitle'>Requirement</p>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td colspan='2'>r = 1 %</td>
                    </tr>
                  </tbody>
                </table>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope' type='scope' displayorder="3">
              <title depth='1'>
                1.
                <tab/>
                Scope
              </title>
              <table id='N' class='requirement' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Requirement 2</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <p>
                <xref target='N'>Requirement 2</xref>
              </p>
            </clause>
            <terms id='terms' displayorder='4'>
              <title>2.</title>
            </terms>
            <clause id='widgets' displayorder='5'>
              <title depth='1'>
                3.
                <tab/>
                Widgets
              </title>
              <clause id='widgets1'>
                <title>3.1.</title>
                <table id='note1' class='requirement' type='recommend'>
                  <thead>
                    <tr>
                      <th scope='colgroup' colspan='2'>
                        <p class='RecommendationTitle'>Requirement 3</p>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td colspan='2'>r = 1 %</td>
                    </tr>
                  </tbody>
                </table>
                <table id='note2' class='requirement' type='recommend'>
                  <thead>
                    <tr>
                      <th scope='colgroup' colspan='2'>
                        <p class='RecommendationTitle'>Requirement 4</p>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td colspan='2'>r = 1 %</td>
                    </tr>
                  </tbody>
                </table>
                <p>
                  <xref target='note1'>Requirement 3</xref>
                  <xref target='note2'>Requirement 4</xref>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1' displayorder='6'>
            <title>
              <strong>Annex A</strong>
              <br/>
              (informative)
            </title>
            <clause id='annex1a'>
              <title>A.1.</title>
              <table id='AN' class='requirement' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Requirement A.1</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
            <clause id='annex1b'>
              <title>A.2.</title>
              <table id='Anote1' unnumbered='true' class='requirement' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Requirement</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <table id='Anote2' class='requirement' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Requirement A.2</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
          </annex>
        </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
           <preface>
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
             <introduction id='intro' displayorder='2'>
               <title>II.</title>
               <table id='N1' class='requirement' type='recommend'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTitle'>Requirement 1</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td>A</td>
                     <td/>
                   </tr>
                   <tr>
                     <td>B</td>
                     <td/>
                   </tr>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
               <clause id='xyz'>
                 <title depth='2'>
                   II.A.
                   <tab/>
                   Preparatory
                 </title>
                 <table id='N2' unnumbered='true' class='requirement' type='recommend'>
                   <thead>
                     <tr>
                       <th scope='colgroup' colspan='2'>
                         <p class='RecommendationTitle'>Requirement</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td>A</td>
                       <td/>
                     </tr>
                     <tr>
                       <td>B</td>
                       <td/>
                     </tr>
                     <tr>
                       <td colspan='2'>r = 1 %</td>
                     </tr>
                   </tbody>
                 </table>
               </clause>
             </introduction>
           </preface>
           <sections>
             <clause id='scope' type='scope' displayorder='3'>
               <title depth='1'>
                 1.
                 <tab/>
                 Scope
               </title>
               <table id='N' class='requirement' type='recommend'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTitle'>Requirement 2</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td>A</td>
                     <td/>
                   </tr>
                   <tr>
                     <td>B</td>
                     <td/>
                   </tr>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
               <p>
                 <xref target='N'>Requirement 2</xref>
               </p>
             </clause>
             <terms id='terms' displayorder='4'>
               <title>2.</title>
             </terms>
             <clause id='widgets' displayorder='5'>
               <title depth='1'>
                 3.
                 <tab/>
                 Widgets
               </title>
               <clause id='widgets1'>
                 <title>3.1.</title>
                 <table id='note1' class='requirement' type='recommend'>
                   <thead>
                     <tr>
                       <th scope='colgroup' colspan='2'>
                         <p class='RecommendationTitle'>Requirement 3</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td>A</td>
                       <td/>
                     </tr>
                     <tr>
                       <td>B</td>
                       <td/>
                     </tr>
                     <tr>
                       <td colspan='2'>r = 1 %</td>
                     </tr>
                   </tbody>
                 </table>
                 <table id='note2' class='requirement' type='recommend'>
                   <thead>
                     <tr>
                       <th scope='colgroup' colspan='2'>
                         <p class='RecommendationTitle'>Requirement 4</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td>A</td>
                       <td/>
                     </tr>
                     <tr>
                       <td>B</td>
                       <td/>
                     </tr>
                     <tr>
                       <td colspan='2'>r = 1 %</td>
                     </tr>
                   </tbody>
                 </table>
                 <p>
                   <xref target='note1a'>Requirement A</xref>
                   <xref target='note2b'>Requirement B</xref>
                 </p>
               </clause>
             </clause>
           </sections>
           <annex id='annex1' displayorder='6'>
             <title>
               <strong>Annex A</strong>
               <br/>
               (informative)
             </title>
             <clause id='annex1a'>
               <title>A.1.</title>
               <table id='AN' class='requirement' type='recommend'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTitle'>Requirement A.1</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td>A</td>
                     <td/>
                   </tr>
                   <tr>
                     <td>B</td>
                     <td/>
                   </tr>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
             </clause>
             <clause id='annex1b'>
               <title>A.2.</title>
               <table id='Anote1' unnumbered='true' class='requirement' type='recommend'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTitle'>Requirement</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td>A</td>
                     <td/>
                   </tr>
                   <tr>
                     <td>B</td>
                     <td/>
                   </tr>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
               <table id='Anote2' class='requirement' type='recommend'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTitle'>Requirement A.2</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td>A</td>
                     <td/>
                   </tr>
                   <tr>
                     <td>B</td>
                     <td/>
                   </tr>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
             </clause>
           </annex>
         </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
            <preface>
              <foreword displayorder="1">
                <p>
                  <xref target='N1'>Introduction, Requirement Test 1</xref>
                  <xref target='N2'>Clause II.A, Requirement Test (??)</xref>
                  <xref target='N'>Clause 1, Requirement Test 2</xref>
                  <xref target='note1'>Clause 3.1, Requirement Test 3</xref>
                  <xref target='note2'>Clause 3.1, Requirement Test 4</xref>
                  <xref target='AN'>Annex A.1, Requirement Test A.1</xref>
                  <xref target='Anote1'>Annex A.2, Requirement Test (??)</xref>
                  <xref target='Anote2'>Annex A.2, Requirement Test A.2</xref>
                </p>
              </foreword>
          <introduction id='intro' displayorder="2">
               <title>II.</title>
               <table id='N1' type='recommendtest' class='requirement'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test 1</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
               <clause id='xyz'>
                 <title depth='2'>
                   II.A.
                   <tab/>
                   Preparatory
                 </title>
                 <table id='N2' unnumbered='true' type='recommendtest' class='requirement'>
                   <thead>
                     <tr>
                       <th scope='colgroup' colspan='2'>
                         <p class='RecommendationTestTitle'>Requirement Test</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td colspan='2'>r = 1 %</td>
                     </tr>
                   </tbody>
                 </table>
               </clause>
             </introduction>
           </preface>
           <sections>
             <clause id='scope' type='scope' displayorder="3">
               <title depth='1'>
                 1.
                 <tab/>
                 Scope
               </title>
               <table id='N' type='recommendtest' class='requirement'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test 2</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
               <p>
                 <xref target='N'>Requirement Test 2</xref>
               </p>
             </clause>
             <terms id='terms' displayorder='4'>
               <title>2.</title>
             </terms>
             <clause id='widgets' displayorder='5'>
               <title depth='1'>
                 3.
                 <tab/>
                 Widgets
               </title>
               <clause id='widgets1'>
                 <title>3.1.</title>
                 <table id='note1' type='recommendtest' class='requirement'>
                   <thead>
                     <tr>
                       <th scope='colgroup' colspan='2'>
                         <p class='RecommendationTestTitle'>Requirement Test 3</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td colspan='2'>r = 1 %</td>
                     </tr>
                   </tbody>
                 </table>
                 <table id='note2' type='recommendtest' class='requirement'>
                   <thead>
                     <tr>
                       <th scope='colgroup' colspan='2'>
                         <p class='RecommendationTestTitle'>Requirement Test 4</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td colspan='2'>r = 1 %</td>
                     </tr>
                   </tbody>
                 </table>
                 <p>
                   <xref target='note1'>Requirement Test 3</xref>
                   <xref target='note2'>Requirement Test 4</xref>
                 </p>
               </clause>
             </clause>
           </sections>
           <annex id='annex1' displayorder='6'>
             <title>
               <strong>Annex A</strong>
               <br/>
               (informative)
             </title>
             <clause id='annex1a'>
               <title>A.1.</title>
               <table id='AN' type='recommendtest' class='requirement'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test A.1</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
             </clause>
             <clause id='annex1b'>
               <title>A.2.</title>
               <table id='Anote1' unnumbered='true' type='recommendtest' class='requirement'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
               <table id='Anote2' type='recommendtest' class='requirement'>
                 <thead>
                   <tr>
                     <th scope='colgroup' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test A.2</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <tr>
                     <td colspan='2'>r = 1 %</td>
                   </tr>
                 </tbody>
               </table>
             </clause>
           </annex>
         </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
       <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
         <preface>
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
       <introduction id='intro' displayorder="2">
            <title>II.</title>
            <table id='N1' class='recommendation' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Recommendation 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <clause id='xyz'>
              <title depth='2'>
                II.A.
                <tab/>
                Preparatory
              </title>
              <table id='N2' unnumbered='true' class='recommendation' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Recommendation</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='scope' type='scope' displayorder="3">
            <title depth='1'>
              1.
              <tab/>
              Scope
            </title>
            <table id='N' class='recommendation' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Recommendation 2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <p>
              <xref target='N'>Recommendation 2</xref>
            </p>
          </clause>
          <terms id='terms' displayorder='4'>
            <title>2.</title>
          </terms>
          <clause id='widgets' displayorder='5'>
            <title depth='1'>
              3.
              <tab/>
              Widgets
            </title>
            <clause id='widgets1'>
              <title>3.1.</title>
              <table id='note1' class='recommendation' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Recommendation 3</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <table id='note2' class='recommendation' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Recommendation 4</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <p>
                <xref target='note1'>Recommendation 3</xref>
                <xref target='note2'>Recommendation 4</xref>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id='annex1' displayorder='6'>
          <title>
            <strong>Annex A</strong>
            <br/>
            (informative)
          </title>
          <clause id='annex1a'>
            <title>A.1.</title>
            <table id='AN' class='recommendation' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Recommendation A.1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
          <clause id='annex1b'>
            <title>A.2.</title>
            <table id='Anote1' unnumbered='true' class='recommendation' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Recommendation</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <table id='Anote2' class='recommendation' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Recommendation A.2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
        </annex>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
       <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
         <preface>
           <foreword displayorder="1">
             <p>
               <xref target='N1'>Introduction, Recommendation Test 1</xref>
               <xref target='N2'>Clause II.A, Recommendation Test (??)</xref>
               <xref target='N'>Clause 1, Recommendation Test 2</xref>
               <xref target='note1'>Clause 3.1, Recommendation Test 3</xref>
               <xref target='note2'>Clause 3.1, Recommendation Test 4</xref>
               <xref target='AN'>Annex A.1, Recommendation Test A.1</xref>
               <xref target='Anote1'>Annex A.2, Recommendation Test (??)</xref>
               <xref target='Anote2'>Annex A.2, Recommendation Test A.2</xref>
             </p>
           </foreword>
       <introduction id='intro' displayorder="2">
            <title>II.</title>
            <table id='N1' type='recommendtest' class='recommendation'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Recommendation Test 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <clause id='xyz'>
              <title depth='2'>
                II.A.
                <tab/>
                Preparatory
              </title>
              <table id='N2' unnumbered='true' type='recommendtest' class='recommendation'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Recommendation Test</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='scope' type='scope' displayorder="3">
            <title depth='1'>
              1.
              <tab/>
              Scope
            </title>
            <table id='N' type='recommendtest' class='recommendation'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Recommendation Test 2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <p>
              <xref target='N'>Recommendation Test 2</xref>
            </p>
          </clause>
          <terms id='terms' displayorder='4'>
            <title>2.</title>
          </terms>
          <clause id='widgets' displayorder='5'>
            <title depth='1'>
              3.
              <tab/>
              Widgets
            </title>
            <clause id='widgets1'>
              <title>3.1.</title>
              <table id='note1' type='recommendtest' class='recommendation'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Recommendation Test 3</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <table id='note2' type='recommendtest' class='recommendation'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Recommendation Test 4</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <p>
                <xref target='note1'>Recommendation Test 3</xref>
                <xref target='note2'>Recommendation Test 4</xref>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id='annex1' displayorder='6'>
          <title>
            <strong>Annex A</strong>
            <br/>
            (informative)
          </title>
          <clause id='annex1a'>
            <title>A.1.</title>
            <table id='AN' type='recommendtest' class='recommendation'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Recommendation Test A.1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
          <clause id='annex1b'>
            <title>A.2.</title>
            <table id='Anote1' unnumbered='true' type='recommendtest' class='recommendation'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Recommendation Test</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <table id='Anote2' type='recommendtest' class='recommendation'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Recommendation Test A.2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
        </annex>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
       <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
         <preface>
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
       <introduction id='intro' displayorder="2">
            <title>II.</title>
            <table id='N1' class='permission' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Permission 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <clause id='xyz'>
              <title depth='2'>
                II.A.
                <tab/>
                Preparatory
              </title>
              <table id='N2' unnumbered='true' class='permission' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Permission</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='scope' type='scope' displayorder="3">
            <title depth='1'>
              1.
              <tab/>
              Scope
            </title>
            <table id='N' class='permission' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Permission 2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <p>
              <xref target='N'>Permission 2</xref>
            </p>
          </clause>
          <terms id='terms' displayorder='4'>
            <title>2.</title>
          </terms>
          <clause id='widgets' displayorder='5'>
            <title depth='1'>
              3.
              <tab/>
              Widgets
            </title>
            <clause id='widgets1'>
              <title>3.1.</title>
              <table id='note1' class='permission' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Permission 3</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <table id='note2' class='permission' type='recommend'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Permission 4</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <p>
                <xref target='note1'>Permission 3</xref>
                <xref target='note2'>Permission 4</xref>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id='annex1' displayorder='6'>
          <title>
            <strong>Annex A</strong>
            <br/>
            (informative)
          </title>
          <clause id='annex1a'>
            <title>A.1.</title>
            <table id='AN' class='permission' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Permission A.1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
          <clause id='annex1b'>
            <title>A.2.</title>
            <table id='Anote1' unnumbered='true' class='permission' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Permission</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <table id='Anote2' class='permission' type='recommend'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Permission A.2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
        </annex>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
       <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
         <preface>
           <foreword displayorder="1">
             <p>
               <xref target='N1'>Introduction, Permission Test 1</xref>
               <xref target='N2'>Clause II.A, Permission Test (??)</xref>
               <xref target='N'>Clause 1, Permission Test 2</xref>
               <xref target='note1'>Clause 3.1, Permission Test 3</xref>
               <xref target='note2'>Clause 3.1, Permission Test 4</xref>
               <xref target='AN'>Annex A.1, Permission Test A.1</xref>
               <xref target='Anote1'>Annex A.2, Permission Test (??)</xref>
               <xref target='Anote2'>Annex A.2, Permission Test A.2</xref>
             </p>
           </foreword>
        <introduction id='intro' displayorder="2">
            <title>II.</title>
            <table id='N1' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Permission Test 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <clause id='xyz'>
              <title depth='2'>
                II.A.
                <tab/>
                Preparatory
              </title>
              <table id='N2' unnumbered='true' type='recommendtest' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Permission Test</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='scope' type='scope' displayorder="3">
            <title depth='1'>
              1.
              <tab/>
              Scope
            </title>
            <table id='N' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Permission Test 2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <p>
              <xref target='N'>Permission Test 2</xref>
            </p>
          </clause>
          <terms id='terms' displayorder='4'>
            <title>2.</title>
          </terms>
          <clause id='widgets' displayorder='5'>
            <title depth='1'>
              3.
              <tab/>
              Widgets
            </title>
            <clause id='widgets1'>
              <title>3.1.</title>
              <table id='note1' type='recommendtest' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Permission Test 3</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <table id='note2' type='recommendtest' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Permission Test 4</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <p>
                <xref target='note1'>Permission Test 3</xref>
                <xref target='note2'>Permission Test 4</xref>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id='annex1' displayorder='6'>
          <title>
            <strong>Annex A</strong>
            <br/>
            (informative)
          </title>
          <clause id='annex1a'>
            <title>A.1.</title>
            <table id='AN' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Permission Test A.1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
          <clause id='annex1b'>
            <title>A.2.</title>
            <table id='Anote1' unnumbered='true' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Permission Test</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <table id='Anote2' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Permission Test A.2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
        </annex>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
                <preface>
                  <foreword displayorder="1">
                    <p>
                      <xref target='N1'>Clause 1, Permission 1</xref>
                      <xref target='N2'>Clause 1, Permission Test 1-1</xref>
                      <xref target='N'>Clause 1, Permission 1-1-1</xref>
                      <xref target='Q1'>Clause 1, Requirement 1-1</xref>
                      <xref target='R1'>Clause 1, Recommendation 1-1</xref>
                      <xref target='AN1'>Annex A, Permission Test A.1</xref>
                      <xref target='AN2'>Annex A, Permission A.1-1</xref>
                      <xref target='AN'>Annex A, Permission Test A.1-1-1</xref>
                      <xref target='AQ1'>Annex A, Requirement A.1-1</xref>
                      <xref target='AR1'>Annex A, Recommendation A.1-1</xref>
                    </p>
                  </foreword>
                </preface>
                <sections>
                 <clause id='xyz' displayorder="2">
                   <title depth='1'>
                     1.
                     <tab/>
                     Preparatory
                   </title>
                   <table id='N1' class='permission' type='recommend'>
                     <thead>
                       <tr>
                         <th scope='colgroup' colspan='2'>
                           <p class='RecommendationTitle'>Permission 1</p>
                         </th>
                       </tr>
                     </thead>
                     <tbody>
                       <tr>
                         <td colspan='2'>
                           <table id='N2' type='recommendtest' class='permission'>
                             <thead>
                               <tr>
                                 <th scope='colgroup' colspan='2'>
                                   <p class='RecommendationTestTitle'>Permission Test 1-1</p>
                                 </th>
                               </tr>
                             </thead>
                             <tbody>
                               <tr>
                                 <td colspan='2'>
                                   <table id='N' class='permission' type='recommend'>
                                     <thead>
                                       <tr>
                                         <th scope='colgroup' colspan='2'>
                                           <p class='RecommendationTitle'>Permission 1-1-1</p>
                                         </th>
                                       </tr>
                                     </thead>
                                     <tbody/>
                                   </table>
                                 </td>
                               </tr>
                             </tbody>
                           </table>
                         </td>
                       </tr>
                       <tr>
                         <td colspan='2'>
                           <table id='Q1' class='requirement' type='recommend'>
                             <thead>
                               <tr>
                                 <th scope='colgroup' colspan='2'>
                                   <p class='RecommendationTitle'>Requirement 1-1</p>
                                 </th>
                               </tr>
                             </thead>
                             <tbody/>
                           </table>
                         </td>
                       </tr>
                       <tr>
                         <td colspan='2'>
                           <table id='R1' class='recommendation' type='recommend'>
                             <thead>
                               <tr>
                                 <th scope='colgroup' colspan='2'>
                                   <p class='RecommendationTitle'>Recommendation 1-1</p>
                                 </th>
                               </tr>
                             </thead>
                             <tbody/>
                           </table>
                         </td>
                       </tr>
                       <tr>
                         <td colspan='2'>
                           <table id='N3' type='recommendtest' class='permission'>
                             <thead>
                               <tr>
                                 <th scope='colgroup' colspan='2'>
                                   <p class='RecommendationTestTitle'>Permission Test 1-2</p>
                                 </th>
                               </tr>
                             </thead>
                             <tbody/>
                           </table>
                         </td>
                       </tr>
                       <tr>
                         <td colspan='2'>
                           <table id='N4' class='permission' type='recommend'>
                             <thead>
                               <tr>
                                 <th scope='colgroup' colspan='2'>
                                   <p class='RecommendationTitle'>Permission 1-1</p>
                                 </th>
                               </tr>
                             </thead>
                             <tbody/>
                           </table>
                         </td>
                       </tr>
                     </tbody>
                   </table>
                 </clause>
               </sections>
               <annex id='Axyz' displayorder='3'>
                 <title>
                   <strong>Annex A</strong>
                   <br/>
                   (informative)
                   <br/>
                   <strong>Preparatory</strong>
                 </title>
                 <table id='AN1' type='recommendtest' class='permission'>
                   <thead>
                     <tr>
                       <th scope='colgroup' colspan='2'>
                         <p class='RecommendationTestTitle'>Permission Test A.1</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td colspan='2'>
                         <table id='AN2' class='permission' type='recommend'>
                           <thead>
                             <tr>
                               <th scope='colgroup' colspan='2'>
                                 <p class='RecommendationTitle'>Permission A.1-1</p>
                               </th>
                             </tr>
                           </thead>
                           <tbody>
                             <tr>
                               <td colspan='2'>
                                 <table id='AN' type='recommendtest' class='permission'>
                                   <thead>
                                     <tr>
                                       <th scope='colgroup' colspan='2'>
                                         <p class='RecommendationTestTitle'>Permission Test A.1-1-1</p>
                                       </th>
                                     </tr>
                                   </thead>
                                   <tbody/>
                                 </table>
                               </td>
                             </tr>
                           </tbody>
                         </table>
                       </td>
                     </tr>
                     <tr>
                       <td colspan='2'>
                         <table id='AQ1' class='requirement' type='recommend'>
                           <thead>
                             <tr>
                               <th scope='colgroup' colspan='2'>
                                 <p class='RecommendationTitle'>Requirement A.1-1</p>
                               </th>
                             </tr>
                           </thead>
                           <tbody/>
                         </table>
                       </td>
                     </tr>
                     <tr>
                       <td colspan='2'>
                         <table id='AR1' class='recommendation' type='recommend'>
                           <thead>
                             <tr>
                               <th scope='colgroup' colspan='2'>
                                 <p class='RecommendationTitle'>Recommendation A.1-1</p>
                               </th>
                             </tr>
                           </thead>
                           <tbody/>
                         </table>
                       </td>
                     </tr>
                     <tr>
                       <td colspan='2'>
                         <table id='AN3' type='recommendtest' class='permission'>
                           <thead>
                             <tr>
                               <th scope='colgroup' colspan='2'>
                                 <p class='RecommendationTestTitle'>Permission Test A.1-1</p>
                               </th>
                             </tr>
                           </thead>
                           <tbody/>
                         </table>
                       </td>
                     </tr>
                     <tr>
                       <td colspan='2'>
                         <table id='AN4' class='permission' type='recommend'>
                           <thead>
                             <tr>
                               <th scope='colgroup' colspan='2'>
                                 <p class='RecommendationTitle'>Permission A.1-2</p>
                               </th>
                             </tr>
                           </thead>
                           <tbody/>
                         </table>
                       </td>
                     </tr>
                   </tbody>
                 </table>
               </annex>
             </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
       <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
         <preface>
           <foreword displayorder="1">
             <p>
               <xref target='N1'>Introduction, Abstract Test 1</xref>
               <xref target='N2'>Clause II.A, Abstract Test (??)</xref>
               <xref target='N'>Clause 1, Abstract Test 2</xref>
               <xref target='note1'>Clause 3.1, Abstract Test 3</xref>
               <xref target='note2'>Clause 3.1, Abstract Test 4</xref>
               <xref target='AN'>Annex A.1, Abstract Test A.1</xref>
               <xref target='Anote1'>Annex A.2, Abstract Test (??)</xref>
               <xref target='Anote2'>Annex A.2, Abstract Test A.2</xref>
             </p>
           </foreword>
       <introduction id='intro' displayorder="2">
            <title>II.</title>
            <table id='N1' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Abstract Test 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <clause id='xyz'>
              <title depth='2'>
                II.A.
                <tab/>
                Preparatory
              </title>
              <table id='N2' unnumbered='true' type='recommendtest' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Abstract Test</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='scope' type='scope' displayorder="3">
            <title depth='1'>
              1.
              <tab/>
              Scope
            </title>
            <table id='N' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Abstract Test 2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <p>
              <xref target='N'>Abstract Test 2</xref>
            </p>
          </clause>
          <terms id='terms' displayorder='4'>
            <title>2.</title>
          </terms>
          <clause id='widgets' displayorder='5'>
            <title depth='1'>
              3.
              <tab/>
              Widgets
            </title>
            <clause id='widgets1'>
              <title>3.1.</title>
              <table id='note1' type='recommendtest' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Abstract Test 3</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <table id='note2' type='recommendtest' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTestTitle'>Abstract Test 4</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <p>
                <xref target='note1'>Abstract Test 3</xref>
                <xref target='note2'>Abstract Test 4</xref>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id='annex1' displayorder='6'>
          <title>
            <strong>Annex A</strong>
            <br/>
            (informative)
          </title>
          <clause id='annex1a'>
            <title>A.1.</title>
            <table id='AN' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Abstract Test A.1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
          <clause id='annex1b'>
            <title>A.2.</title>
            <table id='Anote1' unnumbered='true' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Abstract Test</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <table id='Anote2' type='recommendtest' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTestTitle'>Abstract Test A.2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
        </annex>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
       <iso-standard xmlns='http://riboseinc.com/isoxml' type="presentation">
         <preface>
           <foreword displayorder="1">
             <p>
               <xref target='N1'>Introduction, Conformance Class 1</xref>
               <xref target='N2'>Clause II.A, Conformance Class (??)</xref>
               <xref target='N'>Clause 1, Conformance Class 2</xref>
               <xref target='note1'>Clause 3.1, Conformance Class 3</xref>
               <xref target='note2'>Clause 3.1, Conformance Class 4</xref>
               <xref target='AN'>Annex A.1, Conformance Class A.1</xref>
               <xref target='Anote1'>Annex A.2, Conformance Class (??)</xref>
               <xref target='Anote2'>Annex A.2, Conformance Class A.2</xref>
             </p>
           </foreword>
        <introduction id='intro' displayorder="2">
            <title>II.</title>
            <table id='N1' type='recommendclass' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Conformance Class 1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <clause id='xyz'>
              <title depth='2'>
                II.A.
                <tab/>
                Preparatory
              </title>
              <table id='N2' unnumbered='true' type='recommendclass' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Conformance Class</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
            </clause>
          </introduction>
        </preface>
        <sections>
          <clause id='scope' type='scope' displayorder="3">
            <title depth='1'>
              1.
              <tab/>
              Scope
            </title>
            <table id='N' type='recommendclass' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Conformance Class 2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <p>
              <xref target='N'>Conformance Class 2</xref>
            </p>
          </clause>
          <terms id='terms' displayorder='4'>
            <title>2.</title>
          </terms>
          <clause id='widgets'  displayorder='5'>
            <title depth='1'>
              3.
              <tab/>
              Widgets
            </title>
            <clause id='widgets1'>
              <title>3.1.</title>
              <table id='note1' type='recommendclass' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Conformance Class 3</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <table id='note2' type='recommendclass' class='permission'>
                <thead>
                  <tr>
                    <th scope='colgroup' colspan='2'>
                      <p class='RecommendationTitle'>Conformance Class 4</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td colspan='2'>r = 1 %</td>
                  </tr>
                </tbody>
              </table>
              <p>
                <xref target='note1'>Conformance Class 3</xref>
                <xref target='note2'>Conformance Class 4</xref>
              </p>
            </clause>
          </clause>
        </sections>
        <annex id='annex1' displayorder='6'>
          <title>
            <strong>Annex A</strong>
            <br/>
            (informative)
          </title>
          <clause id='annex1a'>
            <title>A.1.</title>
            <table id='AN' type='recommendclass' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Conformance Class A.1</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
          <clause id='annex1b'>
            <title>A.2.</title>
            <table id='Anote1' unnumbered='true' type='recommendclass' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Conformance Class</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
            <table id='Anote2' type='recommendclass' class='permission'>
              <thead>
                <tr>
                  <th scope='colgroup' colspan='2'>
                    <p class='RecommendationTitle'>Conformance Class A.2</p>
                  </th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td colspan='2'>r = 1 %</td>
                </tr>
              </tbody>
            </table>
          </clause>
        </annex>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
        <preface>
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
          <introduction id='A' displayorder="2">
             <title depth='1'>II.<tab/>Introduction</title>
            <clause id='B'>
              <title>II.A.</title>
              <clause id='C'>
                <title>II.A.1.</title>
                <clause id='D'>
                  <title>II.A.1.a.</title>
                  <clause id='E'>
                    <title>II.A.1.a.i.</title>
                    <clause id='F'>
                      <title>II.A.1.a.i.(1).</title>
                      <clause id='G'>
                        <title>II.A.1.a.i.(1).(a).</title>
                        <clause id='H'>
                          <title>II.A.1.a.i.(1).(a).(i).</title>
                          <clause id='I'>
                            <title>II.A.1.a.i.(1).(a).(i).1.</title>
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
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
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
      <iso-standard xmlns='http://riboseinc.com/isoxml' type='presentation'>
        <preface>
          <foreword displayorder='1'>
            <p>
              <xref target='A'>Annex A</xref>
              <xref target='B'>Annex A.1</xref>
              <xref target='C'>Annex A.2</xref>
            </p>
          </foreword>
        </preface>
        <annex id='A' displayorder='2'>
          <title>
            <strong>Annex A</strong>
            <br/>
            (informative)
            <br/>
            <strong>Glossary</strong>
          </title>
          <terms>
            <term id='B'>
              <name>A.1.</name>
              <preferred>Term B</preferred>
            </term>
            <term id='C'>
              <name>A.2.</name>
              <preferred>Term C</preferred>
            </term>
          </terms>
        </annex>
        <iso-standard> </iso-standard>
      </iso-standard>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>")))
      .to be_equivalent_to xmlpp(output)
  end
end
