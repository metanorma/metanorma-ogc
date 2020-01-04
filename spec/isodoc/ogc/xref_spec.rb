require "spec_helper"

RSpec.describe IsoDoc::Ogc do
    it "cross-references requirements" do
      expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
#{HTML_HDR}
<br/>
           <div>
             <h1 class='ForewordTitle'>Preface</h1>
             <p>
               <a href='#N1'>Introduction, Requirement 1</a>
               <a href='#N2'>Clause 2.1, Requirement (??)</a>
               <a href='#N'>Clause 1, Requirement 2</a>
               <a href='#note1'>Clause 3.1, Requirement 3</a>
               <a href='#note2'>Clause 3.1, Requirement 4</a>
               <a href='#AN'>Annex A.1, Requirement A.1</a>
               <a href='#Anote1'>Annex A.2, Requirement (??)</a>
               <a href='#Anote2'>Annex A.2, Requirement A.2</a>
             </p>
           </div>
           <br/>
           <div class='Section3' id='intro'>
             <h1 class='IntroTitle'>Introduction</h1>
             <table id='N1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Requirement 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <div id='xyz'>
               <h2>2.1.&#160; Preparatory</h2>
               <table id='N2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Requirement:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
           <p class='zzSTDTitle1'/>
           <div id='scope'>
             <h1>1.&#160; Scope</h1>
             <table id='N' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Requirement 2:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <p>
               <a href='#N'>Requirement 2</a>
             </p>
           </div>
           <div id='terms'>
             <h1>2.&#160; Terms and definitions</h1>
           </div>
           <div id='widgets'>
             <h1>3.&#160; Widgets</h1>
             <div id='widgets1'>
               <h2>3.1.&#160; </h2>
               <table id='note1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Requirement 3:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='note2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Requirement 4:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <p>
                 <a href='#note1'>Requirement 3</a>
                 <a href='#note2'>Requirement 4</a>
               </p>
             </div>
           </div>
           <br/>
           <div id='annex1' class='Section3'>
             <div id='annex1a'>
               <h2>A.1.&#160; </h2>
               <table id='AN' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Requirement A.1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
             <div id='annex1b'>
               <h2>A.2.&#160; </h2>
               <table id='Anote1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Requirement:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='Anote2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Requirement A.2:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
         </div>
       </body>

OUTPUT
    end

        it "cross-references requirement tests" do
          expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
    #{HTML_HDR}
     <br/>
           <div>
             <h1 class='ForewordTitle'>Preface</h1>
             <p>
               <a href='#N1'>Introduction, Requirement Test 1</a>
               <a href='#N2'>Clause 2.1, Requirement Test (??)</a>
               <a href='#N'>Clause 1, Requirement Test 2</a>
               <a href='#note1'>Clause 3.1, Requirement Test 3</a>
               <a href='#note2'>Clause 3.1, Requirement Test 4</a>
               <a href='#AN'>Annex A.1, Requirement Test A.1</a>
               <a href='#Anote1'>Annex A.2, Requirement Test (??)</a>
               <a href='#Anote2'>Annex A.2, Requirement Test A.2</a>
             </p>
           </div>
           <br/>
           <div class='Section3' id='intro'>
             <h1 class='IntroTitle'>Introduction</h1>
             <table id='N1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Requirement Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <div id='xyz'>
               <h2>2.1.&#160; Preparatory</h2>
               <table id='N2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
           <p class='zzSTDTitle1'/>
           <div id='scope'>
             <h1>1.&#160; Scope</h1>
             <table id='N' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Requirement Test 2:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <p>
               <a href='#N'>Requirement Test 2</a>
             </p>
           </div>
           <div id='terms'>
             <h1>2.&#160; Terms and definitions</h1>
           </div>
           <div id='widgets'>
             <h1>3.&#160; Widgets</h1>
             <div id='widgets1'>
               <h2>3.1.&#160; </h2>
               <table id='note1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test 3:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='note2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test 4:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <p>
                 <a href='#note1'>Requirement Test 3</a>
                 <a href='#note2'>Requirement Test 4</a>
               </p>
             </div>
           </div>
           <br/>
           <div id='annex1' class='Section3'>
             <div id='annex1a'>
               <h2>A.1.&#160; </h2>
               <table id='AN' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test A.1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
             <div id='annex1b'>
               <h2>A.2.&#160; </h2>
               <table id='Anote1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='Anote2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Requirement Test A.2:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
         </div>
       </body>
