require "asciidoctor"
require "metanorma/standoc/converter"
require "fileutils"

module Metanorma
  module Ogc
    class Converter < Standoc::Converter
      def org_author(node, xml)
        node.attr("submitting-organizations") or return
        csv_split(@c.decode(node.attr("submitting-organizations")),
                  ";")&.each do |org|
          xml.contributor do |c|
            c.role type: "author"
            c.organization do |a|
              add_noko_elem(a, "name", org)
            end
          end
        end
      end

      def personal_author(node, xml)
        ogc_editor(node, xml)
        if node.attr("fullname") || node.attr("surname")
          personal_author1(node, xml, "")
        end
        i = 2
        while node.attr("fullname_#{i}") || node.attr("surname_#{i}")
          personal_author1(node, xml, "_#{i}")
          i += 1
        end
      end

      def personal_role(node, contrib, suffix)
        type = node.attr("role#{suffix}")&.downcase || "editor"
        if type == "contributor"
          contrib.role type: "author" do |r|
            add_noko_elem(r, "description", type)
          end
        else contrib.role type: type
        end
      end

      def ogc_editor(node, xml)
        node.attr("editor") or return
        xml.contributor do |c|
          c.role type: "editor"
          c.person do |p|
            p.name do |n|
              add_noko_elem(n, "completename", node.attr("editor"))
            end
          end
        end
      end

      def personal_author1(node, xml, suffix)
        xml.contributor do |c|
          personal_role(node, c, suffix)
          c.person do |p|
            p.name do |n|
              personal_author_name(node, n, suffix)
            end
          end
        end
      end

      def personal_author_name(node, xml, suffix)
        if node.attr("fullname#{suffix}")
          add_noko_elem(xml, "completename", node.attr("fullname#{suffix}"))
        else
          add_noko_elem(xml, "forename", node.attr("givenname#{suffix}"))
          add_noko_elem(xml, "surname", node.attr("surname#{suffix}"))
        end
      end

      def default_publisher
        "OGC"
      end

      def org_abbrev
        { "Open Geospatial Consortium" => "OGC" }
      end

      def metadata_committee_types(_node)
        %w(committee subcommittee workgroup)
      end

      def metadata_committee_prep(node)
        node.attr("committee") or node.set_attribute("committee", "technical")
        a = node.attr("workinggroup") and
          node.set_attribute("workgroup", a)
        true
      end

      def externalid(node)
        i = node.attr("external-id") and return i
        d = doctype(node)
        a = node.attr("abbrev")
        d && a or return
        url = "http://www.opengis.net/doc/#{IsoDoc::Ogc::DOCTYPE_ABBR[d]}/#{a}"
        v = node.attr("edition") || node.attr("version") and url += "/#{v}"
        url
      end

      def metadata_id(node, xml)
        add_noko_elem(xml, "docidentifier", externalid(node),
                      type: "ogc-external")
        node.attr("referenceurlid") and
          add_noko_elem(xml, "docidentifier", externalurl(node),
                        type: "ogc-external")
        id = node.attr("docidentifier") || node.attr("docnumber") ||
          node.attr("docreference")
        add_noko_elem(xml, "docidentifier", id, type: "ogc-internal",
                                                primary: "true")
      end

      def externalurl(node)
        if doctype(node) == "engineering-report"
          "http://www.opengis.net/doc/PER/t14-#{node.attr('referenceurlid')}"
        else
          node.attr("referenceurlid")
        end
      end

      def metadata_source(node, xml)
        super
        add_noko_elem(xml, "uri", node.attr("previous-uri"), type: "previous")
      end

      def metadata_copyright(node, xml)
        node.attr("copyrightyear") and
          node.set_attr("copyright-year", node.attr("copyrightyear"))
        super
      end

      def metadata_date(node, xml)
        super
        ogc_date(node, xml, "submissiondate", "received")
        ogc_date(node, xml, "publicationdate", "published")
        ogc_date(node, xml, "approvaldate", "issued")
      end

      def ogc_date(node, xml, ogcname, metanormaname)
        if node.attr(ogcname)
          xml.date type: metanormaname do |d|
            add_noko_elem(d, "on", node.attr(ogcname))
          end
        end
      end

      def metadata_version(node, xml)
        node.attr("version") and
          node.set_attr("edition", node.attr("version"), false)
        super
      end

      def metadata_subdoctype(node, xml)
        s = node.attr("docsubtype")
        s1 = ::IsoDoc::Ogc::DOCSUBTYPE_ABBR.invert[s] and s = s1
        case doctype(node)
        when "standard"
          unless %w{conceptual-model conceptual-model-and-encoding
                    conceptual-model-and-implementation encoding extension
                    implementation profile profile-with-extension}.include? s
            @log.add("OGC_17", nil, params: [s])
            s = "implementation"
          end
        when "best-practice"
          unless %w{general encoding extension profile
                    profile-with-extension}.include? s
            @log.add("OGC_18", nil, params: [s])
            s = "general"
          end
        end
        s && !s.empty? and xml.subdoctype s
      end

      def title(node, xml)
        super
        content = node.attr("abbrev") and
          add_title_xml(xml, content, @lang, "abbrev")
      end
    end
  end
end
