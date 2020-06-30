require "spec_helper"

RSpec.describe IsoDoc::Ogc do
    it "cross-references requirements" do
      expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <!--
               <a href='#N1'>Introduction, Requirement 1</a>
               <a href='#N2'>Clause ii.1, Requirement (??)</a>
               <a href='#N'>Clause 1, Requirement 2</a>
               <a href='#note1'>Clause 3.1, Requirement 3</a>
               <a href='#note2'>Clause 3.1, Requirement 4</a>
               <a href='#AN'>Annex A.1, Requirement A.1</a>
               <a href='#Anote1'>Annex A.2, Requirement (??)</a>
               <a href='#Anote2'>Annex A.2, Requirement A.2</a>
               -->
               <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <requirement id='N1'>
                <name>Requirement 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
              <clause id='xyz'>
                <title>Preparatory</title>
                <requirement id='N2' unnumbered='true'>
                  <name>Requirement</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </requirement>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <requirement id='N'>
                <name>Requirement 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <requirement id='note1'>
                  <name>Requirement 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </requirement>
                <requirement id='note2'>
                  <name>Requirement 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </requirement>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <requirement id='AN'>
                <name>Requirement A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
            </clause>
            <clause id='annex1b'>
              <requirement id='Anote1' unnumbered='true'>
                <name>Requirement</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
              <requirement id='Anote2'>
                <name>Requirement A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
            </clause>
          </annex>
        </iso-standard>
OUTPUT
    end

        it "cross-references requirement tests" do
          expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <!--
               <a href='#N1'>Introduction, Requirement Test 1</a>
               <a href='#N2'>Clause ii.1, Requirement Test (??)</a>
               <a href='#N'>Clause 1, Requirement Test 2</a>
               <a href='#note1'>Clause 3.1, Requirement Test 3</a>
               <a href='#note2'>Clause 3.1, Requirement Test 4</a>
               <a href='#AN'>Annex A.1, Requirement Test A.1</a>
               <a href='#Anote1'>Annex A.2, Requirement Test (??)</a>
               <a href='#Anote2'>Annex A.2, Requirement Test A.2</a>
               -->
               <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <requirement id='N1' type='verification'>
                <name>Requirement Test 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
              <clause id='xyz'>
                <title>Preparatory</title>
                <requirement id='N2' unnumbered='true' type='verification'>
                  <name>Requirement Test</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </requirement>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <requirement id='N' type='verification'>
                <name>Requirement Test 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <requirement id='note1' type='verification'>
                  <name>Requirement Test 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </requirement>
                <requirement id='note2' type='verification'>
                  <name>Requirement Test 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </requirement>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <requirement id='AN' type='verification'>
                <name>Requirement Test A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
            </clause>
            <clause id='annex1b'>
              <requirement id='Anote1' unnumbered='true' type='verification'>
                <name>Requirement Test</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
              <requirement id='Anote2' type='verification'>
                <name>Requirement Test A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </requirement>
            </clause>
          </annex>
        </iso-standard>
OUTPUT
        end


        it "cross-references recommendations" do
          expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <!--
               <a href='#N1'>Introduction, Recommendation 1</a>
               <a href='#N2'>Clause ii.1, Recommendation (??)</a>
               <a href='#N'>Clause 1, Recommendation 2</a>
               <a href='#note1'>Clause 3.1, Recommendation 3</a>
               <a href='#note2'>Clause 3.1, Recommendation 4</a>
               <a href='#AN'>Annex A.1, Recommendation A.1</a>
               <a href='#Anote1'>Annex A.2, Recommendation (??)</a>
               <a href='#Anote2'>Annex A.2, Recommendation A.2</a>
               -->
                <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <recommendation id='N1'>
                <name>Recommendation 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
              <clause id='xyz'>
                <title>Preparatory</title>
                <recommendation id='N2' unnumbered='true'>
                  <name>Recommendation</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </recommendation>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <recommendation id='N'>
                <name>Recommendation 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <recommendation id='note1'>
                  <name>Recommendation 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </recommendation>
                <recommendation id='note2'>
                  <name>Recommendation 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </recommendation>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <recommendation id='AN'>
                <name>Recommendation A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
            </clause>
            <clause id='annex1b'>
              <recommendation id='Anote1' unnumbered='true'>
                <name>Recommendation</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
              <recommendation id='Anote2'>
                <name>Recommendation A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
            </clause>
          </annex>
        </iso-standard>
