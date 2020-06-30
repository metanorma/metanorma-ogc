require "spec_helper"

RSpec.describe IsoDoc::Ogc do

     it "processes terms and definitions" do
       FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface/>
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
expect(xmlpp(File.read("test.doc").gsub(%r{^.*<div class="WordSection3">}m, "<body><div class='WordSection3'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
<body>
  <div class='WordSection3'>
    <p class='zzSTDTitle1'/>
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
      <p class='TermNum'>
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

     it "processes permission classes" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
        <p id="_"><xref target="A1"/></p>
    <permission id="A1" type="class">
    <name>Permission Class 1</name>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <permission id="A2">
    <name>Permission 1-1</name>
  <label>Permission 1</label>
  </permission>
  <requirement id="A3">
    <name>Requirement 1-1</name>
  <label>Requirement 1</label>
  </requirement>
  <recommendation id="A4">
    <name>Recommendation 1-1</name>
  <label>Recommendation 1</label>
  </recommendation>
</permission>
    </foreword></preface>
    </ogc-standard>
    INPUT
        expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <p class='MsoNormal'>
               <a name='_' id='_'/>
               <a href='#A1'>Permission Class 1</a>
             </p>
             <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Target Type</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Permission 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Permission 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Requirement 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Recommendation 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
OUTPUT
      end

            it "processes requirement classes" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
        <p id="_"><xref target="A1"/></p>
    <requirement id="A1" type="class">
    <name>Requirement Class 1</name>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <permission id="A2">
    <name>Permission 1-1</name>
  <label>Permission 1</label>
  </permission>
  <requirement id="A3">
    <name>Requirement 1-1</name>
  <label>Requirement 1</label>
  </requirement>
  <recommendation id="A4">
    <name>Recommendation 1-1</name>
  <label>Recommendation 1</label>
  </recommendation>
</requirement>
    </foreword></preface>
    </ogc-standard>
    INPUT
        expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
               <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <p class='MsoNormal'>
               <a name='_' id='_'/>
               <a href='#A1'>Requirement Class 1</a>
             </p>
             <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A1' id='A1'/>
               <thead>
                 <tr>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Requirement Class 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Target Type</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Dependency</td>
                   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Permission 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Permission 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Requirement 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Requirement 1</p>
                     </td>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='1'>
                     <p class='MsoNormal'>Recommendation 1-1:</p>
                     <td style='vertical-align:top;' class='recommend' colspan='1'>
                       <p class='MsoNormal'>Recommendation 1</p>
                     </td>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
OUTPUT
      end

                  it "processes recommendation classes" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
        <p id="_"><xref target="A1"/></p>
    <recommendation id="A1" type="class">
    <name>Recommendation Class 1</name>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <permission id="A2">
  <name>Permission 1-1</name>
  <label>Permission 1</label>
  </permission>
  <requirement id="A3">
  <name>Requirement 1-1</name>
  <label>Requirement 1</label>
  </requirement>
  <recommendation id="A4">
  <name>Recommendation 1-1</name>
  <label>Recommendation 1</label>
  </recommendation>
</recommendation>
    </foreword></preface>
    </ogc-standard>
    INPUT
        expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <body xmlns:m=''>
          <div>
            <div>
              <a name='A' id='A'/>
              <h1 class='ForewordTitle'>
                i.
                <span style='mso-tab-count:1'>&#xA0; </span>
                Preface
              </h1>
              <p class='MsoNormal'>
                <a name='_' id='_'/>
                <a href='#A1'>Recommendation Class 1</a>
              </p>
              <table class='recommendclass' style='border-collapse:collapse;border-spacing:0;'>
                <a name='A1' id='A1'/>
                <thead>
                  <tr>
                    <th style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='RecommendationTitle'>Recommendation Class 1:</p>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='2'>
                      <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Target Type</td>
                    <td style='vertical-align:top;' class='recommend'>user</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend'>Dependency</td>
                    <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='1'>
                      <p class='MsoNormal'>Permission 1-1:</p>
                      <td style='vertical-align:top;' class='recommend' colspan='1'>
                        <p class='MsoNormal'>Permission 1</p>
                      </td>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='1'>
                      <p class='MsoNormal'>Requirement 1-1:</p>
                      <td style='vertical-align:top;' class='recommend' colspan='1'>
                        <p class='MsoNormal'>Requirement 1</p>
                      </td>
                    </td>
                  </tr>
                  <tr>
                    <td style='vertical-align:top;' class='recommend' colspan='1'>
                      <p class='MsoNormal'>Recommendation 1-1:</p>
                      <td style='vertical-align:top;' class='recommend' colspan='1'>
                        <p class='MsoNormal'>Recommendation 1</p>
                      </td>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
            <p class='MsoNormal'>&#xA0;</p>
          </div>
          <p class='MsoNormal'>
            <br clear='all' class='section'/>
          </p>
          <div class='WordSection3'>
            <p class='zzSTDTitle1'/>
          </div>
          <div style='mso-element:footnote-list'/>
        </body>
OUTPUT
      end


  it "processes permissions" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
    <permission id="_">
    <name>Permission 1</name>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <inherit>/ss/584/2015/level/2</inherit>
  <subject>user</subject>
  <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
  <dl>
  <dt>A</dt><dd>B</dd>
  <dt>C</dt><dd>D</dd>
  </dl>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="_">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</permission>
    </foreword></preface>
    </ogc-standard>
    INPUT
        expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <a name='_' id='_'/>
               <thead>
                 <tr style='background:#A5A5A5;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Permission 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                  <tr>
   <td style='vertical-align:top;' class='recommend'>Dependency</td>
   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
 </tr>
 <tr style='background:#C9C9C9;'>
   <td style='vertical-align:top;' class='recommend'>Dependency</td>
   <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/2</td>
 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Control-class</td>
                   <td style='vertical-align:top;' class='recommend'>Technical</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Priority</td>
                   <td style='vertical-align:top;' class='recommend'>P0</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       I recommend 
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div>
                       <a name='_' id='_'/>
                     <div class='formula'>
                       <p class='MsoNormal'>
                         <span class='stem'>
                           <m:oMath>
                             <m:f>
                               <m:fPr>
                                 <m:type m:val='bar'/>
                               </m:fPr>
                               <m:num>
                                 <m:r>
                                   <m:t>r</m:t>
                                 </m:r>
                               </m:num>
                               <m:den>
                                 <m:r>
                                   <m:t>1</m:t>
                                 </m:r>
                               </m:den>
                             </m:f>
                             <m:r>
                               <m:t>=0</m:t>
                             </m:r>
                           </m:oMath>
                         </span>
                       </p>
                     </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The following code will be run for verification:
                     </p>
                     <p class='Sourcecode'>
                       <a name='_' id='_'/>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if (success)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; recommendation(label:
                       success-response)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                       <br/>
                       &#xA0;&#xA0;&#xA0; 
                     </p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
    OUTPUT

  end

    it "processes permission tests" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
    <permission id="_" type="verification">
    <name>Permission Test 1</name>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <subject>user</subject>
  <classification> <tag>control-class</tag> <value>Technical</value> </classification><classification> <tag>priority</tag> <value>P0</value> </classification><classification> <tag>family</tag> <value>System and Communications Protection</value> </classification><classification> <tag>family</tag> <value>System and Communications Protocols</value> </classification>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
  <dl>
  <dt>A</dt><dd>B</dd>
  <dt>C</dt><dd>D</dd>
  </dl>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="_">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</permission>
    </foreword></preface>
    </ogc-standard>
    INPUT
        expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
        <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommendtest' style='border-collapse:collapse;border-spacing:0;'>
               <a name='_' id='_'/>
               <thead>
                 <tr style='background:#C9C9C9;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTestTitle'>Permission Test 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
  <td style='vertical-align:top;' class='recommend'>Dependency</td>
  <td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
</tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Control-class</td>
                   <td style='vertical-align:top;' class='recommend'>Technical</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Priority</td>
                   <td style='vertical-align:top;' class='recommend'>P0</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protection</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>Family</td>
                   <td style='vertical-align:top;' class='recommend'>System and Communications Protocols</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       I recommend 
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div>
                       <a name='_' id='_'/>
                     <div class='formula'>
                       <p class='MsoNormal'>
                         <span class='stem'>
                           <m:oMath>
                             <m:f>
                               <m:fPr>
                                 <m:type m:val='bar'/>
                               </m:fPr>
                               <m:num>
                                 <m:r>
                                   <m:t>r</m:t>
                                 </m:r>
                               </m:num>
                               <m:den>
                                 <m:r>
                                   <m:t>1</m:t>
                                 </m:r>
                               </m:den>
                             </m:f>
                             <m:r>
                               <m:t>=0</m:t>
                             </m:r>
                           </m:oMath>
                         </span>
                       </p>
                     </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The following code will be run for verification:
                     </p>
                     <p class='Sourcecode'>
                       <a name='_' id='_'/>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if (success)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; recommendation(label:
                       success-response)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                       <br/>
                       &#xA0;&#xA0;&#xA0; 
                     </p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
    OUTPUT
    end

  it "processes requirements" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
          <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
    <requirement id="A0" unnumbered="true">
    <name>Requirement</name>
  <title>A New Requirement</title>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <subject>user</subject>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
        </tr>
        <tr>
          <td style="text-align:left;">Mission</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
    <p id="_">As for the measurement targets,</p>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="B">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</requirement>
    </foreword></preface>
    </ogc-standard>
INPUT
        expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
<body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <a name='A0' id='A0'/>
               <thead>
                 <tr style='background:#A5A5A5;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Requirement: A New Requirement</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                 <td style='vertical-align:top;' class='recommend'>Dependency</td>
<td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       I recommend 
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       As for the measurement targets,
                     </p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div>
                       <a name='B' id='B'/>
                     <div class='formula'>
                       <p class='MsoNormal'>
                         <span class='stem'>
                           <m:oMath>
                             <m:f>
                               <m:fPr>
                                 <m:type m:val='bar'/>
                               </m:fPr>
                               <m:num>
                                 <m:r>
                                   <m:t>r</m:t>
                                 </m:r>
                               </m:num>
                               <m:den>
                                 <m:r>
                                   <m:t>1</m:t>
                                 </m:r>
                               </m:den>
                             </m:f>
                             <m:r>
                               <m:t>=0</m:t>
                             </m:r>
                           </m:oMath>
                         </span>
                       </p>
                     </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The following code will be run for verification:
                     </p>
                     <p class='Sourcecode'>
                       <a name='_' id='_'/>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if (success)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; recommendation(label:
                       success-response)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                       <br/>
                       &#xA0;&#xA0;&#xA0; 
                     </p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
    OUTPUT

  end

  it "processes recommendations" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
      <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
    <recommendation id="_">
    <name>Recommendation 1</name>
  <label>/ogc/recommendation/wfs/2</label>
  <inherit>/ss/584/2015/level/1</inherit>
  <subject>user</subject>
  <description>
    <p id="_">I recommend <em>this</em>.</p>
  </description>
  <specification exclude="true" type="tabular">
    <p id="_">This is the object of the recommendation:</p>
    <table id="_">
      <tbody>
        <tr>
          <td style="text-align:left;">Object</td>
          <td style="text-align:left;">Value</td>
        </tr>
        <tr>
          <td style="text-align:left;">Mission</td>
          <td style="text-align:left;">Accomplished</td>
        </tr>
      </tbody>
    </table>
  </specification>
  <description>
    <p id="_">As for the measurement targets,</p>
  </description>
  <measurement-target exclude="false">
    <p id="_">The measurement target shall be measured as:</p>
    <formula id="_">
      <stem type="AsciiMath">r/1 = 0</stem>
    </formula>
  </measurement-target>
  <verification exclude="false">
    <p id="_">The following code will be run for verification:</p>
    <sourcecode id="_">CoreRoot(success): HttpResponse
      if (success)
      recommendation(label: success-response)
      end
    </sourcecode>
  </verification>
  <import exclude="true">
    <sourcecode id="_">success-response()</sourcecode>
  </import>
</recommendation>
    </foreword></preface>
    </ogc-standard>
INPUT
        expect(xmlpp(File.read("test.doc").gsub(%r{^.*<a name="A" id="A">}m, "<body xmlns:m=''><div><div><a name='A' id='A'>").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
       <body xmlns:m=''>
         <div>
           <div>
             <a name='A' id='A'/>
             <h1 class='ForewordTitle'>
               i.
               <span style='mso-tab-count:1'>&#xA0; </span>
               Preface
             </h1>
             <table class='recommend' style='border-collapse:collapse;border-spacing:0;'>
               <a name='_' id='_'/>
               <thead>
                 <tr style='background:#A5A5A5;'>
                   <th style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='RecommendationTitle'>Recommendation 1:</p>
                   </th>
                 </tr>
               </thead>
               <tbody>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>/ogc/recommendation/wfs/2</p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>Subject</td>
                   <td style='vertical-align:top;' class='recommend'>user</td>
                 </tr>
                 <tr>
                 <td style='vertical-align:top;' class='recommend'>Dependency</td>
<td style='vertical-align:top;' class='recommend'>/ss/584/2015/level/1</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       I recommend 
                       <i>this</i>
                       .
                     </p>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       As for the measurement targets,
                     </p>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div>
                       <a name='_' id='_'/>
                     <div class='formula'>
                       <p class='MsoNormal'>
                         <span class='stem'>
                           <m:oMath>
                             <m:f>
                               <m:fPr>
                                 <m:type m:val='bar'/>
                               </m:fPr>
                               <m:num>
                                 <m:r>
                                   <m:t>r</m:t>
                                 </m:r>
                               </m:num>
                               <m:den>
                                 <m:r>
                                   <m:t>1</m:t>
                                 </m:r>
                               </m:den>
                             </m:f>
                             <m:r>
                               <m:t>=0</m:t>
                             </m:r>
                           </m:oMath>
                         </span>
                       </p>
                     </div>
                     </div>
                   </td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The following code will be run for verification:
                     </p>
                     <p class='Sourcecode'>
                       <a name='_' id='_'/>
                       CoreRoot(success): HttpResponse
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; if (success)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; recommendation(label:
                       success-response)
                       <br/>
                       &#xA0;&#xA0;&#xA0;&#xA0;&#xA0; end
                       <br/>
                       &#xA0;&#xA0;&#xA0; 
                     </p>
                   </td>
                 </tr>
               </tbody>
             </table>
           </div>
           <p class='MsoNormal'>&#xA0;</p>
         </div>
         <p class='MsoNormal'>
           <br clear='all' class='section'/>
         </p>
         <div class='WordSection3'>
           <p class='zzSTDTitle1'/>
         </div>
         <div style='mso-element:footnote-list'/>
       </body>
    OUTPUT
  end

    it "populates Word ToC" do
FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
        <iso-standard xmlns="http://riboseinc.com/isoxml">
        <sections>
               <clause id="A" inline-header="false" obligation="normative"><title>Clause 4</title><clause id="N" inline-header="false" obligation="normative">

         <title>Introduction<bookmark id="Q"/> to this<fn reference="1">
  <p id="_ff27c067-2785-4551-96cf-0a73530ff1e6">Formerly denoted as 15 % (m/m).</p>
</fn></title>
       </clause>
       <clause id="O" inline-header="false" obligation="normative">
         <title>Clause 4.2</title>
         <recommendation id="AA">
         <name>Recommendation 1</name<
  <label>/ogc/recommendation/wfs/2</label>
  </recommendation>
         <recommendation id="AB" type="verification">
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
    word = File.read("test.doc").sub(/^.*<div class="WordSection2">/m, '<div class="WordSection2">').
      sub(%r{^.*<p class="zzContents" style="margin-top:0cm">}m, "<div><p class='zzContents' style='margin-top:0cm'>").
      sub(%r{<p class="MsoNormal">\s*<br clear="all" class="section"/>\s*</p>\s*<div class="WordSection3">.*$}m, "")
      #sub(%r{<p class="MsoNormal">\s*\&#xA0;\s*</p>\s*</div>\s*$}, "")
    expect(xmlpp(word.gsub(/_Toc\d\d+/, "_Toc"))).to be_equivalent_to xmlpp(<<~'OUTPUT')
    <div>
         <p class='zzContents' style='margin-top:0cm'>
           <span lang='EN-GB' xml:lang='EN-GB'>Contents</span>
         </p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-begin'/>
             <span style='mso-spacerun:yes'>&#xA0;</span>
             TOC \o "1-2" \h \z \u
             <span style='mso-element:field-separator'/>
           </span>
           <span class='MsoHyperlink'>
             <span lang='EN-GB' xml:lang='EN-GB' style='mso-no-proof:yes'>
               <a href='#_Toc'>
                 1. Clause 4
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-tab-count:1 dotted'>. </span>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-begin'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'> PAGEREF _Toc \h </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-separator'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>1</span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'/>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-end'/>
                 </span>
               </a>
             </span>
           </span>
         </p>
         <p class='MsoToc2'>
           <span class='MsoHyperlink'>
             <span lang='EN-GB' xml:lang='EN-GB' style='mso-no-proof:yes'>
               <a href='#_Toc'>
                 1.1. Introduction to this
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-tab-count:1 dotted'>. </span>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-begin'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'> PAGEREF _Toc \h </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-separator'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>1</span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'/>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-end'/>
                 </span>
               </a>
             </span>
           </span>
         </p>
         <p class='MsoToc2'>
           <span class='MsoHyperlink'>
             <span lang='EN-GB' xml:lang='EN-GB' style='mso-no-proof:yes'>
               <a href='#_Toc'>
                 1.2. Clause 4.2
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-tab-count:1 dotted'>. </span>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-begin'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'> PAGEREF _Toc \h </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-separator'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>1</span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'/>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-end'/>
                 </span>
               </a>
             </span>
           </span>
         </p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-end'/>
           </span>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <p class='MsoNormal'>&#xA0;</p>
           </span>
         </p>
         <p class='TOCTitle'>List of Tables</p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-begin'/>
             <span style='mso-spacerun:yes'>&#xA0;</span>
             TOC \h \z \t "TableTitle,1"
             <span style='mso-element:field-separator'/>
           </span>
           <span class='MsoHyperlink'>
             <span lang='EN-GB' xml:lang='EN-GB' style='mso-no-proof:yes'>
               <a href='#_Toc'>
                 Table 1&#xA0;&#x2014; First table
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-tab-count:1 dotted'>. </span>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-begin'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'> PAGEREF _Toc \h </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-separator'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>1</span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'/>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-end'/>
                 </span>
               </a>
             </span>
           </span>
         </p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-end'/>
           </span>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <p class='MsoNormal'>&#xA0;</p>
           </span>
         </p>
         <p class='TOCTitle'>List of Figures</p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-begin'/>
             <span style='mso-spacerun:yes'>&#xA0;</span>
             TOC \h \z \t "FigureTitle,1"
             <span style='mso-element:field-separator'/>
           </span>
           <span class='MsoHyperlink'>
             <span lang='EN-GB' xml:lang='EN-GB' style='mso-no-proof:yes'>
               <a href='#_Toc'>
                 First figure
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-tab-count:1 dotted'>. </span>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-begin'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'> PAGEREF _Toc \h </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-separator'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>1</span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'/>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-end'/>
                 </span>
               </a>
             </span>
           </span>
         </p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-end'/>
           </span>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <p class='MsoNormal'>&#xA0;</p>
           </span>
         </p>
         <p class='TOCTitle'>List of Recommendations</p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-begin'/>
             <span style='mso-spacerun:yes'>&#xA0;</span>
             TOC \h \z \t "RecommendationTitle,1"
             <span style='mso-element:field-separator'/>
           </span>
           <span class='MsoHyperlink'>
             <span lang='EN-GB' xml:lang='EN-GB' style='mso-no-proof:yes'>
               <a href='#_Toc'>
                 Recommendation 1:
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-tab-count:1 dotted'>. </span>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-begin'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'> PAGEREF _Toc \h </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-separator'/>
                 </span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>1</span>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'/>
                 <span lang='EN-GB' xml:lang='EN-GB' class='MsoTocTextSpan'>
                   <span style='mso-element:field-end'/>
                 </span>
               </a>
             </span>
           </span>
         </p>
         <p class='MsoToc1'>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <span style='mso-element:field-end'/>
           </span>
           <span lang='EN-GB' xml:lang='EN-GB'>
             <p class='MsoNormal'>&#xA0;</p>
           </span>
         </p>
         <p class='MsoNormal'>&#xA0;</p>
       </div>
OUTPUT
    end

         it "processes boilerplate" do
       FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({wordcoverpage: "lib/isodoc/ogc/html/word_ogc_titlepage.html"}).convert("test", <<~"INPUT", false)
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
expect((File.read("test.doc").gsub(%r{^.*<div class="boilerplate-copyright">}m, "<div class='boilerplate-copyright'>").gsub(%r{<div class="warning">.*}m, ""))).to be_equivalent_to xmlpp(<<~"OUTPUT")
<div class='boilerplate-copyright'>
    <div><p class="TitlePageSubhead">Copyright notice</p>

    <p align="center" class="MsoNormal">A</p>
    </div>
    <div><p class="TitlePageSubhead">Note</p>

    <p class="MsoNormal">B</p>
    </div>
    </div>
OUTPUT
expect((File.read("test.doc").gsub(%r{^.*<div class="boilerplate-license">}m, "<div class='boilerplate-license'>").gsub(%r{<p class="license">.*}m, '<p class="license"/></div></div>'))).to be_equivalent_to xmlpp(<<~"OUTPUT")
<div class='boilerplate-license'>
    <div><p class="TitlePageSubhead">License Agreement</p>
    <p class="license"/></div></div>
OUTPUT
end


end
