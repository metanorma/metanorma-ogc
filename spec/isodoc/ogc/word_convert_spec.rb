require "spec_helper"

RSpec.describe IsoDoc::Ogc do

     it "processes terms and definitions" do
       FileUtils.rm_f "test.doc"
    IsoDoc::Ogc::WordConvert.new({}).convert("test", <<~"INPUT", false)
    <ogc-standard xmlns="https://standards.opengeospatial.org/document">
    <preface/>
    <sections>
    <terms id="_terms_and_definitions" obligation="normative"><title>1.<tab/>Terms and definitions</title><p id="_bf202ad0-7300-4cca-80ae-87ef7008f0fd">For the purposes of this document,
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
                 Clause 4
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
                 Introduction to this
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
                 Clause 4.2
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
                 First table
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
