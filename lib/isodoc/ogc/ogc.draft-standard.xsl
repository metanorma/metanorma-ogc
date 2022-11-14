<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:ogc="https://www.metanorma.org/ns/ogc" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>

	<xsl:key name="kfn" match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])]" use="@reference"/>

	<xsl:variable name="debug">false</xsl:variable>

	<xsl:variable name="docnumber" select="java:toUpperCase(java:java.lang.String.new(/ogc:ogc-standard/ogc:bibdata/ogc:docnumber))"/>
	<xsl:variable name="doctitle" select="/ogc:ogc-standard/ogc:bibdata/ogc:title[@language = 'en']"/>

	<xsl:variable name="docLatestDate_">
		<xsl:for-each select="/*/ogc:bibdata/ogc:date[normalize-space(ogc:on) != '']">
			<xsl:sort order="descending" select="ogc:on"/>
			<xsl:if test="position() = 1"><xsl:value-of select="translate(ogc:on, '-', '')"/></xsl:if>
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

	<xsl:variable name="doctype">
		<xsl:call-template name="capitalizeWords">
			<xsl:with-param name="str" select="/ogc:ogc-standard/ogc:bibdata/ogc:ext/ogc:doctype"/>
		</xsl:call-template>
	</xsl:variable>

	<xsl:variable name="copyright-owner" select="java:toUpperCase(java:java.lang.String.new(/ogc:ogc-standard/ogc:bibdata/ogc:copyright/ogc:owner/ogc:organization/ogc:name))"/>

	<xsl:variable name="color_main">rgb(88, 89, 91)</xsl:variable>
	<xsl:variable name="color_design">
		<xsl:choose>
			<xsl:when test="$selectedStyle = '2'">rgb(0, 177, 255)</xsl:when>
			<xsl:otherwise>rgb(237, 193, 35)</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="color_design_light">
		<xsl:choose>
			<xsl:when test="$selectedStyle = '2'">rgb(0, 177, 255)</xsl:when>
			<xsl:otherwise>rgb(246, 223, 140)</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="color_blue">rgb(33, 55, 92)</xsl:variable>

	<xsl:variable name="toc_recommendations_">
		<xsl:for-each select="//ogc:table[.//ogc:p[@class = 'RecommendationTitle']]">
			<xsl:variable name="table_id" select="@id"/>
			<recommendation alt-text="{.//ogc:p[@class = 'RecommendationTitle'][1]/text()}">
				<xsl:copy-of select="@id"/>
				<xsl:variable name="title">
					<xsl:apply-templates select=".//ogc:p[@class = 'RecommendationTitle'][ancestor::ogc:table[1][@id= $table_id]]/node()"/>
					<xsl:if test=".//ogc:p[@class = 'RecommendationLabel'][ancestor::ogc:table[1][@id= $table_id]]/node()">
						<xsl:text>: </xsl:text>
						<xsl:variable name="recommendationLabel">
							<tt><xsl:copy-of select=".//ogc:p[@class = 'RecommendationLabel'][ancestor::ogc:table[1][@id= $table_id]]/node()"/></tt>
						</xsl:variable>
						<xsl:apply-templates select="xalan:nodeset($recommendationLabel)/node()"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="bookmark">
					<xsl:value-of select="normalize-space(.//ogc:p[@class = 'RecommendationTitle'][ancestor::ogc:table[1][@id= $table_id]]/node())"/>
					<xsl:if test=".//ogc:p[@class = 'RecommendationLabel'][ancestor::ogc:table[1][@id= $table_id]]/node()">
						<xsl:text>: </xsl:text>
						<xsl:value-of select="normalize-space(.//ogc:p[@class = 'RecommendationLabel'][ancestor::ogc:table[1][@id= $table_id]]/node())"/>
					</xsl:if>
				</xsl:variable>
				<xsl:variable name="regex_str" select="'^([^0-9]+) (\d+).*'"/>
				<xsl:variable name="class" select="java:replaceAll(java:java.lang.String.new($bookmark), $regex_str, '$1')"/>
				<xsl:variable name="num" select="java:replaceAll(java:java.lang.String.new($bookmark), $regex_str, '$2')"/>
				<xsl:variable name="class_lc" select="java:toLowerCase(java:java.lang.String.new($class))"/>
				<!-- <xsl:attribute name="class_str">
					<xsl:value-of select="$class"/>
				</xsl:attribute> -->
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="$class_lc = 'requirements class'">1</xsl:when>
						<xsl:when test="$class_lc = 'requirement'">2</xsl:when>
						<xsl:when test="$class_lc = 'recommendation'">3</xsl:when>
						<xsl:when test="$class_lc = 'permission'">4</xsl:when>
						<xsl:when test="$class_lc = 'conformance class'">5</xsl:when>
						<xsl:when test="$class_lc = 'abstract test'">6</xsl:when>
						<xsl:when test="$class_lc = 'requirement test'">7</xsl:when>
						<xsl:when test="$class_lc = 'recommendation test'">8</xsl:when>
						<xsl:when test="$class_lc = 'permission test'">9</xsl:when>
						<xsl:otherwise>9999</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:attribute name="num">
					<xsl:value-of select="$num"/>
				</xsl:attribute>
				<title>
					<xsl:copy-of select="$title"/>
				</title>
				<bookmark>
					<xsl:value-of select="$bookmark"/>
				</bookmark>
			</recommendation>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="toc_recommendations">
		<xsl:for-each select="xalan:nodeset($toc_recommendations_)/*">
			<xsl:sort select="@class" data-type="number"/>
			<xsl:sort select="@num" data-type="number"/>
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="contents_">
		<contents>
			<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>

			<xsl:call-template name="processMainSectionsDefault_Contents"/>
			<xsl:apply-templates select="//ogc:indexsect" mode="contents"/>

			<xsl:call-template name="processTablesFigures_Contents">
				<xsl:with-param name="always">true</xsl:with-param>
			</xsl:call-template>
		</contents>
	</xsl:variable>
	<xsl:variable name="contents" select="xalan:nodeset($contents_)"/>

	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root xml:lang="{$lang}">
			<xsl:variable name="root-style">
				<root-style xsl:use-attribute-sets="root-style"/>
			</xsl:variable>
			<xsl:call-template name="insertRootStyle">
				<xsl:with-param name="root-style" select="$root-style"/>
			</xsl:call-template>
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="16.5mm" margin-bottom="10mm" margin-left="16.5mm" margin-right="14mm"/>
					<fo:region-before region-name="cover-page-header" extent="16.5mm"/>
					<fo:region-after extent="10mm"/>
					<fo:region-start extent="16.5mm"/>
					<fo:region-end extent="14mm"/>
				</fo:simple-page-master>

				<!-- Preface pages -->
				<fo:simple-page-master master-name="preface" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="16.5mm" margin-bottom="22.5mm" margin-left="16.5mm" margin-right="16.5mm"/>
					<fo:region-before region-name="header" extent="16.5mm"/>
					<fo:region-after region-name="footer" extent="22.5mm"/>
					<fo:region-start region-name="left-region" extent="16.5mm"/>
					<fo:region-end region-name="right-region" extent="16.5mm"/>
				</fo:simple-page-master>

				<!-- Document pages -->
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm"/>
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="16.5mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>

			</fo:layout-master-set>

			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>

			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>

			<!-- Cover Page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>

				<fo:flow flow-name="xsl-region-body" color="white">

					<!-- background image -->
					<fo:block-container absolute-position="fixed" left="0mm" top="0mm" font-size="0">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Cover-Background))}" width="{$pageWidth}mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Front"/>
						</fo:block>
					</fo:block-container>

					<!-- background color -->
					<fo:block-container absolute-position="fixed" left="0" top="0" font-size="0">
            <fo:block>
              <fo:instream-foreign-object content-height="{$pageHeight}mm" fox:alt-text="Background color">
                <svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="{$pageWidth}mm" height="{$pageHeight}mm">
                  <rect width="{$pageWidth}mm" height="{$pageHeight}mm" style="fill:rgb(33,55,92);stroke-width:0;fill-opacity:0.85"/>
                </svg>
              </fo:instream-foreign-object>
            </fo:block>
          </fo:block-container>

					<xsl:call-template name="insertCrossingLines"/>

					<!-- title and logo -->
					<fo:block>
						<fo:table table-layout="fixed" width="100%">
							<fo:table-column column-width="75%"/>
							<fo:table-column column-width="25%"/>
							<fo:table-body>
								<fo:table-row>
									<fo:table-cell font-weight="bold">
										<fo:block font-size="16pt" color="{$color_design}" margin-bottom="4pt">
											<xsl:variable name="ogc_document" select="concat('OGC® DOCUMENT: ', $docnumber)"/>
											<xsl:call-template name="addLetterSpacing">
												<xsl:with-param name="text" select="$ogc_document"/>
												<xsl:with-param name="letter-spacing" select="0.3"/>
											</xsl:call-template>
										</fo:block>
										<xsl:variable name="ogc_external" select="/ogc:ogc-standard/ogc:bibdata/ogc:docidentifier[@type='ogc-external']"/>
										<xsl:if test="normalize-space($ogc_external) != ''">
											<fo:block font-size="10pt">External identifier of this OGC<fo:inline font-size="58%" baseline-shift="30%">®</fo:inline>  document: <fo:inline font-weight="normal"><xsl:value-of select="$ogc_external"/></fo:inline></fo:block>
										</xsl:if>
									</fo:table-cell>
									<fo:table-cell text-align="right">
										<fo:block>
											<xsl:call-template name="insertLogo"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-body>
						</fo:table>
					</fo:block>

					<!-- <fo:block-container absolute-position="fixed" left="16.5mm" top="83mm" height="90mm"> -->
					<fo:block-container absolute-position="fixed" left="16.5mm" top="40mm" height="170mm">
						<fo:block-container width="155mm" height="99%" display-align="center">
							<fo:block font-size="33pt" role="H1">
								<xsl:variable name="length_title" select="string-length($doctitle)"/>
								<xsl:variable name="fit_font-size">
									<xsl:choose>
										<xsl:when test="$length_title &gt; 230">20</xsl:when>
										<xsl:when test="$length_title &gt; 170">26</xsl:when>
										<xsl:when test="$length_title &gt; 155">28</xsl:when>
										<xsl:when test="$length_title &gt; 130">30</xsl:when>
									</xsl:choose>
								</xsl:variable>
								<xsl:if test="normalize-space($fit_font-size) != ''">
									<xsl:attribute name="font-size"><xsl:value-of select="$fit_font-size"/>pt</xsl:attribute>
								</xsl:if>
								<xsl:call-template name="addLetterSpacing">
									<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new($doctitle))"/>
									<xsl:with-param name="letter-spacing" select="1.1"/>
								</xsl:call-template>
							</fo:block>
							<fo:block-container width="22.5mm" border-bottom="2pt solid {$color_design}" margin-bottom="24pt">
								<fo:block margin-top="4pt"> </fo:block>
							</fo:block-container>
							<fo:block color="{$color_design}">
								<fo:block font-size="17pt" margin-bottom="14pt">
									<xsl:call-template name="addLetterSpacing">
										<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new($doctype))"/>
									</xsl:call-template>
									<xsl:value-of select="$linebreak"/>
									<xsl:variable name="docsubtype" select="normalize-space(/ogc:ogc-standard/ogc:bibdata/ogc:ext/ogc:subdoctype)"/>
									<xsl:variable name="docsubtype_str">
										<xsl:choose>
											<xsl:when test="$docsubtype = 'implementation'">Implementation</xsl:when>
											<xsl:when test="$docsubtype = 'conceptual-model'">Conceptual model</xsl:when>
											<xsl:when test="$docsubtype = 'conceptual-model-and-encoding'">Conceptual model &amp; encoding</xsl:when>
											<xsl:when test="$docsubtype = 'conceptual-model-and-implementation'">Conceptual model &amp; implementation</xsl:when>
											<xsl:when test="$docsubtype = 'encoding'">Encoding</xsl:when>
											<xsl:when test="$docsubtype = 'extension'">Extension</xsl:when>
											<xsl:when test="$docsubtype = 'profile'">Profile</xsl:when>
											<xsl:when test="$docsubtype = 'profile-with-extension'">Profile with extension</xsl:when>
											<xsl:when test="$docsubtype = 'general'">General</xsl:when>
										</xsl:choose>
									</xsl:variable>
									<xsl:call-template name="addLetterSpacing">
										<xsl:with-param name="text" select="$docsubtype_str"/>
										<xsl:with-param name="letter-spacing" select="0.25"/>
									</xsl:call-template>
								</fo:block>
								<fo:block font-size="12pt" font-weight="bold">
									<xsl:variable name="curr_lang" select="/ogc:ogc-standard/ogc:bibdata/ogc:language[@current = 'true']"/>
									<xsl:variable name="stage" select="java:toUpperCase(java:java.lang.String.new(/ogc:ogc-standard/ogc:bibdata/ogc:status/ogc:stage[@language = $curr_lang]))"/>
									<xsl:call-template name="addLetterSpacing">
										<xsl:with-param name="text" select="$stage"/>
									</xsl:call-template>
								</fo:block>
							</fo:block>
						</fo:block-container>
					</fo:block-container>

					<fo:block-container absolute-position="fixed" left="16.5mm" top="204mm" height="60mm" width="180mm" display-align="after" font-size="10pt">
						<fo:block line-height="140%">
							<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:edition[normalize-space(@language) = '']"/>
							<fo:block>
								<fo:inline font-weight="bold">Submission Date: </fo:inline>
								<xsl:choose>
									<xsl:when test="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'received']/ogc:on">
										<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'received']/ogc:on"/>
									</xsl:when>
									<xsl:otherwise>XXX</xsl:otherwise>
								</xsl:choose>
							</fo:block>
							<fo:block>
								<fo:inline font-weight="bold">Approval Date: </fo:inline>
								<xsl:choose>
									<xsl:when test="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'issued']/ogc:on">
										<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'issued']/ogc:on"/>
									</xsl:when>
									<xsl:otherwise>XXX</xsl:otherwise>
								</xsl:choose>
							</fo:block>
							<fo:block>
								<fo:inline font-weight="bold">Publication Date: </fo:inline>
								<xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'published']/ogc:on"/>
							</fo:block>

							<fo:block margin-bottom="12pt">
								<xsl:if test="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author']/ogc:person/ogc:name/ogc:completename">
									<fo:block>
										<fo:inline font-weight="bold">Author: </fo:inline>
										<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='author']/ogc:person/ogc:name/ogc:completename">
											<xsl:value-of select="."/>
											<xsl:if test="position() != last()">, </xsl:if>
										</xsl:for-each>
									</fo:block>
								</xsl:if>
								<xsl:if test="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='editor']/ogc:person/ogc:name/ogc:completename">
									<fo:block>
										<fo:inline font-weight="bold">Editor: </fo:inline>
										<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='editor']/ogc:person/ogc:name/ogc:completename">
											<xsl:value-of select="."/>
											<xsl:if test="position() != last()">, </xsl:if>
										</xsl:for-each>
									</fo:block>
								</xsl:if>
								<xsl:if test="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='contributor']/ogc:person/ogc:name/ogc:completename">
									<fo:block>
										<fo:inline font-weight="bold">Contributor: </fo:inline>
										<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='contributor']/ogc:person/ogc:name/ogc:completename">
											<xsl:value-of select="."/>
											<xsl:if test="position() != last()">, </xsl:if>
										</xsl:for-each>
									</fo:block>
								</xsl:if>
							</fo:block>
						</fo:block>

						<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:legal-statement"/>

					</fo:block-container>

				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->

			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="preface" initial-page-number="2" format="i" force-page-count="no-force">
				<xsl:call-template name="insertFootnoteSeparator"/>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">

					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<!-- <xsl:copy-of select="xalan:nodeset($contents)"/> -->
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>

					<!-- crossing lines -->
					<fo:block-container absolute-position="fixed" width="{$pageWidth}mm" height="{$pageHeight}mm" font-size="0">
						<fo:block>
							<fo:instream-foreign-object content-height="{$pageHeight}mm" content-width="{$pageWidth}mm" fox:alt-text="Crossing lines">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2159 2794" width="{$pageWidth}mm" height="{$pageHeight}mm">
									<line x1="230" y1="0" x2="2159" y2="490" stroke="{$color_design_light}"/>
									<line x1="0" y1="395" x2="820" y2="0" stroke="{$color_design_light}"/>
									<circle style="fill:{$color_design_light};" cx="614" cy="100" r="15"/>
								</svg>
							</fo:instream-foreign-object>
						</fo:block>
					</fo:block-container>

					<xsl:call-template name="insertLogoPreface"/>

					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:license-statement"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:feedback-statement"/>

					<!-- Copyright notice -->
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:copyright-statement"/>

				</fo:flow>
			</fo:page-sequence>

			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="document" format="i" force-page-count="no-force">
				<xsl:call-template name="insertFootnoteSeparator"/>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">

					<!-- crossing lines -->
					<fo:block-container absolute-position="fixed" width="{$pageWidth}mm" height="{$pageHeight}mm" font-size="0">
						<fo:block>
							<fo:instream-foreign-object content-height="{$pageHeight}mm" content-width="{$pageWidth}mm" fox:alt-text="Crossing lines">
								<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2159 2794" width="{$pageWidth}mm" height="{$pageHeight}mm">
									<line x1="0" y1="545" x2="2084" y2="0" stroke="{$color_design_light}"/>
									<line x1="0" y1="1374" x2="355" y2="0" stroke="{$color_design_light}"/>
									<circle style="fill:{$color_design_light};" cx="227" cy="487" r="15"/>
								</svg>
							</fo:instream-foreign-object>
						</fo:block>
					</fo:block-container>

					<fo:block color="{$color_blue}">

						<xsl:variable name="title-toc">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-toc'"/>
							</xsl:call-template>
						</xsl:variable>

						<fo:block-container margin-left="-18mm">
							<fo:block-container margin-left="0mm">
								<fo:block margin-bottom="40pt">
									<fo:block font-size="33pt" margin-bottom="4pt" role="H1">
										<xsl:call-template name="addLetterSpacing">
											<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new($title-toc))"/>
											<xsl:with-param name="letter-spacing" select="1.1"/>
										</xsl:call-template>
									</fo:block>
									<fo:block-container width="22.5mm" border-bottom="2pt solid {$color_design}">
										<fo:block margin-top="4pt"> </fo:block>
									</fo:block-container>
								</fo:block>
							</fo:block-container>
						</fo:block-container>

						<fo:block-container line-height="130%">
							<fo:block role="TOC">
								<xsl:for-each select="$contents//item[@display = 'true' and normalize-space(@id) != '']">

									<fo:block role="TOCI">
										<xsl:if test="@level = 1">
											<xsl:attribute name="margin-top">14pt</xsl:attribute>
										</xsl:if>
										<xsl:if test="@level = 1 or @parent = 'annex'">
											<xsl:attribute name="font-size">12pt</xsl:attribute>
										</xsl:if>
										<xsl:if test="@level &gt;= 2"> <!-- and not(@parent = 'annex') -->
											<xsl:attribute name="font-size">10pt</xsl:attribute>
										</xsl:if>

										<xsl:choose>
											<xsl:when test="@level = 1">
												<fo:list-block provisional-distance-between-starts="8mm">
													<xsl:if test="@type = 'annex'">
														<xsl:attribute name="provisional-distance-between-starts">0mm</xsl:attribute>
													</xsl:if>
													<fo:list-item>
														<fo:list-item-label end-indent="label-end()">
															<fo:block>
																<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@section))"/>
															</fo:block>
														</fo:list-item-label>
														<fo:list-item-body start-indent="body-start()">
															<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
																<fo:basic-link internal-destination="{@id}">
																	<xsl:call-template name="setAltText">
																		<xsl:with-param name="value" select="text()"/>
																	</xsl:call-template>
																	<xsl:variable name="sectionTitle">
																		<xsl:apply-templates select="title"/>
																	</xsl:variable>
																	<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($sectionTitle))"/>
																	<xsl:text> </xsl:text>
																	<fo:inline keep-together.within-line="always">
																		<fo:leader leader-pattern="dots"/>
																		<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
																	</fo:inline>
																</fo:basic-link>
															</fo:block>
														</fo:list-item-body>
													</fo:list-item>
												</fo:list-block>
											</xsl:when>
											<xsl:otherwise>
												<xsl:variable name="margin-left">
													<xsl:choose>
														<xsl:when test="number(@level) != 'NaN'"><xsl:value-of select="(@level - 1) * 8"/></xsl:when>
														<xsl:otherwise>8</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<fo:block text-align-last="justify" margin-left="{$margin-left}mm">
													<fo:basic-link internal-destination="{@id}">
														<xsl:call-template name="setAltText">
															<xsl:with-param name="value" select="text()"/>
														</xsl:call-template>
														<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@section))"/>
														<xsl:text> </xsl:text>
														<xsl:apply-templates select="title"/>
														<xsl:text> </xsl:text>
														<fo:inline keep-together.within-line="always">
															<fo:leader leader-pattern="dots"/>
															<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
														</fo:inline>
													</fo:basic-link>
												</fo:block>
											</xsl:otherwise>
										</xsl:choose>

									</fo:block>
								</xsl:for-each>
							</fo:block>
						</fo:block-container>

						<!-- List of Tables -->
						<xsl:if test="$contents//tables/table">
							<xsl:call-template name="insertListOf_Title">
								<xsl:with-param name="title" select="$title-list-tables"/>
							</xsl:call-template>
							<fo:block-container line-height="130%">
								<xsl:for-each select="$contents//tables/table">
									<xsl:call-template name="insertListOf_Item"/>
								</xsl:for-each>
							</fo:block-container>
						</xsl:if>

						<!-- List of Figures -->
						<xsl:if test="$contents//figures/figure">
							<xsl:call-template name="insertListOf_Title">
								<xsl:with-param name="title" select="$title-list-figures"/>
							</xsl:call-template>
							<fo:block-container line-height="130%">
								<xsl:for-each select="$contents//figures/figure">
									<xsl:call-template name="insertListOf_Item"/>
								</xsl:for-each>
							</fo:block-container>
						</xsl:if>

						<!-- List of Recommendations -->
						<xsl:if test="//ogc:table[.//ogc:p[@class = 'RecommendationTitle']]">
							<xsl:call-template name="insertListOf_Title">
								<xsl:with-param name="title" select="$title-list-recommendations"/>
							</xsl:call-template>
							<fo:block-container line-height="130%">
								<xsl:for-each select="xalan:nodeset($toc_recommendations)/*[normalize-space(@id) != '']">
									<fo:block text-align-last="justify" margin-top="6pt" role="TOCI">
										<fo:basic-link internal-destination="{@id}">
											<xsl:call-template name="setAltText">
												<xsl:with-param name="value" select="@alt-text"/>
											</xsl:call-template>
											<xsl:copy-of select="title/node()"/>
											<xsl:text> </xsl:text>
											<fo:inline keep-together.within-line="always">
												<fo:leader leader-pattern="dots"/>
												<fo:page-number-citation ref-id="{@id}"/>
											</fo:inline>
										</fo:basic-link>
									</fo:block>
								</xsl:for-each>
							</fo:block-container>
						</xsl:if>

					</fo:block>

					<fo:block break-after="page"/>

					<fo:block line-height="125%">
						<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->

						<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
							<xsl:sort select="@displayorder" data-type="number"/>

							<xsl:if test="local-name() = 'foreword' or         (local-name() = 'clause' and @type = 'security') or        (local-name() = 'clause' and @type = 'submitting_orgs') or         local-name() = 'introduction'">
								<fo:block break-after="page"/>
							</xsl:if>

							<xsl:apply-templates select="."/>
						</xsl:for-each>

					</fo:block>
				</fo:flow>
			</fo:page-sequence>

			<!-- Document Pages -->
			<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:choose>
					<xsl:when test="local-name() = 'clause' and @type='scope'">
						<xsl:apply-templates select="." mode="sections">
							<xsl:with-param name="initial-page-number" select="1"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="." mode="sections"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

			<xsl:for-each select="/*/*[local-name()='annex']">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="sections"/>
			</xsl:for-each>

			<!-- Bibliography -->
			<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] |          /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="sections"/>
			</xsl:for-each>

			<xsl:apply-templates select="//ogc:indexsect" mode="sections"/>

			<!-- End Document Pages -->

		</fo:root>
	</xsl:template>

	<xsl:template name="insertListOf_Title">
		<xsl:param name="title"/>
		<fo:block-container margin-left="-18mm" keep-with-next="always" margin-bottom="10pt" space-before="36pt">
			<fo:block-container margin-left="0mm">
				<xsl:call-template name="insertSectionTitle">
					<xsl:with-param name="title" select="$title"/>
				</xsl:call-template>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="insertListOf_Item">
		<fo:block text-align-last="justify" margin-top="2pt" role="TOCI">
			<fo:basic-link internal-destination="{@id}">
				<xsl:call-template name="setAltText">
					<xsl:with-param name="value" select="@alt-text"/>
				</xsl:call-template>
				<!-- <xsl:copy-of select="node()"/> -->
				<xsl:apply-templates select="." mode="contents"/>
				<fo:inline keep-together.within-line="always">
					<fo:leader leader-pattern="dots"/>
					<fo:page-number-citation ref-id="{@id}"/>
				</fo:inline>
			</fo:basic-link>
		</fo:block>
	</xsl:template>

	<!-- Lato font doesn't contain 'thin space' glyph -->
	<xsl:template match="text()" priority="1">
		<xsl:value-of select="translate(., $thin_space, ' ')"/>
	</xsl:template>

	<xsl:template match="ogc:title//text() | ogc:name//text()" priority="3" mode="contents">
		<xsl:value-of select="translate(., $thin_space, ' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text()" priority="2">
		<xsl:variable name="content">
			<xsl:call-template name="add-zero-spaces"/>
		</xsl:variable>
		<!-- add zero-width space in the words like 'adeOfAbstractTransportaonSpace' to split it in the table's cell -->
		<xsl:variable name="content2" select="java:replaceAll(java:java.lang.String.new($content),'([a-z]{2,})([A-Z])(.?)','$1​$2$3')"/>
		<xsl:value-of select="translate($content2, $thin_space, ' ')"/>
	</xsl:template>

	<xsl:template match="node()" mode="sections">
		<xsl:param name="initial-page-number"/>
		<fo:page-sequence master-reference="document" force-page-count="no-force" color="white">
			<xsl:if test="$initial-page-number != ''">
				<xsl:attribute name="initial-page-number">1</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="insertHeaderFooter">
				<xsl:with-param name="color">white</xsl:with-param>
			</xsl:call-template>
			<fo:flow flow-name="xsl-region-body">
				<!-- background color -->
				<fo:block-container absolute-position="fixed" left="0" top="0" font-size="0">
					<fo:block>
						<fo:instream-foreign-object content-height="{$pageHeight}mm" fox:alt-text="Background color">
							<svg xmlns="http://www.w3.org/2000/svg" version="1.0" width="{$pageWidth}mm" height="{$pageHeight}mm">
								<rect width="{$pageWidth}mm" height="{$pageHeight}mm" style="fill:rgb(33,55,92);stroke-width:0;fill-opacity:1"/>
							</svg>
						</fo:instream-foreign-object>
					</fo:block>
				</fo:block-container>

				<xsl:call-template name="insertCrossingLines"/>

				<xsl:variable name="sectionName">
					<xsl:call-template name="getName"/>
				</xsl:variable>

				<fo:block-container absolute-position="fixed" left="16.5mm" top="107mm" width="178mm">
					<xsl:call-template name="insertSectionNumInCircle"/>

					<fo:block margin-top="14pt">
						<xsl:call-template name="insertSectionTitleBig">
							<xsl:with-param name="title" select="$sectionName"/>
						</xsl:call-template>
					</fo:block>

				</fo:block-container>

			</fo:flow>
		</fo:page-sequence>

		<fo:page-sequence master-reference="document" format="1" force-page-count="no-force">
			<xsl:call-template name="insertFootnoteSeparator"/>
			<xsl:call-template name="insertHeaderFooter"/>
			<fo:flow flow-name="xsl-region-body">

				<fo:block line-height="125%">
					<xsl:apply-templates select="."/>

				</fo:block>
			</fo:flow>
		</fo:page-sequence>

	</xsl:template>

	<xsl:template match="node()">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->

	<!-- element with title -->
	<xsl:template match="*[ogc:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="ogc:title/@depth"/>
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
				<xsl:when test="ancestor-or-self::ogc:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::ogc:term">true</xsl:when>
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

			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" display="{$display}">
				<xsl:if test="ancestor::ogc:annex">
					<xsl:attribute name="parent">annex</xsl:attribute>
				</xsl:if>
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates mode="contents"/>
			</item>
		</xsl:if>

	</xsl:template>

	<!-- ============================= -->
	<!-- ============================= -->

	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:uri[not(@type)]">
		<fo:block margin-bottom="12pt">
			<xsl:text>URL for this OGC® document: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>

	<xsl:template match="/ogc:ogc-standard/ogc:bibdata/ogc:edition">
		<fo:block>
			<xsl:variable name="title-version">
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str">
						<xsl:call-template name="getLocalizedString">
							<xsl:with-param name="key">version</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>
			<fo:inline font-weight="bold"><xsl:value-of select="$title-version"/><xsl:text>: </xsl:text></fo:inline>
			<xsl:value-of select="."/><xsl:text/>
		</fo:block>
	</xsl:template>

	<xsl:template match="ogc:legal-statement//ogc:title" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<!-- inline title -->
		<fo:inline font-weight="bold" role="H{$level}">
			<xsl:apply-templates/><xsl:text>: </xsl:text>
		</fo:inline>
	</xsl:template>

	<xsl:template match="ogc:legal-statement//ogc:title/text() | ogc:license-statement//ogc:title/text() | ogc:copyright-statement//ogc:title/text()">
		<xsl:call-template name="addLetterSpacing">
			<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new(.))"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ogc:legal-statement//ogc:p" priority="2">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
		<xsl:if test="following-sibling::ogc:p">
			<xsl:value-of select="$linebreak"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/*/*[local-name() = 'preface']/*" priority="3">
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->

	<xsl:template match="ogc:title" name="title">

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>

		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level = 3">14pt</xsl:when>
				<xsl:when test="$level = 4">12pt</xsl:when>
				<xsl:when test="$level &gt;= 5">11pt</xsl:when>
				<xsl:otherwise>18pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="font-weight">
			<xsl:choose>
				<xsl:when test="$level = 3">bold</xsl:when>
				<xsl:when test="$level = 4">bold</xsl:when>
				<xsl:when test="$level = 5">bold</xsl:when>
				<xsl:otherwise>normal</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$level = 1">
				<fo:block-container margin-left="-22mm">
					<fo:block-container margin-left="0mm">
						<fo:block margin-bottom="10pt" space-before="36pt" keep-with-next="always" role="H{$level}">
							<fo:table table-layout="fixed" width="100%">
								<fo:table-column column-width="22mm"/>
								<fo:table-column column-width="158mm"/>
								<fo:table-body>
									<fo:table-row>
										<fo:table-cell>
											<fo:block margin-top="-3mm">
												<xsl:for-each select="..">
													<xsl:call-template name="insertSectionNumInCircle">
														<xsl:with-param name="font-size" select="'18em'"/>
													</xsl:call-template>
												</xsl:for-each>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block space-before="36pt">
												<xsl:variable name="title">
													<xsl:choose>
														<xsl:when test="*[local-name() = 'tab']">
															<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:copy-of select="."/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:variable>
												<xsl:call-template name="insertSectionTitle">
													<xsl:with-param name="title" select="$title"/>
												</xsl:call-template>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:when test="$level = 2">
				<fo:block space-before="24pt" margin-bottom="10pt" role="H{$level}">
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
					<xsl:variable name="title">
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="section" select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
					<xsl:call-template name="insertSectionTitle">
						<xsl:with-param name="section" select="$section"/>
						<xsl:with-param name="title" select="$title"/>
						<xsl:with-param name="level" select="$level"/>
					</xsl:call-template>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$element-name}">
					<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
					<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
					<xsl:attribute name="keep-with-next">always</xsl:attribute>
					<xsl:attribute name="margin-top">30pt</xsl:attribute>
					<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
					<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
					<xsl:attribute name="role">H<xsl:value-of select="$level"/></xsl:attribute>
					<xsl:apply-templates/>
					<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:template match="ogc:p" name="paragraph">
		<xsl:param name="inline" select="'false'"/>
		<xsl:param name="split_keep-within-line"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:if test="@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::ogc:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise><!-- justify -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="not(ancestor::ogc:table)">
				<xsl:attribute name="line-height">124%</xsl:attribute>
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::ogc:dd and not(ancestor::ogc:table)">
				<xsl:attribute name="margin-bottom">4pt</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::ogc:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ogc:fn/ogc:p">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="ogc:ul | ogc:ol" mode="list" priority="2">
		<xsl:variable name="ul_indent">6mm</xsl:variable>
		<fo:block-container margin-left="13mm">
			<xsl:if test="self::ogc:ul and not(ancestor::ogc:ul) and not(ancestor::ogc:ol)"> <!-- if first level -->
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="self::ogc:ul and ancestor::*[2][self::ogc:ul]"> <!-- ul/li/ul -->
				<xsl:attribute name="margin-left"><xsl:value-of select="$ul_indent"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::ogc:table">
				<xsl:attribute name="margin-left">4mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::ogc:ul or ancestor::ogc:ol">
				<xsl:attribute name="margin-top">10pt</xsl:attribute>
				<xsl:if test="ancestor::ogc:table">
					<xsl:attribute name="margin-top">1mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<fo:block-container margin-left="0mm">
				<fo:list-block xsl:use-attribute-sets="list-style">
					<xsl:if test="self::ogc:ul">
						<xsl:attribute name="provisional-distance-between-starts"><xsl:value-of select="$ul_indent"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="ancestor::ogc:table">
						<xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
					</xsl:if>
					<xsl:if test="ancestor::ogc:ul | ancestor::ogc:ol">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						<xsl:if test="ancestor::ogc:table[not(@class)]">
							<xsl:attribute name="space-after">1mm</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:if test="following-sibling::*[1][local-name() = 'ul' or local-name() = 'ol']">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates/>
				</fo:list-block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="ogc:ul/ogc:note | ogc:ol/ogc:note" priority="2">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block/></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates select="ogc:name"/>
					<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="ogc:term/ogc:name" priority="2">
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block space-before="36pt" margin-bottom="10pt" keep-with-next="always" role="H{$levelTerm}">
			<fo:list-block color="{$color_blue}" keep-with-next="always" provisional-distance-between-starts="{string-length()*3}mm">
				<fo:list-item>
					<fo:list-item-label end-indent="label-end()">
						<fo:block><fo:inline font-size="18pt" padding-right="1mm"><xsl:apply-templates/></fo:inline></fo:block>
					</fo:list-item-label>
					<fo:list-item-body start-indent="body-start()">
						<fo:block>
							<xsl:apply-templates select="../ogc:preferred | ../ogc:deprecated | ../ogc:admitted" mode="term_name"/>
						</fo:block>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
			<xsl:call-template name="insertShortHorizontalLine"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="ogc:preferred | ogc:deprecated | ogc:admitted" priority="2"/>

	<!-- first preferred displays on the same line as term/name -->
	<xsl:template match="ogc:preferred[not(preceding-sibling::ogc:preferred)]" mode="term_name" priority="2">
		<fo:inline font-size="18pt" padding-right="3mm"><xsl:call-template name="setStyle_preferred"/><xsl:apply-templates/></fo:inline>
		<fo:inline padding-right="2mm"> </fo:inline>
	</xsl:template>

	<xsl:template match="ogc:preferred | ogc:deprecated | ogc:admitted" mode="term_name">
		<xsl:choose>
			<xsl:when test="preceding-sibling::*[self::ogc:preferred or self::deprecated or self::admitted]">
				<fo:block space-before="6pt"><xsl:call-template name="displayTerm"/></fo:block> <!-- block wrapper -->
			</xsl:when>
			<xsl:otherwise><xsl:call-template name="displayTerm"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="displayTerm">
		<fo:inline font-size="18pt" padding-right="3mm"><xsl:apply-templates/></fo:inline>
		<fo:inline font-size="11pt" padding="1mm" padding-bottom="0.5mm" baseline-shift="25%">
			<xsl:variable name="kind" select="local-name()"/>
			<xsl:attribute name="background-color">
				<xsl:choose>
					<xsl:when test="$kind = 'preferred'">rgb(249, 235, 187)</xsl:when>
					<xsl:when test="$kind = 'deprecated'">rgb(237, 237, 238)</xsl:when>
					<xsl:when test="$kind = 'admitted'">rgb(223, 236, 249)</xsl:when>
				</xsl:choose>
			</xsl:attribute>
			<xsl:call-template name="addLetterSpacing">
				<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new($kind))"/>
			</xsl:call-template>
		</fo:inline>
		<xsl:if test="following-sibling::*[self::ogc:preferred or self::deprecated or self::admitted]">
			<fo:inline padding-right="2mm"> </fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='th']//text()" priority="2">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-java"/>
		</xsl:variable>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new($text))"/>
	</xsl:template>

	<xsl:template match="ogc:figure" priority="2">
		<fo:block-container id="{@id}" margin-top="12pt" margin-bottom="12pt">
			<fo:block>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="ogc:note">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<xsl:apply-templates select="ogc:name"/>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="insertHeaderFooter">
		<xsl:param name="color" select="$color_blue"/>
		<fo:static-content flow-name="footer" role="artifact">
			<fo:block-container font-size="8pt" color="{$color}" padding-top="6mm">
				<fo:table table-layout="fixed" width="100%">
					<fo:table-column column-width="90%"/>
					<fo:table-column column-width="10%"/>
					<fo:table-body>
						<fo:table-row>
							<fo:table-cell>
								<fo:block>
									<fo:inline font-weight="bold">
										<xsl:call-template name="addLetterSpacing">
											<xsl:with-param name="text" select="concat($copyright-owner, ' ')"/>
											<xsl:with-param name="letter-spacing" select="0.2"/>
										</xsl:call-template>
									</fo:inline>
									<xsl:call-template name="addLetterSpacing">
										<xsl:with-param name="text" select="$docnumber"/>
										<xsl:with-param name="letter-spacing" select="0.2"/>
									</xsl:call-template>
								</fo:block>
							</fo:table-cell>
							<fo:table-cell text-align="right">
								<fo:block font-weight="bold">
									<fo:page-number/>
								</fo:block>
							</fo:table-cell>
						</fo:table-row>
					</fo:table-body>
				</fo:table>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<xsl:variable name="Image-Cover-Background">
	</xsl:variable>

	<xsl:template name="insertLogo">
		<xsl:choose>
			<xsl:when test="$selectedStyle = '2'">
				<xsl:variable name="Image-Logo-OGC">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="Layer_1" data-name="Layer 1" viewBox="0 0 1507.26 505.29"><defs><style>.cls-1{fill:none;}.cls-2{clip-path:url(#clip-path);}.cls-3{fill:#fff;}</style><clipPath id="clip-path" transform="translate(-204.33 -235.82)"><rect class="cls-1" width="1915.92" height="976.9"/></clipPath></defs><g id="Reverse_Horizontal_Lockup" data-name="Reverse Horizontal Lockup"><g class="cls-2"><polygon class="cls-3" points="203.48 364.21 203.48 505.26 0.01 387.78 0 152.7 203.48 270.18 203.48 317.19 162.86 293.75 142.51 282 142.5 282 40.72 223.23 40.72 364.27 162.87 434.8 162.87 387.78 101.79 352.52 101.79 329.01 101.79 305.51 203.48 364.21"/><path class="cls-3" d="M428.18,235.82,224.6,353.36,428.18,470.9,631.76,353.36Zm0,188.06L306,353.36l122.16-70.53,122.14,70.53L530,365.11Z" transform="translate(-204.33 -235.82)"/><polygon class="cls-3" points="325.83 269.62 366.55 246.11 407.27 222.6 407.27 269.62 447.88 246.17 447.88 152.67 244.4 270.15 244.4 316.63 244.41 316.63 244.4 330.66 244.41 504.7 244.3 504.64 244.3 505.29 447.88 387.75 447.88 293.18 407.27 316.63 407.27 363.65 285.12 434.17 285.13 293.13 325.83 269.62"/><g class="cls-2"><path class="cls-3" d="M878.76,397.76c-32.72,0-56.84-24-56.84-55.88S846,286,878.76,286s56.75,23.94,56.75,55.89-24.08,55.89-56.75,55.89Zm38.76-55.88c0-22.25-16.55-38.88-38.76-38.88s-38.85,16.79-38.85,38.88,16.63,38.87,38.85,38.87,38.76-16.64,38.76-38.87" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M998.32,310.61c24.87,0,43,18.56,43,43.58s-18.18,43.62-43,43.62a41.58,41.58,0,0,1-27.59-10.06v37.79H953.64V312.64h11.52l3.21,10.2a41.38,41.38,0,0,1,30-12.23Zm25.77,43.58c0-15.67-11.44-27.27-27.11-27.27s-27.22,11.71-27.22,27.27,11.55,27.26,27.22,27.26,27.11-11.6,27.11-27.26" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1138.62,354.38a53.15,53.15,0,0,1-.35,5.62h-67.45c2.13,13.47,11.83,21.74,25.43,21.74,9.93,0,18-4.59,22.37-12.17h18c-6.61,17.55-21.79,28.2-40.34,28.2-24.3,0-42.7-18.76-42.7-43.58s18.36-43.58,42.7-43.58c25.43,0,42.37,19.59,42.37,43.77Zm-67.38-8.27h50.25c-3.06-12.62-12.58-20.07-25.24-20.07-12.85,0-22.21,7.75-25,20.07" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1200.75,310.75c19.44,0,31.57,14.49,31.57,34.95v50h-17.08V349.18c0-15.1-6.57-23.12-19.07-23.12-13.05,0-22.32,10.5-22.32,25.19v44.49h-17.08v-83.1h11.9l3.32,11.59c6.29-8.38,16.56-13.49,28.76-13.49Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M931.48,489.52c-.43,33-22.73,56.73-54.37,56.73S822,522.61,822,490.4s23.22-55.82,54.79-55.82c26.27,0,48.26,16.53,53.12,40H911.65c-4.61-13.85-18.3-22.87-34.54-22.87-21.78,0-37.16,16-37.16,38.71s15,38.74,37.16,38.74c17.19,0,31.18-9.71,35.2-24.35H873.9V489.52Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1029.06,502.87a55.57,55.57,0,0,1-.35,5.61H961.25c2.14,13.47,11.83,21.75,25.44,21.75,9.93,0,18-4.59,22.36-12.17h18c-6.62,17.54-21.79,28.19-40.35,28.19-24.3,0-42.7-18.75-42.7-43.58s18.36-43.58,42.7-43.58c25.44,0,42.37,19.59,42.37,43.78Zm-67.38-8.27h50.25c-3.07-12.63-12.58-20.08-25.24-20.08-12.85,0-22.21,7.75-25,20.08" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1085.53,546.25c-25.42,0-44.44-18.6-44.44-43.58,0-25.13,19-43.58,44.44-43.58S1130,477.65,1130,502.67,1110.9,546.25,1085.53,546.25Zm27-43.58c0-15.9-11.31-27.27-27-27.27s-27,11.37-27,27.27,11.31,27.27,27,27.27,27-11.36,27-27.27" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1141.87,517.84h16.68c.44,8.79,7.82,13.38,17.84,13.38,9.18,0,16.23-3.89,16.23-10.83,0-7.89-8.92-9.69-19.09-11.4-13.86-2.37-30.17-5.52-30.17-24.78,0-14.91,12.89-25.12,32.22-25.12s31.84,10.51,32.17,26.63h-16.18c-.33-7.9-6.35-12.15-16.39-12.15-9.45,0-15.29,4-15.29,10.09,0,7.33,8.48,8.78,18.5,10.43,14,2.35,31.11,5.06,31.11,25.55,0,16.14-13.45,26.61-33.71,26.61s-33.49-11.17-33.92-28.41" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1272.54,459.09c24.86,0,43,18.56,43,43.58s-18.19,43.62-43,43.62a41.53,41.53,0,0,1-27.6-10.06V574h-17.08V461.12h11.51l3.21,10.2a41.4,41.4,0,0,1,30-12.23Zm25.77,43.58c0-15.67-11.45-27.27-27.12-27.27S1244,487.12,1244,502.67s11.56,27.27,27.22,27.27,27.12-11.6,27.12-27.27" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1416.62,461.08v83.1h-13.78l-1.66-10.1A41.76,41.76,0,0,1,1371,546.25c-24.76,0-43.27-18.71-43.27-43.62s18.51-43.54,43.27-43.54c12.25,0,22.85,4.63,30.4,12.38l2-10.39Zm-17.12,41.55c0-15.67-11.45-27.27-27.12-27.27s-27.22,11.71-27.22,27.27,11.56,27.27,27.22,27.27,27.12-11.61,27.12-27.27" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1487.5,528.71v15.52h-12.7c-18.2,0-29.44-11.24-29.44-29.6V475.75H1430.5v-3.3l28.91-30.73h2.9v19.4H1487v14.63h-24.6v37.53c0,9.91,5.52,15.43,15.58,15.43Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1503.79,430.62h17.65v17.62h-17.65Zm.28,30.5h17.09v83.1h-17.09Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1628.21,461.08v83.1h-13.78l-1.67-10.1a41.72,41.72,0,0,1-30.13,12.17c-24.76,0-43.27-18.71-43.27-43.62s18.51-43.54,43.27-43.54c12.25,0,22.85,4.63,30.39,12.38l2-10.39Zm-17.13,41.55c0-15.67-11.44-27.27-27.11-27.27s-27.22,11.71-27.22,27.27S1568.3,529.9,1584,529.9s27.11-11.61,27.11-27.27" transform="translate(-204.33 -235.82)"/><rect class="cls-3" x="1448.24" y="195.51" width="17.09" height="112.9"/><path class="cls-3" d="M822,638.89c0-32.24,23.5-55.83,55.38-55.83,25.49,0,45.91,15.88,51.56,40.14H911c-5.14-14.35-17.71-23-33.66-23-21.58,0-37.4,16.24-37.4,38.72s15.82,38.63,37.4,38.63c16.46,0,29.18-9.3,34-24.57h17.94c-5.61,25.33-26,41.67-52,41.67C845.47,694.62,822,671,822,638.89" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M984.74,694.73c-25.42,0-44.44-18.6-44.44-43.58s19-43.58,44.44-43.58,44.43,18.56,44.43,43.59S1010.11,694.73,984.74,694.73Zm27-43.58c0-15.9-11.31-27.26-27-27.26s-27,11.36-27,27.26,11.32,27.27,27,27.27,27-11.36,27-27.27" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1091.34,607.71c19.44,0,31.57,14.49,31.57,35v50h-17.08V646.14c0-15.09-6.57-23.11-19.07-23.11-13,0-22.32,10.5-22.32,25.18v44.5h-17.09V609.6h11.91l3.32,11.6c6.29-8.38,16.55-13.49,28.76-13.49Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1139.87,666.32h16.68c.44,8.79,7.82,13.38,17.84,13.38,9.18,0,16.23-3.88,16.23-10.83,0-7.88-8.92-9.69-19.1-11.4-13.85-2.37-30.16-5.52-30.16-24.78,0-14.91,12.89-25.11,32.22-25.11s31.84,10.51,32.16,26.63h-16.18c-.32-7.91-6.34-12.15-16.38-12.15-9.45,0-15.29,4-15.29,10.08,0,7.34,8.48,8.79,18.5,10.43,14,2.36,31.11,5.06,31.11,25.55,0,16.14-13.46,26.61-33.71,26.61s-33.49-11.17-33.92-28.41" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1264.18,694.73c-25.41,0-44.43-18.6-44.43-43.58s19-43.58,44.43-43.58,44.44,18.56,44.44,43.59S1289.56,694.73,1264.18,694.73Zm27-43.58c0-15.9-11.31-27.26-27-27.26s-27,11.36-27,27.26,11.31,27.27,27,27.27,27-11.36,27-27.27" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1374.08,609.14v16.14h-9c-14.14,0-21.19,8.06-21.19,23.11v44.32H1326.8V609.6h11.56l2.89,11.34c5.94-7.88,14.1-11.8,25.44-11.8Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1434.1,677.19v15.52h-12.7c-18.2,0-29.44-11.23-29.44-29.6V624.23H1377.1v-3.3L1406,590.2h2.91v19.4h24.72v14.63h-24.59v37.54c0,9.9,5.51,15.42,15.58,15.42Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1450.39,579.1H1468v17.62h-17.65Zm.28,30.5h17.09v83.11h-17.09Z" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1490.77,657.62v-48h17.08v45.62c0,14.44,7.89,23.2,20.72,23.2s20.67-8.92,20.67-23.2V609.6h17.08v48c0,22.36-14.82,37.11-37.75,37.11s-37.8-14.75-37.8-37.11" transform="translate(-204.33 -235.82)"/><path class="cls-3" d="M1682.24,607.71c17.52,0,29.35,13.33,29.35,32.14v52.86h-17.08V644.06c0-13.38-5.82-21-16.17-21-11,0-19.49,10.08-19.49,24.24v45.44h-16.68V644.06c0-13.38-5.78-21-16.19-21-11,0-19.57,10.08-19.57,24.24v45.44h-17.09V609.6h12.11l2.93,10.74a33.32,33.32,0,0,1,25.82-12.63c11.27,0,20.2,5.54,24.94,14.55a32.86,32.86,0,0,1,27.12-14.55Z" transform="translate(-204.33 -235.82)"/></g></g></g></svg>
				</xsl:variable>
				<fo:block margin-top="-13mm">
					<fo:instream-foreign-object content-width="39mm" fox:alt-text="Image Logo">
						<xsl:copy-of select="$Image-Logo-OGC"/>
					</fo:instream-foreign-object>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Image-Logo-OGC">
					<xsl:text>iVBORw0KGgoAAAANSUhEUgAABEwAAAHqCAYAAAAefNvuAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIDIwMTQgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjlCQjdDRjY3RUJCNzExRUE5RjgwQzU1RDQ2MzNFNTIxIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjlCQjdDRjY4RUJCNzExRUE5RjgwQzU1RDQ2MzNFNTIxIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6OUJCN0NGNjVFQkI3MTFFQTlGODBDNTVENDYzM0U1MjEiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6OUJCN0NGNjZFQkI3MTFFQTlGODBDNTVENDYzM0U1MjEiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz7GXpk+AACoqUlEQVR42uzd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</xsl:text>
				</xsl:variable>
				<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-OGC))}" width="39mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertLogoPreface">
		<xsl:choose>
			<xsl:when test="$selectedStyle = '2'">
				<xsl:variable name="Image-Logo-Preface-OGC">
					<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="Layer_1" data-name="Layer 1" viewBox="0 0 1511.65 506.76"><defs><style>.cls-1{fill:none;}.cls-2{clip-path:url(#clip-path);}.cls-3{fill:#00b1ff;}</style><clipPath id="clip-path" transform="translate(-204.17 -235.76)"><rect class="cls-1" width="1920" height="978.25"/></clipPath></defs><g id="Blue_Horizontal_Lockup" data-name="Blue Horizontal Lockup"><g class="cls-2"><polygon class="cls-3" points="204.07 365.27 204.07 506.73 0.01 388.91 0 153.15 204.07 270.97 204.07 318.11 163.34 294.61 142.93 282.82 142.92 282.82 40.84 223.88 40.84 365.33 163.34 436.06 163.34 388.91 102.09 353.55 102.09 329.97 102.09 306.4 204.07 365.27"/><path class="cls-3" d="M428.68,235.76,224.5,353.64,428.68,471.52,632.85,353.64Zm0,188.61L306.17,353.64l122.52-70.73,122.49,70.73-20.41,11.79Z" transform="translate(-204.17 -235.76)"/><polygon class="cls-3" points="326.78 270.4 367.62 246.83 408.45 223.25 408.46 270.4 449.18 246.89 449.18 153.12 245.12 270.94 245.12 317.55 245.12 317.55 245.12 331.63 245.12 506.17 245.01 506.11 245.01 506.76 449.18 388.88 449.18 294.04 408.46 317.56 408.46 364.71 285.95 435.44 285.96 293.98 326.78 270.4"/><g class="cls-2"><path class="cls-3" d="M880.57,398.17c-32.81,0-57-24.06-57-56.05s24.2-56.05,57-56.05,56.91,24,56.91,56.05-24.15,56.06-56.91,56.06Zm38.87-56.05c0-22.3-16.59-39-38.87-39s-39,16.84-39,39,16.69,39,39,39,38.87-16.69,38.87-39" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1000.48,310.76c24.94,0,43.18,18.62,43.18,43.71s-18.24,43.75-43.18,43.75a41.67,41.67,0,0,1-27.67-10.09V426H955.67V312.8h11.55L970.44,323a41.5,41.5,0,0,1,30-12.26Zm25.84,43.71c0-15.71-11.47-27.35-27.19-27.35s-27.3,11.75-27.3,27.35,11.59,27.35,27.3,27.35,27.19-11.64,27.19-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1141.19,354.67a56.15,56.15,0,0,1-.35,5.63h-67.65c2.14,13.5,11.86,21.81,25.51,21.81,10,0,18-4.61,22.42-12.21h18c-6.63,17.6-21.85,28.28-40.46,28.28-24.37,0-42.83-18.81-42.83-43.71s18.42-43.7,42.83-43.7c25.51,0,42.49,19.64,42.49,43.9Zm-67.58-8.3H1124c-3.08-12.66-12.62-20.13-25.31-20.13-12.89,0-22.28,7.77-25.09,20.13" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1203.5,310.9c19.49,0,31.66,14.53,31.66,35.06v50.19H1218V349.44c0-15.14-6.59-23.18-19.12-23.18-13.1,0-22.39,10.54-22.39,25.26v44.63h-17.14V312.8h11.95l3.32,11.63c6.31-8.41,16.61-13.53,28.85-13.53Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M933.45,490.2c-.44,33.12-22.8,56.89-54.54,56.89s-55.3-23.7-55.3-56,23.29-56,54.95-56c26.35,0,48.4,16.59,53.28,40.1H913.56c-4.63-13.89-18.36-22.94-34.65-22.94-21.84,0-37.26,16-37.26,38.83s15,38.86,37.26,38.86c17.25,0,31.27-9.75,35.31-24.43H875.7V490.19Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1031.31,503.58a53.19,53.19,0,0,1-.36,5.63H963.3c2.14,13.51,11.87,21.81,25.51,21.81,10,0,18-4.6,22.43-12.2h18c-6.64,17.59-21.85,28.27-40.46,28.27-24.37,0-42.83-18.81-42.83-43.7s18.42-43.71,42.83-43.71c25.5,0,42.49,19.65,42.49,43.9Zm-67.58-8.29h50.4c-3.08-12.66-12.62-20.14-25.32-20.14-12.88,0-22.27,7.78-25.08,20.14" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1087.94,547.09c-25.49,0-44.56-18.65-44.56-43.71s19.07-43.7,44.56-43.7,44.56,18.61,44.56,43.71S1113.39,547.09,1087.94,547.09Zm27.12-43.71c0-15.95-11.34-27.34-27.12-27.34s-27.12,11.39-27.12,27.34,11.34,27.35,27.12,27.35,27.12-11.39,27.12-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1144.44,518.6h16.74c.44,8.81,7.84,13.41,17.88,13.41,9.21,0,16.28-3.89,16.28-10.86,0-7.9-8.94-9.71-19.15-11.43-13.89-2.38-30.25-5.53-30.25-24.85,0-14.95,12.92-25.19,32.31-25.19s31.93,10.54,32.26,26.71h-16.22c-.33-7.93-6.37-12.19-16.44-12.19-9.47,0-15.33,4-15.33,10.12,0,7.35,8.5,8.81,18.56,10.46,14.08,2.36,31.19,5.07,31.19,25.62,0,16.19-13.49,26.69-33.8,26.69s-33.59-11.2-34-28.49" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1275.49,459.68c24.94,0,43.18,18.61,43.18,43.71s-18.24,43.75-43.18,43.75a41.65,41.65,0,0,1-27.67-10.1v37.9h-17.14V461.71h11.55l3.22,10.24a41.48,41.48,0,0,1,30-12.27Zm25.85,43.7c0-15.71-11.48-27.34-27.19-27.34s-27.31,11.74-27.31,27.34,11.59,27.35,27.31,27.35,27.19-11.63,27.19-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1420,461.67V545h-13.82l-1.67-10.14a41.84,41.84,0,0,1-30.22,12.21c-24.84,0-43.4-18.76-43.4-43.75s18.56-43.66,43.4-43.66c12.28,0,22.91,4.64,30.48,12.41l2-10.42Zm-17.18,41.67c0-15.71-11.48-27.34-27.19-27.34s-27.3,11.74-27.3,27.34,11.59,27.35,27.3,27.35,27.19-11.64,27.19-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1491.08,529.5v15.56h-12.73c-18.26,0-29.53-11.26-29.53-29.68v-39h-14.91v-3.32l29-30.82h2.91v19.46h24.8v14.68H1466V514c0,9.93,5.53,15.47,15.63,15.47Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1507.42,431.12h17.7v17.67h-17.7Zm.28,30.59h17.14v83.35H1507.7Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1632.2,461.67V545h-13.82l-1.67-10.14a41.84,41.84,0,0,1-30.22,12.21c-24.83,0-43.4-18.76-43.4-43.75s18.57-43.66,43.4-43.66c12.28,0,22.91,4.64,30.48,12.41l2-10.42ZM1615,503.34c0-15.71-11.48-27.34-27.19-27.34s-27.3,11.74-27.3,27.34,11.59,27.35,27.3,27.35S1615,519.05,1615,503.34" transform="translate(-204.17 -235.76)"/><rect class="cls-3" x="1452.45" y="196.08" width="17.14" height="113.23"/><path class="cls-3" d="M823.61,640c0-32.33,23.57-56,55.54-56,25.56,0,46.05,15.93,51.72,40.25h-18c-5.16-14.39-17.77-23.09-33.77-23.09-21.64,0-37.5,16.28-37.5,38.83s15.86,38.74,37.5,38.74c16.51,0,29.27-9.32,34.14-24.64h18c-5.61,25.41-26.1,41.8-52.13,41.8-32,0-55.54-23.66-55.54-55.9" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M986.86,696c-25.5,0-44.57-18.66-44.57-43.71s19.07-43.71,44.57-43.71,44.56,18.62,44.56,43.71S1012.3,696,986.86,696ZM1014,652.3c0-15.95-11.35-27.35-27.12-27.35s-27.13,11.4-27.13,27.35,11.35,27.35,27.13,27.35S1014,668.25,1014,652.3" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1093.77,608.73c19.49,0,31.66,14.53,31.66,35.06V694H1108.3V647.27c0-15.13-6.59-23.18-19.12-23.18-13.1,0-22.39,10.54-22.39,25.26V694h-17.14V610.63h11.95l3.33,11.63c6.3-8.41,16.6-13.53,28.84-13.53Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1142.43,667.51h16.74c.44,8.82,7.84,13.42,17.89,13.42,9.2,0,16.27-3.9,16.27-10.86,0-7.91-8.94-9.72-19.15-11.43-13.88-2.38-30.25-5.54-30.25-24.86,0-14.95,12.93-25.18,32.31-25.18s31.94,10.54,32.27,26.7h-16.23c-.33-7.93-6.37-12.18-16.44-12.18-9.47,0-15.33,4-15.33,10.11,0,7.36,8.51,8.81,18.56,10.47,14.09,2.35,31.2,5.07,31.2,25.62,0,16.19-13.5,26.69-33.81,26.69s-33.59-11.21-34-28.5" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1267.12,696c-25.5,0-44.57-18.66-44.57-43.71s19.07-43.71,44.57-43.71,44.56,18.62,44.56,43.71S1292.56,696,1267.12,696Zm27.12-43.71c0-15.95-11.35-27.35-27.12-27.35S1240,636.35,1240,652.3s11.35,27.35,27.13,27.35,27.12-11.4,27.12-27.35" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1377.33,610.16v16.19h-9c-14.17,0-21.24,8.08-21.24,23.18V694h-17.14V610.63h11.59l2.9,11.37c6-7.9,14.14-11.84,25.52-11.84Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1437.53,678.41V694h-12.74c-18.26,0-29.52-11.27-29.52-29.68v-39h-14.91V622l29-30.82h2.92v19.46h24.8V625.3H1412.4v37.64c0,9.94,5.53,15.47,15.62,15.47Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1453.86,580h17.71v17.67h-17.71Zm.29,30.59h17.13V694h-17.13Z" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1494.36,658.78V610.63h17.14v45.75c0,14.48,7.9,23.27,20.77,23.27S1553,670.7,1553,656.38V610.63h17.14v48.15c0,22.43-14.87,37.23-37.87,37.23s-37.91-14.8-37.91-37.23" transform="translate(-204.17 -235.76)"/><path class="cls-3" d="M1686.39,608.73c17.57,0,29.43,13.37,29.43,32.24v53h-17.13v-48.8c0-13.42-5.83-21.09-16.21-21.09-11,0-19.55,10.12-19.55,24.31V694H1646.2v-48.8c0-13.42-5.79-21.09-16.24-21.09-11.08,0-19.63,10.12-19.63,24.31V694H1593.2V610.63h12.14l3,10.77a33.38,33.38,0,0,1,25.89-12.67c11.3,0,20.25,5.55,25,14.59a33,33,0,0,1,27.2-14.59Z" transform="translate(-204.17 -235.76)"/></g></g></g></svg>
				</xsl:variable>
				<fo:block text-align="right" margin-right="-1mm" margin-top="-11mm" margin-bottom="-3mm">
					<fo:instream-foreign-object content-width="29mm" fox:alt-text="Image Logo">
						<xsl:copy-of select="$Image-Logo-Preface-OGC"/>
					</fo:instream-foreign-object>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="Image-Logo-Preface-OGC">
					<xsl:text>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</xsl:text>
				</xsl:variable>
				<fo:block text-align="right" margin-right="-1mm" margin-top="-1mm" margin-bottom="1mm">
					<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-Preface-OGC))}" width="29mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="addLetterSpacing">
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
			<xsl:call-template name="addLetterSpacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertSectionNumInCircle">
		<xsl:param name="font-size" select="'20em'"/>
		<xsl:variable name="sectionNum_">
			<xsl:call-template name="getSection"/>
		</xsl:variable>

		<xsl:variable name="sectionNum">
			<xsl:choose>
				<xsl:when test="normalize-space($sectionNum_) = '' and local-name() = 'annex'">
					<xsl:number format="A" count="ogc:annex" lang="en"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$sectionNum_"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- orange circle 14mm -->
		<fo:block>
			<fo:instream-foreign-object content-height="14mm" content-width="14mm" fox:alt-text="Circle">
				<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve" style="shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd" viewBox="0 0 500 500">
					<g id="UrTavla">
						<circle style="fill:{$color_design};" cx="250" cy="250" r="250">
						</circle>
						<text x="50%" y="67%" text-anchor="middle" style="fill:white" dy="20em" font-size="{$font-size}" font-family="Lato" letter-spacing="25"><xsl:value-of select="translate($sectionNum,'.','')"/></text>
					</g>
				</svg>
			</fo:instream-foreign-object>
		</fo:block>
	</xsl:template>

	<xsl:template name="insertCrossingLines">
		<fo:block-container absolute-position="fixed" width="{$pageWidth}mm" height="{$pageHeight}mm" font-size="0">
			<fo:block>
				<fo:instream-foreign-object content-height="{$pageHeight}mm" content-width="{$pageWidth}mm" fox:alt-text="Crossing lines">
					<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2159 2794" width="{$pageWidth}mm" height="{$pageHeight}mm">
						<line x1="0" y1="300" x2="2159" y2="675" stroke="{$color_design}"/>
						<line x1="1215" y1="0" x2="2159" y2="1380" stroke="{$color_design}"/>
						<line x1="0" y1="1850" x2="2159" y2="2390" stroke="{$color_design}"/>
						<line x1="0" y1="2280" x2="2159" y2="1155" stroke="{$color_design}"/>
						<circle style="fill:{$color_design};" cx="1610" cy="580" r="15"/>
						<circle style="fill:{$color_design};" cx="2045" cy="1215" r="15"/>
						<circle style="fill:{$color_design};" cx="562" cy="1990" r="15"/>
					</svg>
				</fo:instream-foreign-object>
			</fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="insertSectionTitleBig">
		<xsl:param name="title"/>
		<fo:block font-size="33pt" margin-bottom="6pt">
			<xsl:apply-templates select="xalan:nodeset($title)" mode="titlebig"/>
			<!-- <xsl:call-template name="addLetterSpacing">
				<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new($title))"/>
				<xsl:with-param name="letter-spacing" select="1.1"/>
			</xsl:call-template> -->
		</fo:block>

		<fo:block-container width="22.5mm" border-bottom="2pt solid {$color_design}">
			<fo:block margin-top="4pt"> </fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="text()" mode="titlebig">
		<xsl:call-template name="addLetterSpacing">
				<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new(.))"/>
				<xsl:with-param name="letter-spacing" select="1.1"/>
			</xsl:call-template>
	</xsl:template>
	<xsl:template match="ogc:strong" mode="titlebig">
		<xsl:apply-templates mode="titlebig"/>
		<fo:inline/>
	</xsl:template>

	<xsl:template match="ogc:br" mode="titlebig">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ogc:fn" mode="titlebig">
	</xsl:template>

	<xsl:template name="insertSectionTitle">
		<xsl:param name="section"/>
		<xsl:param name="title"/>
		<xsl:param name="level">1</xsl:param>
		<fo:block>
			<fo:block font-size="18pt" color="{$color_blue}" keep-with-next="always" line-height="150%">
				<xsl:if test="$section != ''">
					<fo:inline padding-right="2mm">
						<xsl:call-template name="addLetterSpacing">
							<xsl:with-param name="text" select="$section"/>
							<xsl:with-param name="letter-spacing" select="0.6"/>
						</xsl:call-template>
					</fo:inline>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="$level = 1">
						<xsl:apply-templates select="xalan:nodeset($title)" mode="titlesmall"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="xalan:nodeset($title)" mode="titlesimple"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:variable name="variant-title">
					<xsl:choose>
						<xsl:when test="$level = 1">
							<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="titlesmall"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="titlesimple"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="normalize-space($variant-title) != ''">
					<fo:inline padding-right="5mm"> </fo:inline>
					<fo:inline><xsl:copy-of select="$variant-title"/></fo:inline>
				</xsl:if>

			</fo:block>
			<xsl:call-template name="insertShortHorizontalLine"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="text()" mode="titlesmall">
		<xsl:call-template name="addLetterSpacing">
			<xsl:with-param name="text" select="java:toUpperCase(java:java.lang.String.new(.))"/>
			<xsl:with-param name="letter-spacing" select="0.6"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="text()" mode="titlesimple">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="ogc:strong" mode="titlesmall">
		<xsl:apply-templates mode="titlesmall"/>
	</xsl:template>
	<xsl:template match="ogc:strong" mode="titlesimple">
		<xsl:apply-templates mode="titlesimple"/>
	</xsl:template>

	<xsl:template match="ogc:em" mode="titlesmall">
		<fo:inline font-style="italic"><xsl:apply-templates mode="titlesmall"/></fo:inline>
	</xsl:template>
	<xsl:template match="ogc:em" mode="titlesimple">
		<fo:inline font-style="italic"><xsl:apply-templates mode="titlesimple"/></fo:inline>
	</xsl:template>

	<xsl:template match="ogc:fn" mode="titlesmall">
		<xsl:call-template name="fn"/>
	</xsl:template>
	<xsl:template match="ogc:fn" mode="titlesimple">
		<xsl:call-template name="fn"/>
	</xsl:template>
	<xsl:template match="ogc:tab " mode="titlesmall">
		<xsl:apply-templates select="."/>
	</xsl:template>
	<xsl:template match="ogc:tab " mode="titlesimple">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="ogc:br" mode="titlesmall">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>
	<xsl:template match="ogc:br" mode="titlesimple">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'name']/text()[1]" priority="2">
		<!-- 0xA0 to space replacement -->
		<xsl:variable name="text" select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
		<xsl:variable name="separator" select="' — '"/>
		<xsl:choose>
			<xsl:when test="contains($text, $separator)">
				<fo:inline font-weight="bold"><xsl:value-of select="substring-before($text, $separator)"/></fo:inline>
				<xsl:value-of select="$separator"/>
				<xsl:value-of select="substring-after($text, $separator)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertShortHorizontalLine">
		<fo:block-container width="12.7mm" border-top="1pt solid {$color_design}" margin-top="3mm">
			<fo:block font-size="1pt"> </fo:block>
		</fo:block-container>
	</xsl:template>

	<xsl:template name="insertFootnoteSeparator">
		<fo:static-content flow-name="xsl-footnote-separator">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="20%" color="{$color_design}"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<!-- external parameters -->

	<xsl:param name="svg_images"/> <!-- svg images array -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/> <!-- base path for images -->
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:param name="syntax-highlight">false</xsl:param> <!-- syntax highlighting feature, default - off -->
	<xsl:param name="add_math_as_text">true</xsl:param> <!-- add math in text behind svg formula, to copy-paste formula from PDF as text -->

	<xsl:param name="table_if">false</xsl:param> <!-- generate extended table in IF for autolayout-algorithm -->
	<xsl:param name="table_widths"/> <!-- path to xml with table's widths, generated on 1st pass, based on FOP Intermediate Format -->
	<!-- Example: <tables>
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

	<xsl:variable name="isApplyAutolayoutAlgorithm_">
		true
	</xsl:variable>
	<xsl:variable name="isApplyAutolayoutAlgorithm" select="normalize-space($isApplyAutolayoutAlgorithm_)"/>

	<xsl:variable name="isGenerateTableIF_">
		<xsl:choose>
			<xsl:when test="$isApplyAutolayoutAlgorithm = 'true'">
				<xsl:value-of select="normalize-space($table_if) = 'true'"/>
			</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="isGenerateTableIF" select="normalize-space($isGenerateTableIF_)"/>

	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>

	<!-- Note 1: Each xslt has declated variable `namespace` that allows to set some properties, processing logic, etc. for concrete xslt.
	You can put such conditions by using xslt construction `xsl:if test="..."` or <xsl:choose><xsl:when test=""></xsl:when><xsl:otherwiste></xsl:otherwiste></xsl:choose>,
	BUT DON'T put any another conditions together with $namespace = '...' (such conditions will be ignored). For another conditions, please use nested xsl:if or xsl:choose -->

	<!--
	<misc-container>
		<presentation-metadata>
			<papersize>letter</papersize>
		</presentation-metadata>
	</misc-container>
	-->

	<xsl:variable name="papersize" select="java:toLowerCase(java:java.lang.String.new(normalize-space(//*[contains(local-name(), '-standard')]/*[local-name() = 'misc-container']/*[local-name() = 'presentation-metadata']/*[local-name() = 'papersize'])))"/>
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
			<xsl:otherwise>
				215.9
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageWidth" select="normalize-space($pageWidth_)"/>

	<!-- page height in mm -->
	<xsl:variable name="pageHeight_">
		<xsl:choose>
			<xsl:when test="$papersize_height != ''"><xsl:value-of select="$papersize_height"/></xsl:when>
			<xsl:otherwise>
				279.4
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="pageHeight" select="normalize-space($pageHeight_)"/>

	<!-- Page margins in mm (just digits, without 'mm')-->
	<!-- marginLeftRight1 and marginLeftRight2 - is left or right margin depends on odd/even page,
	for example, left margin on odd page and right margin on even page -->
	<xsl:variable name="marginLeftRight1_">
		35
	</xsl:variable>
	<xsl:variable name="marginLeftRight1" select="normalize-space($marginLeftRight1_)"/>

	<xsl:variable name="marginLeftRight2_">
		17
	</xsl:variable>
	<xsl:variable name="marginLeftRight2" select="normalize-space($marginLeftRight2_)"/>

	<xsl:variable name="marginTop_">
		16.5
	</xsl:variable>
	<xsl:variable name="marginTop" select="normalize-space($marginTop_)"/>

	<xsl:variable name="marginBottom_">
		22.5
	</xsl:variable>
	<xsl:variable name="marginBottom" select="normalize-space($marginBottom_)"/>

	<!-- Note 2: almost all localized string determined in the element //localized-strings in metanorma xml, but there are a few cases when:
	 - string didn't determined yet
	 - we need to put the string on two-languages (for instance, on English and French both), but xml contains only localized strings for one language
	 - there is a difference between localized string value and text that should be displayed in PDF
	-->
	<xsl:variable name="titles_">

		<!-- These titles of Table of contents renders different than determined in localized-strings -->
		<title-toc lang="en">

				<xsl:text>Contents</xsl:text>

		</title-toc>
		<title-toc lang="fr">
			<xsl:text>Sommaire</xsl:text>
		</title-toc>
		<title-toc lang="zh">

					<xsl:text>Contents</xsl:text>

		</title-toc>

		<title-descriptors lang="en">Descriptors</title-descriptors>

		<title-part lang="en">

		</title-part>
		<title-part lang="fr">

		</title-part>
		<title-part lang="ru">

		</title-part>
		<title-part lang="zh">第 # 部分:</title-part>

		<title-subpart lang="en">Sub-part #</title-subpart>
		<title-subpart lang="fr">Partie de sub #</title-subpart>

		<title-list-tables lang="en">List of Tables</title-list-tables>

		<title-list-figures lang="en">List of Figures</title-list-figures>

		<title-table-figures lang="en">Table of Figures</title-table-figures>

		<title-list-recommendations lang="en">List of Recommendations</title-list-recommendations>

		<title-summary lang="en">Summary</title-summary>

		<title-continued lang="ru">(продолжение)</title-continued>
		<title-continued lang="en">(continued)</title-continued>
		<title-continued lang="fr">(continué)</title-continued>

	</xsl:variable>
	<xsl:variable name="titles" select="xalan:nodeset($titles_)"/>

	<xsl:variable name="title-list-tables">
		<xsl:variable name="toc_table_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'misc-container']/*[local-name() = 'toc'][@type='table']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_table_title"/>
		<xsl:if test="normalize-space($toc_table_title) = ''">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-list-tables'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-figures">
		<xsl:variable name="toc_figure_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'misc-container']/*[local-name() = 'toc'][@type='figure']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_figure_title"/>
		<xsl:if test="normalize-space($toc_figure_title) = ''">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-list-figures'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="title-list-recommendations">
		<xsl:variable name="toc_requirement_title" select="//*[contains(local-name(), '-standard')]/*[local-name() = 'misc-container']/*[local-name() = 'toc'][@type='requirement']/*[local-name() = 'title']"/>
		<xsl:value-of select="$toc_requirement_title"/>
		<xsl:if test="normalize-space($toc_requirement_title) = ''">
			<xsl:call-template name="getTitle">
				<xsl:with-param name="name" select="'title-list-recommendations'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="bibdata">
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']"/>
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'localized-strings']"/>
	</xsl:variable>

	<!-- Characters -->
	<xsl:variable name="linebreak">&#8232;</xsl:variable>
	<xsl:variable name="tab_zh">　</xsl:variable>
	<xsl:variable name="non_breaking_hyphen">‑</xsl:variable>
	<xsl:variable name="thin_space"> </xsl:variable>
	<xsl:variable name="zero_width_space">​</xsl:variable>
	<xsl:variable name="hair_space"> </xsl:variable>
	<xsl:variable name="en_dash">–</xsl:variable>

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

	<xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

	<xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/>

	<!-- ====================================== -->
	<!-- STYLES -->
	<!-- ====================================== -->
	<xsl:variable name="font_noto_sans">Noto Sans, Noto Sans HK, Noto Sans JP, Noto Sans KR, Noto Sans SC, Noto Sans TC</xsl:variable>
	<xsl:variable name="font_noto_sans_mono">Noto Sans Mono, Noto Sans Mono CJK HK, Noto Sans Mono CJK JP, Noto Sans Mono CJK KR, Noto Sans Mono CJK SC, Noto Sans Mono CJK TC</xsl:variable>
	<xsl:variable name="font_noto_serif">Noto Serif, Noto Serif HK, Noto Serif JP, Noto Serif KR, Noto Serif SC, Noto Serif TC</xsl:variable>
	<xsl:attribute-set name="root-style">

			<xsl:attribute name="font-family">Lato, STIX Two Math, <xsl:value-of select="$font_noto_sans"/></xsl:attribute>
			<xsl:attribute name="font-family-generic">Sans</xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_main"/></xsl:attribute>

	</xsl:attribute-set> <!-- root-style -->

	<xsl:template name="insertRootStyle">
		<xsl:param name="root-style"/>
		<xsl:variable name="root-style_" select="xalan:nodeset($root-style)"/>

		<xsl:variable name="additional_fonts_">
			<xsl:for-each select="//*[contains(local-name(), '-standard')][1]/*[local-name() = 'misc-container']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'fonts']/*[local-name() = 'value'] |       //*[contains(local-name(), '-standard')][1]/*[local-name() = 'presentation-metadata'][*[local-name() = 'name'] = 'fonts']/*[local-name() = 'value']">
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

						<xsl:value-of select="."/>

						<xsl:if test="$additional_fonts != ''">
							<xsl:text>, </xsl:text><xsl:value-of select="$additional_fonts"/>
						</xsl:if>
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

	<!-- Preface sections styles -->
	<xsl:attribute-set name="copyright-statement-style">

			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>

	</xsl:attribute-set> <!-- copyright-statement-style -->

	<xsl:attribute-set name="copyright-statement-title-style">

			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="margin-top">24pt</xsl:attribute>

	</xsl:attribute-set> <!-- copyright-statement-title-style -->

	<xsl:attribute-set name="copyright-statement-p-style">

			<xsl:attribute name="margin-top">6pt</xsl:attribute>

	</xsl:attribute-set> <!-- copyright-statement-p-style -->

	<xsl:attribute-set name="license-statement-style">

			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="license-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>

	</xsl:attribute-set> <!-- license-statement-title-style -->

	<xsl:attribute-set name="license-statement-p-style">

			<xsl:attribute name="margin-top">6pt</xsl:attribute>

	</xsl:attribute-set> <!-- license-statement-p-style -->

	<xsl:attribute-set name="legal-statement-style">

			<xsl:attribute name="font-size">8pt</xsl:attribute>

	</xsl:attribute-set> <!-- legal-statement-style -->

	<xsl:attribute-set name="legal-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

	</xsl:attribute-set> <!-- legal-statement-title-style -->

	<xsl:attribute-set name="legal-statement-p-style">

	</xsl:attribute-set> <!-- legal-statement-p-style -->

	<xsl:attribute-set name="feedback-statement-style">

			<xsl:attribute name="font-size">8pt</xsl:attribute>
			<xsl:attribute name="line-height">125%</xsl:attribute>

	</xsl:attribute-set> <!-- feedback-statement-style -->

	<xsl:attribute-set name="feedback-statement-title-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

	</xsl:attribute-set> <!-- feedback-statement-title-style -->

	<xsl:attribute-set name="feedback-statement-p-style">

			<xsl:attribute name="margin-top">6pt</xsl:attribute>

	</xsl:attribute-set> <!-- feedback-statement-p-style -->

	<!-- End Preface sections styles -->

	<xsl:attribute-set name="link-style">

			<xsl:attribute name="text-decoration">underline</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-container-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		<xsl:attribute name="role">Code</xsl:attribute>

			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="pre-style">
		<xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>

	</xsl:attribute-set>

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

	<xsl:attribute-set name="termexample-style">

			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="example-style">

			<xsl:attribute name="margin-top">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">10pt</xsl:attribute>

	</xsl:attribute-set> <!-- example-style -->

	<xsl:attribute-set name="example-body-style">

	</xsl:attribute-set> <!-- example-body-style -->

	<xsl:attribute-set name="example-name-style">

			<xsl:attribute name="font-weight">bold</xsl:attribute>

	</xsl:attribute-set> <!-- example-name-style -->

	<xsl:attribute-set name="example-p-style">

			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>

	</xsl:attribute-set> <!-- example-p-style -->

	<xsl:attribute-set name="termexample-name-style">

			<xsl:attribute name="padding-right">10mm</xsl:attribute>

	</xsl:attribute-set> <!-- termexample-name-style -->

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

			<xsl:attribute name="space-after">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- table-container-style -->

	<xsl:attribute-set name="table-style">
		<xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
		<xsl:attribute name="table-layout">fixed</xsl:attribute>

	</xsl:attribute-set><!-- table-style -->

	<xsl:attribute-set name="table-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<xsl:attribute name="font-size">11pt</xsl:attribute>

	</xsl:attribute-set> <!-- table-name-style -->

	<xsl:attribute-set name="table-row-style">
		<xsl:attribute name="min-height">4mm</xsl:attribute>

			<xsl:attribute name="min-height">8.5mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="table-header-row-style" use-attribute-sets="table-row-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>

			<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			<xsl:attribute name="color">white</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="table-footer-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="table-header-cell-style">
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="display-align">center</xsl:attribute>

			<xsl:attribute name="padding-top">1mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="border">solid black 0pt</xsl:attribute>

	</xsl:attribute-set> <!-- table-header-cell-style -->

	<xsl:attribute-set name="table-cell-style">
		<xsl:attribute name="display-align">center</xsl:attribute>
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>

			<xsl:attribute name="border">solid 0pt white</xsl:attribute>
			<xsl:attribute name="padding-top">1mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>

	</xsl:attribute-set> <!-- table-cell-style -->

	<xsl:attribute-set name="table-footer-cell-style">
		<xsl:attribute name="border">solid black 1pt</xsl:attribute>
		<xsl:attribute name="padding-left">1mm</xsl:attribute>
		<xsl:attribute name="padding-right">1mm</xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>

			<xsl:attribute name="border">solid black 0pt</xsl:attribute>

	</xsl:attribute-set> <!-- table-footer-cell-style -->

	<xsl:attribute-set name="table-note-style">
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set><!-- table-note-style -->

	<xsl:attribute-set name="table-fn-style">
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- table-fn-style -->

	<xsl:attribute-set name="table-fn-number-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="padding-right">5mm</xsl:attribute>

			<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set> <!-- table-fn-number-style -->

	<xsl:attribute-set name="fn-container-body-style">
		<xsl:attribute name="text-indent">0</xsl:attribute>
		<xsl:attribute name="start-indent">0</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="table-fn-body-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-fn-number-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="padding-right">5mm</xsl:attribute>
		<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-fn-body-style">
		<xsl:attribute name="text-align">justify</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>
	<!-- ========================== -->
	<!-- END Table styles -->
	<!-- ========================== -->

	<!-- ========================== -->
	<!-- Definition's list styles -->
	<!-- ========================== -->
	<xsl:attribute-set name="dt-row-style">

			<xsl:attribute name="min-height">8.5mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="dt-cell-style">
	</xsl:attribute-set>

	<xsl:attribute-set name="dt-block-style">
		<xsl:attribute name="margin-top">0pt</xsl:attribute>

			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="dl-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="margin-bottom">6pt</xsl:attribute>

			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>

	</xsl:attribute-set> <!-- dl-name-style -->

	<xsl:attribute-set name="dd-cell-style">
		<xsl:attribute name="padding-left">2mm</xsl:attribute>
	</xsl:attribute-set>

	<!-- ========================== -->
	<!-- END Definition's list styles -->
	<!-- ========================== -->

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

	<xsl:attribute-set name="xref-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="eref-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="note-style">

			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:variable name="note-body-indent">10mm</xsl:variable>
	<xsl:variable name="note-body-indent-table">5mm</xsl:variable>

	<xsl:attribute-set name="note-name-style">

			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="table-note-name-style">
		<xsl:attribute name="padding-right">2mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="note-p-style">

			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="termnote-style">

			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="termnote-name-style">

			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="padding-right">1mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="termnote-p-style">

			<xsl:attribute name="space-before">4pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="quote-style">
		<xsl:attribute name="margin-left">12mm</xsl:attribute>
		<xsl:attribute name="margin-right">12mm</xsl:attribute>

			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="quote-source-style">
		<xsl:attribute name="text-align">right</xsl:attribute>

			<xsl:attribute name="margin-right">25mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="termsource-style">

			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="termsource-text-style">

			<xsl:attribute name="padding-right">1mm</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="origin-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="term-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="term-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="figure-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-name-style">

			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>
			<!-- <xsl:attribute name="margin-top">12pt</xsl:attribute> -->
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
			<!-- <xsl:attribute name="margin-bottom">6pt</xsl:attribute> -->
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<!-- <xsl:attribute name="keep-with-next">always</xsl:attribute> -->
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>

	</xsl:attribute-set>

	<!-- Formula's styles -->
	<xsl:attribute-set name="formula-style">
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

	</xsl:attribute-set> <!-- formula-style -->

	<xsl:attribute-set name="formula-stem-block-style">
		<xsl:attribute name="text-align">center</xsl:attribute>

			<xsl:attribute name="text-align">left</xsl:attribute>

	</xsl:attribute-set> <!-- formula-stem-block-style -->

	<xsl:attribute-set name="formula-stem-number-style">
		<xsl:attribute name="text-align">right</xsl:attribute>

	</xsl:attribute-set> <!-- formula-stem-number-style -->
	<!-- End Formula's styles -->

	<xsl:attribute-set name="image-style">
		<xsl:attribute name="text-align">center</xsl:attribute>

			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">6pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="figure-pseudocode-p-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="image-graphic-style">
		<xsl:attribute name="width">100%</xsl:attribute>
		<xsl:attribute name="content-height">100%</xsl:attribute>
		<xsl:attribute name="scaling">uniform</xsl:attribute>

			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="tt-style">

			<xsl:attribute name="font-family">Fira Code, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="preferred-block-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="preferred-term-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="domain-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="admitted-style">

			<xsl:attribute name="font-size">11pt</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="deprecates-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="definition-style">

			<xsl:attribute name="space-after">6pt</xsl:attribute>

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

	<xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="list-style">

			<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
			<xsl:attribute name="space-after">12pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>

	</xsl:attribute-set> <!-- list-style -->

	<xsl:attribute-set name="list-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>

			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="color"><xsl:value-of select="$color_blue"/></xsl:attribute>

	</xsl:attribute-set> <!-- list-name-style -->

	<xsl:attribute-set name="list-item-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="list-item-label-style">

	</xsl:attribute-set>

	<xsl:attribute-set name="list-item-body-style">

			<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="toc-style">
		<xsl:attribute name="line-height">135%</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="fn-reference-style">
		<xsl:attribute name="font-size">80%</xsl:attribute>
		<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>

			<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set>

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
			<xsl:attribute name="color"><xsl:value-of select="$color_main"/></xsl:attribute>
			<xsl:attribute name="line-height">124%</xsl:attribute>
			<xsl:attribute name="text-align">justify</xsl:attribute>

	</xsl:attribute-set>

	<xsl:attribute-set name="fn-body-num-style">
		<xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>

			<xsl:attribute name="font-size">60%</xsl:attribute>
			<xsl:attribute name="vertical-align">super</xsl:attribute>

	</xsl:attribute-set> <!-- fn-body-num-style -->

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

	<!-- bibitem in Normative References (references/@normative="true") -->
	<xsl:attribute-set name="bibitem-normative-style">

			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="start-indent">25mm</xsl:attribute>
			<xsl:attribute name="text-indent">-25mm</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-normative-style -->

	<!-- bibitem in Normative References (references/@normative="true"), renders as list -->
	<xsl:attribute-set name="bibitem-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

		<!-- <xsl:if test="$namespace = 'ieee'">
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="provisional-distance-between-starts">9.5mm</xsl:attribute>
		</xsl:if> -->

			<xsl:attribute name="provisional-distance-between-starts">13mm</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-normative-list-style -->

	<xsl:attribute-set name="bibitem-non-normative-style">

	</xsl:attribute-set> <!-- bibitem-non-normative-style -->

	<!-- bibitem in bibliography section (references/@normative="false"), renders as list -->
	<xsl:attribute-set name="bibitem-non-normative-list-style">
		<xsl:attribute name="provisional-distance-between-starts">12mm</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>

			<xsl:attribute name="provisional-distance-between-starts">13mm</xsl:attribute>

	</xsl:attribute-set> <!-- bibitem-non-normative-list-style -->

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
	<!-- ====================================== -->
	<!-- END STYLES -->
	<!-- ====================================== -->

	<xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable>
	<xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable>

	<xsl:variable name="ace_tag">ace-tag_</xsl:variable>

	<xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:variable name="nodes_preface_">
			<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_preface" select="xalan:nodeset($nodes_preface_)"/>

		<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
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
			<xsl:for-each select="/*/*[local-name()='sections']/*">
				<node id="{@id}"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

		<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |    /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]">
			<xsl:sort select="@displayorder" data-type="number"/>

			<!-- process Section's title -->
			<xsl:variable name="preceding-sibling_id" select="$nodes_sections/node[@id = current()/@id]/preceding-sibling::node[1]/@id"/>
			<xsl:if test="$preceding-sibling_id != ''">
				<xsl:apply-templates select="parent::*/*[@type = 'section-title' and @id = $preceding-sibling_id and not(@displayorder)]" mode="contents_no_displayorder"/>
			</xsl:if>

			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>

		<xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>

		<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true') and not(*[local-name()='references'][@normative='true'])] |          /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="." mode="contents"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processTablesFigures_Contents">
		<xsl:param name="always"/>
		<xsl:if test="(//*[contains(local-name(), '-standard')]/*[local-name() = 'misc-container']/*[local-name() = 'toc'][@type='table']/*[local-name() = 'title']) or normalize-space($always) = 'true'">
			<xsl:call-template name="processTables_Contents"/>
		</xsl:if>
		<xsl:if test="(//*[contains(local-name(), '-standard')]/*[local-name() = 'misc-container']/*[local-name() = 'toc'][@type='figure']/*[local-name() = 'title']) or normalize-space($always) = 'true'">
			<xsl:call-template name="processFigures_Contents"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processTables_Contents">
		<tables>
			<xsl:for-each select="//*[local-name() = 'table'][@id and *[local-name() = 'name'] and normalize-space(@id) != '']">
				<table id="{@id}" alt-text="{*[local-name() = 'name']}">
					<xsl:copy-of select="*[local-name() = 'name']"/>
				</table>
			</xsl:for-each>
		</tables>
	</xsl:template>

	<xsl:template name="processFigures_Contents">
		<figures>
			<xsl:for-each select="//*[local-name() = 'figure'][@id and *[local-name() = 'name'] and not(@unnumbered = 'true') and normalize-space(@id) != ''] | //*[@id and starts-with(*[local-name() = 'name'], 'Figure ') and normalize-space(@id) != '']">
				<figure id="{@id}" alt-text="{*[local-name() = 'name']}">
					<xsl:copy-of select="*[local-name() = 'name']"/>
				</figure>
			</xsl:for-each>
		</figures>
	</xsl:template>

	<xsl:template name="processPrefaceSectionsDefault">
		<xsl:for-each select="/*/*[local-name()='preface']/*[not(local-name() = 'note' or local-name() = 'admonition')]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="processMainSectionsDefault">
		<xsl:for-each select="/*/*[local-name()='sections']/* | /*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>

		</xsl:for-each>

		<xsl:for-each select="/*/*[local-name()='annex']">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>

		<xsl:for-each select="/*/*[local-name()='bibliography']/*[not(@normative='true')] |          /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]">
			<xsl:sort select="@displayorder" data-type="number"/>
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>

	<xsl:variable name="regex_standard_reference">([A-Z]{2,}(/[A-Z]{2,})* \d+(-\d+)*(:\d{4})?)</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_open">###fo:inline keep-together_within-line###</xsl:variable>
	<xsl:variable name="tag_fo_inline_keep-together_within-line_close">###/fo:inline keep-together_within-line###</xsl:variable>
	<xsl:template match="text()" name="text">

				<xsl:choose>
					<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:value-of select="."/></xsl:when>
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
				<fo:inline keep-together.within-line="always">
					<xsl:value-of select="substring-before($text_after, $tag_close)"/>
				</fo:inline>
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

	<xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template>

	<!-- keep-together for standard's name (ISO 12345:2020) -->
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
				<xsl:for-each select="xalan:nodeset($items)/item">
					<xsl:choose>
						<xsl:when test=". = $sep">
							<xsl:value-of select="$sep"/><xsl:value-of select="$zero_width_space"/>
						</xsl:when>
						<xsl:otherwise>
							<fo:inline keep-together.within-line="always"><xsl:apply-templates/></fo:inline>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>

			<xsl:otherwise>
				<fo:inline keep-together.within-line="always"><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>

		</xsl:choose>
	</xsl:template>

	<!-- ================================= -->
	<!-- Preface boilerplate sections processing -->
	<!-- ================================= -->
	<xsl:template match="*[local-name()='copyright-statement']">
		<fo:block xsl:use-attribute-sets="copyright-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- copyright-statement -->

	<xsl:template match="*[local-name()='copyright-statement']//*[local-name()='title']">

				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="copyright-statement-title-style">
					<xsl:apply-templates/>
				</fo:block>

	</xsl:template> <!-- copyright-statement//title -->

	<xsl:template match="*[local-name()='copyright-statement']//*[local-name()='p']">

				<fo:block xsl:use-attribute-sets="copyright-statement-p-style">

					<xsl:apply-templates/>
				</fo:block>

	</xsl:template> <!-- copyright-statement//p -->

	<xsl:template match="*[local-name()='license-statement']">
		<fo:block xsl:use-attribute-sets="license-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- license-statement -->

	<xsl:template match="*[local-name()='license-statement']//*[local-name()='title']">

				<xsl:variable name="level">
					<xsl:call-template name="getLevel"/>
				</xsl:variable>
				<fo:block role="H{$level}" xsl:use-attribute-sets="license-statement-title-style">
					<xsl:apply-templates/>
				</fo:block>

	</xsl:template> <!-- license-statement/title -->

	<xsl:template match="*[local-name()='license-statement']//*[local-name()='p']">

				<fo:block xsl:use-attribute-sets="license-statement-p-style">

					<xsl:apply-templates/>
				</fo:block>

	</xsl:template> <!-- license-statement/p -->

	<xsl:template match="*[local-name()='legal-statement']">
		<fo:block xsl:use-attribute-sets="legal-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- legal-statement -->

	<xsl:template match="*[local-name()='legal-statement']//*[local-name()='title']">

				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>

	</xsl:template> <!-- legal-statement/title -->

	<xsl:template match="*[local-name()='legal-statement']//*[local-name()='p']">
		<xsl:param name="margin"/>

				<!-- process in the template 'paragraph' -->
				<xsl:call-template name="paragraph">
					<xsl:with-param name="margin" select="$margin"/>
				</xsl:call-template>

	</xsl:template> <!-- legal-statement/p -->

	<xsl:template match="*[local-name()='feedback-statement']">
		<fo:block xsl:use-attribute-sets="feedback-statement-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template> <!-- feedback-statement -->

	<xsl:template match="*[local-name()='feedback-statement']//*[local-name()='title']">

				<!-- process in the template 'title' -->
				<xsl:call-template name="title"/>

	</xsl:template>

	<xsl:template match="*[local-name()='feedback-statement']//*[local-name()='p']">
		<xsl:param name="margin"/>

				<fo:block xsl:use-attribute-sets="feedback-statement-p-style">
					<xsl:apply-templates/>
				</fo:block>

	</xsl:template>

	<!-- ================================= -->
	<!-- END Preface boilerplate sections processing -->
	<!-- ================================= -->

	<!-- add zero spaces into table cells text -->
	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
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

	<xsl:template match="*[local-name()='table']" name="table">

		<xsl:variable name="table-preamble">

				<fo:block> </fo:block>

		</xsl:variable>

		<xsl:variable name="table">

			<xsl:variable name="simple-table">
				<xsl:call-template name="getSimpleTable">
					<xsl:with-param name="id" select="@id"/>
				</xsl:call-template>
			</xsl:variable>
			<!-- <xsl:variable name="simple-table" select="xalan:nodeset($simple-table_)"/> -->

			<!-- simple-table=<xsl:copy-of select="$simple-table"/> -->

			<!-- Display table's name before table as standalone block -->
			<!-- $namespace = 'iso' or  -->

					<xsl:apply-templates select="*[local-name()='name']"/> <!-- table's title rendered before table -->

					<xsl:call-template name="table_name_fn_display"/>

			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/tr[1]/td)"/>

			<xsl:variable name="colwidths">
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col'])">
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
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<fo:block-container xsl:use-attribute-sets="table-container-style">

					<!-- <xsl:if test="ancestor::*[local-name()='sections']"> -->
						<xsl:attribute name="font-size">9pt</xsl:attribute>
					<!-- </xsl:if> -->

				<!-- end table block-container attributes -->

				<!-- display table's name before table for PAS inside block-container (2-columnn layout) -->

				<xsl:variable name="table_width_default">100%</xsl:variable>
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->

							<xsl:choose>
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

					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or .//*[local-name()='fn'][local-name(..) != 'name']"/>
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
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
							<!-- Simple_table=<xsl:copy-of select="$simple-table"/> -->
							<xsl:apply-templates select="xalan:nodeset($simple-table)" mode="process_table-if"/>

						</xsl:when>
						<xsl:otherwise>

							<xsl:choose>
								<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
									<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
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
									<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'note')          and not(local-name() = 'thead') and not(local-name() = 'tfoot')]"/> <!-- process all table' elements, except name, header, footer and note that renders separaterely -->
								</xsl:otherwise>
							</xsl:choose>

						</xsl:otherwise>
					</xsl:choose>

				</fo:table>

				<xsl:variable name="colgroup" select="*[local-name()='colgroup']"/>
				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>
						<xsl:with-param name="colgroup" select="$colgroup"/>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:if test="*[local-name()='bookmark']"> <!-- special case: table/bookmark -->
					<fo:block keep-with-previous="always" line-height="0.1">
						<xsl:for-each select="*[local-name()='bookmark']">
							<xsl:call-template name="bookmark"/>
						</xsl:for-each>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</xsl:variable>

		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<xsl:choose>
			<xsl:when test="@width">

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

	<xsl:template match="*[local-name()='table']/*[local-name() = 'name']">
		<xsl:param name="continued"/>
		<xsl:if test="normalize-space() != ''">

					<fo:block xsl:use-attribute-sets="table-name-style">

						<xsl:choose>
							<xsl:when test="$continued = 'true'">

							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>

					</fo:block>

		</xsl:if>
	</xsl:template> <!-- table/name -->

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
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
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
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
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

	<xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template>

	<xsl:template match="*[local-name()='link']" mode="td_text">
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
					<column divider="100">
						<xsl:value-of select="round(@width_min + $d * $W div $D)"/> <!--  * 10 -->
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
						<!-- <xsl:when test="parent::*[local-name() = 'dd']">2</xsl:when> -->
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
	<!-- Calculate column's width based on HTML4 algorithm -->
	<!-- ================================================== -->

	<xsl:template match="*[local-name()='thead']">
		<xsl:param name="cols-count"/>
		<fo:table-header>

			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template> <!-- thead -->

	<!-- template is using for iso, jcgm, bsi only -->
	<xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black">

						<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']">
							<xsl:with-param name="continued">true</xsl:with-param>
						</xsl:apply-templates>

			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- table-header-title -->

	<xsl:template match="*[local-name()='thead']" mode="process_tbody">
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="*[local-name()='tfoot']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>
				<xsl:apply-templates select="../*[local-name()='tfoot']"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>

		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>

		<xsl:variable name="isNoteOrFnExistShowAfterTable">

		</xsl:variable>

		<xsl:if test="$isNoteOrFnExist = 'true' or normalize-space($isNoteOrFnExistShowAfterTable) = 'true'">

			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//*[local-name()='col'])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="tableWithNotesAndFootnotes">

				<fo:table keep-with-previous="always">
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

					<xsl:choose>
						<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
							<xsl:for-each select="xalan:nodeset($colgroup)//*[local-name()='col']">
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

					<fo:table-body>
						<fo:table-row>
							<fo:table-cell xsl:use-attribute-sets="table-footer-cell-style" number-columns-spanned="{$cols-count}">

								<!-- fn will be processed inside 'note' processing -->

								<!-- for BSI (not PAS) display Notes before footnotes -->

								<!-- except gb and bsi  -->

										<xsl:apply-templates select="../*[local-name()='note']"/>

								<!-- horizontal row separator -->

								<!-- fn processing -->

										<xsl:call-template name="table_fn_display"/>

								<!-- for PAS display Notes after footnotes -->

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

	<xsl:template match="*[local-name()='tbody']">

		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:apply-templates select="../*[local-name()='thead']">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>

		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>

		<fo:table-body>

			<xsl:apply-templates/>

		</fo:table-body>

	</xsl:template> <!-- tbody -->

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

	<!-- ===================== -->
	<!-- Table's row processing -->
	<!-- ===================== -->
	<!-- row in table header (thead) -->
	<xsl:template match="*[local-name()='thead']/*[local-name()='tr']" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-header-row-style">

			<xsl:call-template name="setTableRowAttributes"/>

			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<!-- row in table footer (tfoot) -->
	<xsl:template match="*[local-name()='tfoot']/*[local-name()='tr']" priority="2">
		<fo:table-row xsl:use-attribute-sets="table-footer-row-style">

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

				<xsl:variable name="number"><xsl:number/></xsl:variable>
				<xsl:attribute name="background-color">
					<xsl:choose>
						<xsl:when test="$number mod 2 = 0">rgb(252, 246, 222)</xsl:when>
						<xsl:otherwise>rgb(254, 252, 245)</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

			<xsl:call-template name="setTableRowAttributes"/>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template name="setTableRowAttributes">

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

				<xsl:if test="starts-with(ancestor::*[local-name() = 'table'][1]/@type, 'recommend') and normalize-space(@align) = ''">
					<xsl:call-template name="setTextAlignment">
						<xsl:with-param name="default">left</xsl:with-param>
					</xsl:call-template>
				</xsl:if>

			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTableCellAttributes"/>

			<fo:block>
				<xsl:apply-templates/>
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

	<!-- cell in table body, footer -->
	<xsl:template match="*[local-name()='td']" name="td">
		<fo:table-cell xsl:use-attribute-sets="table-cell-style"> <!-- text-align="{@align}" -->
			<xsl:call-template name="setTextAlignment">
				<xsl:with-param name="default">left</xsl:with-param>
			</xsl:call-template>

			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>

			 <!-- bsi -->

			<xsl:if test=".//*[local-name() = 'table']"> <!-- if there is nested table -->
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>

			<xsl:call-template name="setTableCellAttributes"/>

			<xsl:if test="$isGenerateTableIF = 'true'">
				<xsl:attribute name="border">1pt solid black</xsl:attribute> <!-- border is mandatory, to determine page width -->
				<xsl:attribute name="text-align">left</xsl:attribute>
			</xsl:if>

			<fo:block>

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:apply-templates/>

				<xsl:if test="$isGenerateTableIF = 'true'"> <fo:inline id="{@id}_end">end</fo:inline></xsl:if> <!-- to determine width of text --> <!-- <xsl:value-of select="$hair_space"/> -->

			</fo:block>
		</fo:table-cell>
	</xsl:template> <!-- td -->

	<xsl:template match="*[local-name()='table']/*[local-name()='note']" priority="2">

		<fo:block xsl:use-attribute-sets="table-note-style">

			<!-- Table's note name (NOTE, for example) -->
			<fo:inline xsl:use-attribute-sets="table-note-name-style">

				<xsl:apply-templates select="*[local-name() = 'name']"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>

	</xsl:template> <!-- table/note -->

	<xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" priority="2">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ===================== -->
	<!-- Footnotes processing  -->
	<!-- ===================== -->
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<!-- footnotes in text (title, bibliography, main body, table's, figure's names), not for tables, figures -->
	<xsl:template match="*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])]" priority="2" name="fn">

		<!-- list of footnotes to calculate actual footnotes number -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>

		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<xsl:variable name="reference_">
			<xsl:value-of select="@reference"/>
			<xsl:if test="normalize-space(@reference) = ''"><xsl:value-of select="$gen_id"/></xsl:if>
		</xsl:variable>
		<xsl:variable name="reference" select="normalize-space($reference_)"/>
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number">
			<xsl:choose>
				<xsl:when test="@current_fn_number"><xsl:value-of select="@current_fn_number"/></xsl:when> <!-- for BSI -->
				<xsl:otherwise>
					<xsl:value-of select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="current_fn_number_text">
			<xsl:value-of select="$current_fn_number"/>

		</xsl:variable>

		<xsl:variable name="ref_id" select="concat('footnote_', $lang, '_', $reference, '_', $current_fn_number)"/>
		<xsl:variable name="footnote_inline">
			<fo:inline xsl:use-attribute-sets="fn-num-style">

				<fo:basic-link internal-destination="{$ref_id}" fox:alt-text="footnote {$current_fn_number}">
					<xsl:value-of select="$current_fn_number_text"/>
				</fo:basic-link>
			</fo:inline>
		</xsl:variable>
		<!-- DEBUG: p_fn=<xsl:copy-of select="$p_fn"/>
		gen_id=<xsl:value-of select="$gen_id"/> -->
		<xsl:choose>
			<xsl:when test="normalize-space(@skip_footnote_body) = 'true'">
				<xsl:copy-of select="$footnote_inline"/>
			</xsl:when>
			<xsl:when test="$p_fn//fn[@gen_id = $gen_id] or normalize-space(@skip_footnote_body) = 'false'">
				<fo:footnote xsl:use-attribute-sets="fn-style">
					<xsl:copy-of select="$footnote_inline"/>
					<fo:footnote-body>

						<fo:block-container xsl:use-attribute-sets="fn-container-body-style">

							<fo:block xsl:use-attribute-sets="fn-body-style">

								<fo:inline id="{$ref_id}" xsl:use-attribute-sets="fn-body-num-style">

									<xsl:value-of select="$current_fn_number_text"/>
								</fo:inline>
								<xsl:apply-templates/>
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
				<xsl:for-each select="ancestor::*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']/*[local-name() = 'note'][@type='title-footnote']">
					<fn gen_id="{generate-id(.)}">
						<xsl:copy-of select="@*"/>
						<xsl:copy-of select="node()"/>
					</fn>
				</xsl:for-each>
				<xsl:for-each select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='boilerplate']/* |       ancestor::*[contains(local-name(), '-standard')]/*[local-name()='preface']/* |      ancestor::*[contains(local-name(), '-standard')]/*[local-name()='sections']/* |       ancestor::*[contains(local-name(), '-standard')]/*[local-name()='annex'] |      ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*">
					<xsl:sort select="@displayorder" data-type="number"/>
					<xsl:for-each select=".//*[local-name() = 'bibitem'][ancestor::*[local-name() = 'references']]/*[local-name() = 'note'] |      .//*[local-name() = 'fn'][not(ancestor::*[(local-name() = 'table' or local-name() = 'figure') and not(ancestor::*[local-name() = 'name'])])][generate-id(.)=generate-id(key('kfn',@reference)[1])]">
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

	<!-- ============================ -->
	<!-- table's footnotes rendering -->
	<!-- ============================ -->
	<xsl:template name="table_fn_display">
		<xsl:variable name="references">

			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<xsl:call-template name="create_fn"/>
			</xsl:for-each>
		</xsl:variable>

		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block xsl:use-attribute-sets="table-fn-style">

					<fo:inline id="{@id}" xsl:use-attribute-sets="table-fn-number-style">

						<xsl:value-of select="@reference"/>

					</fo:inline>
					<fo:inline xsl:use-attribute-sets="table-fn-body-style">
						<xsl:copy-of select="./node()"/>
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="create_fn">
		<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">

				<xsl:attribute name="id">
					<xsl:value-of select="@reference"/>
					<xsl:text>_</xsl:text>
					<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
				</xsl:attribute>

			<xsl:apply-templates/>
		</fn>
	</xsl:template>

	<!-- footnotes for table's name rendering -->
	<xsl:template name="table_name_fn_display">
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
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

	<!-- figure's footnotes rendering -->
	<xsl:template name="fn_display_figure">

		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>

		<xsl:if test="xalan:nodeset($references)//fn">

			<xsl:variable name="key_iso">

			</xsl:variable>

			<!-- current hierarchy is 'figure' element -->
			<xsl:variable name="following_dl_colwidths">
				<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
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

						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					</xsl:variable>

					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="2"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>

				</xsl:if>
			</xsl:variable>

			<xsl:variable name="maxlength_dt">
				<xsl:for-each select="*[local-name() = 'dl'][1]">
					<xsl:call-template name="getMaxLength_dt"/>
				</xsl:for-each>
			</xsl:variable>

			<fo:block>
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
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="85%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline id="{@id}" xsl:use-attribute-sets="figure-fn-number-style">
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block xsl:use-attribute-sets="figure-fn-body-style">
											<xsl:if test="normalize-space($key_iso) = 'true'">

														<xsl:attribute name="margin-bottom">0</xsl:attribute>

											</xsl:if>
											<xsl:copy-of select="./node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>

	</xsl:template> <!-- fn_display_figure -->

	<!-- fn reference in the text rendering (for instance, 'some text 1) some text' ) -->
	<xsl:template match="*[local-name()='fn']">
		<fo:inline xsl:use-attribute-sets="fn-reference-style">

			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->

					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
						<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
					</xsl:attribute>

				<xsl:value-of select="@reference"/>

			</fo:basic-link>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='fn']/text()[normalize-space() != '']">
		<fo:inline><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='fn']//*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ===================== -->
	<!-- END Footnotes processing  -->
	<!-- ===================== -->

	<!-- ===================== -->
	<!-- Definition List -->
	<!-- ===================== -->
	<xsl:template match="*[local-name()='dl']">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<!-- <dl><xsl:copy-of select="."/></dl> -->
		<fo:block-container>

					<xsl:if test="not(ancestor::*[local-name() = 'quote'])">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>

			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

			</xsl:if>

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<fo:block-container margin-left="0mm">

						<xsl:attribute name="margin-right">0mm</xsl:attribute>

				<xsl:variable name="parent" select="local-name(..)"/>

				<xsl:variable name="key_iso">
					 <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>

				<xsl:variable name="onlyOneComponent" select="normalize-space($parent = 'formula' and count(*[local-name()='dt']) = 1)"/>

				<xsl:choose>
					<xsl:when test="$onlyOneComponent = 'true'"> <!-- only one component -->

								<fo:block margin-bottom="12pt" text-align="left">

									<xsl:variable name="title-where">
										<xsl:call-template name="getLocalizedString">
											<xsl:with-param name="key">where</xsl:with-param>
										</xsl:call-template>
									</xsl:variable>
									<xsl:value-of select="$title-where"/><xsl:text> </xsl:text>
									<xsl:apply-templates select="*[local-name()='dt']/*"/>
									<xsl:text/>
									<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
								</fo:block>

					</xsl:when> <!-- END: only one component -->
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">

							<xsl:variable name="title-where">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">where</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-where"/>
						</fo:block>
					</xsl:when>  <!-- END: a few components -->
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')"> <!-- definition list in a figure -->
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">

							<xsl:variable name="title-key">
								<xsl:call-template name="getLocalizedString">
									<xsl:with-param name="key">key</xsl:with-param>
								</xsl:call-template>
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>  <!-- END: definition list in a figure -->
				</xsl:choose>

				<!-- a few components -->
				<xsl:if test="$onlyOneComponent = 'false'">
					<fo:block>

						<xsl:if test="ancestor::*[local-name() = 'dd' or local-name() = 'td']">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>

						<fo:block>

							<xsl:apply-templates select="*[local-name() = 'name']">
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

											<xsl:variable name="dl_table">
												<tbody>
													<xsl:apply-templates mode="dl_if">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</tbody>
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
												<tbody>
													<xsl:apply-templates mode="dl">
														<xsl:with-param name="id" select="@id"/>
													</xsl:apply-templates>
												</tbody>
											</xsl:variable>

											<xsl:copy-of select="$dl_table"/>
										</xsl:variable>

										<xsl:variable name="colwidths">
											<xsl:call-template name="calculate-column-widths">
												<xsl:with-param name="cols-count" select="2"/>
												<xsl:with-param name="table" select="$simple-table"/>
											</xsl:call-template>
										</xsl:variable>

										<!-- <xsl:text disable-output-escaping="yes">&lt;!- -</xsl:text>
											DEBUG
											colwidths=<xsl:copy-of select="$colwidths"/>
										<xsl:text disable-output-escaping="yes">- -&gt;</xsl:text> -->

										<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->

										<xsl:variable name="maxlength_dt">
											<xsl:call-template name="getMaxLength_dt"/>
										</xsl:variable>

										<xsl:variable name="isContainsKeepTogetherTag_">
											false
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
			<xsl:apply-templates select="*[local-name() = 'dd']/*[local-name() = 'dl']"/>
		</xsl:if>

	</xsl:template> <!-- END: dl -->

	<xsl:template match="*[local-name() = 'dl']/*[local-name() = 'name']">
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
			<xsl:when test="xalan:nodeset($colwidths)/autolayout">
				<xsl:call-template name="insertTableColumnWidth">
					<xsl:with-param name="colwidths" select="$colwidths"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
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
			<xsl:for-each select="*[local-name()='dt']">
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
	<xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
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
					<xsl:apply-templates select="*[local-name() = 'name']" />
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
				<fo:block>
					<xsl:call-template name="note"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template> <!-- END: dl/note -->

	<!-- virtual html table for dl/[dt and dd]  -->
	<xsl:template match="*[local-name()='dt']" mode="dl">
		<xsl:param name="id"/>
		<xsl:variable name="row_number" select="count(preceding-sibling::*[local-name()='dt']) + 1"/>
		<tr>
			<td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'_',$row_number,'_1')"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</td>
			<td>
				<xsl:attribute name="id">
					<xsl:value-of select="concat($id,'_',$row_number,'_2')"/>
				</xsl:attribute>

						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]">
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>

			</td>
		</tr>

	</xsl:template>

	<!-- Definition's term -->
	<xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		<xsl:param name="split_keep-within-line"/>

		<fo:table-row xsl:use-attribute-sets="dt-row-style">
			<xsl:call-template name="insert_dt_cell">
				<xsl:with-param name="key_iso" select="$key_iso"/>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:call-template>
			<xsl:for-each select="following-sibling::*[local-name()='dd'][1]">
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

			<fo:block xsl:use-attribute-sets="dt-block-style">
				<xsl:copy-of select="@id"/>

				<xsl:if test="normalize-space($key_iso) = 'true'">
					<xsl:attribute name="margin-top">0</xsl:attribute>
				</xsl:if>

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

			<fo:block>

				<xsl:if test="$isGenerateTableIF = 'true'">
					<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				</xsl:if>

				<xsl:choose>
					<xsl:when test="$isGenerateTableIF = 'true'">
						<xsl:apply-templates> <!-- following-sibling::*[local-name()='dd'][1] -->
							<xsl:with-param name="process">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="."> <!-- following-sibling::*[local-name()='dd'][1] -->
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

	<xsl:template match="*[local-name()='dd']" mode="dl"/>
	<xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name()='dd']">
		<xsl:param name="process">false</xsl:param>
		<xsl:param name="split_keep-within-line"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates select="@language"/>
			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<!-- virtual html table for dl/[dt and dd] for IF (Intermediate Format) -->
	<xsl:template match="*[local-name()='dt']" mode="dl_if">
		<xsl:param name="id"/>
		<tr>
			<td>
				<xsl:copy-of select="node()"/>
			</td>
			<td>
				<xsl:copy-of select="following-sibling::*[local-name()='dd'][1]/node()[not(local-name() = 'dl')]"/>
				<!-- get paragraphs from nested 'dl' -->
				<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]/*[local-name() = 'dl']" mode="dl_if_nested"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="*[local-name()='dd']" mode="dl_if"/>

	<xsl:template match="*[local-name()='dl']" mode="dl_if_nested">
		<xsl:for-each select="*[local-name() = 'dt']">
			<p>
				<xsl:copy-of select="node()"/>
				<xsl:text> </xsl:text>
				<xsl:copy-of select="following-sibling::*[local-name()='dd'][1]/*[local-name() = 'p']/node()"/>
			</p>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="*[local-name()='dd']" mode="dl_if_nested"/>
	<!-- ===================== -->
	<!-- END Definition List -->
	<!-- ===================== -->

	<!-- ========================= -->
	<!-- Rich text formatting -->
	<!-- ========================= -->
	<xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<xsl:param name="split_keep-within-line"/>
		<fo:inline font-weight="bold">

			<xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}"> </fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name()='tt']">
		<fo:inline xsl:use-attribute-sets="tt-style">

			<xsl:variable name="_font-size">

				 <!-- 10 -->

					<xsl:choose>
						<xsl:when test="ancestor::*[local-name() = 'table']">8.5</xsl:when>
						<xsl:otherwise>9.5</xsl:otherwise>
					</xsl:choose>

			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
						<xsl:when test="ancestor::*[local-name()='note'] or ancestor::*[local-name()='example']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template> <!-- tt -->

	<xsl:variable name="regex_url_start">^(http://|https://|www\.)?(.*)</xsl:variable>
	<xsl:template match="*[local-name()='tt']/text()" priority="2">
		<xsl:choose>
			<xsl:when test="java:replaceAll(java:java.lang.String.new(.), '$2', '') != ''">
				 <!-- url -->
				<xsl:call-template name="add-zero-spaces-link-java"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="add_spaces_to_sourcecode"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- ================= -->
	<!-- Added,deleted text -->
	<!-- ================= -->
	<xsl:template match="*[local-name()='add']" name="tag_add">
		<xsl:param name="skip">true</xsl:param>
		<xsl:param name="block">false</xsl:param>
		<xsl:param name="type"/>
		<xsl:param name="text-align"/>
		<xsl:choose>
			<xsl:when test="starts-with(., $ace_tag)"> <!-- examples: ace-tag_A1_start, ace-tag_A2_end, C1_start, AC_start -->
				<xsl:choose>
					<xsl:when test="$skip = 'true' and       ((local-name(../..) = 'note' and not(preceding-sibling::node())) or       (local-name(..) = 'title' and preceding-sibling::node()[1][local-name() = 'tab']) or      local-name(..) = 'formattedref' and not(preceding-sibling::node()))      and       ../node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]"><!-- start tag displayed in template name="note" and title --></xsl:when>
					<xsl:otherwise>
						<xsl:variable name="tag">
							<xsl:call-template name="insertTag">
								<xsl:with-param name="type">
									<xsl:choose>
										<xsl:when test="$type = ''"><xsl:value-of select="substring-after(substring-after(., $ace_tag), '_')"/> <!-- start or end --></xsl:when>
										<xsl:otherwise><xsl:value-of select="$type"/></xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="kind" select="substring(substring-before(substring-after(., $ace_tag), '_'), 1, 1)"/> <!-- A or C -->
								<xsl:with-param name="value" select="substring(substring-before(substring-after(., $ace_tag), '_'), 2)"/> <!-- 1, 2, C -->
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
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-20%"><!-- alignment-baseline="middle" -->
				<xsl:attribute name="height">5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
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
				</svg>
			</fo:instream-foreign-object>
	</xsl:template>

	<xsl:template match="*[local-name()='del']">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>
	<!-- ================= -->
	<!-- END Added,deleted text -->
	<!-- ================= -->

	<!-- highlight text -->
	<xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline>
	</xsl:template>

	<xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div 0.75}%">
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
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

	<xsl:template match="*[local-name() = 'pagebreak']">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>

	<!-- Example: <span style="font-family:&quot;Noto Sans JP&quot;">styled text</span> -->
	<xsl:template match="*[local-name() = 'span'][@style]" priority="2">
		<xsl:variable name="styles__">
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="concat(@style,';')"/>
				<xsl:with-param name="sep" select="';'"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="quot">"</xsl:variable>
		<xsl:variable name="styles_">
			<xsl:for-each select="xalan:nodeset($styles__)/item">
				<xsl:variable name="key" select="normalize-space(substring-before(., ':'))"/>
				<xsl:variable name="value" select="normalize-space(substring-after(translate(.,$quot,''), ':'))"/>
				<xsl:if test="$key = 'font-family' or $key = 'color'">
					<style name="{$key}"><xsl:value-of select="$value"/></style>
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
	<xsl:template match="*[local-name() = 'span']">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ========================= -->
	<!-- END Rich text formatting -->
	<!-- ========================= -->

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
					<xsl:call-template name="enclose_text_in_tags">
						<xsl:with-param name="text" select="normalize-space($text)"/>
						<xsl:with-param name="tags" select="$tags"/>
					</xsl:call-template>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
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
				<xsl:element name="{$tag_name}">
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
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space, arrow right   -->
		<xsl:variable name="text1" select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| |→)','$1​')"/>
		<!-- add zero-width space (#x200B) after characters: 'great than' -->
		<xsl:variable name="text2" select="java:replaceAll(java:java.lang.String.new($text1), '(\u003e)(?!\u003e)', '$1​')"/><!-- negative lookahead: 'great than' not followed by 'great than' -->
		<!-- add zero-width space (#x200B) before characters: 'less than' -->
		<xsl:variable name="text3" select="java:replaceAll(java:java.lang.String.new($text2), '(?&lt;!\u003c)(\u003c)', '​$1')"/> <!-- (?<!\u003c)(\u003c) --> <!-- negative lookbehind: 'less than' not preceeded by 'less than' -->
		<!-- add zero-width space (#x200B) before character: { -->
		<xsl:variable name="text4" select="java:replaceAll(java:java.lang.String.new($text3), '(?&lt;!\W)(\{)', '​$1')"/> <!-- negative lookbehind: '{' not preceeded by 'punctuation char' -->
		<!-- add zero-width space (#x200B) after character: , -->
		<xsl:variable name="text5" select="java:replaceAll(java:java.lang.String.new($text4), '(\,)(?!\d)', '$1​')"/> <!-- negative lookahead: ',' not followed by digit -->

		<xsl:value-of select="$text5"/>
	</xsl:template>

	<xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>

		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$1')"/> <!-- http://. https:// or www. -->
		<xsl:variable name="url_continue" select="java:replaceAll(java:java.lang.String.new($text), $regex_url_start, '$2')"/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($url_continue),'(-|\.|:|=|_|—| |,|/)','$1​')"/>
	</xsl:template>

	<!-- add zero space after dash character (for table's entries) -->
	<xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">-</xsl:variable>
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space-after-underscore">_</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-underscore)">
				<xsl:value-of select="substring-before($text, $zero-space-after-underscore)"/>
				<xsl:value-of select="$zero-space-after-underscore"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-underscore)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

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
	</xsl:template>

	<!-- Table normalization (colspan,rowspan processing for adding TDs) for column width calculation -->
	<xsl:template name="getSimpleTable">
		<xsl:param name="id"/>

		<xsl:variable name="simple-table">

			<!-- Step 0. replace <br/> to <p>...</p> -->
			<xsl:variable name="table_without_br">
				<xsl:apply-templates mode="table-without-br"/>
			</xsl:variable>

			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates select="xalan:nodeset($table_without_br)" mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>

			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>

			<!-- Step 3: add id to each cell -->
			<!-- add <word>...</word> for each word, image, math -->
			<xsl:variable name="simple-table-id">
				<xsl:apply-templates select="xalan:nodeset($simple-table-rowspan)" mode="simple-table-id">
					<xsl:with-param name="id" select="$id"/>
				</xsl:apply-templates>
			</xsl:variable>

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

	<xsl:template match="*[local-name()='th' or local-name() = 'td'][not(*[local-name()='br']) and not(*[local-name()='p']) and not(*[local-name()='sourcecode'])]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<p>
				<xsl:copy-of select="node()"/>
			</p>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td'][*[local-name()='br']]" mode="table-without-br">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each select="*[local-name()='br']">
				<xsl:variable name="current_id" select="generate-id()"/>
				<p>
					<xsl:for-each select="preceding-sibling::node()[following-sibling::*[local-name() = 'br'][1][generate-id() = $current_id]][not(local-name() = 'br')]">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</p>
				<xsl:if test="not(following-sibling::*[local-name() = 'br'])">
					<p>
						<xsl:for-each select="following-sibling::node()">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</p>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'p'][*[local-name()='br']]" mode="table-without-br">
		<xsl:for-each select="*[local-name()='br']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<p>
				<xsl:for-each select="preceding-sibling::node()[following-sibling::*[local-name() = 'br'][1][generate-id() = $current_id]][not(local-name() = 'br')]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</p>
			<xsl:if test="not(following-sibling::*[local-name() = 'br'])">
				<p>
					<xsl:for-each select="following-sibling::node()">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</p>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'sourcecode']" mode="table-without-br">
		<xsl:apply-templates mode="table-without-br"/>
	</xsl:template>

	<xsl:template match="*[local-name()='th' or local-name()='td']/*[local-name() = 'sourcecode']/text()[contains(., '&#13;') or contains(., '&#10;')]" mode="table-without-br">

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
			<p>
				<sourcecode><xsl:copy-of select="node()"/></sourcecode>
			</p>
		</xsl:for-each>
	</xsl:template>

	<!-- remove redundant white spaces -->
	<xsl:template match="text()[not(ancestor::*[local-name() = 'sourcecode'])]" mode="table-without-br">
		<xsl:variable name="text" select="translate(.,'&#9;&#10;&#13;','')"/>
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),' {2,}',' ')"/>
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
	<xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/>

	<xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
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
				<xsl:element name="td">
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
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
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

	<xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]"/>
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>

		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
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
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]"/>
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

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow"/>
		</xsl:apply-templates>
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
				<xsl:value-of select="concat($id,'_',$row_number,'_',$col_number,'_',$divide)"/>
			</xsl:attribute>

			<xsl:for-each select="*[local-name() = 'p']">
				<xsl:copy>
					<xsl:copy-of select="@*"/>
					<xsl:variable name="p_num" select="count(preceding-sibling::*[local-name() = 'p']) + 1"/>
					<xsl:attribute name="id">
						<xsl:value-of select="concat($id,'_',$row_number,'_',$col_number,'_p_',$p_num,'_',$divide)"/>
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

				<xsl:variable name="words">
					<xsl:for-each select=".//*[local-name() = 'image' or local-name() = 'stem']">
						<word>
							<xsl:copy-of select="."/>
						</word>
					</xsl:for-each>

					<xsl:for-each select="xalan:nodeset($td_text)//*[local-name() = 'word'][normalize-space() != '']">
						<xsl:copy-of select="."/>
					</xsl:for-each>

				</xsl:variable>

				<xsl:for-each select="xalan:nodeset($words)/word">
					<xsl:variable name="num" select="count(preceding-sibling::word) + 1"/>
					<xsl:copy>
						<xsl:attribute name="id">
							<xsl:value-of select="concat($id,'_',$row_number,'_',$col_number,'_word_',$num,'_',$divide)"/>
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

	<xsl:template match="*[local-name() = 'stem' or local-name() = 'image']" mode="td_text_with_formatting"/>

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

	<xsl:template name="getFormattingTags">
		<tags>
			<xsl:if test="ancestor::*[local-name() = 'strong']"><tag>strong</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'em']"><tag>em</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sub']"><tag>sub</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sup']"><tag>sup</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'tt']"><tag>tt</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'sourcecode']"><tag>sourcecode</tag></xsl:if>
			<xsl:if test="ancestor::*[local-name() = 'keep-together_within-line']"><tag>keep-together_within-line</tag></xsl:if>
		</tags>
	</xsl:template>
	<!-- =============================== -->
	<!-- END mode="td_text_with_formatting" -->
	<!-- =============================== -->

	<xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
					<xsl:choose>
						<xsl:when test="$language_current_2 != ''">
							<xsl:value-of select="$language_current_2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="//*[local-name()='bibdata']//*[local-name()='language']"/>
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

	<!-- ======================================= -->
	<!-- math -->
	<!-- ======================================= -->
	<xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>

		<fo:inline xsl:use-attribute-sets="mathml-style">

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

	<xsl:template match="*[local-name() = 'asciimath']">
		<xsl:param name="process" select="'false'"/>
		<xsl:if test="$process = 'true'">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'latexmath']"/>

	<xsl:template name="getMathml_asciimath_text">
		<xsl:variable name="asciimath" select="../*[local-name() = 'asciimath']"/>
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

		<fo:instream-foreign-object fox:alt-text="Math">

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

			<xsl:copy-of select="xalan:nodeset($mathml)"/>

		</fo:instream-foreign-object>
	</xsl:template>

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

	<!-- Examples: 
		<stem type="AsciiMath">x = 1</stem> 
		<stem type="AsciiMath"><asciimath>x = 1</asciimath></stem>
		<stem type="AsciiMath"><asciimath>x = 1</asciimath><latexmath>x = 1</latexmath></stem>
	-->
	<xsl:template match="*[local-name() = 'stem'][@type = 'AsciiMath'][count(*) = 0]/text() | *[local-name() = 'stem'][@type = 'AsciiMath'][*[local-name() = 'asciimath']]" priority="3">
		<fo:inline xsl:use-attribute-sets="mathml-style">

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

	<xsl:template match="*[local-name()='localityStack']"/>

	<xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
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

			<xsl:if test="starts-with(normalize-space(@target), 'mailto:')">
				<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{$target}" fox:alt-text="{$target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<xsl:call-template name="add-zero-spaces-link-java">
									<xsl:with-param name="text" select="$target_text"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- output text from <link>text</link> -->
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template> <!-- link -->

	<!-- ======================== -->
	<!-- Appendix processing -->
	<!-- ======================== -->
	<xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(local-name()='title')]"/>
	</xsl:template>

	<xsl:template match="*[local-name()='appendix']/*[local-name()='title']" priority="2">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<fo:inline role="H{$level}"><xsl:apply-templates/></fo:inline>
	</xsl:template>
	<!-- ======================== -->
	<!-- END Appendix processing -->
	<!-- ======================== -->

	<xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
		</fo:block>
		<xsl:apply-templates select="node()[not(local-name()='name')]"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'callout']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link>
	</xsl:template>

	<xsl:template match="*[local-name() = 'annotation']">
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

	<xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'xref']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			<xsl:if test="parent::*[local-name() = 'add']">
				<xsl:call-template name="append_add-style"/>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template>

	<!-- ====== -->
	<!-- formula  -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

			</xsl:if>
			<fo:block-container margin-left="0mm">
				<fo:block id="{@id}">
					<xsl:apply-templates select="node()[not(local-name() = 'name')]"/> <!-- formula's number will be process in 'stem' template -->
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"> <!-- show in 'stem' template -->
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- stem inside formula with name (with formula's number) -->
	<xsl:template match="*[local-name() = 'formula'][*[local-name() = 'name']]/*[local-name() = 'stem']">
		<fo:block xsl:use-attribute-sets="formula-style">

			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-block-style">

								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block xsl:use-attribute-sets="formula-stem-number-style">
								<xsl:apply-templates select="../*[local-name() = 'name']"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>
		</fo:block>
	</xsl:template>

	<!-- stem inside formula without name (without formula's number) -->
	<xsl:template match="*[local-name() = 'formula'][not(*[local-name() = 'name'])]/*[local-name() = 'stem']">
		<fo:block xsl:use-attribute-sets="formula-style">
			<fo:block xsl:use-attribute-sets="formula-stem-block-style">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- note      -->
	<!-- termnote -->
	<!-- ====== -->

	<xsl:template match="*[local-name() = 'note']" name="note">

		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style">

				<xsl:if test="ancestor::ogc:ul or ancestor::ogc:ol and not(ancestor::ogc:note[1]/following-sibling::*)">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>

			<fo:block-container margin-left="0mm">

						<fo:block>

							<fo:inline xsl:use-attribute-sets="note-name-style">

								<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
								<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
								<xsl:if test="*[not(local-name()='name')][1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
									<xsl:call-template name="append_add-style"/>
								</xsl:if>

								<!-- if note contains only one element and first and last childs are `add` ace-tag, then move start ace-tag before NOTE's name-->
								<xsl:if test="count(*[not(local-name() = 'name')]) = 1 and *[not(local-name() = 'name')]/node()[last()][local-name() = 'add'][starts-with(text(), $ace_tag)]">
									<xsl:apply-templates select="*[not(local-name() = 'name')]/node()[1][local-name() = 'add'][starts-with(text(), $ace_tag)]">
										<xsl:with-param name="skip">false</xsl:with-param>
									</xsl:apply-templates>
								</xsl:if>

								<xsl:apply-templates select="*[local-name() = 'name']"/>

							</fo:inline>

							<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
						</fo:block>

			</fo:block-container>
		</fo:block-container>

	</xsl:template>

	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1"> <!-- display first NOTE's paragraph in the same line with label NOTE -->
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">

			<fo:inline xsl:use-attribute-sets="termnote-name-style">

				<xsl:if test="not(*[local-name() = 'name']/following-sibling::node()[1][self::text()][normalize-space()=''])">
					<xsl:attribute name="padding-right">1mm</xsl:attribute>
				</xsl:if>

				<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
				<!-- <xsl:if test="*[not(local-name()='name')][1][node()[normalize-space() != ''][1][local-name() = 'add'] and node()[normalize-space() != ''][last()][local-name() = 'add']]"> -->
				<xsl:if test="*[not(local-name()='name')][1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
					<xsl:call-template name="append_add-style"/>
				</xsl:if>

				<xsl:apply-templates select="*[local-name() = 'name']"/>

			</fo:inline>

			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>

						<xsl:text>:</xsl:text>

				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>
				</xsl:when>
				<xsl:otherwise>

						<xsl:text>:</xsl:text>

				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
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

	<!-- ====== -->
	<!-- term      -->
	<!-- ====== -->

	<xsl:template match="*[local-name() = 'terms']">
		<!-- <xsl:message>'terms' <xsl:number/> processing...</xsl:message> -->
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">

				<xsl:apply-templates select="ogc:name"/>

			<xsl:if test="parent::*[local-name() = 'term'] and not(preceding-sibling::*[local-name() = 'term'])">

			</xsl:if>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<xsl:variable name="level">
				<xsl:call-template name="getLevelTermName"/>
			</xsl:variable>
			<fo:inline role="H{$level}">
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- figure    -->
	<!-- image    -->
	<!-- ====== -->

	<xsl:template match="*[local-name() = 'figure']" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container id="{@id}">

			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>

			<fo:block xsl:use-attribute-sets="figure-style">
				<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="*[local-name() = 'note']">
				<xsl:call-template name="note"/>
			</xsl:for-each>

					<xsl:apply-templates select="*[local-name() = 'name']"/> <!-- show figure's name AFTER image -->

		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'image']">
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'title']">
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">

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
							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" xsl:use-attribute-sets="image-graphic-style">
								<xsl:if test="not(@mimetype = 'image/svg+xml') and ../*[local-name() = 'name'] and not(ancestor::*[local-name() = 'table'])">

									<xsl:variable name="img_src">
										<xsl:choose>
											<xsl:when test="not(starts-with(@src, 'data:'))"><xsl:value-of select="concat($basepath, @src)"/></xsl:when>
											<xsl:otherwise><xsl:value-of select="@src"/></xsl:otherwise>
										</xsl:choose>
									</xsl:variable>

									<xsl:variable name="scale" select="java:org.metanorma.fop.Util.getImageScale($img_src, $width_effective, $height_effective)"/>
									<xsl:if test="number($scale) &lt; 100">
										<xsl:attribute name="content-width"><xsl:value-of select="$scale"/>%</xsl:attribute>
									</xsl:if>

								</xsl:if>

							</fo:external-graphic>
						</xsl:otherwise>
					</xsl:choose>

				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'image']" mode="cross_image">
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
				<xsl:variable name="src">
					<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
				</xsl:variable>
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

	<xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image']) and *[local-name() = 'svg']]/*[local-name() = 'name']/*[local-name() = 'bookmark']" priority="2"/>
	<xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image'])]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>

		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>

		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../*[local-name() = 'name']) != ''">
					<xsl:value-of select="../*[local-name() = 'name']"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

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
											<xsl:if test="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
												<fo:block line-height="0" font-size="0">
													<xsl:for-each select="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
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
				<fo:block xsl:use-attribute-sets="image-style">
					<fo:instream-foreign-object fox:alt-text="{$alt-text}">
						<xsl:attribute name="width">100%</xsl:attribute>
						<xsl:attribute name="content-height">100%</xsl:attribute>
						<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
						<xsl:variable name="svg_width" select="xalan:nodeset($svg_content)/*/@width"/>
						<xsl:variable name="svg_height" select="xalan:nodeset($svg_content)/*/@height"/>
						<!-- effective height 297 - 27.4 - 13 =  256.6 -->
						<!-- effective width 210 - 12.5 - 25 = 172.5 -->
						<!-- effective height / width = 1.48, 1.4 - with title -->
						<xsl:if test="$svg_height &gt; ($svg_width * 1.4)"> <!-- for images with big height -->
							<xsl:variable name="width" select="(($svg_width * 1.4) div $svg_height) * 100"/>
							<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="scaling">uniform</xsl:attribute>
						<xsl:copy-of select="$svg_content"/>
					</fo:instream-foreign-object>
				</fo:block>
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

	<xsl:template match="*[local-name() = 'image']/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template>

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
			<xsl:variable name="width" select="normalize-space($viewbox//item[3])"/>
			<xsl:variable name="height" select="normalize-space($viewbox//item[4])"/>

			<xsl:attribute name="width">
				<xsl:choose>
					<xsl:when test="$width != ''">
						<xsl:value-of select="round($width)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default width -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:choose>
					<xsl:when test="$height != ''">
						<xsl:value-of select="round($height)"/>
					</xsl:when>
					<xsl:otherwise>400</xsl:otherwise> <!-- default height -->
				</xsl:choose>
			</xsl:attribute>

			<xsl:apply-templates mode="svg_update"/>
		</xsl:copy>
	</xsl:template>
	<!-- ============== -->
	<!-- END: svg_update -->
	<!-- ============== -->

	<!-- image with svg and emf -->
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][*[local-name() = 'svg']]" priority="3">
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="*[local-name() = 'svg']">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
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
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 0]">
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
			<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
				<fo:inline-container inline-progression-dimension="100%">
					<fo:block-container height="{$height - 1}px" width="100%">
						<!-- DEBUG <xsl:if test="local-name()='polygon'">
							<xsl:attribute name="background-color">magenta</xsl:attribute>
						</xsl:if> -->
					<fo:block> </fo:block></fo:block-container>
				</fo:inline-container>
			</fo:basic-link>
		 </fo:block>
	  </fo:block-container>
	</xsl:template>
	<!-- =================== -->
	<!-- End SVG images processing -->
	<!-- =================== -->

	<!-- ignore emf processing (Apache FOP doesn't support EMF) -->
	<xsl:template match="*[local-name() = 'emf']"/>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name'] |               *[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement' or local-name() = 'sourcecode']/*[local-name() = 'name']//text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- special case: ignore preface/section-title and sections/section-title without @displayorder  -->
	<xsl:template match="*[local-name() = 'preface' or local-name() = 'sections']/*[local-name() = 'p'][@type = 'section-title' and not(@displayorder)]" priority="3" mode="contents"/>
	<!-- process them by demand (mode="contents_no_displayorder") -->
	<xsl:template match="*[local-name() = 'p'][@type = 'section-title' and not(@displayorder)]" mode="contents_no_displayorder">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'p'][@type = 'section-title']" mode="contents_in_clause">
		<xsl:call-template name="contents_section-title"/>
	</xsl:template>

	<!-- special case: ignore section-title if @depth different than @depth of parent clause, or @depth of parent clause = 1 -->
	<xsl:template match="*[local-name() = 'clause']/*[local-name() = 'p'][@type = 'section-title' and (@depth != ../*[local-name() = 'title']/@depth or ../*[local-name() = 'title']/@depth = 1)]" priority="3" mode="contents"/>

	<xsl:template match="*[local-name() = 'p'][@type = 'floating-title' or @type = 'section-title']" priority="2" name="contents_section-title" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="section">
			<xsl:choose>
				<xsl:when test="@type = 'section-title'"/>
				<xsl:otherwise>
					<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
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
					<xsl:when test="*[local-name() = 'tab']">
						<xsl:choose>
							<xsl:when test="@type = 'section-title'">
								<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
								<xsl:text>: </xsl:text>
								<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:copy-of select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="node()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="root">
				<xsl:if test="ancestor-or-self::*[local-name() = 'preface']">preface</xsl:if>
				<xsl:if test="ancestor-or-self::*[local-name() = 'annex']">annex</xsl:if>
			</xsl:variable>

			<item id="{@id}" level="{$level}" section="{$section}" type="{$type}" root="{$root}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
			</item>
		</xsl:if>
	</xsl:template>

	<xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'title' or local-name() = 'name']//*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/>

	<xsl:template match="*[local-name() = 'references']/*[local-name() = 'bibitem']" mode="contents"/>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template>

	<!-- Bookmarks -->
	<xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="$contents_nodes/doc">
						<xsl:choose>
							<xsl:when test="count($contents_nodes/doc) &gt; 1">
								<xsl:for-each select="$contents_nodes/doc">
									<fo:bookmark internal-destination="{contents/item[1]/@id}" starting-state="hide">
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

										<xsl:apply-templates select="contents/item" mode="bookmark"/>

										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="contents"/>
										</xsl:call-template>

										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>

									</fo:bookmark>

								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="$contents_nodes/doc">

									<xsl:apply-templates select="contents/item" mode="bookmark"/>

									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="contents"/>
									</xsl:call-template>

									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>

								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="$contents_nodes/contents/item" mode="bookmark"/>

						<xsl:call-template name="insertFigureBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/contents"/>
						</xsl:call-template>

						<xsl:call-template name="insertTableBookmarks">
							<xsl:with-param name="contents" select="$contents_nodes/contents"/>
							<xsl:with-param name="lang" select="@lang"/>
						</xsl:call-template>

					</xsl:otherwise>
				</xsl:choose>

					<xsl:if test="$contents//tables/table or $contents//figures/figure or //*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']]">
						<fo:bookmark internal-destination="empty_bookmark">
							<fo:bookmark-title>—————</fo:bookmark-title>
						</fo:bookmark>
					</xsl:if>

					<xsl:if test="$contents//tables/table">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
							<fo:bookmark-title>
								<xsl:value-of select="$title-list-tables"/>
							</fo:bookmark-title>
							<xsl:for-each select="$contents//tables/table">
								<fo:bookmark internal-destination="{@id}">
									<xsl:variable name="title">
										<xsl:apply-templates select="*[local-name() = 'name']" mode="bookmarks"/>
									</xsl:variable>
									<fo:bookmark-title><xsl:value-of select="$title"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>

					<xsl:if test="$contents//figures/figure">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
							<fo:bookmark-title>
								<xsl:value-of select="$title-list-figures"/>
							</fo:bookmark-title>
							<xsl:for-each select="$contents//figures/figure">
								<fo:bookmark internal-destination="{@id}">
									<xsl:variable name="title">
										<xsl:apply-templates select="*[local-name() = 'name']" mode="bookmarks"/>
									</xsl:variable>
									<fo:bookmark-title><xsl:value-of select="$title"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>

					<xsl:if test="//*[local-name() = 'table'][.//*[local-name() = 'p'][@class = 'RecommendationTitle']]">
						<fo:bookmark internal-destination="empty_bookmark" starting-state="hide">
							<fo:bookmark-title>
								<xsl:value-of select="$title-list-recommendations"/>
							</fo:bookmark-title>
							<xsl:for-each select="xalan:nodeset($toc_recommendations)/*">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:value-of select="bookmark"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>
					</xsl:if>
					<!-- $namespace = 'ogc' -->

			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template>

	<xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/figure">
			<fo:bookmark internal-destination="{$contents_nodes/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>

		<!-- see template addBookmarks -->
	</xsl:template> <!-- insertFigureBookmarks -->

	<xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:variable name="contents_nodes" select="xalan:nodeset($contents)"/>
		<xsl:if test="$contents_nodes/table">
			<fo:bookmark internal-destination="{$contents_nodes/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="$contents_nodes/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>
		</xsl:if>

		<!-- see template addBookmarks -->
	</xsl:template> <!-- insertTableBookmarks -->
	<!-- End Bookmarks -->

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

	<xsl:template match="item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/>
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="normalize-space(title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="title" mode="bookmark"/>
	<xsl:template match="text()" mode="bookmark"/>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |         *[local-name() = 'image']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="figure-name-style">

				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/>
	<xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/>

	<!-- ====== -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template>

	<xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="insertTitleAsListItem">
		<xsl:param name="provisional-distance-between-starts" select="'9.5mm'"/>
		<xsl:variable name="section">
			<xsl:for-each select="..">
				<xsl:call-template name="getSection"/>
			</xsl:for-each>
		</xsl:variable>
		<fo:list-block provisional-distance-between-starts="{$provisional-distance-between-starts}">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:value-of select="$section"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
								<xsl:apply-templates select="following-sibling::*[1][local-name() = 'variant-title'][@type = 'sub']" mode="subtitle"/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>

	<xsl:template name="extractSection">
		<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template>

	<xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'fn']" mode="contents"/>
	<xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/>

	<xsl:template match="*[local-name() = 'fn']" mode="contents_item"/>

	<xsl:template match="*[local-name() = 'xref'] | *[local-name() = 'eref']" mode="contents">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'review']" mode="contents_item"/>

	<xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'em']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'sub']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'sup']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'stem']" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'name']" mode="contents_item">
		<xsl:param name="mode">bookmarks</xsl:param>
		<xsl:apply-templates mode="contents_item">
			<xsl:with-param name="mode" select="$mode"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*[local-name() = 'add']" mode="contents_item">
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
		<xsl:call-template name="keep_together_standard_number"/>
	</xsl:template>

	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
	</xsl:template>

	<!-- =============== -->
	<!-- sourcecode  -->
	<!-- =============== -->
	<xsl:template match="*[local-name()='sourcecode']" name="sourcecode">

		<xsl:variable name="sourcecode_attributes">
			<xsl:element name="sourcecode_attributes" use-attribute-sets="sourcecode-style">
				<xsl:variable name="_font-size">

					<!-- 9 -->

					<!-- <xsl:if test="$namespace = 'ieee'">							
						<xsl:if test="$current_template = 'standard'">8</xsl:if>
					</xsl:if> -->

						<xsl:choose>
							<xsl:when test="ancestor::*[local-name() = 'table']">8.5</xsl:when>
							<xsl:otherwise>9.5</xsl:otherwise>
						</xsl:choose>

				</xsl:variable>

				<xsl:variable name="font-size" select="normalize-space($_font-size)"/>
				<xsl:if test="$font-size != ''">
					<xsl:attribute name="font-size">
						<xsl:choose>
							<xsl:when test="$font-size = 'inherit'"><xsl:value-of select="$font-size"/></xsl:when>
							<xsl:when test="contains($font-size, '%')"><xsl:value-of select="$font-size"/></xsl:when>
							<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
							<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
			</xsl:element>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$isGenerateTableIF = 'true' and (ancestor::*[local-name() = 'td'] or ancestor::*[local-name() = 'th'])">
				<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
					<xsl:attribute name="{local-name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
			</xsl:when>

			<xsl:otherwise>
				<fo:block-container xsl:use-attribute-sets="sourcecode-container-style">

					<xsl:if test="not(ancestor::*[local-name() = 'li']) or ancestor::*[local-name() = 'example']">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
					</xsl:if>

					<xsl:if test="ancestor::*[local-name() = 'example']">
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>

					<xsl:copy-of select="@id"/>

					<xsl:if test="parent::*[local-name() = 'note']">
						<xsl:attribute name="margin-left">
							<xsl:choose>
								<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

					</xsl:if>
					<fo:block-container margin-left="0mm">

							<xsl:if test="parent::*[local-name() = 'example']">
								<fo:block font-size="1pt" line-height="10%" space-after="4pt"> </fo:block>
							</xsl:if>

						<fo:block xsl:use-attribute-sets="sourcecode-style">

							<xsl:for-each select="xalan:nodeset($sourcecode_attributes)/sourcecode_attributes/@*">
								<xsl:attribute name="{local-name()}">
									<xsl:value-of select="."/>
								</xsl:attribute>
							</xsl:for-each>

								<xsl:if test="parent::*[local-name() = 'example']">
									<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
								</xsl:if>

							<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
						</fo:block>

								<xsl:apply-templates select="*[local-name()='name']"/> <!-- show sourcecode's name AFTER content -->

							<xsl:if test="parent::*[local-name() = 'example']">
								<fo:block font-size="1pt" line-height="10%" space-before="6pt"> </fo:block>
							</xsl:if>

					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='sourcecode']/text()" priority="2">
		<xsl:choose>
			<xsl:when test="normalize-space($syntax-highlight) = 'true' and normalize-space(../@lang) != ''"> <!-- condition for turn on of highlighting -->
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

	<!-- insert 'char' between each character in the string -->
	<xsl:template name="interspers">
		<xsl:param name="str"/>
		<xsl:param name="char" select="$zero_width_space"/>
		<xsl:if test="$str != ''">
			<xsl:value-of select="substring($str, 1, 1)"/>

			<xsl:variable name="next_char" select="substring($str, 2, 1)"/>
			<xsl:if test="not(contains(concat(' -.:=_— ', $char), $next_char))">
				<xsl:value-of select="$char"/>
			</xsl:if>

			<xsl:call-template name="interspers">
				<xsl:with-param name="str" select="substring($str, 2)"/>
				<xsl:with-param name="char" select="$char"/>
			</xsl:call-template>
		</xsl:if>
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

			<xsl:for-each select="$classes/item">
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

	<xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>
	<!-- =============== -->
	<!-- END sourcecode  -->
	<!-- =============== -->

	<!-- =============== -->
	<!-- pre  -->
	<!-- =============== -->
	<xsl:template match="*[local-name()='pre']" name="pre">
		<fo:block xsl:use-attribute-sets="pre-style">
			<xsl:copy-of select="@id"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- =============== -->
	<!-- pre  -->
	<!-- =============== -->

	<!-- ========== -->
	<!-- permission -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>

					<xsl:text>:</xsl:text>

			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- requirement -->
<!-- ========== -->
	<xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="*[local-name()='label']"/>
			<xsl:apply-templates select="@obligation"/>
			<xsl:apply-templates select="*[local-name()='subject']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name') and not(local-name() = 'label') and not(local-name() = 'subject')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']">
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

	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'requirement']/@obligation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" priority="2">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- ========== -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- recommendation -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>

			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END recommendation -->
	<!-- ========== -->

	<!-- ========== -->
	<!-- ========== -->

	<xsl:template match="*[local-name() = 'subject']">
		<fo:block xsl:use-attribute-sets="subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'inherit'] | *[local-name() = 'component'][@class = 'inherit'] |           *[local-name() = 'div'][@type = 'requirement-inherit'] |           *[local-name() = 'div'][@type = 'recommendation-inherit'] |           *[local-name() = 'div'][@type = 'permission-inherit']">
		<fo:block xsl:use-attribute-sets="inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'description'] | *[local-name() = 'component'][@class = 'description'] |           *[local-name() = 'div'][@type = 'requirement-description'] |           *[local-name() = 'div'][@type = 'recommendation-description'] |           *[local-name() = 'div'][@type = 'permission-description']">
		<fo:block xsl:use-attribute-sets="description-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'specification'] | *[local-name() = 'component'][@class = 'specification'] |           *[local-name() = 'div'][@type = 'requirement-specification'] |           *[local-name() = 'div'][@type = 'recommendation-specification'] |           *[local-name() = 'div'][@type = 'permission-specification']">
		<fo:block xsl:use-attribute-sets="specification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'measurement-target'] | *[local-name() = 'component'][@class = 'measurement-target'] |           *[local-name() = 'div'][@type = 'requirement-measurement-target'] |           *[local-name() = 'div'][@type = 'recommendation-measurement-target'] |           *[local-name() = 'div'][@type = 'permission-measurement-target']">
		<fo:block xsl:use-attribute-sets="measurement-target-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'verification'] | *[local-name() = 'component'][@class = 'verification'] |           *[local-name() = 'div'][@type = 'requirement-verification'] |           *[local-name() = 'div'][@type = 'recommendation-verification'] |           *[local-name() = 'div'][@type = 'permission-verification']">
		<fo:block xsl:use-attribute-sets="verification-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'import'] | *[local-name() = 'component'][@class = 'import'] |           *[local-name() = 'div'][@type = 'requirement-import'] |           *[local-name() = 'div'][@type = 'recommendation-import'] |           *[local-name() = 'div'][@type = 'permission-import']">
		<fo:block xsl:use-attribute-sets="import-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'div'][starts-with(@type, 'requirement-component')] |           *[local-name() = 'div'][starts-with(@type, 'recommendation-component')] |           *[local-name() = 'div'][starts-with(@type, 'permission-component')]">
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
	<xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">
						<xsl:call-template name="getSimpleTable">
							<xsl:with-param name="id" select="@id"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
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
					<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
						<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
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

			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
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

			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt">

				<!-- <xsl:attribute name="color"><xsl:value-of select="$color_design"/></xsl:attribute> -->
				<xsl:attribute name="color">white</xsl:attribute>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<!-- ========== -->
	<!-- END requirement, recommendation, permission table -->
	<!-- ========== -->

	<!-- ====== -->
	<!-- termexample -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">
			<xsl:apply-templates select="*[local-name()='name']"/>
			<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
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
	<xsl:template match="*[local-name() = 'example']">

		<fo:block-container id="{@id}" xsl:use-attribute-sets="example-style">

			<xsl:variable name="fo_element">
				<xsl:if test=".//*[local-name() = 'table'] or .//*[local-name() = 'dl'] or *[not(local-name() = 'name')][1][local-name() = 'sourcecode']">block</xsl:if>
				inline
			</xsl:variable>

			<fo:block-container margin-left="0mm">

				<xsl:choose>

					<xsl:when test="contains(normalize-space($fo_element), 'block')">

						<!-- display name 'EXAMPLE' in a separate block  -->
						<fo:block>
							<xsl:apply-templates select="*[local-name()='name']">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
						</fo:block>

						<fo:block-container xsl:use-attribute-sets="example-body-style">
							<fo:block-container margin-left="0mm" margin-right="0mm">
								<xsl:apply-templates select="node()[not(local-name() = 'name')]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:block-container>
						</fo:block-container>
					</xsl:when> <!-- end block -->

					<xsl:otherwise> <!-- inline -->

						<!-- display 'EXAMPLE' and first element in the same line -->
						<fo:block>
							<xsl:apply-templates select="*[local-name()='name']">
								<xsl:with-param name="fo_element" select="$fo_element"/>
							</xsl:apply-templates>
							<fo:inline>
								<xsl:apply-templates select="*[not(local-name() = 'name')][1]">
									<xsl:with-param name="fo_element" select="$fo_element"/>
								</xsl:apply-templates>
							</fo:inline>
						</fo:block>

						<xsl:if test="*[not(local-name() = 'name')][position() &gt; 1]">
							<!-- display further elements in blocks -->
							<fo:block-container xsl:use-attribute-sets="example-body-style">
								<fo:block-container margin-left="0mm" margin-right="0mm">
									<xsl:apply-templates select="*[not(local-name() = 'name')][position() &gt; 1]">
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

	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
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
					<xsl:apply-templates/>: 
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:param name="fo_element">block</xsl:param>

		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">

			<xsl:value-of select="$fo_element"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with(normalize-space($element), 'block')">
				<fo:block-container>
					<xsl:if test="ancestor::*[local-name() = 'li'] and contains(normalize-space($fo_element), 'block')">
						<xsl:attribute name="margin-left">0mm</xsl:attribute>
						<xsl:attribute name="margin-right">0mm</xsl:attribute>
					</xsl:if>
					<fo:block xsl:use-attribute-sets="example-p-style">

						<xsl:apply-templates/>
					</fo:block>
				</fo:block-container>
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

	<!-- ====== -->
	<!-- termsource -->
	<!-- origin -->
	<!-- modification -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'termsource']" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">

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
							<xsl:when test="$document_type = 'PAS' and starts-with(*[local-name() = 'origin']/@citeas, '[')"><xsl:text>{</xsl:text></xsl:when>
							<xsl:otherwise><xsl:text>[</xsl:text></xsl:otherwise>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="$namespace = 'gb' or $namespace = 'iso' or $namespace = 'iec' or $namespace = 'itu' or $namespace = 'unece' or $namespace = 'unece-rec' or $namespace = 'nist-cswp'  or $namespace = 'nist-sp' or $namespace = 'ogc-white-paper' or $namespace = 'csa' or $namespace = 'csd' or $namespace = 'm3d' or $namespace = 'iho' or $namespace = 'bipm' or $namespace = 'jcgm'">
						<xsl:text>[</xsl:text>
					</xsl:if>
					<xsl:copy-of select="$termsource_text"/>
					<xsl:if test="$namespace = 'bsi'">
						<xsl:choose>
							<xsl:when test="$document_type = 'PAS' and starts-with(*[local-name() = 'origin']/@citeas, '[')"><xsl:text>}</xsl:text></xsl:when>
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

	<xsl:template match="*[local-name() = 'termsource']/text()[starts-with(., '[SOURCE: Adapted from: ') or     starts-with(., '[SOURCE: Quoted from: ') or     starts-with(., '[SOURCE: Modified from: ')]" priority="2">
		<xsl:text>[</xsl:text><xsl:value-of select="substring-after(., '[SOURCE: ')"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template>

	<!-- text SOURCE: -->
	<xsl:template match="*[local-name() = 'termsource']/*[local-name() = 'strong'][1][following-sibling::*[1][local-name() = 'origin']]/text()">
		<fo:inline xsl:use-attribute-sets="termsource-text-style">
			<xsl:value-of select="."/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'origin']">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:if test="normalize-space(@citeas) = ''">
				<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
			</xsl:if>
			<fo:inline xsl:use-attribute-sets="origin-style">
				<xsl:apply-templates/>
			</fo:inline>
		</fo:basic-link>
	</xsl:template>

	<!-- not using, see https://github.com/glossarist/iev-document/issues/23 -->
	<xsl:template match="*[local-name() = 'modification']">
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

	<xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<!-- <xsl:value-of select="."/> -->
			<xsl:call-template name="text"/>
		</xsl:if>
	</xsl:template>

	<!-- ====== -->
	<!-- ====== -->

	<!-- ====== -->
	<!-- qoute -->
	<!-- source -->
	<!-- author  -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'quote']">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<fo:block-container margin-left="0mm">
				<fo:block-container xsl:use-attribute-sets="quote-style">

					<fo:block-container margin-left="0mm" margin-right="0mm">
						<fo:block role="BlockQuote">
							<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
						</fo:block>
					</fo:block-container>
				</fo:block-container>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>
					</fo:block>
				</xsl:if>

			</fo:block-container>
		</fo:block-container>
	</xsl:template>

	<xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template>

	<xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->

	<xsl:variable name="bibitems_">
		<xsl:for-each select="//*[local-name() = 'bibitem']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems" select="xalan:nodeset($bibitems_)"/>

	<!-- get all hidden bibitems to exclude them from eref/origin processing -->
	<xsl:variable name="bibitems_hidden_">
		<xsl:for-each select="//*[local-name() = 'bibitem'][@hidden='true']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
		<xsl:for-each select="//*[local-name() = 'references'][@hidden='true']//*[local-name() = 'bibitem']">
			<xsl:copy-of select="."/>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="bibitems_hidden" select="xalan:nodeset($bibitems_hidden_)"/>
	<!-- ====== -->
	<!-- eref -->
	<!-- ====== -->
	<xsl:template match="*[local-name() = 'eref']" name="eref">
		<xsl:variable name="current_bibitemid" select="@bibitemid"/>
		<!-- <xsl:variable name="external-destination" select="normalize-space(key('bibitems', $current_bibitemid)/*[local-name() = 'uri'][@type = 'citation'])"/> -->
		<xsl:variable name="external-destination" select="normalize-space($bibitems/*[local-name() ='bibitem'][@id = $current_bibitemid]/*[local-name() = 'uri'][@type = 'citation'])"/>
		<xsl:choose>
			<!-- <xsl:when test="$external-destination != '' or not(key('bibitems_hidden', $current_bibitemid))"> --> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
			<xsl:when test="$external-destination != '' or not($bibitems_hidden/*[local-name() ='bibitem'][@id = $current_bibitemid])"> <!-- if in the bibliography there is the item with @bibitemid (and not hidden), then create link (internal to the bibitem or external) -->
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
						<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
						<xsl:attribute name="vertical-align">super</xsl:attribute>
						<xsl:attribute name="font-size">80%</xsl:attribute>

					</xsl:if>

					<xsl:variable name="citeas" select="java:replaceAll(java:java.lang.String.new(@citeas),'^\[?(.+?)\]?$','$1')"/> <!-- remove leading and trailing brackets -->
					<xsl:variable name="text" select="normalize-space()"/>

					<fo:basic-link fox:alt-text="{@citeas}">
						<xsl:if test="normalize-space(@citeas) = ''">
							<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
						</xsl:if>
						<xsl:if test="@type = 'inline'">

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

				</fo:inline>
			</xsl:when>
			<xsl:otherwise> <!-- if there is key('bibitems_hidden', $current_bibitemid) -->

				<!-- if in bibitem[@hidden='true'] there is url[@type='src'], then create hyperlink  -->
				<xsl:variable name="uri_src" select="normalize-space($bibitems_hidden/*[local-name() ='bibitem'][@id = $current_bibitemid]/*[local-name() = 'uri'][@type = 'src'])"/>
				<xsl:choose>
					<xsl:when test="$uri_src != ''">
						<fo:basic-link external-destination="{$uri_src}" fox:alt-text="{$uri_src}"><xsl:apply-templates/></fo:basic-link>
					</xsl:when>
					<xsl:otherwise><fo:inline><xsl:apply-templates/></fo:inline></xsl:otherwise>
				</xsl:choose>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ====== -->
	<!-- END eref -->
	<!-- ====== -->

	<!-- Tabulation processing -->
	<xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:variable name="padding">

				<xsl:choose>
					<xsl:when test="$depth = 2">2</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
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
				<fo:inline><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm"><xsl:value-of select="$direction"/>​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template> <!-- tab -->

	<xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Preferred, admitted, deprecated -->
	<xsl:template match="*[local-name() = 'preferred']">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			inherit
		</xsl:variable>
		<xsl:variable name="levelTerm">
			<xsl:call-template name="getLevelTermName"/>
		</xsl:variable>
		<fo:block font-size="{normalize-space($font-size)}" role="H{$levelTerm}" xsl:use-attribute-sets="preferred-block-style">

			<xsl:if test="parent::*[local-name() = 'term'] and not(preceding-sibling::*[local-name() = 'preferred'])"> <!-- if first preffered in term, then display term's name -->
				<fo:block xsl:use-attribute-sets="term-name-style">
					<xsl:apply-templates select="ancestor::*[local-name() = 'term'][1]/*[local-name() = 'name']"/>
				</fo:block>
			</xsl:if>

			<fo:block xsl:use-attribute-sets="preferred-term-style">
				<xsl:call-template name="setStyle_preferred"/>
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'deprecates']">
		<xsl:variable name="title-deprecated">
			<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">deprecated</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:value-of select="$title-deprecated"/>: <xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template name="setStyle_preferred">
		<xsl:if test="*[local-name() = 'strong']">
			<xsl:attribute name="font-weight">normal</xsl:attribute>
		</xsl:if>
	</xsl:template>

	<!-- regarding ISO 10241-1:2011,  If there is more than one preferred term, each preferred term follows the previous one on a new line. -->
	<!-- in metanorma xml preferred terms delimited by semicolons -->
	<xsl:template match="*[local-name() = 'preferred']/text()[contains(., ';')] | *[local-name() = 'preferred']/*[local-name() = 'strong']/text()[contains(., ';')]">
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.), ';', $linebreak)"/>
	</xsl:template>
	<!--  End Preferred, admitted, deprecated -->

	<!-- ========== -->
	<!-- definition -->
	<!-- ========== -->
	<xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p'][1]">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block/>
	</xsl:template>
	<!-- ========== -->
	<!-- END definition -->
	<!-- ========== -->

	<!-- main sections -->
	<xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">

		<fo:block>
			<xsl:call-template name="setId"/>

				<xsl:variable name="pos"><xsl:number count="ogc:sections/ogc:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | ogc:sections/ogc:terms -->
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>

			<xsl:apply-templates/>
		</fo:block>

	</xsl:template>

	<xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:call-template name="setId"/>

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">

		</fo:block>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'review']"> <!-- 'review' will be processed in mn2pdf/review.xsl -->
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->

		<xsl:variable name="id_from" select="normalize-space(current()/@from)"/>

		<xsl:choose>
			<!-- if there isn't the attribute '@from', then -->
			<xsl:when test="$id_from = ''">
				<fo:block id="{@id}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
			<!-- if there isn't element with id 'from', then create 'bookmark' here -->
			<xsl:when test="not(ancestor::*[contains(local-name(), '-standard')]//*[@id = $id_from])">
				<fo:block id="{@from}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:block>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template>

	<!-- ===================================== -->
	<!-- Lists processing -->
	<!-- ===================================== -->
	<xsl:variable name="ul_labels_">

				<label color="{$color_design}">•</label>

	</xsl:variable>
	<xsl:variable name="ul_labels" select="xalan:nodeset($ul_labels_)"/>

	<xsl:template name="setULLabel">
		<xsl:variable name="list_level_" select="count(ancestor::*[local-name() = 'ul']) + count(ancestor::*[local-name() = 'ol'])"/>
		<xsl:variable name="list_level">
			<xsl:choose>
				<xsl:when test="$list_level_ &lt;= 3"><xsl:value-of select="$list_level_"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$list_level_ mod 3"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$ul_labels/label[not(@level)]"> <!-- one label for all levels -->
				<xsl:apply-templates select="$ul_labels/label[not(@level)]" mode="ul_labels"/>
			</xsl:when>
			<xsl:when test="$list_level mod 3 = 0">
				<xsl:apply-templates select="$ul_labels/label[@level = 3]" mode="ul_labels"/>
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
					<xsl:otherwise><xsl:call-template name="setULLabel"/></xsl:otherwise>
				</xsl:choose>
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

							<xsl:variable name="list_level_" select="count(ancestor::*[local-name() = 'ul']) + count(ancestor::*[local-name() = 'ol'])"/>
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
						<xsl:when test="$type = 'arabic'">
							1.
						</xsl:when>
						<xsl:when test="$type = 'alphabet'">
							a)
						</xsl:when>
						<xsl:when test="$type = 'alphabet_upper'">
							A)
						</xsl:when>
						<xsl:when test="$type = 'roman'">
							i)
						</xsl:when>
						<xsl:when test="$type = 'roman_upper'">I.</xsl:when>
						<xsl:otherwise>1.</xsl:otherwise> <!-- for any case, if $type has non-determined value, not using -->
					</xsl:choose>
				</xsl:variable>

				<xsl:number value="$start_value + $curr_value" format="{normalize-space($format)}" lang="en"/>

			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note'] or parent::*[local-name() = 'termnote']">
				<fo:block-container>
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>

					<fo:block-container margin-left="0mm">
						<fo:block>
							<xsl:apply-templates select="." mode="list"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates select="." mode="list"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="*[local-name()='ul'] | *[local-name()='ol']" mode="list" name="list">

		<xsl:apply-templates select="*[local-name() = 'name']">
			<xsl:with-param name="process">true</xsl:with-param>
		</xsl:apply-templates>

		<fo:list-block xsl:use-attribute-sets="list-style">

			<xsl:if test="*[local-name() = 'name']">
				<xsl:attribute name="margin-top">0pt</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="node()[not(local-name() = 'note')]"/>
		</fo:list-block>
		<!-- <xsl:for-each select="./iho:note">
			<xsl:call-template name="note"/>
		</xsl:for-each> -->
		<xsl:apply-templates select="./*[local-name() = 'note']"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'ol' or local-name() = 'ul']/*[local-name() = 'name']">
		<xsl:param name="process">false</xsl:param>
		<xsl:if test="$process = 'true'">
			<fo:block xsl:use-attribute-sets="list-name-style">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name()='li']">
		<fo:list-item xsl:use-attribute-sets="list-item-style">
			<xsl:copy-of select="@id"/>

			<fo:list-item-label end-indent="label-end()">
				<fo:block xsl:use-attribute-sets="list-item-label-style">

					<!-- if 'p' contains all text in 'add' first and last elements in first p are 'add' -->
					<xsl:if test="*[1][count(node()[normalize-space() != '']) = 1 and *[local-name() = 'add']]">
						<xsl:call-template name="append_add-style"/>
					</xsl:if>

					<xsl:call-template name="getListItemFormat"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" xsl:use-attribute-sets="list-item-body-style">
				<fo:block>

						<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
						<xsl:if test="ancestor::ogc:table[not(@class)]">
							<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
						</xsl:if>
						<xsl:if test="not(following-sibling::*) and not(../following-sibling::*)">
							<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
						</xsl:if>

					<xsl:apply-templates/>

					<!-- <xsl:apply-templates select="node()[not(local-name() = 'note')]" />
					
					<xsl:for-each select="./bsi:note">
						<xsl:call-template name="note"/>
					</xsl:for-each> -->
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<!-- ===================================== -->
	<!-- END Lists processing -->
	<!-- ===================================== -->

	<!-- =================== -->
	<!-- Index section processing -->
	<!-- =================== -->

	<xsl:variable name="index" select="document($external_index)"/>

	<xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
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

	<xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
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

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/node()" mode="process_li_element" priority="2">
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
			<xsl:when test="self::* and local-name(.) = 'xref'">
				<xsl:variable name="id" select="@id"/>

				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>

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

		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>

		<xsl:variable name="docid_curr">
			<xsl:value-of select="$docid"/>
			<xsl:if test="normalize-space($docid) = ''"><xsl:call-template name="getDocumentId"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid_curr, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'title']" priority="4">
		<fo:block xsl:use-attribute-sets="indexsect-title-style">
			<!-- Index -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']/*[local-name() = 'title']" priority="4">
		<!-- Letter A, B, C, ... -->
		<fo:block xsl:use-attribute-sets="indexsect-clause-title-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']" priority="4">
		<xsl:apply-templates/>
		<fo:block>
			<xsl:if test="following-sibling::*[local-name() = 'clause']">
				<fo:block> </fo:block>
			</xsl:if>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'ul']" priority="4">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" priority="4">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">

			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/text()">
		<!-- to split by '_' and other chars -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'table']/*[local-name() = 'bookmark']" priority="2"/>

	<xsl:template match="*[local-name() = 'bookmark']" name="bookmark">
		<!-- <fo:inline id="{@id}" font-size="1pt"/> -->
		<fo:inline id="{@id}" font-size="1pt"><xsl:value-of select="$hair_space"/></fo:inline>
		<!-- we need to add zero-width space, otherwise this fo:inline is missing in IF xml -->
		<xsl:if test="not(following-sibling::node()[normalize-space() != ''])"><fo:inline font-size="1pt"> </fo:inline></xsl:if>
	</xsl:template>
	<!-- =================== -->
	<!-- End of Index processing -->
	<!-- =================== -->

	<!-- ============ -->
	<!-- errata -->
	<!-- ============ -->
	<xsl:template match="*[local-name() = 'errata']">
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

					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template>

	<xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template>
	<!-- ============ -->
	<!-- END errata -->
	<!-- ============ -->

	<!-- ======================= -->
	<!-- Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->
	<xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/>
	<xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3"/>
	<!-- don't display bibitem with @id starts with '_hidden', that was introduced for references integrity -->
	<xsl:template match="*[local-name() = 'bibitem'][starts-with(@id, 'hidden_bibitem_')]" priority="3"/>

	<!-- Normative references -->
	<xsl:template match="*[local-name() = 'references'][@normative='true']" priority="2">

		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="*[local-name() = 'references']">
		<xsl:if test="not(ancestor::*[local-name() = 'annex'])">

					<fo:block break-after="page"/>

		</xsl:if>

		<!-- <xsl:if test="ancestor::*[local-name() = 'annex']">
			<xsl:if test="$namespace = 'csa' or $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'iso' or $namespace = 'itu'">
				<fo:block break-after="page"/>
			</xsl:if>
		</xsl:if> -->

		<fo:block id="{@id}" xsl:use-attribute-sets="references-non-normative-style">
			<xsl:apply-templates/>
		</fo:block>

	</xsl:template> <!-- references -->

	<xsl:template match="*[local-name() = 'bibitem']">
		<xsl:call-template name="bibitem"/>
	</xsl:template>

	<!-- Normative references -->
	<xsl:template match="*[local-name() = 'references'][@normative='true']/*[local-name() = 'bibitem']" name="bibitem" priority="2">

				<fo:block id="{@id}" xsl:use-attribute-sets="bibitem-normative-style">
					<xsl:call-template name="processBibitem"/>
				</fo:block>

	</xsl:template> <!-- bibitem -->

	<!-- Bibliography (non-normative references) -->
	<xsl:template match="*[local-name() = 'references'][not(@normative='true')]/*[local-name() = 'bibitem']" name="bibitem_non_normative" priority="2">

		 <!-- $namespace = 'csd' or $namespace = 'gb' or $namespace = 'iec' or $namespace = 'ieee' or $namespace = 'iso' or $namespace = 'jcgm' or $namespace = 'm3d' or 
			$namespace = 'mpfd' or $namespace = 'ogc' or $namespace = 'ogc-white-paper' -->
				<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
				<fo:list-block id="{@id}" xsl:use-attribute-sets="bibitem-non-normative-list-style">
					<fo:list-item>
						<fo:list-item-label end-indent="label-end()">
							<fo:block>
								<fo:inline>

											<xsl:number format="1." count="*[local-name()='bibitem'][not(@hidden = 'true')]"/>

								</fo:inline>
							</fo:block>
						</fo:list-item-label>
						<fo:list-item-body start-indent="body-start()">
							<fo:block xsl:use-attribute-sets="bibitem-non-normative-list-body-style">
								<xsl:call-template name="processBibitem"/>
							</fo:block>
						</fo:list-item-body>
					</fo:list-item>
				</fo:list-block>

	</xsl:template> <!-- references[not(@normative='true')]/bibitem -->

	<xsl:template name="processBibitem">

				<!-- start OGC bibitem processing -->
				<xsl:if test=".//ogc:fn">
					<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
				<!-- end OGC bibitem processing-->

	</xsl:template> <!-- processBibitem (bibitem) -->

	<xsl:template name="processBibitemDocId">
		<xsl:variable name="_doc_ident" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'metanorma-ordinal' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($_doc_ident) != ''">
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]/@type"/>
				<xsl:if test="$type != '' and not(contains($_doc_ident, $type))">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="$_doc_ident"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]/@type"/>
				<xsl:if test="$type != ''">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma') and not(@type = 'metanorma-ordinal')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- processBibitemDocId -->

	<xsl:template name="processPersonalAuthor">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'completename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'completename']"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'initial']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'initial']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'forename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'forename']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> <!-- processPersonalAuthor -->

	<xsl:template name="renderDate">
			<xsl:if test="normalize-space(*[local-name() = 'on']) != ''">
				<xsl:value-of select="*[local-name() = 'on']"/>
			</xsl:if>
			<xsl:if test="normalize-space(*[local-name() = 'from']) != ''">
				<xsl:value-of select="concat(*[local-name() = 'from'], '–', *[local-name() = 'to'])"/>
			</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'name']/*[local-name() = 'initial']/text()" mode="strip">
		<xsl:value-of select="translate(.,'. ','')"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'name']/*[local-name() = 'forename']/text()" mode="strip">
		<xsl:value-of select="substring(.,1,1)"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'title']" priority="2">
		<!-- <fo:inline><xsl:apply-templates /></fo:inline> -->
		<fo:inline font-style="italic"> <!-- BIPM BSI CSD CSA GB IEC IHO ISO ITU JCGM -->
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<!-- bibitem/note renders as footnote -->
	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'note']" priority="2">

		<!-- list of footnotes to calculate actual footnotes number -->
		<xsl:variable name="p_fn_">
			<xsl:call-template name="get_fn_list"/>
		</xsl:variable>
		<xsl:variable name="p_fn" select="xalan:nodeset($p_fn_)"/>
		<xsl:variable name="gen_id" select="generate-id(.)"/>
		<xsl:variable name="lang" select="ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibdata']//*[local-name()='language'][@current = 'true']"/>
		<!-- fn sequence number in document -->
		<xsl:variable name="current_fn_number">
			<xsl:choose>
				<xsl:when test="@current_fn_number"><xsl:value-of select="@current_fn_number"/></xsl:when> <!-- for BSI -->
				<xsl:otherwise>
					<!-- <xsl:value-of select="count($p_fn//fn[@reference = $reference]/preceding-sibling::fn) + 1" /> -->
					<xsl:value-of select="count($p_fn//fn[@gen_id = $gen_id]/preceding-sibling::fn) + 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:footnote>
			<xsl:variable name="number">

						<xsl:choose>
							<xsl:when test="ancestor::*[local-name() = 'references'][preceding-sibling::*[local-name() = 'references']]">
								<xsl:number level="any" count="*[local-name() = 'references'][preceding-sibling::*[local-name() = 'references']]//*[local-name() = 'bibitem']/*[local-name() = 'note']"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$current_fn_number"/>
							</xsl:otherwise>
						</xsl:choose>

			</xsl:variable>

			<xsl:variable name="current_fn_number_text">
				<xsl:value-of select="$number"/>

			</xsl:variable>

			<fo:inline xsl:use-attribute-sets="bibitem-note-fn-style">
				<fo:basic-link internal-destination="{$gen_id}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$current_fn_number_text"/>
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block xsl:use-attribute-sets="bibitem-note-fn-body-style">
					<fo:inline id="{$gen_id}" xsl:use-attribute-sets="bibitem-note-fn-number-style">
						<xsl:value-of select="$current_fn_number_text"/>
					</fo:inline>
					<xsl:apply-templates/>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'edition']"> <!-- for iho -->
		<xsl:text> edition </xsl:text>
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'uri']"> <!-- for iho -->
		<xsl:text> (</xsl:text>
		<fo:inline xsl:use-attribute-sets="link-style">
			<fo:basic-link external-destination="." fox:alt-text=".">
				<xsl:value-of select="."/>
			</fo:basic-link>
		</fo:inline>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="*[local-name() = 'bibitem']/*[local-name() = 'docidentifier']"/>

	<xsl:template match="*[local-name() = 'formattedref']">

		<xsl:apply-templates/>
	</xsl:template>

	<!-- ======================= -->
	<!-- END Bibliography rendering -->
	<!-- ======================= -->

	<!-- ========================================================== -->
	<!-- END Reference sections (Normative References and Bibliography) -->
	<!-- ========================================================== -->

	<!-- =================== -->
	<!-- Form's elements processing -->
	<!-- =================== -->
	<xsl:template match="*[local-name() = 'form']">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'label']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
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

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'checkbox']">
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

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'radio']">
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

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'select']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'form']//*[local-name() = 'textarea']">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template>

	<!-- =================== -->
	<!-- End Form's elements processing -->
	<!-- =================== -->

	<!-- =================== -->
	<!-- Table of Contents (ToC) processing -->
	<!-- =================== -->

	<xsl:variable name="toc_level">
		<!-- https://www.metanorma.org/author/ref/document-attributes/ -->
		<xsl:variable name="htmltoclevels" select="normalize-space(//*[local-name() = 'misc-container']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name']/text() = 'HTML TOC Heading Levels']/*[local-name() = 'value'])"/> <!-- :htmltoclevels  Number of table of contents levels to render in HTML/PDF output; used to override :toclevels:-->
		<xsl:variable name="toclevels" select="normalize-space(//*[local-name() = 'misc-container']/*[local-name() = 'presentation-metadata'][*[local-name() = 'name']/text() = 'TOC Heading Levels']/*[local-name() = 'value'])"/> <!-- Number of table of contents levels to render -->
		<xsl:choose>
			<xsl:when test="$htmltoclevels != ''"><xsl:value-of select="number($htmltoclevels)"/></xsl:when> <!-- if there is value in xml -->
			<xsl:when test="$toclevels != ''"><xsl:value-of select="number($toclevels)"/></xsl:when>  <!-- if there is value in xml -->
			<xsl:otherwise><!-- default value -->
				2
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="*[local-name() = 'toc']">
		<xsl:param name="colwidths"/>
		<xsl:variable name="colwidths_">
			<xsl:choose>
				<xsl:when test="not($colwidths)">
					<xsl:variable name="toc_table_simple">
						<tbody>
							<xsl:apply-templates mode="toc_table_width"/>
						</tbody>
					</xsl:variable>
					<xsl:variable name="cols-count" select="count(xalan:nodeset($toc_table_simple)/*/tr[1]/td)"/>
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

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'li']" priority="2">
		<fo:table-row min-height="5mm">
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'li']/*[local-name() = 'p']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'toc']//*[local-name() = 'xref']" priority="3">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:variable name="target" select="@target"/>
		<xsl:for-each select="*[local-name() = 'tab']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<fo:table-cell>
				<fo:block>
					<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
						<xsl:for-each select="following-sibling::node()[not(self::*[local-name() = 'tab']) and preceding-sibling::*[local-name() = 'tab'][1][generate-id() = $current_id]]">
							<xsl:choose>
								<xsl:when test="self::text()"><xsl:value-of select="."/></xsl:when>
								<xsl:otherwise><xsl:apply-templates select="."/></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</fo:basic-link>
				</fo:block>
			</fo:table-cell>
		</xsl:for-each>
		<!-- last column - for page numbers -->
		<fo:table-cell text-align="right" font-size="10pt" font-weight="bold" font-family="Arial">
			<fo:block>
				<fo:basic-link internal-destination="{$target}" fox:alt-text="{.}">
					<fo:page-number-citation ref-id="{$target}"/>
				</fo:basic-link>
			</fo:block>
		</fo:table-cell>
	</xsl:template>

	<!-- ================================== -->
	<!-- calculate ToC table columns widths -->
	<!-- ================================== -->
	<xsl:template match="*" mode="toc_table_width">
		<xsl:apply-templates mode="toc_table_width"/>
	</xsl:template>

	<xsl:template match="*[local-name() = 'clause'][@type = 'toc']/*[local-name() = 'title']" mode="toc_table_width"/>
	<xsl:template match="*[local-name() = 'clause'][not(@type = 'toc')]/*[local-name() = 'title']" mode="toc_table_width"/>

	<xsl:template match="*[local-name() = 'li']" mode="toc_table_width">
		<tr>
			<xsl:apply-templates mode="toc_table_width"/>
		</tr>
	</xsl:template>

	<xsl:template match="*[local-name() = 'xref']" mode="toc_table_width">
		<!-- <xref target="cgpm9th1948r6">1.6.3<tab/>&#8220;9th CGPM, 1948:<tab/>decision to establish the SI&#8221;</xref> -->
		<xsl:for-each select="*[local-name() = 'tab']">
			<xsl:variable name="current_id" select="generate-id()"/>
			<td>
				<xsl:for-each select="following-sibling::node()[not(self::*[local-name() = 'tab']) and preceding-sibling::*[local-name() = 'tab'][1][generate-id() = $current_id]]">
					<xsl:copy-of select="."/>
				</xsl:for-each>
			</td>
		</xsl:for-each>
		<td>333</td> <!-- page number, just for fill -->
	</xsl:template>

	<!-- ================================== -->
	<!-- END: calculate ToC table columns widths -->
	<!-- ================================== -->

	<!-- =================== -->
	<!-- End Table of Contents (ToC) processing -->
	<!-- =================== -->

	<xsl:template match="*[local-name() = 'variant-title']"/> <!-- [@type = 'sub'] -->
	<xsl:template match="*[local-name() = 'variant-title'][@type = 'sub']" mode="subtitle">
		<fo:inline padding-right="5mm"> </fo:inline>
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="*[local-name() = 'blacksquare']" name="blacksquare">
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

	<xsl:template match="*[local-name() = 'p'][@type = 'floating-title' or @type = 'section-title']" priority="4">
		<xsl:call-template name="title"/>
	</xsl:template>

	<!-- ================ -->
	<!-- Admonition -->
	<!-- ================ -->
	<xsl:template match="*[local-name() = 'admonition']">

		 <!-- text in the box -->
				<fo:block-container id="{@id}" xsl:use-attribute-sets="admonition-style">

							<fo:block-container xsl:use-attribute-sets="admonition-container-style">

										<fo:block xsl:use-attribute-sets="admonition-name-style">
											<xsl:call-template name="displayAdmonitionName"/>
										</fo:block>
										<fo:block xsl:use-attribute-sets="admonition-p-style">
											<xsl:apply-templates select="node()[not(local-name() = 'name')]"/>
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
						<xsl:apply-templates select="*[local-name() = 'name']"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="*[local-name() = 'name']"/>
				<xsl:if test="not(*[local-name() = 'name'])">
					<xsl:apply-templates select="@type"/>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose> -->
		<xsl:variable name="name">
			<xsl:apply-templates select="*[local-name() = 'name']"/>
		</xsl:variable>
		<xsl:copy-of select="$name"/>
		<xsl:if test="normalize-space($name) != ''">
			<xsl:value-of select="$sep"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*[local-name() = 'admonition']/*[local-name() = 'name']">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- <xsl:template match="*[local-name() = 'admonition']/@type">
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

	<xsl:template match="*[local-name() = 'admonition']/*[local-name() = 'p']">

				<fo:block xsl:use-attribute-sets="admonition-p-style">

					<xsl:apply-templates/>
				</fo:block>

	</xsl:template>

	<!-- ================ -->
	<!-- END Admonition -->
	<!-- ================ -->

	<!-- ===================================== -->
	<!-- Update xml -->
	<!-- ===================================== -->
	<!-- =========================================================================== -->
	<!-- STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
	<!-- =========================================================================== -->
	<xsl:template match="@*|node()" mode="update_xml_step1">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>

	<!-- change section's order based on @displayorder value -->
	<xsl:template match="*[local-name() = 'preface']" mode="update_xml_step1">
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

	<xsl:template match="*[local-name() = 'sections']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>

			<xsl:variable name="nodes_sections_">
				<xsl:for-each select="*">
					<node id="{@id}"/>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="nodes_sections" select="xalan:nodeset($nodes_sections_)"/>

			<!-- move section 'Normative references' inside 'sections' -->
			<xsl:for-each select="* |      ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |     ancestor::*[contains(local-name(), '-standard')]/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]">
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

	<xsl:template match="*[local-name() = 'bibliography']" mode="update_xml_step1">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- copy all elements from bibliography except 'Normative references' (moved to 'sections') -->
			<xsl:for-each select="*[not(@normative='true') and not(*[@normative='true'])]">
				<xsl:sort select="@displayorder" data-type="number"/>
				<xsl:apply-templates select="." mode="update_xml_step1"/>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*[local-name() = 'span'][@style]" mode="update_xml_step1" priority="2">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="update_xml_step1"/>
		</xsl:copy>
	</xsl:template>
	<!-- Note: to enable the addition of character span markup with semantic styling for DIS Word output -->
	<xsl:template match="*[local-name() = 'span']" mode="update_xml_step1">
		<xsl:apply-templates mode="update_xml_step1"/>
	</xsl:template>
	<!-- =========================================================================== -->
	<!-- END STEP1: Re-order elements in 'preface', 'sections' based on @displayorder -->
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

	<xsl:variable name="element_name_keep-together_within-line">keep-together_within-line</xsl:variable>

	<xsl:template match="text()[not(ancestor::*[local-name() = 'bibdata'] or      ancestor::*[local-name() = 'link'][not(contains(.,' '))] or      ancestor::*[local-name() = 'sourcecode'] or      ancestor::*[local-name() = 'math'] or     starts-with(., 'http://') or starts-with(., 'https://') or starts-with(., 'www.') )]" name="keep_together_standard_number" mode="update_xml_enclose_keep-together_within-line">

		<!-- enclose standard's number into tag 'keep-together_within-line' -->
		<xsl:variable name="tag_keep-together_within-line_open">###<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
		<xsl:variable name="tag_keep-together_within-line_close">###/<xsl:value-of select="$element_name_keep-together_within-line"/>###</xsl:variable>
		<xsl:variable name="text__" select="java:replaceAll(java:java.lang.String.new(.), $regex_standard_reference, concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
		<xsl:variable name="text_">
			<xsl:choose>
				<xsl:when test="ancestor::*[local-name() = 'table']"><xsl:value-of select="."/></xsl:when> <!-- no need enclose standard's number into tag 'keep-together_within-line' in table cells -->
				<xsl:otherwise><xsl:value-of select="$text__"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="text"><text><xsl:call-template name="replace_text_tags">
				<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
				<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
				<xsl:with-param name="text" select="$text_"/>
			</xsl:call-template></text></xsl:variable>

		<xsl:variable name="parent" select="local-name(..)"/>

		<xsl:variable name="text2">
			<text><xsl:for-each select="xalan:nodeset($text)/text/node()">
					<xsl:copy-of select="."/>
				</xsl:for-each></text>
		</xsl:variable>

		<!-- keep-together_within-line for: a/b, aaa/b, a/bbb, /b -->
		<!-- \S matches any non-whitespace character (equivalent to [^\r\n\t\f\v ]) -->
		<!-- <xsl:variable name="regex_solidus_units">((\b((\S{1,3}\/\S+)|(\S+\/\S{1,3}))\b)|(\/\S{1,3})\b)</xsl:variable> -->
		<!-- add &lt; and &gt; to \S -->
		<xsl:variable name="regex_S">[^\r\n\t\f\v \&lt;&gt;]</xsl:variable>
		<xsl:variable name="regex_solidus_units">((\b((<xsl:value-of select="$regex_S"/>{1,3}\/<xsl:value-of select="$regex_S"/>+)|(<xsl:value-of select="$regex_S"/>+\/<xsl:value-of select="$regex_S"/>{1,3}))\b)|(\/<xsl:value-of select="$regex_S"/>{1,3})\b)</xsl:variable>
		<xsl:variable name="text3">
			<text><xsl:for-each select="xalan:nodeset($text2)/text/node()">
				<xsl:choose>
					<xsl:when test="self::text()">
						<xsl:variable name="text_units_" select="java:replaceAll(java:java.lang.String.new(.),$regex_solidus_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
						<xsl:variable name="text_units"><text><xsl:call-template name="replace_text_tags">
							<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
							<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
							<xsl:with-param name="text" select="$text_units_"/>
						</xsl:call-template></text></xsl:variable>
						<xsl:copy-of select="xalan:nodeset($text_units)/text/node()"/>
					</xsl:when>
					<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
				</xsl:choose>
			</xsl:for-each></text>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'td' or local-name() = 'th']">
				<!-- keep-together_within-line for: a.b, aaa.b, a.bbb, .b  in table's cell ONLY -->
				<xsl:variable name="regex_dots_units">((\b((\S{1,3}\.\S+)|(\S+\.\S{1,3}))\b)|(\.\S{1,3})\b)</xsl:variable>
				<xsl:for-each select="xalan:nodeset($text3)/text/node()">
					<xsl:choose>
						<xsl:when test="self::text()">
							<xsl:variable name="text_dots_" select="java:replaceAll(java:java.lang.String.new(.),$regex_dots_units,concat($tag_keep-together_within-line_open,'$1',$tag_keep-together_within-line_close))"/>
							<xsl:variable name="text_dots"><text><xsl:call-template name="replace_text_tags">
								<xsl:with-param name="tag_open" select="$tag_keep-together_within-line_open"/>
								<xsl:with-param name="tag_close" select="$tag_keep-together_within-line_close"/>
								<xsl:with-param name="text" select="$text_dots_"/>
							</xsl:call-template></text></xsl:variable>
							<xsl:copy-of select="xalan:nodeset($text_dots)/text/node()"/>
						</xsl:when>
						<xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise> <!-- copy 'as-is' for <fo:inline keep-together.within-line="always" ...  -->
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise><xsl:copy-of select="xalan:nodeset($text3)/text/node()"/></xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template name="replace_text_tags">
		<xsl:param name="tag_open"/>
		<xsl:param name="tag_close"/>
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, $tag_open)">
				<xsl:value-of select="substring-before($text, $tag_open)"/>
				<xsl:variable name="text_after" select="substring-after($text, $tag_open)"/>

				<xsl:element name="{substring-before(substring-after($tag_open, '###'),'###')}">
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

	<!-- for correct rendering combining chars -->
	<xsl:template match="*[local-name() = 'lang_none']">
		<fo:inline xml:lang="none"><xsl:value-of select="."/></fo:inline>
	</xsl:template>

	<xsl:template name="printEdition">
		<xsl:variable name="edition_i18n" select="normalize-space((//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']/*[local-name() = 'edition'][normalize-space(@language) != ''])"/>
		<xsl:text> </xsl:text>
		<xsl:choose>
			<xsl:when test="$edition_i18n != ''">
				<!-- Example: <edition language="fr">deuxième édition</edition> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$edition_i18n"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="edition" select="normalize-space((//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']/*[local-name() = 'edition'])"/>
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
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="meta" select="$meta"/>
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
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
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">

										<xsl:value-of select="*[local-name() = 'title'][@language = $lang]"/>

							</xsl:for-each>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="normalize-space($title) != ''">
								<xsl:value-of select="$title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</dc:title>
					<dc:creator>
						<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">

									<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
										<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
										<xsl:if test="position() != last()">; </xsl:if>
									</xsl:for-each>

						</xsl:for-each>
					</dc:creator>
					<dc:description>
						<xsl:variable name="abstract">

									<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()[not(ancestor::*[local-name() = 'title'])]"/>

						</xsl:variable>
						<xsl:value-of select="normalize-space($abstract)"/>
					</dc:description>
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
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*)"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface'] and not(ancestor::*[local-name() = 'foreword']) and not(ancestor::*[local-name() = 'introduction'])"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="local-name() = 'annex'">1</xsl:when>
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
					<xsl:for-each select="../preceding-sibling::*[local-name() = 'title'][1]">
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
			<item>
				<xsl:choose>
					<xsl:when test="$normalize-space = 'true'">
						<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
					</xsl:otherwise>
				</xsl:choose>
			</item>
			<xsl:if test="$keep_sep = 'true' and contains($pText, $sep)"><item><xsl:value-of select="$sep"/></item></xsl:if>
			<xsl:call-template name="split">
				<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
				<xsl:with-param name="sep" select="$sep"/>
				<xsl:with-param name="normalize-space" select="$normalize-space"/>
				<xsl:with-param name="keep_sep" select="$keep_sep"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template> <!-- split -->

	<xsl:template name="getDocumentId">
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template>

	<xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">

				<xsl:value-of select="document('')//*/namespace::ogc"/>

		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template> <!-- namespaceCheck -->

	<xsl:template name="getLanguage">
		<xsl:param name="lang"/>
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
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
				<xsl:when test="$formatted = 'true'">
					<xsl:apply-templates select="xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang])"/>
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
			<xsl:when test="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]">
				<xsl:choose>
					<xsl:when test="$formatted = 'true'">
						<xsl:apply-templates select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
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
				<xsl:when test="$align != '' and not($align = 'indent')"><xsl:value-of select="$align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'td']/@align"><xsl:value-of select="ancestor::*[local-name() = 'td']/@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'th']/@align"><xsl:value-of select="ancestor::*[local-name() = 'th']/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
		<xsl:if test="$align = 'indent'">
			<xsl:attribute name="margin-left">7mm</xsl:attribute>
		</xsl:if>
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

</xsl:stylesheet>