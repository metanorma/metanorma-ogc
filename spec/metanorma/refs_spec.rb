require "spec_helper"
require "fileutils"

RSpec.describe Metanorma::Ogc do
  before do
    # Force to download Relaton index file
    allow_any_instance_of(Relaton::Index::Type).to receive(:actual?)
      .and_return(false)
    allow_any_instance_of(Relaton::Index::FileIO).to receive(:check_file)
      .and_return(nil)
  end

  it "sort OGC and ISO references in Bibliography" do
    VCR.use_cassette "sort" do
      input = <<~INPUT
        #{ASCIIDOC_BLANK_HDR}

        [bibliography]
        == Bibliography

        * [[[iso1,ISO 8000-110]]]
        * [[[iso2,ISO 8000-61]]]
        * [[[ogc1,OGC 17-080r2]]], _OGC Zzzyxy_
        * [[[iso3,ISO 8000-8]]]
        * [[[ref1,REF]]] s:surname[Wozniak], s:initials[S.] & s:givenname[Steve] s:surname[Jobs]. s:pubyear[1996]. s:title[_Work_]. In s:surname.editor[Gates], s:initials.editor[W. H], Collected Essays. s:pubplace[Geneva]: s:publisher[Some Standardization Organization]. s:uri.citation[http://www.example.com]. s:type[inbook]
        * [[[ogc2,OGC 11-165r2]]], _Present_
        * [[[iso4,ISO 9]]]
        * [[[ref2,ABC]]] s:surname[Wozniak], Jobs:initials[S.] & s:givenname[Wozniak] s:surname[Jobs]. s:pubyear[1996]. s:title[_Work_]. In s:surname.editor[Gates], s:initials.editor[W. H], Collected Essays. s:pubplace[Geneva]: s:publisher[Some Standardization Organization]. s:uri.citation[http://www.example.com]. s:type[inbook]
        * [[[ogc3,OGC 11-157]]], _Absent_
      INPUT
      out = Nokogiri::XML(Asciidoctor.convert(input, *OPTIONS))
      warn out.to_xml
      expect(out.xpath("//xmlns:references/xmlns:bibitem/@anchor")
        .map(&:value))
        .to be_equivalent_to ["ogc1", "ogc3", "ogc2", "iso4", "iso3", "iso2",
                              "iso1", "ref2", "ref1"]
    end
  end
end
