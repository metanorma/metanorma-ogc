require "asciidoctor"
require "asciidoctor/standoc/converter"
require "fileutils"

module Asciidoctor
  module Ogc

    # A {Converter} implementation that generates RSD output, and a document
    # schema encapsulation of the document for validation
    #
    class Converter < Standoc::Converter

      register_for "ogc"

      def metadata_author(node, xml)
        corporate_author(xml)
        personal_author(node, xml)
      end

      def corporate_author(xml)
        xml.contributor do |c|
          c.role **{ type: "author" }
          c.organization do |a|
            a.name Metanorma::Ogc::ORGANIZATION_NAME_SHORT
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
          c.role **{ type: node.attr("role#{suffix}") || "author" }
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
      end

      # ignore, we generate ToC outside of asciidoctor
      def toc(value)
      end

      def title_validate(root)
        nil
      end

      def makexml(node)
        result = ["<?xml version='1.0' encoding='UTF-8'?>\n<ogc-standard>"]
        @draft = node.attributes.has_key?("draft")
        result << noko { |ixml| front node, ixml }
        result << noko { |ixml| middle node, ixml }
        result << "</ogc-standard>"
        result = textcleanup(result.flatten * "\n")
        ret1 = cleanup(Nokogiri::XML(result))
        validate(ret1)
        ret1.root.add_namespace(nil, Metanorma::Ogc::DOCUMENT_NAMESPACE)
        ret1
      end

      def doctype(node)
        d = node.attr("doctype")
        unless %w{standard standard-with-suite abstract-specification
        community-standard profile best-practice 
        engineering-report discussion-paper reference-model user-guide
        policy guide amendment technical-corrigendum administrative}.include? d
          warn "#{d} is not a legal document type: reverting to 'standard'"
          d = "standard"
        end
        d
      end

      def document(node)
        init(node)
        ret1 = makexml(node)
        ret = ret1.to_xml(indent: 2)
        unless node.attr("nodoc") || !node.attr("docfile")
          filename = node.attr("docfile").gsub(/\.adoc/, ".xml").
            gsub(%r{^.*/}, "")
          File.open(filename, "w") { |f| f.write(ret) }
          html_converter(node).convert filename unless node.attr("nodoc")
          word_converter(node).convert filename unless node.attr("nodoc")
          pdf_converter(node).convert filename unless node.attr("nodoc")
        end
        @files_to_delete.each { |f| FileUtils.rm f }
        ret
      end

      def validate(doc)
        content_validate(doc)
        schema_validate(formattedstr_strip(doc.dup),
                        File.join(File.dirname(__FILE__), "ogc.rng"))
      end

      def literal(node)
        noko do |xml|
          xml.figure **id_attr(node) do |f|
            figure_title(node, f)
            f.pre node.lines.join("\n")
          end
        end
      end

      def sections_cleanup(x)
        super
        x.xpath("//*[@inline-header]").each do |h|
          h.delete("inline-header")
        end
      end

      def style(n, t)
        return
      end

      def html_converter(node)
        IsoDoc::Ogc::HtmlConvert.new(html_extract_attributes(node))
      end

      def pdf_converter(node)
        IsoDoc::Ogc::PdfConvert.new(html_extract_attributes(node))
      end

      def word_converter(node)
        IsoDoc::Ogc::WordConvert.new(doc_extract_attributes(node))
      end
    end
  end
end
