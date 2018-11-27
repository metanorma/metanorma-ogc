require "asciidoctor"
require "asciidoctor/standoc/converter"
require "fileutils"

module Asciidoctor
  module Ogc

    # A {Converter} implementation that generates RSD output, and a document
    # schema encapsulation of the document for validation
    #
    class Converter < Standoc::Converter

      def metadata_author(node, xml)
        corporate_author(node, xml)
        personal_author(node, xml)
      end

      def corporate_author(node, xml)
        return unless node.attr("submitting-organizations")
        node.attr("submitting-organizations").split(/;[ ]*/).each do |org|
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
          c.role **{ type: node.attr("role#{suffix}").downcase || "author" }
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

      def metadata_publisher(node, xml)
        xml.contributor do |c|
          c.role **{ type: "publisher" }
          c.organization do |a|
            a.name Metanorma::Ogc::ORGANIZATION_NAME_SHORT
          end
        end
      end

      def metadata_committee(node, xml)
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

      def metadata_status(node, xml)
        status = node.attr("status") || "published"
        xml.status(**{ format: "plain" }) { |s| s << status }
      end

      def metadata_id(node, xml)
        node.attr("external-id") and
          xml.docidentifier node.attr("external-id"), **{ type: "ogc-external" }
        node.attr("referenceurlid") and
          xml.docidentifier externalurl(node), **{ type: "ogc-external" }
        docnumber = node.attr("docnumber") || node.attr("docreference")
        if docnumber
          xml.docidentifier docnumber, **{ type: "ogc-internal" }
          xml.docnumber docnumber
        end
      end

      def externalurl(node)
        if node.attr("doctype") == "engineering-report"
          "http://www.opengis.net/doc/PER/t14-#{node.attr('referenceurlid')}"
        else
          node.attr('referenceurlid')
        end
      end

      def metadata_source(node, xml)
        super
        node.attr("previous-uri") && xml.source(node.attr("previous-uri"), type: "previous")
      end

      def metadata_copyright(node, xml)
        from = node.attr("copyright-year") || node.attr("copyrightyear") || Date.today.year
        xml.copyright do |c|
          c.from from
          c.owner do |owner|
            owner.organization do |o|
              o.name Metanorma::Ogc::ORGANIZATION_NAME_SHORT
            end
          end
        end
      end

      def metadata_keywords(node, xml)
        return unless node.attr("keywords")
        node.attr("keywords").split(/,[ ]*/).each do |kw|
          xml.keyword kw
        end
      end

      def metadata_date(node, xml)
        super
        ogc_date(node, xml, "submissiondate", "received" )
        ogc_date(node, xml, "publicationdate", "published" )
        ogc_date(node, xml, "approvaldate", "issued" )
      end

      def ogc_date(node, xml, ogcname, metanormaname)
        if node.attr(ogcname)
          xml.date **{ type: metanormaname } do |d|
            d.on node.attr(ogcname)
          end
        end
      end

      def metadata(node, xml)
        super
        metadata_keywords(node, xml)
      end
    end
  end
end
