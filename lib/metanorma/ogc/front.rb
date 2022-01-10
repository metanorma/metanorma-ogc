require "asciidoctor"
require "metanorma/standoc/converter"
require "fileutils"

module Metanorma
  module Ogc
    class Converter < Standoc::Converter
      def metadata_author(node, xml)
        corporate_author(node, xml)
        personal_author(node, xml)
      end

      def corporate_author(node, xml)
        return unless node.attr("submitting-organizations")

        csv_split(HTMLEntities.new
          .decode(node.attr("submitting-organizations")), ";")&.each do |org|
          xml.contributor do |c|
            c.role **{ type: "author" }
            c.organization do |a|
              a.name org
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

      def ogc_editor(node, xml)
        return unless node.attr("editor")

        xml.contributor do |c|
          c.role **{ type: "editor" }
          c.person do |p|
            p.name do |n|
              n.completename node.attr("editor")
            end
          end
        end
      end

      def personal_author1(node, xml, suffix)
        xml.contributor do |c|
          c.role **{ type: node&.attr("role#{suffix}")&.downcase || "editor" }
          c.person do |p|
            p.name do |n|
              if node.attr("fullname#{suffix}")
                n.completename node.attr("fullname#{suffix}")
              else
                n.forename node.attr("givenname#{suffix}")
                n.surname node.attr("surname#{suffix}")
              end
            end
          end
        end
      end

      def default_publisher
        "Open Geospatial Consortium"
      end

      def metadata_committee(node, xml)
        return unless node.attr("committee")

        xml.editorialgroup do |a|
          a.committee(node.attr("committee") || "technical")
          node.attr("subcommittee") and
            a.subcommittee(node.attr("subcommittee"),
                           **attr_code(type: node.attr("subcommittee-type"),
                                       number: node.attr("subcommittee-number")))
          (node.attr("workgroup") || node.attr("workinggroup")) and
            a.workgroup(node.attr("workgroup") || node.attr("workinggroup"),
                        **attr_code(type: node.attr("workgroup-type"),
                                    number: node.attr("workgroup-number")))
        end
      end

      def externalid(node)
        return node.attr("external-id") if node.attr("external-id")

        d = doctype(node)
        a = node.attr("abbrev")
        return unless d && a

        url = "http://www.opengis.net/doc/#{IsoDoc::Ogc::DOCTYPE_ABBR[d]}/#{a}"
        v = (node.attr("edition") || node.attr("version")) and url += "/#{v}"
        url
      end

      def metadata_id(node, xml)
        e = externalid(node) and xml.docidentifier e, **{ type: "ogc-external" }
        node.attr("referenceurlid") and
          xml.docidentifier externalurl(node), **{ type: "ogc-external" }
        docnumber = node.attr("docnumber") || node.attr("docreference")
        if docnumber
          xml.docidentifier docnumber, **{ type: "ogc-internal" }
          xml.docnumber docnumber
        end
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
        node.attr("previous-uri") && xml.uri(node.attr("previous-uri"),
                                             type: "previous")
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
          xml.date **{ type: metanormaname } do |d|
            d.on node.attr(ogcname)
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
            @log.add("Document Attributes", nil,
                     "'#{s}' is not a permitted subtype of Standard: "\
                     "reverting to 'implementation'")
            s = "implementation"
          end
        when "best-practice"
          unless %w{general encoding extension profile
                    profile-with-extension}.include? s
            @log.add("Document Attributes", nil,
                     "'#{s}' is not a permitted subtype of Standard: "\
                     "reverting to 'implementation'")
            s = "general"
          end
        end
        s and xml.subdoctype s
      end

      def title(node, xml)
        super
        at = { format: "text/plain", type: "abbrev" }
        a = node.attr("abbrev") and
          xml.title a, **attr_code(at)
      end

      def metadata_ext(node, xml)
        metadata_doctype(node, xml)
        metadata_subdoctype(node, xml)
        metadata_committee(node, xml)
      end
    end
  end
end
