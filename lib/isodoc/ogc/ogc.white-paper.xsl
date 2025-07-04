<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:mn="https://www.metanorma.org/ns/standoc" xmlns:mnx="https://www.metanorma.org/ns/xslt" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:redirect="http://xml.apache.org/xalan/redirect" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java redirect" extension-element-prefixes="redirect" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:key name="kfn" match="mn:fn[not(ancestor::*[self::mn:table or self::mn:figure or self::mn:localized-strings] and not(ancestor::mn:fmt-name))]" use="@reference"/>

	<xsl:variable name="debug">false</xsl:variable>

	<xsl:variable name="docLatestDate_">
		<xsl:for-each select="/*/mn:bibdata/mn:date[normalize-space(mn:on) != '']">
			<xsl:sort order="descending" select="mn:on"/>
			<xsl:if test="position() = 1"><xsl:value-of select="translate(mn:on, '-', '')"/></xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="docLatestDate" select="normalize-space($docLatestDate_)"/>

	<xsl:variable name="selectedStyle_">
		<xsl:choose>
			<xsl:when test="$docLatestDate &gt;= '20211108'">2</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="selectedStyle" select="normalize-space($selectedStyle_)"/>

	<xsl:variable name="color">rgb(0, 51, 102)</xsl:variable>

	<xsl:variable name="color_text_title" select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'color-text-title']/mn:value"/>
	<xsl:variable name="color_table_header_row" select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'color-background-table-header']/mn:value"/>

	<xsl:attribute-set name="title-toc-style">
		<xsl:attribute name="font-size">26pt</xsl:attribute>
		<xsl:attribute name="border-bottom">2pt solid rgb(21, 43, 77)</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="title-depth1-style" use-attribute-sets="title-toc-style">
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="color">rgb(59, 56, 56)</xsl:attribute>
		<xsl:attribute name="margin-top">18pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">18pt</xsl:attribute>
		<xsl:attribute name="line-height">110%</xsl:attribute>
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="title-depth2-style">
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="font-size">18pt</xsl:attribute>
		<xsl:attribute name="color">rgb(21, 43, 77)</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="line-height">110%</xsl:attribute>
		<xsl:attribute name="role">H2</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="title-depth3-style">
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">rgb(21, 43, 77)</xsl:attribute>
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="role">H3</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="empty-style">
	</xsl:attribute-set>

	<xsl:variable name="contents_">
		<mnx:contents>
			<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>

			<xsl:call-template name="processMainSectionsDefault_Contents"/>
			<xsl:apply-templates select="//mn:indexsect" mode="contents"/>

			<xsl:call-template name="processTablesFigures_Contents"/>
		</mnx:contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>

	<xsl:template name="layout-master-set">
		<fo:layout-master-set>

			<!-- Document pages -->
			<fo:simple-page-master master-name="document" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm" precedence="true"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm" precedence="true"/>
				<fo:region-start region-name="left" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>

			<fo:simple-page-master master-name="document-landscape" page-width="{$pageHeight}mm" page-height="{$pageWidth}mm">
				<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
				<fo:region-before region-name="header" extent="{$marginTop}mm" precedence="true"/>
				<fo:region-after region-name="footer" extent="{$marginBottom}mm" precedence="true"/>
				<fo:region-start region-name="left" extent="{$marginLeftRight1}mm"/>
				<fo:region-end region-name="right" extent="{$marginLeftRight2}mm"/>
			</fo:simple-page-master>

		</fo:layout-master-set>
	</xsl:template> <!-- END: layout-master-set -->

	<xsl:template match="/">

			<fo:root xml:lang="{$lang}">
				<xsl:variable name="root-style">
					<root-style xsl:use-attribute-sets="root-style"/>
				</xsl:variable>
				<xsl:call-template name="insertRootStyle">
					<xsl:with-param name="root-style" select="$root-style"/>
				</xsl:call-template>

				<xsl:call-template name="layout-master-set"/>

				<fo:declarations>
					<xsl:call-template name="addPDFUAmeta"/>
				</fo:declarations>

				<xsl:call-template name="addBookmarks">
					<xsl:with-param name="contents" select="$contents"/>
					<xsl:with-param name="contents_addon">
						<xsl:variable name="list_of_tables_figures_">
							<xsl:for-each select="//mn:table[@id and mn:fmt-name] | //mn:figure[@id and mn:fmt-name]">
								<table_figure id="{@id}"><xsl:apply-templates select="mn:fmt-name" mode="bookmarks"/></table_figure>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="list_of_tables_figures" select="xalan:nodeset($list_of_tables_figures_)"/>

						<xsl:if test="$list_of_tables_figures/table_figure">
							<fo:bookmark internal-destination="empty_bookmark">
								<fo:bookmark-title>—————</fo:bookmark-title>
							</fo:bookmark>
						</xsl:if>

						<xsl:if test="$list_of_tables_figures//table_figure">
							<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
								<fo:bookmark-title>
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">table_of_figures</xsl:with-param>
									</xsl:call-template>
								</fo:bookmark-title>
								<xsl:for-each select="$list_of_tables_figures//table_figure">
									<fo:bookmark internal-destination="{@id}">
										<fo:bookmark-title><xsl:value-of select="."/></fo:bookmark-title>
									</fo:bookmark>
								</xsl:for-each>
							</fo:bookmark>
						</xsl:if>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="cover-page"/>

				<xsl:variable name="updated_xml">
					<xsl:call-template name="updateXML"/>
					<!-- <xsl:copy-of select="."/> -->
				</xsl:variable>

				<xsl:if test="$debug = 'true'">
					<redirect:write file="contents_.xml"> <!-- {java:getTime(java:java.util.Date.new())} -->
						<xsl:copy-of select="$contents"/>
					</redirect:write>
				</xsl:if>

				<xsl:for-each select="xalan:nodeset($updated_xml)/*">

					<xsl:variable name="updated_xml_with_pages">
						<xsl:call-template name="processPrefaceAndMainSectionsOGC_items"/>
					</xsl:variable>

					<xsl:for-each select="xalan:nodeset($updated_xml_with_pages)"> <!-- set context to preface/sections -->

						<xsl:for-each select=".//mn:page_sequence[parent::*[self::mn:preface or self::mn:boilerplate]][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">

							<!-- Copyright, Content, Foreword, etc. pages -->
							<fo:page-sequence master-reference="document" force-page-count="no-force">

								<xsl:attribute name="master-reference">
									<xsl:text>document</xsl:text>
									<xsl:call-template name="getPageSequenceOrientation"/>
								</xsl:attribute>

								<xsl:call-template name="insertHeaderFooter"/>
								<fo:flow flow-name="xsl-region-body">

									<!-- <xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:license-statement"/>
									<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:feedback-statement"/> -->

									<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
									<!-- <xsl:for-each select="/*/mn:preface/*[not(local-name() = 'note' or local-name() = 'admonition')]">
										<xsl:sort select="@displayorder" data-type="number"/>
										
										<xsl:if test="local-name() = 'abstract' or local-name() = 'foreword' or local-name() = 'introduction' or (local-name() = 'clause' and @type = 'toc')">
											<fo:block break-after="page"/>
										</xsl:if>
										
										<xsl:apply-templates select="."/>
									</xsl:for-each> -->

									<xsl:apply-templates/>

								</fo:flow>
							</fo:page-sequence>
						</xsl:for-each>

						<xsl:for-each select=".//mn:page_sequence[not(parent::*[self::mn:preface or self::mn:boilerplate])][normalize-space() != '' or .//mn:image or .//*[local-name() = 'svg']]">

							<!-- Document Pages -->
							<fo:page-sequence master-reference="document" format="1" force-page-count="no-force">

								<xsl:attribute name="master-reference">
									<xsl:text>document</xsl:text>
									<xsl:call-template name="getPageSequenceOrientation"/>
								</xsl:attribute>

								<xsl:if test="position() = 1">
									<xsl:attribute name="initial-page-number">1</xsl:attribute>
								</xsl:if>

								<xsl:call-template name="insertHeaderFooter"/>

								<fo:flow flow-name="xsl-region-body">

									<fo:block line-height="125%">

										<!-- <xsl:call-template name="processMainSectionsDefault"/> -->
										<xsl:apply-templates/>

									</fo:block>
								</fo:flow>
							</fo:page-sequence>

							<!-- End Document Pages -->
						</xsl:for-each>
					</xsl:for-each>
				</xsl:for-each>

			</fo:root>

	</xsl:template>

	<xsl:template name="cover-page">
		<!-- Cover Page -->
		<fo:page-sequence master-reference="document" force-page-count="no-force">
			<xsl:call-template name="insertHeaderFooter"/>
			<fo:flow flow-name="xsl-region-body">

				<fo:block-container margin-left="-12mm" margin-right="-9mm">
					<fo:block-container margin-left="0mm" margin-right="0mm">
						<fo:block font-size="36pt" background-color="{$color}" color="white" margin-left="2.5mm" padding-top="1mm" padding-left="1mm" role="H1">
							<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:title/node()"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>

				<!-- <fo:block font-family="Lato" font-weight="300" font-size="14pt" font-style="italic" margin-top="6pt" color="rgb(21, 43, 77)">
					<xsl:text>Additional context, inspirational quote, etc. fits into this subheading area</xsl:text>
				</fo:block> -->

				<fo:block text-align="right" font-size="10pt" margin-top="12pt" margin-bottom="24pt">
					<fo:block margin-top="6pt">Submission Date: <xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'received']/mn:on"/></fo:block>
					<fo:block margin-top="6pt">Approval Date: <xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'issued']/mn:on"/></fo:block>
					<fo:block margin-top="6pt">Publication Date: <xsl:value-of select="/mn:metanorma/mn:bibdata/mn:date[@type = 'published']/mn:on"/></fo:block>
					<fo:block margin-top="6pt">External identifier of this OGC® document: <xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docidentifier[@type = 'ogc-external']"/></fo:block>
					<fo:block margin-top="6pt">Internal reference number of this OGC® document: <xsl:value-of select="/mn:metanorma/mn:bibdata/mn:docnumber"/></fo:block>

					<xsl:variable name="url" select="/mn:metanorma/mn:bibdata/mn:uri"/>
					<xsl:if test="normalize-space($url) != ''">
						<fo:block margin-top="6pt">URL for this OGC® document: <xsl:value-of select="$url"/></fo:block>
					</xsl:if>

					<xsl:apply-templates select="/mn:metanorma/mn:bibdata/mn:edition[normalize-space(@language) = '']"/>

					<fo:block margin-top="6pt"><xsl:text>Category: </xsl:text>
						<xsl:call-template name="capitalizeWords">
							<xsl:with-param name="str" select="/mn:metanorma/mn:bibdata/mn:ext/mn:doctype"/>
						</xsl:call-template>
					</fo:block>

					<xsl:variable name="editors">
						<xsl:for-each select="/mn:metanorma/mn:bibdata/mn:contributor[mn:role/@type='editor']/mn:person/mn:name/mn:completename">
							<xsl:value-of select="."/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="normalize-space($editors) != ''">
						<fo:block margin-top="6pt">
							<!-- Editor: -->
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">editor_full</xsl:with-param>
							</xsl:call-template><xsl:text>: </xsl:text><xsl:value-of select="$editors"/>
						</fo:block>
					</xsl:if>
				</fo:block>

				<!-- absolute-position="fixed" left="20mm" top="91mm" width="175mm" -->
				<fo:block-container font-size="9pt" margin-left="-5mm" margin-right="-5mm">
					<fo:block-container margin-left="0mm" margin-right="0mm">
						<fo:block margin-top="8pt">
							<xsl:variable name="copyright_statement">
								<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:copyright-statement" mode="update_xml_step1"/>
							</xsl:variable>
							<xsl:apply-templates select="xalan:nodeset($copyright_statement)/*"/>
						</fo:block>
						<fo:block margin-top="8pt"> </fo:block>
						<fo:block margin-top="8pt">
							<xsl:variable name="legal_statement">
								<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:legal-statement" mode="update_xml_step1"/>
							</xsl:variable>
							<xsl:apply-templates select="xalan:nodeset($legal_statement)/*"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>

				<xsl:call-template name="insertLogo"/>

			</fo:flow>
		</fo:page-sequence>
		<!-- End Cover Page -->
		</xsl:template> <!-- END: cover-page -->

	<xsl:template name="processPrefaceAndMainSectionsOGC_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">

			<xsl:element name="{$root_element}" namespace="{$namespace_full}">

				<xsl:call-template name="copyCommonElements"/>

				<xsl:element name="boilerplate" namespace="{$namespace_full}"> <!-- save context element -->
					<xsl:element name="page_sequence" namespace="{$namespace_full}">
						<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:license-statement" mode="update_xml_step_move_pagebreak"/>
						<xsl:apply-templates select="/mn:metanorma/mn:boilerplate/mn:feedback-statement" mode="update_xml_step_move_pagebreak"/>
					</xsl:element>
				</xsl:element>

				<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
				<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
					<xsl:element name="page_sequence" namespace="{$namespace_full}">

						<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
							<xsl:sort select="@displayorder" data-type="number"/>

							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:for-each>
					</xsl:element>
				</xsl:element> <!-- preface -->

				<xsl:call-template name="insertMainSectionsPageSequences"/>

			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_', java:getTime(java:java.util.Date.new()), '.xml')"/>

		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<!-- TODO: instead of 
		<xsl:for-each select=".//mn:page_sequence[normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsOGC_items -->

	<xsl:template match="mn:preface//mn:clause[@type = 'toc']" priority="4">
		<fo:block break-after="page"/>
		<fo:block-container line-height="1.08" font-family="Lato">

			<xsl:apply-templates select="mn:fmt-title"/>

			<fo:block role="TOC">

				<xsl:apply-templates select="*[not(self::mn:fmt-title)]"/>

				<xsl:if test="count(*) = 1 and mn:fmt-title"> <!-- if there isn't user ToC -->

					<xsl:variable name="margin-left">3.9</xsl:variable>
					<xsl:for-each select="$contents//mnx:item[@display = 'true']">
						<fo:block margin-top="8pt" margin-bottom="5pt" margin-left="{(@level - 1) * $margin-left}mm" text-align-last="justify" role="TOCI">
							<fo:basic-link internal-destination="{@id}" fox:alt-text="{mnx:title}">
								<xsl:if test="@section != ''">
									<xsl:value-of select="@section"/><xsl:text> </xsl:text>
								</xsl:if>
								<xsl:apply-templates select="mnx:title"/>
								<fo:inline keep-together.within-line="always">
									<fo:leader leader-pattern="dots"/>
									<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
								</fo:inline>
							</fo:basic-link>
						</fo:block>
					</xsl:for-each>

					<xsl:if test="//mn:figure[@id and mn:fmt-name] or //mn:table[@id and mn:fmt-name]">
						<fo:block font-size="11pt" margin-top="8pt"> </fo:block>
						<fo:block font-size="11pt" margin-top="8pt"> </fo:block>
						<fo:block xsl:use-attribute-sets="title-toc-style">
							<!-- <xsl:text>Table of Figures</xsl:text> -->
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">table_of_figures</xsl:with-param>
							</xsl:call-template>
						</fo:block>
						<xsl:for-each select="//mn:figure[@id and mn:fmt-name] | //mn:table[@id and mn:fmt-name]">
							<fo:block margin-top="8pt" margin-bottom="5pt" text-align-last="justify" role="TOCI">
								<fo:basic-link internal-destination="{@id}" fox:alt-text="{mn:fmt-name}">
									<xsl:apply-templates select="mn:fmt-name" mode="contents"/>
									<fo:inline keep-together.within-line="always">
										<fo:leader leader-pattern="dots"/>
										<fo:page-number-citation ref-id="{@id}"/>
									</fo:inline>
								</fo:basic-link>
							</fo:block>
						</xsl:for-each>
					</xsl:if>
				</xsl:if>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:preface//mn:clause[@type = 'toc']/mn:fmt-title" priority="3">
		<fo:block xsl:use-attribute-sets="title-toc-style" role="H1">
			<!-- <xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-toc'"/>
			</xsl:call-template> -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Lato font doesn't contain 'thin space' glyph -->
	<xsl:template match="text()" priority="1">
		<xsl:value-of select="translate(., $thin_space, ' ')"/>
	</xsl:template>

	<xsl:template match="text()" priority="3" mode="contents">
		<xsl:value-of select="translate(., $thin_space, ' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text()" priority="2">
		<xsl:variable name="content">
			<xsl:call-template name="add-zero-spaces-java"/>
		</xsl:variable>
		<xsl:value-of select="translate($content, $thin_space, ' ')"/>
	</xsl:template>

	<xsl:template match="node()">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->

	<!-- element with title -->
	<xsl:template match="*[mn:title or mn:fmt-title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="mn:fmt-title/@depth | mn:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="$level &gt; $toc_level">false</xsl:when>
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="@type = 'toc'">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::mn:term">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$skip = 'false'">

			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>

			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>

			<xsl:variable name="type">
				<xsl:value-of select="local-name()"/>
			</xsl:variable>

			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
				<xsl:apply-templates mode="contents"/>
			</mnx:item>
		</xsl:if>

	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->

	<xsl:template match="/mn:metanorma/mn:bibdata/mn:uri[not(@type)]">
		<fo:block margin-bottom="12pt">
			<xsl:text>URL for this OGC® document: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>

	<xsl:template match="/mn:metanorma/mn:bibdata/mn:edition">
		<xsl:variable name="edition" select="."/>
		<xsl:if test="normalize-space($edition) != ''">
			<fo:block margin-top="6pt">
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str">
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">version</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text>: </xsl:text><xsl:value-of select="$edition"/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:feedback-statement" priority="2">
		<fo:block margin-top="12pt" margin-bottom="12pt">
			<xsl:apply-templates select="mn:clause[1]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:copyright-statement//mn:clause | mn:legal-statement//mn:clause" priority="2">
		<fo:block margin-top="6pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="/*/mn:preface/mn:page_sequence/*" priority="3">

		<xsl:if test="self::mn:abstract or self::mn:foreword or self::mn:introduction or (self::mn:clause and @type = 'toc')">
			<fo:block break-after="page"/>
		</xsl:if>

		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->

	<xsl:template match="mn:annex/mn:fmt-title">
		<fo:block xsl:use-attribute-sets="title-depth1-style" role="H1">
			<xsl:apply-templates/>
			<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-title" name="title">

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="../@inline-header = 'true'">
				<xsl:choose>
					<xsl:when test="$level = 1">
						<fo:inline xsl:use-attribute-sets="title-depth1-style">
							<xsl:apply-templates/>
						</fo:inline>
					</xsl:when>
					<xsl:when test="$level = 2">
						<fo:inline xsl:use-attribute-sets="title-depth2-style">
							<xsl:apply-templates/>
						</fo:inline>
					</xsl:when>
					<xsl:when test="$level = 3">
						<fo:inline xsl:use-attribute-sets="title-depth3-style">
							<xsl:apply-templates/>
						</fo:inline>
					</xsl:when>
					<xsl:otherwise>
						<fo:inline font-family="Lato" role="H{$level}">
							<xsl:apply-templates/>
						</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$level = 1">
						<fo:block xsl:use-attribute-sets="title-depth1-style">
							<xsl:apply-templates/>
							<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$level = 2">
						<fo:block xsl:use-attribute-sets="title-depth2-style">
							<xsl:apply-templates/>
							<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$level = 3">
						<fo:block xsl:use-attribute-sets="title-depth3-style">
							<xsl:apply-templates/>
							<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block font-family="Lato" role="H{$level}">
							<xsl:apply-templates/>
							<xsl:apply-templates select="following-sibling::*[1][self::mn:variant-title][@type = 'sub']" mode="subtitle"/>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:template match="mn:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'fmt-title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="parent::mn:admonition">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>

			<xsl:call-template name="setBlockAttributes"/>

			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::mn:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="ancestor::mn:dd and not(ancestor::mn:table)">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(parent::mn:admonition)">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::mn:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:ul | mn:ol" mode="list" priority="2">
		<fo:list-block xsl:use-attribute-sets="list-style">
			<xsl:if test="ancestor::mn:ul | ancestor::mn:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][self::mn:ul or self::mn:ol]">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="mn:ul/mn:note | mn:ol/mn:note" priority="2">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block/></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template name="insertHeaderFooter">

		<xsl:call-template name="insertFootnoteSeparatorCommon"/>

		<fo:static-content flow-name="header" role="artifact">
			<fo:block-container height="16.5mm" background-color="{$color}">
				<fo:block> </fo:block>
			</fo:block-container>
		</fo:static-content>

		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container height="100%" display-align="after">
				<fo:block-container height="23.5mm" background-color="{$color}" color="rgb(231, 230, 230)" display-align="after">
					<fo:block-container margin-left="1in" margin-right="1in">
						<fo:block-container margin-left="0mm" margin-right="0mm">
							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="50%"/>
								<fo:table-column column-width="50%"/>
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell>
											<fo:block padding-bottom="15mm">ogc.org</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block padding-bottom="14mm" text-align="right">
												<xsl:text>Page | </xsl:text>
												<fo:page-number/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block-container>
					</fo:block-container>
				</fo:block-container>
			</fo:block-container>
		</fo:static-content>

	</xsl:template>

	<xsl:template name="insertLogo">
		<xsl:choose>
			<xsl:when test="$selectedStyle = '2'">
				<xsl:variable name="Image-Logo-OGC">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="Layer_1" data-name="Layer 1" viewBox="0 0 1511.65 506.76"><defs><style>.cls-1{fill:none;}.cls-2{clip-path:url(#clip-path);}.cls-3{fill:#00b1ff;}</style><clipPath id="clip-path" transform="translate(-204.17 -235.76)"><rect class="cls-1" width="1920" height="978.25"/></clipPath></defs><g id="Blue_Horizontal_Lockup" data-name="Blue Horizontal Lockup"><g class="cls-2"><polygon class="cls-3" points="204.07 365.27 204.07 506.73 0.01 388.91 0 153.15 204.07 270.97 204.07 318.11 163.34 294.61 142.93 282.82 142.92 282.82 40.84 223.88 40.84 365.33 163.34 436.06 163.34 388.91 102.09 353.55 102.09 329.97 102.09 306.4 204.07 365.27"/><path class="cls-3" d="M428.68,235.76,224.5,353.64,428.68,471.52,632.85,353.64Zm0,188.61L306.17,353.64l122.52-70.73,122.49,70.73-20.41,11.79Z" transform="translate(-204.17 -235.76)"/><polygon class="cls-3" points="326.78 270.4 367.62 246.83 408.45 223.25 408.46 270.4 449.18 246.89 449.18 153.12 245.12 270.94 245.12 317.55 245.12 317.55 245.12 331.63 245.12 506.17 245.01 506.11 245.01 506.76 449.18 388.88 449.18 294.04 408.46 317.56 408.46 364.71 285.95 435.44 285.96 293.98 326.78 270.4"/><g class="cls-2"><path class="cls-3" d="M880.57,398.17c-32.81,0-57-24.06-57-56.05s24.2-56.05,57-56.05,56.91,24,56.91,56.05-24.15,56.06-56.91,56.06Zm38.87-56.05c0-22.3-16.59-39-38.87-39s-39,16.84-39,39,16.69,39,39,39,38.87-16.69,38.87-39" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1000.48,310.76c24.94,0,43.18,18.62,43.18,43.71s-18.24,43.75-43.18,43.75a41.67,41.67,0,0,1-27.67-10.09V426H955.67V312.8h11.55L970.44,323a41.5,41.5,0,0,1,30-12.26Zm25.84,43.71c0-15.71-11.47-27.35-27.19-27.35s-27.3,11.75-27.3,27.35,11.59,27.35,27.3,27.35,27.19-11.64,27.19-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1141.19,354.67a56.15,56.15,0,0,1-.35,5.63h-67.65c2.14,13.5,11.86,21.81,25.51,21.81,10,0,18-4.61,22.42-12.21h18c-6.63,17.6-21.85,28.28-40.46,28.28-24.37,0-42.83-18.81-42.83-43.71s18.42-43.7,42.83-43.7c25.51,0,42.49,19.64,42.49,43.9Zm-67.58-8.3H1124c-3.08-12.66-12.62-20.13-25.31-20.13-12.89,0-22.28,7.77-25.09,20.13" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1203.5,310.9c19.49,0,31.66,14.53,31.66,35.06v50.19H1218V349.44c0-15.14-6.59-23.18-19.12-23.18-13.1,0-22.39,10.54-22.39,25.26v44.63h-17.14V312.8h11.95l3.32,11.63c6.31-8.41,16.61-13.53,28.85-13.53Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M933.45,490.2c-.44,33.12-22.8,56.89-54.54,56.89s-55.3-23.7-55.3-56,23.29-56,54.95-56c26.35,0,48.4,16.59,53.28,40.1H913.56c-4.63-13.89-18.36-22.94-34.65-22.94-21.84,0-37.26,16-37.26,38.83s15,38.86,37.26,38.86c17.25,0,31.27-9.75,35.31-24.43H875.7V490.19Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1031.31,503.58a53.19,53.19,0,0,1-.36,5.63H963.3c2.14,13.51,11.87,21.81,25.51,21.81,10,0,18-4.6,22.43-12.2h18c-6.64,17.59-21.85,28.27-40.46,28.27-24.37,0-42.83-18.81-42.83-43.7s18.42-43.71,42.83-43.71c25.5,0,42.49,19.65,42.49,43.9Zm-67.58-8.29h50.4c-3.08-12.66-12.62-20.14-25.32-20.14-12.88,0-22.27,7.78-25.08,20.14" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1087.94,547.09c-25.49,0-44.56-18.65-44.56-43.71s19.07-43.7,44.56-43.7,44.56,18.61,44.56,43.71S1113.39,547.09,1087.94,547.09Zm27.12-43.71c0-15.95-11.34-27.34-27.12-27.34s-27.12,11.39-27.12,27.34,11.34,27.35,27.12,27.35,27.12-11.39,27.12-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1144.44,518.6h16.74c.44,8.81,7.84,13.41,17.88,13.41,9.21,0,16.28-3.89,16.28-10.86,0-7.9-8.94-9.71-19.15-11.43-13.89-2.38-30.25-5.53-30.25-24.85,0-14.95,12.92-25.19,32.31-25.19s31.93,10.54,32.26,26.71h-16.22c-.33-7.93-6.37-12.19-16.44-12.19-9.47,0-15.33,4-15.33,10.12,0,7.35,8.5,8.81,18.56,10.46,14.08,2.36,31.19,5.07,31.19,25.62,0,16.19-13.49,26.69-33.8,26.69s-33.59-11.2-34-28.49" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1275.49,459.68c24.94,0,43.18,18.61,43.18,43.71s-18.24,43.75-43.18,43.75a41.65,41.65,0,0,1-27.67-10.1v37.9h-17.14V461.71h11.55l3.22,10.24a41.48,41.48,0,0,1,30-12.27Zm25.85,43.7c0-15.71-11.48-27.34-27.19-27.34s-27.31,11.74-27.31,27.34,11.59,27.35,27.31,27.35,27.19-11.63,27.19-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1420,461.67V545h-13.82l-1.67-10.14a41.84,41.84,0,0,1-30.22,12.21c-24.84,0-43.4-18.76-43.4-43.75s18.56-43.66,43.4-43.66c12.28,0,22.91,4.64,30.48,12.41l2-10.42Zm-17.18,41.67c0-15.71-11.48-27.34-27.19-27.34s-27.3,11.74-27.3,27.34,11.59,27.35,27.3,27.35,27.19-11.64,27.19-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1491.08,529.5v15.56h-12.73c-18.26,0-29.53-11.26-29.53-29.68v-39h-14.91v-3.32l29-30.82h2.91v19.46h24.8v14.68H1466V514c0,9.93,5.53,15.47,15.63,15.47Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1507.42,431.12h17.7v17.67h-17.7Zm.28,30.59h17.14v83.35H1507.7Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1632.2,461.67V545h-13.82l-1.67-10.14a41.84,41.84,0,0,1-30.22,12.21c-24.83,0-43.4-18.76-43.4-43.75s18.57-43.66,43.4-43.66c12.28,0,22.91,4.64,30.48,12.41l2-10.42ZM1615,503.34c0-15.71-11.48-27.34-27.19-27.34s-27.3,11.74-27.3,27.34,11.59,27.35,27.3,27.35S1615,519.05,1615,503.34" transform="translate(-204.17 -235.76)"/><rect class="cls-3" x="1452.45" y="196.08" width="17.14" height="113.23"/><path class="cls-3" d="M823.61,640c0-32.33,23.57-56,55.54-56,25.56,0,46.05,15.93,51.72,40.25h-18c-5.16-14.39-17.77-23.09-33.77-23.09-21.64,0-37.5,16.28-37.5,38.83s15.86,38.74,37.5,38.74c16.51,0,29.27-9.32,34.14-24.64h18c-5.61,25.41-26.1,41.8-52.13,41.8-32,0-55.54-23.66-55.54-55.9" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M986.86,696c-25.5,0-44.57-18.66-44.57-43.71s19.07-43.71,44.57-43.71,44.56,18.62,44.56,43.71S1012.3,696,986.86,696ZM1014,652.3c0-15.95-11.35-27.35-27.12-27.35s-27.13,11.4-27.13,27.35,11.35,27.35,27.13,27.35S1014,668.25,1014,652.3" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1093.77,608.73c19.49,0,31.66,14.53,31.66,35.06V694H1108.3V647.27c0-15.13-6.59-23.18-19.12-23.18-13.1,0-22.39,10.54-22.39,25.26V694h-17.14V610.63h11.95l3.33,11.63c6.3-8.41,16.6-13.53,28.84-13.53Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1142.43,667.51h16.74c.44,8.82,7.84,13.42,17.89,13.42,9.2,0,16.27-3.9,16.27-10.86,0-7.91-8.94-9.72-19.15-11.43-13.88-2.38-30.25-5.54-30.25-24.86,0-14.95,12.93-25.18,32.31-25.18s31.94,10.54,32.27,26.7h-16.23c-.33-7.93-6.37-12.18-16.44-12.18-9.47,0-15.33,4-15.33,10.11,0,7.36,8.51,8.81,18.56,10.47,14.09,2.35,31.2,5.07,31.2,25.62,0,16.19-13.5,26.69-33.81,26.69s-33.59-11.21-34-28.5" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1267.12,696c-25.5,0-44.57-18.66-44.57-43.71s19.07-43.71,44.57-43.71,44.56,18.62,44.56,43.71S1292.56,696,1267.12,696Zm27.12-43.71c0-15.95-11.35-27.35-27.12-27.35S1240,636.35,1240,652.3s11.35,27.35,27.13,27.35,27.12-11.4,27.12-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1377.33,610.16v16.19h-9c-14.17,0-21.24,8.08-21.24,23.18V694h-17.14V610.63h11.59l2.9,11.37c6-7.9,14.14-11.84,25.52-11.84Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1437.53,678.41V694h-12.74c-18.26,0-29.52-11.27-29.52-29.68v-39h-14.91V622l29-30.82h2.92v19.46h24.8V625.3H1412.4v37.64c0,9.94,5.53,15.47,15.62,15.47Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1453.86,580h17.71v17.67h-17.71Zm.29,30.59h17.13V694h-17.13Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1494.36,658.78V610.63h17.14v45.75c0,14.48,7.9,23.27,20.77,23.27S1553,670.7,1553,656.38V610.63h17.14v48.15c0,22.43-14.87,37.23-37.87,37.23s-37.91-14.8-37.91-37.23" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1686.39,608.73c17.57,0,29.43,13.37,29.43,32.24v53h-17.13v-48.8c0-13.42-5.83-21.09-16.21-21.09-11,0-19.55,10.12-19.55,24.31V694H1646.2v-48.8c0-13.42-5.79-21.09-16.24-21.09-11.08,0-19.63,10.12-19.63,24.31V694H1593.2V610.63h12.14l3,10.77a33.38,33.38,0,0,1,25.89-12.67c11.3,0,20.25,5.55,25,14.59a33,33,0,0,1,27.2-14.59Z" transform="translate(-204.17 -235.76)"/></g></g></g></svg>
				</xsl:variable>
				<fo:block text-align="center" margin-top="-13mm">
					<fo:instream-foreign-object content-width="57.5mm" fox:alt-text="Image Logo">
						<xsl:copy-of select="$Image-Logo-OGC"/>
					</fo:instream-foreign-object>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Image-Logo-OGC">
					<xsl:text>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</xsl:text>
				</xsl:variable>
				<fo:block-container margin-top="24pt" margin-left="-5mm" margin-right="-5mm">
					<fo:block-container margin-left="0mm" margin-right="0mm">
						<fo:block text-align="center">
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-OGC))}" width="57.5mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- https://www.metanorma.org/ns/standoc -->
	<xsl:variable name="namespace_full" select="namespace-uri(//mn:metanorma[1])"/>

	<!-- https://www.metanorma.org/ns/xsl -->
	<xsl:variable name="namespace_mn_xsl">https://www.metanorma.org/ns/xslt</xsl:variable>

	<xsl:variable name="root_element">metanorma</xsl:variable>

	<!---examples: 2013, 2024 -->
	<xsl:variable name="document_scheme" select="normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'document-scheme']/mn:value)"/>

	<!-- external parameters -->
	<xsl:param name="svg_images"/> <!-- svg images array -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/> <!-- base path for images -->
	<xsl:param name="inputxml_basepath"/> <!-- input xml file path -->
	<xsl:param name="inputxml_filename"/> <!-- input xml file name -->
	<xsl:param name="output_path"/> <!-- output PDF file name -->
	<xsl:param name="outputpdf_basepath"/> <!-- output PDF folder -->
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:param name="syntax-highlight">false</xsl:param> <!-- syntax highlighting feature, default - off -->
	<xsl:param name="add_math_as_text">true</xsl:param> <!-- add math in text behind svg formula, to copy-paste formula from PDF as text -->

	<xsl:param name="table_if">false</xsl:param> <!-- generate extended table in IF for autolayout-algorithm -->
	<xsl:param name="table_widths"/> <!-- (debug: path to) xml with table's widths, generated on 1st pass, based on FOP Intermediate Format -->
	<!-- Example: <tables>
		<table page-width="509103" id="table1" width_max="223561" width_min="223560">
			<column width_max="39354" width_min="39354"/>
			<column width_max="75394" width_min="75394"/>
			<column width_max="108813" width_min="108813"/>
			<tbody>
				<tr>
					<td width_max="39354" width_min="39354">
						<p_len>39354</p_len>
						<word_len>39354</word_len>
					</td>
					
		OLD:
			<tables>
					<table id="table_if_tab-symdu" page-width="75"> - table id prefixed by 'table_if_' to simple search in IF 
						<tbody>
							<tr>
								<td id="tab-symdu_1_1">
									<p_len>6</p_len>
									<p_len>100</p_len>  for 2nd paragraph
									<word_len>6</word_len>
									<word_len>20</word_len>
								...
	-->

	<!-- for command line debug: <xsl:variable name="table_widths_from_if" select="document($table_widths)"/> -->
	<xsl:variable name="table_widths_from_if" select="xalan:nodeset($table_widths)"/>

	<xsl:variable name="table_widths_from_if_calculated_">
		<xsl:for-each select="$table_widths_from_if//table">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:call-template name="calculate-column-widths-autolayout-algorithm"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="table_widths_from_if_calculated" select="xalan:nodeset($table_widths_from_if_calculated_)"/>

	<xsl:param name="table_if_debug">false</xsl:param> <!-- set 'true' to put debug width data before table or dl -->

	<!-- for table auto-layout algorithm, see <xsl:template match="*[local-name()='table']" priority="2"> -->
	<xsl:param name="table_only_with_id"/> <!-- Example: 'table1' -->
	<xsl:param name="table_only_with_ids"/> <!-- Example: 'table1 table2 table3 ' -->

	<!-- don't remove and rename this variable, it's using in mn2pdf tool -->
	<xsl:variable name="isApplyAutolayoutAlgorithm_">true
	</xsl:variable>
	<xsl:variable name="isApplyAutolayoutAlgorithm" select="normalize-space($isApplyAutolayoutAlgorithm_)"/>

	<xsl:variable name="isGenerateTableIF"><xsl:value-of select="$table_if"/></xsl:variable>
	<!-- <xsl:variable name="isGenerateTableIF" select="normalize-space(normalize-space($table_if) = 'true' and 1 = 1)"/> -->

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<xsl:variable name="inputxml_filename_prefix">
		<xsl:choose>
			<xsl:when test="contains($inputxml_filename, '.presentation.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.presentation.xml')"/>
			</xsl:when>
			<xsl:when test="contains($inputxml_filename, '.xml')">
				<xsl:value-of select="substring-before($inputxml_filename, '.xml')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$inputxml_filename"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- Note 1: Each xslt has declated variable `namespace` that allows to set some properties, processing logic, etc. for concrete xslt.
	You can put such conditions by using xslt construction `xsl:if test="..."` or <xsl:choose><xsl:when test=""></xsl:when><xsl:otherwiste></xsl:otherwiste></xsl:choose>,
	BUT DON'T put any another conditions together with $namespace = '...' (such conditions will be ignored). For another conditions, please use nested xsl:if or xsl:choose -->

	<!-- Note 2: almost all localized string determined in the element //localized-strings in metanorma xml, but there are a few cases when:
	 - string didn't determined yet
	 - we need to put the string on two-languages (for instance, on English and French both), but xml contains only localized strings for one language
	 - there is a difference between localized string value and text that should be displayed in PDF
	-->
	<xsl:variable name="titles_">
		<!-- These titles of Table of contents renders different than determined in localized-strings -->
		<!-- <title-toc lang="en">
			<xsl:if test="$namespace = 'csd' or $namespace = 'ieee' or $namespace = 'iho' or $namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'unece-rec'">
				<xsl:text>Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'csa' or $namespace = 'm3d' or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper'">
				<xsl:text>Table of Contents</xsl:text>
			</xsl:if>
			<xsl:if test="$namespace = 'gb'">
				<xsl:text>Table of contents</xsl:text>
			</xsl:if>
		</title-toc> -->
		<title-toc lang="en">Table of contents</title-toc>
		<!-- <title-toc lang="fr">
			<xsl:text>Sommaire</xsl:text>
		</title-toc> -->
		<!-- <title-toc lang="zh">
			<xsl:choose>
				<xsl:when test="$namespace = 'gb'">
					<xsl:text>目次</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>Contents</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</title-toc> -->
		<title-toc lang="zh">目次</title-toc>

		<title-part lang="en">
		</title-part>
		<title-part lang="fr">
		</title-part>
		<title-part lang="ru">
		</title-part>
		<title-part lang="zh">第 # 部分:</title-part>
	</xsl:variable>
	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>

	<xsl:variable name="ace_tag">ace-tag_</xsl:variable>

	<xsl:variable name="title-list-tables">
		<xsl:variable name="toc_table_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title"/>
		<xsl:value-of select="$toc_table_title"/>
		<xsl:if test="normalize-space($toc_table_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_tables</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-figures">
		<xsl:variable name="toc_figure_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title"/>
		<xsl:value-of select="$toc_figure_title"/>
		<xsl:if test="normalize-space($toc_figure_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_figures</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-recommendations">
		<xsl:variable name="toc_requirement_title" select="//mn:metanorma/mn:metanorma-extension/mn:toc[@type='requirement']/mn:title"/>
		<xsl:value-of select="$toc_requirement_title"/>
		<xsl:if test="normalize-space($toc_requirement_title) = ''">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">toc_recommendations</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//mn:metanorma/mn:bibdata"/>
		<xsl:copy-of select="//mn:metanorma/mn:localized-strings"/>
	</xsl:variable>

	<xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Characters -->
	<xsl:variable name="linebreak">&#8232;</xsl:variable>
	<xsl:variable name="tab_zh">　</xsl:variable>
	<xsl:variable name="non_breaking_hyphen">‑</xsl:variable>
	<xsl:variable name="thin_space"> </xsl:variable>
	<xsl:variable name="zero_width_space">​</xsl:variable>
	<xsl:variable name="hair_space"> </xsl:variable>
	<xsl:variable name="en_dash">–</xsl:variable>
	<xsl:variable name="em_dash">—</xsl:variable>
	<xsl:variable name="nonbreak_space_em_dash_space"> — </xsl:variable>
	<xsl:variable name="cr">&#13;</xsl:variable>
	<xsl:variable name="lf">
</xsl:variable>

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>

	<!--
	<metanorma-extension>
		<presentation-metadata>
			<papersize>letter</papersize>
		</presentation-metadata>
	</metanorma-extension>
	-->

	<xsl:variable name="papersize" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//mn:metanorma/mn:metanorma-extension/mn:presentation-metadata/mn:papersize)))"/>
	<xsl:variable name="papersize_width_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">215.9</xsl:when>
			<xsl:when test="$papersize = 'a4'">210</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_width" select="normalize-space($papersize_width_)"/>
	<xsl:variable name="papersize_height_">
		<xsl:choose>
			<xsl:when test="$papersize = 'letter'">279.4</xsl:when>
			<xsl:when test="$papersize = 'a4'">297</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="papersize_height" select="normalize-space($papersize_height_)"/>

	<!-- page width in mm -->
	<xsl:variable name="pageWidth_">
		<xsl:choose>
			<xsl:when test="$papersize_width != ''"><xsl:value-of select="$papersize_width"/></xsl:when>
			<xsl:otherwise>215.9
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageWidth" select="normalize-space($pageWidth_)"/>

	<!-- page height in mm -->
	<xsl:variable name="pageHeight_">
		<xsl:choose>
			<xsl:when test="$papersize_height != ''"><xsl:value-of select="$papersize_height"/></xsl:when>
			<xsl:otherwise>279.4
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageHeight" select="normalize-space($pageHeight_)"/>

	<!-- Page margins in mm (just digits, without 'mm')-->
	<!-- marginLeftRight1 and marginLeftRight2 - is left or right margin depends on odd/even page,
	for example, left margin on odd page and right margin on even page -->
	<xsl:variable name="marginLeftRight1_">25.4
	</xsl:variable>
	<xsl:variable name="marginLeftRight1" select="normalize-space($marginLeftRight1_)"/>

	<xsl:variable name="marginLeftRight2_">25.4
	</xsl:variable>
	<xsl:variable name="marginLeftRight2" select="normalize-space($marginLeftRight2_)"/>

	<xsl:variable name="marginTop_">25.4
	</xsl:variable>
	<xsl:variable name="marginTop" select="normalize-space($marginTop_)"/>

	<xsl:variable name="marginBottom_">25.4
	</xsl:variable>
	<xsl:variable name="marginBottom" select="normalize-space($marginBottom_)"/>

	<xsl:variable name="layout_columns_default">1</xsl:variable>
	<xsl:variable name="layout_columns_" select="normalize-space((//mn:metanorma)[1]/mn:metanorma-extension/mn:presentation-metadata/mn:layout-columns)"/>
	<xsl:variable name="layout_columns">
		<xsl:choose>
			<xsl:when test="$layout_columns_ != ''"><xsl:value-of select="$layout_columns_"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$layout_columns_default"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="font_noto_sans">Noto Sans, Noto Sans HK, Noto Sans JP, Noto Sans KR, Noto Sans SC, Noto Sans TC</xsl:variable>
	<xsl:variable name="font_noto_sans_mono">Noto Sans Mono, Noto Sans Mono CJK HK, Noto Sans Mono CJK JP, Noto Sans Mono CJK KR, Noto Sans Mono CJK SC, Noto Sans Mono CJK TC</xsl:variable>
	<xsl:variable name="font_noto_serif">Noto Serif, Noto Serif HK, Noto Serif JP, Noto Serif KR, Noto Serif SC, Noto Serif TC</xsl:variable>
	<xsl:attribute-set name="root-style">
		<xsl:attribute name="font-family">Roboto, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
		<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
	</xsl:attribute-set> <!-- root-style -->

	<xsl:template name="insertRootStyle">
		<xsl:param name="root-style"/>
		<xsl:variable name="root-style_" select="xalan:nodeset($root-style)"/>

		<xsl:variable name="additional_fonts_">
			<xsl:for-each select="//mn:metanorma[1]/mn:metanorma-extension/mn:presentation-metadata[mn:name = 'fonts']/mn:value |       //mn:metanorma[1]/mn:presentation-metadata[mn:name = 'fonts']/mn:value">
				<xsl:value-of select="."/><xsl:if test="position() != last()">, </xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="additional_fonts" select="normalize-space($additional_fonts_)"/>

		<xsl:variable name="font_family_generic" select="$root-style_/root-style/@font-family-generic"/>

		<xsl:for-each select="$root-style_/root-style/@*">

			<xsl:choose>
				<xsl:when test="local-name() = 'font-family-generic'"><!-- skip, it's using for determine 'sans' or 'serif' --></xsl:when>
				<xsl:when test="local-name() = 'font-family'">

					<xsl:variable name="font_regional_prefix">
						<xsl:choose>
							<xsl:when test="$font_family_generic = 'Sans'">Noto Sans</xsl:when>
							<xsl:otherwise>Noto Serif</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:attribute name="{local-name()}">

						<xsl:variable name="font_extended">
							<xsl:choose>
								<xsl:when test="$lang = 'zh'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'hk'"><xsl:value-of select="$font_regional_prefix"/> HK</xsl:when>
								<xsl:when test="$lang = 'jp'"><xsl:value-of select="$font_regional_prefix"/> JP</xsl:when>
								<xsl:when test="$lang = 'kr'"><xsl:value-of select="$font_regional_prefix"/> KR</xsl:when>
								<xsl:when test="$lang = 'sc'"><xsl:value-of select="$font_regional_prefix"/> SC</xsl:when>
								<xsl:when test="$lang = 'tc'"><xsl:value-of select="$font_regional_prefix"/> TC</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="normalize-space($font_extended) != ''">
							<xsl:value-of select="$font_regional_prefix"/><xsl:text>, </xsl:text>
							<xsl:value-of select="$font_extended"/><xsl:text>, </xsl:text>
						</xsl:if>

						<xsl:variable name="font_family" select="."/>

						<xsl:choose>
							<xsl:when test="$additional_fonts = ''">
								<xsl:value-of select="$font_family"/>
							</xsl:when>
							<xsl:otherwise> <!-- $additional_fonts != '' -->
								<xsl:choose>
									<xsl:when test="contains($font_family, ',')">
										<xsl:value-of select="substring-before($font_family, ',')"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
										<xsl:text>, </xsl:text><xsl:value-of select="substring-after($font_family, ',')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$font_family"/>
										<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose>

			<!-- <xsl:choose>
				<xsl:when test="local-name() = 'font-family'">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>, <xsl:value-of select="$additional_fonts"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="."/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:for-each>
	</xsl:template> <!-- insertRootStyle -->

	<!-- ===================================== -->
	<!-- Update xml -->
	<!-- ===================================== -->

	<xsl:template name="updateXML">
		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step1</xsl:message></xsl:if>
		<xsl:variable name="startTime1" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
		<xsl:variable name="updated_xml_step1">
			<xsl:if test="$table_if = 'false'">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="endTime1" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime1 - $startTime1"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step1</xsl:message>
			<!-- <redirect:write file="updated_xml_step1_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step1"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step2</xsl:message></xsl:if>
		<xsl:variable name="startTime2" select="java:getTime(java:java.util.Date.new())"/>

		<!-- STEP2: add 'fn' after 'eref' and 'origin', if referenced to bibitem with 'note' = Withdrawn.' or 'Cancelled and replaced...'  -->
		<xsl:variable name="updated_xml_step2">
			<xsl:if test="$table_if = 'false'">
				<xsl:copy-of select="$updated_xml_step1"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="endTime2" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime2 - $startTime2"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step2</xsl:message>
			<!-- <redirect:write file="updated_xml_step2_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step2"/>
			</redirect:write> -->
		</xsl:if>

		<xsl:if test="$debug = 'true'"><xsl:message>START updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime3" select="java:getTime(java:java.util.Date.new())"/>

		<xsl:variable name="updated_xml_step3">
			<xsl:choose>
				<xsl:when test="$table_if = 'false'">
					<xsl:apply-templates select="xalan:nodeset($updated_xml_step2)" mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="." mode="update_xml_enclose_keep-together_within-line"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="endTime3" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime3 - $startTime3"/> msec.</xsl:message>
			<xsl:message>END updated_xml_step3</xsl:message>
			<!-- <redirect:write file="updated_xml_step3_{java:getTime(java:java.util.Date.new())}.xml">
				<xsl:copy-of select="$updated_xml_step3"/>
			</redirect:write> -->
		</xsl:if>

		<!-- <xsl:if test="$debug = 'true'"><xsl:message>START copying updated_xml_step3</xsl:message></xsl:if>
		<xsl:variable name="startTime4" select="java:getTime(java:java.util.Date.new())"/>  -->
		<xsl:copy-of select="$updated_xml_step3"/>
		<!-- <xsl:variable name="endTime4" select="java:getTime(java:java.util.Date.new())"/>
		<xsl:if test="$debug = 'true'">
			<xsl:message>DEBUG: processing time <xsl:value-of select="$endTime4 - $startTime4"/> msec.</xsl:message>
			<xsl:message>END copying updated_xml_step3</xsl:message>
		</xsl:if> -->

	</xsl:template>

	<!-- =========================================================================== -->
	<!-- STEP1:  -->
	<!--   - Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!--   - Put Section title in the correct position -->
	<!--   - Ignore 'span' without style -->
	<!--   - Remove semantic xml part -->
	<!--   - Remove image/emf (EMF vector image for Word) -->
	<!--   - add @id, redundant for table auto-layout algorithm -->
	<!--   - process 'passthrough' element -->
	<!--   - split math by element with @linebreak into maths -->
	<!--   - rename fmt-title to title, fmt-name to name and another changes to convert new presentation XML to  -->
	<!--   - old XML without significant changes in XSLT -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- change section's order based on @displayorder value -->
	<xsl:template match="mn:preface" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_preface_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

			<xsl:for-each select="*">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sections" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

			<!-- move section 'Normative references' inside 'sections' -->
			<xsl:for-each select="* |      ancestor::mn:metanorma/mn:bibliography/mn:references[@normative='true'] |     ancestor::mn:metanorma/mn:bibliography/mn:clause[mn:references[@normative='true']]">
				<xsl:sort select="@displayorder" data-type="number"/>

				<!-- process Section's title -->
				<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
				<xsl:if test="$preceding-sibling_id != ''">
					<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="update_xml_step1"/>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="@type = 'section-title' and not(@displayorder)"><!-- skip, don't copy, because copied in above 'apply-templates' --></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="update_xml_step1"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:bibliography" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- copy all elements from bibliography except 'Normative references' (moved to 'sections') -->
			<xsl:for-each select="*[not(@normative='true') and not(*[@normative='true'])]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<!-- Example with 'class': <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@style or @class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear' or @class = 'fmt-hi' or @class = 'horizontal' or @class = 'norotate' or @class = 'halffontsize']" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]/mn:span[@class] | mn:sourcecode//mn:span[@class]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- remove semantic xml -->
	<xsl:template match="mn:metanorma-extension/mn:metanorma/mn:source" mode="update_xml_step1"/>

	<!-- remove UnitML elements, big section especially in BIPM xml -->
	<xsl:template match="mn:metanorma-extension/*[local-name() = 'UnitsML']" mode="update_xml_step1"/>

	<!-- remove image/emf -->
	<xsl:template match="mn:image/mn:emf" mode="update_xml_step1"/>

	<!-- remove preprocess-xslt -->
	<xsl:template match="mn:preprocess-xslt" mode="update_xml_step1"/>

	<xsl:template match="mn:stem" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-stem" mode="update_xml_step1">
		<!-- <xsl:element name="stem" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="mn:semx and count(node()) = 1">
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="mn:semx/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:semx/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//*[@linebreak])">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>

	<xsl:template match="mn:image[not(.//mn:passthrough)] |        mn:bibdata[not(.//mn:passthrough)] |        mn:localized-strings" mode="update_xml_step1">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<!-- mn:sourcecode[not(.//mn:passthrough) and not(.//mn:fmt-name)] -->
	<xsl:template match="mn:sourcecode" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:choose>
				<xsl:when test="mn:fmt-sourcecode">
					<xsl:choose>
						<xsl:when test="mn:fmt-sourcecode[not(.//mn:passthrough)] and not(.//mn:fmt-name)">
							<xsl:copy-of select="mn:fmt-sourcecode/node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="mn:fmt-sourcecode/node()" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise> <!-- If fmt-sourcecode is not present -->
					<xsl:choose>
						<xsl:when test="not(.//mn:passthrough) and not(.//mn:fmt-name)">
							<xsl:copy-of select="node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]" mode="update_xml_step1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/651 -->
	<xsl:template match="mn:figure[mn:fmt-figure]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
			<xsl:apply-templates select="mn:fmt-figure/node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source" mode="update_xml_step1"/>
	<xsl:template match="mn:quote/mn:author" mode="update_xml_step1"/>
	<xsl:template match="mn:amend" mode="update_xml_step1"/>
	<!-- https://github.com/metanorma/isodoc/issues/687 -->
	<xsl:template match="mn:source" mode="update_xml_step1"/>

	<xsl:template match="mn:metanorma-extension/mn:attachment" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:if test="1 = 2"> <!-- remove attachment/text(), because attachments added in the template 'addPDFUAmeta' before applying 'update_xml_step1' -->
				<xsl:variable name="name_filepath" select="concat($inputxml_basepath, @name)"/>
				<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($name_filepath)))"/>
				<xsl:if test="$file_exists = 'false'"> <!-- copy attachment content only if file on disk doesnt exist -->
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:if>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- add @id, mandatory for table auto-layout algorithm -->
	<xsl:template match="*[self::mn:dl or self::mn:table][not(@id)]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="add_id"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- prevent empty thead processing in XSL-FO, remove it -->
	<xsl:template match="mn:table/mn:thead[count(*) = 0]" mode="update_xml_step1"/>

	<xsl:template name="add_id">
		<xsl:if test="not(@id)">
			<!-- add @id - first element with @id plus '_element_name' -->
			<xsl:variable name="prefix_id_" select="(.//*[@id])[1]/@id"/>
			<xsl:variable name="prefix_id"><xsl:value-of select="$prefix_id_"/><xsl:if test="normalize-space($prefix_id_) = ''"><xsl:value-of select="generate-id()"/></xsl:if></xsl:variable>
			<xsl:variable name="document_suffix" select="ancestor::mn:metanorma/@document_suffix"/>
			<xsl:attribute name="id"><xsl:value-of select="concat($prefix_id, '_', local-name(), '_', $document_suffix)"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- optimization: remove clause if table_only_with_id isn't empty and clause doesn't contain table or dl with table_only_with_id -->
	<xsl:template match="*[self::mn:clause or self::mn:p or self::mn:definitions or self::mn:annex]" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="($table_only_with_id != '' or $table_only_with_ids != '') and self::mn:p and (ancestor::*[self::mn:table or self::mn:dl or self::mn:toc])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_id != '' and not(.//*[self::mn:table or self::mn:dl][@id = $table_only_with_id])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<!-- for table auto-layout algorithm -->
			<xsl:when test="$table_only_with_ids != '' and not(.//*[self::mn:table or self::mn:dl][contains($table_only_with_ids, concat(@id, ' '))])">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
				</xsl:copy>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="regex_passthrough">.*\bpdf\b.*</xsl:variable>
	<xsl:template match="mn:passthrough" mode="update_xml_step1">
		<!-- <xsl:if test="contains(@formats, ' pdf ')"> -->
		<xsl:if test="normalize-space(java:matches(java:java.lang.String.new(@formats), $regex_passthrough)) = 'true'">
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:if>
	</xsl:template>

	<!-- split math by element with @linebreak into maths -->
	<xsl:template match="mathml:math[.//mathml:mo[@linebreak] or .//mathml:mspace[@linebreak]]" mode="update_xml_step1">
		<xsl:variable name="maths">
			<xsl:apply-templates select="." mode="mathml_linebreak"/>
		</xsl:variable>
		<xsl:copy-of select="$maths"/>
	</xsl:template>

	<!-- update new Presentation XML -->
	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="update_xml_step1"/>
	<xsl:template match="mn:name[following-sibling::*[1][self::mn:fmt-name]]" mode="update_xml_step1"/>
	<xsl:template match="mn:section-title[following-sibling::*[1][self::mn:p][@type = 'section-title' or @type = 'floating-title']]" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:preferred[following-sibling::*[not(local-name() = 'preferred')][1][local-name() = 'fmt-preferred']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:preferred" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:admitted[following-sibling::*[not(local-name() = 'admitted')][1][local-name() = 'fmt-admitted']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:admitted" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:deprecates[following-sibling::*[not(local-name() = 'deprecates')][1][local-name() = 'fmt-deprecates']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:deprecates" mode="update_xml_step1"/>
	<xsl:template match="mn:related" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:definition[following-sibling::*[1][local-name() = 'fmt-definition']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:definition" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:termsource[following-sibling::*[1][local-name() = 'fmt-termsource']]" mode="update_xml_step1"/> -->
	<xsl:template match="mn:termsource" mode="update_xml_step1"/>

	<xsl:template match="mn:term[@unnumbered = 'true'][not(.//*[starts-with(local-name(), 'fmt-')])]" mode="update_xml_step1"/>

	<xsl:template match="mn:p[@type = 'section-title' or @type = 'floating-title'][preceding-sibling::*[1][self::mn:section-title]]" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="update_xml_step1"/>
			<xsl:copy-of select="preceding-sibling::*[1][self::mn:section-title]/@depth"/>
			<xsl:apply-templates select="node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:fmt-title" mode="update_xml_step1">
		<!-- <xsl:element name="title" namespace="{$namespace_full}"> -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:call-template name="addNamedDestinationAttribute"/>

			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
		<!-- </xsl:element> -->
	</xsl:template>

	<xsl:template name="addNamedDestinationAttribute">
	</xsl:template>

	<xsl:template match="mn:fmt-name" mode="update_xml_step1">
		<xsl:choose>
			<xsl:when test="local-name(..) = 'p' and ancestor::mn:table">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:element name="name" namespace="{$namespace_full}"> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:call-template name="addNamedDestinationAttribute"/>

					<xsl:apply-templates mode="update_xml_step1"/>
				</xsl:copy>
				<!-- </xsl:element> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- li/fmt-name -->
	<xsl:template match="mn:li/mn:fmt-name" priority="2" mode="update_xml_step1">
		<xsl:attribute name="label"><xsl:value-of select="."/></xsl:attribute>
		<xsl:attribute name="full">true</xsl:attribute>
	</xsl:template>

	<xsl:template match="mn:fmt-preferred[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-preferred[not(mn:p)] | mn:fmt-preferred/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-preferred" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:fmt-admitted[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-admitted[not(mn:p)] | mn:fmt-admitted/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-admitted" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:fmt-deprecates[mn:p]" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<xsl:template match="mn:fmt-deprecates[not(mn:p)] | mn:fmt-deprecates/mn:p" mode="update_xml_step1">
		<xsl:element name="fmt-deprecates" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>

	<!-- <xsl:template match="mn:fmt-definition" mode="update_xml_step1">
		<xsl:element name="definition" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-termsource" mode="update_xml_step1">
		<xsl:element name="termsource" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="mn:fmt-source" mode="update_xml_step1">
		<xsl:element name="source" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:span[                @class = 'fmt-caption-label' or                 @class = 'fmt-element-name' or                @class = 'fmt-caption-delim' or                @class = 'fmt-autonum-delim']" mode="update_xml_step1" priority="3">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label" mode="update_xml_step1"/>

	<xsl:template match="mn:requirement | mn:recommendation | mn:permission" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:requirement/*[not(starts-with(local-name(), 'fmt-'))] |             mn:recommendation/*[not(starts-with(local-name(), 'fmt-'))] |              mn:permission/*[not(starts-with(local-name(), 'fmt-'))]" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-provision" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:identifier" mode="update_xml_step1"/>
	<!-- <xsl:template match="mn:fmt-identifier" mode="update_xml_step1">
		<xsl:element name="identifier" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:concept" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-concept" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>

	<xsl:template match="mn:eref" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-eref" mode="update_xml_step1">
		<xsl:element name="eref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:xref" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-xref" mode="update_xml_step1">
		<xsl:element name="xref" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:link" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-link" mode="update_xml_step1">
		<xsl:element name="link" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:origin" mode="update_xml_step1"/>

	<!-- <xsl:template match="mn:fmt-origin" mode="update_xml_step1">
		<xsl:element name="origin" namespace="{$namespace_full}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:element>
	</xsl:template> -->

	<xsl:template match="mn:erefstack" mode="update_xml_step1"/>

	<xsl:template match="mn:svgmap" mode="update_xml_step1"/>

	<xsl:template match="mn:annotation-container" mode="update_xml_step1"/>

	<xsl:template match="mn:fmt-identifier[not(ancestor::*[local-name() = 'bibdata'])]//text()" mode="update_xml_step1">
		<xsl:element name="{$element_name_keep-together_within-line}" namespace="{$namespace_full}">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="@semx-id | @anchor" mode="update_xml_step1"/>

	<!-- END: update new Presentation XML -->

	<!-- =========================================================================== -->
	<!-- END STEP1: update_xml_step1 -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step_move_pagebreak">
				<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<!-- replace 'pagebreak' by closing tags + page_sequence and  opening page_sequence + tags -->
	<xsl:template match="mn:pagebreak[not(following-sibling::*[1][self::mn:pagebreak])]" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top"/>
		<!-- <xsl:choose>
			<xsl:when test="ancestor::mn:sections">
			
			</xsl:when>
			<xsl:when test="ancestor::mn:annex">
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose> -->

		<!-- determine pagebreak is last element before </fo:flow> or not -->
		<xsl:variable name="isLast">
			<xsl:for-each select="ancestor-or-self::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
				<xsl:if test="following-sibling::*">false</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="contains($isLast, 'false')">

			<xsl:variable name="orientation" select="normalize-space(@orientation)"/>

			<xsl:variable name="tree_">
				<xsl:call-template name="makeAncestorsElementsTree">
					<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

			<!-- close fo:page-sequence (closing preceding fo elements) -->
			<xsl:call-template name="insertClosingElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

			<xsl:text disable-output-escaping="yes">&lt;/page_sequence&gt;</xsl:text>

			<!-- create a new page_sequence (opening elements) -->
			<xsl:text disable-output-escaping="yes">&lt;page_sequence xmlns="</xsl:text><xsl:value-of select="$namespace_full"/>"<xsl:if test="$orientation != ''"> orientation="<xsl:value-of select="$orientation"/>"</xsl:if><xsl:text disable-output-escaping="yes">&gt;</xsl:text>

			<xsl:call-template name="insertOpeningElements">
				<xsl:with-param name="tree" select="$tree"/>
			</xsl:call-template>

		</xsl:if>
	</xsl:template>

	<xsl:template name="makeAncestorsElementsTree">
		<xsl:param name="page_sequence_at_top"/>

		<xsl:choose>
			<xsl:when test="$page_sequence_at_top = 'true'">
				<xsl:for-each select="ancestor::*[ancestor::mn:metanorma]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="ancestor::*[ancestor::mn:preface or ancestor::mn:sections or ancestor-or-self::mn:annex]">
					<element pos="{position()}">
						<xsl:copy-of select="@*[local-name() != 'id']"/>
						<xsl:value-of select="name()"/>
					</element>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertClosingElements">
		<xsl:param name="tree"/>
		<xsl:for-each select="$tree//element">
			<xsl:sort data-type="number" order="descending" select="@pos"/>
			<xsl:text disable-output-escaping="yes">&lt;/</xsl:text>
				<xsl:value-of select="."/>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;/<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertOpeningElements">
		<xsl:param name="tree"/>
		<xsl:param name="xmlns"/>
		<xsl:param name="add_continue">true</xsl:param>
		<xsl:for-each select="$tree//element">
			<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:value-of select="."/>
				<xsl:for-each select="@*[local-name() != 'pos']">
					<xsl:text> </xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>="</xsl:text>
					<xsl:value-of select="."/>
					<xsl:text>"</xsl:text>
				</xsl:for-each>
				<xsl:if test="position() = 1 and $add_continue = 'true'"> continue="true"</xsl:if>
				<xsl:if test="position() = 1 and $xmlns != ''"> xmlns="<xsl:value-of select="$xmlns"/>"</xsl:if>
			<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			<xsl:if test="$debug = 'true'">
				<xsl:message>&lt;<xsl:value-of select="."/>&gt;</xsl:message>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<!-- move full page width figures, tables at top level -->
	<xsl:template match="*[self::mn:figure or self::mn:table][normalize-space(@width) != 'text-width']" mode="update_xml_step_move_pagebreak">
		<xsl:param name="page_sequence_at_top">false</xsl:param>
		<xsl:choose>
			<xsl:when test="$layout_columns != 1">

				<xsl:variable name="tree_">
					<xsl:call-template name="makeAncestorsElementsTree">
						<xsl:with-param name="page_sequence_at_top" select="$page_sequence_at_top"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="tree" select="xalan:nodeset($tree_)"/>

				<xsl:call-template name="insertClosingElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:attribute name="top-level">true</xsl:attribute>
					<xsl:copy-of select="node()"/>
				</xsl:copy>

				<xsl:call-template name="insertOpeningElements">
					<xsl:with-param name="tree" select="$tree"/>
				</xsl:call-template>

			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =========================================================================== -->
	<!-- END STEP MOVE PAGEBREAK: move <pagebreak/> at top level under 'preface' and 'sections' -->
	<!-- =========================================================================== -->

	<!-- =========================================================================== -->
	<!-- XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
	<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY  -->
	<!-- =========================================================================== -->
	<!-- Example: <keep-together_within-line>ISO 10303-51</keep-together_within-line> -->
	<xsl:template match="@*|node()" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="express_reference_separators">_.\</xsl:variable>
	<xsl:variable name="express_reference_characters" select="concat($upper,$lower,'1234567890',$express_reference_separators)"/>
	<xsl:variable name="regex_express_reference">(^([A-Za-z0-9_.\\]+)$)</xsl:variable>

	<xsl:variable name="element_name_keep-together_within-line">keep-together_within-line</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_open">###<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
	<xsl:variable name="tag_keep-together_within-line_close">###/<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>

	<!-- \S matches any non-whitespace character (equivalent to [^\r\n\t\f\v ]) -->
	<!-- <xsl:variable name="regex_solidus_units">((\b((\S{1,3}\/\S+)|(\S+\/\S{1,3}))\b)|(\/\S{1,3})\b)</xsl:variable> -->
	<!-- add &lt; and &gt; to \S -->
	<xsl:variable name="regex_S">[^\r\n\t\f\v \&lt;&gt;\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_solidus_units">((\b((<xsl:value-of select="$regex_S"/>{1,3}\/<xsl:value-of select="$regex_S"/>+)|(<xsl:value-of select="$regex_S"/>+\/<xsl:value-of select="$regex_S"/>{1,3}))\b)|(\/<xsl:value-of select="$regex_S"/>{1,3})\b)</xsl:variable>

	<xsl:variable name="non_white_space">[^\s\u3000-\u9FFF]</xsl:variable>
	<xsl:variable name="regex_dots_units">((\b((<xsl:value-of select="$non_white_space"/>{1,3}\.<xsl:value-of select="$non_white_space"/>+)|(<xsl:value-of select="$non_white_space"/>+\.<xsl:value-of select="$non_white_space"/>{1,3}))\b)|(\.<xsl:value-of select="$non_white_space"/>{1,3})\b)</xsl:variable>

	<xsl:template match="text()[not(ancestor::mn:bibdata or      ancestor::mn:fmt-link[not(contains(normalize-space(),' '))] or      ancestor::mn:sourcecode or      ancestor::*[local-name() = 'math'] or     ancestor::*[local-name() = 'svg'] or     ancestor::mn:name or ancestor::mn:fmt-name or     starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.') or normalize-space() = '' )]" name="keep_together_standard_number" mode="update_xml_enclose_keep-together_within-line">

		<xsl:variable name="parent" select="local-name(..)"/>

		<xsl:if test="1 = 2"> <!-- alternative variant -->

			<xsl:variable name="regexs">
				<!-- enclose standard's number into tag 'keep-together_within-line' -->
				<xsl:if test="not(ancestor::mn:table)"><regex><xsl:value-of select="$regex_standard_reference"/></regex></xsl:if>
				<!-- if EXPRESS reference -->
				<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
				<regex><xsl:value-of select="$regex_solidus_units"/></regex>
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:if test="ancestor::*[self::mn:td or self::mn:th]">
					<regex><xsl:value-of select="$regex_dots_units"/></regex>
				</xsl:if>
			</xsl:variable>

			<xsl:variable name="regex_replacement"><xsl:text>(</xsl:text>
				<xsl:for-each select="xalan:nodeset($regexs)/regex">
					<xsl:value-of select="."/>
					<xsl:if test="position() != last()">|</xsl:if>
				</xsl:for-each>
				<xsl:text>)</xsl:text>
			</xsl:variable>

			<!-- regex_replacement='<xsl:value-of select="$regex_replacement"/>' -->

			<xsl:variable name="text_replaced" select="java:replaceAll(java:java.lang.String.new(.), $regex_replacement, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>

			<!-- text_replaced='<xsl:value-of select="$text_replaced"/>' -->

			<xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
				<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
				<xsl:with-param name="text" select="$text_replaced"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:if test="1 = 1">

		<!-- enclose standard's number into tag 'keep-together_within-line' -->
		<xsl:variable name="text">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:choose>
					<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when> <!-- no need enclose standard's number into tag 'keep-together_within-line' in table cells -->
					<xsl:otherwise>
						<xsl:variable name="text_" select="java:replaceAll(java:java.lang.String.new(.), $regex_standard_reference, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
						<!-- <xsl:value-of select="$text__"/> -->

						<xsl:call-template name="replace_text_tags">
							<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text_"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="text2">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text)/*[local-name() = 'text']/node()"><xsl:copy-of select="."/>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
		<xsl:variable name="text3">
			<xsl:element name="text" namespace="{$namespace_full}">
				<xsl:for-each select="xalan:nodeset($text2)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_units" select="java:replaceAll(java:java.lang.String.new(.),$regex_solidus_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_units">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_units"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_units)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:element>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:for-each select="xalan:nodeset($text3)/*[local-name() = 'text']/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_dots" select="java:replaceAll(java:java.lang.String.new(.),$regex_dots_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<!-- <xsl:variable name="text_dots">
								<xsl:element name="text" namespace="{$namespace_full}"> -->
									<xsl:call-template name="replace_text_tags">
										<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
										<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
										<xsl:with-param name="text" select="$text_dots"/>
									</xsl:call-template>
								<!-- </xsl:element>
							</xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_dots)/*[local-name() = 'text']/node()"/> -->
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="xalan:nodeset($text3)/*[local-name() = 'text']/node()"/></xsl:otherwise>
		</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-stem | mn:image" mode="update_xml_enclose_keep-together_within-line">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template name="replace_text_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>

				<xsl:element name="{substring-before(substring-after($tag_open, '###'),'###')}" namespace="{$namespace_full}">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</xsl:element>

				<xsl:call-template name="replace_text_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ===================================== -->
	<!-- END XML UPDATE STEP: enclose standard's name into tag 'keep-together_within-line'  -->
	<!-- ===================================== -->

	<!-- Example:
	<metanorma>
		<preface>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</preface>
		<sections>
			<page_sequence>
				<clause...
			</page_sequence>
			<page_sequence>
				<clause...
			</page_sequence>
		</sections>
		<page_sequence>
			<annex ..
		</page_sequence>
		<page_sequence>
			<annex ..
		</page_sequence>
	</metanorma>
	-->
	<xsl:template name="processPrefaceAndMainSectionsDefault_items">

		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:call-template name="insertPrefaceSectionsPageSequences"/>
				<xsl:call-template name="insertMainSectionsPageSequences"/>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>

		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
	</xsl:template> <!-- END: processPrefaceAndMainSectionsDefault_items -->

	<xsl:template name="insertPrefaceSectionsPageSequences">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertPrefaceSectionsPageSequences -->

	<xsl:template name="insertMainSectionsPageSequences">

		<xsl:call-template name="insertSectionsInPageSequence"/>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:for-each select="/*/mn:annex">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:for-each>
		</xsl:element>

		<xsl:element name="page_sequence" namespace="{$namespace_full}">
			<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
				<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |            /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template> <!-- END: insertMainSectionsPageSequences -->

	<xsl:template name="insertSectionsInPageSequence">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>

	<xsl:template name="insertMainSectionsInSeparatePageSequences">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>

		<xsl:call-template name="insertAnnexAndBibliographyInSeparatePageSequences"/>

		<!-- <xsl:call-template name="insertBibliographyInSeparatePageSequences"/> -->

		<!-- <xsl:call-template name="insertIndexInSeparatePageSequences"/> -->
	</xsl:template> <!-- END: insertMainSectionsInSeparatePageSequences -->

	<xsl:template name="insertAnnexAndBibliographyInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex |           /*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]] |          /*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:choose>
				<xsl:when test="self::mn:annex or self::mn:indexsect">
					<xsl:element name="page_sequence" namespace="{$namespace_full}">
						<xsl:attribute name="main_page_sequence"/>
						<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise> <!-- bibliography -->
					<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
						<xsl:element name="page_sequence" namespace="{$namespace_full}">
							<xsl:attribute name="main_page_sequence"/>
							<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertAnnexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="insertBibliographyInSeparatePageSequences">
		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:attribute name="main_page_sequence"/>
					<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="insertIndexInSeparatePageSequences">
		<xsl:for-each select="/*/mn:indexsect">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:element name="page_sequence" namespace="{$namespace_full}">
				<xsl:attribute name="main_page_sequence"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processAllSectionsDefault_items">
		<xsl:variable name="updated_xml_step_move_pagebreak">
			<xsl:element name="{$root_element}" namespace="{$namespace_full}">
				<xsl:call-template name="copyCommonElements"/>
				<xsl:element name="page_sequence" namespace="{$namespace_full}">
					<xsl:call-template name="insertPrefaceSections"/>
					<xsl:call-template name="insertMainSections"/>
				</xsl:element>
			</xsl:element>
		</xsl:variable>

		<xsl:variable name="updated_xml_step_move_pagebreak_filename" select="concat($output_path,'_preface_and_main_', java:getTime(java:java.util.Date.new()), '.xml')"/>
		<!-- <xsl:message>updated_xml_step_move_pagebreak_filename=<xsl:value-of select="$updated_xml_step_move_pagebreak_filename"/></xsl:message>
		<xsl:message>start write updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<redirect:write file="{$updated_xml_step_move_pagebreak_filename}">
			<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
		</redirect:write>
		<!-- <xsl:message>end write updated_xml_step_move_pagebreak_filename</xsl:message> -->

		<xsl:copy-of select="document($updated_xml_step_move_pagebreak_filename)"/>

		<!-- TODO: instead of 
		<xsl:for-each select=".//mn:page_sequence[normalize-space() != '' or .//image or .//svg]">
		in each template, add removing empty page_sequence here
		-->

		<xsl:if test="$debug = 'true'">
			<redirect:write file="page_sequence_preface_and_main.xml">
				<xsl:copy-of select="$updated_xml_step_move_pagebreak"/>
			</redirect:write>
		</xsl:if>

		<!-- <xsl:message>start delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
		<xsl:call-template name="deleteFile">
			<xsl:with-param name="filepath" select="$updated_xml_step_move_pagebreak_filename"/>
		</xsl:call-template>
		<!-- <xsl:message>end delete updated_xml_step_move_pagebreak_filename</xsl:message> -->
	</xsl:template> <!-- END: processAllSectionsDefault_items -->

	<xsl:template name="insertPrefaceSections">
		<xsl:element name="preface" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<xsl:template name="insertMainSections">
		<xsl:element name="sections" namespace="{$namespace_full}"> <!-- save context element -->

			<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>

		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
		</xsl:for-each>

		<xsl:element name="bibliography" namespace="{$namespace_full}"> <!-- save context element -->
			<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |           /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step_move_pagebreak">
					<xsl:with-param name="page_sequence_at_top">true</xsl:with-param>
				</xsl:apply-templates>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>

	<!-- boilerplate sections styles -->
	<xsl:attribute-set name="copyright-statement-style">
	</xsl:attribute-set> <!-- copyright-statement-style -->

	<xsl:attribute-set name="copyright-statement-title-style">
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- copyright-statement-title-style -->

	<xsl:attribute-set name="copyright-statement-p-style">
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set> <!-- copyright-statement-p-style -->

		<xsl:attribute-set name="license-statement-style">
	</xsl:attribute-set> <!-- license-statement-style -->

	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="margin-top">4pt</xsl:attribute>
	</xsl:attribute-set> <!-- license-statement-title-style -->

	<xsl:attribute-set name="license-statement-p-style">
		<xsl:attribute name="font-size">8pt</xsl:attribute>
		<xsl:attribute name="margin-top">14pt</xsl:attribute>
		<xsl:attribute name="line-height">135%</xsl:attribute>
	</xsl:attribute-set> <!-- license-statement-p-style -->

	<xsl:attribute-set name="legal-statement-style">
	</xsl:attribute-set> <!-- legal-statement-style -->

	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- legal-statement-title-style -->

	<xsl:attribute-set name="legal-statement-p-style">
		<xsl:attribute name="text-align">left</xsl:attribute>
	</xsl:attribute-set> <!-- legal-statement-p-style -->

	<xsl:attribute-set name="feedback-statement-style">
	</xsl:attribute-set> <!-- feedback-statement-style -->

	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set> <!-- feedback-statement-title-style -->

	<xsl:attribute-set name="feedback-statement-p-style">
	</xsl:attribute-set> <!-- feedback-statement-p-style -->

	<!-- End boilerplate sections styles -->

	<!-- ================================= -->
	<!-- Preface boilerplate sections processing -->
	<!-- ================================= -->
	<xsl:template match="mn:copyright-statement">
		<fo:block xsl:use-attribute-sets="copyright-statement-style" role="SKIP">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- copyright-statement -->

	<xsl:template match="mn:copyright-statement//mn:fmt-title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:block role="H{$level}" xsl:use-attribute-sets="copyright-statement-title-style">
			<xsl:apply-templates/>
		</fo:block>

	</xsl:template> <!-- copyright-statement//title -->

	<xsl:template match="mn:copyright-statement//mn:p">
		<fo:block xsl:use-attribute-sets="copyright-statement-p-style">
				<xsl:if test="@align">
					<xsl:attribute name="text-align">
						<xsl:value-of select="@align"/>
					</xsl:attribute>
				</xsl:if>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template> <!-- copyright-statement//p -->

	<xsl:template match="mn:license-statement">
		<fo:block xsl:use-attribute-sets="license-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- license-statement -->

	<xsl:template match="mn:license-statement//mn:fmt-title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:block role="H{$level}" xsl:use-attribute-sets="license-statement-title-style">
			<xsl:apply-templates/>
		</fo:block>

	</xsl:template> <!-- license-statement/title -->

	<xsl:template match="mn:license-statement//mn:p">
		<fo:block xsl:use-attribute-sets="license-statement-p-style">
				<xsl:if test="following-sibling::mn:p">
					<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
				</xsl:if>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template> <!-- license-statement/p -->

	<xsl:template match="mn:legal-statement">
		<xsl:param name="isLegacy">false</xsl:param>
		<fo:block xsl:use-attribute-sets="legal-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- legal-statement -->

	<xsl:template match="mn:legal-statement//mn:fmt-title">
		<!-- ogc-white-paper rsd -->
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:block role="H{$level}" xsl:use-attribute-sets="legal-statement-title-style">
			<xsl:apply-templates/>
		</fo:block>

	</xsl:template> <!-- legal-statement/title -->

	<xsl:template match="mn:legal-statement//mn:p">
		<xsl:param name="margin"/>
		<!-- csa -->
		<fo:block xsl:use-attribute-sets="legal-statement-p-style">

			<xsl:if test="@align">
				<xsl:attribute name="text-align">
					<xsl:value-of select="@align"/>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template> <!-- legal-statement/p -->

	<xsl:template match="mn:feedback-statement">
		<fo:block xsl:use-attribute-sets="feedback-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- feedback-statement -->

	<xsl:template match="mn:feedback-statement//mn:fmt-title">
		<!-- process in the template 'title' -->
		<xsl:call-template name="title"/>
	</xsl:template>

	<xsl:template match="mn:feedback-statement//mn:p">
		<xsl:param name="margin"/>
		<!-- process in the template 'paragraph' -->
		<xsl:call-template name="paragraph">
			<xsl:with-param name="margin" select="$margin"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================= -->
	<!-- END Preface boilerplate sections processing -->
	<!-- ================================= -->

	<xsl:attribute-set name="link-style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_link-style">
	</xsl:template> <!-- refine_link-style -->

	<xsl:template match="mn:fmt-link" name="link">
		<xsl:variable name="target_normalized" select="translate(@target, '\', '/')"/>
		<xsl:variable name="target_attachment_name" select="substring-after($target_normalized, '_attachments/')"/>
		<xsl:variable name="isLinkToEmbeddedFile" select="normalize-space(@attachment = 'true' and $pdfAttachmentsList//attachment[@filename = current()/@target])"/>
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<!-- link to the PDF attachment -->
				<xsl:when test="$isLinkToEmbeddedFile = 'true'">
					<xsl:variable name="target_file" select="java:org.metanorma.fop.Util.getFilenameFromPath(@target)"/>
					<xsl:value-of select="concat('url(embedded-file:', $target_file, ')')"/>
				</xsl:when>
				<!-- <xsl:when test="starts-with($target_normalized, '_') and contains($target_normalized, '_attachments/') and $pdfAttachmentsList//attachment[@filename = $target_attachment_name]">
					<xsl:value-of select="concat('url(embedded-file:', $target_attachment_name, ')')"/>
				</xsl:when>
				<xsl:when test="contains(@target, concat('_', $inputxml_filename_prefix, '_attachments'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="target__" select="substring-after($target_, concat('_', $inputxml_filename_prefix, '_attachments', '/'))"/>
					<xsl:value-of select="concat('url(embedded-file:', $target__, ')')"/>
				</xsl:when> -->

				<!-- <xsl:when test="not(starts-with(@target, 'http:') or starts-with(@target, 'https') or starts-with(@target, 'www') or starts-with(@target, 'mailto') or starts-with(@target, 'ftp'))">
					<xsl:variable name="target_" select="translate(@target, '\', '/')"/>
					<xsl:variable name="filename">
						<xsl:call-template name="substring-after-last">
							<xsl:with-param name="value" select="$target_"/>
							<xsl:with-param name="delimiter" select="'/'"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="target_filepath" select="concat($inputxml_basepath, @target)"/>
					<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($target_filepath)))"/>
					<xsl:choose>
						<xsl:when test="$file_exists = 'true'">
							<xsl:value-of select="concat('url(embedded-file:', $filename, ')')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when> -->

				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">

			<xsl:if test="starts-with(normalize-space(@target), 'mailto:') and not(ancestor::*[local-name() = 'td'])">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isLinkToEmbeddedFile = 'true'">
				<xsl:attribute name="color">inherit</xsl:attribute>
				<xsl:attribute name="text-decoration">none</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_link-style"/>

			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="alt_text">
						<xsl:call-template name="getAltText"/>
					</xsl:variable>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link external-destination="{$target}" fox:alt-text="{$alt_text}">
								<xsl:if test="$isLinkToEmbeddedFile = 'true'">
									<xsl:attribute name="role">Annot</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space(.) = ''">
										<xsl:call-template name="add-zero-spaces-link-java">
											<xsl:with-param name="text" select="$target_text"/>
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<!-- output text from <link>text</link> -->
										<xsl:choose>
											<xsl:when test="starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.')">
												<xsl:call-template name="add-zero-spaces-link-java">
													<xsl:with-param name="text" select="."/>
												</xsl:call-template>
											</xsl:when>
											<xsl:otherwise>
												<xsl:apply-templates/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</fo:basic-link>
							<xsl:if test="$isLinkToEmbeddedFile = 'true'">
								<!-- reserve space at right for PaperClip icon -->
								<fo:inline keep-with-previous.within-line="always">        </fo:inline>
							</xsl:if>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

	<xsl:attribute-set name="sourcecode-container-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="line-height">113%</xsl:attribute>
	</xsl:attribute-set> <!-- sourcecode-style -->

	<xsl:template name="refine_sourcecode-style">
	</xsl:template> <!-- refine_sourcecode-style -->

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set> <!-- sourcecode-name-style -->

	<xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equals">(==========)</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="regex_zero-space-after-equal">(=)</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equals,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<!-- <xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template> -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),$regex_zero-space-after-equal,concat('$1',$zero_width_space))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add-zero-spaces-equal -->

	<!-- =============== -->
	<!-- sourcecode  -->
	<!-- =============== -->

	<xsl:variable name="source-highlighter-css_" select="//mn:metanorma/mn:metanorma-extension/mn:source-highlighter-css"/>
	<xsl:variable name="sourcecode_css_" select="java:org.metanorma.fop.Util.parseCSS($source-highlighter-css_)"/>
	<xsl:variable name="sourcecode_css" select="xalan:nodeset($sourcecode_css_)"/>

	<xsl:template match="*[local-name() = 'property']" mode="css">
		<xsl:attribute name="{@name}">
			<xsl:value-of select="@value"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="get_sourcecode_attributes">
		<xsl:element name="sourcecode_attributes" use-attribute-sets="sourcecode-style">
			<xsl:variable name="_font-size"><!-- inherit -->
				<xsl:choose>
					<xsl:when test="ancestor::mn:table[not(parent::mn:sourcecode[@linenums = 'true'])]">8.5</xsl:when>
					<xsl:otherwise>9.5</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::mn:note"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="$sourcecode_css//class[@name = 'sourcecode']" mode="css"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="mn:sourcecode" name="sourcecode">

		<xsl:variable name="sourcecode_attributes">
			<xsl:call-template name="get_sourcecode_attributes"/>
		</xsl:variable>

    <!-- <xsl:copy-of select="$sourcecode_css"/> -->

		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true' and (ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])">
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
			</xsl:when>

			<xsl:otherwise>
				<fo:block-container xsl:use-attribute-sets="sourcecode-container-style" role="SKIP">

					<xsl:if test="not(ancestor::mn:li) or ancestor::mn:example">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::mn:example">
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>

					<xsl:copy-of select="@id"/>

					<xsl:if test="parent::mn:note">
						<xsl:attribute name="margin-left">
							<xsl:choose>
								<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
					</xsl:if>
					<fo:block-container margin-left="0mm" role="SKIP">

						<fo:block xsl:use-attribute-sets="sourcecode-style">

							<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
								<xsl:attribute name="{local-name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>

							<xsl:call-template name="refine_sourcecode-style"/>

							<!-- remove margin between rows in the table with sourcecode line numbers -->
							<xsl:if test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::mn:tr[1]/following-sibling::mn:tr">
								<xsl:attribute name="margin-top">0pt</xsl:attribute>
								<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
							</xsl:if>

							<xsl:apply-templates select="node()[not(self::mn:fmt-name or self::mn:dl)]"/>
						</fo:block>

						<xsl:apply-templates select="mn:dl"/> <!-- Key table -->
						<xsl:apply-templates select="mn:fmt-name"/> <!-- show sourcecode's name AFTER content -->

					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:sourcecode/text() | mn:sourcecode//mn:span/text()" priority="2">
		<xsl:choose>
			<!-- disabled -->
			<xsl:when test="1 = 2 and normalize-space($syntax-highlight) = 'true' and normalize-space(../@lang) != ''"> <!-- condition for turn on of highlighting -->
				<xsl:variable name="syntax" select="java:org.metanorma.fop.Util.syntaxHighlight(., ../@lang)"/>
				<xsl:choose>
					<xsl:when test="normalize-space($syntax) != ''"><!-- if there is highlighted result -->
						<xsl:apply-templates select="xalan:nodeset($syntax)" mode="syntax_highlight"/> <!-- process span tags -->
					</xsl:when>
					<xsl:otherwise> <!-- if case of non-succesfull syntax highlight (for instance, unknown lang), process without highlighting -->
						<xsl:call-template name="add_spaces_to_sourcecode"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- add sourcecode highlighting -->
	<xsl:template match="mn:sourcecode//mn:span[@class]" priority="2">
		<xsl:variable name="class" select="@class"/>

		<!-- Example: <1> -->
		<xsl:variable name="is_callout">
			<xsl:if test="parent::mn:dt">
				<xsl:variable name="dt_id" select="../@id"/>
				<xsl:if test="ancestor::mn:sourcecode//mn:callout[@target = $dt_id]">true</xsl:if>
			</xsl:if>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$sourcecode_css//class[@name = $class]">
				<fo:inline>
					<xsl:apply-templates select="$sourcecode_css//class[@name = $class]" mode="css"/>
					<xsl:if test="$is_callout = 'true'">&lt;</xsl:if>
					<xsl:apply-templates/>
					<xsl:if test="$is_callout = 'true'">&gt;</xsl:if>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- outer table with line numbers for sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] |  -->
		<fo:block>
			<fo:table width="100%" table-layout="fixed">
				<xsl:copy-of select="@id"/>
					<fo:table-column column-width="8%"/>
					<fo:table-column column-width="92%"/>
					<fo:table-body>
						<xsl:apply-templates/>
					</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table/mn:tbody" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']/*[local-name() = 'tbody'] |  -->
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode']//*[local-name()='tr'] |  -->
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>
	<!-- first td with line numbers -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][not(preceding-sibling::*)]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block>

				<!-- set attibutes for line numbers - same as sourcecode -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:for-each select="following-sibling::*[local-name() = 'td']/mn:sourcecode">
						<xsl:call-template name="get_sourcecode_attributes"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*[not(starts-with(local-name(), 'margin-') or starts-with(local-name(), 'space-'))]">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>

				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- second td with sourcecode -->
	<xsl:template match="mn:sourcecode[@linenums = 'true']/mn:table//mn:tr/*[local-name() = 'td'][preceding-sibling::*]" priority="2"> <!-- *[local-name()='table'][@type = 'sourcecode'] -->
		<fo:table-cell>
			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- END outer table with line numbers for sourcecode -->

	<xsl:template name="add_spaces_to_sourcecode">
		<xsl:variable name="text_step1">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:variable name="text_step2">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$text_step1"/>
			</xsl:call-template>
		</xsl:variable>

		<!-- <xsl:value-of select="$text_step2"/> -->

		<!-- add zero-width space after space -->
		<xsl:variable name="text_step3" select="java:replaceAll(java:java.lang.String.new($text_step2),' ',' ​')"/>

		<!-- split text by zero-width space -->
		<xsl:variable name="text_step4">
			<xsl:call-template name="split_for_interspers">
				<xsl:with-param name="pText" select="$text_step3"/>
				<xsl:with-param name="sep" select="$zero_width_space"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:for-each select="xalan:nodeset($text_step4)/node()">
			<xsl:choose>
				<xsl:when test="local-name() = 'interspers'"> <!-- word with length more than 30 will be interspersed with zero-width space -->
					<xsl:call-template name="interspers-java">
						<xsl:with-param name="str" select="."/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

	</xsl:template> <!-- add_spaces_to_sourcecode -->

	<xsl:variable name="interspers_tag_open">###interspers123###</xsl:variable>
	<xsl:variable name="interspers_tag_close">###/interspers123###</xsl:variable>
	<!-- split string by separator for interspers -->
	<xsl:template name="split_for_interspers">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<!-- word with length more than 30 will be interspersed with zero-width space -->
		<xsl:variable name="regex" select="concat('([^', $zero_width_space, ']{31,})')"/> <!-- sequence of characters (more 31), that doesn't contains zero-width space -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new($pText),$regex,concat($interspers_tag_open,'$1',$interspers_tag_close))"/>
		<xsl:call-template name="replace_tag_interspers">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template> <!-- end: split string by separator for interspers -->

	<xsl:template name="replace_tag_interspers">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $interspers_tag_open)">
				<xsl:value-of select="substring-before($text, $interspers_tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $interspers_tag_open)"/>
				<interspers>
					<xsl:value-of select="substring-before($text_after, $interspers_tag_close)"/>
				</interspers>
				<xsl:call-template name="replace_tag_interspers">
					<xsl:with-param name="text" select="substring-after($text_after, $interspers_tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="interspers-java">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($str),'([^ -.:=_—])',concat('$1', $char))"/> <!-- insert $char after each char excep space, - . : = _ etc. -->
	</xsl:template>

	<xsl:template match="*" mode="syntax_highlight">
		<xsl:apply-templates mode="syntax_highlight"/>
	</xsl:template>

	<xsl:variable name="syntax_highlight_styles_">
		<style class="hljs-addition" xsl:use-attribute-sets="hljs-addition"/>
		<style class="hljs-attr" xsl:use-attribute-sets="hljs-attr"/>
		<style class="hljs-attribute" xsl:use-attribute-sets="hljs-attribute"/>
		<style class="hljs-built_in" xsl:use-attribute-sets="hljs-built_in"/>
		<style class="hljs-bullet" xsl:use-attribute-sets="hljs-bullet"/>
		<style class="hljs-char_and_escape_" xsl:use-attribute-sets="hljs-char_and_escape_"/>
		<style class="hljs-code" xsl:use-attribute-sets="hljs-code"/>
		<style class="hljs-comment" xsl:use-attribute-sets="hljs-comment"/>
		<style class="hljs-deletion" xsl:use-attribute-sets="hljs-deletion"/>
		<style class="hljs-doctag" xsl:use-attribute-sets="hljs-doctag"/>
		<style class="hljs-emphasis" xsl:use-attribute-sets="hljs-emphasis"/>
		<style class="hljs-formula" xsl:use-attribute-sets="hljs-formula"/>
		<style class="hljs-keyword" xsl:use-attribute-sets="hljs-keyword"/>
		<style class="hljs-link" xsl:use-attribute-sets="hljs-link"/>
		<style class="hljs-literal" xsl:use-attribute-sets="hljs-literal"/>
		<style class="hljs-meta" xsl:use-attribute-sets="hljs-meta"/>
		<style class="hljs-meta_hljs-string" xsl:use-attribute-sets="hljs-meta_hljs-string"/>
		<style class="hljs-meta_hljs-keyword" xsl:use-attribute-sets="hljs-meta_hljs-keyword"/>
		<style class="hljs-name" xsl:use-attribute-sets="hljs-name"/>
		<style class="hljs-number" xsl:use-attribute-sets="hljs-number"/>
		<style class="hljs-operator" xsl:use-attribute-sets="hljs-operator"/>
		<style class="hljs-params" xsl:use-attribute-sets="hljs-params"/>
		<style class="hljs-property" xsl:use-attribute-sets="hljs-property"/>
		<style class="hljs-punctuation" xsl:use-attribute-sets="hljs-punctuation"/>
		<style class="hljs-quote" xsl:use-attribute-sets="hljs-quote"/>
		<style class="hljs-regexp" xsl:use-attribute-sets="hljs-regexp"/>
		<style class="hljs-section" xsl:use-attribute-sets="hljs-section"/>
		<style class="hljs-selector-attr" xsl:use-attribute-sets="hljs-selector-attr"/>
		<style class="hljs-selector-class" xsl:use-attribute-sets="hljs-selector-class"/>
		<style class="hljs-selector-id" xsl:use-attribute-sets="hljs-selector-id"/>
		<style class="hljs-selector-pseudo" xsl:use-attribute-sets="hljs-selector-pseudo"/>
		<style class="hljs-selector-tag" xsl:use-attribute-sets="hljs-selector-tag"/>
		<style class="hljs-string" xsl:use-attribute-sets="hljs-string"/>
		<style class="hljs-strong" xsl:use-attribute-sets="hljs-strong"/>
		<style class="hljs-subst" xsl:use-attribute-sets="hljs-subst"/>
		<style class="hljs-symbol" xsl:use-attribute-sets="hljs-symbol"/>
		<style class="hljs-tag" xsl:use-attribute-sets="hljs-tag"/>
		<!-- <style class="hljs-tag_hljs-attr" xsl:use-attribute-sets="hljs-tag_hljs-attr"></style> -->
		<!-- <style class="hljs-tag_hljs-name" xsl:use-attribute-sets="hljs-tag_hljs-name"></style> -->
		<style class="hljs-template-tag" xsl:use-attribute-sets="hljs-template-tag"/>
		<style class="hljs-template-variable" xsl:use-attribute-sets="hljs-template-variable"/>
		<style class="hljs-title" xsl:use-attribute-sets="hljs-title"/>
		<style class="hljs-title_and_class_" xsl:use-attribute-sets="hljs-title_and_class_"/>
		<style class="hljs-title_and_class__and_inherited__" xsl:use-attribute-sets="hljs-title_and_class__and_inherited__"/>
		<style class="hljs-title_and_function_" xsl:use-attribute-sets="hljs-title_and_function_"/>
		<style class="hljs-type" xsl:use-attribute-sets="hljs-type"/>
		<style class="hljs-variable" xsl:use-attribute-sets="hljs-variable"/>
		<style class="hljs-variable_and_language_" xsl:use-attribute-sets="hljs-variable_and_language_"/>
	</xsl:variable>
	<xsl:variable name="syntax_highlight_styles" select="xalan:nodeset($syntax_highlight_styles_)"/>

	<xsl:template match="span" mode="syntax_highlight" priority="2">
		<!-- <fo:inline color="green" font-style="italic"><xsl:apply-templates mode="syntax_highlight"/></fo:inline> -->
		<fo:inline>
			<xsl:variable name="classes_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@class"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
				<!-- a few classes together (_and_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-char') and contains(@class, 'escape_')">
					<item>hljs-char_and_escape_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_')">
					<item>hljs-title_and_class_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'class_') and contains(@class, 'inherited__')">
					<item>hljs-title_and_class__and_inherited__</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-title') and contains(@class, 'function_')">
					<item>hljs-title_and_function_</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-variable') and contains(@class, 'language_')">
					<item>hljs-variable_and_language_</item>
				</xsl:if>
				<!-- with parent classes (_ suffix) -->
				<xsl:if test="contains(@class, 'hljs-keyword') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-keyword</item>
				</xsl:if>
				<xsl:if test="contains(@class, 'hljs-string') and contains(ancestor::*/@class, 'hljs-meta')">
					<item>hljs-meta_hljs-string</item>
				</xsl:if>
			</xsl:variable>
			<xsl:variable name="classes" select="xalan:nodeset($classes_)"/>

			<xsl:for-each select="$classes/*[local-name() = 'item']">
				<xsl:variable name="class_name" select="."/>
				<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
					<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
				</xsl:for-each>
			</xsl:for-each>

			<!-- <xsl:variable name="class_name">
				<xsl:choose>
					<xsl:when test="@class = 'hljs-attr' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-attr</xsl:when>
					<xsl:when test="@class = 'hljs-name' and ancestor::*/@class = 'hljs-tag'">hljs-tag_hljs-name</xsl:when>
					<xsl:when test="@class = 'hljs-string' and ancestor::*/@class = 'hljs-meta'">hljs-meta_hljs-string</xsl:when>
					<xsl:otherwise><xsl:value-of select="@class"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each select="$syntax_highlight_styles/style[@class = $class_name]/@*[not(local-name() = 'class')]">
				<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each> -->

		<xsl:apply-templates mode="syntax_highlight"/></fo:inline>
	</xsl:template>

	<xsl:template match="text()" mode="syntax_highlight" priority="2">
		<xsl:call-template name="add_spaces_to_sourcecode"/>
	</xsl:template>

	<!-- end mode="syntax_highlight" -->

	<xsl:template match="mn:sourcecode/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- =============== -->
	<!-- END sourcecode  -->
	<!-- =============== -->

	<xsl:template match="mn:callout">
		<xsl:choose>
			<xsl:when test="normalize-space(@target) = ''">&lt;<xsl:apply-templates/>&gt;</xsl:when>
			<xsl:otherwise><fo:basic-link internal-destination="{@target}" fox:alt-text="{normalize-space()}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:callout-annotation">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>
		<fo:block id="{$annotation-id}" white-space="nowrap">
			<fo:inline>
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:callout-annotation/mn:p">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<xsl:call-template name="setNamedDestination"/>
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::mn:p)"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- pre, strong, em, underline -->

	<!-- ========================= -->
	<!-- Rich text formatting -->
	<!-- ========================= -->

	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="line-height">113%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="tt-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
	</xsl:attribute-set>

	<xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="add-style">
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<!-- <xsl:attribute name="color">black</xsl:attribute>
				<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				<xsl:attribute name="padding-top">1mm</xsl:attribute>
				<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:variable name="add-style">
			<add-style xsl:use-attribute-sets="add-style"/>
		</xsl:variable>
	<xsl:template name="append_add-style">
		<xsl:copy-of select="xalan:nodeset($add-style)/add-style/@*"/>
	</xsl:template>

	<xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable>
	<xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="mn:br">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

		<xsl:template match="mn:em">
		<fo:inline font-style="italic">
			<xsl:call-template name="refine_italic_style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_italic_style">
	</xsl:template>

	<xsl:template match="mn:strong | *[local-name()='b']">
		<xsl:param name="split_keep-within-line"/>
		<fo:inline font-weight="bold">

			<xsl:call-template name="refine_strong_style"/>

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:inline>
	</xsl:template>

	<xsl:template name="refine_strong_style">
		<xsl:if test="ancestor::*['preferred']">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}"> </fo:inline>
	</xsl:template>

	<xsl:template match="mn:sup">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:sub">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:tt">
		<fo:inline xsl:use-attribute-sets="tt-style">

			<xsl:variable name="_font-size"> <!-- inherit -->
				<xsl:choose>
					<xsl:when test="ancestor::mn:table">8.5</xsl:when>
					<xsl:otherwise>9.5</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::mn:note or ancestor::mn:example"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template> <!-- tt -->

	<xsl:variable name="regex_url_start">^(http://|https://|www\.)?(.*)</xsl:variable>
	<xsl:template match="mn:tt/text()" priority="2">
		<xsl:choose>
			<xsl:when test="java:replaceAll(java:java.lang.String.new(.), $regex_url_start, '$2') != ''">
				 <!-- url -->
				<xsl:call-template name="add-zero-spaces-link-java"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:underline">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ================= -->
	<!-- Added,deleted text -->
	<!-- ================= -->
	<xsl:template match="mn:add | mn:change-open-tag | mn:change-close-tag" name="tag_add">
		<xsl:param name="skip">true</xsl:param>
		<xsl:param name="block">false</xsl:param>
		<xsl:param name="type"/>
		<xsl:param name="text-align"/>
		<xsl:choose>
			<xsl:when test="starts-with(., $ace_tag) or self::mn:change-open-tag or self::mn:change-close-tag"> <!-- examples: ace-tag_A1_start, ace-tag_A2_end, C1_start, AC_start, or
							<change-open-tag>A<sub>1</sub></change-open-tag>, <change-close-tag>A<sub>1</sub></change-close-tag> -->
				<xsl:choose>
					<xsl:when test="$skip = 'true' and       ((local-name(../..) = 'note' and not(preceding-sibling::node())) or       (parent::mn:fmt-title and preceding-sibling::node()[1][self::mn:tab]) or      local-name(..) = 'formattedref' and not(preceding-sibling::node()))      and       ../node()[last()][self::mn:add][starts-with(text(), $ace_tag)]"><!-- start tag displayed in template name="note" and title --></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="tag">
							<xsl:call-template name="insertTag">
								<xsl:with-param name="type">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag">start</xsl:when>
										<xsl:when test="self::mn:change-close-tag">end</xsl:when>
										<xsl:when test="$type = ''"><xsl:value-of select="substring-after(substring-after(., $ace_tag), '_')"/> <!-- start or end --></xsl:when>
										<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="kind">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 1, 1)"/> <!-- A or C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="value">
									<xsl:choose>
										<xsl:when test="self::mn:change-open-tag or self::mn:change-close-tag">
											<xsl:value-of select="mn:sub"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="substring(substring-before(substring-after(., $ace_tag), '_'), 2)"/> <!-- 1, 2, C -->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$block = 'false'">
								<fo:inline>
									<xsl:copy-of select="$tag"/>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<fo:block> <!-- for around figures -->
									<xsl:if test="$text-align != ''">
										<xsl:attribute name="text-align"><xsl:value-of select="$text-align"/></xsl:attribute>
									</xsl:if>
									<xsl:copy-of select="$tag"/>
								</fo:block>
							</xsl:otherwise>
						</xsl:choose>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- add -->

	<xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20"/>
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-10%"><!-- alignment-baseline="middle" -->
				<xsl:attribute name="height">3.5mm</xsl:attribute> <!-- 5mm -->
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<!-- <svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg> -->
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing' or $type = 'end'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,2.5 {$maxwidth},2.5 {$maxwidth + 20},40 {$maxwidth},77.5 0,77.5" stroke="black" stroke-width="5" fill="white"/>
						<line x1="9.5" y1="0" x2="9.5" y2="80" stroke="black" stroke-width="19"/>
					</g>
					<xsl:variable name="text_x">
						<xsl:choose>
							<xsl:when test="$type = 'closing' or $type = 'end'">28</xsl:when>
							<xsl:otherwise>22</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<text font-family="Arial" x="{$text_x}" y="50" font-size="40pt">
						<xsl:value-of select="$kind"/>
					</text>
					<text font-family="Arial" x="{$text_x + 33}" y="65" font-size="38pt">
						<xsl:value-of select="$value"/>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template match="mn:del">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ================= -->
	<!-- END Added,deleted text -->
	<!-- ================= -->

	<!-- highlight text -->
	<xsl:template match="mn:hi | mn:span[@class = 'fmt-hi']" priority="3">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="text()[ancestor::mn:smallcap]" name="smallcaps">
		<xsl:param name="txt"/>
		<!-- <xsl:variable name="text" select="normalize-space(.)"/> --> <!-- https://github.com/metanorma/metanorma-iso/issues/1115 -->
		<xsl:variable name="text">
			<xsl:choose>
				<xsl:when test="$txt != ''">
					<xsl:value-of select="$txt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ratio_">0.75
		</xsl:variable>
		<xsl:variable name="ratio" select="number(normalize-space($ratio_))"/>
		<fo:inline font-size="{$ratio * 100}%" role="SKIP">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:variable name="smallCapsText">
						<xsl:call-template name="recursiveSmallCaps">
							<xsl:with-param name="text" select="$text"/>
							<xsl:with-param name="ratio" select="$ratio"/>
						</xsl:call-template>
					</xsl:variable>
					<!-- merge neighboring fo:inline -->
					<xsl:for-each select="xalan:nodeset($smallCapsText)/node()">
						<xsl:choose>
							<xsl:when test="self::fo:inline and preceding-sibling::node()[1][self::fo:inline]"><!-- <xsl:copy-of select="."/> --></xsl:when>
							<xsl:when test="self::fo:inline and @font-size">
								<xsl:variable name="curr_pos" select="count(preceding-sibling::node()) + 1"/>
								<!-- <curr_pos><xsl:value-of select="$curr_pos"/></curr_pos> -->
								<xsl:variable name="next_text_" select="count(following-sibling::node()[not(local-name() = 'inline')][1]/preceding-sibling::node())"/>
								<xsl:variable name="next_text">
									<xsl:choose>
										<xsl:when test="$next_text_ = 0">99999999</xsl:when>
										<xsl:otherwise><xsl:value-of select="$next_text_ + 1"/></xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<!-- <next_text><xsl:value-of select="$next_text"/></next_text> -->
								<fo:inline>
									<xsl:copy-of select="@*"/>
									<xsl:copy-of select="./node()"/>
									<xsl:for-each select="following-sibling::node()[position() &lt; $next_text - $curr_pos]"> <!-- [self::fo:inline] -->
										<xsl:copy-of select="./node()"/>
									</xsl:for-each>
								</fo:inline>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:if>
			</fo:inline>
	</xsl:template>

	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:param name="ratio">0.75</xsl:param>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div $ratio}%" role="SKIP">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
        <xsl:with-param name="ratio" select="$ratio"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

	<xsl:template match="mn:strike">
		<fo:inline text-decoration="line-through">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- Example: <span style="font-family:&quot;Noto Sans JP&quot;">styled text</span> -->
	<xsl:template match="mn:span[@style]" priority="2">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value_" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:variable name="value">
					<xsl:choose>
						<!-- if font-size is digits only -->
						<xsl:when test="$key = 'font-size' and translate($value_, '0123456789', '') = ''"><xsl:value-of select="$value_"/>pt</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$value_"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="$key = 'font-family' or $key = 'font-size' or $key = 'color' or $key = 'baseline-shift'">
					<style name="{$key}"><xsl:value-of select="$value"/></style>
				</xsl:if>
				<xsl:if test="$key = 'text-indent'">
					<style name="padding-left"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:choose>
			<xsl:when test="$styles/style">
				<fo:inline>
					<xsl:for-each select="$styles/style">
						<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- END: span[@style] -->

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Don't break standard's numbers -->
	<!-- Example : <span class="stdpublisher">ISO</span> <span class="stddocNumber">10303</span>-<span class="stddocPartNumber">1</span>:<span class="stdyear">1994</span> -->
	<xsl:template match="mn:span[@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']" priority="2">
		<xsl:choose>
			<xsl:when test="ancestor::mn:table"><xsl:apply-templates/></xsl:when>
			<xsl:when test="following-sibling::*[2][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']">
				<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="text()[not(ancestor::mn:table) and preceding-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear'] and   following-sibling::*[1][self::mn:span][@class = 'stdpublisher' or @class = 'stddocNumber' or @class = 'stddocPartNumber' or @class = 'stdyear']]" priority="2">
		<fo:inline keep-with-next.within-line="always" role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:span[contains(@style, 'text-transform:none')]//text()" priority="5">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:pre" name="pre">
		<fo:block xsl:use-attribute-sets="pre-style">
			<xsl:copy-of select="@id"/>
			<xsl:choose>

				<xsl:when test="ancestor::mn:sourcecode[@linenums = 'true'] and ancestor::*[local-name() = 'td'][1][not(preceding-sibling::*)]"> <!-- pre in the first td in the table with @linenums = 'true' -->
					<xsl:if test="ancestor::mn:tr[1]/following-sibling::mn:tr"> <!-- is current tr isn't last -->
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<fo:instream-foreign-object fox:alt-text="{.}" content-width="95%">
						<math xmlns="http://www.w3.org/1998/Math/MathML">
							<mtext><xsl:value-of select="."/></mtext>
						</math>
					</fo:instream-foreign-object>
				</xsl:when>

				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>

			</xsl:choose>
		</fo:block>
	</xsl:template> <!-- pre -->

	<!-- ========================= -->
	<!-- END Rich text formatting -->
	<!-- ========================= -->

	<xsl:attribute-set name="permission-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
		<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="permission-label-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
		<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="requirement-label-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="subject-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="inherit-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="description-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="specification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="measurement-target-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="verification-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="import-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="component-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
		<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="recommendation-label-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<!-- ========== -->
	<!-- permission -->
	<!-- ========== -->
	<xsl:template match="mn:permission">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:permission/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>
					<xsl:text>:</xsl:text>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:permission/mn:label">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement -->
	<!-- ========== -->
	<xsl:template match="mn:requirement">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="mn:label"/>
			<xsl:apply-templates select="@obligation"/>
			<xsl:apply-templates select="mn:subject"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:label) and not(self::mn:subject)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">

			<fo:block xsl:use-attribute-sets="requirement-name-style">
					<xsl:if test="../@type = 'class'">
						<xsl:attribute name="background-color">white</xsl:attribute>
					</xsl:if>
				<xsl:apply-templates/>
					<xsl:text>:</xsl:text>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:label">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/@obligation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>

	<xsl:template match="mn:requirement/mn:subject" priority="2">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="mn:recommendation">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:recommendation/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">

			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:recommendation/mn:label">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END recommendation -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- ========== -->

	<xsl:template match="mn:subject">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:div">
		<fo:block><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="mn:inherit | mn:component[@class = 'inherit'] |           mn:div[@type = 'requirement-inherit'] |           mn:div[@type = 'recommendation-inherit'] |           mn:div[@type = 'permission-inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:description | mn:component[@class = 'description'] |           mn:div[@type = 'requirement-description'] |           mn:div[@type = 'recommendation-description'] |           mn:div[@type = 'permission-description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:specification | mn:component[@class = 'specification'] |           mn:div[@type = 'requirement-specification'] |           mn:div[@type = 'recommendation-specification'] |           mn:div[@type = 'permission-specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:measurement-target | mn:component[@class = 'measurement-target'] |           mn:div[@type = 'requirement-measurement-target'] |           mn:div[@type = 'recommendation-measurement-target'] |           mn:div[@type = 'permission-measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:verification | mn:component[@class = 'verification'] |           mn:div[@type = 'requirement-verification'] |           mn:div[@type = 'recommendation-verification'] |           mn:div[@type = 'permission-verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:import | mn:component[@class = 'import'] |           mn:div[@type = 'requirement-import'] |           mn:div[@type = 'recommendation-import'] |           mn:div[@type = 'permission-import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:div[starts-with(@type, 'requirement-component')] |           mn:div[starts-with(@type, 'recommendation-component')] |           mn:div[starts-with(@type, 'permission-component')]">
		<fo:block xsl:use-attribute-sets="component-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END  -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement, recommendation, permission table -->
	<!-- ========== -->
	<xsl:template match="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt" role="SKIP">
			<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setNamedDestination"/>
			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">
						<xsl:call-template name="getSimpleTable">
							<xsl:with-param name="id" select="@id"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//mn:tr[1]/mn:td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//mn:fn">
					<xsl:for-each select="mn:tbody">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="table_fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name()='thead']" mode="requirement">
		<fo:table-header>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="requirement">
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">

			<xsl:if test="parent::*[local-name()='thead'] or starts-with(*[local-name()='td' or local-name()='th'][1], 'Requirement ') or starts-with(*[local-name()='td' or local-name()='th'][1], 'Recommendation ')">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
				<xsl:attribute name="font-weight">normal</xsl:attribute>
				<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']) -->
					<xsl:attribute name="background-color"><xsl:value-of select="$color_table_header_row"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
					<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
				</xsl:if>
				<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
					<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block role="SKIP">
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="mn:p[@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt">
			<!-- <xsl:attribute name="color"><xsl:value-of select="$color_design"/></xsl:attribute> -->
			<xsl:attribute name="color">white</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p2'][ancestor::mn:table[@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END requirement, recommendation, permission table -->
	<!-- ========== -->

	<xsl:attribute-set name="term-style">
	</xsl:attribute-set> <!-- term-style -->

	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- term-name-style -->

		<xsl:attribute-set name="preferred-block-style">
	</xsl:attribute-set> <!-- preferred-block-style -->

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="line-height">1</xsl:attribute>
	</xsl:attribute-set> <!-- preferred-term-style -->

	<xsl:attribute-set name="domain-style">
	</xsl:attribute-set> <!-- domain-style -->

	<xsl:attribute-set name="admitted-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
	</xsl:attribute-set> <!-- admitted-style -->

	<xsl:attribute-set name="deprecates-style">
	</xsl:attribute-set> <!-- deprecates-style -->

	<xsl:attribute-set name="related-block-style" use-attribute-sets="preferred-block-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="definition-style">
		<xsl:attribute name="space-after">6pt</xsl:attribute>
	</xsl:attribute-set> <!-- definition-style -->

	<xsl:attribute-set name="termsource-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set> <!-- termsource-style -->

	<xsl:template name="refine_termsource-style">
	</xsl:template> <!-- refine_termsource-style -->

	<xsl:attribute-set name="termsource-text-style">
	</xsl:attribute-set> <!-- termsource-text-style -->

	<xsl:attribute-set name="origin-style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set> <!-- origin-style -->

	<!-- ====== -->
	<!-- term      -->
	<!-- ====== -->

	<xsl:template match="mn:terms">
		<!-- <xsl:message>'terms' <xsl:number/> processing...</xsl:message> -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:term">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">

			<xsl:if test="parent::mn:term and not(preceding-sibling::mn:term)">
			</xsl:if>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:term/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates />
			</fo:inline> -->
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- termsource -->
	<!-- origin -->
	<!-- modification -->
	<!-- ====== -->
	<xsl:template match="mn:fmt-termsource" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">

			<xsl:call-template name="refine_termsource-style"/>

			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			<xsl:copy-of select="$termsource_text"/>
			<!-- <xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>{</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>[</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(mn:origin/@citeas, '[')"><xsl:text>}</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>]</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose> -->
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource/text()[starts-with(., '[SOURCE: Adapted from: ') or     starts-with(., '[SOURCE: Quoted from: ') or     starts-with(., '[SOURCE: Modified from: ')]" priority="2">
		<xsl:text>[</xsl:text><xsl:value-of select="substring-after(., '[SOURCE: ')"/>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<!-- text SOURCE: -->
	<xsl:template match="mn:fmt-termsource/mn:strong[1][following-sibling::*[1][self::mn:fmt-origin]]/text()">
		<fo:inline xsl:use-attribute-sets="termsource-text-style">
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-origin">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
					<xsl:if test="normalize-space(@citeas) = ''">
						<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
					</xsl:if>
					<fo:inline xsl:use-attribute-sets="origin-style">
						<xsl:apply-templates/>
					</fo:inline>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- not using, see https://github.com/glossarist/iev-document/issues/23 -->
	<xsl:template match="mn:modification">
		<xsl:variable name="title-modified">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">modified</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="text"><xsl:apply-templates/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text>—</xsl:text></xsl:if></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:if test="normalize-space($text) != ''"><xsl:text> — </xsl:text></xsl:if></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:modification/mn:p">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:modification/text()">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:value-of select="."/> -->
			<xsl:call-template name="text"/>
		</xsl:if>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- Preferred, admitted, deprecated -->
	<xsl:template match="mn:fmt-preferred">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>

		</xsl:variable>
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block font-size="{normalize-space($font-size)}" role="H{$levelTerm}" xsl:use-attribute-sets="preferred-block-style">

			<xsl:if test="parent::mn:term and not(preceding-sibling::mn:fmt-preferred)"> <!-- if first preffered in term, then display term's name -->

				<fo:block xsl:use-attribute-sets="term-name-style" role="SKIP">

					<xsl:for-each select="ancestor::mn:term[1]/mn:fmt-name"><!-- change context -->
						<xsl:call-template name="setIDforNamedDestination"/>
					</xsl:for-each>

					<xsl:apply-templates select="ancestor::mn:term[1]/mn:fmt-name"/>
				</fo:block>
			</xsl:if>

			<fo:block xsl:use-attribute-sets="preferred-term-style" role="SKIP">
				<xsl:call-template name="setStyle_preferred"/>

				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- <xsl:template match="mn:domain"> -->
		<!-- https://github.com/metanorma/isodoc/issues/607 
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text> -->
		<!-- <xsl:if test="not(@hidden = 'true')">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template> -->

	<!-- https://github.com/metanorma/isodoc/issues/632#issuecomment-2567163931 -->
	<xsl:template match="mn:domain"/>

	<xsl:template match="mn:fmt-admitted">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-deprecates">
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="setStyle_preferred">
		<xsl:if test="mn:strong">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- regarding ISO 10241-1:2011,  If there is more than one preferred term, each preferred term follows the previous one on a new line. -->
	<!-- in metanorma xml preferred terms delimited by semicolons -->
	<xsl:template match="mn:fmt-preferred/text()[contains(., ';')] | mn:fmt-preferred/mn:strong/text()[contains(., ';')]">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), ';', $linebreak)"/>
	</xsl:template>
	<!--  End Preferred, admitted, deprecated -->

	<xsl:template match="mn:fmt-related">
		<fo:block role="SKIP" xsl:use-attribute-sets="related-block-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="mn:fmt-related/mn:p" priority="4">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="mn:fmt-definition">
		<fo:block xsl:use-attribute-sets="definition-style" role="SKIP">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:fmt-definition[preceding-sibling::mn:domain]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="mn:fmt-definition[preceding-sibling::mn:domain]/mn:p[1]">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block/>
	</xsl:template>
	<!-- ========== -->
	<!-- END definition -->
	<!-- ========== -->

	<xsl:template match="mn:definitions">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:attribute-set name="termexample-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- termexample-style -->

	<xsl:template name="refine_termexample-style">
	</xsl:template> <!-- refine_termexample-style -->

	<xsl:attribute-set name="termexample-name-style">
		<xsl:attribute name="padding-right">10mm</xsl:attribute>
	</xsl:attribute-set> <!-- termexample-name-style -->

	<xsl:template name="refine_termexample-name-style">
	</xsl:template>

	<xsl:attribute-set name="example-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
		<xsl:attribute name="margin-right">12.5mm</xsl:attribute>
	</xsl:attribute-set> <!-- example-style -->

	<xsl:template name="refine_example-style">
	</xsl:template> <!-- refine_example-style -->

	<xsl:attribute-set name="example-body-style">
	</xsl:attribute-set> <!-- example-body-style -->

	<xsl:attribute-set name="example-name-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:template name="refine_example-name-style">
	</xsl:template>

	<xsl:attribute-set name="example-p-style">
		<xsl:attribute name="margin-bottom">14pt</xsl:attribute>

	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:template name="refine_example-p-style">
	</xsl:template> <!-- refine_example-p-style -->

	<!-- ====== -->
	<!-- termexample -->
	<!-- ====== -->
	<xsl:template match="mn:termexample">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">
			<xsl:call-template name="refine_termexample-style"/>
			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:apply-templates select="mn:fmt-name"/>
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:termexample/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:call-template name="refine_termexample-name-style"/>
				<xsl:apply-templates/> <!-- commented $namespace = 'ieee', https://github.com/metanorma/isodoc/issues/614-->
			</fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termexample/mn:p">
		<xsl:variable name="element">inline

		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($element, 'block')">
				<fo:block xsl:use-attribute-sets="example-p-style">

					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- example -->
	<!-- ====== -->

	<!-- There are a few cases:
	1. EXAMPLE text
	2. EXAMPLE
	        text
	3. EXAMPLE text line 1
	     text line 2
	4. EXAMPLE
	     text line 1
			 text line 2
	-->
	<xsl:template match="mn:example" name="example">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_example-style"/>

			<xsl:variable name="fo_element">
				<xsl:if test=".//mn:table or .//mn:dl or *[not(self::mn:fmt-name)][1][self::mn:sourcecode]">block</xsl:if>block
			</xsl:variable>

			<fo:block-container margin-left="0mm" role="SKIP">

				<xsl:choose>

					<xsl:when test="contains(normalize-space($fo_element), 'block')">

						<!-- display name 'EXAMPLE' in a separate block  -->
						<fo:block>
							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
						</fo:block>

						<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
							<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
								<xsl:variable name="example_body">
									<xsl:apply-templates select="node()[not(self::mn:fmt-name)]">
										<xsl:with-param name="fo_element" select="$fo_element"/>
									</xsl:apply-templates>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="xalan:nodeset($example_body)/*">
										<xsl:copy-of select="$example_body"/>
									</xsl:when>
									<xsl:otherwise><fo:block/><!-- prevent empty block-container --></xsl:otherwise>
								</xsl:choose>
							</fo:block-container>
						</fo:block-container>
					</xsl:when> <!-- end block -->

					<xsl:when test="contains(normalize-space($fo_element), 'list')">

						<xsl:variable name="provisional_distance_between_starts_">7
						</xsl:variable>
						<xsl:variable name="provisional_distance_between_starts" select="normalize-space($provisional_distance_between_starts_)"/>
						<xsl:variable name="indent_">0
						</xsl:variable>
						<xsl:variable name="indent" select="normalize-space($indent_)"/>

						<fo:list-block provisional-distance-between-starts="{$provisional_distance_between_starts}mm">
							<fo:list-item>
								<fo:list-item-label start-indent="{$indent}mm" end-indent="label-end()">
									<fo:block>
										<xsl:apply-templates select="mn:fmt-name">
											<xsl:with-param name="fo_element">block</xsl:with-param>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-label>
								<fo:list-item-body start-indent="body-start()">
									<fo:block>
										<xsl:apply-templates select="node()[not(self::mn:fmt-name)]">
											<xsl:with-param name="fo_element" select="$fo_element"/>
										</xsl:apply-templates>
									</fo:block>
								</fo:list-item-body>
							</fo:list-item>
						</fo:list-block>
					</xsl:when> <!-- end list -->

					<xsl:otherwise> <!-- inline -->

						<!-- display 'EXAMPLE' and first element in the same line -->
						<fo:block>
							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
							<fo:inline>
								<xsl:apply-templates select="*[not(self::mn:fmt-name)][1]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>

						<xsl:if test="*[not(self::mn:fmt-name)][position() &gt; 1]">
							<!-- display further elements in blocks -->
							<fo:block-container xsl:use-attribute-sets="example-body-style" role="SKIP">
								<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
									<xsl:apply-templates select="*[not(self::mn:fmt-name)][position() &gt; 1]">
										<xsl:with-param name="fo_element" select="'block'"/>
									</xsl:apply-templates>
								</fo:block-container>
							</fo:block-container>
						</xsl:if>
					</xsl:otherwise> <!-- end inline -->

				</xsl:choose>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<!-- example/name -->
	<xsl:template match="mn:example/mn:fmt-name">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:choose>
			<xsl:when test="ancestor::mn:appendix">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($fo_element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:call-template name="refine_example-name-style"/>
					<xsl:apply-templates/> <!-- $namespace = 'ieee', see https://github.com/metanorma/isodoc/issues/614  -->
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- table/example/name, table/tfoot//example/name -->
	<xsl:template match="mn:table/mn:example/mn:fmt-name |  mn:table/mn:tfoot//mn:example/mn:fmt-name">
		<fo:inline xsl:use-attribute-sets="example-name-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:example/mn:p">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			<xsl:value-of select="$fo_element"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space($element), 'block')">
				<fo:block-container role="SKIP">
					<xsl:if test="ancestor::mn:li and contains(normalize-space($fo_element), 'block')">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="example-p-style">

						<xsl:call-template name="refine_example-p-style"/>

						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="starts-with(normalize-space($element), 'list')">
				<fo:block xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- example/p -->

	<!-- ====== -->
	<!-- ====== -->

	<!-- ========================== -->
	<!-- Table styles -->
	<!-- ========================== -->
	<xsl:variable name="table-border_">
	</xsl:variable>
	<xsl:variable name="table-border" select="normalize-space($table-border_)"/>

	<xsl:variable name="table-cell-border_">
	</xsl:variable>
	<xsl:variable name="table-cell-border" select="normalize-space($table-cell-border_)"/>

	<xsl:attribute-set name="table-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="space-after">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- table-container-style -->

	<xsl:template name="refine_table-container-style">
		<xsl:param name="margin-side"/>
		<!-- end table block-container attributes -->
	</xsl:template> <!-- refine_table-container-style -->

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>
	</xsl:attribute-set><!-- table-style -->

	<xsl:template name="refine_table-style">
		<xsl:param name="margin-side"/>

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-style -->

	<xsl:attribute-set name="table-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="margin-top">0pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set> <!-- table-name-style -->

	<xsl:template name="refine_table-name-style">
		<xsl:param name="continued"/>
		<xsl:if test="$continued = 'true'">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- refine_table-name-style -->

	<xsl:attribute-set name="table-row-style">
		<xsl:attribute name="min-height">4mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-header-row-style" use-attribute-sets="table-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_table-header-row-style">

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-header-row-style -->

	<xsl:attribute-set name="table-footer-row-style" use-attribute-sets="table-row-style">
	</xsl:attribute-set>

	<xsl:template name="refine_table-footer-row-style">
	</xsl:template> <!-- refine_table-footer-row-style -->

	<xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:template name="refine_table-body-row-style">

		<xsl:call-template name="setBordersTableArray"/>
	</xsl:template> <!-- refine_table-body-row-style -->

	<xsl:attribute-set name="table-header-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="padding">1mm</xsl:attribute>
		<xsl:attribute name="background-color">rgb(0, 51, 102)</xsl:attribute>
		<xsl:attribute name="color">white</xsl:attribute>
		<xsl:attribute name="border">solid 0.5pt rgb(153, 153, 153)</xsl:attribute>
		<xsl:attribute name="height">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- table-header-cell-style -->

	<xsl:template name="refine_table-header-cell-style">

		<xsl:call-template name="setBordersTableArray"/>

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setTableCellAttributes"/>
	</xsl:template> <!-- refine_table-header-cell-style -->

	<xsl:attribute-set name="table-cell-style">
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
		<xsl:attribute name="border">solid 0.5pt rgb(153, 153, 153)</xsl:attribute>
		<xsl:attribute name="height">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- table-cell-style -->

	<xsl:template name="refine_table-cell-style">

		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="padding-right">1mm</xsl:attribute>
		</xsl:if>

		<xsl:call-template name="setBordersTableArray"/>

	</xsl:template> <!-- refine_table-cell-style -->

	<xsl:attribute-set name="table-footer-cell-style">
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
	</xsl:attribute-set> <!-- table-footer-cell-style -->

	<xsl:template name="refine_table-footer-cell-style">
	</xsl:template> <!-- refine_table-footer-cell-style -->

	<xsl:attribute-set name="table-note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set><!-- table-note-style -->

	<xsl:template name="refine_table-note-style">
	</xsl:template> <!-- refine_table-note-style -->

	<xsl:attribute-set name="table-fn-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- table-fn-style -->

	<xsl:template name="refine_table-fn-style">
	</xsl:template>

	<xsl:attribute-set name="table-fn-number-style">
		<!-- <xsl:attribute name="padding-right">5mm</xsl:attribute> -->
	</xsl:attribute-set> <!-- table-fn-number-style -->

	<xsl:attribute-set name="table-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- table-fmt-fn-label-style -->

	<xsl:template name="refine_table-fmt-fn-label-style">
	</xsl:template>

	<xsl:attribute-set name="fn-container-body-style">
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="table-fn-body-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-fn-number-style">
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- figure-fn-number-style -->

	<xsl:attribute-set name="figure-fmt-fn-label-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- figure-fmt-fn-label-style -->

	<xsl:template name="refine_figure-fmt-fn-label-style">
	</xsl:template>

	<xsl:attribute-set name="figure-fn-body-style">
		<xsl:attribute name="text-align">justify</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>
	<!-- ========================== -->
	<!-- END Table styles -->
	<!-- ========================== -->

	<xsl:template match="*[local-name()='table']" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="table"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="table"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='table']" name="table">

		<xsl:variable name="table-preamble">
		</xsl:variable>

		<xsl:variable name="table">

			<xsl:variable name="simple-table">
				<xsl:if test="$isGenerateTableIF = 'true' and $isApplyAutolayoutAlgorithm = 'true'">
					<xsl:call-template name="getSimpleTable">
						<xsl:with-param name="id" select="@id"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>

			<xsl:if test="$debug = 'true' and normalize-space($simple-table) != ''">
				<!-- <redirect:write file="simple-table_{@id}.xml">
					<xsl:copy-of select="$simple-table"/>
				</redirect:write> -->
			</xsl:if>
			<!-- <xsl:variable name="simple-table" select="xalan:nodeset($simple-table_)"/> -->

			<!-- simple-table=<xsl:copy-of select="$simple-table"/> -->

			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->
			<xsl:call-template name="table_name_fn_display"/>

			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/mn:tr[1]/mn:td)"/>

			<xsl:variable name="colwidths">
				<xsl:if test="not(mn:colgroup/mn:col) and not(@class = 'dl')">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- <xsl:variable name="colwidths" select="xalan:nodeset($colwidths_)"/> -->

			<!-- DEBUG -->
			<xsl:if test="$table_if_debug = 'true'">
				<fo:block font-size="60%">
					<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
				</fo:block>
			</xsl:if>

			<!-- <xsl:copy-of select="$colwidths"/> -->

			<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
			DEBUG
			colwidths=<xsl:copy-of select="$colwidths"/>
		<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

			<xsl:variable name="margin-side">
				<xsl:choose>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">0</xsl:when>
					<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'">0</xsl:when>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:call-template name="setNamedDestination"/>

			<fo:block-container xsl:use-attribute-sets="table-container-style" role="SKIP">

				<xsl:for-each select="mn:fmt-name">
					<xsl:call-template name="setIDforNamedDestination"/>
				</xsl:for-each>

				<xsl:call-template name="refine_table-container-style">
					<xsl:with-param name="margin-side" select="$margin-side"/>
				</xsl:call-template>

				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->

				<xsl:variable name="table_width_default">100%</xsl:variable>
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->
					<xsl:choose>
						<xsl:when test="@width = 'full-page-width' or @width = 'text-width'">100%</xsl:when>
						<xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$table_width_default"/></xsl:otherwise>
					</xsl:choose>

				</xsl:variable>

				<xsl:variable name="table_attributes">

					<xsl:element name="table_attributes" use-attribute-sets="table-style">

						<xsl:if test="$margin-side != 0">
							<xsl:attribute name="margin-left">0mm</xsl:attribute>
							<xsl:attribute name="margin-right">0mm</xsl:attribute>
						</xsl:if>

						<xsl:attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></xsl:attribute>

						<xsl:call-template name="refine_table-style">
							<xsl:with-param name="margin-side" select="$margin-side"/>
						</xsl:call-template>

						<xsl:call-template name="setTableStyles">
							<xsl:with-param name="scope">table</xsl:with-param>
						</xsl:call-template>

					</xsl:element>
				</xsl:variable>

				<xsl:if test="$isGenerateTableIF = 'true'">
					<!-- to determine start of table -->
					<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
				</xsl:if>

				<fo:table id="{@id}">

					<xsl:if test="$isGenerateTableIF = 'true'">
						<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
					</xsl:if>

					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:attribute name="{local-name()}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>

					<xsl:variable name="isNoteOrFnExist" select="./mn:note[not(@type = 'units')] or ./mn:example or .//mn:fn[not(parent::mn:fmt-name)] or ./mn:fmt-source"/>
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<!-- <xsl:choose>
							<xsl:when test="$namespace = 'plateau'"></xsl:when>
							<xsl:otherwise>
								
							</xsl:otherwise>
						</xsl:choose> -->
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute><!-- set 0pt border, because there is a separete table below for footer -->
					</xsl:if>

					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<!-- generate IF for table widths -->
							<!-- example:
								<tr>
									<td valign="top" align="left" id="tab-symdu_1_1">
										<p>Symbol</p>
										<word id="tab-symdu_1_1_word_1">Symbol</word>
									</td>
									<td valign="top" align="left" id="tab-symdu_1_2">
										<p>Description</p>
										<word id="tab-symdu_1_2_word_1">Description</word>
									</td>
								</tr>
							-->
							<!-- <debug-simple-table><xsl:copy-of select="$simple-table"/></debug-simple-table> -->

							<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if"/>

						</xsl:when>
						<xsl:otherwise>

							<xsl:choose>
								<xsl:when test="mn:colgroup/mn:col">
									<xsl:for-each select="mn:colgroup/mn:col">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:when test="@class = 'dl'">
									<xsl:for-each select=".//*[local-name()='tr'][1]/*">
										<fo:table-column column-width="{@width}"/>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="insertTableColumnWidth">
										<xsl:with-param name="colwidths" select="$colwidths"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:choose>
								<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
									<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:note) and not(self::mn:example) and not(self::mn:dl) and not(self::mn:fmt-source) and not(self::mn:p)          and not(self::mn:thead) and not(self::mn:tfoot) and not(self::mn:fmt-footnote-container)]"/> <!-- process all table' elements, except name, header, footer, note, source and dl which render separaterely -->
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>

				</fo:table>

				<xsl:variable name="colgroup" select="mn:colgroup"/>

				<!-- https://github.com/metanorma/metanorma-plateau/issues/171 -->

				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>
						<xsl:with-param name="colgroup" select="$colgroup"/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:apply-templates select="mn:fmt-name"/>

				<!-- https://github.com/metanorma/metanorma-plateau/issues/171
				<xsl:if test="$namespace = 'plateau'">
					<xsl:apply-templates select="*[not(local-name()='thead') and not(local-name()='tbody') and not(local-name()='tfoot') and not(local-name()='name')]" />
					<xsl:for-each select="*[local-name()='tbody']"> - select context to tbody -
						<xsl:variable name="table_fn_block">
							<xsl:call-template name="table_fn_display" />
						</xsl:variable>
						<xsl:copy-of select="$table_fn_block"/>
					</xsl:for-each>
				</xsl:if> -->

				<xsl:if test="*[local-name()='bookmark']"> <!-- special case: table/bookmark -->
					<fo:block keep-with-previous="always" line-height="0.1">
						<xsl:for-each select="*[local-name()='bookmark']">
							<xsl:call-template name="bookmark"/>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</xsl:variable> <!-- END: variable name="table" -->

		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<xsl:choose>
			<xsl:when test="@width and @width != 'full-page-width' and @width != 'text-width'">

				<!-- centered table when table name is centered (see table-name-style) -->
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="setBordersTableArray">
	</xsl:template>

	<!-- table/name-->
	<xsl:template match="*[local-name()='table']/mn:fmt-name">
		<xsl:param name="continued"/>
		<xsl:param name="cols-count"/>
		<xsl:if test="normalize-space() != ''">

			<fo:block xsl:use-attribute-sets="table-name-style">

				<xsl:call-template name="refine_table-name-style">
					<xsl:with-param name="continued" select="$continued"/>
				</xsl:call-template>

				<xsl:choose>
					<xsl:when test="$continued = 'true'">
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>

			</fo:block>

			<!-- <xsl:if test="$namespace = 'bsi' or $namespace = 'iec' or $namespace = 'iso'"> -->
			<xsl:if test="$continued = 'true'">

				<!-- to prevent the error 'THead element may contain only TR elements' -->

				<xsl:choose>
					<xsl:when test="string(number($cols-count)) != 'NaN'">
						<fo:table width="100%" table-layout="fixed" role="SKIP">
							<fo:table-body role="SKIP">
								<fo:table-row>
									<fo:table-cell role="TH" number-columns-spanned="{$cols-count}">
										<fo:block text-align="right" role="SKIP">
											<xsl:apply-templates select="../mn:note[@type = 'units']/node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</xsl:when>
					<xsl:otherwise>
						<fo:block text-align="right">
							<xsl:apply-templates select="../mn:note[@type = 'units']/node()"/>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:if>
			<!-- </xsl:if> -->

		</xsl:if>
	</xsl:template> <!-- table/name -->

	<!-- workaround solution for https://github.com/metanorma/metanorma-iso/issues/1151#issuecomment-2033087938 -->
	<xsl:template match="*[local-name()='table']/mn:note[@type = 'units']/mn:p/text()" priority="4">
		<xsl:choose>
			<xsl:when test="preceding-sibling::mn:br">
				<!-- remove CR or LF at start -->
				<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'^(&#13;&#10;|&#13;|&#10;)', '')"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- SOURCE: ... -->
	<xsl:template match="*[local-name()='table']/mn:fmt-source" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>

	<xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template>

	<xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:call-template name="get-calculated-column-widths-autolayout-algorithm"/>
			</xsl:when>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'skip'"/>
			<xsl:otherwise>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ================================================== -->
	<!-- Calculate column's width based on text string max widths -->
	<!-- ================================================== -->
	<xsl:template name="calculate-column-widths-proportional">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>

		<!-- table=<xsl:copy-of select="$table"/> -->

		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>

						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- <curr_col><xsl:value-of select="$curr-col"/></curr_col> -->

						<!-- <table><xsl:copy-of select="$table"/></table>
						 -->
						<xsl:for-each select="xalan:nodeset($table)/*/*[local-name()='tr']">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="*[local-name()='td'][$curr-col]" mode="td_text"/>
							</xsl:variable>
							<!-- <td_text><xsl:value-of select="$td_text"/></td_text> -->
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:message>string_with_added_zerospaces=<xsl:value-of select="$string_with_added_zerospaces"/></xsl:message> -->
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
								</xsl:call-template>
							</xsl:variable>
							<!-- words=<xsl:copy-of select="$words"/> -->
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<!-- <xsl:message>max_length=<xsl:value-of select="$max_length"/></xsl:message> -->
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="*[local-name()='td'][$curr-col]/@divide">
											<xsl:value-of select="*[local-name()='td'][$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>

						</xsl:for-each>

					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<!-- widths=<xsl:copy-of select="$widths"/> -->

			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths-proportional">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- calculate-column-widths-proportional -->

	<!-- ================================= -->
	<!-- mode="td_text" -->
	<!-- ================================= -->
	<!-- replace each each char to 'X', just to process the tag 'keep-together_within-line' as whole word in longest word calculation -->
	<xsl:template match="*[@keep-together.within-line or local-name() = 'keep-together_within-line']/text()" priority="2" mode="td_text">
		<!-- <xsl:message>DEBUG t1=<xsl:value-of select="."/></xsl:message>
		<xsl:message>DEBUG t2=<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/></xsl:message> -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'.','X')"/>

		<!-- if all capitals english letters or digits -->
		<xsl:if test="normalize-space(translate(., concat($upper,'0123456789'), '')) = ''">
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="'X'"/>
				<xsl:with-param name="count" select="string-length(normalize-space(.)) * 0.5"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text()" mode="td_text">
		<xsl:value-of select="translate(., $zero_width_space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:fmt-termsource" mode="td_text">
		<xsl:value-of select="mn:fmt-origin/@citeas"/>
	</xsl:template>

	<xsl:template match="mn:fmt-link" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template>

	<xsl:template match="*[local-name()='math']" mode="td_text" name="math_length">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<xsl:variable name="mathml_">
				<xsl:for-each select="*">
					<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
						<xsl:copy-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="mathml" select="xalan:nodeset($mathml_)"/>

			<xsl:variable name="math_text">
				<xsl:value-of select="normalize-space($mathml)"/>
				<xsl:for-each select="$mathml//@open"><xsl:value-of select="."/></xsl:for-each>
				<xsl:for-each select="$mathml//@close"><xsl:value-of select="."/></xsl:for-each>
			</xsl:variable>
			<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
		</xsl:if>
	</xsl:template>
	<!-- ================================= -->
	<!-- END mode="td_text" -->
	<!-- ================================= -->
	<!-- ================================================== -->
	<!-- END Calculate column's width based on text string max widths -->
	<!-- ================================================== -->

	<!-- ================================================== -->
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- (https://www.w3.org/TR/REC-html40/appendix/notes.html#h-B.5.2) -->
	<!-- ================================================== -->

	<!-- INPUT: table with columns widths, generated by table_if.xsl  -->
	<xsl:template name="calculate-column-widths-autolayout-algorithm">
		<xsl:param name="parent_table_page-width"/> <!-- for nested tables, in re-calculate step -->

		<!-- via intermediate format -->

		<!-- The algorithm uses two passes through the table data and scales linearly with the size of the table -->

		<!-- In the first pass, line wrapping is disabled, and the user agent keeps track of the minimum and maximum width of each cell. -->

		<!-- Since line wrap has been disabled, paragraphs are treated as long lines unless broken by BR elements. -->

		<xsl:variable name="page_width">
			<xsl:choose>
				<xsl:when test="$parent_table_page-width != ''">
					<xsl:value-of select="$parent_table_page-width"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@page-width"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$table_if_debug = 'true'">
			<page_width><xsl:value-of select="$page_width"/></page_width>
		</xsl:if>

		<!-- There are three cases: -->
		<xsl:choose>
			<!-- 1. The minimum table width is equal to or wider than the available space -->
			<xsl:when test="@width_min &gt;= $page_width and 1 = 2"> <!-- this condition isn't working see case 3 below -->
				<!-- call old algorithm -->
				<case1/>
				<!-- <xsl:variable name="cols-count" select="count(xalan:nodeset($table)/*/tr[1]/td)"/>
				<xsl:call-template name="calculate-column-widths-proportional">
					<xsl:with-param name="cols-count" select="$cols-count"/>
					<xsl:with-param name="table" select="$table"/>
				</xsl:call-template> -->
			</xsl:when>
			<!-- 2. The maximum table width fits within the available space. In this case, set the columns to their maximum widths. -->
			<xsl:when test="@width_max &lt;= $page_width">
				<case2/>
				<autolayout/>
				<xsl:for-each select="column/@width_max">
					<column divider="100"><xsl:value-of select="."/></column>
				</xsl:for-each>
			</xsl:when>
			<!-- 3. The maximum width of the table is greater than the available space, but the minimum table width is smaller. 
			In this case, find the difference between the available space and the minimum table width, lets call it W. 
			Lets also call D the difference between maximum and minimum width of the table. 
			For each column, let d be the difference between maximum and minimum width of that column. 
			Now set the column's width to the minimum width plus d times W over D. 
			This makes columns with large differences between minimum and maximum widths wider than columns with smaller differences. -->
			<xsl:when test="(@width_max &gt; $page_width and @width_min &lt; $page_width) or (@width_min &gt;= $page_width)">
				<!-- difference between the available space and the minimum table width -->
				<_width_min><xsl:value-of select="@width_min"/></_width_min>
				<xsl:variable name="W" select="$page_width - @width_min"/>
				<W><xsl:value-of select="$W"/></W>
				<!-- difference between maximum and minimum width of the table -->
				<xsl:variable name="D" select="@width_max - @width_min"/>
				<D><xsl:value-of select="$D"/></D>
				<case3/>
				<autolayout/>
				<xsl:if test="@width_min &gt;= $page_width">
					<split_keep-within-line>true</split_keep-within-line>
				</xsl:if>
				<xsl:for-each select="column">
					<!-- difference between maximum and minimum width of that column.  -->
					<xsl:variable name="d" select="@width_max - @width_min"/>
					<d><xsl:value-of select="$d"/></d>
					<width_min><xsl:value-of select="@width_min"/></width_min>
					<e><xsl:value-of select="$d * $W div $D"/></e>
					<!-- set the column's width to the minimum width plus d times W over D.  -->
					<xsl:variable name="column_width_" select="round(@width_min + $d * $W div $D)"/> <!--  * 10 -->
					<xsl:variable name="column_width" select="$column_width_*($column_width_ &gt;= 0) - $column_width_*($column_width_ &lt; 0)"/> <!-- absolute value -->
					<column divider="100">
						<xsl:value-of select="$column_width"/>
					</column>
				</xsl:for-each>

			</xsl:when>
			<xsl:otherwise><unknown_case/></xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- calculate-column-widths-autolayout-algorithm -->

	<xsl:template name="get-calculated-column-widths-autolayout-algorithm">

		<!-- if nested 'dl' or 'table' -->
		<xsl:variable name="parent_table_id" select="normalize-space(ancestor::*[local-name() = 'table' or local-name() = 'dl'][1]/@id)"/>
		<parent_table_id><xsl:value-of select="$parent_table_id"/></parent_table_id>

		<parent_element><xsl:value-of select="local-name(..)"/></parent_element>

		<ancestor_tree>
			<xsl:for-each select="ancestor::*">
				<ancestor><xsl:value-of select="local-name()"/></ancestor>
			</xsl:for-each>
		</ancestor_tree>

		<xsl:variable name="parent_table_page-width_">
			<xsl:if test="$parent_table_id != ''">
				<!-- determine column number in the parent table -->
				<xsl:variable name="parent_table_column_number">
					<xsl:choose>
						<!-- <xsl:when test="parent::mn:dd">2</xsl:when> -->
						<xsl:when test="(ancestor::*[local-name() = 'dd' or local-name() = 'table' or local-name() = 'dl'])[last()][local-name() = 'dd' or local-name() = 'dl']">2</xsl:when>
						<xsl:otherwise> <!-- parent is table -->
							<xsl:value-of select="count(ancestor::*[local-name() = 'td'][1]/preceding-sibling::*[local-name() = 'td']) + 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<!-- find table by id in the file 'table_widths' and get all Nth `<column>...</column> -->

				<xsl:variable name="parent_table_column_" select="$table_widths_from_if_calculated//table[@id = $parent_table_id]/column[number($parent_table_column_number)]"/>
				<xsl:variable name="parent_table_column" select="xalan:nodeset($parent_table_column_)"/>
				<!-- <xsl:variable name="divider">
					<xsl:value-of select="$parent_table_column/@divider"/>
					<xsl:if test="not($parent_table_column/@divider)">1</xsl:if>
				</xsl:variable> -->
				<xsl:value-of select="$parent_table_column/text()"/> <!--  * 10 -->
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="parent_table_page-width" select="normalize-space($parent_table_page-width_)"/>

		<parent_table_page-width><xsl:value-of select="$parent_table_page-width"/></parent_table_page-width>

		<!-- get current table id -->
		<xsl:variable name="table_id" select="@id"/>

		<xsl:choose>
			<xsl:when test="$parent_table_id = '' or $parent_table_page-width = ''">
				<!-- find table by id in the file 'table_widths' and get all `<column>...</column> -->
				<xsl:copy-of select="$table_widths_from_if_calculated//table[@id = $table_id]/node()"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- recalculate columns width based on parent table width -->
				<xsl:for-each select="$table_widths_from_if//table[@id = $table_id]">
					<xsl:call-template name="calculate-column-widths-autolayout-algorithm">
						<xsl:with-param name="parent_table_page-width" select="$parent_table_page-width"/> <!-- padding-left = 2mm  = 50000-->
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- get-calculated-column-widths-autolayout-algorithm -->

	<!-- ================================================== -->
	<!-- END: Calculate column's width based on HTML4 algorithm -->
	<!-- ================================================== -->

	<xsl:template match="mn:thead">
		<xsl:param name="cols-count"/>
		<fo:table-header>
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template> <!-- thead -->

	<!-- template is using for iec, iso, jcgm, bsi only -->
	<xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row role="SKIP">
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black" role="SKIP">

				<xsl:call-template name="refine_table-header-title-style"/>

				<xsl:apply-templates select="ancestor::mn:table/mn:fmt-name">
					<xsl:with-param name="continued">true</xsl:with-param>
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:apply-templates>

				<xsl:if test="not(ancestor::mn:table/mn:fmt-name)"> <!-- to prevent empty fo:table-cell in case of missing table's name -->
					<fo:block role="SKIP"/>
				</xsl:if>

			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- table-header-title -->

	<xsl:template name="refine_table-header-title-style">
	</xsl:template> <!-- refine_table-header-title-style -->

	<xsl:template match="*[local-name()='thead']" mode="process_tbody">
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="mn:tfoot">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../mn:tfoot">
			<fo:table-footer>
				<xsl:apply-templates select="../mn:tfoot"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>

		<xsl:variable name="isNoteOrFnExist" select="../mn:note[not(@type = 'units')] or ../mn:example or ../mn:dl or ..//mn:fn[not(parent::mn:fmt-name)] or ../mn:fmt-source or ../mn:p"/>

		<xsl:variable name="isNoteOrFnExistShowAfterTable">
		</xsl:variable>

		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">

			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//mn:col">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//mn:col)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="table_fn_block">
				<xsl:call-template name="table_fn_display"/>
			</xsl:variable>

			<xsl:variable name="tableWithNotesAndFootnotes">

				<fo:table keep-with-previous="always" role="SKIP">
					<xsl:for-each select="xalan:nodeset($table_attributes)/table_attributes/@*">
						<xsl:variable name="name" select="local-name()"/>
						<xsl:choose>
							<xsl:when test="$name = 'border-top'">
								<xsl:attribute name="{$name}">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:when test="$name = 'border'">
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
								<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="{$name}"><xsl:value-of select="."/></xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:for-each select="ancestor::mn:table[1]">
						<xsl:call-template name="setTableStyles">
							<xsl:with-param name="scope">table</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>

					<xsl:choose>
						<xsl:when test="xalan:nodeset($colgroup)//mn:col">
							<xsl:for-each select="xalan:nodeset($colgroup)//mn:col">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<!-- $colwidths=<xsl:copy-of select="$colwidths"/> -->
							<xsl:call-template name="insertTableColumnWidth">
								<xsl:with-param name="colwidths" select="$colwidths"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>

					<fo:table-body role="SKIP">
						<fo:table-row role="SKIP">
							<xsl:for-each select="ancestor::mn:table[1]">
								<xsl:call-template name="setTableStyles">
									<xsl:with-param name="scope">ancestor_table</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>

							<fo:table-cell xsl:use-attribute-sets="table-footer-cell-style" number-columns-spanned="{$cols-count}" role="SKIP">

								<xsl:call-template name="refine_table-footer-cell-style"/>

								<xsl:for-each select="ancestor::mn:table[1]">
									<xsl:call-template name="setTableStyles">
										<xsl:with-param name="scope">ancestor_table_borders_only</xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>

								<xsl:call-template name="setBordersTableArray"/>

								<!-- fn will be processed inside 'note' processing -->
								<xsl:apply-templates select="../mn:p"/>
								<xsl:apply-templates select="../mn:dl"/>
								<xsl:apply-templates select="../mn:note[not(@type = 'units')]"/>
								<xsl:apply-templates select="../mn:example"/>
								<xsl:apply-templates select="../mn:fmt-source"/>

								<xsl:variable name="isDisplayRowSeparator">
								</xsl:variable>

								<!-- horizontal row separator -->
								<xsl:if test="normalize-space($isDisplayRowSeparator) = 'true'">
									<xsl:if test="(../mn:note[not(@type = 'units')] or ../mn:example) and normalize-space($table_fn_block) != ''">
										<fo:block-container border-top="0.5pt solid black" padding-left="1mm" padding-right="1mm">
											<xsl:call-template name="setBordersTableArray"/>
											<fo:block font-size="1pt"> </fo:block>
										</fo:block-container>
									</xsl:if>
								</xsl:if>

								<!-- fn processing -->
								<!-- <xsl:call-template name="table_fn_display" /> -->
								<xsl:copy-of select="$table_fn_block"/>

							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>

				</fo:table>
			</xsl:variable>

			<xsl:if test="normalize-space($tableWithNotesAndFootnotes) != ''">
				<xsl:copy-of select="$tableWithNotesAndFootnotes"/>
			</xsl:if>

		</xsl:if>
	</xsl:template> <!-- insertTableFooterInSeparateTable -->

	<xsl:template match="mn:tbody">

		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../mn:thead">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../mn:thead/mn:tr[1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./mn:tr[1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates select="../mn:thead">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>

		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>

		<fo:table-body>

			<xsl:apply-templates/>

		</fo:table-body>

	</xsl:template> <!-- tbody -->

	<!-- ======================================== -->
	<!-- mode="process_table-if"                  -->
	<!-- ======================================== -->
	<xsl:template match="/" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>
		<xsl:apply-templates mode="process_table-if">
			<xsl:with-param name="table_or_dl" select="$table_or_dl"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="process_table-if">
		<xsl:param name="table_or_dl">table</xsl:param>

		<fo:table-body>
			<xsl:for-each select="*[local-name() = 'tr']">
				<xsl:variable name="col_count" select="count(*)"/>

				<!-- iteration for each tr/td -->

				<xsl:choose>
					<xsl:when test="$table_or_dl = 'table'">
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']/*">
							<fo:table-row number-columns-spanned="{$col_count}">
								<xsl:copy-of select="../@font-weight"/>
								<!-- <test_table><xsl:copy-of select="."/></test_table> -->
								<xsl:call-template name="td"/>
							</fo:table-row>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise> <!-- $table_or_dl = 'dl' -->
						<xsl:for-each select="*[local-name() = 'td' or local-name() = 'th']">
							<xsl:variable name="is_dt" select="position() = 1"/>

							<xsl:for-each select="*">
								<!-- <test><xsl:copy-of select="."/></test> -->
								<fo:table-row number-columns-spanned="{$col_count}">
									<xsl:choose>
										<xsl:when test="$is_dt">
											<xsl:call-template name="insert_dt_cell"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="insert_dd_cell"/>
										</xsl:otherwise>
									</xsl:choose>
								</fo:table-row>
							</xsl:for-each>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:for-each>
		</fo:table-body>
	</xsl:template> <!-- process_table-if -->
	<!-- ======================================== -->
	<!-- END: mode="process_table-if"             -->
	<!-- ======================================== -->

	<!-- ===================== -->
	<!-- Table's row processing -->
	<!-- ===================== -->
	<!-- row in table header (thead) thead/tr -->
	<xsl:template match="mn:thead/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-header-row-style">

			<xsl:call-template name="refine_table-header-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setBorderUnderRow">
		<xsl:variable name="border_under_row_" select="normalize-space(ancestor::mn:table[1]/@border-under-row)"/>
		<xsl:choose>
			<xsl:when test="$border_under_row_ != ''">
				<xsl:variable name="table_id" select="ancestor::mn:table[1]/@id"/>
				<xsl:variable name="row_num_"><xsl:number level="any" count="mn:table[@id = $table_id]//mn:tr"/></xsl:variable>
				<xsl:variable name="row_num" select="number($row_num_) - 1"/> <!-- because values in border-under-row start with 0 -->
				<xsl:variable name="border_under_row">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="$border_under_row_"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="xalan:nodeset($border_under_row)/mnx:item[. = normalize-space($row_num)]">
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- row in table footer (tfoot), tfoot/tr -->
	<xsl:template match="mn:tfoot/mn:tr" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-footer-row-style">

			<xsl:call-template name="refine_table-footer-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<!-- row in table's body (tbody) -->
	<xsl:template match="*[local-name()='tr']">
		<fo:table-row xsl:use-attribute-sets="table-body-row-style">

			<xsl:if test="count(*) = count(*[local-name() = 'th'])"> <!-- row contains 'th' only -->
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_table-body-row-style"/>

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setTableRowAttributes">

		<xsl:for-each select="ancestor::mn:table[1]">
			<xsl:call-template name="setTableStyles">
				<xsl:with-param name="scope">ancestor_table</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="setTableStyles"/>

	</xsl:template> <!-- setTableRowAttributes -->
	<!-- ===================== -->
	<!-- END Table's row processing -->
	<!-- ===================== -->

	<!-- cell in table header row -->
	<xsl:template match="*[local-name()='th']">
		<fo:table-cell xsl:use-attribute-sets="table-header-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">center</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-header-cell-style"/>

			<!-- experimental feature, see https://github.com/metanorma/metanorma-plateau/issues/30#issuecomment-2145461828 -->
			<!-- <xsl:choose>
				<xsl:when test="count(node()) = 1 and mn:span[contains(@style, 'text-orientation')]">
					<fo:block-container reference-orientation="270">
						<fo:block role="SKIP" text-align="start">
							<xsl:apply-templates />
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
					<fo:block role="SKIP">
						<xsl:apply-templates />
					</fo:block>
				</xsl:otherwise>
			</xsl:choose> -->

			<fo:block role="SKIP">
				<xsl:apply-templates/>
				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0"> </xsl:if>
			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- cell in table header row - 'th' -->

	<xsl:template name="setTableCellAttributes">
		<xsl:if test="@colspan">
			<xsl:attribute name="number-columns-spanned">
				<xsl:value-of select="@colspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:if test="@rowspan">
			<xsl:attribute name="number-rows-spanned">
				<xsl:value-of select="@rowspan"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:call-template name="display-align"/>

		<xsl:for-each select="ancestor::mn:table[1]">
			<xsl:call-template name="setTableStyles">
				<xsl:with-param name="scope">ancestor_table_borders_only</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:call-template name="setTableStyles"/>
	</xsl:template>

	<xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setTableStyles">
		<xsl:param name="scope">cell</xsl:param>
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/mnx:item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:if test="($key = 'color' and ($scope = 'cell' or $scope = 'table')) or       ($key = 'background-color' and ($scope = 'cell' or $scope = 'ancestor_table')) or      $key = 'border' or      $key = 'border-top' or      $key = 'border-right' or      $key = 'border-left' or      $key = 'border-bottom' or      $key = 'border-style' or      $key = 'border-width' or      $key = 'border-color' or      $key = 'border-top-style' or      $key = 'border-top-width' or      $key = 'border-top-color' or      $key = 'border-right-style' or      $key = 'border-right-width' or      $key = 'border-right-color' or      $key = 'border-left-style' or      $key = 'border-left-width' or      $key = 'border-left-color' or      $key = 'border-bottom-style' or      $key = 'border-bottom-width' or      $key = 'border-bottom-color'">
					<style name="{$key}"><xsl:value-of select="java:replaceAll(java:java.lang.String.new($value), 'currentColor', 'inherit')"/></style>
				</xsl:if>
				<xsl:if test="$key = 'border' and ($scope = 'table' or $scope = 'ancestor_table' or $scope = 'ancestor_table_borders_only')">
					<style name="{$key}-top"><xsl:value-of select="$value"/></style>
					<style name="{$key}-right"><xsl:value-of select="$value"/></style>
					<style name="{$key}-left"><xsl:value-of select="$value"/></style>
					<style name="{$key}-bottom"><xsl:value-of select="$value"/></style>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="styles" select="xalan:nodeset($styles_)"/>
		<xsl:for-each select="$styles/style">
			<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
		</xsl:for-each>
	</xsl:template> <!-- setTableStyles -->

	<!-- cell in table body, footer -->
	<xsl:template match="*[local-name()='td']" name="td">
		<fo:table-cell xsl:use-attribute-sets="table-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:copy-of select="@keep-together.within-line"/>

			<xsl:call-template name="refine_table-cell-style"/>

			<xsl:call-template name="setTableCellAttributes"/>

			<xsl:if test=".//mn:table"> <!-- if there is nested table -->
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isGenerateTableIF = 'true'">
				<xsl:attribute name="border">1pt solid black</xsl:attribute> <!-- border is mandatory, to determine page width -->
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<xsl:if test="$isGenerateTableIF = 'false'">
				<xsl:if test="@colspan and mn:note[@type = 'units']">
					<xsl:attribute name="text-align">right</xsl:attribute>
					<xsl:attribute name="border">none</xsl:attribute>
					<xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
					<xsl:attribute name="border-top">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-left">1pt solid white</xsl:attribute>
					<xsl:attribute name="border-right">1pt solid white</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:apply-templates/>

				<xsl:if test="$isGenerateTableIF = 'true'"> <fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

				<xsl:if test="$isGenerateTableIF = 'false' and count(node()) = 0"> </xsl:if>

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- td -->

	<!-- table/note, table/example, table/tfoot//note, table/tfoot//example -->
	<xsl:template match="mn:table/*[self::mn:note or self::mn:example] |       mn:table/mn:tfoot//*[self::mn:note or self::mn:example]" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block xsl:use-attribute-sets="table-note-style">
			<xsl:copy-of select="@id"/>

			<xsl:call-template name="refine_table-note-style"/>

			<!-- Table's note/example name (NOTE, for example) -->
			<fo:inline xsl:use-attribute-sets="table-note-name-style">

				<xsl:call-template name="refine_table-note-name-style"/>

				<xsl:apply-templates select="mn:fmt-name"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template> <!-- table/note -->

	<xsl:template match="mn:table/*[self::mn:note or self::mn:example]/mn:p |  mn:table/mn:tfoot//*[self::mn:note or self::mn:example]/mn:p" priority="2">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ============================ -->
	<!-- table's footnotes rendering -->
	<!-- ============================ -->

	<!-- table/fmt-footnote-container -->
	<xsl:template match="mn:table/mn:fmt-footnote-container"/>

	<xsl:template match="mn:table/mn:tfoot//mn:fmt-footnote-container">
		<xsl:for-each select=".">
			<xsl:call-template name="table_fn_display"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="table_fn_display">
		<!-- <xsl:variable name="references">
			<xsl:if test="$namespace = 'bsi'">
				<xsl:for-each select="..//mn:fn[local-name(..) = 'name']">
					<xsl:call-template name="create_fn" />
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="..//mn:fn[local-name(..) != 'name']">
				<xsl:call-template name="create_fn" />
			</xsl:for-each>
		</xsl:variable> -->
		<!-- <xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])">  --> <!-- only unique reference puts in note-->
		<xsl:for-each select="..//mn:fmt-footnote-container/mn:fmt-fn-body">
				<fo:block xsl:use-attribute-sets="table-fn-style">
					<xsl:copy-of select="@id"/>
					<xsl:call-template name="refine_table-fn-style"/>

					<xsl:apply-templates select=".//mn:fmt-fn-label">
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>

					<fo:inline xsl:use-attribute-sets="table-fn-body-style">
						<!-- <xsl:copy-of select="./node()"/> -->
						<xsl:apply-templates/>
					</fo:inline>

				</fo:block>

			<!-- </xsl:if> -->
		</xsl:for-each>
	</xsl:template> <!-- table_fn_display -->

	<!-- fmt-fn-body/fmt-fn-label in text -->
	<xsl:template match="mn:fmt-fn-body//mn:fmt-fn-label"/>

	<!-- table//fmt-fn-body//fmt-fn-label -->
	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="table-fn-number-style" role="SKIP">

				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>

				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">(</fo:inline>
				</xsl:if> -->

				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>※</xsl:text>
				</xsl:if> -->

				<!-- <xsl:value-of select="@reference"/> -->
				<!-- <xsl:value-of select="normalize-space()"/> -->
				<xsl:apply-templates/>

				<!-- <xsl:if test="$namespace = 'bipm'">
					<fo:inline font-style="normal">)</fo:inline>
				</xsl:if> -->

				<!-- commented https://github.com/metanorma/isodoc/issues/614 -->
				<!-- <xsl:if test="$namespace = 'itu'">
					<xsl:text>)</xsl:text>
				</xsl:if> -->

				<!-- <xsl:if test="$namespace = 'plateau'">
					<xsl:text>：</xsl:text>
				</xsl:if> -->

			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  fmt-fn-body//fmt-fn-label -->

	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<xsl:attribute name="padding-right">5mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:table//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="table-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_table-fmt-fn-label-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- <xsl:template match="mn:fmt-footnote-container/mn:fmt-fn-body//mn:fmt-fn-label//mn:tab"/> -->
	<!-- 
	<xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
			<xsl:if test="ancestor::*[local-name()='table'][1]/@id">  - for footnotes in tables -
				<xsl:attribute name="id">
					<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$namespace = 'itu'">
				<xsl:if test="ancestor::mn:preface">
					<xsl:attribute name="preface">true</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
				<xsl:attribute name="id">
					<xsl:value-of select="@reference"/>
					<xsl:text>_</xsl:text>
					<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</fn>
	</xsl:template> -->

	<!-- footnotes for table's name rendering -->
	<xsl:template name="table_name_fn_display">
		<xsl:for-each select="mn:fmt-name//mn:fn">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template>
	<!-- ============================ -->
	<!-- EMD table's footnotes rendering -->
	<!-- ============================ -->

	<!-- fn reference in the table rendering (for instance, 'some text 1) some text' ) -->
	<!-- fn --> <!-- in table --> <!-- for figure see <xsl:template match="mn:figure/mn:fn" priority="2"/> -->
	<xsl:template match="mn:fn">
		<xsl:variable name="target" select="@target"/>
		<xsl:choose>
			<!-- case for footnotes in Requirement tables (https://github.com/metanorma/metanorma-ogc/issues/791) -->
			<xsl:when test="not(ancestor::mn:table[1]//mn:fmt-footnote-container/mn:fmt-fn-body[@id = $target]) and        $footnotes/mn:fmt-fn-body[@id = $target]">
				<xsl:call-template name="fn">
					<xsl:with-param name="footnote_body_from_table">true</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>

				<fo:inline xsl:use-attribute-sets="fn-reference-style">

					<xsl:call-template name="refine_fn-reference-style"/>

					<!-- <fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="footnote {@reference}"> --> <!-- @reference   | ancestor::mn:clause[1]/@id-->
					<fo:basic-link internal-destination="{@target}" fox:alt-text="footnote {@reference}">
						<!-- <xsl:if test="ancestor::*[local-name()='table'][1]/@id"> --> <!-- for footnotes in tables -->
						<!-- 	<xsl:attribute name="internal-destination">
								<xsl:value-of select="concat(@reference, '_', ancestor::*[local-name()='table'][1]/@id)"/>
							</xsl:attribute>
						</xsl:if>
						<xsl:if test="$namespace = 'ogc' or $namespace = 'ogc-white-paper'">
							<xsl:attribute name="internal-destination">
								<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
								<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
							</xsl:attribute>
						</xsl:if> -->
						<!-- <xsl:if test="$namespace = 'plateau'">
							<xsl:text>※</xsl:text>
						</xsl:if> -->
						<!-- <xsl:value-of select="@reference"/> -->
						<xsl:value-of select="normalize-space(mn:fmt-fn-label)"/>

						<!-- <xsl:if test="$namespace = 'bsi'">
							<xsl:text>)</xsl:text>
						</xsl:if> -->
						<!-- commented, https://github.com/metanorma/isodoc/issues/614 -->
						<!-- <xsl:if test="$namespace = 'jis'">
							<fo:inline font-weight="normal">)</fo:inline>
						</xsl:if> -->
					</fo:basic-link>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn -->

	<!-- split string 'text' by 'separator' -->
	<xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="$isGenerateTableIF = 'true' and not(contains($text, $separator))">
				<word><xsl:value-of select="normalize-space($text)"/></word>
			</xsl:when>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:choose>
						<xsl:when test="normalize-space(translate($text, 'X', '')) = ''"> <!-- special case for keep-together.within-line -->
							<xsl:value-of select="$len_str_tmp"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
							<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
							<xsl:variable name="len_str">
								<xsl:choose>
									<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
										<xsl:value-of select="$len_str_tmp * 1.5"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$len_str_tmp"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
								<xsl:message>
									div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
									len_str=<xsl:value-of select="$len_str"/>
									len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
								</xsl:message>
							</xsl:if> -->
							<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
							<len_str><xsl:value-of select="$len_str"/></len_str> -->
							<xsl:choose>
								<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
									<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$len_str"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:variable name="word" select="normalize-space(substring-before($text, $separator))"/>
					<xsl:choose>
						<xsl:when test="$isGenerateTableIF = 'true'">
							<xsl:value-of select="$word"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string-length($word)"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- split string 'text' by 'separator', enclosing in formatting tags -->
	<xsl:template name="tokenize_with_tags">
		<xsl:param name="tags"/>
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>

			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:if test="ancestor::mn:p[@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space($text)"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:if test="ancestor::mn:p[@from_dl = 'true']">
						<xsl:text>
 </xsl:text> <!-- to add distance between dt and dd -->
					</xsl:if>
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space(substring-before($text, $separator))"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
				<xsl:call-template name="tokenize_with_tags">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
					<xsl:with-param name="tags" select="$tags"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="enclose_text_in_tags">
		<xsl:param name="text"/>
		<xsl:param name="tags"/>
		<xsl:param name="num">1</xsl:param> <!-- default (start) value -->

		<xsl:variable name="tag_name" select="normalize-space(xalan:nodeset($tags)//tag[$num])"/>

		<xsl:choose>
			<xsl:when test="$tag_name = ''"><xsl:value-of select="$text"/></xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$tag_name}" namespace="{$namespace_full}">
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="$text"/>
						<xsl:with-param name="tags" select="$tags"/>
						<xsl:with-param name="num" select="$num + 1"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- get max value in array -->
	<xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>

		<!-- add zero-width space (#x200B) after dot with next non-digit -->
		<xsl:variable name="text1" select="java:replaceAll(java:java.lang.String.new($text),'(\.)([^\d\s])','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, equal, underscore, em dash, thin space, arrow right, ;   -->
		<xsl:variable name="text2" select="java:replaceAll(java:java.lang.String.new($text1),'(-|=|_|—| |→|;)','$1​')"/>
		<!-- add zero-width space (#x200B) after characters: colon, if there aren't digits after -->
		<xsl:variable name="text3" select="java:replaceAll(java:java.lang.String.new($text2),'(:)(\D)','$1​$2')"/>
		<!-- add zero-width space (#x200B) after characters: 'great than' -->
		<xsl:variable name="text4" select="java:replaceAll(java:java.lang.String.new($text3), '(\u003e)(?!\u003e)', '$1​')"/><!-- negative lookahead: 'great than' not followed by 'great than' -->
		<!-- add zero-width space (#x200B) before characters: 'less than' -->
		<xsl:variable name="text5" select="java:replaceAll(java:java.lang.String.new($text4), '(?&lt;!\u003c)(\u003c)', '​$1')"/> <!-- (?<!\u003c)(\u003c) --> <!-- negative lookbehind: 'less than' not preceeded by 'less than' -->
		<!-- add zero-width space (#x200B) before character: { -->
		<xsl:variable name="text6" select="java:replaceAll(java:java.lang.String.new($text5), '(?&lt;!\W)(\{)', '​$1')"/> <!-- negative lookbehind: '{' not preceeded by 'punctuation char' -->
		<!-- add zero-width space (#x200B) after character: , -->
		<xsl:variable name="text7" select="java:replaceAll(java:java.lang.String.new($text6), '(\,)(?!\d)', '$1​')"/> <!-- negative lookahead: ',' not followed by digit -->
		<!-- add zero-width space (#x200B) after character: '/' -->
		<xsl:variable name="text8" select="java:replaceAll(java:java.lang.String.new($text7), '(\u002f)(?!\u002f)', '$1​')"/><!-- negative lookahead: '/' not followed by '/' -->

		<xsl:variable name="text9">
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text8), '([\u3000-\u9FFF])', '$1​')"/> <!-- 3000 - CJK Symbols and Punctuation ... 9FFF CJK Unified Ideographs-->
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="$text8"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="text10" select="java:replaceAll(java:java.lang.String.new($text9), '\u200b{2,}', '​')"/>

		<!-- replace sequence #x200B and space TO space -->
		<xsl:variable name="text11" select="java:replaceAll(java:java.lang.String.new($text10), '\u200b ', ' ')"/>

		<xsl:value-of select="$text11"/>
	</xsl:template> <!-- add-zero-spaces-java -->

	<xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>

		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$1')"/> <!-- http://. https:// or www. -->
		<xsl:variable name="url_continue" select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space, comma, slash, @  -->
		<xsl:variable name="url" select="java:replaceAll(java:java.lang.String.new($url_continue),'(-|\.|:|=|_|—| |,|/|@)','$1​')"/>

		<!-- replace sequence #x200B to one &#x200B -->
		<xsl:variable name="url2" select="java:replaceAll(java:java.lang.String.new($url), '\u200b{2,}', '​')"/>

		<!-- remove zero-width space at the end -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($url2), '​$', '')"/>
	</xsl:template> <!-- add-zero-spaces-link-java -->

	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:param name="id"/>

		<!-- <test0>
			<xsl:copy-of select="."/>
		</test0> -->

		<xsl:variable name="simple-table">

			<xsl:variable name="table_without_semantic_elements">
				<xsl:apply-templates mode="update_xml_step1"/>
			</xsl:variable>

			<!-- Step 0. replace <br/> to <p>...</p> -->
			<xsl:variable name="table_without_br">
				<!-- <xsl:apply-templates mode="table-without-br"/> -->
				<xsl:apply-templates select="xalan:nodeset($table_without_semantic_elements)" mode="table-without-br"/>
			</xsl:variable>
			<!-- <debug-table_without_br><xsl:copy-of select="$table_without_br"/></debug-table_without_br> -->

			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<mn:tbody>
					<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-colspan"/>
				</mn:tbody>
			</xsl:variable>
			<!-- <debug-simple-table-colspan><xsl:copy-of select="$simple-table-colspan"/></debug-simple-table-colspan> -->

			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			<!-- <debug-simple-table-rowspan><xsl:copy-of select="$simple-table-rowspan"/></debug-simple-table-rowspan> -->

			<!-- Step 3: add id to each cell -->
			<!-- add <word>...</word> for each word, image, math -->
			<xsl:variable name="simple-table-id">
				<xsl:apply-templates select="xalan:nodeset($simple-table-rowspan)" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
			</xsl:variable>
			<!-- <debug-simple-table-id><xsl:copy-of select="$simple-table-id"/></debug-simple-table-id> -->

			<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template>

	<!-- ================================== -->
	<!-- Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->
	<xsl:template match="@*|node()" mode="table-without-br">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="table-without-br"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name() = 'td'][not(mn:br) and not(mn:p) and not(mn:sourcecode) and not(mn:ul) and not(mn:ol)]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<mn:p>
				<xsl:copy-of select="node()"/>
			</mn:p>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td'][mn:br]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="mn:br">
				<xsl:variable name="current_id" select="generate-id()"/>
				<mn:p>
					<xsl:for-each select="preceding-sibling::node()[following-sibling::mn:br[1][generate-id() = $current_id]][not(local-name() = 'br')]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</mn:p>
				<xsl:if test="not(following-sibling::mn:br)">
					<mn:p>
						<xsl:for-each select="following-sibling::node()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</mn:p>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:p[mn:br]" mode="table-without-br">
		<xsl:for-each select="mn:br">
			<xsl:variable name="current_id" select="generate-id()"/>
			<mn:p>
				<xsl:for-each select="preceding-sibling::node()[following-sibling::mn:br[1][generate-id() = $current_id]][not(local-name() = 'br')]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</mn:p>
			<xsl:if test="not(following-sibling::mn:br)">
				<mn:p>
					<xsl:for-each select="following-sibling::node()">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</mn:p>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:sourcecode" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/mn:sourcecode/text()[contains(., '&#13;') or contains(., '&#10;')]" mode="table-without-br">

		<xsl:variable name="sep">###SOURCECODE_NEWLINE###</xsl:variable>
		<xsl:variable name="sourcecode_text" select="java:replaceAll(java:java.lang.String.new(.),'(&#13;&#10;|&#13;|&#10;)', $sep)"/>
		<xsl:variable name="items">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="$sourcecode_text"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space">false</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($items)/*">
			<mn:p>
				<mn:sourcecode><xsl:copy-of select="node()"/></mn:sourcecode>
			</mn:p>
		</xsl:for-each>
	</xsl:template>

	<!-- remove redundant white spaces -->
	<xsl:template match="text()[not(ancestor::mn:sourcecode)]" mode="table-without-br">
		<xsl:variable name="text" select="translate(.,'&#9;&#10;&#13;','')"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),' {2,}',' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//*[local-name() = 'ol' or local-name() = 'ul']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']//mn:li" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<!-- mode="table-without-br" -->
	<!-- ================================== -->
	<!-- END: Step 0. replace <br/> to <p>...</p> -->
	<!-- ================================== -->

	<!-- ===================== -->
	<!-- 1. mode "simple-table-colspan" 
			1.1. remove thead, tbody, fn
			1.2. rename th -> td
			1.3. repeating N td with colspan=N
			1.4. remove namespace
			1.5. remove @colspan attribute
			1.6. add @divide attribute for divide text width in further processing 
	-->
	<!-- ===================== -->
	<xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template>
	<xsl:template match="mn:fn" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="{local-name()}" namespace="{$namespace_full}">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:if test="local-name()='th'">
							<xsl:attribute name="font-weight">bold</xsl:attribute>
						</xsl:if>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{local-name()}" namespace="{$namespace_full}">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:if test="local-name()='th'">
						<xsl:attribute name="font-weight">bold</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@colspan" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<mn:tr>
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</mn:tr>
	</xsl:template>

	<xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template>

	<!-- repeat node 'count' times -->
	<xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>

		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template>
	<!-- End mode simple-table-colspan  -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- ===================== -->
	<!-- 2. mode "simple-table-rowspan" 
	Row span processing, more information http://andrewjwelch.com/code/xslt/table/table-normalization.html	-->
	<!-- ===================== -->
	<xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="mn:tr[1]"/>
				<xsl:apply-templates select="mn:tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="mn:tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>

		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//*[self::mn:td or self::mn:th]">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/*[self::mn:td or self::mn:th][1 + count(current()/preceding-sibling::*[self::mn:td or self::mn:th][not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<!-- optimize to prevent StackOverflowError, just copy next 'tr' -->
		<xsl:variable name="currrow_num" select="count(preceding-sibling::mn:tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan_" select="count(following-sibling::mn:tr[*[@rowspan and @rowspan != 1]][1]/preceding-sibling::mn:tr) + 1"/>
		<xsl:variable name="nextrow_without_rowspan" select="$nextrow_without_rowspan_ - $currrow_num"/>
		<xsl:choose>
			<xsl:when test="not(xalan:nodeset($newRow)/*/*[@rowspan and @rowspan != 1]) and $nextrow_without_rowspan &lt;= 0">
				<xsl:copy-of select="following-sibling::mn:tr"/>
			</xsl:when>
			<!-- <xsl:when test="xalan:nodeset($newRow)/*[not(@rowspan) or (@rowspan = 1)] and $nextrow_without_rowspan &gt; 0">
				<xsl:copy-of select="following-sibling::tr[position() &lt;= $nextrow_without_rowspan]"/>
				
				<xsl:copy-of select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				<xsl:apply-templates select="following-sibling::tr[$nextrow_without_rowspan + 2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="following-sibling::tr[$nextrow_without_rowspan + 1]"/>
				</xsl:apply-templates>
			</xsl:when> -->
			<xsl:otherwise>
				<xsl:apply-templates select="following-sibling::mn:tr[1]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="$newRow"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- End mode simple-table-rowspan  -->

	<!-- Step 3: add id for each cell -->
	<!-- mode: simple-table-id -->
	<xsl:template match="/" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:variable name="id_prefixed" select="concat('table_if_',$id)"/> <!-- table id prefixed by 'table_if_' to simple search in IF  -->
		<xsl:apply-templates select="@*|node()" mode="simple-table-id">
			<xsl:with-param name="id" select="$id_prefixed"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="@*|node()" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='tbody']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
			<xsl:apply-templates select="node()" mode="simple-table-id">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']" mode="simple-table-id">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="row_number" select="count(../preceding-sibling::*) + 1"/>
			<xsl:variable name="col_number" select="count(preceding-sibling::*) + 1"/>
			<xsl:variable name="divide">
				<xsl:choose>
					<xsl:when test="@divide"><xsl:value-of select="@divide"/></xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="id">
				<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_',$divide)"/>
			</xsl:attribute>

			<xsl:for-each select="*[local-name() = 'p']">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:variable name="p_num" select="count(preceding-sibling::*[local-name() = 'p']) + 1"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_p_',$p_num,'_',$divide)"/>
					</xsl:attribute>

					<!-- <xsl:copy-of select="node()" /> -->
					<xsl:apply-templates mode="simple-table-noid"/>

				</xsl:copy>
			</xsl:for-each>

			<xsl:if test="$isGenerateTableIF = 'true'"> <!-- split each paragraph to words, image, math -->

				<xsl:variable name="td_text">
					<xsl:apply-templates select="." mode="td_text_with_formatting"/>
				</xsl:variable>

				<!-- td_text='<xsl:copy-of select="$td_text"/>' -->

				<xsl:variable name="words_with_width">
					<!-- calculate width for 'word' which contain text only (without formatting tags inside) -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][not(*)]">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:attribute name="width">
								<xsl:value-of select="java:org.metanorma.fop.Util.getStringWidth(., $font_main)"/> <!-- Example: 'Times New Roman' -->
							</xsl:attribute>
							<xsl:copy-of select="node()"/>
						</xsl:copy>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="words_with_width_sorted">
					<xsl:for-each select="xalan:nodeset($words_with_width)//*[local-name() = 'word']">
						<xsl:sort select="@width" data-type="number" order="descending"/>
						<!-- select word maximal width only -->
						<xsl:if test="position() = 1">
							<xsl:copy-of select="."/>
						</xsl:if>
					</xsl:for-each>
					<!-- add 'word' with formatting tags inside -->
					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != ''][*]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:variable>

				<!-- <xsl:if test="$debug = 'true'">
					<redirect:write file="{generate-id()}_words_with_width_sorted.xml">
						<td_text><xsl:copy-of select="$td_text"/></td_text>
						<words_with_width><xsl:copy-of select="$words_with_width"/></words_with_width>
						<xsl:copy-of select="$words_with_width_sorted"/>
					</redirect:write>
				</xsl:if> -->

				<xsl:variable name="words">
					<xsl:for-each select=".//*[local-name() = 'image' or local-name() = 'fmt-stem']">
						<word>
							<xsl:copy-of select="."/>
						</word>
					</xsl:for-each>

					<xsl:for-each select="xalan:nodeset($words_with_width_sorted)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each>
					<!-- <xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each> -->

				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($words)/word">
					<xsl:variable name="num" select="count(preceding-sibling::word) + 1"/>
					<xsl:copy>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'@',$row_number,'_',$col_number,'_word_',$num,'_',$divide)"/>
						</xsl:attribute>
						<xsl:copy-of select="node()"/>
					</xsl:copy>
				</xsl:for-each>
			</xsl:if>
		</xsl:copy>

	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p']//*" mode="simple-table-noid">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@*[local-name() != 'id']"/> <!-- to prevent repeat id in colspan/rowspan cells -->
					<!-- <xsl:if test="local-name() = 'dl' or local-name() = 'table'">
						<xsl:copy-of select="@id"/>
					</xsl:if> -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="@*"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="node()" mode="simple-table-noid"/>
		</xsl:copy>
	</xsl:template>

	<!-- End mode: simple-table-id -->
	<!-- ===================== -->
	<!-- ===================== -->

	<!-- =============================== -->
	<!-- mode="td_text_with_formatting" -->
	<!-- =============================== -->
	<xsl:template match="@*|node()" mode="td_text_with_formatting">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="td_text_with_formatting"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'fmt-stem' or local-name() = 'image']" mode="td_text_with_formatting"/>

	<xsl:template match="*[local-name() = 'keep-together_within-line']/text()" mode="td_text_with_formatting">
		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>
		<word>
			<xsl:call-template name="enclose_text_in_tags">
				<xsl:with-param name="text" select="normalize-space(.)"/>
				<xsl:with-param name="tags" select="$formatting_tags"/>
			</xsl:call-template>
		</word>
	</xsl:template>

	<xsl:template match="*[local-name() != 'keep-together_within-line']/text()" mode="td_text_with_formatting">

		<xsl:variable name="td_text" select="."/>

		<xsl:variable name="string_with_added_zerospaces">
			<xsl:call-template name="add-zero-spaces-java">
				<xsl:with-param name="text" select="$td_text"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="formatting_tags">
			<xsl:call-template name="getFormattingTags"/>
		</xsl:variable>

		<!-- <word>text</word> -->
		<xsl:call-template name="tokenize_with_tags">
			<xsl:with-param name="tags" select="$formatting_tags"/>
			<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​­', '  '))"/> <!-- replace zero-width-space and soft-hyphen to space -->
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:fmt-link[normalize-space() = '']" mode="td_text_with_formatting">
		<xsl:variable name="link">
			<link_updated>
				<xsl:variable name="target_text">
					<xsl:choose>
						<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
							<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="normalize-space(@target)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$target_text"/>
			</link_updated>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($link)/*">
			<xsl:apply-templates mode="td_text_with_formatting"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getFormattingTags">
		<tags>
			<xsl:if test="ancestor::mn:strong"><tag>strong</tag></xsl:if>
			<xsl:if test="ancestor::mn:em"><tag>em</tag></xsl:if>
			<xsl:if test="ancestor::mn:sub"><tag>sub</tag></xsl:if>
			<xsl:if test="ancestor::mn:sup"><tag>sup</tag></xsl:if>
			<xsl:if test="ancestor::mn:tt"><tag>tt</tag></xsl:if>
			<xsl:if test="ancestor::mn:sourcecode"><tag>sourcecode</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'keep-together_within-line']"><tag>keep-together_within-line</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'font_en_vertical']"><tag>font_en_vertical</tag></xsl:if>
		</tags>
	</xsl:template>
	<!-- =============================== -->
	<!-- END mode="td_text_with_formatting" -->
	<!-- =============================== -->

	<!-- ========================== -->
	<!-- Definition's list styles -->
	<!-- ========================== -->

	<xsl:attribute-set name="dl-block-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="dt-row-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="dt-cell-style">
	</xsl:attribute-set>

	<xsl:template name="refine_dt-cell-style">
	</xsl:template> <!-- refine_dt-cell-style -->

	<xsl:attribute-set name="dt-block-style">
		<xsl:attribute name="margin-top">0pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_dt-block-style">
	</xsl:template> <!-- refine_dt-block-style -->

	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set> <!-- dl-name-style -->

	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_dd-cell-style">
	</xsl:template> <!-- refine_dd-cell-style -->

	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->

	<!-- ===================== -->
	<!-- Definition List -->
	<!-- ===================== -->

	<!-- for table auto-layout algorithm -->
	<xsl:template match="mn:dl" priority="2">
		<xsl:choose>
			<xsl:when test="$table_only_with_id != '' and @id = $table_only_with_id">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_id != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:when test="$table_only_with_ids != '' and contains($table_only_with_ids, concat(@id, ' '))">
				<xsl:call-template name="dl"/>
			</xsl:when>
			<xsl:when test="$table_only_with_ids != ''"><fo:block/><!-- to prevent empty fo:block-container --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="dl"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- dl -->

	<xsl:template match="mn:dl" name="dl">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<!-- <dl><xsl:copy-of select="."/></dl> -->
		<fo:block-container xsl:use-attribute-sets="dl-block-style" role="SKIP">

			<xsl:if test="@key = 'true' and ancestor::mn:figure">
				<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setBlockSpanAll"/>
			<xsl:if test="not(ancestor::mn:quote)">
				<xsl:attribute name="margin-left">0mm</xsl:attribute>
			</xsl:if>

			<xsl:if test="ancestor::mn:sourcecode">
				<!-- set font-size as sourcecode font-size -->
				<xsl:variable name="sourcecode_attributes">
					<xsl:call-template name="get_sourcecode_attributes"/>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@font-size">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="parent::mn:note">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<fo:block-container margin-left="0mm" role="SKIP">
				<xsl:attribute name="margin-right">0mm</xsl:attribute>

				<xsl:variable name="parent" select="local-name(..)"/>

				<xsl:variable name="key_iso"> <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>

				<xsl:variable name="onlyOneComponent" select="normalize-space($parent = 'formula' and count(mn:dt) = 1)"/>

				<xsl:choose>
					<xsl:when test="$onlyOneComponent = 'true'"> <!-- only one component -->
						<fo:block margin-bottom="12pt" text-align="left">
							<!-- <xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/> -->
							<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="mn:dt/*"/>
							<xsl:if test="mn:dd/node()[normalize-space() != ''][1][self::text()]">
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:apply-templates select="mn:dd/node()" mode="inline"/>
						</fo:block>
					</xsl:when> <!-- END: only one component -->
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">

							<xsl:call-template name="refine_dl_formula_where_style"/>

							<!-- <xsl:variable name="title-where">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">where</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-where"/><xsl:if test="$namespace = 'bsi' or $namespace = 'itu'">:</xsl:if> -->
							<!-- preceding 'p' with word 'where' -->
							<xsl:apply-templates select="preceding-sibling::*[1][self::mn:p and @keep-with-next = 'true']/node()"/>
						</fo:block>
					</xsl:when>  <!-- END: a few components -->
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')"> <!-- definition list in a figure -->
						<!-- Presentation XML contains 'Key' caption, https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:if test="not(preceding-sibling::*[1][self::mn:p and @keep-with-next])"> <!-- for old Presentation XML -->
							<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">

								<xsl:call-template name="refine_figure_key_style"/>

								<xsl:variable name="title-key">
									<xsl:call-template name="getLocalizedString">
										<xsl:with-param name="key">key</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$title-key"/>
							</fo:block>
						</xsl:if>
					</xsl:when>  <!-- END: definition list in a figure -->
				</xsl:choose>

				<!-- a few components -->
				<xsl:if test="$onlyOneComponent = 'false'">
					<fo:block role="SKIP">

						<xsl:call-template name="refine_multicomponent_style"/>

						<xsl:if test="ancestor::*[self::mn:dd or self::mn:td]">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>

						<fo:block role="SKIP">

							<xsl:call-template name="refine_multicomponent_block_style"/>

							<xsl:apply-templates select="mn:fmt-name">
								<xsl:with-param name="process">true</xsl:with-param>
							</xsl:apply-templates>

							<xsl:if test="$isGenerateTableIF = 'true'">
								<!-- to determine start of table -->
								<fo:block id="{concat('table_if_start_',@id)}" keep-with-next="always" font-size="1pt">Start table '<xsl:value-of select="@id"/>'.</fo:block>
							</xsl:if>

							<fo:table width="95%" table-layout="fixed">

								<xsl:if test="$isGenerateTableIF = 'true'">
									<xsl:attribute name="wrap-option">no-wrap</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'"/>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
									</xsl:when>
								</xsl:choose>

								<xsl:choose>
									<xsl:when test="$isGenerateTableIF = 'true'">
										<!-- generate IF for table widths -->
										<!-- example:
											<tr>
												<td valign="top" align="left" id="tab-symdu_1_1">
													<p>Symbol</p>
													<word id="tab-symdu_1_1_word_1">Symbol</word>
												</td>
												<td valign="top" align="left" id="tab-symdu_1_2">
													<p>Description</p>
													<word id="tab-symdu_1_2_word_1">Description</word>
												</td>
											</tr>
										-->

										<!-- create virtual html table for dl/[dt and dd] -->
										<xsl:variable name="simple-table">
											<!-- initial='<xsl:copy-of select="."/>' -->
											<xsl:variable name="dl_table">
												<mn:tbody>
													<xsl:apply-templates mode="dl_if">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
											</xsl:variable>

											<!-- dl_table='<xsl:copy-of select="$dl_table"/>' -->

											<!-- Step: replace <br/> to <p>...</p> -->
											<xsl:variable name="table_without_br">
												<xsl:apply-templates select="xalan:nodeset($dl_table)" mode="table-without-br"/>
											</xsl:variable>

											<!-- table_without_br='<xsl:copy-of select="$table_without_br"/>' -->

											<!-- Step: add id to each cell -->
											<!-- add <word>...</word> for each word, image, math -->
											<xsl:variable name="simple-table-id">
												<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-id">
													<xsl:with-param name="id" select="@id"/>
												</xsl:apply-templates>
											</xsl:variable>

											<!-- simple-table-id='<xsl:copy-of select="$simple-table-id"/>' -->

											<xsl:copy-of select="xalan:nodeset($simple-table-id)"/>

										</xsl:variable>

										<!-- DEBUG: simple-table<xsl:copy-of select="$simple-table"/> -->

										<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if">
											<xsl:with-param name="table_or_dl">dl</xsl:with-param>
										</xsl:apply-templates>

									</xsl:when>
									<xsl:otherwise>

										<xsl:variable name="simple-table">

											<xsl:variable name="dl_table">
												<mn:tbody>
													<xsl:apply-templates mode="dl">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</mn:tbody>
											</xsl:variable>

											<xsl:copy-of select="$dl_table"/>
										</xsl:variable>

										<xsl:variable name="colwidths">
											<xsl:choose>
												<!-- dl from table[@class='dl'] -->
												<xsl:when test="mn:colgroup">
													<autolayout/>
													<xsl:for-each select="mn:colgroup/mn:col">
														<column><xsl:value-of select="translate(@width,'%m','')"/></column>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
													<xsl:call-template name="calculate-column-widths">
														<xsl:with-param name="cols-count" select="2"/>
														<xsl:with-param name="table" select="$simple-table"/>
													</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>

										<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
											DEBUG
											colwidths=<xsl:copy-of select="$colwidths"/>
										<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

										<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->

										<xsl:variable name="maxlength_dt">
											<xsl:call-template name="getMaxLength_dt"/>
										</xsl:variable>

										<xsl:variable name="isContainsKeepTogetherTag_">false
										</xsl:variable>
										<xsl:variable name="isContainsKeepTogetherTag" select="normalize-space($isContainsKeepTogetherTag_)"/>
										<!-- isContainsExpressReference=<xsl:value-of select="$isContainsExpressReference"/> -->
										<xsl:call-template name="setColumnWidth_dl">
											<xsl:with-param name="colwidths" select="$colwidths"/>
											<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
											<xsl:with-param name="isContainsKeepTogetherTag" select="$isContainsKeepTogetherTag"/>
										</xsl:call-template>

										<fo:table-body>

											<!-- DEBUG -->
											<xsl:if test="$table_if_debug = 'true'">
												<fo:table-row>
													<fo:table-cell number-columns-spanned="2" font-size="60%">
														<xsl:apply-templates select="xalan:nodeset($colwidths)" mode="print_as_xml"/>
													</fo:table-cell>
												</fo:table-row>
											</xsl:if>

											<xsl:apply-templates>
												<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
												<xsl:with-param name="split_keep-within-line" select="xalan:nodeset($colwidths)/split_keep-within-line"/>
											</xsl:apply-templates>

										</fo:table-body>
									</xsl:otherwise>
								</xsl:choose>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if> <!-- END: a few components -->
			</fo:block-container>
		</fo:block-container>

		<xsl:if test="$isGenerateTableIF = 'true'"> <!-- process nested 'dl' -->
			<xsl:apply-templates select="mn:dd/mn:dl"/>
		</xsl:if>

	</xsl:template> <!-- END: dl -->

	<xsl:template match="@*|node()" mode="dt_clean">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="dt_clean"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="mn:asciimath" mode="dt_clean"/>

	<xsl:template name="refine_dl_formula_where_style">
	</xsl:template> <!-- refine_dl_formula_where_style -->

	<xsl:template name="refine_multicomponent_style">
		<xsl:variable name="parent" select="local-name(..)"/>
	</xsl:template> <!-- refine_multicomponent_style -->

	<xsl:template name="refine_multicomponent_block_style">
		<xsl:variable name="parent" select="local-name(..)"/>
	</xsl:template> <!-- refine_multicomponent_block_style -->

	<!-- dl/name -->
	<xsl:template match="mn:dl/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="dl-name-style">

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>
		<xsl:param name="maxlength_dt"/>
		<xsl:param name="isContainsKeepTogetherTag"/>

		<!-- <colwidths><xsl:copy-of select="$colwidths"/></colwidths> -->

		<xsl:choose>
			<!-- <xsl:when test="@class = 'formula_dl' and local-name(..) = 'figure'">
				<fo:table-column column-width="10%"/>
				<fo:table-column column-width="90%"/>
			</xsl:when> -->
			<xsl:when test="xalan:nodeset($colwidths)/autolayout">
				<xsl:call-template name="insertTableColumnWidth">
					<xsl:with-param name="colwidths" select="$colwidths"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="ancestor::mn:dl"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colwidths)/autolayout">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$isContainsKeepTogetherTag">
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:when>
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="insertTableColumnWidth">
							<xsl:with-param name="colwidths" select="$colwidths"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertTableColumnWidth">
		<xsl:param name="colwidths"/>

		<xsl:for-each select="xalan:nodeset($colwidths)//column">
			<xsl:choose>
				<xsl:when test=". = 1 or . = 0">
					<fo:table-column column-width="proportional-column-width(2)"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- <fo:table-column column-width="proportional-column-width({.})"/> -->
					<xsl:variable name="divider">
						<xsl:value-of select="@divider"/>
						<xsl:if test="not(@divider)">1</xsl:if>
					</xsl:variable>
					<fo:table-column column-width="proportional-column-width({round(. div $divider)})"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="getMaxLength_dt">
		<xsl:variable name="lengths">
			<xsl:for-each select="mn:dt">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template>

	<!-- note in definition list: dl/note -->
	<!-- renders in the 2-column spanned table row -->
	<xsl:template match="mn:dl/mn:note" priority="2">
		<xsl:param name="key_iso"/>
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<!-- OLD Variant -->
		<!-- <fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="mn:name" />
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates select="node()[not(local-name() = 'name')]" />
				</fo:block>
			</fo:table-cell>
		</fo:table-row> -->
		<!-- <tr>
			<td number-columns-spanned="2">NOTE <xsl:apply-templates /> </td>
		</tr> 
		-->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="2">
				<fo:block role="SKIP">
					<xsl:call-template name="note"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- END: dl/note -->

	<!-- virtual html table for dl/[dt and dd]  -->
	<xsl:template match="mn:dt" mode="dl">
		<xsl:param name="id"/>
		<xsl:variable name="row_number" select="count(preceding-sibling::mn:dt) + 1"/>
		<mn:tr>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_1')"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</mn:td>
			<mn:td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'@',$row_number,'_2')"/>
				</xsl:attribute>
				<xsl:apply-templates select="following-sibling::mn:dd[1]">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>
			</mn:td>
		</mn:tr>
	</xsl:template>

	<!-- Definition's term -->
	<xsl:template match="mn:dt">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>

		<fo:table-row xsl:use-attribute-sets="dt-row-style">
			<xsl:call-template name="insert_dt_cell">
				<xsl:with-param name="key_iso" select="$key_iso"/>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:call-template>
			<xsl:for-each select="following-sibling::mn:dd[1]">
				<xsl:call-template name="insert_dd_cell">
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:call-template>
			</xsl:for-each>
		</fo:table-row>
	</xsl:template> <!-- END: dt -->

	<xsl:template name="insert_dt_cell">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dt-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_dt-cell-style"/>

			<xsl:call-template name="setNamedDestination"/>
			<fo:block xsl:use-attribute-sets="dt-block-style" role="SKIP">

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
					<xsl:copy-of select="@id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="@id"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="normalize-space($key_iso) = 'true'">
					<xsl:attribute name="margin-top">0</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="refine_dt-block-style"/>

				<xsl:apply-templates>
					<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
				</xsl:apply-templates>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dt_cell -->

	<xsl:template name="insert_dd_cell">
		<xsl:param name="split_keep-within-line"/>
		<fo:table-cell xsl:use-attribute-sets="dd-cell-style">

			<xsl:if test="$isGenerateTableIF = 'true'">
				<!-- border is mandatory, to calculate real width -->
				<xsl:attribute name="border">0.1pt solid black</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="refine_dd-cell-style"/>

			<fo:block role="SKIP">

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:apply-templates> <!-- following-sibling::mn:dd[1] -->
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."> <!-- following-sibling::mn:dd[1] -->
							<xsl:with-param name="process">true</xsl:with-param>
							<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
						</xsl:apply-templates>
					</xsl:otherwise>

				</xsl:choose>

				<xsl:if test="$isGenerateTableIF = 'true'"><fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- insert_dd_cell -->

	<!-- END Definition's term -->

	<xsl:template match="mn:dd" mode="dl"/>
	<xsl:template match="mn:dd" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:dd">
		<xsl:param name="process">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates select="@language"/>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:dd/*" mode="inline">
		<xsl:variable name="is_inline_element_after_where">
			<xsl:if test="self::mn:p and not(preceding-sibling::node()[normalize-space() != ''])">true</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$is_inline_element_after_where = 'true'">
				<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- =============================== -->
	<!-- mode="dl_if" -->
	<!-- =============================== -->
	<!-- virtual html table for dl/[dt and dd] for IF (Intermediate Format) -->
	<xsl:template match="mn:dt" mode="dl_if">
		<xsl:param name="id"/>
		<mn:tr>
			<mn:td>
				<xsl:copy-of select="node()"/>
			</mn:td>
			<mn:td>
				<!-- <xsl:copy-of select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]"/> -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/node()[not(local-name() = 'dl')]" mode="dl_if"/>
				<!-- get paragraphs from nested 'dl' -->
				<xsl:apply-templates select="following-sibling::mn:dd[1]/mn:dl" mode="dl_if_nested"/>
			</mn:td>
		</mn:tr>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if"/>

	<xsl:template match="*" mode="dl_if">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:p" mode="dl_if">
		<xsl:param name="indent"/>
		<mn:p>
			<xsl:copy-of select="@*"/>
			<xsl:value-of select="$indent"/>
			<xsl:copy-of select="node()"/>
		</mn:p>
	</xsl:template>

	<xsl:template match="*[local-name() = 'ul' or local-name() = 'ol']" mode="dl_if">
		<xsl:variable name="list_rendered_">
			<xsl:apply-templates select="."/>
		</xsl:variable>
		<xsl:variable name="list_rendered" select="xalan:nodeset($list_rendered_)"/>

		<xsl:variable name="indent">
			<xsl:for-each select="($list_rendered//fo:block[not(.//fo:block)])[1]">
				<xsl:apply-templates select="ancestor::*[@provisional-distance-between-starts]/@provisional-distance-between-starts" mode="dl_if"/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="mn:li" mode="dl_if">
		<xsl:param name="indent"/>
		<xsl:apply-templates mode="dl_if">
			<xsl:with-param name="indent" select="$indent"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="@provisional-distance-between-starts" mode="dl_if">
		<xsl:variable name="value" select="round(substring-before(.,'mm'))"/>
		<!-- emulate left indent for list item -->
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'x'"/>
			<xsl:with-param name="count" select="$value"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="mn:dl" mode="dl_if_nested">
		<xsl:for-each select="mn:dt">
			<mn:p>
				<xsl:copy-of select="node()"/>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="following-sibling::mn:dd[1]/mn:p/node()"/>
			</mn:p>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="mn:dd" mode="dl_if_nested"/>
	<!-- =============================== -->
	<!-- END mode="dl_if" -->
	<!-- =============================== -->
	<!-- ===================== -->
	<!-- END Definition List -->
	<!-- ===================== -->

	<xsl:attribute-set name="appendix-style">
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="appendix-example-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-top">8pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
	</xsl:attribute-set>

	<!-- ======================== -->
	<!-- Appendix processing -->
	<!-- ======================== -->
	<xsl:template match="mn:appendix">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="mn:fmt-title"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-title)]"/>
	</xsl:template>

	<xsl:template match="mn:appendix/mn:fmt-title" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:call-template name="setIDforNamedDestination"/><xsl:apply-templates/></fo:inline>
	</xsl:template>
	<!-- ======================== -->
	<!-- END Appendix processing -->
	<!-- ======================== -->

	<xsl:template match="mn:appendix//mn:example" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">
			<xsl:apply-templates select="mn:fmt-name"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
	</xsl:template>

	<xsl:attribute-set name="xref-style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="mn:fmt-xref">
		<xsl:call-template name="insert_basic_link">
			<xsl:with-param name="element">
				<xsl:variable name="alt_text">
					<xsl:call-template name="getAltText"/>
				</xsl:variable>
				<fo:basic-link internal-destination="{@target}" fox:alt-text="{$alt_text}" xsl:use-attribute-sets="xref-style">
					<xsl:if test="string-length(normalize-space()) &lt; 30 and not(contains(normalize-space(), 'http://')) and not(contains(normalize-space(), 'https://')) and not(ancestor::*[self::mn:table or self::mn:dl])">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
					</xsl:if>
					<xsl:if test="parent::mn:add">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:basic-link>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- xref -->

	<!-- command between two xref points to non-standard bibitem -->
	<xsl:template match="text()[. = ','][preceding-sibling::node()[1][self::mn:sup][mn:fmt-xref[@type = 'footnote']] and    following-sibling::node()[1][self::mn:sup][mn:fmt-xref[@type = 'footnote']]]"><xsl:value-of select="."/>
	</xsl:template>

	<xsl:attribute-set name="eref-style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_eref-style">
		<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
		<xsl:variable name="text" select="normalize-space()"/>
	</xsl:template> <!-- refine_eref-style -->

	<xsl:variable name="bibitems_">
		<xsl:for-each select="//mn:bibitem">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems" select="xalan:nodeset($bibitems_)"/>

	<!-- get all hidden bibitems to exclude them from eref/origin processing -->
	<xsl:variable name="bibitems_hidden_">
		<xsl:for-each select="//mn:bibitem[@hidden='true']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
		<xsl:for-each select="//mn:references[@hidden='true']//mn:bibitem">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems_hidden" select="xalan:nodeset($bibitems_hidden_)"/>
	<!-- ====== -->
	<!-- eref -->
	<!-- ====== -->
	<xsl:template match="mn:fmt-eref" name="eref">
		<xsl:variable name="current_bibitemid" select="@bibitemid"/>
		<!-- <xsl:variable name="external-destination" select="normalize-space(key('bibitems', $current_bibitemid)/mn:uri[@type = 'citation'])"/> -->
		<xsl:variable name="external-destination" select="normalize-space($bibitems/mn:bibitem[@id = $current_bibitemid]/mn:uri[@type = 'citation'])"/>
		<xsl:choose>
			<!-- <xsl:when test="$external-destination != '' or not(key('bibitems_hidden', $current_bibitemid))"> --> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
			<xsl:when test="$external-destination != '' or not($bibitems_hidden/mn:bibitem[@id = $current_bibitemid])"> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
						<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
						<xsl:attribute name="vertical-align">super</xsl:attribute>
						<xsl:attribute name="font-size">80%</xsl:attribute>
					</xsl:if>

					<xsl:call-template name="refine_eref-style"/>

					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link fox:alt-text="{@citeas}">
								<xsl:if test="normalize-space(@citeas) = ''">
									<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
								</xsl:if>
								<xsl:if test="@type = 'inline'">

									<xsl:call-template name="refine_basic_link_style"/>

								</xsl:if>

								<xsl:choose>
									<xsl:when test="$external-destination != ''"> <!-- external hyperlink -->
										<xsl:attribute name="external-destination"><xsl:value-of select="$external-destination"/></xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="internal-destination"><xsl:value-of select="@bibitemid"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>

								<xsl:apply-templates/>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise> <!-- if there is key('bibitems_hidden', $current_bibitemid) -->

				<!-- if in bibitem[@hidden='true'] there is url[@type='src'], then create hyperlink  -->
				<xsl:variable name="uri_src" select="normalize-space($bibitems_hidden/mn:bibitem[@id = $current_bibitemid]/mn:uri[@type = 'src'])"/>
				<xsl:choose>
					<xsl:when test="$uri_src != ''">
						<fo:basic-link external-destination="{$uri_src}" fox:alt-text="{$uri_src}"><xsl:apply-templates/></fo:basic-link>
					</xsl:when>
					<xsl:otherwise><fo:inline><xsl:apply-templates/></fo:inline></xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_basic_link_style">
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
	</xsl:template> <!-- refine_basic_link_style -->

	<!-- ====== -->
	<!-- END eref -->
	<!-- ====== -->

	<xsl:attribute-set name="note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="line-height">115%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_note-style">
		<xsl:if test="ancestor::mn:ul or ancestor::mn:ol and not(ancestor::mn:note[1]/following-sibling::*)">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="note-body-indent">10mm</xsl:variable>
	<xsl:variable name="note-body-indent-table">5mm</xsl:variable>

	<xsl:attribute-set name="note-name-style">
		<!-- <xsl:attribute name="padding-right">4mm</xsl:attribute> -->
	</xsl:attribute-set>

	<xsl:template name="refine_note-name-style">
	</xsl:template> <!-- refine_note-name-style -->

	<xsl:attribute-set name="table-note-name-style">
		<xsl:attribute name="padding-right">2mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_table-note-name-style">
	</xsl:template> <!-- refine_table-note-name-style -->

	<xsl:attribute-set name="note-p-style">
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="termnote-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_termnote-style">
	</xsl:template> <!-- refine_termnote-style -->

	<xsl:attribute-set name="termnote-name-style">
	</xsl:attribute-set>

	<xsl:template name="refine_termnote-name-style">
	</xsl:template>

	<xsl:attribute-set name="termnote-p-style">
		<xsl:attribute name="space-before">4pt</xsl:attribute>
	</xsl:attribute-set>

	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->

	<xsl:template match="mn:note" name="note">

		<xsl:call-template name="setNamedDestination"/>

		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_note-style"/>

			<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block>

							<xsl:call-template name="refine_note_block_style"/>

							<fo:inline xsl:use-attribute-sets="note-name-style" role="SKIP">

								<xsl:apply-templates select="mn:fmt-name/mn:tab" mode="tab"/>

								<xsl:call-template name="refine_note-name-style"/>

								<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
								<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
								<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
									<xsl:call-template name="append_add-style"/>
								</xsl:if>

								<!-- if note contains only one element and first and last childs are `add` ace-tag, then move start ace-tag before NOTE's name-->
								<xsl:if test="count(*[not(self::mn:fmt-name)]) = 1 and *[not(self::mn:fmt-name)]/node()[last()][self::mn:add][starts-with(text(), $ace_tag)]">
									<xsl:apply-templates select="*[not(self::mn:fmt-name)]/node()[1][self::mn:add][starts-with(text(), $ace_tag)]">
										<xsl:with-param name="skip">false</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>

								<xsl:apply-templates select="mn:fmt-name"/>

							</fo:inline>

							<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
						</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="refine_note_block_style">
	</xsl:template> <!-- refine_note_block_style -->

	<xsl:template match="mn:note/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- display first NOTE's paragraph in the same line with label NOTE -->
				<fo:inline xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style" role="SKIP">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:termnote">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_termnote-style"/>

			<fo:inline xsl:use-attribute-sets="termnote-name-style">

				<xsl:call-template name="refine_termnote-name-style"/>

				<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
				<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
				<xsl:if test="*[not(self::mn:fmt-name)][1][count(node()[normalize-space() != '']) = 1 and mn:add]">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>

				<xsl:apply-templates select="mn:fmt-name"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:note/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'iho' or $namespace = 'gb' or $namespace = 'm3d' or $namespace = 'unece-rec' or $namespace = 'unece'  or $namespace = 'rsd'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termnote/mn:fmt-name">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- https://github.com/metanorma/isodoc/issues/607 -->
					<!-- <xsl:if test="$namespace = 'ieee'">
						<xsl:text>—</xsl:text> em dash &#x2014;
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' or $namespace = 'rsd' or $namespace = 'jcgm'">
						<xsl:text>:</xsl:text>
					</xsl:if> -->
					<!-- <xsl:if test="$namespace = 'itu' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'unece-rec' or $namespace = 'unece'">				
						<xsl:text> – </xsl:text> en dash &#x2013;
					</xsl:if> -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:termnote/mn:p">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- first paragraph renders in the same line as titlenote name -->
				<fo:inline xsl:use-attribute-sets="termnote-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="termnote-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-left">13mm</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_quote-style">
	</xsl:template>

	<xsl:attribute-set name="quote-source-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
		<xsl:attribute name="margin-right">25mm</xsl:attribute>
	</xsl:attribute-set>

	<!-- ====== -->
	<!-- quote -->
	<!-- source -->
	<!-- author  -->
	<!-- ====== -->
	<xsl:template match="mn:quote">
		<fo:block-container margin-left="0mm" role="SKIP">

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:if test="parent::mn:note">
				<xsl:if test="not(ancestor::mn:table)">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<fo:block-container xsl:use-attribute-sets="quote-style" role="SKIP">

					<xsl:call-template name="refine_quote-style"/>

					<fo:block-container margin-left="0mm" margin-right="0mm" role="SKIP">
						<fo:block role="BlockQuote">
							<xsl:apply-templates select="./node()[not(self::mn:author) and         not(self::mn:fmt-source) and         not(self::mn:attribution)]"/> <!-- process all nested nodes, except author and source -->
						</fo:block>
					</fo:block-container>
				</fo:block-container>
				<xsl:if test="mn:author or mn:fmt-source or mn:attribution">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="mn:author"/>
						<xsl:apply-templates select="mn:fmt-source"/>
						<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
						<xsl:apply-templates select="mn:attribution/mn:p/node()"/>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:fmt-source">
		<xsl:if test="../mn:author">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="not(parent::quote)">
				<fo:block>
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
								<xsl:apply-templates/>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
							<xsl:apply-templates/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:author">
		<xsl:if test="local-name(..) = 'quote'"> <!-- for old Presentation XML, https://github.com/metanorma/isodoc/issues/607 -->
			<xsl:text>— </xsl:text>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:quote//mn:referenceFrom"/>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:attribute-set name="figure-block-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_figure-block-style">
	</xsl:template>

	<xsl:attribute-set name="figure-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style">
		<xsl:attribute name="role">Caption</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="margin-top">0pt</xsl:attribute>
		<xsl:attribute name="space-after">6pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_figure-name-style">
	</xsl:template> <!-- refine_figure-name-style -->

	<xsl:attribute-set name="image-style">
		<xsl:attribute name="role">SKIP</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="space-before">12pt</xsl:attribute>
		<xsl:attribute name="space-after">0pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_image-style">
	</xsl:template>

	<xsl:attribute-set name="image-graphic-style">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="content-height">100%</xsl:attribute>
		<xsl:attribute name="scaling">uniform</xsl:attribute>
		<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-source-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-pseudocode-p-style">
	</xsl:attribute-set>

	<!-- ============================ -->
	<!-- figure's footnotes rendering -->
	<!-- ============================ -->

	<!-- figure/fmt-footnote-container -->
	<xsl:template match="mn:figure//mn:fmt-footnote-container"/>

	<!-- TO DO: remove, now the figure fn in figure/dl/... https://github.com/metanorma/isodoc/issues/658 -->
	<xsl:template name="figure_fn_display">

		<xsl:variable name="references">
			<xsl:for-each select="./mn:fmt-footnote-container/mn:fmt-fn-body">
				<xsl:variable name="curr_id" select="@id"/>
				<!-- <curr_id><xsl:value-of select="$curr_id"/></curr_id>
				<curr><xsl:copy-of select="."/></curr>
				<ancestor><xsl:copy-of select="ancestor::mn:figure[.//mn:name[.//mn:fn]]"/></ancestor> -->
				<xsl:choose>
					<!-- skip figure/name/fn -->
					<xsl:when test="ancestor::mn:figure[.//mn:fmt-name[.//mn:fn[@target = $curr_id]]]"><!-- skip --></xsl:when>
					<xsl:otherwise>
						<xsl:element name="figure" namespace="{$namespace_full}">
							<xsl:element name="fmt-footnote-container" namespace="{$namespace_full}">
								<xsl:copy-of select="."/>
							</xsl:element>
						</xsl:element>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<!-- <references><xsl:copy-of select="$references"/></references> -->

		<xsl:if test="xalan:nodeset($references)//mn:fmt-fn-body">

			<xsl:variable name="key_iso">
			</xsl:variable>

			<fo:block>
				<!-- current hierarchy is 'figure' element -->
				<xsl:variable name="following_dl_colwidths">
					<xsl:if test="mn:dl"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
						<xsl:variable name="simple-table">
							<!-- <xsl:variable name="doc_ns">
								<xsl:if test="$namespace = 'bipm'">bipm</xsl:if>
							</xsl:variable>
							<xsl:variable name="ns">
								<xsl:choose>
									<xsl:when test="normalize-space($doc_ns)  != ''">
										<xsl:value-of select="normalize-space($doc_ns)"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring-before(name(/*), '-')"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable> -->

							<xsl:for-each select="mn:dl[1]">
								<mn:tbody>
									<xsl:apply-templates mode="dl"/>
								</mn:tbody>
							</xsl:for-each>
						</xsl:variable>

						<xsl:call-template name="calculate-column-widths">
							<xsl:with-param name="cols-count" select="2"/>
							<xsl:with-param name="table" select="$simple-table"/>
						</xsl:call-template>

					</xsl:if>
				</xsl:variable>

				<xsl:variable name="maxlength_dt">
					<xsl:for-each select="mn:dl[1]">
						<xsl:call-template name="getMaxLength_dt"/>
					</xsl:for-each>
				</xsl:variable>

				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="5%"/>
							<fo:table-column column-width="95%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<!-- <xsl:for-each select="xalan:nodeset($references)//fn"> -->
						<xsl:for-each select="xalan:nodeset($references)//mn:fmt-fn-body">

							<xsl:variable name="reference" select="@reference"/>
							<!-- <xsl:if test="not(preceding-sibling::*[@reference = $reference])"> --> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline id="{@id}" xsl:use-attribute-sets="figure-fmt-fn-label-style">
												<!-- <xsl:attribute name="padding-right">0mm</xsl:attribute> -->
												<!-- <xsl:value-of select="@reference"/> -->
												<xsl:value-of select="normalize-space(.//mn:fmt-fn-label)"/>
											</fo:inline>

										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block xsl:use-attribute-sets="figure-fn-body-style">
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											<!-- <xsl:copy-of select="./node()"/> -->
											<xsl:apply-templates/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							<!-- </xsl:if> -->
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
	</xsl:template> <!-- figure_fn_display -->

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label"> <!-- mn:fmt-footnote-container/ -->
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:inline xsl:use-attribute-sets="figure-fn-number-style" role="SKIP">
				<xsl:attribute name="padding-right">0mm</xsl:attribute>

				<!-- tab is padding-right -->
				<xsl:apply-templates select=".//mn:tab">
					<xsl:with-param name="process">true</xsl:with-param>
				</xsl:apply-templates>

				<xsl:apply-templates/>

			</fo:inline>
		</xsl:if>
	</xsl:template> <!--  figure//fmt-fn-body//fmt-fn-label -->

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:tab" priority="5">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">

		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:figure//mn:fmt-fn-body//mn:fmt-fn-label//mn:sup" priority="5">
		<fo:inline xsl:use-attribute-sets="figure-fmt-fn-label-style" role="SKIP">
			<xsl:call-template name="refine_figure-fmt-fn-label-style"/>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- added for https://github.com/metanorma/isodoc/issues/607 -->
	<!-- figure's footnote label -->
	<!-- figure/dl[@key = 'true']/dt/p/sup -->
	<xsl:template match="mn:figure/mn:dl[@key = 'true']/mn:dt/     mn:p[count(node()[normalize-space() != '']) = 1]/mn:sup" priority="3">
		<xsl:variable name="key_iso">
		</xsl:variable>
		<xsl:if test="normalize-space($key_iso) = 'true'">
			<xsl:attribute name="font-size">10pt</xsl:attribute>
		</xsl:if>
		<fo:inline xsl:use-attribute-sets="figure-fn-number-style figure-fmt-fn-label-style"> <!-- id="{@id}"  -->
			<!-- <xsl:value-of select="@reference"/> -->
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ============================ -->
	<!-- END: figure's footnotes rendering -->
	<!-- ============================ -->

	<!-- caption for figure key and another caption, https://github.com/metanorma/isodoc/issues/607 -->
	<xsl:template match="mn:figure/mn:p[@keep-with-next = 'true' and mn:strong]" priority="3">
		<fo:block text-align="left" margin-bottom="12pt" keep-with-next="always" keep-with-previous="always">
			<xsl:call-template name="refine_figure_key_style"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_figure_key_style">
	</xsl:template> <!-- refine_figure_key_style -->

	<!-- ====== -->
	<!-- figure    -->
	<!-- image    -->
	<!-- ====== -->

	<xsl:template match="mn:figure" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="figure-block-style">
			<xsl:call-template name="refine_figure-block-style"/>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<!-- Example: Dimensions in millimeters -->
			<xsl:apply-templates select="mn:note[@type = 'units']"/>

			<xsl:variable name="show_figure_key_in_block_container">true
			</xsl:variable>

			<fo:block xsl:use-attribute-sets="figure-style" role="SKIP">

				<xsl:for-each select="mn:fmt-name"> <!-- set context -->
					<xsl:call-template name="setIDforNamedDestination"/>
				</xsl:for-each>

				<xsl:apply-templates select="node()[not(self::mn:fmt-name) and not(self::mn:note and @type = 'units')]"/>
			</fo:block>

			<xsl:if test="normalize-space($show_figure_key_in_block_container) = 'true'">
				<xsl:call-template name="showFigureKey"/>
			</xsl:if>
			<xsl:apply-templates select="mn:fmt-name"/> <!-- show figure's name AFTER image -->

		</fo:block-container>
	</xsl:template>

	<xsl:template name="showFigureKey">
		<xsl:for-each select="*[(self::mn:note and not(@type = 'units')) or self::mn:example]">
			<xsl:choose>
				<xsl:when test="self::mn:note">
					<xsl:call-template name="note"/>
				</xsl:when>
				<xsl:when test="self::mn:example">
					<xsl:call-template name="example"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<!-- TO DO: remove, now the figure fn in figure/dl/... https://github.com/metanorma/isodoc/issues/658 -->
		<xsl:call-template name="figure_fn_display"/>
	</xsl:template>

	<xsl:template match="mn:figure[@class = 'pseudocode']">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
		</fo:block>
		<xsl:apply-templates select="mn:fmt-name"/>
	</xsl:template>

	<xsl:template match="mn:figure[@class = 'pseudocode']//mn:p">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- SOURCE: ... -->
	<!-- figure/source -->
	<xsl:template match="mn:figure/mn:fmt-source" priority="2">
		<xsl:call-template name="termsource"/>
	</xsl:template>

	<xsl:template match="mn:image">
		<xsl:param name="indent">0</xsl:param>
		<xsl:param name="logo_width"/>
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::mn:fmt-title or not(parent::mn:figure) or parent::mn:p"> <!-- inline image ( 'image:path' in adoc, with one colon after image) -->
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:if test="not(parent::mn:figure) or parent::mn:p">
						<xsl:attribute name="padding-left">0mm</xsl:attribute>
						<xsl:attribute name="padding-right">0mm</xsl:attribute>
					</xsl:if>
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:call-template name="getImageScale">
							<xsl:with-param name="indent" select="$indent"/>
						</xsl:call-template>
					</xsl:variable>

					<!-- debug scale='<xsl:value-of select="$scale"/>', indent='<xsl:value-of select="$indent"/>' -->

					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle">

						<xsl:if test="parent::mn:logo"> <!-- publisher's logo -->
							<xsl:attribute name="scaling">uniform</xsl:attribute>
							<xsl:choose>
								<xsl:when test="@width and not(@height)">
									<xsl:attribute name="width">100%</xsl:attribute>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:when>
								<xsl:when test="@height and not(@width)">
									<xsl:attribute name="height">100%</xsl:attribute>
									<xsl:attribute name="content-height"><xsl:value-of select="@height"/></xsl:attribute>
								</xsl:when>
								<xsl:when test="not(@width) and not(@height)">
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:when>
							</xsl:choose>

							<xsl:if test="normalize-space($logo_width) != ''">
								<xsl:attribute name="width"><xsl:value-of select="$logo_width"/></xsl:attribute>
							</xsl:if>
							<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
							<xsl:attribute name="vertical-align">top</xsl:attribute>
						</xsl:if>

						<xsl:variable name="width">
							<xsl:call-template name="setImageWidth"/>
						</xsl:variable>
						<xsl:if test="$width != ''">
							<xsl:attribute name="width"><xsl:value-of select="$width"/></xsl:attribute>
						</xsl:if>
						<xsl:variable name="height">
							<xsl:call-template name="setImageHeight"/>
						</xsl:variable>
						<xsl:if test="$height != ''">
							<xsl:attribute name="height"><xsl:value-of select="$height"/></xsl:attribute>
						</xsl:if>

						<xsl:if test="$width = '' and $height = ''">
							<xsl:if test="number($scale) &lt; 100">
								<xsl:attribute name="content-width"><xsl:value-of select="number($scale)"/>%</xsl:attribute>
								<!-- <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute> -->
							</xsl:if>
						</xsl:if>

					</fo:external-graphic>

				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">

					<xsl:call-template name="refine_image-style"/>

					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="$isDeleted = 'true'">
							<!-- enclose in svg -->
							<fo:instream-foreign-object fox:alt-text="Image {@alt}">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute>

								<xsl:apply-templates select="." mode="cross_image"/>

							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:otherwise>
							<!-- <fo:block>debug block image:
							<xsl:variable name="scale">
								<xsl:call-template name="getImageScale">
									<xsl:with-param name="indent" select="$indent"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="concat('scale=', $scale,', indent=', $indent)"/>
							</fo:block> -->

							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}">

								<xsl:choose>
									<!-- default -->
									<xsl:when test="((@width = 'auto' or @width = 'text-width' or @width = 'full-page-width' or @width = 'narrow') and @height = 'auto') or            (normalize-space(@width) = '' and normalize-space(@height) = '') ">
										<!-- add attribute for automatic scaling -->
										<xsl:variable name="image-graphic-style_attributes">
											<attributes xsl:use-attribute-sets="image-graphic-style"/>
										</xsl:variable>
										<xsl:copy-of select="xalan:nodeset($image-graphic-style_attributes)/attributes/@*"/>

										<xsl:if test="not(@mimetype = 'image/svg+xml') and not(ancestor::mn:table)">
											<xsl:variable name="scale">
												<xsl:call-template name="getImageScale">
													<xsl:with-param name="indent" select="$indent"/>
												</xsl:call-template>
											</xsl:variable>

											<xsl:variable name="scaleRatio">1
											</xsl:variable>

											<xsl:if test="number($scale) &lt; 100">
												<xsl:attribute name="content-width"><xsl:value-of select="number($scale) * number($scaleRatio)"/>%</xsl:attribute>
											</xsl:if>
										</xsl:if>

									</xsl:when> <!-- default -->
									<xsl:otherwise>

										<xsl:variable name="width_height_">
											<attributes>
												<xsl:call-template name="setImageWidthHeight"/>
											</attributes>
										</xsl:variable>
										<xsl:variable name="width_height" select="xalan:nodeset($width_height_)"/>

										<xsl:copy-of select="$width_height/attributes/@*"/>

										<xsl:if test="$width_height/attributes/@content-width != '' and             $width_height/attributes/@content-height != ''">
											<xsl:attribute name="scaling">non-uniform</xsl:attribute>
										</xsl:if>

									</xsl:otherwise>
								</xsl:choose>

								<!-- 
								<xsl:if test="not(@mimetype = 'image/svg+xml') and (../mn:name or parent::mn:figure[@unnumbered = 'true']) and not(ancestor::mn:table)">
								-->

							</fo:external-graphic>
						</xsl:otherwise>
					</xsl:choose>

				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setImageWidth">
		<xsl:if test="@width != '' and @width != 'auto' and @width != 'text-width' and @width != 'full-page-width' and @width != 'narrow'">
			<xsl:value-of select="@width"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageHeight">
		<xsl:if test="@height != '' and @height != 'auto'">
			<xsl:value-of select="@height"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="setImageWidthHeight">
		<xsl:variable name="width">
			<xsl:call-template name="setImageWidth"/>
		</xsl:variable>
		<xsl:if test="$width != ''">
			<xsl:attribute name="content-width">
				<xsl:value-of select="$width"/>
			</xsl:attribute>
		</xsl:if>
		<xsl:variable name="height">
			<xsl:call-template name="setImageHeight"/>
		</xsl:variable>
		<xsl:if test="$height != ''">
			<xsl:attribute name="content-height">
				<xsl:value-of select="$height"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getImageSrc">
		<xsl:choose>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:call-template name="getImageSrcExternal"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getImageSrcExternal">
		<xsl:choose>
			<xsl:when test="@extracted = 'true'"> <!-- added in mn2pdf v1.97 -->
				<xsl:value-of select="@src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_with_basepath" select="concat($basepath, @src)"/>
				<xsl:variable name="file_exists" select="normalize-space(java:exists(java:java.io.File.new($src_with_basepath)))"/>
				<xsl:choose>
					<xsl:when test="$file_exists = 'true'">
						<xsl:value-of select="$src_with_basepath"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@src"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getImageScale">
		<xsl:param name="indent"/>
		<xsl:variable name="indent_left">
			<xsl:choose>
				<xsl:when test="$indent != ''"><xsl:value-of select="$indent"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="img_src">
			<xsl:call-template name="getImageSrc"/>
		</xsl:variable>

		<xsl:variable name="image_width_effective">
			<xsl:value-of select="$width_effective - number($indent_left)"/>
		</xsl:variable>
		<xsl:variable name="image_height_effective" select="$height_effective - number($indent_left)"/>
		<!-- <xsl:message>width_effective=<xsl:value-of select="$width_effective"/></xsl:message>
		<xsl:message>indent_left=<xsl:value-of select="$indent_left"/></xsl:message>
		<xsl:message>image_width_effective=<xsl:value-of select="$image_width_effective"/></xsl:message> --> <!--  for <xsl:value-of select="ancestor::mn:p[1]/@id"/> -->
		<xsl:variable name="scale">
			<xsl:value-of select="java:org.metanorma.fop.utils.ImageUtils.getImageScale($img_src, $image_width_effective, $height_effective)"/>
		</xsl:variable>
		<!-- <xsl:message>scale=<xsl:value-of select="$scale"/></xsl:message> -->
		<xsl:value-of select="$scale"/>
	</xsl:template>

	<xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<!-- in WebP format, then convert image into PNG -->
			<xsl:when test="starts-with(@src, 'data:image/webp')">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="$src_png"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:')) and        (java:endsWith(java:java.lang.String.new(@src), '.webp') or       java:endsWith(java:java.lang.String.new(@src), '.WEBP'))">
				<xsl:variable name="src_png" select="java:org.metanorma.fop.utils.ImageUtils.convertWebPtoPNG(@src)"/>
				<xsl:value-of select="concat('url(file:///',$basepath, $src_png, ')')"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:variable name="file_protocol"><xsl:if test="not(starts-with($src_external, 'http:')) and not(starts-with($src_external, 'https:')) and not(starts-with($src_external, 'www.'))">file:///</xsl:if></xsl:variable>
				<xsl:value-of select="concat('url(', $file_protocol, $src_external, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:image" mode="cross_image">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:variable name="src">
					<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
				</xsl:variable>
				<xsl:variable name="width" select="document($src)/@width"/>
				<xsl:variable name="height" select="document($src)/@height"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:variable name="src" select="concat('url(file:///', $src_external, ')')"/>
				<xsl:variable name="file" select="java:java.io.File.new(@src)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="base64String" select="substring-after(@src, 'base64,')"/>
				<xsl:variable name="decoder" select="java:java.util.Base64.getDecoder()"/>
				<xsl:variable name="fileContent" select="java:decode($decoder, $base64String)"/>
				<xsl:variable name="bis" select="java:java.io.ByteArrayInputStream.new($fileContent)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($bis)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
	</xsl:template>

	<!-- =================== -->
	<!-- SVG images processing -->
	<!-- =================== -->
	<xsl:variable name="figure_name_height">14</xsl:variable>
	<xsl:variable name="width_effective" select="$pageWidth - $marginLeftRight1 - $marginLeftRight2"/><!-- paper width minus margins -->
	<xsl:variable name="height_effective" select="$pageHeight - $marginTop - $marginBottom - $figure_name_height"/><!-- paper height minus margins and title height -->
	<xsl:variable name="image_dpi" select="96"/>
	<xsl:variable name="width_effective_px" select="$width_effective div 25.4 * $image_dpi"/>
	<xsl:variable name="height_effective_px" select="$height_effective div 25.4 * $image_dpi"/>

	<xsl:template match="mn:figure[not(mn:image) and *[local-name() = 'svg']]/mn:fmt-name/mn:bookmark" priority="2"/>
	<xsl:template match="mn:figure[not(mn:image)]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>

		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>

		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../mn:fmt-name) != ''">
					<xsl:value-of select="../mn:fmt-name"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isPrecedingTitle" select="normalize-space(ancestor::mn:figure/preceding-sibling::*[1][self::mn:fmt-title] and 1 = 1)"/>

		<xsl:choose>
			<xsl:when test=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]">
				<fo:block>
					<xsl:variable name="width" select="@width"/>
					<xsl:variable name="height" select="@height"/>

					<xsl:variable name="scale_x">
						<xsl:choose>
							<xsl:when test="$width &gt; $width_effective_px">
								<xsl:value-of select="$width_effective_px div $width"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale_y">
						<xsl:choose>
							<xsl:when test="$height * $scale_x &gt; $height_effective_px">
								<xsl:value-of select="$height_effective_px div ($height * $scale_x)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="scale">
						<xsl:choose>
							<xsl:when test="$scale_y != 1">
								<xsl:value-of select="$scale_x * $scale_y"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scale_x"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="width_scale" select="round($width * $scale)"/>
					<xsl:variable name="height_scale" select="round($height * $scale)"/>

					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{$width_scale}px"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block>
										<fo:block-container width="{$width_scale}px" height="{$height_scale}px">
											<xsl:if test="../mn:fmt-name/mn:bookmark">
												<fo:block line-height="0" font-size="0">
													<xsl:for-each select="../mn:fmt-name/mn:bookmark">
														<xsl:call-template name="bookmark"/>
													</xsl:for-each>
												</fo:block>
											</xsl:if>
											<fo:block text-depth="0" line-height="0" font-size="0">

												<fo:instream-foreign-object fox:alt-text="{$alt-text}">
													<xsl:attribute name="width">100%</xsl:attribute>
													<xsl:attribute name="content-height">100%</xsl:attribute>
													<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
													<xsl:attribute name="scaling">uniform</xsl:attribute>

													<xsl:apply-templates select="xalan:nodeset($svg_content)" mode="svg_remove_a"/>
												</fo:instream-foreign-object>
											</fo:block>

											<xsl:apply-templates select=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]" mode="svg_imagemap_links">
												<xsl:with-param name="scale" select="$scale"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>

			</xsl:when>
			<xsl:otherwise>

				<xsl:variable name="image_class" select="ancestor::mn:image/@class"/>
				<xsl:variable name="ancestor_table_cell" select="normalize-space(ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])"/>

				<xsl:variable name="element">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'tr'] and $isGenerateTableIF = 'true'">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:when test="not(ancestor::mn:figure)">
							<fo:inline xsl:use-attribute-sets="image-style" text-align="left"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:block xsl:use-attribute-sets="image-style">
								<xsl:if test="ancestor::mn:dt">
									<xsl:attribute name="text-align">left</xsl:attribute>
								</xsl:if>
							</fo:block>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($element)/*">
					<xsl:copy>
						<xsl:copy-of select="@*"/>
					<!-- <fo:block xsl:use-attribute-sets="image-style"> -->
						<fo:instream-foreign-object fox:alt-text="{$alt-text}">

							<xsl:choose>
								<xsl:when test="$image_class = 'corrigenda-tag'">
									<xsl:attribute name="fox:alt-text">CorrigendaTag</xsl:attribute>
									<xsl:attribute name="baseline-shift">-10%</xsl:attribute>
									<xsl:if test="$ancestor_table_cell = 'true'">
										<xsl:attribute name="baseline-shift">-25%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="height">3.5mm</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="$isGenerateTableIF = 'false'">
										<xsl:attribute name="width">100%</xsl:attribute>
									</xsl:if>
									<xsl:attribute name="content-height">100%</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>

							<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
							<xsl:variable name="svg_width_" select="xalan:nodeset($svg_content)/*/@width"/>
							<xsl:variable name="svg_width" select="number(translate($svg_width_, 'px', ''))"/>
							<xsl:variable name="svg_height_" select="xalan:nodeset($svg_content)/*/@height"/>
							<xsl:variable name="svg_height" select="number(translate($svg_height_, 'px', ''))"/>

							<!-- Example: -->
							<!-- effective height 297 - 27.4 - 13 =  256.6 -->
							<!-- effective width 210 - 12.5 - 25 = 172.5 -->
							<!-- effective height / width = 1.48, 1.4 - with title -->

							<xsl:variable name="scale_x">
								<xsl:choose>
									<xsl:when test="$svg_width &gt; $width_effective_px">
										<xsl:value-of select="$width_effective_px div $svg_width"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="scale_y">
								<xsl:choose>
									<xsl:when test="$svg_height * $scale_x &gt; $height_effective_px">
										<xsl:variable name="height_effective_px_">
											<xsl:choose>
												<!-- title is 'keep-with-next' with following figure -->
												<xsl:when test="$isPrecedingTitle = 'true'"><xsl:value-of select="$height_effective_px - 80"/></xsl:when>
												<xsl:otherwise><xsl:value-of select="$height_effective_px"/></xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:value-of select="$height_effective_px_ div ($svg_height * $scale_x)"/>
									</xsl:when>
									<xsl:otherwise>1</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							 <!-- for images with big height -->
							<!-- <xsl:if test="$svg_height &gt; ($svg_width * 1.4)">
								<xsl:variable name="width" select="(($svg_width * 1.4) div $svg_height) * 100"/>
								<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
							</xsl:if> -->
							<xsl:attribute name="scaling">uniform</xsl:attribute>

							<xsl:if test="$scale_y != 1">
								<xsl:attribute name="content-height"><xsl:value-of select="round($scale_x * $scale_y * 100)"/>%</xsl:attribute>
							</xsl:if>

							<xsl:copy-of select="$svg_content"/>
						</fo:instream-foreign-object>
					<!-- </fo:block> -->
					</xsl:copy>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============== -->
	<!-- svg_update     -->
	<!-- ============== -->
	<xsl:template match="@*|node()" mode="svg_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:image/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

	<xsl:variable name="regex_starts_with_digit">^[0-9].*</xsl:variable>

	<xsl:template match="*[local-name() = 'svg'][not(@width and @height)]" mode="svg_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="svg_update"/>
			<xsl:variable name="viewbox_">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@viewBox"/>
					<xsl:with-param name="sep" select="' '"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="viewbox" select="xalan:nodeset($viewbox_)"/>
			<xsl:variable name="width" select="normalize-space($viewbox//mnx:item[3])"/>
			<xsl:variable name="height" select="normalize-space($viewbox//mnx:item[4])"/>

			<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[1][self::mn:image]/@width)"/>
			<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[1][self::mn:image]/@height)"/>

			<xsl:attribute name="width">
				<xsl:choose>
					<!-- width is non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
					<xsl:when test="$width != ''">
						<xsl:value-of select="round($width)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default width -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<!-- height non 'auto', 'text-width', 'full-page-width' or 'narrow' -->
					<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
					<xsl:when test="$height != ''">
						<xsl:value-of select="round($height)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default height -->
				</xsl:choose>
			</xsl:attribute>

			<xsl:apply-templates mode="svg_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@width" mode="svg_update">
		<!-- image[@width]/svg -->
		<xsl:variable name="parent_image_width" select="normalize-space(ancestor::*[2][self::mn:image]/@width)"/>
		<xsl:attribute name="width">
			<xsl:choose>
				<xsl:when test="$parent_image_width != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_width), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_width"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*[local-name() = 'svg']/@height" mode="svg_update">
		<!-- image[@height]/svg -->
		<xsl:variable name="parent_image_height" select="normalize-space(ancestor::*[2][self::mn:image]/@height)"/>
		<xsl:attribute name="height">
			<xsl:choose>
				<xsl:when test="$parent_image_height != '' and normalize-space(java:matches(java:java.lang.String.new($parent_image_height), $regex_starts_with_digit)) = 'true'"><xsl:value-of select="$parent_image_height"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<!-- regex for 'display: inline-block;' -->
	<xsl:variable name="regex_svg_style_notsupported">display(\s|\h)*:(\s|\h)*inline-block(\s|\h)*;</xsl:variable>
	<xsl:template match="*[local-name() = 'svg']//*[local-name() = 'style']/text()" mode="svg_update">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), $regex_svg_style_notsupported, '')"/>
	</xsl:template>

	<!-- replace
			stroke="rgba(r, g, b, alpha)" to 
			stroke="rgb(r,g,b)" stroke-opacity="alpha", and
			fill="rgba(r, g, b, alpha)" to 
			fill="rgb(r,g,b)" fill-opacity="alpha" -->
	<xsl:template match="@*[local-name() = 'stroke' or local-name() = 'fill'][starts-with(normalize-space(.), 'rgba')]" mode="svg_update">
		<xsl:variable name="components_">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-before(substring-after(., '('), ')')"/>
				<xsl:with-param name="sep" select="','"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="components" select="xalan:nodeset($components_)"/>
		<xsl:variable name="att_name" select="local-name()"/>
		<xsl:attribute name="{$att_name}"><xsl:value-of select="concat('rgb(', $components/mnx:item[1], ',', $components/mnx:item[2], ',', $components/mnx:item[3], ')')"/></xsl:attribute>
		<xsl:attribute name="{$att_name}-opacity"><xsl:value-of select="$components/mnx:item[4]"/></xsl:attribute>
	</xsl:template>

	<!-- ============== -->
	<!-- END: svg_update -->
	<!-- ============== -->

	<!-- image with svg and emf -->
	<xsl:template match="mn:figure/mn:image[*[local-name() = 'svg']]" priority="3">
		<xsl:variable name="name" select="ancestor::mn:figure/mn:fmt-name"/>
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- For the structures like: <dt><image src="" mimetype="image/svg+xml" height="" width=""><svg xmlns="http://www.w3.org/2000/svg" ... -->
	<xsl:template match="*[not(self::mn:figure)]/mn:image[*[local-name() = 'svg']]" priority="3">
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:figure/mn:image[@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::mn:figure/mn:fmt-name"/>
		<xsl:for-each select="xalan:nodeset($svg_content)/node()">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="@*|node()" mode="svg_remove_a">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_remove_a"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_remove_a">
		<xsl:apply-templates mode="svg_remove_a"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'a']" mode="svg_imagemap_links">
		<xsl:param name="scale"/>
		<xsl:variable name="dest">
			<xsl:choose>
				<xsl:when test="starts-with(@href, '#')">
					<xsl:value-of select="substring-after(@href, '#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="./*[local-name() = 'rect']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor(@x * $scale)"/>
				<xsl:with-param name="top" select="floor(@y * $scale)"/>
				<xsl:with-param name="width" select="floor(@width * $scale)"/>
				<xsl:with-param name="height" select="floor(@height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'polygon']">
			<xsl:variable name="points">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@points"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="x_coords">
				<xsl:for-each select="xalan:nodeset($points)//mnx:item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//mnx:item[position() mod 2 = 0]">
					<xsl:sort select="." data-type="number"/>
					<y><xsl:value-of select="."/></y>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="x" select="xalan:nodeset($x_coords)//x[1]"/>
			<xsl:variable name="y" select="xalan:nodeset($y_coords)//y[1]"/>
			<xsl:variable name="width" select="xalan:nodeset($x_coords)//x[last()] - $x"/>
			<xsl:variable name="height" select="xalan:nodeset($y_coords)//y[last()] - $y"/>
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor($x * $scale)"/>
				<xsl:with-param name="top" select="floor($y * $scale)"/>
				<xsl:with-param name="width" select="floor($width * $scale)"/>
				<xsl:with-param name="height" select="floor($height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>

		<xsl:for-each select="./*[local-name() = 'circle']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @r) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @r) * $scale)"/>
				<xsl:with-param name="width" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="./*[local-name() = 'ellipse']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @rx) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @ry) * $scale)"/>
				<xsl:with-param name="width" select="floor(@rx * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@ry * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="insertSVGMapLink">
		<xsl:param name="left"/>
		<xsl:param name="top"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="dest"/>
		<fo:block-container position="absolute" left="{$left}px" top="{$top}px" width="{$width}px" height="{$height}px">
		 <fo:block font-size="1pt">
			<xsl:call-template name="insert_basic_link">
				<xsl:with-param name="element">
					<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
						<fo:inline-container inline-progression-dimension="100%">
							<fo:block-container height="{$height - 1}px" width="100%">
								<!-- DEBUG <xsl:if test="local-name()='polygon'">
									<xsl:attribute name="background-color">magenta</xsl:attribute>
								</xsl:if> -->
							<fo:block> </fo:block></fo:block-container>
						</fo:inline-container>
					</fo:basic-link>
				</xsl:with-param>
			</xsl:call-template>
		 </fo:block>
	  </fo:block-container>
	</xsl:template>
	<!-- =================== -->
	<!-- End SVG images processing -->
	<!-- =================== -->

	<!-- ignore emf processing (Apache FOP doesn't support EMF) -->
	<xsl:template match="mn:emf"/>

	<!-- figure/name -->
	<xsl:template match="mn:figure/mn:fmt-name |         mn:image/mn:fmt-name">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="figure-name-style">

				<xsl:call-template name="refine_figure-name-style"/>

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<!-- figure/fn -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:fn" priority="2"/>
	<!-- figure/note -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:note" priority="2"/>
	<!-- figure/example -->
	<xsl:template match="mn:figure[not(@class = 'pseudocode')]/mn:example" priority="2"/>

	<!-- figure/note[@type = 'units'] -->
	<!-- image/note[@type = 'units'] -->
	<xsl:template match="mn:figure/mn:note[@type = 'units'] |         mn:image/mn:note[@type = 'units']" priority="2">
		<fo:block text-align="right" keep-with-next="always">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Formula's styles -->
	<xsl:attribute-set name="formula-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- formula-style -->

	<xsl:attribute-set name="formula-stem-block-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="text-align">left</xsl:attribute>
		<xsl:attribute name="margin-left">5mm</xsl:attribute>
	</xsl:attribute-set> <!-- formula-stem-block-style -->

	<xsl:template name="refine_formula-stem-block-style">
	</xsl:template> <!-- refine_formula-stem-block-style -->

	<xsl:attribute-set name="formula-stem-number-style">
		<xsl:attribute name="text-align">right</xsl:attribute>
	</xsl:attribute-set> <!-- formula-stem-number-style -->
	<!-- End Formula's styles -->

	<xsl:template name="refine_formula-stem-number-style">
	</xsl:template>

	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_mathml-style">
	</xsl:template>

	<!-- ====== -->
	<!-- formula  -->
	<!-- ====== -->
	<xsl:template match="mn:formula" name="formula">
		<fo:block-container margin-left="0mm" role="SKIP">
			<xsl:if test="parent::mn:note">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" role="SKIP">
				<xsl:call-template name="setNamedDestination"/>
				<fo:block id="{@id}">
					<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/> <!-- formula's number will be process in 'stem' template -->
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="mn:formula/mn:dt/mn:fmt-stem">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:fmt-admitted/mn:fmt-stem">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:formula/mn:fmt-name"> <!-- show in 'stem' template -->
		<!-- https://github.com/metanorma/isodoc/issues/607 
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates /><xsl:text>)</xsl:text>
		</xsl:if> -->
		<xsl:apply-templates/>
	</xsl:template>

	<!-- stem inside formula with name (with formula's number) -->
	<xsl:template match="mn:formula[mn:fmt-name]/mn:fmt-stem">
		<fo:block xsl:use-attribute-sets="formula-style">

			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-block-style" role="SKIP">

								<xsl:call-template name="refine_formula-stem-block-style"/>

								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">

							<fo:block xsl:use-attribute-sets="formula-stem-number-style" role="SKIP">

								<xsl:for-each select="../mn:fmt-name">
									<xsl:call-template name="setIDforNamedDestination"/>
								</xsl:for-each>

								<xsl:call-template name="refine_formula-stem-number-style"/>

								<xsl:apply-templates select="../mn:fmt-name"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!-- stem inside formula without name (without formula's number) -->
	<xsl:template match="mn:formula[not(mn:fmt-name)]/mn:fmt-stem">
		<fo:block xsl:use-attribute-sets="formula-style">
			<fo:block xsl:use-attribute-sets="formula-stem-block-style">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- ignore 'p' with 'where' in formula, before 'dl' -->
	<xsl:template match="mn:formula/*[self::mn:p and @keep-with-next = 'true' and following-sibling::*[1][self::mn:dl]]"/>

	<!-- ======================================= -->
	<!-- math -->
	<!-- ======================================= -->
	<xsl:template match="mn:stem[following-sibling::*[1][self::mn:fmt-stem]]"/> <!-- for tablesonly.xml generated by mn2pdf -->

	<xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<fo:inline xsl:use-attribute-sets="mathml-style">

			<!-- DEBUG -->
			<!-- <xsl:copy-of select="ancestor::mn:stem/@font-family"/> -->

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:if test="$isGenerateTableIF = 'true' and ancestor::*[local-name() = 'td' or local-name() = 'th' or local-name() = 'dl'] and not(following-sibling::node()[not(self::comment())][normalize-space() != ''])"> <!-- math in table cell, and math is last element -->
				<!-- <xsl:attribute name="padding-right">1mm</xsl:attribute> -->
			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<xsl:if test="$add_math_as_text = 'true'">
				<!-- insert helper tag -->
				<!-- set unique font-size (fiction) -->
				<xsl:variable name="font-size_sfx"><xsl:number level="any"/></xsl:variable>
				<fo:inline color="white" font-size="1.{$font-size_sfx}pt" font-style="normal" font-weight="normal"><xsl:value-of select="$zero_width_space"/></fo:inline> <!-- zero width space -->
			</xsl:if>

			<xsl:variable name="mathml_content">
				<xsl:apply-templates select="." mode="mathml_actual_text"/>
			</xsl:variable>
			<xsl:call-template name="mathml_instream_object">
				<xsl:with-param name="mathml_content" select="$mathml_content"/>
			</xsl:call-template>

		</fo:inline>
	</xsl:template>

	<xsl:template name="getMathml_comment_text">
		<xsl:variable name="comment_text_following" select="following-sibling::node()[1][self::comment()]"/>
		<xsl:variable name="comment_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($comment_text_following) != ''">
					<xsl:value-of select="$comment_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="comment_text_2" select="java:org.metanorma.fop.Util.unescape($comment_text_)"/>
		<xsl:variable name="comment_text" select="java:trim(java:java.lang.String.new($comment_text_2))"/>
		<xsl:value-of select="$comment_text"/>
	</xsl:template>

	<xsl:template match="mn:asciimath">
		<xsl:param name="process" select="'false'"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:latexmath"/>

	<xsl:template name="getMathml_asciimath_text">
		<xsl:variable name="asciimath" select="../mn:asciimath"/>
		<xsl:variable name="latexmath">
		</xsl:variable>
		<xsl:variable name="asciimath_text_following">
			<xsl:choose>
				<xsl:when test="normalize-space($latexmath) != ''">
					<xsl:value-of select="$latexmath"/>
				</xsl:when>
				<xsl:when test="normalize-space($asciimath) != ''">
					<xsl:value-of select="$asciimath"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="following-sibling::node()[1][self::comment()]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text_following) != ''">
					<xsl:value-of select="$asciimath_text_following"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(translate(.,' ⁢','  '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="asciimath_text_2" select="java:org.metanorma.fop.Util.unescape($asciimath_text_)"/>
		<xsl:variable name="asciimath_text" select="java:trim(java:java.lang.String.new($asciimath_text_2))"/>
		<xsl:value-of select="$asciimath_text"/>
	</xsl:template>

	<xsl:template name="mathml_instream_object">
		<xsl:param name="asciimath_text"/>
		<xsl:param name="mathml_content"/>

		<xsl:variable name="asciimath_text_">
			<xsl:choose>
				<xsl:when test="normalize-space($asciimath_text) != ''"><xsl:value-of select="$asciimath_text"/></xsl:when>
				<!-- <xsl:otherwise><xsl:call-template name="getMathml_comment_text"/></xsl:otherwise> -->
				<xsl:otherwise><xsl:call-template name="getMathml_asciimath_text"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="mathml">
			<xsl:apply-templates select="." mode="mathml"/>
		</xsl:variable>

		<fo:instream-foreign-object fox:alt-text="Math" fox:actual-text="Math">

			<xsl:call-template name="refine_mathml_insteam_object_style"/>

			<xsl:if test="$isGenerateTableIF = 'false'">
				<!-- put MathML in Actual Text -->
				<!-- DEBUG: mathml_content=<xsl:value-of select="$mathml_content"/> -->
				<xsl:attribute name="fox:actual-text">
					<xsl:value-of select="$mathml_content"/>
				</xsl:attribute>

				<!-- <xsl:if test="$add_math_as_text = 'true'"> -->
				<xsl:if test="normalize-space($asciimath_text_) != ''">
				<!-- put Mathin Alternate Text -->
					<xsl:attribute name="fox:alt-text">
						<xsl:value-of select="$asciimath_text_"/>
					</xsl:attribute>
				</xsl:if>
				<!-- </xsl:if> -->
			</xsl:if>

			<xsl:copy-of select="xalan:nodeset($mathml)"/>

		</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template name="refine_mathml_insteam_object_style">
	</xsl:template> <!-- refine_mathml_insteam_object_style -->

	<xsl:template match="mathml:*" mode="mathml_actual_text">
		<!-- <xsl:text>a+b</xsl:text> -->
		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:if test="local-name() = 'math'">
			<xsl:text> xmlns="http://www.w3.org/1998/Math/MathML"</xsl:text>
		</xsl:if>
		<xsl:for-each select="@*">
			<xsl:text> </xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:text>="</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>"</xsl:text>
		</xsl:for-each>
		<xsl:text>&gt;</xsl:text>
		<xsl:apply-templates mode="mathml_actual_text"/>
		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="local-name()"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="text()" mode="mathml_actual_text">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template>

	<!-- <xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = '&#xa0;'])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<xsl:choose>
			if in msub, then don't add space
			<xsl:when test="ancestor::mathml:mrow[parent::mathml:msub and preceding-sibling::*[1][self::mathml:mrow]]"></xsl:when>
			if next char in digit,  don't add space
			<xsl:when test="translate(substring(following-sibling::*[1]/text(),1,1),'0123456789','') = ''"></xsl:when>
			<xsl:otherwise>
				<mathml:mspace width="0.5ex"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/>
	<xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/>

	<!-- patch: slash in the mtd wrong rendering -->
	<xsl:template match="mathml:mtd/mathml:mo/text()[. = '/']" mode="mathml">
		<xsl:value-of select="."/><xsl:value-of select="$zero_width_space"/>
	</xsl:template>

	<!-- special case for:
		<math xmlns="http://www.w3.org/1998/Math/MathML">
			<mstyle displaystyle="true">
				<msup>
					<mi color="#00000000">C</mi>
					<mtext>R</mtext>
				</msup>
				<msubsup>
					<mtext>C</mtext>
					<mi>n</mi>
					<mi>k</mi>
				</msubsup>
			</mstyle>
		</math>
	-->
	<xsl:template match="mathml:msup/mathml:mi[. = '‌' or . = ''][not(preceding-sibling::*)][following-sibling::mathml:mtext]" mode="mathml">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="next_mtext" select="ancestor::mathml:msup/following-sibling::*[1][self::mathml:msubsup or self::mathml:msub or self::mathml:msup]/mathml:mtext"/>
			<xsl:if test="string-length($next_mtext) != ''">
				<xsl:attribute name="color">#00000000</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:value-of select="$next_mtext"/>
		</xsl:copy>
	</xsl:template>

	<!-- special case for:
				<msup>
					<mtext/>
					<mn>1</mn>
				</msup>
		convert to (add mspace after mtext and enclose them into mrow):
			<msup>
				<mrow>
					<mtext/>
					<mspace height="1.47ex"/>
				</mrow>
				<mn>1</mn>
			</msup>
	-->
	<xsl:template match="mathml:msup/mathml:mtext[not(preceding-sibling::*)]" mode="mathml">
		<mathml:mrow>
			<xsl:copy-of select="."/>
			<mathml:mspace height="1.47ex"/>
		</mathml:mrow>
	</xsl:template>

	<!-- add space around vertical line -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '|']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@lspace)">
				<xsl:attribute name="lspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(@rspace) and not(following-sibling::*[1][self::mathml:mo and normalize-space(text()) = '|'])">
				<xsl:attribute name="rspace">0.2em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- decrease fontsize for 'Circled Times' char -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '⊗']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="not(@fontsize)">
				<xsl:attribute name="fontsize">55%</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<!-- increase space before '(' -->
	<xsl:template match="mathml:mo[normalize-space(text()) = '(']" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="mathml"/>
			<xsl:if test="(preceding-sibling::* and not(preceding-sibling::*[1][self::mathml:mo])) or (../preceding-sibling::* and not(../preceding-sibling::*[1][self::mathml:mo]))">
				<xsl:if test="not(@lspace)">
					<xsl:attribute name="lspace">0.4em</xsl:attribute>
					<xsl:choose>
						<xsl:when test="preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
						<xsl:when test="../preceding-sibling::*[1][self::mathml:mi or self::mathml:mstyle]">
							<xsl:attribute name="lspace">0.2em</xsl:attribute>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates mode="mathml"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="@*|node()" mode="mathml_linebreak">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml_linebreak"/>
		</xsl:copy>
	</xsl:template>

	<!-- split math into two math -->
	<xsl:template match="mathml:mo[@linebreak] | mathml:mspace[@linebreak]" mode="mathml_linebreak">
		<xsl:variable name="math_elements_tree_">
			<xsl:for-each select="ancestor::*[ancestor-or-self::mathml:math]">
				<element pos="{position()}">
					<xsl:copy-of select="@*[local-name() != 'id']"/>
					<xsl:value-of select="name()"/>
				</element>
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="math_elements_tree" select="xalan:nodeset($math_elements_tree_)"/>

		<xsl:call-template name="insertClosingElements">
			<xsl:with-param name="tree" select="$math_elements_tree"/>
		</xsl:call-template>

		<xsl:element name="br" namespace="{$namespace_full}"/>

		<xsl:call-template name="insertOpeningElements">
			<xsl:with-param name="tree" select="$math_elements_tree"/>
			<xsl:with-param name="xmlns">http://www.w3.org/1998/Math/MathML</xsl:with-param>
			<xsl:with-param name="add_continue">false</xsl:with-param>
		</xsl:call-template>

	</xsl:template>

	<!-- Examples: 
		<stem type="AsciiMath">x = 1</stem> 
		<stem type="AsciiMath"><asciimath>x = 1</asciimath></stem>
		<stem type="AsciiMath"><asciimath>x = 1</asciimath><latexmath>x = 1</latexmath></stem>
	-->
	<xsl:template match="mn:fmt-stem[@type = 'AsciiMath'][count(*) = 0]/text() | mn:fmt-stem[@type = 'AsciiMath'][mn:asciimath]" priority="3">
		<fo:inline xsl:use-attribute-sets="mathml-style">

			<xsl:call-template name="refine_mathml-style"/>

			<xsl:choose>
				<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates>
						<xsl:with-param name="process">true</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>

		</fo:inline>
	</xsl:template>
	<!-- ======================================= -->
	<!-- END: math -->
	<!-- ======================================= -->

	<xsl:attribute-set name="list-style">
		<xsl:attribute name="provisional-distance-between-starts">6.5mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="line-height">115%</xsl:attribute>
	</xsl:attribute-set> <!-- list-style -->

	<xsl:template name="refine_list-style">
	</xsl:template> <!-- refine_list-style -->

	<xsl:attribute-set name="list-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
	</xsl:attribute-set> <!-- list-name-style -->

	<xsl:attribute-set name="list-item-style">
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-style">
	</xsl:template> <!-- refine_list-item-style -->

	<xsl:attribute-set name="list-item-label-style">
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-label-style">
	</xsl:template> <!-- refine_list-item-label-style -->

	<xsl:attribute-set name="list-item-body-style">
		<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_list-item-body-style">
	</xsl:template> <!-- refine_list-item-body-style -->

	<!-- ===================================== -->
	<!-- Lists processing -->
	<!-- ===================================== -->
	<xsl:variable name="ul_labels_">
		<label>—</label> <!-- em dash -->

	</xsl:variable>
	<xsl:variable name="ul_labels" select="xalan:nodeset($ul_labels_)"/>

	<xsl:template name="setULLabel">
		<xsl:variable name="list_level__"><xsl:value-of select="count(ancestor::mn:ul) + count(ancestor::mn:ol)"/>
		</xsl:variable>
		<xsl:variable name="list_level_" select="number($list_level__)"/>
		<xsl:variable name="list_level">
			<xsl:choose>
				<xsl:when test="$list_level_ &lt;= 3"><xsl:value-of select="$list_level_"/></xsl:when>
				<xsl:when test="$ul_labels/label[@level = 3]"><xsl:value-of select="$list_level_ mod 3"/></xsl:when>
				<xsl:when test="$list_level_ mod 2 = 0">2</xsl:when>
				<xsl:otherwise><xsl:value-of select="$list_level_ mod 2"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ul_labels/label[not(@level)]"> <!-- one label for all levels -->
				<xsl:apply-templates select="$ul_labels/label[not(@level)]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0 and $ul_labels/label[@level = 3]">
				<xsl:apply-templates select="$ul_labels/label[@level = 3]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 2 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 2]" mode="ul_labels"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$ul_labels/label[@level = 1]" mode="ul_labels"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="label" mode="ul_labels">
		<xsl:copy-of select="@*[not(local-name() = 'level')]"/>
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template name="getListItemFormat">
		<!-- Example: for BSI <?list-type loweralpha?> -->
		<xsl:variable name="processing_instruction_type" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-type'))"/>
		<xsl:choose>
			<xsl:when test="local-name(..) = 'ul'">
				<xsl:choose>
					<xsl:when test="normalize-space($processing_instruction_type) = 'simple'"/>
					<!-- https://github.com/metanorma/isodoc/issues/675 -->
					<xsl:when test="@label"><xsl:value-of select="@label"/></xsl:when>
					<xsl:otherwise><xsl:call-template name="setULLabel"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- https://github.com/metanorma/isodoc/issues/675 -->
			<xsl:when test="local-name(..) = 'ol' and @label and @full = 'true'"> <!-- @full added in the template li/fmt-name -->
				<xsl:value-of select="@label"/>
			</xsl:when>
			<xsl:when test="local-name(..) = 'ol' and @label"> <!-- for ordered lists 'ol', and if there is @label, for instance label="1.1.2" -->

				<xsl:variable name="type" select="../@type"/>

				<xsl:variable name="label">

					<xsl:variable name="style_prefix_">
						<xsl:if test="$type = 'roman'"> <!-- Example: (i) -->
						</xsl:if>
						<xsl:if test="$type = 'alphabet'">
						</xsl:if>
					</xsl:variable>
					<xsl:variable name="style_prefix" select="normalize-space($style_prefix_)"/>

					<xsl:variable name="style_suffix_">
						<xsl:choose>
							<xsl:when test="$type = 'arabic'">)
							</xsl:when>
							<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">)
							</xsl:when>
							<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">)
							</xsl:when>
							<xsl:when test="$type = 'roman'">)
							</xsl:when>
							<xsl:when test="$type = 'roman_upper'">.</xsl:when> <!-- Example: I. -->
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="style_suffix" select="normalize-space($style_suffix_)"/>

					<xsl:if test="$style_prefix != '' and not(starts-with(@label, $style_prefix))">
						<xsl:value-of select="$style_prefix"/>
					</xsl:if>

					<xsl:value-of select="@label"/>

					<xsl:if test="not(java:endsWith(java:java.lang.String.new(@label),$style_suffix))">
						<xsl:value-of select="$style_suffix"/>
					</xsl:if>
				</xsl:variable>
				<xsl:value-of select="normalize-space($label)"/>

			</xsl:when>
			<xsl:otherwise> <!-- for ordered lists 'ol' -->

				<!-- Example: for BSI <?list-start 2?> -->
				<xsl:variable name="processing_instruction_start" select="normalize-space(../preceding-sibling::*[1]/processing-instruction('list-start'))"/>

				<xsl:variable name="start_value">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_start) != ''">
							<xsl:value-of select="number($processing_instruction_start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:when test="normalize-space(../@start) != ''">
							<xsl:value-of select="number(../@start) - 1"/><!-- if start="3" then start_value=2 + xsl:number(1) = 3 -->
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="curr_value"><xsl:number/></xsl:variable>

				<xsl:variable name="type">
					<xsl:choose>
						<xsl:when test="normalize-space($processing_instruction_type) != ''"><xsl:value-of select="$processing_instruction_type"/></xsl:when>
						<xsl:when test="normalize-space(../@type) != ''"><xsl:value-of select="../@type"/></xsl:when>

						<xsl:otherwise> <!-- if no @type or @class = 'steps' -->

							<xsl:variable name="list_level_" select="count(ancestor::mn:ul) + count(ancestor::mn:ol)"/>
							<xsl:variable name="list_level">
								<xsl:choose>
									<xsl:when test="$list_level_ &lt;= 5"><xsl:value-of select="$list_level_"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$list_level_ mod 5"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="$list_level mod 5 = 0">roman_upper</xsl:when> <!-- level 5 -->
								<xsl:when test="$list_level mod 4 = 0">alphabet_upper</xsl:when> <!-- level 4 -->
								<xsl:when test="$list_level mod 3 = 0">roman</xsl:when> <!-- level 3 -->
								<xsl:when test="$list_level mod 2 = 0 and ancestor::*/@class = 'steps'">alphabet</xsl:when> <!-- level 2 and @class = 'steps'-->
								<xsl:when test="$list_level mod 2 = 0">arabic</xsl:when> <!-- level 2 -->
								<xsl:otherwise> <!-- level 1 -->
									<xsl:choose>
										<xsl:when test="ancestor::*/@class = 'steps'">arabic</xsl:when>
										<xsl:otherwise>alphabet</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="format">
					<xsl:choose>
						<xsl:when test="$type = 'arabic'">1)
						</xsl:when>
						<xsl:when test="$type = 'alphabet' or $type = 'alphabetic'">a)
						</xsl:when>
						<xsl:when test="$type = 'alphabet_upper' or $type = 'alphabetic_upper'">A)
						</xsl:when>
						<xsl:when test="$type = 'roman'">i)
						</xsl:when>
						<xsl:when test="$type = 'roman_upper'">I.</xsl:when>
						<xsl:otherwise>1.</xsl:otherwise> <!-- for any case, if $type has non-determined value, not using -->
					</xsl:choose>
				</xsl:variable>

				<xsl:number value="$start_value + $curr_value" format="{normalize-space($format)}" lang="en"/>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getListItemFormat -->

	<xsl:template match="mn:ul | mn:ol">
		<xsl:param name="indent">0</xsl:param>
		<xsl:choose>
			<xsl:when test="parent::mn:note or parent::mn:termnote">
				<fo:block-container role="SKIP">
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::mn:table)"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<xsl:call-template name="refine_list_container_style"/>

					<fo:block-container margin-left="0mm" role="SKIP">
						<fo:block>
							<xsl:apply-templates select="." mode="list">
								<xsl:with-param name="indent" select="$indent"/>
							</xsl:apply-templates>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block role="SKIP">
					<xsl:apply-templates select="." mode="list">
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_list_container_style">
	</xsl:template> <!-- refine_list_container_style -->

	<xsl:template match="mn:ul | mn:ol" mode="list" name="list">

		<xsl:apply-templates select="mn:fmt-name">
			<xsl:with-param name="process">true</xsl:with-param>
		</xsl:apply-templates>

		<fo:list-block xsl:use-attribute-sets="list-style">

			<xsl:variable name="provisional_distance_between_starts_">
				<attributes xsl:use-attribute-sets="list-style">
					<xsl:call-template name="refine_list-style_provisional-distance-between-starts"/>
				</attributes>
			</xsl:variable>
			<xsl:variable name="provisional_distance_between_starts" select="normalize-space(xalan:nodeset($provisional_distance_between_starts_)/attributes/@provisional-distance-between-starts)"/>
			<xsl:if test="$provisional_distance_between_starts != ''">
				<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts"/></xsl:attribute>
			</xsl:if>
			<xsl:variable name="provisional_distance_between_starts_value" select="substring-before($provisional_distance_between_starts, 'mm')"/>

			<!-- increase provisional-distance-between-starts for long lists -->
			<xsl:if test="self::mn:ol">
				<!-- Examples: xiii), xviii), xxviii) -->
				<xsl:variable name="item_numbers">
					<xsl:for-each select="mn:li">
						<item><xsl:call-template name="getListItemFormat"/></item>
					</xsl:for-each>
				</xsl:variable>

				<xsl:variable name="max_length">
					<xsl:for-each select="xalan:nodeset($item_numbers)/item">
						<xsl:sort select="string-length(.)" data-type="number" order="descending"/>
						<xsl:if test="position() = 1"><xsl:value-of select="string-length(.)"/></xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<!-- base width (provisional-distance-between-starts) for 4 chars -->
				<xsl:variable name="addon" select="$max_length - 4"/>
				<xsl:if test="$addon &gt; 0">
					<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$provisional_distance_between_starts_value + $addon * 2"/>mm</xsl:attribute>
				</xsl:if>
				<!-- DEBUG -->
				<!-- <xsl:copy-of select="$item_numbers"/>
				<max_length><xsl:value-of select="$max_length"/></max_length>
				<addon><xsl:value-of select="$addon"/></addon> -->
			</xsl:if>

			<xsl:call-template name="refine_list-style"/>

			<xsl:if test="mn:fmt-name">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="node()[not(self::mn:note)]"/>
		</fo:list-block>
		<!-- <xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each> -->
		<xsl:apply-templates select="./mn:note"/>
	</xsl:template>

	<xsl:template name="refine_list-style_provisional-distance-between-starts">
	</xsl:template> <!-- refine_list-style_provisional-distance-between-starts -->

	<xsl:template match="*[self::mn:ol or self::mn:ul]/mn:fmt-name">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="list-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:li">
		<xsl:param name="indent">0</xsl:param>
		<!-- <fo:list-item xsl:use-attribute-sets="list-item-style">
			<fo:list-item-label end-indent="label-end()"><fo:block>x</fo:block></fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>debug li indent=<xsl:value-of select="$indent"/></fo:block>
			</fo:list-item-body>
		</fo:list-item> -->
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>

			<xsl:call-template name="refine_list-item-style"/>

			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style" role="SKIP">

					<xsl:call-template name="refine_list-item-label-style"/>

					<xsl:if test="local-name(..) = 'ul'">
						<xsl:variable name="li_label" select="@label"/>
						<xsl:copy-of select="$ul_labels//label[. = $li_label]/@*[not(local-name() = 'level')]"/>
					</xsl:if>

					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and mn:add]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>

					<xsl:call-template name="getListItemFormat"/>

				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block role="SKIP">

					<xsl:call-template name="refine_list-item-body-style"/>

					<xsl:apply-templates>
						<xsl:with-param name="indent" select="$indent"/>
					</xsl:apply-templates>

					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./mn:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<!-- ===================================== -->
	<!-- END Lists processing -->
	<!-- ===================================== -->

	<xsl:attribute-set name="fn-reference-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
		<xsl:attribute name="color">blue</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>

	</xsl:attribute-set>

	<xsl:template name="refine_fn-reference-style">
	</xsl:template> <!-- refine_fn-reference-style -->

	<xsl:attribute-set name="fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="fn-num-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">65%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="fn-body-style">
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="font-style">normal</xsl:attribute>
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="text-align">justify</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="refine_fn-body-style">
	</xsl:template> <!-- refine_fn-body-style -->

	<xsl:attribute-set name="fn-body-num-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">60%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- fn-body-num-style -->

	<xsl:template name="refine_fn-body-num-style">
	</xsl:template> <!-- refine_fn-body-num-style -->

	<!-- ===================== -->
	<!-- Footnotes processing  -->
	<!-- ===================== -->

	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="footnotes_">
		<xsl:for-each select="//mn:fmt-footnote-container/mn:fmt-fn-body"> <!-- commented mn:metanorma/, because there are fn in figure or table name -->
			<!-- <xsl:copy-of select="."/> -->
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="footnotes" select="xalan:nodeset($footnotes_)"/>

	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<!-- footnotes in text (title, bibliography, main body), not for tables, figures and names --> <!-- table's, figure's names -->
	<!-- fn in text -->
	<xsl:template match="mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))]" priority="2" name="fn">
		<xsl:param name="footnote_body_from_table">false</xsl:param>

		<!-- list of unique footnotes -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>

		<xsl:variable name="gen_id" select="generate-id(.)"/>

		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number" select="@reference"/>

		<xsl:variable name="current_fn_number_text">
			<xsl:value-of select="$current_fn_number"/>
		</xsl:variable>

		<xsl:variable name="ref_id" select="@target"/>

		<xsl:variable name="footnote_inline">
			<fo:inline role="Reference">

				<xsl:variable name="fn_styles">
					<xsl:choose>
						<xsl:when test="ancestor::mn:bibitem">
							<fn_styles xsl:use-attribute-sets="bibitem-note-fn-style">
							</fn_styles>
						</xsl:when>
						<xsl:otherwise>
							<fn_styles xsl:use-attribute-sets="fn-num-style">
							</fn_styles>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($fn_styles)/fn_styles/@*">
					<xsl:copy-of select="."/>
				</xsl:for-each>

				<xsl:if test="following-sibling::node()[normalize-space() != ''][1][self::mn:fn]">
					<xsl:attribute name="padding-right">0.5mm</xsl:attribute>
				</xsl:if>

				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$ref_id}" fox:alt-text="footnote {$current_fn_number}"> <!-- note: role="Lbl" removed in https://github.com/metanorma/mn2pdf/issues/291 -->
							<fo:inline role="Lbl"> <!-- need for https://github.com/metanorma/metanorma-iso/issues/1003 -->
								<xsl:copy-of select="$current_fn_number_text"/>

							</fo:inline>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:inline>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space(@skip_footnote_body) = 'true'">
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:when>
			<!-- <xsl:when test="$footnotes//mn:fmt-fn-body[@id = $ref_id] or normalize-space(@skip_footnote_body) = 'false'"> -->
			<xsl:when test="$p_fn//fn[@gen_id = $gen_id] or normalize-space(@skip_footnote_body) = 'false' or $footnote_body_from_table = 'true'">

				<fo:footnote xsl:use-attribute-sets="fn-style" role="SKIP">
					<xsl:copy-of select="$footnote_inline"/>
					<fo:footnote-body role="Note">

						<fo:block-container xsl:use-attribute-sets="fn-container-body-style" role="SKIP">

							<xsl:variable name="fn_block">
								<xsl:call-template name="refine_fn-body-style"/>

								<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style" role="Lbl">

									<xsl:call-template name="refine_fn-body-num-style"/>

									<xsl:value-of select="$current_fn_number_text"/>

								</fo:inline>
								<!-- <xsl:apply-templates /> -->
								<!-- <ref_id><xsl:value-of select="$ref_id"/></ref_id>
								<here><xsl:copy-of select="$footnotes"/></here> -->
								<xsl:apply-templates select="$footnotes/mn:fmt-fn-body[@id = $ref_id]"/>
							</xsl:variable>
							<fo:block xsl:use-attribute-sets="fn-body-style" role="SKIP">
								<xsl:copy-of select="$fn_block"/>
							</fo:block>

						</fo:block-container>
					</fo:footnote-body>
				</fo:footnote>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- fn in text -->

	<xsl:template name="get_fn_list">
		<xsl:choose>
			<xsl:when test="@current_fn_number"> <!-- for BSI, footnote reference number calculated already -->
				<fn gen_id="{generate-id(.)}">
					<xsl:copy-of select="@*"/>
					<xsl:copy-of select="node()"/>
				</fn>
			</xsl:when>
			<xsl:otherwise>
				<!-- itetation for:
				footnotes in bibdata/title
				footnotes in bibliography
				footnotes in document's body (except table's head/body/foot and figure text) 
				-->
				<xsl:for-each select="ancestor::mn:metanorma/mn:bibdata/mn:note[@type='title-footnote']">
					<fn gen_id="{generate-id(.)}">
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="node()"/>
					</fn>
				</xsl:for-each>
				<xsl:for-each select="ancestor::mn:metanorma/mn:boilerplate/* |       ancestor::mn:metanorma//mn:preface/* |      ancestor::mn:metanorma//mn:sections/* |       ancestor::mn:metanorma//mn:annex |      ancestor::mn:metanorma//mn:bibliography/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<!-- commented:
					 .//mn:bibitem[ancestor::mn:references]/mn:note |
					 because 'fn' there is in biblio-tag -->
					<xsl:for-each select=".//mn:fn[not(ancestor::*[(self::mn:table or self::mn:figure)] and not(ancestor::mn:fmt-name))][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
						<!-- copy unique fn -->
						<fn gen_id="{generate-id(.)}">
							<xsl:copy-of select="@*"/>
							<xsl:copy-of select="node()"/>
						</fn>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- fn/text() -->
	<xsl:template match="mn:fn/text()[normalize-space() != '']">
		<fo:inline role="SKIP"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<!-- fn//p fmt-fn-body//p -->
	<xsl:template match="mn:fn//mn:p | mn:fmt-fn-body//mn:p">
		<fo:inline role="P">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="insertFootnoteSeparatorCommon">
		<xsl:param name="leader_length">30%</xsl:param>
		<fo:static-content flow-name="xsl-footnote-separator">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="{$leader_length}"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<!-- ===================== -->
	<!-- END Footnotes processing  -->
	<!-- ===================== -->

	<!-- admonition -->
	<xsl:attribute-set name="admonition-style">
		<xsl:attribute name="border">0.5pt solid rgb(79, 129, 189)</xsl:attribute>
		<xsl:attribute name="color">rgb(79, 129, 189)</xsl:attribute>
		<xsl:attribute name="margin-left">16mm</xsl:attribute>
		<xsl:attribute name="margin-right">16mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-style -->

	<xsl:attribute-set name="admonition-container-style">
		<xsl:attribute name="margin-left">0mm</xsl:attribute>
		<xsl:attribute name="margin-right">0mm</xsl:attribute>
		<xsl:attribute name="padding">2mm</xsl:attribute>
		<xsl:attribute name="padding-top">3mm</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-container-style -->

	<xsl:attribute-set name="admonition-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-name-style -->

	<xsl:attribute-set name="admonition-p-style">
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set> <!-- admonition-p-style -->
	<!-- end admonition -->

	<!-- ================ -->
	<!-- Admonition -->
	<!-- ================ -->
	<xsl:template match="mn:admonition"> <!-- text in the box -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style">

			<xsl:call-template name="setBlockSpanAll"/>
				<xsl:variable name="admonition_color" select="normalize-space(/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = concat('color-admonition-', @type)]/mn:value)"/>
				<xsl:if test="$admonition_color != ''">
					<xsl:attribute name="border">0.5pt solid <xsl:value-of select="$admonition_color"/></xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$admonition_color"/></xsl:attribute>
				</xsl:if>
					<fo:block-container xsl:use-attribute-sets="admonition-container-style" role="SKIP">
								<fo:block xsl:use-attribute-sets="admonition-name-style">
									<xsl:call-template name="displayAdmonitionName"/>
								</fo:block>
								<fo:block xsl:use-attribute-sets="admonition-p-style">
									<xsl:apply-templates select="node()[not(self::mn:fmt-name)]"/>
								</fo:block>

					</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="displayAdmonitionName">
		<xsl:param name="sep"/> <!-- Example: ' - ' -->
		<!-- <xsl:choose>
			<xsl:when test="$namespace = 'nist-cswp' or $namespace = 'nist-sp'">
				<xsl:choose>
					<xsl:when test="@type='important'"><xsl:apply-templates select="@type"/></xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="mn:name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="mn:name"/>
				<xsl:if test="not(mn:name)">
					<xsl:apply-templates select="@type"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:variable name="name">
			<xsl:apply-templates select="mn:fmt-name"/>
		</xsl:variable>
		<xsl:copy-of select="$name"/>
		<xsl:if test="normalize-space($name) != ''">
			<xsl:value-of select="$sep"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:admonition/mn:fmt-name">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- <xsl:template match="mn:admonition/@type">
		<xsl:variable name="admonition_type_">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">admonition.<xsl:value-of select="."/></xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="admonition_type" select="normalize-space(java:toUpperCase(java:java.lang.String.new($admonition_type_)))"/>
		<xsl:value-of select="$admonition_type"/>
		<xsl:if test="$admonition_type = ''">
			<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(.))"/>
		</xsl:if>
	</xsl:template> -->

	<xsl:template match="mn:admonition/mn:p">
		<fo:block xsl:use-attribute-sets="admonition-p-style">

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ================ -->
	<!-- END Admonition -->
	<!-- ================ -->

	<!-- bibitem in Normative References (references/@normative="true") -->
	<xsl:attribute-set name="bibitem-normative-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="start-indent">12mm</xsl:attribute>
		<xsl:attribute name="text-indent">-12mm</xsl:attribute>
		<xsl:attribute name="line-height">115%</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-normative-style -->

	<!-- bibitem in Normative References (references/@normative="true"), renders as list -->
	<xsl:attribute-set name="bibitem-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-normative-list-style -->

	<xsl:attribute-set name="bibitem-non-normative-style">
	</xsl:attribute-set> <!-- bibitem-non-normative-style -->

	<!-- bibitem in bibliography section (references/@normative="false"), renders as list -->
	<xsl:attribute-set name="bibitem-non-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-non-normative-list-style -->

	<xsl:attribute-set name="bibitem-non-normative-list-item-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
	</xsl:attribute-set>

	<!-- bibitem in bibliography section (references/@normative="false"), list body -->
	<xsl:attribute-set name="bibitem-normative-list-body-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="bibitem-non-normative-list-body-style">
	</xsl:attribute-set> <!-- bibitem-non-normative-list-body-style -->

	<!-- footnote reference number for bibitem, in the text  -->
	<xsl:attribute-set name="bibitem-note-fn-style">
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">65%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-style -->

	<!-- footnote number on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-number-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
		<xsl:attribute name="font-size">60%</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-number-style -->

	<!-- footnote body (text) on the page bottom -->
	<xsl:attribute-set name="bibitem-note-fn-body-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="start-indent">0pt</xsl:attribute>
	</xsl:attribute-set> <!-- bibitem-note-fn-body-style -->

	<xsl:attribute-set name="references-non-normative-style">
		<xsl:attribute name="line-height">120%</xsl:attribute>
	</xsl:attribute-set> <!-- references-non-normative-style -->

		<!-- ======================= -->
	<!-- Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	<xsl:template match="mn:references[@hidden='true']" priority="3"/>
	<xsl:template match="mn:bibitem[@hidden='true']" priority="3">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/>
	</xsl:template>
	<!-- don't display bibitem with @id starts with '_hidden', that was introduced for references integrity -->
	<xsl:template match="mn:bibitem[starts-with(@id, 'hidden_bibitem_')]" priority="3"/>

	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']" priority="2">

		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references">
		<xsl:if test="not(ancestor::mn:annex)">
			<fo:block break-after="page"/>
		</xsl:if>

		<!-- <xsl:if test="ancestor::mn:annex">
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'itu'">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if> -->

		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}"/>

		<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>

		<fo:block xsl:use-attribute-sets="references-non-normative-style">
			<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]"/>
		</fo:block>
	</xsl:template> <!-- references -->

	<xsl:template match="mn:bibitem">
		<xsl:call-template name="bibitem"/>
	</xsl:template>

	<!-- Normative references -->
	<xsl:template match="mn:references[@normative='true']/mn:bibitem" name="bibitem" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
			<xsl:call-template name="processBibitem"/>
		</fo:block>

	</xsl:template> <!-- bibitem -->

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="mn:references[not(@normative='true')]/mn:bibitem | mn:references[not(@normative='true')]/mn:note" name="bibitem_non_normative" priority="2">
		<xsl:param name="skip" select="normalize-space(preceding-sibling::*[not(self::mn:note)][1][self::mn:bibitem] and 1 = 1)"/> <!-- current bibiitem is non-first --> <!-- $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'm3d' or 
			$namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' -->
		<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block role="SKIP">
						<fo:inline role="SKIP">
							<xsl:apply-templates select="mn:biblio-tag">
								<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
							</xsl:apply-templates>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style" role="SKIP">
						<xsl:call-template name="processBibitem">
							<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
						</xsl:call-template>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>

	</xsl:template> <!-- references[not(@normative='true')]/bibitem -->

	<xsl:template name="insertListItem_Bibitem">
		<xsl:choose>
			<xsl:when test="@hidden = 'true'"><!-- skip --></xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="setNamedDestination"/>
				<fo:list-item id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-item-style">
					<fo:list-item-label end-indent="label-end()">
						<fo:block role="SKIP">
							<fo:inline role="SKIP">
								<xsl:apply-templates select="mn:biblio-tag">
									<xsl:with-param name="biblio_tag_part">first</xsl:with-param>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style" role="SKIP">
							<xsl:call-template name="processBibitem">
								<xsl:with-param name="biblio_tag_part">last</xsl:with-param>
							</xsl:call-template>
							<xsl:if test="self::mn:note">
								<xsl:variable name="note_node">
									<xsl:copy> <!-- skip @id -->
										<xsl:copy-of select="node()"/>
									</xsl:copy>
								</xsl:variable>
								<xsl:for-each select="xalan:nodeset($note_node)/*">
									<xsl:call-template name="note"/>
								</xsl:for-each>
							</xsl:if>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="following-sibling::*[1]"> <!-- [self::mn:bibitem] -->
			<xsl:with-param name="skip">false</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template name="processBibitem">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<!-- start bibitem processing -->
		<xsl:if test=".//mn:fn">
			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
		</xsl:if>

		<xsl:apply-templates select="mn:biblio-tag">
			<xsl:with-param name="biblio_tag_part" select="$biblio_tag_part"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="mn:formattedref"/>
		<!-- end bibitem processing -->
	</xsl:template> <!-- processBibitem (bibitem) -->

	<xsl:template match="mn:title" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:bibitem/mn:docidentifier"/>

	<xsl:template match="mn:formattedref">
		<!-- <xsl:if test="$namespace = 'unece' or $namespace = 'unece-rec'">
			<xsl:text>, </xsl:text>
		</xsl:if> -->
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:biblio-tag">
		<xsl:param name="biblio_tag_part">both</xsl:param>
		<xsl:choose>
			<xsl:when test="$biblio_tag_part = 'first' and mn:tab">
				<xsl:apply-templates select="./mn:tab[1]/preceding-sibling::node()"/>
			</xsl:when>
			<xsl:when test="$biblio_tag_part = 'last'">
				<xsl:apply-templates select="./mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:biblio-tag/mn:tab" priority="2">
		<xsl:text> </xsl:text>
	</xsl:template>

	<!-- ======================= -->
	<!-- END Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- END Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->

	<!-- Highlight.js syntax GitHub styles -->
	<xsl:attribute-set name="hljs-doctag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-keyword">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-tag">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-template-variable">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-type">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable_and_language_">
		<xsl:attribute name="color">#d73a49</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-title">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_class__and_inherited__">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-title_and_function_">
		<xsl:attribute name="color">#6f42c1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-attribute">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-literal">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-number">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-operator">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-variable">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-attr">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-class">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-id">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-regexp">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-meta_hljs-string">
		<xsl:attribute name="color">#032f62</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-built_in">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-symbol">
		<xsl:attribute name="color">#e36209</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-comment">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-code">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-formula">
		<xsl:attribute name="color">#6a737d</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-name">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-quote">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-tag">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-selector-pseudo">
		<xsl:attribute name="color">#22863a</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-subst">
		<xsl:attribute name="color">#24292e</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-section">
		<xsl:attribute name="color">#005cc5</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-bullet">
		<xsl:attribute name="color">#735c0f</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-emphasis">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-style">italic</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-strong">
		<xsl:attribute name="color">#24292e</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-addition">
		<xsl:attribute name="color">#22863a</xsl:attribute>
		<xsl:attribute name="background-color">#f0fff4</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-deletion">
		<xsl:attribute name="color">#b31d28</xsl:attribute>
		<xsl:attribute name="background-color">#ffeef0</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="hljs-char_and_escape_">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-link">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-params">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-property">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-punctuation">
	</xsl:attribute-set>
	<xsl:attribute-set name="hljs-tag">
	</xsl:attribute-set>
	<!-- End Highlight syntax styles -->

	<!-- Index section styles -->
	<xsl:attribute-set name="indexsect-title-style">
		<xsl:attribute name="role">H1</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="indexsect-clause-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
	</xsl:attribute-set>
	<!-- End Index section styles -->

	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>

	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//mn:bookmark[ancestor::mn:fn]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="@*|node()" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:xref" mode="index_add_id"/>
	<xsl:template match="mn:fmt-xref" mode="index_add_id">
		<xsl:param name="docid"/>
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id">
				<xsl:with-param name="docid" select="$docid"/>
			</xsl:apply-templates>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$en_dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id">
					<xsl:with-param name="docid" select="$docid"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[not(self::mn:fmt-name)][1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $en_dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'fmt-xref'">
				<xsl:variable name="id" select="@id"/>

				<xsl:variable name="id_next" select="following-sibling::mn:fmt-xref[1]/@id"/>
				<xsl:variable name="id_prev" select="preceding-sibling::mn:fmt-xref[1]/@id"/>

				<xsl:variable name="pages_">
					<xsl:for-each select="$index/index/item[@id = $id or @id = $id_next or @id = $id_prev]">
						<xsl:choose>
							<xsl:when test="@id = $id">
								<page><xsl:value-of select="."/></page>
							</xsl:when>
							<xsl:when test="@id = $id_next">
								<page_next><xsl:value-of select="."/></page_next>
							</xsl:when>
							<xsl:when test="@id = $id_prev">
								<page_prev><xsl:value-of select="."/></page_prev>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="pages" select="xalan:nodeset($pages_)"/>

				<!-- <xsl:variable name="page" select="$index/index/item[@id = $id]"/> -->
				<xsl:variable name="page" select="$pages/page"/>
				<!-- <xsl:variable name="page_next" select="$index/index/item[@id = $id_next]"/> -->
				<xsl:variable name="page_next" select="$pages/page_next"/>
				<!-- <xsl:variable name="page_prev" select="$index/index/item[@id = $id_prev]"/> -->
				<xsl:variable name="page_prev" select="$pages/page_prev"/>

				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->

						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="generateIndexXrefId">
		<xsl:param name="docid"/>

		<xsl:variable name="level" select="count(ancestor::mn:ul)"/>

		<xsl:variable name="docid_curr">
			<xsl:value-of select="$docid"/>
			<xsl:if test="normalize-space($docid) = ''"><xsl:call-template name="getDocumentId"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="item_number">
			<xsl:number count="mn:li[ancestor::mn:indexsect]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="mn:fmt-xref"/></xsl:variable>
		<xsl:value-of select="concat($docid_curr, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:fmt-title | mn:indexsect/mn:title" priority="4">
		<fo:block xsl:use-attribute-sets="indexsect-title-style">
			<!-- Index -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause/mn:fmt-title | mn:indexsect/mn:clause/mn:title" priority="4">
		<!-- Letter A, B, C, ... -->
		<fo:block xsl:use-attribute-sets="indexsect-clause-title-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect/mn:clause" priority="4">
		<xsl:apply-templates/>
		<fo:block>
			<xsl:if test="following-sibling::mn:clause">
				<fo:block> </fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:ul" priority="4">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li" priority="4">
		<xsl:variable name="level" select="count(ancestor::mn:ul)"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:indexsect//mn:li/text()">
		<!-- to split by '_' and other chars -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>

	<xsl:template match="mn:table/mn:bookmark" priority="2"/>

	<xsl:template match="mn:bookmark" name="bookmark">
		<xsl:variable name="bookmark_id" select="@id"/>
		<xsl:choose>
			<!-- Example:
				<fmt-review-start id="_7ef81cf7-3f6c-4ed4-9c1f-1ba092052bbd" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" end="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/>
				<bookmark id="_dda23915-8574-ef1e-29a1-822d465a5b97"/>
				<fmt-review-end id="_f336a8d0-08a8-4b7f-a1aa-b04688ed40c1" source="_dda23915-8574-ef1e-29a1-822d465a5b97" target="_ecfb2210-3b1b-46a2-b63a-8b8505be6686" start="_dda23915-8574-ef1e-29a1-822d465a5b97" author="" date="2025-03-24T00:00:00Z"/> -->
			<xsl:when test="1 = 2 and preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and        following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]">
				<!-- skip here, see the template 'fmt-review-start' -->
			</xsl:when>
			<xsl:otherwise>
				<!-- <fo:inline id="{@id}" font-size="1pt"/> -->
				<fo:inline id="{@id}" font-size="1pt"><xsl:if test="preceding-sibling::node()[self::mn:fmt-annotation-start][@source = $bookmark_id] and        following-sibling::node()[self::mn:fmt-annotation-end][@source = $bookmark_id]"><xsl:attribute name="line-height">0.1</xsl:attribute></xsl:if><xsl:value-of select="$hair_space"/></fo:inline>
				<!-- we need to add zero-width space, otherwise this fo:inline is missing in IF xml -->
				<xsl:if test="not(following-sibling::node()[normalize-space() != ''])"><fo:inline font-size="1pt"> </fo:inline></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->

		<!-- =================== -->
	<!-- Form's elements processing -->
	<!-- =================== -->
	<xsl:template match="mn:form">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:form//mn:label">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'checkbox']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:input[@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:select">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="mn:form//mn:textarea">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template>

	<!-- =================== -->
	<!-- End Form's elements processing -->
	<!-- =================== -->

	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition or @type = 'toc')]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_preface/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault_Contents">

		<xsl:variable name="nodes_sections_">
			<xsl:for-each select="/*/mn:sections/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true'] |    /*/mn:bibliography/mn:clause[mn:references[@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>

		<!-- <xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each> -->

		<xsl:for-each select="/*/mn:annex | /*/mn:bibliography/*[not(@normative='true') and not(mn:references[@normative='true'])][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0] |          /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]][count(.//mn:bibitem[not(@hidden) = 'true']) &gt; 0]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='table']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//mn:metanorma/mn:metanorma-extension/mn:toc[@type='figure']/mn:title) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<mnx:tables>
			<xsl:for-each select="//mn:table[not(ancestor::mn:metanorma-extension)][@id and mn:fmt-name and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:table id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:table>
					</xsl:when>
					<xsl:otherwise>
						<mnx:table id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:table>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:tables>
	</xsl:template>

	<xsl:template name="processFigures_Contents">
		<mnx:figures>
			<xsl:for-each select="//mn:figure[@id and mn:fmt-name and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(mn:name, 'Figure ') and normalize-space(@id) != '']">
				<xsl:choose>
					<xsl:when test="mn:fmt-name">
						<xsl:variable name="fmt_name">
							<xsl:apply-templates select="mn:fmt-name" mode="update_xml_step1"/>
						</xsl:variable>
						<mnx:figure id="{@id}" alt-text="{normalize-space($fmt_name)}">
							<xsl:copy-of select="$fmt_name"/>
						</mnx:figure>
					</xsl:when>
					<xsl:otherwise>
						<mnx:figure id="{@id}" alt-text="{mn:name}">
							<xsl:copy-of select="mn:name"/>
						</mnx:figure>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</mnx:figures>
	</xsl:template>

	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name |                mn:table/mn:name | mnx:table/mn:name |               mn:permission/mn:name | mnx:permission/mn:name |               mn:recommendation/mn:name | mnx:recommendation/mn:name |               mn:requirement/mn:name | mnx:requirement/mn:name" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:title[following-sibling::*[1][self::mn:fmt-title]]" mode="contents"/>

	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name |               mn:table/mn:fmt-name | mnx:table/mn:fmt-name |               mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name |               mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name |               mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name" mode="contents">
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:figure/mn:name | mnx:figure/mn:name |                mn:table/mn:name | mnx:table/mn:name |               mn:permission/mn:name | mnx:permission/mn:name |               mn:recommendation/mn:name | mnx:recommendation/mn:name |               mn:requirement/mn:name | mnx:requirement/mn:name |               mn:sourcecode/mn:name" mode="bookmarks">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="bookmarks"/>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:figure/mn:fmt-name | mnx:figure/mn:fmt-name |                mn:table/mn:fmt-name | mnx:table/mn:fmt-name |                mn:permission/mn:fmt-name | mnx:permission/mn:fmt-name |                mn:recommendation/mn:fmt-name | mnx:recommendation/mn:fmt-name |                mn:requirement/mn:fmt-name | mnx:requirement/mn:fmt-name |                mn:sourcecode/mn:fmt-name | mnx:sourcecode/mn:fmt-name" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:name/text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:name/text()" mode="contents" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement]/mn:fmt-name/text() |   *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement]/mn:fmt-name/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:name//text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:name//text()" mode="bookmarks" priority="2">
		<xsl:if test="not(../following-sibling::*[1][self::mn:fmt-name])">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[self::mn:figure or self::mn:table or self::mn:permission or self::mn:recommendation or self::mn:requirement or self::mn:sourcecode]/mn:fmt-name//text() |    *[self::mnx:figure or self::mnx:table or self::mnx:permission or self::mnx:recommendation or self::mnx:requirement or self::mnx:sourcecode]/mn:fmt-name//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:add/text()" mode="bookmarks" priority="3"> <!-- mn:add[starts-with(., $ace_tag)] -->
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space(..), $ace_tag)"><!-- skip --></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[self::mn:preface or self::mn:sections]/mn:p[@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="mn:p[@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="mn:p[@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>

	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="mn:clause/mn:p[@type = 'section-title' and (@depth != ../*[self::mn:title or self::mn:fmt-title]/@depth or ../*[self::mn:title or self::mn:fmt-title]/@depth = 1)]" priority="3" mode="contents"/>

	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"/>
				<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
					<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>

		<xsl:variable name="display">
			<xsl:choose>
				<xsl:when test="normalize-space(@id) = ''">false</xsl:when>
				<xsl:when test="$level &lt;= $toc_level">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="skip">false</xsl:variable>

		<xsl:if test="$skip = 'false'">

			<xsl:variable name="title">
				<xsl:choose>
					<!-- https://github.com/metanorma/mn-native-pdf/issues/770 -->
					<xsl:when test="mn:span[@class = 'fmt-caption-delim']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:span[@class = 'fmt-caption-delim'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:span[@class = 'fmt-caption-delim'][1]/following-sibling::node()[not(self::mn:fmt-xref-label)]"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="mn:tab">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="mn:tab[1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::mn:preface">preface</xsl:if>
				<xsl:if test="ancestor-or-self::mn:annex">annex</xsl:if>
			</xsl:variable>

			<mnx:item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<mnx:title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</mnx:title>
			</mnx:item>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:stem" mode="contents"/>

	<xsl:template match="*[self::mn:title or self::mn:name or self::mn:fmt-title or self::mn:fmt-name]//mn:fmt-stem" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<!-- prevent missing stem for table and figures in ToC -->
	<xsl:template match="*[self::mn:name or self::mn:fmt-name]//mn:stem" mode="contents">
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-stem])">
			<xsl:apply-templates select="."/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:references[@hidden='true']" mode="contents" priority="3"/>

	<xsl:template match="mn:references/mn:bibitem" mode="contents"/>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="mn:concept" mode="contents"/>
	<xsl:template match="mn:eref" mode="contents"/>
	<xsl:template match="mn:xref" mode="contents"/>
	<xsl:template match="mn:link" mode="contents"/>
	<xsl:template match="mn:origin" mode="contents"/>
	<xsl:template match="mn:erefstack" mode="contents"/>

	<xsl:template match="mn:requirement |             mn:recommendation |              mn:permission" mode="contents" priority="3"/>

	<xsl:template match="mn:stem" mode="bookmarks"/>
	<xsl:template match="mn:fmt-stem" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="mn:concept" mode="bookmarks"/>
	<xsl:template match="mn:eref" mode="bookmarks"/>
	<xsl:template match="mn:xref" mode="bookmarks"/>
	<xsl:template match="mn:link" mode="bookmarks"/>
	<xsl:template match="mn:origin" mode="bookmarks"/>
	<xsl:template match="mn:erefstack" mode="bookmarks"/>

	<xsl:template match="mn:requirement |             mn:recommendation |              mn:permission" mode="bookmarks" priority="3"/>

	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="contents_addon"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//mnx:item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/mnx:doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/mnx:doc) &gt; 1">

								<xsl:if test="$contents_nodes/collection">
									<fo:bookmark internal-destination="{$contents/collection/@firstpage_id}">
										<fo:bookmark-title>collection.pdf</fo:bookmark-title>
									</fo:bookmark>
								</xsl:if>

								<xsl:for-each select="$contents_nodes/mnx:doc">
									<fo:bookmark internal-destination="{contents/mnx:item[@display = 'true'][1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>

										<xsl:apply-templates select="contents/mnx:item" mode="bookmark"/>

										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
										</xsl:call-template>

										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="mnx:contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>

									</fo:bookmark>

								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$contents_nodes/mnx:doc">

									<xsl:apply-templates select="mnx:contents/mnx:item" mode="bookmark"/>

									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
									</xsl:call-template>

									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="mnx:contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>

								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$contents_nodes/mnx:contents/mnx:item" mode="bookmark"/>

						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
						</xsl:call-template>

						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/mnx:contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>

				<!-- for $namespace = 'nist-sp' $namespace = 'ogc' $namespace = 'ogc-white-paper' -->
				<xsl:copy-of select="$contents_addon"/>

			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:figure">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if><!-- see template addBookmarks -->
	</xsl:template> <!-- insertFigureBookmarks -->

	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/mnx:table">
			<fo:bookmark internal-destination="{$contents_nodes/mnx:table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/mnx:table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(mnx:title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if><!-- see template addBookmarks -->
	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->

	<!-- ============================ -->
	<!-- mode="bookmark_clean" -->
	<!-- ============================ -->
	<xsl:template match="node()" mode="bookmark_clean">
		<xsl:apply-templates select="node()" mode="bookmark_clean"/>
	</xsl:template>

	<xsl:template match="text()" mode="bookmark_clean">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'math']" mode="bookmark_clean">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>

	<xsl:template match="mn:asciimath" mode="bookmark_clean"/>
	<!-- ============================ -->
	<!-- END: mode="bookmark_clean" -->
	<!-- ============================ -->

	<xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mnx:item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:variable name="title">
							<xsl:for-each select="mnx:title/node()">
								<xsl:choose>
									<xsl:when test="local-name() = 'add' and starts-with(., $ace_tag)"><!-- skip --></xsl:when>
									<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:variable>
						<xsl:value-of select="normalize-space($title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mnx:title" mode="bookmark"/>
	<xsl:template match="text()" mode="bookmark"/>

	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="mn:title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-title])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
			<!-- <xsl:text> </xsl:text> -->
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-title" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>

	<xsl:template match="mn:span[                @class = 'fmt-caption-label' or                 @class = 'fmt-element-name' or                @class = 'fmt-caption-delim']" mode="contents_item" priority="3">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<xsl:template match="mn:semx" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label" mode="contents_item"/>

	<xsl:template match="mn:concept" mode="contents_item"/>
	<xsl:template match="mn:eref" mode="contents_item"/>
	<xsl:template match="mn:xref" mode="contents_item"/>
	<xsl:template match="mn:link" mode="contents_item"/>
	<xsl:template match="mn:origin" mode="contents_item"/>
	<xsl:template match="mn:erefstack" mode="contents_item"/>

	<!-- fn -->
	<xsl:template match="mn:fn" mode="contents"/>
	<xsl:template match="mn:fn" mode="bookmarks"/>

	<xsl:template match="mn:fn" mode="contents_item"/>

	<xsl:template match="mn:xref | mn:eref" mode="contents">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="mn:annotation" mode="contents_item"/>

	<xsl:template match="mn:tab" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:strong" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:copy>
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="element" select="$element"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:em" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sub" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:sup" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="mn:stem" mode="contents_item"/>
	<xsl:template match="mn:fmt-stem" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:br" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="mn:name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:if test="not(following-sibling::*[1][self::mn:fmt-name])">
			<xsl:apply-templates mode="contents_item">
				<xsl:with-param name="mode" select="$mode"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mn:fmt-name" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="mn:add" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:choose>
			<xsl:when test="starts-with(text(), $ace_tag)">
				<xsl:if test="$mode = 'contents'">
					<xsl:copy>
						<xsl:apply-templates mode="contents_item"/>
					</xsl:copy>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise><xsl:apply-templates mode="contents_item"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="text()" mode="contents_item">
		<xsl:variable name="text">
			<!-- to split by '_' and other chars -->
			<mnx:text><xsl:call-template name="add-zero-spaces-java"/></mnx:text>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($text)/mnx:text/text()">
			<xsl:call-template name="keep_together_standard_number"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="mn:add/text()" mode="contents_item" priority="2"> <!-- mn:add[starts-with(., $ace_tag)]/text() -->
		<xsl:if test="starts-with(normalize-space(..), $ace_tag)"><xsl:value-of select="."/></xsl:if>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="mn:span" mode="contents_item">
		<xsl:param name="element"/>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="element" select="$element"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->

	<xsl:variable name="toc_level">
		<!-- https://www.metanorma.org/author/ref/document-attributes/ -->
		<xsl:variable name="pdftoclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'PDF TOC Heading Levels']/mn:value)"/> <!-- :toclevels-pdf  Number of table of contents levels to render in PDF output; used to override :toclevels:-->
		<xsl:variable name="toclevels" select="normalize-space(//mn:metanorma-extension/mn:presentation-metadata[mn:name/text() = 'TOC Heading Levels']/mn:value)"/> <!-- Number of table of contents levels to render -->
		<xsl:choose>
			<xsl:when test="$pdftoclevels != ''"><xsl:value-of select="number($pdftoclevels)"/></xsl:when> <!-- if there is value in xml -->
			<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>  <!-- if there is value in xml -->
			<xsl:otherwise><!-- default value -->3
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="mn:toc">
		<xsl:param name="colwidths"/>
		<xsl:variable name="colwidths_">
			<xsl:choose>
				<xsl:when test="not($colwidths)">
					<xsl:variable name="toc_table_simple">
						<mn:tbody>
							<xsl:apply-templates mode="toc_table_width"/>
						</mn:tbody>
					</xsl:variable>
					<!-- <debug_toc_table_simple><xsl:copy-of select="$toc_table_simple"/></debug_toc_table_simple> -->
					<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/mn:tr[1]/mn:td)"/>
					<xsl:call-template name="calculate-column-widths-proportional">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$toc_table_simple"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="$colwidths"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- <debug_colwidth><xsl:copy-of select="$colwidths_"/></debug_colwidth> -->
		<fo:block role="TOCI" space-after="16pt">
			<fo:table width="100%" table-layout="fixed">
				<xsl:for-each select="xalan:nodeset($colwidths_)/column">
					<fo:table-column column-width="proportional-column-width({.})"/>
				</xsl:for-each>
				<fo:table-body>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<xsl:template match="mn:toc//mn:li" priority="2">
		<fo:table-row min-height="5mm">
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="mn:toc//mn:li/mn:p">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:toc//mn:xref | mn:toc//mn:fmt-xref" priority="3">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format: one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- <test><xsl:copy-of select="."/></test> -->

		<xsl:variable name="target" select="@target"/>

		<xsl:for-each select="mn:tab">

			<xsl:if test="position() = 1">
				<!-- first column (data before first `tab`) -->
				<fo:table-cell>
					<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
						<xsl:call-template name="insert_basic_link">
							<xsl:with-param name="element">
								<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
									<xsl:for-each select="preceding-sibling::node()">
										<xsl:choose>
											<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
											<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</fo:basic-link>
							</xsl:with-param>
						</xsl:call-template>
					</fo:block>
				</fo:table-cell>
			</xsl:if>

			<xsl:variable name="current_id" select="generate-id()"/>
			<fo:table-cell>
				<fo:block line-height-shift-adjustment="disregard-shifts" role="SKIP">
					<xsl:call-template name="insert_basic_link">
						<xsl:with-param name="element">
							<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
								<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
									<xsl:choose>
										<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
										<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</fo:basic-link>
						</xsl:with-param>
					</xsl:call-template>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block role="SKIP">
				<xsl:call-template name="insert_basic_link">
					<xsl:with-param name="element">
						<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
							<fo:page-number-citation ref-id="{$target}"/>
						</fo:basic-link>
					</xsl:with-param>
				</xsl:call-template>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- ================================== -->
	<!-- calculate ToC table columns widths -->
	<!-- ================================== -->
	<xsl:template match="*" mode="toc_table_width">
		<xsl:apply-templates mode="toc_table_width"/>
	</xsl:template>

	<xsl:template match="mn:clause[@type = 'toc']/mn:fmt-title" mode="toc_table_width"/>
	<xsl:template match="mn:clause[not(@type = 'toc')]/mn:fmt-title" mode="toc_table_width"/>

	<xsl:template match="mn:li" mode="toc_table_width">
		<mn:tr>
			<xsl:apply-templates mode="toc_table_width"/>
		</mn:tr>
	</xsl:template>

	<xsl:template match="mn:fmt-xref" mode="toc_table_width">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<!-- New format - one tab <xref target="cgpm9th1948r6">&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="mn:tab">
			<xsl:if test="position() = 1">
				<mn:td>
					<xsl:for-each select="preceding-sibling::node()">
						<xsl:choose>
							<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
							<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</mn:td>
			</xsl:if>
			<xsl:variable name="current_id" select="generate-id()"/>
			<mn:td>
				<xsl:for-each select="following-sibling::node()[not(self::mn:tab) and preceding-sibling::mn:tab[1][generate-id() = $current_id]]">
					<xsl:choose>
						<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</mn:td>
		</xsl:for-each>
		<mn:td>333</mn:td> <!-- page number, just for fill -->
	</xsl:template>

	<!-- ================================== -->
	<!-- END: calculate ToC table columns widths -->
	<!-- ================================== -->

	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->

	<!-- Tabulation processing -->
	<xsl:template match="mn:tab">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="padding">
			<xsl:choose>
				<xsl:when test="ancestor::mn:note and ancestor::mn:fmt-name">4</xsl:when>
				<xsl:when test="$depth &gt;= 5"/>
				<xsl:when test="$depth &gt;= 4">5</xsl:when>
				<xsl:when test="$depth &gt;= 3 and ancestor::mn:terms">3</xsl:when>
				<xsl:when test="$depth &gt;= 2">4</xsl:when>
				<xsl:when test="$depth = 1">4</xsl:when>
				<xsl:otherwise>2</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$lang = 'zh'">
				<fo:inline role="SKIP"><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%" role="SKIP">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm" role="SKIP"><xsl:value-of select="$direction"/>​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- tab -->

	<xsl:template match="mn:note/mn:fmt-name/mn:tab" priority="2"/>
	<xsl:template match="mn:termnote/mn:fmt-name/mn:tab" priority="2"/>

	<xsl:template match="mn:note/mn:fmt-name/mn:tab" mode="tab">
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
	</xsl:template>

	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:variable name="reviews_">
		<xsl:for-each select="//mn:annotation[not(parent::mn:annotation-container)][@from]">
			<xsl:copy>
				<xsl:copy-of select="@from"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
		<xsl:for-each select="//mn:fmt-annotation-start[@source]">
			<xsl:copy>
				<xsl:copy-of select="@source"/>
				<xsl:copy-of select="@id"/>
			</xsl:copy>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews" select="xalan:nodeset($reviews_)"/>

	<xsl:template name="addReviewHelper">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- if there is review with from="...", then add small helper block for Annot tag adding, see 'review' template -->
			<xsl:variable name="curr_id" select="@id"/>
			<!-- <xsl:variable name="review_id" select="normalize-space(/@id)"/> -->
			<xsl:for-each select="$reviews//mn:annotation[@from = $curr_id]"> <!-- $reviews//mn:fmt-review-start[@source = $curr_id] -->
				<xsl:variable name="review_id" select="normalize-space(@id)"/>
				<xsl:if test="$review_id != ''"> <!-- i.e. if review found -->
					<fo:block keep-with-next="always" line-height="0.1" id="{$review_id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$review_id}" fox:alt-text="Annot___{$review_id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
		<!-- <fo:block>
			<curr_id><xsl:value-of select="$curr_id"/></curr_id>
			<xsl:copy-of select="$reviews"/>
		</fo:block> -->
	</xsl:template>

	<!-- document text (not figures, or tables) footnotes -->
	<xsl:variable name="reviews_container_">
		<xsl:for-each select="//mn:annotation-container/mn:fmt-annotation-body">
			<xsl:variable name="update_xml_step1">
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:variable>
			<xsl:apply-templates select="xalan:nodeset($update_xml_step1)" mode="update_xml_enclose_keep-together_within-line"/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="reviews_container" select="xalan:nodeset($reviews_container_)"/>

	<xsl:template match="mn:annotation-container"/>

	<!-- for old Presentation XML (before https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:annotation[not(parent::mn:annotation-container)]">  <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<xsl:variable name="id_from" select="normalize-space(current()/@from)"/>
		<xsl:if test="$isGenerateTableIF = 'false'">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>
	</xsl:template>

	<!-- for new Presentation XML (https://github.com/metanorma/isodoc/issues/670) -->
	<xsl:template match="mn:fmt-annotation-start" name="fmt-annotation-start"> <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->

		<xsl:variable name="id_from" select="normalize-space(current()/@source)"/>

		<xsl:variable name="source" select="normalize-space(@source)"/>

		<xsl:if test="$isGenerateTableIF = 'false'">
		<!-- <xsl:variable name="id_from" select="normalize-space(current()/@from)"/> -->

		<!-- <xsl:if test="@source = @end"> -->
		<!-- following-sibling::node()[1][local-name() = 'bookmark'][@id = $source] and
				following-sibling::node()[2][local-name() = 'fmt-review-end'][@source = $source] -->
			<!-- <fo:block id="{$source}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$source}" fox:alt-text="Annot___{$source}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block> -->
			<xsl:call-template name="setNamedDestination"/>
			<fo:block id="{@id}" font-size="1pt" role="SKIP" keep-with-next="always" line-height="0.1"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
		<!-- </xsl:if> -->
		</xsl:if>

		<xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{@id}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{$id_from}" font-size="1pt" role="SKIP"><xsl:value-of select="$hair_space"/><fo:basic-link internal-destination="{$id_from}" fox:alt-text="Annot___{@id}" role="Annot"><xsl:value-of select="$hair_space"/></fo:basic-link></fo:block>
			</xsl:when>
		</xsl:choose>
		</xsl:if>

    <xsl:if test="1 = 2">
		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="ancestor::mn:metanorma and not(ancestor::mn:metanorma//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
			<xsl:when test="not(/*[@id = $id_from]) and not(/*//*[@id = $id_from]) and not(preceding-sibling::*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt" role="SKIP"><fo:wrapper role="artifact"><xsl:value-of select="$hair_space"/></fo:wrapper></fo:block>
			</xsl:when>
		</xsl:choose>
    </xsl:if>

	</xsl:template>

	<!-- https://github.com/metanorma/mn-samples-bsi/issues/312 -->
	<xsl:template match="mn:annotation[@type = 'other']"/>

	<!-- ============ -->
	<!-- errata -->
	<!-- ============ -->
	<xsl:template match="mn:errata">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block role="SKIP">Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="mn:errata/mn:row">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="mn:errata/mn:row/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block role="SKIP"><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============ -->
	<!-- END errata -->
	<!-- ============ -->

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->
	<xsl:template match="mn:ruby">
		<fo:inline-container text-indent="0mm" last-line-end-indent="0mm">
			<xsl:if test="not(ancestor::mn:ruby)">
				<xsl:attribute name="alignment-baseline">central</xsl:attribute>
			</xsl:if>
			<xsl:variable name="rt_text" select="mn:rt"/>
			<xsl:variable name="rb_text" select=".//mn:rb[not(mn:ruby)]"/>
			<!-- Example: width="2em"  -->
			<xsl:variable name="text_rt_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rt_text, $font_main, 6)"/>
			<xsl:variable name="text_rb_width" select="java:org.metanorma.fop.Util.getStringWidthByFontSize($rb_text, $font_main, 10)"/>
			<xsl:variable name="text_width">
				<xsl:choose>
					<xsl:when test="$text_rt_width &gt;= $text_rb_width"><xsl:value-of select="$text_rt_width"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$text_rb_width"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="width"><xsl:value-of select="$text_width div 10"/>em</xsl:attribute>

			<xsl:choose>
				<xsl:when test="ancestor::mn:ruby">
					<xsl:apply-templates select="mn:rb"/>
					<xsl:apply-templates select="mn:rt"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="mn:rt"/>
					<xsl:apply-templates select="mn:rb"/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="node()[not(self::mn:rt) and not(self::mn:rb)]"/>
		</fo:inline-container>
	</xsl:template>

	<xsl:template match="mn:rb">
		<fo:block line-height="1em" text-align="center"><xsl:apply-templates/></fo:block>
	</xsl:template>

	<xsl:template match="mn:rt">
		<fo:block font-size="0.5em" text-align="center" line-height="1.2em" space-before="-1.4em" space-before.conditionality="retain"> <!--  -->
			<xsl:if test="ancestor::mn:ruby[last()]//mn:ruby or      ancestor::mn:rb">
				<xsl:attribute name="space-before">0em</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:block>

	</xsl:template>

	<!-- ===================================== -->
	<!-- ===================================== -->
	<!-- END: Ruby text (CJK languages) rendering -->
	<!-- ===================================== -->
	<!-- ===================================== -->

	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/mn:preface/*[not(self::mn:note or self::mn:admonition)]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="copyCommonElements">
		<!-- copy bibdata, localized-strings, metanorma-extension and boilerplate -->
		<xsl:copy-of select="/*/*[not(self::mn:preface) and not(self::mn:sections) and not(self::mn:annex) and not(self::mn:bibliography) and not(self::mn:indexsect)]"/>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault">
		<xsl:for-each select="/*/mn:sections/* | /*/mn:bibliography/mn:references[@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/mn:annex">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/mn:bibliography/*[not(@normative='true')] |          /*/mn:bibliography/mn:clause[mn:references[not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template><!-- END: processMainSectionsDefault -->

	<xsl:template name="deleteFile">
		<xsl:param name="filepath"/>
		<xsl:variable name="xml_file" select="java:java.io.File.new($filepath)"/>
		<xsl:variable name="xml_file_path" select="java:toPath($xml_file)"/>
		<xsl:variable name="deletefile" select="java:java.nio.file.Files.deleteIfExists($xml_file_path)"/>
	</xsl:template>

	<xsl:template name="getPageSequenceOrientation">
		<xsl:variable name="previous_orientation" select="preceding-sibling::mn:page_sequence[@orientation][1]/@orientation"/>
		<xsl:choose>
			<xsl:when test="@orientation = 'landscape'">-<xsl:value-of select="@orientation"/></xsl:when>
			<xsl:when test="$previous_orientation = 'landscape' and not(@orientation = 'portrait')">-<xsl:value-of select="$previous_orientation"/></xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:variable name="regex_standard_reference">([A-Z]{2,}(/[A-Z]{2,})* \d+(-\d+)*(:\d{4})?)</xsl:variable> <!-- example: ISO 1234:2000 -->
	<xsl:variable name="tag_fo_inline_keep-together_within-line_open">###fo:inline keep-together_within-line###</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_close">###/fo:inline keep-together_within-line###</xsl:variable>
	<xsl:template match="text()" name="text">
		<xsl:choose>
			<xsl:when test="ancestor::mn:table"><xsl:value-of select="."/></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new(.),$regex_standard_reference,concat($tag_fo_inline_keep-together_within-line_open,'$1',$tag_fo_inline_keep-together_within-line_close))"/>
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_fo_inline_keep-together_within-line_open"/>
					<xsl:with-param name="tag_close" select="$tag_fo_inline_keep-together_within-line_close"/>
					<xsl:with-param name="text" select="$text"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="replace_fo_inline_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<!-- <xsl:text disable-output-escaping="yes">&lt;fo:inline keep-together.within-line="always"&gt;</xsl:text> -->
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>
				<xsl:choose>
					<xsl:when test="local-name(..) = 'keep-together_within-line'"> <!-- prevent two nested <fo:inline keep-together.within-line="always"><fo:inline keep-together.within-line="always" -->
						<xsl:value-of select="substring-before($text_after, $tag_close)"/>
					</xsl:when>
					<xsl:otherwise>
						<fo:inline keep-together.within-line="always" role="SKIP">
							<xsl:value-of select="substring-before($text_after, $tag_close)"/>
						</fo:inline>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <xsl:text disable-output-escaping="yes">&lt;/fo:inline&gt;</xsl:text> -->
				<xsl:call-template name="replace_fo_inline_tags">
					<xsl:with-param name="tag_open" select="$tag_open"/>
					<xsl:with-param name="tag_close" select="$tag_close"/>
					<xsl:with-param name="text" select="substring-after($text_after, $tag_close)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- keep-together for standard's name (ISO 12345:2020), added in mode="update_xml_enclose_keep-together_within-line" -->
	<xsl:template match="*[local-name() = 'keep-together_within-line']">
		<xsl:param name="split_keep-within-line"/>

		<!-- <fo:inline>split_keep-within-line='<xsl:value-of select="$split_keep-within-line"/>'</fo:inline> -->
		<xsl:choose>

			<xsl:when test="normalize-space($split_keep-within-line) = 'true'">
				<xsl:variable name="sep">_</xsl:variable>
				<xsl:variable name="items">
					<xsl:call-template name="split">
						<xsl:with-param name="pText" select="."/>
						<xsl:with-param name="sep" select="$sep"/>
						<xsl:with-param name="normalize-space">false</xsl:with-param>
						<xsl:with-param name="keep_sep">true</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:for-each select="xalan:nodeset($items)/mnx:item">
					<xsl:choose>
						<xsl:when test=". = $sep">
							<xsl:value-of select="$sep"/><xsl:value-of select="$zero_width_space"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>

			<xsl:otherwise>
				<fo:inline keep-together.within-line="always" role="SKIP"><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>

		</xsl:choose>
	</xsl:template>

	<!-- add zero spaces into table cells text -->
	<xsl:template match="*[local-name() = 'td']//text() | *[local-name() = 'th']//text() | *[local-name() = 'dt']//text() | *[local-name() = 'dd']//text()" priority="1">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'keep-together_within-line']">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="addZeroWidthSpacesToTextNodes"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addZeroWidthSpacesToTextNodes">
		<xsl:variable name="text"><text><xsl:call-template name="text"/></text></xsl:variable>
		<!-- <xsl:copy-of select="$text"/> -->
		<xsl:for-each select="xalan:nodeset($text)/text/node()">
			<xsl:choose>
				<xsl:when test="self::text()"><xsl:call-template name="add-zero-spaces-java"/></xsl:when>
				<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<!-- default: ignore title in sections/p -->
	<xsl:template match="mn:sections/mn:p[starts-with(@class, 'zzSTDTitle')]" priority="3"/>

	<xsl:template match="mn:pagebreak">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>

	<xsl:variable name="font_main_root_style">
		<root-style xsl:use-attribute-sets="root-style">
		</root-style>
	</xsl:variable>
	<xsl:variable name="font_main_root_style_font_family" select="xalan:nodeset($font_main_root_style)/root-style/@font-family"/>
	<xsl:variable name="font_main">
		<xsl:choose>
			<xsl:when test="contains($font_main_root_style_font_family, ',')"><xsl:value-of select="substring-before($font_main_root_style_font_family, ',')"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$font_main_root_style_font_family"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="language_current_3" select="normalize-space(//mn:bibdata//mn:language)"/>
							<xsl:choose>
								<xsl:when test="$language_current_3 != ''">
									<xsl:value-of select="$language_current_3"/>
								</xsl:when>
								<xsl:otherwise>en</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getLang_fromCurrentNode">
		<xsl:variable name="language_current" select="normalize-space(.//mn:bibdata//mn:language[@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//mn:bibdata//mn:language[@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select=".//mn:bibdata//mn:language"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>
	</xsl:template>

	<xsl:template match="mn:localityStack"/>

	<xsl:variable name="pdfAttachmentsList_">
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<attachment filename="{@name}"/>
		</xsl:for-each>
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<attachment filename="{$attachment_path}"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="pdfAttachmentsList" select="xalan:nodeset($pdfAttachmentsList_)"/>

	<xsl:template name="getAltText">
		<xsl:choose>
			<xsl:when test="normalize-space(.) = ''"><xsl:value-of select="@target"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="normalize-space(translate(normalize-space(), ' —', ' -'))"/></xsl:otherwise>
			<!-- <xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise> -->
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setBlockSpanAll">
		<xsl:if test="@columns = 1 or     (local-name() = 'p' and *[@columns = 1])"><xsl:attribute name="span">all</xsl:attribute></xsl:if>
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:choose>
			<xsl:when test="mn:fmt-title">
				<xsl:variable name="fmt_title_section">
					<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/preceding-sibling::node()[not(self::mn:annotation)]"/>
				</xsl:variable>
				<xsl:value-of select="normalize-space($fmt_title_section)"/>
				<xsl:if test="normalize-space($fmt_title_section) = ''">
					<xsl:value-of select="mn:fmt-title/mn:tab[1]/preceding-sibling::node()"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="mn:title/mn:tab[1]/preceding-sibling::node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab]">
				<xsl:copy-of select="mn:fmt-title//mn:span[@class = 'fmt-caption-delim'][mn:tab][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title/mn:tab">
				<xsl:copy-of select="mn:fmt-title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:when test="mn:fmt-title">
				<xsl:copy-of select="mn:fmt-title/node()"/>
			</xsl:when>
			<xsl:when test="mn:title/mn:tab">
				<xsl:copy-of select="mn:title/mn:tab[1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="mn:title/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="extractSection">
		<xsl:value-of select="mn:tab[1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="mn:tab">
					<xsl:apply-templates select="mn:tab[1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<!-- main sections -->
	<xsl:template match="/*/mn:sections/*" name="sections_node" priority="2">
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>

			<xsl:call-template name="sections_element_style"/>

			<xsl:call-template name="addReviewHelper"/>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template>

	<!-- note: @top-level added in mode=" update_xml_step_move_pagebreak" -->
	<xsl:template match="mn:sections/mn:page_sequence/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/sections/clause -->
	<xsl:template match="mn:page_sequence/mn:sections/*[not(@top-level)]" priority="2">
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="sections_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sections_element_style">
		<xsl:variable name="pos"><xsl:number count="mn:sections/*/mn:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | mn:sections/mn:terms -->
		<xsl:if test="$pos &gt;= 2">
			<xsl:attribute name="space-before">18pt</xsl:attribute>
		</xsl:if>
	</xsl:template> <!-- sections_element_style -->

	<xsl:template match="//mn:metanorma/mn:preface/*" priority="2" name="preface_node"> <!-- /*/mn:preface/* -->
		<fo:block break-after="page"/>
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:call-template name="addReviewHelper"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- preface/ page_sequence/clause -->
	<xsl:template match="mn:preface/mn:page_sequence/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- page_sequence/preface/clause -->
	<xsl:template match="mn:page_sequence/mn:preface/*[not(@top-level)]" priority="2"> <!-- /*/mn:preface/* -->
		<xsl:choose>
			<xsl:when test="self::mn:clause and normalize-space() = '' and count(*) = 0"/>
			<xsl:otherwise>
				<xsl:call-template name="preface_node"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:clause[normalize-space() != '' or mn:figure or @id]" name="template_clause"> <!-- if clause isn't empty -->
		<xsl:call-template name="setNamedDestination"/>
		<fo:block>
			<xsl:if test="parent::mn:copyright-statement">
				<xsl:attribute name="role">SKIP</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setId"/>

			<xsl:call-template name="setBlockSpanAll"/>

			<xsl:call-template name="refine_clause_style"/>

			<xsl:call-template name="addReviewHelper"/>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="refine_clause_style">
	</xsl:template> <!-- refine_clause_style -->

	<xsl:template match="mn:annex[normalize-space() != '']">
		<xsl:choose>
			<xsl:when test="@continue = 'true'"> <!-- it's using for figure/table on top level for block span -->
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>

				<fo:block break-after="page"/>
				<xsl:call-template name="setNamedDestination"/>

				<fo:block id="{@id}">

					<xsl:call-template name="setBlockSpanAll"/>

					<xsl:call-template name="refine_annex_style"/>

				</fo:block>

				<xsl:apply-templates select="mn:fmt-title[@columns = 1]"/>

				<fo:block>
					<xsl:apply-templates select="node()[not(self::mn:fmt-title and @columns = 1)]"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="refine_annex_style">
	</xsl:template>

	<xsl:template match="mn:name/text() | mn:fmt-name/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>

	<!-- insert fo:basic-link, if external-destination or internal-destination is non-empty, otherwise insert fo:inline -->
	<xsl:template name="insert_basic_link">
		<xsl:param name="element"/>
		<xsl:variable name="element_node" select="xalan:nodeset($element)"/>
		<xsl:variable name="external-destination" select="normalize-space(count($element_node/fo:basic-link/@external-destination[. != '']) = 1)"/>
		<xsl:variable name="internal-destination" select="normalize-space(count($element_node/fo:basic-link/@internal-destination[. != '']) = 1)"/>
		<xsl:choose>
			<xsl:when test="$external-destination = 'true' or $internal-destination = 'true'">
				<xsl:copy-of select="$element_node"/>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline>
					<xsl:for-each select="$element_node/fo:basic-link/@*[local-name() != 'external-destination' and local-name() != 'internal-destination' and local-name() != 'alt-text']">
						<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
					</xsl:for-each>
					<xsl:copy-of select="$element_node/fo:basic-link/node()"/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mn:variant-title"/> <!-- [@type = 'sub'] -->
	<xsl:template match="mn:variant-title[@type = 'sub']" mode="subtitle">
		<fo:inline padding-right="5mm"> </fo:inline>
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="mn:blacksquare" name="blacksquare">
		<fo:inline padding-right="2.5mm" baseline-shift="5%">
			<fo:instream-foreign-object content-height="2mm" content-width="2mm" fox:alt-text="Quad">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" viewBox="0 0 2 2">
						<rect x="0" y="0" width="2" height="2" fill="black"/>
					</svg>
				</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template>

	<xsl:template match="@language">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="mn:p[@type = 'floating-title' or @type = 'section-title']" priority="4">
		<xsl:call-template name="title"/>
	</xsl:template>

	<!-- https://github.com/metanorma/isodoc/issues/652 -->
	<xsl:template match="mn:quote/mn:source"/>
	<xsl:template match="mn:quote/mn:author"/>
	<xsl:template match="mn:amend"/>

	<!-- fmt-title renamed to title in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-title" /> -->

	<!-- fmt-name renamed to name in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-name" /> -->

	<!-- fmt-preferred renamed to preferred in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-preferred" /> -->

	<!-- fmt-admitted renamed to admitted in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-admitted" /> -->

	<!-- fmt-deprecates renamed to deprecates in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-deprecates" /> -->

	<!-- fmt-definition renamed to definition in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-definition" /> -->

	<!-- fmt-termsource renamed to termsource in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-termsource" /> -->

	<!-- fmt-source renamed to source in update_xml_step1 -->
	<!-- <xsl:template match="mn:fmt-source" /> -->

	<xsl:template match="mn:semx">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:fmt-xref-label"/>

	<xsl:template match="mn:concept"/>

	<xsl:template match="mn:fmt-concept">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="mn:erefstack"/>

	<xsl:template match="mn:svgmap"/>

	<!-- for correct rendering combining chars, added in mode="update_xml_step2" -->
	<xsl:template match="*[local-name() = 'lang_none']">
		<fo:inline xml:lang="none"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="replaceChar">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:choose>
			<xsl:when test="$text = '' or $replace = '' or not($replace)">
				<xsl:value-of select="$text"/>
			</xsl:when>
			<xsl:when test="contains($text, $replace)">
				<xsl:value-of select="substring-before($text,$replace)"/>
				<xsl:element name="inlineChar" namespace="{$namespace_full}"><xsl:value-of select="$by"/></xsl:element>
				<xsl:call-template name="replaceChar">
						<xsl:with-param name="text" select="substring-after($text,$replace)"/>
						<xsl:with-param name="replace" select="$replace"/>
						<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- inlineChar added in the template replaceChar -->
	<xsl:template match="mn:inlineChar">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="printEdition">
		<xsl:variable name="edition_i18n" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition[normalize-space(@language) != ''])"/>
		<xsl:choose>
			<xsl:when test="$edition_i18n != ''">
				<!-- Example: <edition language="fr">deuxième édition</edition> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$edition_i18n"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="edition" select="normalize-space((//mn:metanorma)[1]/mn:bibdata/mn:edition)"/>
				<xsl:if test="$edition != ''"> <!-- Example: 1.3 -->
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str">
							<xsl:call-template name="getLocalizedString">
								<xsl:with-param name="key">edition</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:text> </xsl:text>
					<xsl:value-of select="$edition"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- convert YYYY-MM-DD to 'Month YYYY' or 'Month DD, YYYY' or DD Month YYYY -->
	<xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:call-template name="getMonthByNum">
				<xsl:with-param name="num" select="$month"/>
				<xsl:with-param name="lowercase" select="'true'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="monthStr_localized">
			<xsl:if test="normalize-space($monthStr) != ''"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param></xsl:call-template></xsl:if>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'"> <!-- convert date from format 2007-04-01 to 1 April 2007 -->
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr_localized"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr_localized, ' ', $day, ', ' , $year))"/> <!-- January 01, 2022 -->
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template> <!-- convertDate -->

	<!-- return Month's name by number -->
	<xsl:template name="getMonthByNum">
		<xsl:param name="num"/>
		<xsl:param name="lang">en</xsl:param>
		<xsl:param name="lowercase">false</xsl:param> <!-- return 'january' instead of 'January' -->
		<xsl:variable name="monthStr_">
			<xsl:choose>
				<xsl:when test="$lang = 'fr'">
					<xsl:choose>
						<xsl:when test="$num = '01'">Janvier</xsl:when>
						<xsl:when test="$num = '02'">Février</xsl:when>
						<xsl:when test="$num = '03'">Mars</xsl:when>
						<xsl:when test="$num = '04'">Avril</xsl:when>
						<xsl:when test="$num = '05'">Mai</xsl:when>
						<xsl:when test="$num = '06'">Juin</xsl:when>
						<xsl:when test="$num = '07'">Juillet</xsl:when>
						<xsl:when test="$num = '08'">Août</xsl:when>
						<xsl:when test="$num = '09'">Septembre</xsl:when>
						<xsl:when test="$num = '10'">Octobre</xsl:when>
						<xsl:when test="$num = '11'">Novembre</xsl:when>
						<xsl:when test="$num = '12'">Décembre</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$num = '01'">January</xsl:when>
						<xsl:when test="$num = '02'">February</xsl:when>
						<xsl:when test="$num = '03'">March</xsl:when>
						<xsl:when test="$num = '04'">April</xsl:when>
						<xsl:when test="$num = '05'">May</xsl:when>
						<xsl:when test="$num = '06'">June</xsl:when>
						<xsl:when test="$num = '07'">July</xsl:when>
						<xsl:when test="$num = '08'">August</xsl:when>
						<xsl:when test="$num = '09'">September</xsl:when>
						<xsl:when test="$num = '10'">October</xsl:when>
						<xsl:when test="$num = '11'">November</xsl:when>
						<xsl:when test="$num = '12'">December</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($lowercase) = 'true'">
				<xsl:value-of select="java:toLowerCase(java:java.lang.String.new($monthStr_))"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$monthStr_"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getMonthByNum -->

	<!-- return Month's name by number from localized strings -->
	<xsl:template name="getMonthLocalizedByNum">
		<xsl:param name="num"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$num = '01'">january</xsl:when>
				<xsl:when test="$num = '02'">february</xsl:when>
				<xsl:when test="$num = '03'">march</xsl:when>
				<xsl:when test="$num = '04'">april</xsl:when>
				<xsl:when test="$num = '05'">may</xsl:when>
				<xsl:when test="$num = '06'">june</xsl:when>
				<xsl:when test="$num = '07'">july</xsl:when>
				<xsl:when test="$num = '08'">august</xsl:when>
				<xsl:when test="$num = '09'">september</xsl:when>
				<xsl:when test="$num = '10'">october</xsl:when>
				<xsl:when test="$num = '11'">november</xsl:when>
				<xsl:when test="$num = '12'">december</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="getLocalizedString">
			<xsl:with-param name="key">month_<xsl:value-of select="$monthStr"/></xsl:with-param>
		</xsl:call-template>
	</xsl:template> <!-- getMonthLocalizedByNum -->

	<xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="meta" select="'false'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//mn:metanorma/mn:bibdata//mn:keyword">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:param name="meta"/>
		<xsl:choose>
			<xsl:when test="$meta = 'true'">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addPDFUAmeta">
		<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
			<pdf:dictionary type="normal" key="ViewerPreferences">
				<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
			</pdf:dictionary>
		</pdf:catalog>
		<x:xmpmeta xmlns:x="adobe:ns:meta/">
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<!-- Commented after upgrade to Apache FOP 2.10
				<rdf:Description xmlns:pdfaExtension="http://www.aiim.org/pdfa/ns/extension/" xmlns:pdfaProperty="http://www.aiim.org/pdfa/ns/property#" xmlns:pdfaSchema="http://www.aiim.org/pdfa/ns/schema#" rdf:about="">
					<pdfaExtension:schemas>
						<rdf:Bag>
							<rdf:li rdf:parseType="Resource">
								<pdfaSchema:namespaceURI>http://www.aiim.org/pdfua/ns/id/</pdfaSchema:namespaceURI>
								<pdfaSchema:prefix>pdfuaid</pdfaSchema:prefix>
								<pdfaSchema:schema>PDF/UA identification schema</pdfaSchema:schema>
								<pdfaSchema:property>
									<rdf:Seq>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA version identifier</pdfaProperty:description>
											<pdfaProperty:name>part</pdfaProperty:name>
											<pdfaProperty:valueType>Integer</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA amendment identifier</pdfaProperty:description>
											<pdfaProperty:name>amd</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
										<rdf:li rdf:parseType="Resource">
											<pdfaProperty:category>internal</pdfaProperty:category>
											<pdfaProperty:description>PDF/UA corrigenda identifier</pdfaProperty:description>
											<pdfaProperty:name>corr</pdfaProperty:name>
											<pdfaProperty:valueType>Text</pdfaProperty:valueType>
										</rdf:li>
									</rdf:Seq>
								</pdfaSchema:property>
							</rdf:li>
						</rdf:Bag>
					</pdfaExtension:schemas>
				</rdf:Description> -->
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
								<xsl:value-of select="mn:title[@language = $lang]"/>

							</xsl:for-each>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:choose>
									<xsl:when test="normalize-space($title) != ''">
										<xsl:value-of select="$title"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text> </xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</rdf:li>
						</rdf:Alt>
					</dc:title>
					<xsl:variable name="dc_creator">
						<xsl:for-each select="(//mn:metanorma)[1]/mn:bibdata">
							<rdf:Seq>
								<xsl:for-each select="mn:contributor[mn:role[not(mn:description)]/@type='author']">
									<rdf:li>
										<xsl:value-of select="mn:organization/mn:name"/>
									</rdf:li>
									<!-- <xsl:if test="position() != last()">; </xsl:if> -->
								</xsl:for-each>
							</rdf:Seq>
						</xsl:for-each>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_creator) != ''">
						<dc:creator>
							<xsl:copy-of select="$dc_creator"/>
						</dc:creator>
					</xsl:if>

					<xsl:variable name="dc_description">
						<xsl:variable name="abstract">
							<xsl:copy-of select="//mn:metanorma/mn:preface/mn:abstract//text()[not(ancestor::mn:fmt-title) and not(ancestor::mn:title) and not(ancestor::mn:fmt-xref-label)]"/>
						</xsl:variable>
						<rdf:Alt>
							<rdf:li xml:lang="x-default">
								<xsl:value-of select="normalize-space($abstract)"/>
							</rdf:li>
						</rdf:Alt>
					</xsl:variable>
					<xsl:if test="normalize-space($dc_description)">
						<dc:description>
							<xsl:copy-of select="$dc_description"/>
						</dc:description>
					</xsl:if>

					<pdf:Keywords>
						<xsl:call-template name="insertKeywords">
							<xsl:with-param name="meta">true</xsl:with-param>
						</xsl:call-template>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
		<!-- add attachments -->
		<xsl:for-each select="//mn:metanorma/mn:metanorma-extension/mn:attachment">
			<xsl:variable name="bibitem_attachment_" select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment'] = current()/@name]"/>
			<xsl:variable name="bibitem_attachment" select="xalan:nodeset($bibitem_attachment_)"/>
			<xsl:variable name="description" select="normalize-space($bibitem_attachment/mn:formattedref)"/>
			<xsl:variable name="filename" select="java:org.metanorma.fop.Util.getFilenameFromPath(@name)"/>
			<!-- Todo: need update -->
			<xsl:variable name="afrelationship" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-AFRelationship'])"/>
			<xsl:variable name="volatile" select="normalize-space($bibitem_attachment//mn:classification[@type = 'pdf-volatile'])"/>

			<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" filename="{$filename}" link-as-file-annotation="true">
				<xsl:attribute name="src">
					<xsl:choose>
						<xsl:when test="normalize-space() != ''">
							<xsl:variable name="src_attachment" select="java:replaceAll(java:java.lang.String.new(.),'(&#13;&#10;|&#13;|&#10;)', '')"/> <!-- remove line breaks -->
							<xsl:value-of select="$src_attachment"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="url" select="concat('url(file:///',$inputxml_basepath , @name, ')')"/>
							<xsl:value-of select="$url"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:if test="$description != ''">
					<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$afrelationship != ''">
					<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$volatile != ''">
					<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
				</xsl:if>
			</pdf:embedded-file>
		</xsl:for-each>
		<!-- references to external attachments (no binary-encoded within the Metanorma XML file) -->
		<xsl:if test="not(//mn:metanorma/mn:metanorma-extension/mn:attachment)">
			<xsl:for-each select="//mn:bibitem[@hidden = 'true'][mn:uri[@type = 'attachment']]">
				<xsl:variable name="attachment_path" select="mn:uri[@type = 'attachment']"/>
				<xsl:variable name="attachment_name" select="java:org.metanorma.fop.Util.getFilenameFromPath($attachment_path)"/>
				<!-- <xsl:variable name="url" select="concat('url(file:///',$basepath, $attachment_path, ')')"/> -->
				<!-- See https://github.com/metanorma/metanorma-iso/issues/1369 -->
				<xsl:variable name="url" select="concat('url(file:///',$outputpdf_basepath, $attachment_path, ')')"/>
				<xsl:variable name="description" select="normalize-space(mn:formattedref)"/>
				<!-- Todo: need update -->
				<xsl:variable name="afrelationship" select="normalize-space(.//mn:classification[@type = 'pdf-AFRelationship'])"/>
				<xsl:variable name="volatile" select="normalize-space(.//mn:classification[@type = 'pdf-volatile'])"/>
				<pdf:embedded-file xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf" src="{$url}" filename="{$attachment_name}" link-as-file-annotation="true">
					<xsl:if test="$description != ''">
						<xsl:attribute name="description"><xsl:value-of select="$description"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$afrelationship != ''">
						<xsl:attribute name="afrelationship"><xsl:value-of select="$afrelationship"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="$volatile != ''">
						<xsl:attribute name="volatile"><xsl:value-of select="$volatile"/></xsl:attribute>
					</xsl:if>
				</pdf:embedded-file>
			</xsl:for-each>
		</xsl:if>
	</xsl:template> <!-- addPDFUAmeta -->

	<xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Get or calculate depth of the element -->
	<xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<!-- <xsl:message>
			<xsl:choose>
				<xsl:when test="local-name() = 'title'">title=<xsl:value-of select="."/></xsl:when>
				<xsl:when test="local-name() = 'clause'">clause/title=<xsl:value-of select="mn:title"/></xsl:when>
			</xsl:choose>
		</xsl:message> -->
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*[local-name() != 'page_sequence'])"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::mn:preface">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface and not(ancestor::mn:foreword) and not(ancestor::mn:introduction)"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:preface">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-title">
							<!-- determine 'depth' depends on upper clause with title/@depth -->
							<!-- <xsl:message>title=<xsl:value-of select="."/></xsl:message> -->
							<xsl:variable name="clause_with_depth_depth" select="ancestor::mn:clause[mn:fmt-title/@depth][1]/mn:fmt-title/@depth"/>
							<!-- <xsl:message>clause_with_depth_depth=<xsl:value-of select="$clause_with_depth_depth"/></xsl:message> -->
							<xsl:variable name="clause_with_depth_level" select="count(ancestor::mn:clause[mn:fmt-title/@depth][1]/ancestor::*)"/>
							<!-- <xsl:message>clause_with_depth_level=<xsl:value-of select="$clause_with_depth_level"/></xsl:message> -->
							<xsl:variable name="curr_level" select="count(ancestor::*) - 1"/>
							<!-- <xsl:message>curr_level=<xsl:value-of select="$curr_level"/></xsl:message> -->
							<!-- <xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:title/@depth)"/> -->
							<xsl:variable name="curr_clause_depth" select="number($clause_with_depth_depth) + (number($curr_level) - number($clause_with_depth_level)) "/>
							<!-- <xsl:message>curr_clause_depth=<xsl:value-of select="$curr_clause_depth"/></xsl:message> -->
							<xsl:choose>
								<xsl:when test="string(number($curr_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($curr_clause_depth)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections and self::mn:fmt-name and parent::mn:term">
							<xsl:variable name="upper_terms_depth" select="normalize-space(ancestor::mn:terms[1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_terms_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_terms_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 2"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:sections">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::*[self::mn:clause or self::mn:terms][1]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:bibliography">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::mn:annex">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex and self::mn:fmt-title">
							<xsl:variable name="upper_clause_depth" select="normalize-space(ancestor::mn:clause[2]/mn:fmt-title/@depth)"/>
							<xsl:choose>
								<xsl:when test="string(number($upper_clause_depth)) != 'NaN'">
									<xsl:value-of select="number($upper_clause_depth + 1)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$level_total - 1"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="ancestor::mn:annex">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="self::mn:annex">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevel -->

	<!-- Get or calculate depth of term's name -->
	<xsl:template name="getLevelTermName">
		<xsl:choose>
			<xsl:when test="normalize-space(../@depth) != ''">
				<xsl:value-of select="../@depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="title_level_">
					<xsl:for-each select="../preceding-sibling::mn:fmt-title[1]">
						<xsl:call-template name="getLevel"/>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="title_level" select="normalize-space($title_level_)"/>
				<xsl:choose>
					<xsl:when test="$title_level != ''"><xsl:value-of select="$title_level + 1"/></xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="getLevel"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLevelTermName -->

	<!-- split string by separator -->
	<xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:param name="keep_sep" select="'false'"/>
		<xsl:if test="string-length($pText) &gt;0">
			<xsl:element name="item" namespace="{$namespace_mn_xsl}">
				<xsl:choose>
					<xsl:when test="$normalize-space = 'true'">
						<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:if test="$keep_sep = 'true' and contains($pText, $sep)"><xsl:element name="item" namespace="{$namespace_mn_xsl}"><xsl:value-of select="$sep"/></xsl:element></xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space" select="$normalize-space"/>
				<xsl:with-param name="keep_sep" select="$keep_sep"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- split -->

	<xsl:template name="getDocumentId">
		<xsl:call-template name="getLang"/><xsl:value-of select="//mn:p[1]/@id"/>
	</xsl:template>

	<xsl:template name="getDocumentId_fromCurrentNode">
		<xsl:call-template name="getLang_fromCurrentNode"/><xsl:value-of select=".//mn:p[1]/@id"/>
	</xsl:template>

	<xsl:template name="setId">
		<xsl:param name="prefix"/>
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="concat($prefix, @id)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($prefix, generate-id())"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="setIDforNamedDestination">
		<xsl:if test="@named_dest">
			<xsl:attribute name="id"><xsl:value-of select="@named_dest"/></xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setIDforNamedDestinationInline">
		<xsl:if test="@named_dest">
			<fo:inline><xsl:call-template name="setIDforNamedDestination"/></fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setNamedDestination">
		<xsl:if test="$isGenerateTableIF = 'false'">
			<!-- skip GUID, e.g. _33eac3cb-9663-4291-ae26-1d4b6f4635fc -->
			<xsl:if test="@id and       normalize-space(java:matches(java:java.lang.String.new(@id), '_[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}')) = 'false'">
				<fox:destination internal-destination="{@id}"/>
			</xsl:if>
			<xsl:for-each select=". | mn:fmt-title | mn:fmt-name">
				<xsl:if test="@named_dest">
					<fox:destination internal-destination="{@named_dest}"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="getLocalizedString">
		<xsl:param name="key"/>
		<xsl:param name="formatted">false</xsl:param>
		<xsl:param name="lang"/>
		<xsl:param name="returnEmptyIfNotFound">false</xsl:param>
		<xsl:param name="bibdata_updated"/>

		<xsl:variable name="curr_lang">
			<xsl:choose>
				<xsl:when test="$lang != ''"><xsl:value-of select="$lang"/></xsl:when>
				<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="data_value">
			<xsl:choose>
				<xsl:when test="$formatted = 'true' and string-length($bibdata_updated) != 0">
					<xsl:apply-templates select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="string-length($bibdata_updated) != 0">
					<xsl:value-of select="xalan:nodeset($bibdata_updated)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//mn:localized-string[@key = $key and @language = $curr_lang])"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space($data_value) != ''">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'"><xsl:copy-of select="$data_value"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$data_value"/></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/mn:localized-strings/mn:localized-string[@key = $key and @language = $curr_lang]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$returnEmptyIfNotFound = 'true'"/>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- getLocalizedString -->

	<xsl:template name="setTrackChangesStyles">
		<xsl:param name="isAdded"/>
		<xsl:param name="isDeleted"/>

		<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
		<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>

		<xsl:choose>
			<xsl:when test="local-name() = 'math'">
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-added"/></xsl:attribute>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-deleted"/></xsl:attribute>
					<xsl:if test="local-name() = 'table'">
						<xsl:attribute name="background-color">rgb(255, 185, 185)</xsl:attribute>
					</xsl:if>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- setTrackChangesStyles -->

	<!--  see https://xmlgraphics.apache.org/fop/2.5/complexscripts.html#bidi_controls-->
	<xsl:variable name="LRM" select="'‎'"/> <!-- U+200E - LEFT-TO-RIGHT MARK (LRM) -->
	<xsl:variable name="RLM" select="'‏'"/> <!-- U+200F - RIGHT-TO-LEFT MARK (RLM) -->
	<xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="setTextAlignment">
		<xsl:param name="default">left</xsl:param>
		<xsl:variable name="align" select="normalize-space(@align)"/>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
				<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
				<xsl:when test="$align = 'justified'">justify</xsl:when>
				<xsl:when test="$align != '' and not($align = 'indent')"><xsl:value-of select="$align"/></xsl:when>
				<xsl:when test="ancestor::mn:td/@align"><xsl:value-of select="ancestor::mn:td/@align"/></xsl:when>
				<xsl:when test="ancestor::mn:th/@align"><xsl:value-of select="ancestor::mn:th/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$align = 'indent'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<xsl:template name="setBlockAttributes">
		<xsl:param name="text_align_default">left</xsl:param>
		<xsl:call-template name="setTextAlignment">
			<xsl:with-param name="default" select="$text_align_default"/>
		</xsl:call-template>
		<xsl:call-template name="setKeepAttributes"/>
	</xsl:template>

	<xsl:template name="setKeepAttributes">
		<!-- https://www.metanorma.org/author/topics/document-format/text/#avoiding-page-breaks -->
		<!-- Example: keep-lines-together="true" -->
		<xsl:if test="@keep-lines-together = 'true'">
			<xsl:attribute name="keep-together.within-column">always</xsl:attribute>
		</xsl:if>
		<!-- Example: keep-with-next="true" -->
		<xsl:if test="@keep-with-next =  'true'">
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- insert cover page image -->
	<!-- background cover image -->
	<xsl:template name="insertBackgroundPageImage">
		<xsl:param name="number">1</xsl:param>
		<xsl:param name="name">coverpage-image</xsl:param>
		<xsl:param name="suffix"/>
		<xsl:variable name="num" select="number($number)"/>
		<!-- background image -->
		<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0" id="__internal_layout__coverpage{$suffix}_{$name}_{$number}_{generate-id()}">
			<fo:block>
				<xsl:for-each select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata[mn:name = $name][1]/mn:value/mn:image[$num]">
					<xsl:choose>
						<xsl:when test="*[local-name() = 'svg'] or java:endsWith(java:java.lang.String.new(@src), '.svg')">
							<fo:instream-foreign-object fox:alt-text="Image Front">
								<xsl:attribute name="content-height"><xsl:value-of select="$pageHeight"/>mm</xsl:attribute>
								<xsl:call-template name="getSVG"/>
							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:when test="starts-with(@src, 'data:application/pdf;base64')">
							<fo:external-graphic src="{@src}" fox:alt-text="Image Front"/>
						</xsl:when>
						<xsl:otherwise> <!-- bitmap image -->
							<xsl:variable name="coverimage_src" select="normalize-space(@src)"/>
							<xsl:if test="$coverimage_src != ''">
								<xsl:variable name="coverpage">
									<xsl:call-template name="getImageURL">
										<xsl:with-param name="src" select="$coverimage_src"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- <xsl:variable name="coverpage" select="concat('url(file:',$basepath, 'coverpage1.png', ')')"/> --> <!-- for DEBUG -->
								<fo:external-graphic src="{$coverpage}" width="{$pageWidth}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="getImageURL">
		<xsl:param name="src"/>
		<xsl:choose>
			<xsl:when test="starts-with($src, 'data:image')">
				<xsl:value-of select="$src"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="src_external"><xsl:call-template name="getImageSrcExternal"/></xsl:variable>
				<xsl:value-of select="concat('url(file:///', $src_external, ')')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="getSVG">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'svg']">
				<xsl:apply-templates select="*[local-name() = 'svg']" mode="svg_update"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="svg_content" select="document(@src)"/>
				<xsl:for-each select="xalan:nodeset($svg_content)/node()">
					<xsl:apply-templates select="." mode="svg_update"/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- END: insert cover page image -->

	<!-- https://github.com/metanorma/docs/blob/main/109.adoc -->
	<xsl:variable name="regex_ja_spec_half_width_">
		\u0028  <!-- U+0028 LEFT PARENTHESIS (() -->
		\u0029 <!-- U+0029 RIGHT PARENTHESIS ()) -->
		\u007B <!-- U+007B LEFT CURLY BRACKET ({) -->
		\u007D <!-- U+007D RIGHT CURLY BRACKET (}) -->
		\uFF62 <!-- U+FF62 HALFWIDTH LEFT CORNER BRACKET (｢) -->
		\uFF63 <!-- U+FF63 HALFWIDTH RIGHT CORNER BRACKET (｣) -->
		\u005B <!-- U+005B LEFT SQUARE BRACKET ([) -->
		\u005D <!-- U+005D RIGHT SQUARE BRACKET (]) -->
	</xsl:variable>
	<xsl:variable name="regex_ja_spec_half_width" select="translate(normalize-space($regex_ja_spec_half_width_), ' ', '')"/>
	<xsl:variable name="regex_ja_spec_">[
		<!-- Rotate 90° clockwise -->
		<xsl:value-of select="$regex_ja_spec_half_width"/>
		\uFF08 <!-- U+FF08 FULLWIDTH LEFT PARENTHESIS (（) -->
		\uFF09 <!-- U+FF09 FULLWIDTH RIGHT PARENTHESIS (）) -->
		\uFF5B <!-- U+FF5B FULLWIDTH LEFT CURLY BRACKET (｛) -->
		\uFF5D <!-- U+FF5D FULLWIDTH RIGHT CURLY BRACKET (｝) -->
		\u3014 <!-- U+3014 LEFT TORTOISE SHELL BRACKET (〔) -->
		\u3015 <!-- U+3015 RIGHT TORTOISE SHELL BRACKET (〕) -->
		\u3010 <!-- U+3010 LEFT BLACK LENTICULAR BRACKET (【) -->
		\u3011 <!-- U+3011 RIGHT BLACK LENTICULAR BRACKET (】) -->
		\u300A <!-- U+300A LEFT DOUBLE ANGLE BRACKET (《) -->
		\u300B <!-- U+300B RIGHT DOUBLE ANGLE BRACKET (》) -->
		\u300C <!-- U+300C LEFT CORNER BRACKET (「) -->
		\u300D <!-- U+300D RIGHT CORNER BRACKET (」) -->
		\u300E <!-- U+300E LEFT WHITE CORNER BRACKET (『) -->
		\u300F <!-- U+300F RIGHT WHITE CORNER BRACKET (』) -->
		\uFF3B <!-- U+FF3B FULLWIDTH LEFT SQUARE BRACKET (［) -->
		\uFF3D <!-- U+FF3D FULLWIDTH RIGHT SQUARE BRACKET (］) -->
		\u3008 <!-- U+3008 LEFT ANGLE BRACKET (〈) -->
		\u3009 <!-- U+3009 RIGHT ANGLE BRACKET (〉) -->
		\u3016 <!-- U+3016 LEFT WHITE LENTICULAR BRACKET (〖) -->
		\u3017 <!-- U+3017 RIGHT WHITE LENTICULAR BRACKET (〗) -->
		\u301A <!-- U+301A LEFT WHITE SQUARE BRACKET (〚) -->
		\u301B <!-- U+301B RIGHT WHITE SQUARE BRACKET (〛) -->
		\u301C <!-- U+301C WAVE DASH (〜) -->
		\u3030 <!-- U+3030 WAVY DASH (〰 )-->
		\u30FC <!-- U+30FC KATAKANA-HIRAGANA PROLONGED SOUND MARK (ー) -->
		\u2329 <!-- U+2329 LEFT-POINTING ANGLE BRACKET (〈) -->
		\u232A <!-- U+232A RIGHT-POINTING ANGLE BRACKET (〉) -->
		\u3018 <!-- U+3018 LEFT WHITE TORTOISE SHELL BRACKET (〘) -->
		\u3019 <!-- U+3019 RIGHT WHITE TORTOISE SHELL BRACKET (〙) -->
		\u30A0 <!-- U+30A0 KATAKANA-HIRAGANA DOUBLE HYPHEN (゠) -->
		\uFE59 <!-- U+FE59 SMALL LEFT PARENTHESIS (﹙) -->
		\uFE5A <!-- U+FE5A SMALL RIGHT PARENTHESIS (﹚) -->
		\uFE5B <!-- U+FE5B SMALL LEFT CURLY BRACKET (﹛) -->
		\uFE5C <!-- U+FE5C SMALL RIGHT CURLY BRACKET (﹜) -->
		\uFE5D <!-- U+FE5D SMALL LEFT TORTOISE SHELL BRACKET (﹝) -->
		\uFE5E <!-- U+FE5E SMALL RIGHT TORTOISE SHELL BRACKET (﹞) -->
		\uFF5C <!-- U+FF5C FULLWIDTH VERTICAL LINE (｜) -->
		\uFF5F <!-- U+FF5F FULLWIDTH LEFT WHITE PARENTHESIS (｟) -->
		\uFF60 <!-- U+FF60 FULLWIDTH RIGHT WHITE PARENTHESIS (｠) -->
		\uFFE3 <!-- U+FFE3 FULLWIDTH MACRON (￣) -->
		\uFF3F <!-- U+FF3F FULLWIDTH LOW LINE (＿) -->
		\uFF5E <!-- U+FF5E FULLWIDTH TILDE (～) -->
		<!-- Rotate 180° -->
		\u309C <!-- U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜) -->
		\u3002 <!-- U+3002 IDEOGRAPHIC FULL STOP (。) -->
		\uFE52 <!-- U+FE52 SMALL FULL STOP (﹒) -->
		\uFF0E <!-- U+FF0E FULLWIDTH FULL STOP (．) -->
		]</xsl:variable>
	<xsl:variable name="regex_ja_spec"><xsl:value-of select="translate(normalize-space($regex_ja_spec_), ' ', '')"/></xsl:variable>
	<xsl:template name="insertVerticalChar">
		<xsl:param name="str"/>
		<xsl:param name="char_prev"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<xsl:choose>
			<xsl:when test="ancestor::mn:span[@class = 'norotate']">
				<xsl:value-of select="$str"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string-length($str) &gt; 0">

					<!-- <xsl:variable name="horizontal_mode" select="normalize-space(ancestor::mn:span[@class = 'horizontal'] and 1 = 1)"/> -->
					<xsl:variable name="char" select="substring($str,1,1)"/>
					<xsl:variable name="char_next" select="substring($str,2,1)"/>

					<xsl:variable name="char_half_width" select="normalize-space(java:matches(java:java.lang.String.new($char), concat('([', $regex_ja_spec_half_width, ']{1,})')))"/>

					<xsl:choose>
						<xsl:when test="$char_half_width = 'true'">
							<fo:inline>
								<xsl:attribute name="baseline-shift">7%</xsl:attribute>
								<xsl:value-of select="$char"/>
							</fo:inline>
						</xsl:when>
						<xsl:otherwise>
							<!--  namespace-uri(ancestor::mn:title) != '' to skip title from $contents  -->
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_prev = '' and ../preceding-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
							<fo:inline-container text-align="center" alignment-baseline="central" width="1em" margin="0" padding="0" text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP" text-align-last="center">
								<xsl:if test="normalize-space($writing-mode) != ''">
									<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
									<xsl:attribute name="reference-orientation">90</xsl:attribute>
								</xsl:if>
								<xsl:if test="normalize-space(java:matches(java:java.lang.String.new($char), concat('(', $regex_ja_spec, '{1,})'))) = 'true'">
									<xsl:attribute name="reference-orientation">0</xsl:attribute>
								</xsl:if>
								<xsl:if test="$char = '゜' or $char = '。' or $char = '﹒' or $char = '．'">
									<!-- Rotate 180°: 
										U+309C KATAKANA-HIRAGANA SEMI-VOICED SOUND MARK (゜)
										U+3002 IDEOGRAPHIC FULL STOP (。)
										U+FE52 SMALL FULL STOP (﹒)
										U+FF0E FULLWIDTH FULL STOP (．)
									-->
									<xsl:attribute name="reference-orientation">-90</xsl:attribute>
								</xsl:if>
								<fo:block-container width="1em" role="SKIP"><!-- border="0.5pt solid blue" -->
									<fo:block line-height="1em" role="SKIP">
										<!-- <xsl:choose>
											<xsl:when test="$horizontal_mode = 'true'">
												<xsl:value-of select="$str"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$char"/>
											</xsl:otherwise>
										</xsl:choose> -->
										<xsl:value-of select="$char"/>
									</fo:block>
								</fo:block-container>
							</fo:inline-container>
							<xsl:if test="namespace-uri(ancestor::mn:fmt-title) != '' and ($char_next != '' or ../following-sibling::node())">
								<fo:inline padding-left="1mm"><xsl:value-of select="$zero_width_space"/></fo:inline>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>

					<xsl:if test="$add_zero_width_space = 'true' and ($char = ',' or $char = '.' or $char = ' ' or $char = '·' or $char = ')' or $char = ']' or $char = '}' or $char = '/')"><xsl:value-of select="$zero_width_space"/></xsl:if>
						<!-- <xsl:if test="$horizontal_mode = 'false'"> -->
							<xsl:call-template name="insertVerticalChar">
								<xsl:with-param name="str" select="substring($str, 2)"/>
								<xsl:with-param name="char_prev" select="$char"/>
								<xsl:with-param name="writing-mode" select="$writing-mode"/>
								<xsl:with-param name="reference-orientation" select="$reference-orientation"/>
								<xsl:with-param name="add_zero_width_space" select="$add_zero_width_space"/>
							</xsl:call-template>
						<!-- </xsl:if> -->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertHorizontalChars">
		<xsl:param name="str"/>
		<xsl:param name="writing-mode">lr-tb</xsl:param>
		<xsl:param name="reference-orientation">90</xsl:param>
		<xsl:param name="add_zero_width_space">false</xsl:param>
		<fo:inline-container text-align="center" alignment-baseline="central" width="1em" margin="0" padding="0" text-indent="0mm" last-line-end-indent="0mm" start-indent="0mm" end-indent="0mm" role="SKIP">
			<xsl:if test="normalize-space($writing-mode) != ''">
				<xsl:attribute name="writing-mode"><xsl:value-of select="$writing-mode"/></xsl:attribute>
				<xsl:attribute name="reference-orientation">90</xsl:attribute>
			</xsl:if>
			<fo:block-container width="1em" role="SKIP"> <!-- border="0.5pt solid green" -->
				<fo:block line-height="1em" role="SKIP">
					<xsl:value-of select="$str"/>
				</fo:block>
			</fo:block-container>
		</fo:inline-container>
	</xsl:template>

	<xsl:template name="number-to-words">
		<xsl:param name="number"/>
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
				<words>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'"> <!-- https://en.wiktionary.org/wiki/Appendix:French_numbers -->
							<word cardinal="1">Une-</word>
							<word ordinal="1">Première </word>
							<word cardinal="2">Deux-</word>
							<word ordinal="2">Seconde </word>
							<word cardinal="3">Trois-</word>
							<word ordinal="3">Tierce </word>
							<word cardinal="4">Quatre-</word>
							<word ordinal="4">Quatrième </word>
							<word cardinal="5">Cinq-</word>
							<word ordinal="5">Cinquième </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixième </word>
							<word cardinal="7">Sept-</word>
							<word ordinal="7">Septième </word>
							<word cardinal="8">Huit-</word>
							<word ordinal="8">Huitième </word>
							<word cardinal="9">Neuf-</word>
							<word ordinal="9">Neuvième </word>
							<word ordinal="10">Dixième </word>
							<word ordinal="11">Onzième </word>
							<word ordinal="12">Douzième </word>
							<word ordinal="13">Treizième </word>
							<word ordinal="14">Quatorzième </word>
							<word ordinal="15">Quinzième </word>
							<word ordinal="16">Seizième </word>
							<word ordinal="17">Dix-septième </word>
							<word ordinal="18">Dix-huitième </word>
							<word ordinal="19">Dix-neuvième </word>
							<word cardinal="20">Vingt-</word>
							<word ordinal="20">Vingtième </word>
							<word cardinal="30">Trente-</word>
							<word ordinal="30">Trentième </word>
							<word cardinal="40">Quarante-</word>
							<word ordinal="40">Quarantième </word>
							<word cardinal="50">Cinquante-</word>
							<word ordinal="50">Cinquantième </word>
							<word cardinal="60">Soixante-</word>
							<word ordinal="60">Soixantième </word>
							<word cardinal="70">Septante-</word>
							<word ordinal="70">Septantième </word>
							<word cardinal="80">Huitante-</word>
							<word ordinal="80">Huitantième </word>
							<word cardinal="90">Nonante-</word>
							<word ordinal="90">Nonantième </word>
							<word cardinal="100">Cent-</word>
							<word ordinal="100">Centième </word>
						</xsl:when>
						<xsl:when test="$lang = 'ru'">
							<word cardinal="1">Одна-</word>
							<word ordinal="1">Первое </word>
							<word cardinal="2">Две-</word>
							<word ordinal="2">Второе </word>
							<word cardinal="3">Три-</word>
							<word ordinal="3">Третье </word>
							<word cardinal="4">Четыре-</word>
							<word ordinal="4">Четвертое </word>
							<word cardinal="5">Пять-</word>
							<word ordinal="5">Пятое </word>
							<word cardinal="6">Шесть-</word>
							<word ordinal="6">Шестое </word>
							<word cardinal="7">Семь-</word>
							<word ordinal="7">Седьмое </word>
							<word cardinal="8">Восемь-</word>
							<word ordinal="8">Восьмое </word>
							<word cardinal="9">Девять-</word>
							<word ordinal="9">Девятое </word>
							<word ordinal="10">Десятое </word>
							<word ordinal="11">Одиннадцатое </word>
							<word ordinal="12">Двенадцатое </word>
							<word ordinal="13">Тринадцатое </word>
							<word ordinal="14">Четырнадцатое </word>
							<word ordinal="15">Пятнадцатое </word>
							<word ordinal="16">Шестнадцатое </word>
							<word ordinal="17">Семнадцатое </word>
							<word ordinal="18">Восемнадцатое </word>
							<word ordinal="19">Девятнадцатое </word>
							<word cardinal="20">Двадцать-</word>
							<word ordinal="20">Двадцатое </word>
							<word cardinal="30">Тридцать-</word>
							<word ordinal="30">Тридцатое </word>
							<word cardinal="40">Сорок-</word>
							<word ordinal="40">Сороковое </word>
							<word cardinal="50">Пятьдесят-</word>
							<word ordinal="50">Пятидесятое </word>
							<word cardinal="60">Шестьдесят-</word>
							<word ordinal="60">Шестидесятое </word>
							<word cardinal="70">Семьдесят-</word>
							<word ordinal="70">Семидесятое </word>
							<word cardinal="80">Восемьдесят-</word>
							<word ordinal="80">Восьмидесятое </word>
							<word cardinal="90">Девяносто-</word>
							<word ordinal="90">Девяностое </word>
							<word cardinal="100">Сто-</word>
							<word ordinal="100">Сотое </word>
						</xsl:when>
						<xsl:otherwise> <!-- default english -->
							<word cardinal="1">One-</word>
							<word ordinal="1">First </word>
							<word cardinal="2">Two-</word>
							<word ordinal="2">Second </word>
							<word cardinal="3">Three-</word>
							<word ordinal="3">Third </word>
							<word cardinal="4">Four-</word>
							<word ordinal="4">Fourth </word>
							<word cardinal="5">Five-</word>
							<word ordinal="5">Fifth </word>
							<word cardinal="6">Six-</word>
							<word ordinal="6">Sixth </word>
							<word cardinal="7">Seven-</word>
							<word ordinal="7">Seventh </word>
							<word cardinal="8">Eight-</word>
							<word ordinal="8">Eighth </word>
							<word cardinal="9">Nine-</word>
							<word ordinal="9">Ninth </word>
							<word ordinal="10">Tenth </word>
							<word ordinal="11">Eleventh </word>
							<word ordinal="12">Twelfth </word>
							<word ordinal="13">Thirteenth </word>
							<word ordinal="14">Fourteenth </word>
							<word ordinal="15">Fifteenth </word>
							<word ordinal="16">Sixteenth </word>
							<word ordinal="17">Seventeenth </word>
							<word ordinal="18">Eighteenth </word>
							<word ordinal="19">Nineteenth </word>
							<word cardinal="20">Twenty-</word>
							<word ordinal="20">Twentieth </word>
							<word cardinal="30">Thirty-</word>
							<word ordinal="30">Thirtieth </word>
							<word cardinal="40">Forty-</word>
							<word ordinal="40">Fortieth </word>
							<word cardinal="50">Fifty-</word>
							<word ordinal="50">Fiftieth </word>
							<word cardinal="60">Sixty-</word>
							<word ordinal="60">Sixtieth </word>
							<word cardinal="70">Seventy-</word>
							<word ordinal="70">Seventieth </word>
							<word cardinal="80">Eighty-</word>
							<word ordinal="80">Eightieth </word>
							<word cardinal="90">Ninety-</word>
							<word ordinal="90">Ninetieth </word>
							<word cardinal="100">Hundred-</word>
							<word ordinal="100">Hundredth </word>
						</xsl:otherwise>
					</xsl:choose>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>

			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:variable name="value_lc" select="java:toLowerCase(java:java.lang.String.new($value))"/>
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="$value_lc"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template> <!-- number-to-words -->

	<!-- st for 1, nd for 2, rd for 3, th for 4, 5, 6, ... -->
	<xsl:template name="number-to-ordinal">
		<xsl:param name="number"/>
		<xsl:param name="curr_lang"/>
		<xsl:choose>
			<xsl:when test="$curr_lang = 'fr'">
				<xsl:choose>
					<xsl:when test="$number = '1'">re</xsl:when>
					<xsl:otherwise>e</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$number = 1">st</xsl:when>
					<xsl:when test="$number = 2">nd</xsl:when>
					<xsl:when test="$number = 3">rd</xsl:when>
					<xsl:otherwise>th</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- number-to-ordinal -->

	<!-- add the attribute fox:alt-text, required for PDF/UA -->
	<xsl:template name="setAltText">
		<xsl:param name="value"/>
		<xsl:attribute name="fox:alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space($value) != ''">
					<xsl:value-of select="$value"/>
				</xsl:when>
				<xsl:otherwise>_</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>

	<xsl:template name="substring-after-last">
		<xsl:param name="value"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="contains($value, $delimiter)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="value" select="substring-after($value, $delimiter)"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================= -->
	<!--  mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->
	<xsl:template match="*" mode="print_as_xml">
		<xsl:param name="level">0</xsl:param>

		<fo:block margin-left="{2*$level}mm">
			<xsl:text>
&lt;</xsl:text>
			<xsl:value-of select="local-name()"/>
			<xsl:for-each select="@*">
				<xsl:text> </xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>="</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text>"</xsl:text>
			</xsl:for-each>
			<xsl:text>&gt;</xsl:text>

			<xsl:if test="not(*)">
				<fo:inline font-weight="bold"><xsl:value-of select="."/></fo:inline>
				<xsl:text>&lt;/</xsl:text>
					<xsl:value-of select="local-name()"/>
					<xsl:text>&gt;</xsl:text>
			</xsl:if>
		</fo:block>

		<xsl:if test="*">
			<fo:block>
				<xsl:apply-templates mode="print_as_xml">
					<xsl:with-param name="level" select="$level + 1"/>
				</xsl:apply-templates>
			</fo:block>
			<fo:block margin-left="{2*$level}mm">
				<xsl:text>&lt;/</xsl:text>
				<xsl:value-of select="local-name()"/>
				<xsl:text>&gt;</xsl:text>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- ============================================= -->
	<!-- END: mode="print_as_xml", for debug purposes -->
	<!-- ============================================= -->

	<!-- ============================================= -->
	<!-- mode="set_table_role_skip" -->
	<!-- ============================================= -->
	<xsl:template match="@*|node()" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[starts-with(local-name(), 'table')]" mode="set_table_role_skip">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="set_table_role_skip"/>
			<xsl:attribute name="role">SKIP</xsl:attribute>
			<xsl:apply-templates select="node()" mode="set_table_role_skip"/>
		</xsl:copy>
	</xsl:template>
	<!-- ============================================= -->
	<!-- END: mode="set_table_role_skip" -->
	<!-- ============================================= -->

</xsl:stylesheet>