OUTPUT
    end

          it "cross-references recommendation tests" do
            expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <!--
               <a href='#N1'>Introduction, Recommendation Test 1</a>
               <a href='#N2'>Clause ii.1, Recommendation Test (??)</a>
               <a href='#N'>Clause 1, Recommendation Test 2</a>
               <a href='#note1'>Clause 3.1, Recommendation Test 3</a>
               <a href='#note2'>Clause 3.1, Recommendation Test 4</a>
               <a href='#AN'>Annex A.1, Recommendation Test A.1</a>
               <a href='#Anote1'>Annex A.2, Recommendation Test (??)</a>
               <a href='#Anote2'>Annex A.2, Recommendation Test A.2</a>
               -->
               <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <recommendation id='N1' type='verification'>
                <name>Recommendation Test 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
              <clause id='xyz'>
                <title>Preparatory</title>
                <recommendation id='N2' unnumbered='true' type='verification'>
                  <name>Recommendation Test</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </recommendation>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <recommendation id='N' type='verification'>
                <name>Recommendation Test 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <recommendation id='note1' type='verification'>
                  <name>Recommendation Test 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </recommendation>
                <recommendation id='note2' type='verification'>
                  <name>Recommendation Test 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </recommendation>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <recommendation id='AN' type='verification'>
                <name>Recommendation Test A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
            </clause>
            <clause id='annex1b'>
              <recommendation id='Anote1' unnumbered='true' type='verification'>
                <name>Recommendation Test</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
              <recommendation id='Anote2' type='verification'>
                <name>Recommendation Test A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </recommendation>
            </clause>
          </annex>
        </iso-standard>
OUTPUT
          end

        it "cross-references permissions" do
          expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <!--
               <a href='#N1'>Introduction, Permission 1</a>
               <a href='#N2'>Clause ii.1, Permission (??)</a>
               <a href='#N'>Clause 1, Permission 2</a>
               <a href='#note1'>Clause 3.1, Permission 3</a>
               <a href='#note2'>Clause 3.1, Permission 4</a>
               <a href='#AN'>Annex A.1, Permission A.1</a>
               <a href='#Anote1'>Annex A.2, Permission (??)</a>
               <a href='#Anote2'>Annex A.2, Permission A.2</a>
               -->
               <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <permission id='N1'>
                <name>Permission 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <clause id='xyz'>
                <title>Preparatory</title>
                <permission id='N2' unnumbered='true'>
                  <name>Permission</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <permission id='N'>
                <name>Permission 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <permission id='note1'>
                  <name>Permission 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <permission id='note2'>
                  <name>Permission 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <permission id='AN'>
                <name>Permission A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
            <clause id='annex1b'>
              <permission id='Anote1' unnumbered='true'>
                <name>Permission</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <permission id='Anote2'>
                <name>Permission A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
          </annex>
        </iso-standard>
OUTPUT
    end

               it "cross-references permission tests" do
                 expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <!--
               <a href='#N1'>Introduction, Permission Test 1</a>
               <a href='#N2'>Clause ii.1, Permission Test (??)</a>
               <a href='#N'>Clause 1, Permission Test 2</a>
               <a href='#note1'>Clause 3.1, Permission Test 3</a>
               <a href='#note2'>Clause 3.1, Permission Test 4</a>
               <a href='#AN'>Annex A.1, Permission Test A.1</a>
               <a href='#Anote1'>Annex A.2, Permission Test (??)</a>
               <a href='#Anote2'>Annex A.2, Permission Test A.2</a>
               -->
                <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <permission id='N1' type='verification'>
                <name>Permission Test 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <clause id='xyz'>
                <title>Preparatory</title>
                <permission id='N2' unnumbered='true' type='verification'>
                  <name>Permission Test</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <permission id='N' type='verification'>
                <name>Permission Test 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <permission id='note1' type='verification'>
                  <name>Permission Test 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <permission id='note2' type='verification'>
                  <name>Permission Test 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <permission id='AN' type='verification'>
                <name>Permission Test A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
            <clause id='annex1b'>
              <permission id='Anote1' unnumbered='true' type='verification'>
                <name>Permission Test</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <permission id='Anote2' type='verification'>
                <name>Permission Test A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
          </annex>
        </iso-standard>
OUTPUT
end

        it "labels and cross-references nested requirements" do
          expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <!--
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
               -->
<?xml version='1.0'?>
<iso-standard xmlns='http://riboseinc.com/isoxml'>
  <preface>
    <foreword>
      <p>
        <xref target='N1'/>
        <xref target='N2'/>
        <xref target='N'/>
        <xref target='Q1'/>
        <xref target='R1'/>
        <xref target='AN1'/>
        <xref target='AN2'/>
        <xref target='AN'/>
        <xref target='AQ1'/>
        <xref target='AR1'/>
      </p>
    </foreword>
  </preface>
  <sections>
    <clause id='xyz'>
      <title>Preparatory</title>
      <permission id='N1'>
        <name>Permission 1</name>
        <permission id='N2' type='verification'>
          <name>Permission Test 1-1</name>
          <permission id='N'>
            <name>Permission 1-1-1</name>
          </permission>
        </permission>
        <requirement id='Q1'>
          <name>Requirement 1-1</name>
        </requirement>
        <recommendation id='R1'>
          <name>Recommendation 1-1</name>
        </recommendation>
        <permission id='N3' type='verification'>
          <name>Permission Test 1-2</name>
        </permission>
        <permission id='N4'>
          <name>Permission 1-1</name>
        </permission>
      </permission>
    </clause>
  </sections>
  <annex id='Axyz'>
    <title>Preparatory</title>
    <permission id='AN1' type='verification'>
      <name>Permission Test A.1</name>
      <permission id='AN2'>
        <name>Permission A.1-1</name>
        <permission id='AN' type='verification'>
          <name>Permission Test A.1-1-1</name>
        </permission>
      </permission>
      <requirement id='AQ1'>
        <name>Requirement A.1-1</name>
      </requirement>
      <recommendation id='AR1'>
        <name>Recommendation A.1-1</name>
      </recommendation>
      <permission id='AN3' type='verification'>
        <name>Permission Test A.1-1</name>
      </permission>
      <permission id='AN4'>
        <name>Permission A.1-2</name>
      </permission>
    </permission>
  </annex>