OUTPUT
        end


        it "cross-references recommendations" do
          expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
    #{HTML_HDR}
    <br/>
           <div>
             <h1 class='ForewordTitle'>Preface</h1>
             <p>
               <a href='#N1'>Introduction, Recommendation 1</a>
               <a href='#N2'>Clause 2.1, Recommendation (??)</a>
               <a href='#N'>Clause 1, Recommendation 2</a>
               <a href='#note1'>Clause 3.1, Recommendation 3</a>
               <a href='#note2'>Clause 3.1, Recommendation 4</a>
               <a href='#AN'>Annex A.1, Recommendation A.1</a>
               <a href='#Anote1'>Annex A.2, Recommendation (??)</a>
               <a href='#Anote2'>Annex A.2, Recommendation A.2</a>
             </p>
           </div>
           <br/>
           <div class='Section3' id='intro'>
             <h1 class='IntroTitle'>Introduction</h1>
             <table id='N1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Recommendation 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <div id='xyz'>
               <h2>2.1.&#160; Preparatory</h2>
               <table id='N2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Recommendation:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
           <p class='zzSTDTitle1'/>
           <div id='scope'>
             <h1>1.&#160; Scope</h1>
             <table id='N' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Recommendation 2:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <p>
               <a href='#N'>Recommendation 2</a>
             </p>
           </div>
           <div id='terms'>
             <h1>2.&#160; Terms and definitions</h1>
           </div>
           <div id='widgets'>
             <h1>3.&#160; Widgets</h1>
             <div id='widgets1'>
               <h2>3.1.&#160; </h2>
               <table id='note1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Recommendation 3:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='note2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Recommendation 4:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <p>
                 <a href='#note1'>Recommendation 3</a>
                 <a href='#note2'>Recommendation 4</a>
               </p>
             </div>
           </div>
           <br/>
           <div id='annex1' class='Section3'>
             <div id='annex1a'>
               <h2>A.1.&#160; </h2>
               <table id='AN' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Recommendation A.1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
             <div id='annex1b'>
               <h2>A.2.&#160; </h2>
               <table id='Anote1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Recommendation:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='Anote2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Recommendation A.2:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
         </div>
       </body>
OUTPUT
    end

          it "cross-references recommendation tests" do
            expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
    #{HTML_HDR}
    <br/>
    <div>
             <h1 class='ForewordTitle'>Preface</h1>
             <p>
               <a href='#N1'>Introduction, Recommendation Test 1</a>
               <a href='#N2'>Clause 2.1, Recommendation Test (??)</a>
               <a href='#N'>Clause 1, Recommendation Test 2</a>
               <a href='#note1'>Clause 3.1, Recommendation Test 3</a>
               <a href='#note2'>Clause 3.1, Recommendation Test 4</a>
               <a href='#AN'>Annex A.1, Recommendation Test A.1</a>
               <a href='#Anote1'>Annex A.2, Recommendation Test (??)</a>
               <a href='#Anote2'>Annex A.2, Recommendation Test A.2</a>
             </p>
           </div>
           <br/>
           <div class='Section3' id='intro'>
             <h1 class='IntroTitle'>Introduction</h1>
             <table id='N1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Recommendation Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <div id='xyz'>
               <h2>2.1.&#160; Preparatory</h2>
               <table id='N2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Recommendation Test:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
           <p class='zzSTDTitle1'/>
           <div id='scope'>
             <h1>1.&#160; Scope</h1>
             <table id='N' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Recommendation Test 2:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <p>
               <a href='#N'>Recommendation Test 2</a>
             </p>
           </div>
           <div id='terms'>
             <h1>2.&#160; Terms and definitions</h1>
           </div>
           <div id='widgets'>
             <h1>3.&#160; Widgets</h1>
             <div id='widgets1'>
               <h2>3.1.&#160; </h2>
               <table id='note1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Recommendation Test 3:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='note2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Recommendation Test 4:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <p>
                 <a href='#note1'>Recommendation Test 3</a>
                 <a href='#note2'>Recommendation Test 4</a>
               </p>
             </div>
           </div>
           <br/>
           <div id='annex1' class='Section3'>
             <div id='annex1a'>
               <h2>A.1.&#160; </h2>
               <table id='AN' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Recommendation Test A.1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
             <div id='annex1b'>
               <h2>A.2.&#160; </h2>
               <table id='Anote1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Recommendation Test:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='Anote2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Recommendation Test A.2:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
         </div>
       </body>
