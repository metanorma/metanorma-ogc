require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "processes IsoXML bibliographies" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          </bibdata>
                        #{METANORMA_EXTENSION}
          <preface><foreword id="A"><title>Preface</title>
        <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
        <eref bibitemid="ISO712"/>
        <eref bibitemid="ISBN"/>
        <eref bibitemid="ISSN"/>
        <eref bibitemid="ISO16634"/>
        <eref bibitemid="ref1"/>
        <eref bibitemid="ref10"/>
        <eref bibitemid="ref12"/>
        <eref bibitemid="zip_ffs"/>
        <eref bibitemid="ogc1"/>
        <eref bibitemid="ogc2"/>
        <eref bibitemid="ogc3"/>
        </p>
          </foreword></preface>
          <sections><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
          <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
      <bibitem id="ISO712" type="standard">
        <title format="text/plain">Cereals or cereal products</title>
        <title type="main" format="text/plain">Cereals and cereal products</title>
        <docidentifier type="ISO">ISO 712</docidentifier>
        <docidentifier type="metanorma">[110]</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
            <abbreviation>ISO</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ISO16634" type="standard">
        <title language="x" format="text/plain">Cereals, pulses, milled cereal products, xxxx, oilseeds and animal feeding stuffs</title>
        <title language="en" format="text/plain">Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</title>
        <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
        <date type="published"><on>--</on></date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
            <abbreviation>ISO</abbreviation>
          </organization>
        </contributor>
        <extent type="part">
        <referenceFrom>all</referenceFrom>
        </extent>
      </bibitem>
      <bibitem id="ISO20483" type="standard">
        <title format="text/plain">Cereals and pulses</title>
        <docidentifier type="ISO">ISO 20483:2013-2014</docidentifier>
        <date type="published"><from>2013</from><to>2014</to></date>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
            <abbreviation>ISO</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ref1">
        <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
        <docidentifier type="ICC">167</docidentifier>
      </bibitem>
      <note><p>This is an annotation of ISO 20483:2013-2014</p></note>
          <bibitem id="zip_ffs"><formattedref format="application/x-isodoc+xml">Title 5</formattedref><docidentifier type="metanorma">[5]</docidentifier></bibitem>
      <bibitem id="ogc1">
        <title type="title-main" format="text/plain" language="en" script="Latn">Development of Spatial Data Infrastructures for Marine Data Management</title>
        <uri type="obp">https://portal.opengeospatial.org/files/?artifact_id=88037</uri>
        <docidentifier type="OGC">19-025r1</docidentifier>
        <date type="published">
          <on>2019-05</on>
        </date>
        <contributor>
          <role type="author"/>
          <person>
            <name>
              <completename>Robert Thomas</completename>
            </name>
          </person>
        </contributor>
        <contributor>
          <role type="author"/>
          <person>
            <name>
              <completename>Terry Idol</completename>
            </name>
          </person>
        </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>Open Geospatial Consortium</name>
          </organization>
        </contributor>
        <edition>1</edition>
        <language>en</language>
        <script>Latn</script>
        <ext>
          <doctype>engineering-report</doctype>
          <editorialgroup>
            <committee>technical</committee>
            <subcommittee number="11" type="OGC">Subcommittee</subcommittee>
            <workgroup number="22" type="WG">Working</workgroup>
          </editorialgroup>
        </ext>
      </bibitem>
      <bibitem id="ogc2">
      <title language="en" format="text/plain">Conformance Test Guidelines for OpenGIS Catalog Services Specification for CORBA</title>
      <docidentifier type="OGC">00-027</docidentifier>
      <docnumber>00-027</docnumber>
      <date type="published">
      <on>2000</on>
      </date>
      <contributor>
      <role type="author"/>
      <organization>
      <name>Geodan Holding bv, the Netherlands</name>
      </organization>
      </contributor>
      <contributor>
      <role type="editor"/>
      <person>
      <name>
      <completename>Laura Diaz</completename>
      </name>
      </person>
      </contributor>
      <contributor>
      <role type="editor"/>
      <person>
      <name>
      <completename>Bart van der Eijnden</completename>
      </name>
      </person>
      </contributor>
      <contributor>
      <role type="editor"/>
      <person>
      <name>
      <completename>Barend Gehrels</completename>
      </name>
      </person>
      </contributor>
      <contributor>
      <role type="publisher"/>
      <organization>
      <name>Open Geospatial Consortium</name>
      </organization>
      </contributor>
      <edition>1.0</edition>
      <language>en</language>
      <script>Latn</script>
      <status>
      <stage>published</stage>
      </status>
      <copyright>
      <from>2020</from>
      <owner>
      <organization>
      <name>Open Geospatial Consortium</name>
      </organization>
      </owner>
      </copyright>
      <ext>
      <doctype>test-suite</doctype>
      <editorialgroup>
      <committee>technical</committee>
      </editorialgroup>
      </ext>
      </bibitem>
      <bibitem id="ogc3">
      <title language="en" format="text/plain">Technical Committee Policies and Procedures</title>
      <docidentifier type="OGC">05-020r27</docidentifier>
      <docnumber>05-020r27</docnumber>
      <date type="published">
      <on>2019-06-03</on>
      </date>
      <date type="issued">
      <on>2019-05-29</on>
      </date>
      <date type="received">
      <on>2019-03-28</on>
      </date>
      <contributor>
      <role type="editor"/>
      <person>
      <name>
      <completename>Scott Simmons</completename>
      </name>
      </person>
      </contributor>
      <contributor>
      <role type="publisher"/>
      <organization>
      <name>Open Geospatial Consortium</name>
      </organization>
      </contributor>
      <edition>27.0</edition>
      <language>en</language>
      <script>Latn</script>
      <status>
      <stage>draft</stage>
      </status>
      <copyright>
      <from>2019</from>
      <owner>
      <organization>
      <name>Open Geospatial Consortium</name>
      </organization>
      </owner>
      </copyright>
      <ext>
      <doctype>policy</doctype>
      <editorialgroup>
      <committee>Technical Committee</committee>
      </editorialgroup>
      </ext>
      </bibitem>
      </references>
      </sections>
      <bibliography>
        <references id="_bibliography" obligation="informative" normative="false">
        <title>Bibliography</title>
      <bibitem id="ISBN" type="book">
        <title format="text/plain">Chemicals for analytical laboratory use</title>
        <docidentifier type="ISBN">ISBN</docidentifier>
        <docidentifier type="metanorma">[1]</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>ISBN Publishers</name>
            <abbreviation>ISBN</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ISSN" type="journal">
        <title format="text/plain">Instruments for analytical laboratory use</title>
        <docidentifier type="ISSN">ISSN</docidentifier>
        <docidentifier type="metanorma">[2]</docidentifier>
        <uri>http://www.example.com</uri>
        <contributor>
        <role type='editor'/>
        <person>
          <name>
            <completename>Euclid</completename>
          </name>
        </person>
      </contributor>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>ISSN Publishers</name>
          </organization>
        </contributor>
      </bibitem>
      <note><p>This is an annotation of document ISSN.</p></note>
      <note><p>This is another annotation of document ISSN.</p></note>
      <bibitem id="ISO3696" type="standard">
        <title format="text/plain">Water for analytical laboratory use</title>
        <docidentifier type="ISO">ISO 3696</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>International Organization for Standardization</name>
            <abbreviation>ISO</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ref10">
        <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
        <docidentifier type="metanorma">[10]</docidentifier>
      </bibitem>
      <bibitem id="ref10a">
        <formattedref format="application/x-isodoc+xml"><em>Appelation of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
        <docidentifier>ABC</docidentifier>
      </bibitem>
      <bibitem id="ref11">
      <contributor>
                  <role type="author"/>
                  <person>
                    <name><completename>Fred Johnson</completename></name>
                  </person>
                </contributor>
              <contributor>
                  <role type="author"/>
                  <person>
                    <name>
                    <surname>Jackson</surname>
                    <formatted-initials>K. G.</formatted-initials>
                    </name>
                  </person>
                </contributor>
              <contributor>
                  <role type="author"/>
                  <person>
                    <name>
                    <surname>Nixon</surname>
                    <forename>Richard</forename>
                    <forename>Milhouse</forename>
                    </name>
                  </person>
                </contributor>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><completename>Euclid</completename></name>
                  </person>
                </contributor>
        <title>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</title>
        <docidentifier type="IETF">RFC 10</docidentifier>
      </bibitem>
      <bibitem id="ref12">
        <formattedref format="application/x-isodoc+xml">CitationWorks. 2019. <em>How to cite a reference</em>.</formattedref>
        <docidentifier type="metanorma">[Citn]</docidentifier>
        <docidentifier type="IETF">RFC 20</docidentifier>
      </bibitem>
      <bibitem id="rfc2616" type="standard"> <fetched>2020-03-27</fetched> <title format="text/plain" language="en" script="Latn">Hypertext Transfer Protocol — HTTP/1.1</title> <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri> <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri> <docidentifier type="IETF">RFC 2616</docidentifier> <docidentifier type="IETF" scope="anchor">RFC2616</docidentifier> <docidentifier type="DOI">10.17487/RFC2616</docidentifier> <date type="published">  <on>1999-06</on> </date> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">R. Fielding</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Gettys</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Mogul</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">H. Frystyk</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">L. Masinter</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">P. Leach</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">T. Berners-Lee</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <language>en</language> <script>Latn</script> <abstract format="text/plain" language="en" script="Latn">HTTP has been in use by the World-Wide Web global information initiative since 1990. This specification defines the protocol referred to as “HTTP/1.1”, and is an update to RFC 2068. [STANDARDS-TRACK]</abstract> <series type="main">  <title format="text/plain" language="en" script="Latn">RFC</title>  <number>2616</number> </series> <place>Fremont, CA</place></bibitem>
      </references>
      </bibliography>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
                  <bibdata>
                  <language current="true">en</language>
                  </bibdata>
                                #{METANORMA_EXTENSION}
                  <preface>    <clause type="toc" id="_" displayorder="1">
                  <title depth="1">Contents</title>
                  </clause>
                <foreword id="A" displayorder="2">
                  <title depth='1'>I.<tab/>Preface</title>
                  <p id="_">
                          <xref target="ISO712">[110]</xref>
        <xref target="ISBN">[1]</xref>
        <xref target="ISSN">[2]</xref>
        <xref target="ISO16634">ISO 16634:-- (all parts)</xref>
        <xref target="ref1">ICC&#xa0;167</xref>
        <xref target="ref10">[4]</xref>
        <xref target="ref12">Citn</xref>
        <xref target="zip_ffs">[5]</xref>
        <xref target="ogc1">OGC&#xa0;19-025r1</xref>
        <xref target="ogc2">OGC&#xa0;00-027</xref>
        <xref target="ogc3">OGC&#xa0;05-020r27 (draft)</xref>
                </p>
                  </foreword></preface>
                  <sections><references id="_" obligation="informative" normative="true" displayorder="3"><title depth="1">1.<tab/>Normative References</title>
                  <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
              <bibitem id="ISO712" type="standard">
                <formattedref>ISO: ISO&#xa0;712, <em>Cereals and cereal products</em>. International Organization for Standardization</formattedref>
                <docidentifier type="ISO">ISO&#xa0;712</docidentifier>
                <docidentifier type="metanorma">[110]</docidentifier>
                <docidentifier scope="biblio-tag">ISO 712</docidentifier>
                <biblio-tag/>
              </bibitem>
              <bibitem id="ISO16634" type="standard">
                <formattedref>ISO: ISO 16634:-- (all parts), <em>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</em>. International Organization for Standardization</formattedref>
                <docidentifier type="ISO">ISO 16634:-- (all parts)</docidentifier>
                <docidentifier scope="biblio-tag">ISO 16634:-- (all parts)</docidentifier>
                <biblio-tag/>
              </bibitem>
              <bibitem id="ISO20483" type="standard">
                <formattedref>ISO: ISO&#xa0;20483:2013-2014, <em>Cereals and pulses</em>. International Organization for Standardization (2013&#x2013;2014).</formattedref>
                <docidentifier type="ISO">ISO&#xa0;20483:2013-2014</docidentifier>
                <docidentifier scope="biblio-tag">ISO 20483:2013-2014</docidentifier>
                <biblio-tag/>
              </bibitem>
              <bibitem id="ref1">
                <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
                <docidentifier type="ICC">ICC&#xa0;167</docidentifier>
                <docidentifier scope="biblio-tag">ICC 167</docidentifier>
                <biblio-tag/>
              </bibitem>
              <note><name>NOTE:<tab/></name><p>This is an annotation of ISO 20483:2013-2014</p></note>
                  <bibitem id="zip_ffs"><formattedref format="application/x-isodoc+xml">Title 5</formattedref><docidentifier type="metanorma">[5]</docidentifier>
                  <biblio-tag/>
                  </bibitem>
                               <bibitem id="ogc1">
               <formattedref>
                 Robert Thomas, Terry Idol: OGC&#xa0;19-025r1,
                 <em>Development of Spatial Data Infrastructures for Marine Data Management</em>
                 . Open Geospatial Consortium (2019).
                 <link target="https://portal.opengeospatial.org/files/?artifact_id=88037">https://portal.opengeospatial.org/files/?artifact_id=88037</link>
                 .
               </formattedref>
               <uri type="obp">https://portal.opengeospatial.org/files/?artifact_id=88037</uri>
               <docidentifier type="OGC">OGC&#xa0;19-025r1</docidentifier>
               <docidentifier scope="biblio-tag">OGC 19-025r1</docidentifier>
               <biblio-tag/>
             </bibitem>
         <bibitem id='ogc2'>
           <formattedref>Geodan Holding bv, the Netherlands: OGC&#xa0;00-027, <em>Conformance Test Guidelines for OpenGIS Catalog Services Specification for CORBA</em>. Open Geospatial Consortium (2000).</formattedref>
           <docidentifier type='OGC'>OGC&#xa0;00-027</docidentifier>
           <docidentifier scope="biblio-tag">OGC 00-027</docidentifier>
                           <status>
                  <stage>published</stage>
                </status>
                <biblio-tag/>
         </bibitem>
         <bibitem id='ogc3'>
           <formattedref>Scott Simmons (ed.): OGC&#xa0;05-020r27 (Draft), <em>Technical Committee Policies and Procedures</em>.  Open Geospatial Consortium (2019).</formattedref>
           <docidentifier type='OGC'>OGC&#xa0;05-020r27</docidentifier>
           <docidentifier scope="biblio-tag">OGC 05-020r27</docidentifier>
           <status>
             <stage>draft</stage>
           </status>
           <biblio-tag/>
         </bibitem>
              </references>
              </sections>
              <bibliography>
            <references id="_" obligation="informative" normative="false" displayorder="4">
                <title depth="1">Bibliography</title>
                <bibitem id='ISBN' type='book'>
                <formattedref><em>Chemicals for analytical laboratory use</em>. ISBN Publishers, n.p. (n.d.).</formattedref>
                <docidentifier type='metanorma-ordinal'>[1]</docidentifier>
                <docidentifier type="ISBN">ISBN</docidentifier>
                <biblio-tag>[1]<tab/></biblio-tag>
              </bibitem>
              <bibitem id='ISSN' type='journal'>
                <formattedref><em>Instruments for analytical laboratory use</em>. ISSN Publishers. (n.d.).</formattedref>
                <docidentifier type='metanorma-ordinal'>[2]</docidentifier>
                <docidentifier type="ISSN">ISSN</docidentifier>
        <uri>http://www.example.com</uri>
                <biblio-tag>[2]<tab/></biblio-tag>
              </bibitem>
              <note><name>NOTE:<tab/></name><p>This is an annotation of document ISSN.</p></note>
              <note><name>NOTE:<tab/></name><p>This is another annotation of document ISSN.</p></note>
              <bibitem id="ISO3696" type="standard">
                <formattedref>ISO: ISO&#xa0;3696, <em>Water for analytical laboratory use</em>. International Organization for Standardization</formattedref>
                <docidentifier type='metanorma-ordinal'>[3]</docidentifier>
                <docidentifier type="ISO">ISO&#xa0;3696</docidentifier>
                <docidentifier scope="biblio-tag">ISO 3696</docidentifier>
                <biblio-tag>[3]<tab/></biblio-tag>
              </bibitem>
              <bibitem id="ref10">
                <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
                <docidentifier type='metanorma-ordinal'>[4]</docidentifier>
                <biblio-tag>[4]<tab/></biblio-tag>
              </bibitem>
              <bibitem id='ref10a'>
        <formattedref format='application/x-isodoc+xml'><em>Appelation of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target='http://www.icc.or.at'/>)</formattedref>
        <docidentifier type='metanorma-ordinal'>[5]</docidentifier>
        <docidentifier>ABC</docidentifier>
        <docidentifier scope="biblio-tag">ABC</docidentifier>
        <biblio-tag>[5]<tab/></biblio-tag>
      </bibitem>
              <bibitem id="ref11">
                <formattedref>Fred Johnson, Jackson KG, Nixon RM: IETF&#xa0;RFC&#xa0;10, <em>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</em>.</formattedref>
                <docidentifier type='metanorma-ordinal'>[6]</docidentifier>
                <docidentifier type="IETF">IETF&#xa0;RFC&#xa0;10</docidentifier>
                <docidentifier scope="biblio-tag">IETF RFC 10</docidentifier>
                <biblio-tag>[6]<tab/></biblio-tag>
              </bibitem>
              <bibitem id="ref12">
                <formattedref format="application/x-isodoc+xml">CitationWorks. 2019. <em>How to cite a reference</em>.</formattedref>
                <docidentifier type='metanorma-ordinal'>[7]</docidentifier>
                <docidentifier type="metanorma">[Citn]</docidentifier>
                <docidentifier type="IETF">IETF&#xa0;RFC&#xa0;20</docidentifier>
                <docidentifier scope="biblio-tag">IETF RFC 20</docidentifier>
                <biblio-tag>[7]<tab/></biblio-tag>
              </bibitem>
                    <bibitem id='rfc2616' type='standard'>
                      <formattedref>R. Fielding, J. Gettys, J. Mogul, H. Frystyk, L. Masinter, P. Leach, T. Berners-Lee: IETF&#xa0;RFC&#xa0;2616, <em>Hypertext Transfer Protocol&#x2009;&#x2014;&#x2009;HTTP/1.1</em>. Fremont, CA (1999). <link target='https://www.rfc-editor.org/info/rfc2616'>https://www.rfc-editor.org/info/rfc2616</link>.</formattedref>
        <uri type='xml'>https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri>
        <uri type='src'>https://www.rfc-editor.org/info/rfc2616</uri>
        <docidentifier type='metanorma-ordinal'>[8]</docidentifier>
        <docidentifier type='IETF'>IETF&#xa0;RFC&#xa0;2616</docidentifier>
        <docidentifier type='IETF' scope="anchor">IETF&#xa0;RFC2616</docidentifier>
        <docidentifier type='DOI'>DOI 10.17487/RFC2616</docidentifier>
         <docidentifier scope="biblio-tag">IETF RFC 2616</docidentifier>
                <biblio-tag>[8]<tab/></biblio-tag>
      </bibitem>
              </references>
              </bibliography>
                  </iso-standard>
    OUTPUT

    html = <<~OUTPUT
      #{HTML_HDR}
                 <br/>
                             <div id="A">
                <h1 class="ForewordTitle">I.  Preface</h1>
                <p id="_">
                   <a href="#ISO712">[110]</a>
                   <a href="#ISBN">[1]</a>
                   <a href="#ISSN">[2]</a>
                   <a href="#ISO16634">ISO 16634:-- (all parts)</a>
                   <a href="#ref1">ICC 167</a>
                   <a href="#ref10">[4]</a>
                   <a href="#ref12">Citn</a>
                   <a href="#zip_ffs">[5]</a>
                   <a href="#ogc1">OGC 19-025r1</a>
                   <a href="#ogc2">OGC 00-027</a>
                   <a href="#ogc3">OGC 05-020r27 (draft)</a>
                </p>
             </div>
             <div>
                <h1>1.  Normative References</h1>
                <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
                <p id="ISO712" class="NormRef">
                   ISO: ISO 712,
                   <i>Cereals and cereal products</i>
                   . International Organization for Standardization
                </p>
                <p id="ISO16634" class="NormRef">
                   ISO: ISO 16634:-- (all parts),
                   <i>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</i>
                   . International Organization for Standardization
                </p>
                <p id="ISO20483" class="NormRef">
                   ISO: ISO 20483:2013-2014,
                   <i>Cereals and pulses</i>
                   . International Organization for Standardization (2013–2014).
                </p>
                <p id="ref1" class="NormRef">
                   <span style="font-variant:small-caps;">Standard No I.C.C 167</span>
                   .
                   <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i>
                   (see
                   <a href="http://www.icc.or.at">http://www.icc.or.at</a>
                   )
                </p>
                <div class="Note">
                   <p>
                      <span class="note_label">NOTE:  </span>
                        This is an annotation of ISO 20483:2013-2014
                   </p>
                </div>
                <p id="zip_ffs" class="NormRef">Title 5</p>
                <p id="ogc1" class="NormRef">
                   Robert Thomas, Terry Idol: OGC 19-025r1,
                   <i>Development of Spatial Data Infrastructures for Marine Data Management</i>
                   . Open Geospatial Consortium (2019).
                   <a href="https://portal.opengeospatial.org/files/?artifact_id=88037">https://portal.opengeospatial.org/files/?artifact_id=88037</a>
                   .
                </p>
                <p id="ogc2" class="NormRef">
                   Geodan Holding bv, the Netherlands: OGC 00-027,
                   <i>Conformance Test Guidelines for OpenGIS Catalog Services Specification for CORBA</i>
                   . Open Geospatial Consortium (2000).
                </p>
                <p id="ogc3" class="NormRef">
                   Scott Simmons (ed.): OGC 05-020r27 (Draft),
                   <i>Technical Committee Policies and Procedures</i>
                   . Open Geospatial Consortium (2019).
                </p>
             </div>
             <br/>
             <div>
                <h1 class="Section3">Bibliography</h1>
                <p id="ISBN" class="Biblio">
                   [1] 
                   <i>Chemicals for analytical laboratory use</i>
                   . ISBN Publishers, n.p. (n.d.).
                </p>
                <p id="ISSN" class="Biblio">
                   [2] 
                   <i>Instruments for analytical laboratory use</i>
                   . ISSN Publishers. (n.d.).
                </p>
                <div class="Note">
                   <p>
                      <span class="note_label">NOTE:  </span>
                        This is an annotation of document ISSN.
                   </p>
                </div>
                <div class="Note">
                   <p>
                      <span class="note_label">NOTE:  </span>
                        This is another annotation of document ISSN.
                   </p>
                </div>
                <p id="ISO3696" class="Biblio">
                   [3]  ISO: ISO 3696,
                   <i>Water for analytical laboratory use</i>
                   . International Organization for Standardization
                </p>
                <p id="ref10" class="Biblio">
                   [4] 
                   <span style="font-variant:small-caps;">Standard No I.C.C 167</span>
                   .
                   <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i>
                   (see
                   <a href="http://www.icc.or.at">http://www.icc.or.at</a>
                   )
                </p>
                <p id="ref10a" class="Biblio">
                   [5] 
                   <i>Appelation of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i>
                   (see
                   <a href="http://www.icc.or.at">http://www.icc.or.at</a>
                   )
                </p>
                <p id="ref11" class="Biblio">
                   [6]  Fred Johnson, Jackson KG, Nixon RM: IETF RFC 10,
                   <i>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</i>
                   .
                </p>
                <p id="ref12" class="Biblio">
                   [7]  CitationWorks. 2019.
                   <i>How to cite a reference</i>
                   .
                </p>
                <p id="rfc2616" class="Biblio">
                   [8]  R. Fielding, J. Gettys, J. Mogul, H. Frystyk, L. Masinter, P. Leach, T. Berners-Lee: IETF RFC 2616,
                   <i>Hypertext Transfer Protocol — HTTP/1.1</i>
                   . Fremont, CA (1999).
                   <a href="https://www.rfc-editor.org/info/rfc2616">https://www.rfc-editor.org/info/rfc2616</a>
                   .
                </p>
             </div>
          </div>
       </body>
    OUTPUT
    pres_output = IsoDoc::Ogc::PresentationXMLConvert.new(presxml_options)
          .convert("test", input, true)
    xml = Nokogiri::XML(pres_output)
    xml.at("//xmlns:localized-strings").remove
    expect(Xml::C14n.format(strip_guid(xml.to_xml)))
      .to be_equivalent_to Xml::C14n.format(presxml)
    expect(Xml::C14n.format(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", pres_output, true)
      .sub(/^.*<body/m, "<body")
      .sub(%r{</body>.*$}m, "</body>")))
      .to be_equivalent_to Xml::C14n.format(html)
  end
end
