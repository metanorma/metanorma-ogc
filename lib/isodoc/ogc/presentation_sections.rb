module IsoDoc
  module Ogc
    class PresentationXMLConvert < IsoDoc::PresentationXMLConvert
      def middle_title(docxml); end

      def preface_rearrange(doc)
        [
          ["//preface/abstract",
           %w(executivesummary foreword introduction clause acknowledgements)],
          ["//preface/executivesummary",
           %w(foreword introduction clause acknowledgements)],
          ["//preface/foreword",
           %w(introduction clause acknowledgements)],
          ["//preface/introduction",
           %w(clause acknowledgements)],
          ["//preface/acknowledgements", %w()],
        ].each do |x|
          preface_move(doc.xpath(ns(x[0])), x[1], doc)
        end
        insert_preface_sections(doc)
      end

      def section(docxml)
        dochistory_insert(docxml)
        @xrefs.parse docxml
        super
      end

      def insert_preface_sections(doc)
        preface_insert(doc.at(ns("//preface//clause[@type = 'submitters' or " \
                                 "@type = 'contributors']")),
                       submit_orgs_append_pt(doc), doc)
        insert_submitting_orgs(doc)
        preface_insert(doc.at(ns("//preface/clause[@type = 'security']")),
                       submit_orgs_append_pt(doc), doc)
        insert_keywords(doc)
      end

      def dochistory_insert(docxml)
        updates = docxml.xpath(ns(UPDATE_RELATIONS))
        updates.empty? and return
        fwd = annex_insert_point(docxml)
        generate_dochistory(updates, fwd)
      end

      def annex_insert_point(docxml)
        docxml.at(ns("//annex[last()]")) || docxml.at(ns("//sections"))
      end

      def generate_dochistory(updates, pref)
        ret = updates.map { |u| generate_dochistory_row(u) }.flatten.join("\n")
        pref.next = <<~XML
          <annex #{add_id_text} obligation='informative'>
          <title #{add_id_text}>#{@i18n.dochistory}</title>
          <table unnumbered="true" #{add_id_text}><thead>
          <tr #{add_id_text}><th #{add_id_text}>Date</th><th #{add_id_text}>Release</th><th #{add_id_text}>Author</th>
            <th #{add_id_text}>Paragraph Modified</th><th #{add_id_text}>Description</th></tr>
          </thead><tbody>#{ret}</tbody></table></annex>
        XML
      end

      def generate_dochistory_row(item)
        e = item.at(ns("./edition")) || item.at(ns("./version/draft"))
        date = dochistory_date(item)
        c = dochistory_contributors(item)
        l = dochistory_location(item)
        desc = dochistory_description(item)
        <<~XML
          <tr #{add_id_text}><td #{add_id_text}>#{date}</td><td #{add_id_text}>#{e&.text}</td><td #{add_id_text}>#{c}</td>
            <td #{add_id_text}>#{l}</td><td #{add_id_text}>#{desc}</td></tr>
        XML
      end

      def dochistory_date(item)
        d = item.at(ns("./date[@type = 'updated']")) ||
          item.at(ns("./date[@type = 'published']")) ||
          item.at(ns("./date[@type = 'issued']")) or return ""
        d.text.strip
      end

      def dochistory_contributors(item)
        item.xpath(ns("./contributor")).map do |c|
          dochistory_contributor(c)
        end.join(", ")
      end

      def dochistory_contributor(contrib)
        ret = contrib.at("./organization/subdivision") ||
          contrib.at("./organization/name") ||
          contrib.at("./person/name/abbreviation") ||
          contrib.at("./person/name/completename")
        ret and return ret.text
        format_personalname(contrib)
      end

      def format_personalname(contrib)
        Relaton::Render::Ogc::General
          .new(template: { book: "{{ creatornames }}" })
          .render("<bibitem type='book'>#{contrib.to_xml}</bibitem>",
                  embedded: true)
      end

      def dochistory_description(item)
        d = item.xpath(ns("./amend/description"))
        d.empty? and return ""
        d.map { |d1| semx_fmt_dup(d1).to_xml }.join("\n")
      end

      def dochistory_location(item)
        t = item.at(ns("./amend/location")) or return "All"
        xpath = "./amend/location/locality | ./amend/location/localityStack"
        r = eref_localities(item.xpath(ns(xpath)), nil, t)
        r.sub!(/^, /, "")
        r == @i18n.wholeoftext and r = "All"
        r
      end

      def preface_init_insert_pt(docxml)
        docxml.at(ns("//preface")) ||
          docxml.at(ns("//sections"))
            .add_previous_sibling("<preface> </preface>").first
      end

      def preface_insert(clause, after, docxml)
        clause or return
        clause.remove
        if after then after.next = clause
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(clause)
        end
      end

      def submit_orgs_append_pt(docxml)
        docxml.at(ns("//foreword")) ||
          docxml.at(ns("//preface/clause[@type = 'keywords']")) ||
          docxml.at(ns("//preface/abstract")) ||
          docxml.at(ns("//preface/executivesummary"))
      end

      def insert_submitting_orgs(docxml)
        orgs = docxml.xpath(submittingorgs_path)
          .each_with_object([]) { |org, m| m << org.text }
        orgs.empty? and return
        if a = submit_orgs_append_pt(docxml)
          a.next = submitting_orgs_clause(orgs)
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(submitting_orgs_clause(orgs))
        end
      end

      def submitting_orgs_clause(orgs)
        <<~SUBMITTING
          <clause #{add_id_text} type="submitting_orgs">
          <title #{add_id_text}>Submitting Organizations</title>
          <p>The following organizations submitted this Document to the Open Geospatial Consortium (OGC):</p>
           <ul #{add_id_text}>#{orgs.map { |m| "<li #{add_id_text}>#{m}</li>" }.join("\n")}</ul>
           </clause>
        SUBMITTING
      end

      def keyword_clause(kwords)
        <<~KEYWORDS
          <clause #{add_id_text} type="keywords">
          <title #{add_id_text}>Keywords</title>
          <p>The following are keywords to be used by search engines and document catalogues.</p>
          <p>#{kwords.join(', ')}</p></clause>
        KEYWORDS
      end

      def insert_keywords(docxml)
        kw = @meta.get[:keywords]
        kw.empty? and return
        if abstract =
             docxml.at(ns("//preface/executivesummary")) ||
             docxml.at(ns("//preface/abstract"))
          abstract.next = keyword_clause(kw)
        else
          preface_init_insert_pt(docxml)&.children&.first
            &.add_previous_sibling(keyword_clause(kw))
        end
      end

      def annex_delim(_elem)
        "<br/>"
      end

      def clause1(elem)
        elem.name == "terms" && elem.parent.name == "annex" &&
          elem.parent.xpath(ns("./terms")).size == 1 and return
        elem.name == "clause" && elem["type"] == "toc" and return
        super
      end
    end
  end
end