OUTPUT
          end

        it "cross-references permissions" do
          expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
    #{HTML_HDR}
    <br/>
           <div>
             <h1 class='ForewordTitle'>Preface</h1>
             <p>
               <a href='#N1'>Introduction, Permission 1</a>
               <a href='#N2'>Clause 2.1, Permission (??)</a>
               <a href='#N'>Clause 1, Permission 2</a>
               <a href='#note1'>Clause 3.1, Permission 3</a>
               <a href='#note2'>Clause 3.1, Permission 4</a>
               <a href='#AN'>Annex A.1, Permission A.1</a>
               <a href='#Anote1'>Annex A.2, Permission (??)</a>
               <a href='#Anote2'>Annex A.2, Permission A.2</a>
             </p>
           </div>
           <br/>
           <div class='Section3' id='intro'>
             <h1 class='IntroTitle'>Introduction</h1>
             <table id='N1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <div id='xyz'>
               <h2>2.1.&#160; Preparatory</h2>
               <table id='N2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Permission:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
           <p class='zzSTDTitle1'/>
           <div id='scope'>
             <h1>1.&#160; Scope</h1>
             <table id='N' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 2:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <p>
               <a href='#N'>Permission 2</a>
             </p>
           </div>
           <div id='terms'>
             <h1>2.&#160; Terms and definitions</h1>
           </div>
           <div id='widgets'>
             <h1>3.&#160; Widgets</h1>
             <div id='widgets1'>
               <h2>3.1.&#160; </h2>
               <table id='note1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Permission 3:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='note2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Permission 4:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <p>
                 <a href='#note1'>Permission 3</a>
                 <a href='#note2'>Permission 4</a>
               </p>
             </div>
           </div>
           <br/>
           <div id='annex1' class='Section3'>
             <div id='annex1a'>
               <h2>A.1.&#160; </h2>
               <table id='AN' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Permission A.1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
             <div id='annex1b'>
               <h2>A.2.&#160; </h2>
               <table id='Anote1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Permission:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='Anote2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTitle'>Permission A.2:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
         </div>
       </body>
