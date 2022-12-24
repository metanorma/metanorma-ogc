require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "processes keyword with no preface" do
    input = <<~"INPUT"
      <ogc-standard xmlns="#{Metanorma::Ogc::DOCUMENT_NAMESPACE}">
      <bibdata/>
        <preface><foreword>
          <note id="A" keep-with-next="true" keep-lines-together="true">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83e">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          <note id="B" keep-with-next="true" keep-lines-together="true" notag="true" unnumbered="true">
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">These results are based on a study carried out on three different types of kernel.</p>
      </note>
          </foreword></preface>
      </ogc-standard>
    INPUT

    presxml = <<~OUTPUT
      <ogc-standard xmlns="https://standards.opengeospatial.org/document" type="presentation">
         <bibdata/>
         <render>
           <preprocess-xslt>
             <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" version="1.0">
               <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
               <xsl:strip-space elements="*"/>
               <xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']">
                 <xsl:copy>
                   <xsl:apply-templates select="@*|node()"/><xsl:if test="normalize-space() != ''">:<tab/></xsl:if>
                 </xsl:copy>
               </xsl:template>
             </xsl:stylesheet>
           </preprocess-xslt>
         </render>
         <preface>
           <foreword displayorder="1">
             <note id="A" keep-with-next="true" keep-lines-together="true">
               <name>NOTE  1</name>
               <p id="_">These results are based on a study carried out on three different types of kernel.</p>
             </note>
             <note id="B" keep-with-next="true" keep-lines-together="true" notag="true" unnumbered="true">
               <p id="_">These results are based on a study carried out on three different types of kernel.</p>
             </note>
           </foreword>
         </preface>
       </ogc-standard>
    OUTPUT

    html = <<~"OUTPUT"
           #{HTML_HDR}
          <br/>
          <div>
            <h1 class="ForewordTitle"/>
            <div id="A" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
              <p>
                <span class="note_label">NOTE  1:  </span>
               These results are based on a study carried out on three different types of kernel.
              </p>
            </div>
            <div id="B" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
              <p>These results are based on a study carried out on three different types of kernel.</p>
            </div>
          </div>
          <p class="zzSTDTitle1"/>
        </div>
      </body>
    OUTPUT

    doc = <<~"OUTPUT"
      <body lang="EN-US" link="blue" vlink="#954F72">
         <div class="WordSection1">
           <p> </p>
         </div>
         <p>
           <br clear="all" class="section"/>
         </p>
         <div class="WordSection2">
           <p>
             <br clear="all" style="mso-special-character:line-break;page-break-before:always"/>
           </p>
           <div>
             <h1 class="ForewordTitle"/>
             <div id="A" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
               <p class="Note">
                 <span class="note_label">NOTE  1:
                 <span style="mso-tab-count:1">  </span></span>
                 These results are based on a study carried out on three different types of kernel.
               </p>
             </div>
             <div id="B" class="Note" style="page-break-after: avoid;page-break-inside: avoid;">
               <p class="Note">
                 <span class="note_label"/>
                 These results are based on a study carried out on three different types of kernel.
               </p>
             </div>
           </div>
           <p> </p>
         </div>
         <p>
           <br clear="all" class="section"/>
         </p>
         <div class="WordSection3">
           <p class="zzSTDTitle1"/>
         </div>
       </body>
    OUTPUT

    expect(xmlpp(strip_guid(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, ""))))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(
             IsoDoc::Ogc::HtmlConvert.new({})
             .convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to xmlpp(html)
    expect(xmlpp(
             IsoDoc::Ogc::WordConvert.new({})
             .convert("test", presxml, true)
             .gsub(%r{^.*<body}m, "<body")
             .gsub(%r{</body>.*}m, "</body>"),
           )).to be_equivalent_to xmlpp(doc)
  end
end
