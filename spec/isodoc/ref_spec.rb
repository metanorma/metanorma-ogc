require "spec_helper"

RSpec.describe IsoDoc::Ogc do
  it "processes IsoXML bibliographies" do
    input = <<~INPUT
          <iso-standard xmlns="http://riboseinc.com/isoxml">
          <bibdata>
          <language>en</language>
          </bibdata>
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
          <bibliography><references id="_normative_references" obligation="informative" normative="true"><title>Normative References</title>
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
      </references><references id="_bibliography" obligation="informative" normative="false">
        <title>Bibliography</title>
      <bibitem id="ISBN" type="ISBN">
        <title format="text/plain">Chemicals for analytical laboratory use</title>
        <docidentifier type="ISBN">ISBN</docidentifier>
        <docidentifier type="metanorma">[1]</docidentifier>
        <contributor>
          <role type="publisher"/>
          <organization>
            <name>ISBN</name>
            <abbreviation>ISBN</abbreviation>
          </organization>
        </contributor>
      </bibitem>
      <bibitem id="ISSN" type="ISSN">
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
            <name>ISSN</name>
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
                    <initial>K.G.</initial>
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
      <bibitem id="rfc2616" type="standard"> <fetched>2020-03-27</fetched> <title format="text/plain" language="en" script="Latn">Hypertext Transfer Protocol — HTTP/1.1</title> <uri type="xml">https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri> <uri type="src">https://www.rfc-editor.org/info/rfc2616</uri> <docidentifier type="IETF">RFC 2616</docidentifier> <docidentifier type="rfc-anchor">RFC2616</docidentifier> <docidentifier type="DOI">10.17487/RFC2616</docidentifier> <date type="published">  <on>1999-06</on> </date> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">R. Fielding</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Gettys</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">J. Mogul</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">H. Frystyk</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">L. Masinter</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">P. Leach</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <contributor>  <role type="author"/>  <person>   <name>    <completename language="en">T. Berners-Lee</completename>   </name>   <affiliation>    <organization>     <name>IETF</name>     <abbreviation>IETF</abbreviation>    </organization>   </affiliation>  </person> </contributor> <language>en</language> <script>Latn</script> <abstract format="text/plain" language="en" script="Latn">HTTP has been in use by the World-Wide Web global information initiative since 1990. This specification defines the protocol referred to as “HTTP/1.1”, and is an update to RFC 2068. [STANDARDS-TRACK]</abstract> <series type="main">  <title format="text/plain" language="en" script="Latn">RFC</title>  <number>2616</number> </series> <place>Fremont, CA</place></bibitem>
      </references>
      </bibliography>
          </iso-standard>
    INPUT

    presxml = <<~OUTPUT
              <iso-standard xmlns="http://riboseinc.com/isoxml" type="presentation">
                  <bibdata>
                  <language current="true">en</language>
                  </bibdata>
                  <preface><foreword id="A" displayorder="1">
                  <title depth='1'>I.<tab/>Preface</title>
                <p id="_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f">
                <eref bibitemid="ISO712">[110]</eref>
                <eref bibitemid="ISBN">[1]</eref>
                <eref bibitemid="ISSN">[2]</eref>
                <eref bibitemid="ISO16634">ISO 16634:-- (all parts)</eref>
                <eref bibitemid="ref1">ICC 167</eref>
                <eref bibitemid="ref10">[10]</eref>
                <eref bibitemid="ref12">Citn</eref>
                <eref bibitemid="zip_ffs">[5]</eref>
                <eref bibitemid='ogc1'>OGC 19-025r1</eref>
      <eref bibitemid='ogc2'>OGC 00-027</eref>
      <eref bibitemid='ogc3'>OGC 05-020r27 (draft)</eref>
                </p>
                  </foreword></preface>
                  <bibliography><references id="_normative_references" obligation="informative" normative="true" displayorder="2"><title depth="1">1.<tab/>Normative References</title>
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
                  </organization>
                </contributor>
              </bibitem>
              <bibitem id="ref1">
                <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
                <docidentifier type="ICC">ICC 167</docidentifier>
              </bibitem>
              <note><name>NOTE</name><p>This is an annotation of ISO 20483:2013-2014</p></note>
                  <bibitem id="zip_ffs"><formattedref format="application/x-isodoc+xml">Title 5</formattedref><docidentifier type="metanorma">[5]</docidentifier></bibitem>
                     <bibitem id='ogc1'>
           <title type='title-main' format='text/plain' language='en' script='Latn'>Development of Spatial Data Infrastructures for Marine Data Management</title>
           <uri type='obp'>https://portal.opengeospatial.org/files/?artifact_id=88037</uri>
           <docidentifier type='OGC'>OGC 19-025r1</docidentifier>
           <date type='published'>
             <on>2019</on>
           </date>
           <contributor>
             <role type='author'/>
             <person>
               <name>
                 <completename>Robert Thomas</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='author'/>
             <person>
               <name>
                 <completename>Terry Idol</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='publisher'/>
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
               <subcommittee number='11' type='OGC'>Subcommittee</subcommittee>
               <workgroup number='22' type='WG'>Working</workgroup>
             </editorialgroup>
           </ext>
         </bibitem>
         <bibitem id='ogc2'>
           <title language='en' format='text/plain'>
             Conformance Test Guidelines for OpenGIS Catalog Services Specification
             for CORBA
           </title>
           <docidentifier type='OGC'>OGC 00-027</docidentifier>
           <docnumber>00-027</docnumber>
           <date type="published">
      <on>2000</on>
      </date>
           <contributor>
             <role type='author'/>
             <organization>
               <name>Geodan Holding bv, the Netherlands</name>
             </organization>
           </contributor>
           <contributor>
             <role type='editor'/>
             <person>
               <name>
                 <completename>Laura Diaz</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'/>
             <person>
               <name>
                 <completename>Bart van der Eijnden</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='editor'/>
             <person>
               <name>
                 <completename>Barend Gehrels</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='publisher'/>
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
         <bibitem id='ogc3'>
           <title language='en' format='text/plain'>Technical Committee Policies and Procedures</title>
           <docidentifier type='OGC'>OGC 05-020r27</docidentifier>
           <docnumber>05-020r27</docnumber>
           <date type='published'>
             <on>2019</on>
           </date>
           <date type='issued'>
             <on>2019</on>
           </date>
           <date type='received'>
             <on>2019</on>
           </date>
           <contributor>
             <role type='editor'/>
             <person>
               <name>
                 <completename>Scott Simmons</completename>
               </name>
             </person>
           </contributor>
           <contributor>
             <role type='publisher'/>
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
              </references><references id="_bibliography" obligation="informative" normative="false" displayorder="3">
                <title depth="1">Bibliography</title>
              <bibitem id="ISBN" type="ISBN">
                <title format="text/plain">Chemicals for analytical laboratory use</title>
                <docidentifier type='metanorma-ordinal'>[1]</docidentifier>
                <docidentifier type="ISBN">ISBN</docidentifier>
                <docidentifier type="metanorma">[1]</docidentifier>
                <contributor>
                  <role type="publisher"/>
                  <organization>
                    <name>ISBN</name>
                    <abbreviation>ISBN</abbreviation>
                  </organization>
                </contributor>
              </bibitem>
              <bibitem id="ISSN" type="ISSN">
                <title format="text/plain">Instruments for analytical laboratory use</title>
                <docidentifier type='metanorma-ordinal'>[2]</docidentifier>
                <docidentifier type="ISSN">ISSN</docidentifier>
                <docidentifier type="metanorma">[2]</docidentifier>
        <uri>http://www.example.com</uri>
                <contributor>
                  <role type="editor"/>
                  <person>
                    <name><completename>Euclid</completename></name>
                  </person>
                </contributor>
                <contributor>
                  <role type="publisher"/>
                  <organization>
                    <name>ISSN</name>
                  </organization>
                </contributor>
              </bibitem>
              <note><name>NOTE</name><p>This is an annotation of document ISSN.</p></note>
              <note><name>NOTE</name><p>This is another annotation of document ISSN.</p></note>
              <bibitem id="ISO3696" type="standard">
                <title format="text/plain">Water for analytical laboratory use</title>
                <docidentifier type='metanorma-ordinal'>[3]</docidentifier>
                <docidentifier type="ISO">ISO 3696</docidentifier>
                <contributor>
                  <role type="publisher"/>
                  <organization>
                    <name>International Organization for Standardization</name>
                  </organization>
                </contributor>
              </bibitem>
              <bibitem id="ref10">
                <formattedref format="application/x-isodoc+xml"><smallcap>Standard No I.C.C 167</smallcap>. <em>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target="http://www.icc.or.at"/>)</formattedref>
                <docidentifier type='metanorma-ordinal'>[4]</docidentifier>
                <docidentifier type="metanorma">[10]</docidentifier>
              </bibitem>
              <bibitem id='ref10a'>
        <formattedref format='application/x-isodoc+xml'><em>Appelation of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</em> (see <link target='http://www.icc.or.at'/>)</formattedref>
        <docidentifier type='metanorma-ordinal'>[5]</docidentifier>
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
                    <initial>K.G.</initial>
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
                <docidentifier type='metanorma-ordinal'>[6]</docidentifier>
                <docidentifier type="IETF">IETF RFC 10</docidentifier>
              </bibitem>
              <bibitem id="ref12">
                <formattedref format="application/x-isodoc+xml">CitationWorks. 2019. <em>How to cite a reference</em>.</formattedref>
                <docidentifier type='metanorma-ordinal'>[7]</docidentifier>
                <docidentifier type="metanorma">[Citn]</docidentifier>
                <docidentifier type="IETF">IETF RFC 20</docidentifier>
              </bibitem>
                    <bibitem id='rfc2616' type='standard'>
        <fetched>2020-03-27</fetched>
        <title format='text/plain' language='en' script='Latn'>Hypertext Transfer Protocol&#x2009;&#x2014;&#x2009;HTTP/1.1</title>
        <uri type='xml'>https://xml2rfc.tools.ietf.org/public/rfc/bibxml/reference.RFC.2616.xml</uri>
        <uri type='src'>https://www.rfc-editor.org/info/rfc2616</uri>
        <docidentifier type='metanorma-ordinal'>[8]</docidentifier>
        <docidentifier type='IETF'>IETF RFC 2616</docidentifier>
        <docidentifier type='rfc-anchor'>RFC2616</docidentifier>
        <docidentifier type='DOI'>DOI 10.17487/RFC2616</docidentifier>
        <date type='published'>
          <on>1999</on>
        </date>
        <contributor>
          <role type='author'/>
          <person>
            <name>
              <completename language='en'>R. Fielding</completename>
            </name>
            <affiliation>
              <organization>
                <name>IETF</name>
                <abbreviation>IETF</abbreviation>
              </organization>
            </affiliation>
          </person>
        </contributor>
        <contributor>
          <role type='author'/>
          <person>
            <name>
              <completename language='en'>J. Gettys</completename>
            </name>
            <affiliation>
              <organization>
                <name>IETF</name>
                <abbreviation>IETF</abbreviation>
              </organization>
            </affiliation>
          </person>
        </contributor>
        <contributor>
          <role type='author'/>
          <person>
            <name>
              <completename language='en'>J. Mogul</completename>
            </name>
            <affiliation>
              <organization>
                <name>IETF</name>
                <abbreviation>IETF</abbreviation>
              </organization>
            </affiliation>
          </person>
        </contributor>
        <contributor>
          <role type='author'/>
          <person>
            <name>
              <completename language='en'>H. Frystyk</completename>
            </name>
            <affiliation>
              <organization>
                <name>IETF</name>
                <abbreviation>IETF</abbreviation>
              </organization>
            </affiliation>
          </person>
        </contributor>
        <contributor>
          <role type='author'/>
          <person>
            <name>
              <completename language='en'>L. Masinter</completename>
            </name>
            <affiliation>
              <organization>
                <name>IETF</name>
                <abbreviation>IETF</abbreviation>
              </organization>
            </affiliation>
          </person>
        </contributor>
        <contributor>
          <role type='author'/>
          <person>
            <name>
              <completename language='en'>P. Leach</completename>
            </name>
            <affiliation>
              <organization>
                <name>IETF</name>
                <abbreviation>IETF</abbreviation>
              </organization>
            </affiliation>
          </person>
        </contributor>
        <contributor>
          <role type='author'/>
          <person>
            <name>
              <completename language='en'>T. Berners-Lee</completename>
            </name>
            <affiliation>
              <organization>
                <name>IETF</name>
                <abbreviation>IETF</abbreviation>
              </organization>
            </affiliation>
          </person>
        </contributor>
        <language>en</language>
        <script>Latn</script>
        <abstract format='text/plain' language='en' script='Latn'>
          HTTP has been in use by the World-Wide Web global information
          initiative since 1990. This specification defines the protocol
          referred to as &#x201C;HTTP/1.1&#x201D;, and is an update to RFC 2068.
          [STANDARDS-TRACK]
        </abstract>
        <series type='main'>
          <title format='text/plain' language='en' script='Latn'>RFC</title>
          <number>2616</number>
        </series>
        <place>Fremont, CA</place>
      </bibitem>
              </references>
              </bibliography>
                  </iso-standard>
    OUTPUT

    html = <<~OUTPUT
          #{HTML_HDR}
          <br/>
                   <div id="A">
                     <h1 class="ForewordTitle">I.&#160; Preface</h1>
                     <p id='_f06fd0d1-a203-4f3d-a515-0bdba0f8d83f'>
        <a href='#ISO712'>[110]</a>
        <a href='#ISBN'>[1]</a>
        <a href='#ISSN'>[2]</a>
        <a href='#ISO16634'>ISO 16634:-- (all parts)</a>
        <a href='#ref1'>ICC 167</a>
        <a href='#ref10'>[10]</a>
        <a href='#ref12'>Citn</a>
        <a href='#zip_ffs'>[5]</a>
        <a href='#ogc1'>OGC 19-025r1</a>
      <a href='#ogc2'>OGC 00-027</a>
      <a href='#ogc3'>OGC 05-020r27 (draft)</a>
      </p>
                   </div>
                   <p class="zzSTDTitle1"/>
                   <div><h1>1.&#160; Normative References</h1>
                 <p>The following documents are referred to in the text in such a way that some or all of their content constitutes requirements of this document. For dated references, only the edition cited applies. For undated references, the latest edition of the referenced document (including any amendments) applies.</p>
             <p id="ISO712" class="NormRef">International Organization for Standardization: ISO 712, <i>Cereals and cereal products</i>. <span>International Organization for Standardization</span></p>
             <p id="ISO16634" class="NormRef">ISO: ISO 16634:-- (all parts), <i>Cereals, pulses, milled cereal products, oilseeds and animal feeding stuffs</i>. <span>International Organization for Standardization</span> (--).</p>
             <p id="ISO20483" class="NormRef">International Organization for Standardization: ISO 20483:2013-2014, <i>Cereals and pulses</i>. <span>International Organization for Standardization</span> (2013&#8211;2014).</p>
             <p id="ref1" class="NormRef"><span style="font-variant:small-caps;">Standard No I.C.C 167</span>. <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i> (see <a href="http://www.icc.or.at">http://www.icc.or.at</a>)</p>
             <div class="Note"><p><span class="note_label">NOTE</span>&#160; This is an annotation of ISO 20483:2013-2014</p></div>
                 <p id="zip_ffs" class="NormRef">Title 5</p>
           <p id='ogc1' class='NormRef'>
             Robert Thomas, Terry Idol: OGC 19-025r1,
             <i>Development of Spatial Data Infrastructures for Marine Data Management</i>
             .
             <span>Open Geospatial Consortium</span>
              (2019).
             <a href='https://portal.opengeospatial.org/files/?artifact_id=88037'>https://portal.opengeospatial.org/files/?artifact_id=88037</a>
           </p>
           <p id='ogc2' class='NormRef'>
             Geodan Holding bv, the Netherlands: OGC 00-027,
             <i>
                Conformance Test Guidelines for OpenGIS Catalog Services
               Specification for CORBA
             </i>
             .
             <span>Open Geospatial Consortium</span>
              (2000).
           </p>
           <p id='ogc3' class='NormRef'>
             Scott Simmons: OGC 05-020r27 (Draft),
             <i>Technical Committee Policies and Procedures</i>
             .
             <span>Open Geospatial Consortium</span>
              (2019).
           </p>
             </div>
                   <br/>
                   <div><h1 class="Section3">Bibliography</h1>
             <p id="ISBN" class="Biblio">[1]&#160; ISBN: ISBN, <i>Chemicals for analytical laboratory use</i>. <span>ISBN</span></p>
             <p id="ISSN" class="Biblio">[2]&#160; Euclid: ISSN, <i>Instruments for analytical laboratory use</i>. <span>ISSN</span> <a href="http://www.example.com">http://www.example.com</a></p>
             <div class="Note"><p><span class="note_label">NOTE</span>&#160; This is an annotation of document ISSN.</p></div>
             <div class="Note"><p><span class="note_label">NOTE</span>&#160; This is another annotation of document ISSN.</p></div>
             <p id="ISO3696" class="Biblio">[3]&#160; International Organization for Standardization: ISO 3696, <i>Water for analytical laboratory use</i>. <span>International Organization for Standardization</span></p>
             <p id="ref10" class="Biblio">[4]&#160; <span style="font-variant:small-caps;">Standard No I.C.C 167</span>. <i>Determination of the protein content in cereal and cereal products for food and animal feeding stuffs according to the Dumas combustion method</i> (see <a href="http://www.icc.or.at">http://www.icc.or.at</a>)</p>
             <p id='ref10a' class='Biblio'>
        [5]&#160;
        <i>
          Appelation of the protein content in cereal and cereal products for
          food and animal feeding stuffs according to the Dumas combustion
          method
        </i>
         (see
        <a href='http://www.icc.or.at'>http://www.icc.or.at</a>
        )
      </p>
             <p id="ref11" class="Biblio">[6]&#160; Fred Johnson, Jackson KG, Nixon RM: IETF RFC 10, <i>Internet Calendaring and Scheduling Core Object Specification (iCalendar)</i>. </p>
             <p id="ref12" class="Biblio">[7]&#160; CitationWorks. 2019. <i>How to cite a reference</i>.</p>
                   <p id='rfc2616' class='Biblio'>
        [8]&#160; R. Fielding, J. Gettys, J. Mogul, H. Frystyk, L. Masinter, P.
        Leach, T. Berners-Lee: IETF RFC 2616,
        <i>Hypertext Transfer Protocol&#8201;&#8212;&#8201;HTTP/1.1</i>
        . Fremont, CA (1999).
        <a href='https://www.rfc-editor.org/info/rfc2616'>https://www.rfc-editor.org/info/rfc2616</a>
      </p>
             </div>
                 </div>
               </body>
    OUTPUT
    expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({})
      .convert("test", input, true)
      .sub(%r{<localized-strings>.*</localized-strings>}m, "")))
      .to be_equivalent_to xmlpp(presxml)
    expect(xmlpp(IsoDoc::Ogc::HtmlConvert.new({})
      .convert("test", presxml, true)
      .sub(/^.*<body/m, "<body")
      .sub(%r{</body>.*$}m, "</body>")))
      .to be_equivalent_to xmlpp(html)
  end
end