OUTPUT
    end

               it "cross-references permission tests" do
                 expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
    #{HTML_HDR}
    <br/>
           <div>
             <h1 class='ForewordTitle'>Preface</h1>
             <p>
               <a href='#N1'>Introduction, Permission Test 1</a>
               <a href='#N2'>Clause 2.1, Permission Test (??)</a>
               <a href='#N'>Clause 1, Permission Test 2</a>
               <a href='#note1'>Clause 3.1, Permission Test 3</a>
               <a href='#note2'>Clause 3.1, Permission Test 4</a>
               <a href='#AN'>Annex A.1, Permission Test A.1</a>
               <a href='#Anote1'>Annex A.2, Permission Test (??)</a>
               <a href='#Anote2'>Annex A.2, Permission Test A.2</a>
             </p>
           </div>
           <br/>
           <div class='Section3' id='intro'>
             <h1 class='IntroTitle'>Introduction</h1>
             <table id='N1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Permission Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <div id='xyz'>
               <h2>2.1.&#160; Preparatory</h2>
               <table id='N2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Permission Test:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
           <p class='zzSTDTitle1'/>
           <div id='scope'>
             <h1>1.&#160; Scope</h1>
             <table id='N' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Permission Test 2:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <span class='stem'>(#(r = 1 %)#)</span>
               </tbody>
             </table>
             <p>
               <a href='#N'>Permission Test 2</a>
             </p>
           </div>
           <div id='terms'>
             <h1>2.&#160; Terms and definitions</h1>
           </div>
           <div id='widgets'>
             <h1>3.&#160; Widgets</h1>
             <div id='widgets1'>
               <h2>3.1.&#160; </h2>
               <table id='note1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Permission Test 3:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='note2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Permission Test 4:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <p>
                 <a href='#note1'>Permission Test 3</a>
                 <a href='#note2'>Permission Test 4</a>
               </p>
             </div>
           </div>
           <br/>
           <div id='annex1' class='Section3'>
             <div id='annex1a'>
               <h2>A.1.&#160; </h2>
               <table id='AN' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Permission Test A.1:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
             <div id='annex1b'>
               <h2>A.2.&#160; </h2>
               <table id='Anote1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Permission Test:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
               <table id='Anote2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                 <thead>
                   <tr>
                     <th style='vertical-align:top;' class='recommend' colspan='2'>
                       <p class='RecommendationTestTitle'>Permission Test A.2:</p>
                     </th>
                   </tr>
                 </thead>
                 <tbody>
                   <span class='stem'>(#(r = 1 %)#)</span>
                 </tbody>
               </table>
             </div>
           </div>
         </div>
       </body>
OUTPUT
end

        it "labels and cross-references nested requirements" do
          expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    #{HTML_HDR}
    <br/>
           <div>
             <h1 class='ForewordTitle'>Preface</h1>
             <p>
               <a href='#N1'>Clause 1, Permission 1</a>
               <a href='#N2'>Clause 1, Permission Test 1-1</a>
               <a href='#N'>Clause 1, Permission 1-1-1</a>
               <a href='#Q1'>Clause 1, Requirement 1-1</a>
               <a href='#R1'>Clause 1, Recommendation 1-1</a>
               <a href='#AN1'>Annex A, Permission Test A.1</a>
               <a href='#AN2'>Annex A, Permission A.1-1</a>
               <a href='#AN'>Annex A, Permission Test A.1-1-1</a>
               <a href='#AQ1'>Annex A, Requirement A.1-1</a>
               <a href='#AR1'>Annex A, Recommendation A.1-1</a>
             </p>
           </div>
           <p class='zzSTDTitle1'/>
           <div id='xyz'>
             <h1>1.&#160; Preparatory</h1>
             <table id='N1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <table id='N2' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTestTitle'>Permission Test 1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <table id='N' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                       <thead>
                         <tr>
                           <th style='vertical-align:top;' class='recommend' colspan='2'>
                             <p class='RecommendationTitle'>Permission 1-1-1:</p>
                           </th>
                         </tr>
                       </thead>
                       <tbody> </tbody>
                     </table>
                   </tbody>
                 </table>
                 <table id='Q1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Requirement 1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody> </tbody>
                 </table>
                 <table id='R1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Recommendation 1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody> </tbody>
                 </table>
                 <table id='N3' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTestTitle'>Permission Test 1-2:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody/>
                 </table>
                 <table id='N4' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Permission 1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody/>
                 </table>
               </tbody>
             </table>
           </div>
           <br/>
           <div id='Axyz' class='Section3'>
             <h1 class='Annex'>
               <b>Annex A</b>
               <br/>
               (informative) 
               <br/>
               <b>Preparatory</b>
             </h1>
             <table id='AN1' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Permission Test A.1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <table id='AN2' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Permission A.1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody>
                     <table id='AN' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                       <thead>
                         <tr>
                           <th style='vertical-align:top;' class='recommend' colspan='2'>
                             <p class='RecommendationTestTitle'>Permission Test A.1-1-1:</p>
                           </th>
                         </tr>
                       </thead>
                       <tbody> </tbody>
                     </table>
                   </tbody>
                 </table>
                 <table id='AQ1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Requirement A.1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody> </tbody>
                 </table>
                 <table id='AR1' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Recommendation A.1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody> </tbody>
                 </table>
                 <table id='AN3' class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTestTitle'>Permission Test A.1-1:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody/>
                 </table>
                 <table id='AN4' class='recommend' style='border-collapse:collapse;border-spacing:0;'>
                   <thead>
                     <tr>
                       <th style='vertical-align:top;' class='recommend' colspan='2'>
                         <p class='RecommendationTitle'>Permission A.1-2:</p>
                       </th>
                     </tr>
                   </thead>
                   <tbody/>
                 </table>
               </tbody>
             </table>
           </div>
         </div>
       </body>
    OUTPUT
        end


end
