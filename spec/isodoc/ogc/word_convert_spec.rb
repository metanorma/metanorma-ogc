require "spec_helper"

RSpec.describe IsoDoc::Ogc do

  it "processes permissions" do
        FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
        <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface><foreword id="A">
    <permission id="_">
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
                   <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
                   <td style='vertical-align:top;' class='recommend'>A</td>
                   <td style='vertical-align:top;' class='recommend'>B</td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
                   <td style='vertical-align:top;' class='recommend'>C</td>
                   <td style='vertical-align:top;' class='recommend'>D</td>
                 </tr>
                 <tr>
                   <td style='vertical-align:top;' class='recommend' colspan='2'>
                     <p class='MsoNormal'>
                       <a name='_' id='_'/>
                       The measurement target shall be measured as:
                     </p>
                     <div class='formula'>
                       <a name='_' id='_'/>
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
                         <span style='mso-tab-count:1'>&#xA0; </span>
                         (1)
                       </p>
                     </div>
                   </td>
                 </tr>
                 <tr style='background:#C9C9C9;'>
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
                   <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
                     <div class='formula'>
                       <a name='_' id='_'/>
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
                         <span style='mso-tab-count:1'>&#xA0; </span>
                         (1)
                       </p>
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
                   <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
                     <div class='formula'>
                       <a name='B' id='B'/>
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
                         <span style='mso-tab-count:1'>&#xA0; </span>
                         (1)
                       </p>
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
                   <td style='vertical-align:top;' class='recommend' colspan='2'>/ss/584/2015/level/1</td>
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
                     <div class='formula'>
                       <a name='_' id='_'/>
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
                         <span style='mso-tab-count:1'>&#xA0; </span>
                         (1)
                       </p>
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
                 Figure 1&#xA0;&#x2014; First figure
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

end