</iso-standard>
    OUTPUT
        end

               it "cross-references abstract tests" do
                 expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
    <!--
               <a href='#N1'>Introduction, Abstract Test 1</a>
               <a href='#N2'>Clause ii.1, Abstract Test (??)</a>
               <a href='#N'>Clause 1, Abstract Test 2</a>
               <a href='#note1'>Clause 3.1, Abstract Test 3</a>
               <a href='#note2'>Clause 3.1, Abstract Test 4</a>
               <a href='#AN'>Annex A.1, Abstract Test A.1</a>
               <a href='#Anote1'>Annex A.2, Abstract Test (??)</a>
               <a href='#Anote2'>Annex A.2, Abstract Test A.2</a>
               -->
               <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <permission id='N1' type='abstracttest'>
                <name>Abstract Test 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <clause id='xyz'>
                <title>Preparatory</title>
                <permission id='N2' unnumbered='true' type='abstracttest'>
                  <name>Abstract Test</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <permission id='N' type='abstracttest'>
                <name>Abstract Test 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <permission id='note1' type='abstracttest'>
                  <name>Abstract Test 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <permission id='note2' type='abstracttest'>
                  <name>Abstract Test 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <permission id='AN' type='abstracttest'>
                <name>Abstract Test A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
            <clause id='annex1b'>
              <permission id='Anote1' unnumbered='true' type='abstracttest'>
                <name>Abstract Test</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <permission id='Anote2' type='abstracttest'>
                <name>Abstract Test A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
          </annex>
        </iso-standard>
OUTPUT
               end

               it "cross-references conformance classes" do
                 expect(xmlpp(IsoDoc::Ogc::PresentationXMLConvert.new({}).convert("test", <<~"INPUT", true).gsub(%r{^.*<body}m, "<body").gsub(%r{</body>.*}m, "</body>"))).to be_equivalent_to xmlpp(<<~"OUTPUT")
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
    <clause id="scope"><title>Scope</title>
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
             <!--
               <a href='#N1'>Introduction, Conformance Class 1</a>
               <a href='#N2'>Clause ii.1, Conformance Class (??)</a>
               <a href='#N'>Clause 1, Conformance Class 2</a>
               <a href='#note1'>Clause 3.1, Conformance Class 3</a>
               <a href='#note2'>Clause 3.1, Conformance Class 4</a>
               <a href='#AN'>Annex A.1, Conformance Class A.1</a>
               <a href='#Anote1'>Annex A.2, Conformance Class (??)</a>
               <a href='#Anote2'>Annex A.2, Conformance Class A.2</a>
               -->
                <?xml version='1.0'?>
        <iso-standard xmlns='http://riboseinc.com/isoxml'>
          <preface>
            <foreword>
              <p>
                <xref target='N1'/>
                <xref target='N2'/>
                <xref target='N'/>
                <xref target='note1'/>
                <xref target='note2'/>
                <xref target='AN'/>
                <xref target='Anote1'/>
                <xref target='Anote2'/>
              </p>
            </foreword>
            <introduction id='intro'>
              <permission id='N1' type='conformanceclass'>
                <name>Conformance Class 1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <clause id='xyz'>
                <title>Preparatory</title>
                <permission id='N2' unnumbered='true' type='conformanceclass'>
                  <name>Conformance Class</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
              </clause>
            </introduction>
          </preface>
          <sections>
            <clause id='scope'>
              <title>Scope</title>
              <permission id='N' type='conformanceclass'>
                <name>Conformance Class 2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <p>
                <xref target='N'/>
              </p>
            </clause>
            <terms id='terms'/>
            <clause id='widgets'>
              <title>Widgets</title>
              <clause id='widgets1'>
                <permission id='note1' type='conformanceclass'>
                  <name>Conformance Class 3</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <permission id='note2' type='conformanceclass'>
                  <name>Conformance Class 4</name>
                  <stem type='AsciiMath'>r = 1 %</stem>
                </permission>
                <p>
                  <xref target='note1'/>
                  <xref target='note2'/>
                </p>
              </clause>
            </clause>
          </sections>
          <annex id='annex1'>
            <clause id='annex1a'>
              <permission id='AN' type='conformanceclass'>
                <name>Conformance Class A.1</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
            <clause id='annex1b'>
              <permission id='Anote1' unnumbered='true' type='conformanceclass'>
                <name>Conformance Class</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
              <permission id='Anote2' type='conformanceclass'>
                <name>Conformance Class A.2</name>
                <stem type='AsciiMath'>r = 1 %</stem>
              </permission>
            </clause>
          </annex>
        </iso-standard>
OUTPUT

end
               end
