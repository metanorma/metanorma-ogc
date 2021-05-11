<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:ogc="https://www.metanorma.org/ns/ogc" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="no"/>
	
	<xsl:param name="svg_images"/>
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/>
	
	<xsl:variable name="pageWidth" select="'215.9mm'"/>
	<xsl:variable name="pageHeight" select="'279.4mm'"/>

	

	<xsl:variable name="debug">false</xsl:variable>

	<xsl:variable name="color">rgb(0, 51, 102)</xsl:variable>
	
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
	</xsl:attribute-set>
	
	<xsl:attribute-set name="title-depth2-style">
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="font-size">18pt</xsl:attribute>
		<xsl:attribute name="color">rgb(21, 43, 77)</xsl:attribute>
		<xsl:attribute name="margin-top">12pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>		
		<xsl:attribute name="line-height">110%</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="title-depth3-style">
		<xsl:attribute name="font-family">Lato</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">rgb(21, 43, 77)</xsl:attribute>
		<xsl:attribute name="margin-top">6pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		<xsl:attribute name="keep-with-next">always</xsl:attribute>		
	</xsl:attribute-set>
	
	<xsl:attribute-set name="empty-style">
	</xsl:attribute-set>
	
	<xsl:variable name="contents">
		<contents>
		
			<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->			
			<!-- <xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/*" mode="contents"/> -->			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:abstract" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:clause[@type = 'keyword']" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:foreword" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:introduction" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:clause[@type = 'submitting_orgs']" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:submitters" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:clause[not(@type = 'submitting_orgs') and not(@type = 'keyword')]" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:acknowledgements" mode="contents"/>
			
			
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@type='scope']" mode="contents"/>				
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@type='conformance']" mode="contents"/>				
			<!-- Normative references  -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@normative='true']" mode="contents"/>			
			<!-- Terms and definitions -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:terms" mode="contents"/>
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:definitions" mode="contents"/>
		
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[not(@type='scope') and not(@type='conformance')]" mode="contents"/>

			<xsl:apply-templates select="/ogc:ogc-standard/ogc:annex" mode="contents"/>
			
			<!-- Bibliography -->
			<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[not(@normative='true')]" mode="contents"/>
			
			
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root font-family="Arial, STIX Two Math, Source Han Sans" font-size="11pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				
				<!-- Document pages -->
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}" page-height="{$pageHeight}">
					<fo:region-body margin-top="1in" margin-bottom="1in" margin-left="1in" margin-right="1in"/>
					<fo:region-before region-name="header" extent="1in" precedence="true"/> 
					<fo:region-after region-name="footer" extent="1in" precedence="true"/>
					<fo:region-start region-name="left" extent="1in"/>
					<fo:region-end region-name="right" extent="1in"/>
				</fo:simple-page-master>
				
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<!-- Cover Page -->
			<fo:page-sequence master-reference="document" force-page-count="no-force">				
				<xsl:call-template name="insertHeaderFooter"/>					
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block-container margin-left="-12mm" margin-right="-9mm">
						<fo:block-container margin-left="0mm" margin-right="0mm">
							<fo:block font-size="36pt" background-color="{$color}" color="white" margin-left="2.5mm" padding-top="1mm" padding-left="1mm">
								<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibdata/ogc:title/node()"/>
							</fo:block>
						</fo:block-container>
					</fo:block-container>
					
					<!-- <fo:block font-family="Lato" font-weight="300" font-size="14pt" font-style="italic" margin-top="6pt" color="rgb(21, 43, 77)">
						<xsl:text>Additional context, inspirational quote, etc. fits into this subheading area</xsl:text>
					</fo:block> -->
					
					<fo:block text-align="right" font-size="10pt" margin-top="12pt" margin-bottom="24pt">
						<fo:block margin-top="6pt">Submission Date: <xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'received']/ogc:on"/></fo:block>
						<fo:block margin-top="6pt">Approval Date: <xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'issued']/ogc:on"/></fo:block>
						<fo:block margin-top="6pt">Publication Date: <xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:date[@type = 'published']/ogc:on"/></fo:block>
						<fo:block margin-top="6pt">External identifier of this OGC® document: <xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:docidentifier[@type = 'ogc-external']"/></fo:block>
						<fo:block margin-top="6pt">Internal reference number of this OGC® document: <xsl:value-of select="/ogc:ogc-standard/ogc:bibdata/ogc:docnumber"/></fo:block>
						
						<xsl:variable name="url" select="/ogc:ogc-standard/ogc:bibdata/ogc:uri"/>
						<xsl:if test="normalize-space($url) != ''">
							<fo:block margin-top="6pt">URL for this OGC® document: <xsl:value-of select="$url"/></fo:block>
						</xsl:if>
							
						<xsl:variable name="edition" select="/ogc:ogc-standard/ogc:bibdata/ogc:edition"/>
						<xsl:if test="normalize-space($edition) != ''">
							<fo:block margin-top="6pt">Version: <xsl:value-of select="$edition"/></fo:block>
						</xsl:if>
							
						<fo:block margin-top="6pt"><xsl:text>Category: </xsl:text>
							<xsl:call-template name="capitalizeWords">
								<xsl:with-param name="str" select="/ogc:ogc-standard/ogc:bibdata/ogc:ext/ogc:doctype"/>
							</xsl:call-template>
						</fo:block>
						
						<xsl:variable name="editors">
							<xsl:for-each select="/ogc:ogc-standard/ogc:bibdata/ogc:contributor[ogc:role/@type='editor']/ogc:person/ogc:name/ogc:completename">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">, </xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:if test="normalize-space($editors) != ''">
							<fo:block margin-top="6pt">Editor: <xsl:value-of select="$editors"/></fo:block>
						</xsl:if>
					</fo:block>
					
					<!-- absolute-position="fixed" left="20mm" top="91mm" width="175mm" -->
					<fo:block-container font-size="9pt" margin-left="-5mm" margin-right="-5mm">
						<fo:block-container margin-left="0mm" margin-right="0mm">
							<fo:block margin-top="8pt">
								<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:copyright-statement"/>
							</fo:block>
							<fo:block margin-top="8pt"> </fo:block>
							<fo:block margin-top="8pt">
								<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:legal-statement"/>
							</fo:block>
						</fo:block-container>
					</fo:block-container>
					
					<!-- absolute-position="fixed" left="79mm" top="168mm" -->
					<fo:block-container margin-top="24pt" margin-left="-5mm" margin-right="-5mm">
						<fo:block-container margin-left="0mm" margin-right="0mm">
							<fo:block text-align="center">
								<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo-OGC))}" width="57.5mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image Logo"/>
							</fo:block>
						</fo:block-container>
					</fo:block-container>

				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->
			
			
			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="document" force-page-count="no-force"> <!--  -->
				
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
				
					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<!-- <xsl:copy-of select="xalan:nodeset($contents)"/> --> 
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:license-statement"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:boilerplate/ogc:feedback-statement"/>
					
					<fo:block break-after="page"/>
					
					<fo:block-container line-height="1.08" font-family="Lato">
						<fo:block xsl:use-attribute-sets="title-toc-style">
							<xsl:text>Table of Contents</xsl:text>
						</fo:block>
						<xsl:variable name="margin-left">3.9</xsl:variable>
						<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true']">
							<fo:block margin-top="8pt" margin-bottom="5pt" margin-left="{(@level - 1) * $margin-left}mm" text-align-last="justify">
								<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
									<xsl:if test="@section != ''">
										<xsl:value-of select="@section"/><xsl:text> </xsl:text>
									</xsl:if>
									<xsl:apply-templates select="title"/>
									<fo:inline keep-together.within-line="always">
										<fo:leader leader-pattern="dots"/>
										<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
									</fo:inline>
								</fo:basic-link>
							</fo:block>
						</xsl:for-each>
						
						<xsl:if test="//ogc:figure[@id and ogc:name] or //ogc:table[@id and ogc:name]">
							<fo:block font-size="11pt" margin-top="8pt"> </fo:block>
							<fo:block font-size="11pt" margin-top="8pt"> </fo:block>							
							<fo:block xsl:use-attribute-sets="title-toc-style">
								<xsl:text>Table of Figures</xsl:text>
							</fo:block>
							<xsl:for-each select="//ogc:figure[@id and ogc:name] | //ogc:table[@id and ogc:name]">
								<fo:block margin-top="8pt" margin-bottom="5pt" text-align-last="justify">
									<fo:basic-link internal-destination="{@id}" fox:alt-text="{ogc:name}">
										<xsl:apply-templates select="ogc:name" mode="contents"/>										
										<fo:inline keep-together.within-line="always">
											<fo:leader leader-pattern="dots"/>
											<fo:page-number-citation ref-id="{@id}"/>
										</fo:inline>
									</fo:basic-link>
								</fo:block>
							</xsl:for-each>
						</xsl:if>						
					</fo:block-container>
				
					
					<!-- Abstract, Keywords, Preface, Submitting Organizations, Submitters -->
					<!-- <xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/*" mode="preface"/> -->
					<xsl:if test="/ogc:ogc-standard/ogc:preface/ogc:abstract">
						<fo:block break-after="page"/>
					</xsl:if>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:abstract"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:clause[@type = 'keyword']"/>
					<xsl:if test="/ogc:ogc-standard/ogc:preface/ogc:foreword">
						<fo:block break-after="page"/>
					</xsl:if>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:foreword"/>					
					<xsl:if test="/ogc:ogc-standard/ogc:preface/ogc:introduction">
						<fo:block break-after="page"/>
					</xsl:if>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:introduction"/>
					
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:clause[@type = 'submitting_orgs']"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:submitters"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:clause[not(@type = 'submitting_orgs') and not(@type = 'keyword')]"/>
					<xsl:apply-templates select="/ogc:ogc-standard/ogc:preface/ogc:acknowledgements"/>
						
				</fo:flow>
			</fo:page-sequence>
			
			
			<!-- Document Pages -->
			<fo:page-sequence master-reference="document" initial-page-number="1" format="1" force-page-count="no-force">
				
				<xsl:call-template name="insertHeaderFooter"/>
					
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block line-height="125%">
					
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@type='scope']"/>
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[@type='conformance']"/>
						
						<!-- Normative references  -->
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[@normative='true']"/>

						<!-- Terms and definitions -->
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:terms"/>						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:definitions"/>
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:sections/ogc:clause[not(@type='scope') and not(@type='conformance')]"/>
						
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:annex"/>
						
						<!-- Bibliography -->
						<xsl:apply-templates select="/ogc:ogc-standard/ogc:bibliography/ogc:references[not(@normative='true')]"/>
						
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
			
			<!-- End Document Pages -->
			
		</fo:root>
	</xsl:template> 


	<xsl:variable name="thinspace" select="' '"/>	
	
	<!-- Lato font doesn't contain 'thin space' glyph -->
	<xsl:template match="text()" priority="1">
		<xsl:value-of select="translate(., $thinspace, ' ')"/>
	</xsl:template>
	
	<xsl:template match="text()" priority="3" mode="contents">
		<xsl:value-of select="translate(., $thinspace, ' ')"/>
	</xsl:template>

	<xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text()" priority="2">
		<xsl:variable name="content">
			<xsl:call-template name="add-zero-spaces"/>
		</xsl:variable>
		<xsl:value-of select="translate($content, $thinspace, ' ')"/>
	</xsl:template>

	<xsl:template match="node()">		
		<xsl:apply-templates/>			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">		
		<xsl:apply-templates mode="contents"/>			
	</xsl:template>

	<!-- element with title -->
	<xsl:template match="*[ogc:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="ogc:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="$level &gt; 3">false</xsl:when>
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
		<fo:block margin-bottom="12pt">
			<xsl:variable name="title-edition">
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-edition'"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:value-of select="$title-edition"/><xsl:text>: </xsl:text>
			<xsl:value-of select="."/><xsl:text> </xsl:text>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:license-statement//ogc:title">
		<fo:block font-family="Lato" text-align="center" font-weight="bold" margin-top="4pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:license-statement//ogc:p">
		<fo:block font-size="8pt" margin-top="14pt" line-height="115%">
			<xsl:if test="following-sibling::ogc:p">
				<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:feedback-statement">
		<fo:block margin-top="12pt" margin-bottom="12pt">
			<xsl:apply-templates select="ogc:clause[1]"/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="ogc:copyright-statement | ogc:legal-statement">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="ogc:copyright-statement//ogc:clause | ogc:legal-statement//ogc:clause" priority="2">
		<fo:block margin-top="6pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="ogc:copyright-statement//ogc:title | ogc:legal-statement//ogc:title">
		<fo:block font-family="Lato" text-align="center" font-weight="bold">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:copyright-statement//ogc:p | ogc:legal-statement//ogc:p">
		<fo:block>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	
	<xsl:template match="/*/*[local-name() = 'preface']/*" priority="3">		
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:ogc-standard/ogc:preface/*" mode="preface">
		<xsl:if test="local-name() = 'introduction' or             local-name() = 'abstract' or             local-name() = 'foreword'">
			<fo:block break-after="page"/>
		</xsl:if>
		<xsl:apply-templates select="current()"/>
	</xsl:template>
	

	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->
	
	<xsl:template match="ogc:annex/ogc:title">
		<fo:block xsl:use-attribute-sets="title-depth1-style">			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="ogc:title">
		
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
						<fo:inline font-family="Lato">
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
						</fo:block>
					</xsl:when>
					<xsl:when test="$level = 2">
						<fo:block xsl:use-attribute-sets="title-depth2-style">
							<xsl:apply-templates/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$level = 3">
						<fo:block xsl:use-attribute-sets="title-depth3-style">
							<xsl:apply-templates/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<fo:block font-family="Lato">
							<xsl:apply-templates/>
						</fo:block>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	
			
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	<xsl:template match="ogc:p">
		<xsl:param name="inline" select="'false'"/>
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
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::ogc:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise><!-- justify -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::ogc:li">0pt</xsl:when>					
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="ancestor::ogc:dd and not(ancestor::ogc:table)">
				<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="line-height">115%</xsl:attribute>
			<xsl:apply-templates/>
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
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="ogc:title//ogc:fn |                  ogc:name//ogc:fn |                  ogc:p/ogc:fn[not(ancestor::ogc:table)] |                  ogc:p/*/ogc:fn[not(ancestor::ogc:table)] |                 ogc:sourcecode/ogc:fn[not(ancestor::ogc:table)]" priority="2">
		<fo:footnote keep-with-previous.within-line="always">
			<xsl:variable name="number" select="@reference"/>
			
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<xsl:value-of select="$number"/><!--  + count(//ogc:bibitem/ogc:note) -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" font-weight="normal" text-indent="0" start-indent="0" color="black" text-align="justify">
					<fo:inline id="footnote_{@reference}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"> <!-- baseline-shift="30%" padding-right="3mm" font-size="60%"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number "/><!-- + count(//ogc:bibitem/ogc:note) -->
					</fo:inline>
					<xsl:for-each select="ogc:p">
							<xsl:apply-templates/>
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="ogc:fn/ogc:p">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ogc:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt" start-indent="12mm" text-indent="-12mm" line-height="115%">
			<xsl:if test=".//ogc:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>			
			<xsl:call-template name="processBibitem"/>			
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="ogc:bibitem/ogc:note" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:choose>
					<xsl:when test="ancestor::ogc:references[preceding-sibling::ogc:references]">
						<xsl:number level="any" count="ogc:references[preceding-sibling::ogc:references]//ogc:bibitem/ogc:note"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number level="any" count="ogc:bibitem/ogc:note"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super"> <!--  60% baseline-shift="35%"   -->
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-size="10pt" margin-bottom="12pt" start-indent="0pt">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"><!-- baseline-shift="30%" padding-right="9mm"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:apply-templates/>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="ogc:ul | ogc:ol" mode="ul_ol">
		<fo:list-block provisional-distance-between-starts="6.5mm" margin-bottom="12pt" line-height="115%">
			<xsl:if test="ancestor::ogc:ul | ancestor::ogc:ol">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:if test="following-sibling::*[1][local-name() = 'ul' or local-name() = 'ol']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="ogc:li">
		<fo:list-item id="{@id}">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="local-name(..) = 'ul'">—</xsl:when> <!-- dash -->
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)" lang="en"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="1)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet_upper'">
									<xsl:number format="A)" lang="en"/>
								</xsl:when>
								
								<xsl:when test="../@type = 'roman'">
									<xsl:number format="i)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="ogc:ul/ogc:note | ogc:ol/ogc:note" priority="2">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block/></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates select="ogc:name" mode="presentation"/>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	

	
	<xsl:template match="ogc:preferred">		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}">
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates select="ancestor::ogc:term/ogc:name" mode="presentation"/>
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always" line-height="1">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>
	

	
	<!-- [position() &gt; 1] -->
	<xsl:template match="ogc:references[not(@normative='true')]">
		<fo:block break-after="page"/>
		<fo:block id="{@id}" line-height="120%">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="ogc:annex//ogc:references">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<xsl:template match="ogc:references[not(@normative='true')]/ogc:bibitem">
		<fo:list-block id="{@id}" margin-bottom="12pt" provisional-distance-between-starts="12mm">
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<fo:inline>
							<xsl:number format="[1]"/>
						</fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>
						<xsl:call-template name="processBibitem"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="ogc:references[not(@normative='true')]/ogc:bibitem" mode="contents"/>
	
	<xsl:template match="ogc:bibitem/ogc:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>



	<xsl:template match="ogc:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="bold" font-style="italic" text-align="center">					
					<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>


	<xsl:template match="ogc:formula/ogc:stem">
		<fo:block margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left" margin-left="5mm">
								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right">
								<xsl:apply-templates select="../ogc:name" mode="presentation"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>			
		</fo:block>
	</xsl:template>
	
	
	
	<xsl:template match="ogc:pagebreak">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>
	
	
	<xsl:template name="insertHeaderFooter">
	
		<fo:static-content flow-name="xsl-footnote-separator">
			<fo:block>
				<fo:leader leader-pattern="rule" leader-length="30%"/>
			</fo:block>
		</fo:static-content>
		
		<fo:static-content flow-name="header">
			<fo:block-container height="16.5mm" background-color="{$color}">
				<fo:block> </fo:block>
			</fo:block-container>
		</fo:static-content>
		
		<fo:static-content flow-name="footer">
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
	
	<xsl:variable name="Image-Logo-OGC">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAAxEAAAGRCAIAAACVKqnAAAAOF2lDQ1BJQ0MgUHJvZmlsZQAAeAGFV3c8l2/3vz7T+th79hEhm8zsvbN3ZYfM7MwSWZW99x4RQmYRIRUyQ0JEFMmW0ed3q+d5fX//PM9zXq/7dd7Xuc8593Vf7+u6z30AIGW38fR0hQMA3Nx9vAzUFLFm5hZYvI8ADmgBBggBlI2dt6eCnp425PIfZH8SwM5ujfGd5eoXBfXEN6gyXwYPR4o3Ur74D0H/NhN7QQ8EAIaFDFSOf7HIGbb9i9XPsL+Ppw/kc/UM2znZ2EPYE8K8XkYGShDOgTCJ419cfYZt/+KOM+xn53gW+w4ANIW7vbM7AHgLEJa1d/C2g25jAQCZdp5ekA/Jmb+8m5sHlJ/kBMJcZ2sBaUgsgwEQ6YfiGv+xefcC0KAMAMvePzbOFADoyACoCf7HtqP3Z31gNC+8b1wS/pMOhlEAAPUJh9vhguaTBMBpAg53XITDnRYDgPgIQFeAna+X3x9faPKwQQD+1/jve/4rAgERApEKi0QwIMvQQnitBKqEI5irxOukHmSHFPeoKKmzaNnpHjOIMDYzS7P0YNVY+9jU2V9xqHJ2XpTkruPl4ssSIBYMFFq+pCvSIEYv7i8xfplfKlJ6RpZXLkD+pSKhkp5ygsqQGpG6kkaQZq3Wog75FTldF71U/RcGy0ZExoImhqa+ZmnmzywmLXeukV/nt9KydrK5Z5tn12o/6rDuiHJicRa7qePi4Brkluhe6tHq+e7WnNemN86X2I/RnzNA+LZUoFKQZrBuiH6oYZjhHf27OuFq9+QjxCP57mOjKKIR0dsx87Fv4549yH8Y9cg93jBBPJEh8SRpLvl5Sm5qUJp5umgGecZ6Zn9WYXZgjmEudx48bzq/tiCy0KKIvxhePFlSWRpcdqUcW75d0V2ZUmX3+FI1onq0pvCJR61MHVHdVH3ZU+8G+UZM41RTyTPPZqkWvJbR1tw2x3bh9pOO/ueJLyw62To3up69DO1W6yHt+fAqv9exj79vr7/jdfiA+huSN2NvM95dG2QdXB6qHHZ9L/B+e6Rp1H9MYuxovH0ieFJ68vRDx1TwtNT08Uzbx4BZ8dn9T41z3vPC81sL9Z9vLQov7iw1fQlYllmBrwx8TVq9usa5tvet93v6uuuG0g+mHwebkz+bt7K3w3dcdk33VPZFD7gOmX5RHmGO0Sfg5Pj06PcRDgfxbwnfQbqiNvCc8ZcITYkmiLVIXpPJkjdT8lJV0jDSJtPjM4Qy7jA7sExg1Vmb2NjZ4y8cclpz9XHz8MTyrvKrCOQKbgurXkoXWRLjF/eRaJbckxKWdpUpkB2TRygIKloohSkXq/SqLqnhNOg1hbXUtC10XK4E68bpZeqXGtQbdhj1Gg+ZTJrOma2Yb1jsWh5dA9fRVhhrChtaW2a78/YcDrw3hBxFnS47y95UclFxVXfTctfx0PXUu6Xrpet9xUfLV91P2V82QOK2YCBX0LlgqhD8kOPQjbC5O0N3n4dX3UuPuBfpet8kSjb6QgwmZit2Mq7tQe7DsEc28QoJrAm4xLmkjuSMFN9UvTSedFT6fEZrZmKWc7ZCDl3OZm5fXm6+V4F6IUvhTtHr4twSr1LVMsayzfJXFZmVblUKj2kef6vurEl+4lQrXUdet1Lf/jS+waHxchNp0/Kztub4lhut0m0UbWvtXR3pz91fqHae6zzoGnn5uDuyx/qVdC9d717fWH/968SBW28M3oq+o3t3Mvh5qG+45n3qSOio05jhuPwE3yTjB8IPR1Pr03MzIx97Z9s+1c6VzmcvJH2OWbyz5P/FfdlhxfKr3qrKmuQ3nu/M68Trxxtff4xstv7M2wrftttR2GXZPdwb2i8+8D1U+UX5a/6o4tjjROzk5LTrdzhOEfcb4h8B50XIIY1QbugYvAL8FoIhwmUMIKYm4SGVJTMhd6EIpUygKqVupnlD+5HuO/0JIwETDTM7C/85UawMq/J5VTYNdq0LGhwqnHJc4hf5uVl5KHjhvD/4pvi7BMoEY4VchbUvcYkgRGZFG8Sixa9KCErgJIcu50g5S4tK/5bpl02QM5M/J7+iUK14S0lc6Vi5SyVSVUONWG1EPVXDQvOc5pJWubarjpDO/pV23bt6avoY/VGDTENrI06jH8ZNJsGmymYYs3HzXAsHS37L/aud12KuG1gxWa1Y19kE2qrYkdnN2pc7eN+QcyRynHIqdfa6KedC7DLjWuHm567sQeGx4Fl7K8RLy5vee8Wn0TfcT9ef0X81oPH2nUCtIOqg+eDKEK9QqTBE2Js7iXfNwpnDF++VR7hE8kdu3W+M8ouWiP4V0xYbFHc57uhB28PAR5KPfsW3JPgniifuJzUl+6aIpuylNqX5pYunH2a0ZYZkyWUjsvty4nL18mjyPuWXFLgWihbiigaKU0tsSwVKf5cNledXeFWqVjFW7Tx+W11Wc++JXa1KHXc9ef3p0+8Nc40TTSPPRpunW1Zaj9qpOySe271I65x4ydJ9q2e4V6qv/rXEwMBbl0HGoen3ZaMR456TrlMBM8mz7XN7n2WWEpa3Vq2+TW6Yby5vB++RHTw5Mjklxs0A8LfendUEtBgA6YkAmLUAYAzVngfUUHkzBYCmAgA9YgCMJAH8ZzGAN3UDWMUe+Ff9gOoWChACckAP2IAAkAIawBw4gyDwCBSBFjAMvsIAjAEmCjOAecAewZ7AhmFbcGq4JNwKHgmvgU8iAIIXYYa4j2hCfEHSINWRwch65FcUC8oUlYh6hyZAq6Oj0K/xiPB08VLwZvHZ8T3w2wkICMwIKglOCPUJK4hgRJZEzRgajB9mmliGuIQEQ+JPskRqQNpDJkb2mPw8eTYFDUUyJQVlMhUNVTb1eerHNKI03bT6tJ/pvOnx6HMYRBgGGZ2YUEwlzMrMKyyx5wTPTWHvsvKxzpyPZZNi22QvvXCNg5ZjnDOZy+gi/cV57koeX15lPhq+df5XAvmCoULW0NdPQIRJFCMGxA7FdyS2JfcuH0ujZahkOeSk5I0VvBSTlJqV51UJ1STVXTWKNGe16XXMr+TqLusLGIQYDhuzQ7t4ylzcItMSd83p+oS1sk2LHb99+Q12x1Jnrpu1rhJuvR7GnmteYT50vk3+RgEHgbnBqiFbYQV3De7hR3TdD46WijmN634YF2+ayJl0lDKSVp0Rm+WSo593uYCziLYEU4asAFWgGvmEqI72KUejxLMrLU5tER3FL151fe0h6hXsNxkIeps/+HL488jpOO0k35TsjOas/pzRgsGi5hfZFb5V2rXf3xc2Ojezt3x3tPew+9uHr4+yT1x+S57VD+gfAgWIAAVgAhxAGMgDXWANvEAkyAJ1oB8sgCMYNUwYpgtzh8XD6mBjsAM4E1wRfhOeDH8OX0NQI5QQ3ohixAQSHymD9EZWIZdQzChzVBpqAk2NNkVnoxfwOPE88Nrw0fhG+CX4+wSaBIUEvwgNCeuISIk8icYwkphCYgzxbeJVEguSYVJV0k4yKbI2cinyTgoVikFKM8plKl9qNHUWjRDNAK09HaDLp5ejX2SIYuRjnGS6w8zLPANxLn3uJ7aU9ep5mvMjbI/YdS6QXhjlyOC04rrItXfxFXcqjxOvLB8t3zb/e4F6wVShYGGHSwYiiqKiYjzi7BJYSexlNqmL0pdk5GX15OzlgxRSFRuUxpUPVbFqWuqBGtWan7UZdEyupOpO6bMYOBo2GiNNTE1rzNEWtpYvr7Fdj7LatDG37bMXdSh3ZHRKuknkEuWGdI/wxLsV503hk+3H4d9wWzFwLPhGyElY8l2e8L4I2/sgqiBGPnbxwf1H3PHDib7JTCk9aS4ZVJnPs2/kkua1FNgUERY3lF4tR1XUVJk8/l1TWqtTt/s0u1Gxaa05vlWs7VNHxAvezvGXIT2cr0b7wl7zD8y9TRxUG8K9bx8NGpebxPswMV3xMfyT7bzmZ8klwWWBr+Jrmt8dNmI3W7e2di/thx4OHl84jf7DPwIQAEqABYJAEZgCDxADykAvWIERwgRh5rB7EOfzcHK4CjwQ3gDfQHAjnBFViB9IEeic96OoUQ6oZjQx2gHdiceMF4q3iK+B30DASpBEiCYMIzwmCiLCYaKIKaFTLUkySupJRkHWQm5PQUnRTxlGJU11St1NE0drRneR7pR+kqGeMZHJm9mcRfEcH5aJleQ8/PwR2y77zws/ObY597lOufF4qHjZ+ET41QWsBAOEUoSfXhoT2RNjFFeScJPMvNwvdSjDI2stly7/XhGjpKkcqzKoRqFurlGsuaktp5N4ZUVPVj/T4NDIwrjTlMss1QJlGXh1+7oHxJ2P7al97A1Gx3pnrZurrrHugh7Tt6K8JXzW/UoCrgcyBc2G5Ic53OUN3494ef9R9NVY3rjTh8PxRRBr6qnMaVsZvVlZOe55CgVUhSvFzaVR5caVrFXfqxue+NeJ1+821DTZNJO2tLRZth88f9jJ2FXUzdqT0Yvf59k/MsD9JvBt9yBySH7Y533BSP/o2jh8gnaS84PglOi06IzgR65Zhk+En3bnZuc7Fwo/hy6aLwl+QX/5sFyx4vtVcZVgdXQt7ZvFd6bvs+s5G2Y/qH8Mb0b/VPh5uFW7bb9Dt/NuN3RPaG9hP+FA4WDnsPSX0RHyqOHY+oTkpO3U/jfJ7yacxRn/f3ukPz0FtZKHq4cXVltJGatk4+ps62Xj4wD1SX+FGihBm8MVurygzaINjZQhrQRsIJszsIWsNsAHOIA/Af81078z/m/t4xAA9WwAKHl43vZydnTywSpA3acDVsPdjp8XKywoJPTfc/zt88580FC/lmN1hrqYHe6c6f8v/wcmwgOELRs6bAAAAAlwSFlzAAALEwAACxMBAJqcGAAAIABJREFUeAHsXQVcVMv+V7oFBCSlQxBQQVAM7Ba7u7s7r9199ZrYXVdsEVFQUUxAUFJBUkBEpPP/8+3771th2To1Z3d8vPs5e87ML74zu+c3M7+oW1VVVQf/wwhgBDACGAGMAEYAI4AREIiAnMCn+CFGACOAEcAIYAQwAhgBjMBvBLDNhOcBRgAjgBHACGAEMAIYAeEIYJtJOEa4BUYAI4ARwAhgBDACGAFsM+E5gBHACGAEMAIYAYwARkA4AthmEo4RboERwAhgBDACGAGMAEYA20x4DmAEMAIYAYwARgAjgBEQjgC2mYRjhFtgBDACGAGMAEYAI4ARwDYTngMYAYwARgAjgBHACGAEhCOAbSbhGOEWGAGMAEYAI4ARwAhgBLDNhOcARgAjgBHACGAEMAIYAeEIYJtJOEa4BUYAI4ARwAhgBDACGAFsM+E5gBHACGAEMAIYAYwARkA4AthmEo4RboERwAhgBDACGAGMAEYA20x4DmAEMAIYAYwARgAjgBEQjoCC8Ca4BUYAI4ARqAWB77kFGdm5KZk/UrN+pmf/zP6Z/yOvMDevICevqKC4BP7yC0qqysqLK6sqKysrKivlK6uK4Qo+1qlSUlBQVVFUUVRUVVaCC01lJQUlBTVVJR1Ndb16avU01Rpoa+rX1zLWq2dYX8vMsL6KMut/r9pO3JHx/SdgUVJRoSwv30BP+9buGTpaarWgi28jh0BRcVla1g+Y6mnZeZnZPzN+/CooKMrJL/6ZXwQzvriioryyom5FVXF5pYqCnLyigpKSvLqiopqKkoamqq6mmq6GmpaWmhFM6d+zGv6rpazI+lldXFLeeMiaqjpVvKN1ZcuUZg4Nee9IxzXrRwupYYCvS3FZeUlpWXlFZd3f/+rA/+Tl5RTk5OQU6sr//o+cvALe20Nq0LAwoiLwNSMnJjEjPjkrNvnbl6+Z0SmZiak5JWVlovav0a68vLSwuLTGbf436tapY2qoY29iYGGmb2Nm4GRl5Gxjam6ky781kncDQj8+DYvjFS0+NbustJz3Dr5GBwEwBeKSMj4mZnxKTI/7mvklNftLeva37Lw/TANi4sKsBvvJ0kTfyrS+lYm+g7mhs7WxrYWhkoI8McK09v74JS0hJasay9ISyX8ZqpGq7WPOz4LAN9ERcamR8amBb2KKikuVFBWMtDXMG+q72Jh2aGbn7e6goa5cW3fJ7mObSTzcCopK07Ny07Jy07NzYZ2RnZOXmfsr+2chLDbiP2ek/vglCjn4noDlJA/WFPxf7rctBR/hhqaqkrqqkoaKsrqKsqra72tNdbUG9bUMdbUa6Goa/OcCliakTwJRZMZtZA0B2AuKik97G5McFvs1Kjb1bWzyj1+FDIIAL6rkjB/wV+dtDFcMTTXlxtYmLramzZ3MPRpZOFoZo7wmOXAliCs5vkAQgZ8FRa8jv7yLSQ6P+QozPy4p6/d+KJX/YFan/d6y+vk8PJ7LR0FBzsbUADZp3B3Nmzcyb+pgDu8C7lMEL8JjU+iU6ld+8Xn/V6duvQiNTKw2QKXlFXFFJXHp3wNCo3edC1BRUujZxnlq/7adPB3JkrBuVRWJRjNZUqFCBxYWEbEpEXEpsSmZCclZScmZabn5jAunq6VuZaJna6JnZ2XkZGUMf7A6AROMccGwAGxHAM7RXkYmPAtPCAn//PJDwq/CEnZppKqs2MbZuq2HfSd3B3dHC6Tsp5SMHxY+yyoqq//efru/3UBPi104S5O0sHv65E3M07D4Vx8+f0hIqz48CKgK62pXO7M2LtYtXK1bu9rAbisCQv0hwqT1p475hfxxq06dF76LQeBqNwl+BE+A3ece7rsUyPvTZGqg01Bf29hQ185Ur7Sy8ltO3qfPGWFxyeXl/7N3m9ibbpzet0crZ4ICQHdsM/2BIawznofFv4j4DAbsq6gvcET9x2NUP2irKDk7mHs0tvBsbOndzM5AVxNVSbFcyCEA+0mvPyY9fPnxwcuPLyM/8/7QICerOAJpa6h2b+Xcp61zVy9nbU1VcbpS0nbpvmtbT/vXJI1tppqYUH0Hfud/T/gXH+Fk53NKNtXsyKVva1S/jbtdJw/Hjp6NEPmpN++1DEzPamqSbjP5PQ6buPFM9n+2LeTqynX0cJjg07JLy8Z83QHhRCjoXczZWy+uPQmDzSeObD7eLseWjwIXyWqiivUR20x14ND66ftYeGE8fhMTFpNSba9PLDRRaAzbTeDn0cnTobNHo9ZNbPFBHgqDgqAM8JtyL+TD9cCw+yGRzB66UQ2OooI8fB0GdnDr492kvrY61ez40ocNPNOeS/iuwbDNxBcxKm4mpmRff/zeLzg85EOCFKwN4Ke+cwvHiX1bt3KxNjbQpgIxUWh+/JzuNHhNzZYk2kxlFRXDlh+99ug9cAGth3ZyWze9r01Dg5pMa97JyP655fi9g9eDOZaTib729R1TPZwsa7YU8Y7s2kxZ3/NuBUfcDAp78OpTsZS6YYIxbmdu4OVs2b21c6/WrlIQdiTitMbNakMAXt7Xn7wDU+nBi0hpnfa16Q7GUw8vpxE9WvRuQ/d3YePxuyv/8eMrGLaZ+MJC4k0wlc49eHUl4G14HK1uNySqIJSUo6XRoM5usDBobGMstDG5DVbs/3fTyfs1aZJlM0GgYv/FB++HRAGLhoa6Z9eNb9PMtiY7wXeS0nOW7f/3woNX0AyOZW7tn9O6iY3gLrU9lTmbKTM775L/64uP3ryMqO4+VhtG0nFfS11laCf3YT082rnZS4dGWAvREaisqAp49fHUnZc3noSJHqomOn12tdTRVBvRrfmY3q3Ax5YGySG6x6bvyto287DNRNEQFJaUXnrwxtfvOa97NUW80CHrYGE4sGOzEd094YIGqSBU3Lz3stSs3Jq8SLGZgH7PufsfvPxtMMFh3NWtU4mcsx/3ez5l81nYYoTYkee+i51tTWuKLfSOrNhMcBJx7dHbs/deBb7+VNMNUyhM0tTAzFBnZBePET08nWxMpEkvrAtfBGCBdeRa0InbLyCjDN8GsnwTzjRG9GwxqnsLI/161OEwa+v5/bVHzGGbiXTk4bToyNWgE3de5BUUk06cLQRbOJmP6NlyaJfmetoa1Mnse/3pxE1n+dInxWZasPsKhL8B/f4dml7YNIl4CoYL916NWOULnv5WpnpvTq/g6wvFVx3uTem3mT7EpRy5Hnz6bqgsf3+44817ARksxvRqMba3l249Zpw8eIXB16Qj4P8i6sDVJ7eDI9nuokc6MtUIQlwSeNSO693Cx7sppNas9pTgx2dh8e0m7xCwTsM2E0GEud1hM9Uv6P3By08evvlfNgruU9m8+H0e3cp5XO+WPdo4K8qTnPMJTs3s+q+CfLZ8sSVuM/k9Ceu78CAQ7+zpeGffTJB/2uZzAS8/Vv4n8SGk0JSrqlNWUalUt24lJOypW1dFWVFLXVVLQ9m4fj07C8MOv4Nn+Wwk7zztv3DfNSA7opvH2Q0T+Aov4KbU2kzw/bka+G7P+YAXHz4L0B8/gvDsUd08Zwxu52JvhtGQAgTA1fHs7Rdbz/jHJn2TAnXoVIFzfg1bsG3d7EjhC6HRbiM3JNUIKeIljm0mXjQku4Y4uOM3nh+8GAiJeSSjIPW9THQ0h/TwHNe7FYkOT1M2nT1y/Wlt0BG0meBo1bbPSshcBTk/oy6v4WwIRcWnXn70bsuJe9xQOA731ZN66Wupf/iSFvwuLjYpk7tKhI3kbXMGdPVqXE3IbjP3cc77/PfPAT/6ak8Ff5RCm6mgsOSE3/N95wPw90fw2Fd72srVZtZg74Ed3ZHKalNNSPxRAALg3334WtCu8wHwQyOgGX4kFAHO+fWQLs1dHSRfSMCPfpcpu55HfhHMDttMgvER/BRCebad9T98LZg3YY/gLjL+1L2ROZwtwJkdwRjSc3dejvzrhAAwCdpM3N2g69um9OvQjJcRhFNAUAXvHTCqHK2MOHdCwuM7TtvNG+Cya96geSM68bZPz/rpOOiv3PwiV1vTsAureB8JvZYqmwmsJch2tfPcQ1jeCdWc6gZwimxrZmBpogdmMmwVgueahrqqh5MFnMhCUZWiklKQNjuv4Nv3vPTvP5PSv39Jy/6YkPE5NZtrI1MtIV/6NiZ6y8Z2H+XTkvSNXL7s8E1SEAB3vQMXHm0541+bozEpXIgTgU1NPR0Nfagip62pq6Gipqb8O+u9qlJdOTkowVZRVQU77XCGXpD/u4AXJGKBbf/MHDJLVYirgp15A3i7DOnszv1FFpEC/Cj7zD/w5lOS0PbYZhIKEd8GgPDW0/dhn6OI+hodfAVg9U14DfVs7Tyml4RndidvvZi4/pSAE2cAh4jNxHUt93KyfH5qaTWon72PazNpB+9NXpsJ7u8683DB3qvcBhA//uL4Ig9nK+4duNh/IXDWzktwcW3rlP4d/7DJeJvVvJYSmwmWdPsuBO4468+gtQQ59Lyb2Xo1sWnuYO4MGUkl8rwDRaB0zvOwhKB3ccHvYpl6BUJI57Kx3cb1aSUF9SNrTnppulNSVn70avCW43dFrNtDm+6Qrb6xtbGDpaGdqYG5SX1LYz0LIz0JlraQmiX1W25sUkZs4reoxPQPMclQxYV3EUmPRs42JiO7NB/UtTmsgoRyhCX4kj1XRRwRbDMJxbNaAygCvf3k/T2XArG1VA0ZCT7CV3JYZ/chXT1EjL2HuiVL9l8/dDUI3KgF/yNiM90JCu+14B+gz9eg+ZySZd13JS/3ajYTCKndfh7v7sOwTm7nt0zm7QJ5GY27LYI3bCc3+4eH5/M+EnzNepsJshiDzbvqoB9T5xENdLWGd3GHzUMvF2tyT7Vg3R0cFgvB4ZDLqzY/O8GjS/AppP9aObHn5L5tcGEWgkhS1P3i/VeL91//XYINjX+Qbq6pQ0MIdYYESCS6TVRTDqyoD3GpIREJga+in7yle10BR9hDu7r3b9eUbxbByPi0FQf/vRkUUU1mAR+xzSQAnGqPYIWw5/wjcGeBU5Vqj5D9CItn0wbaFvq69XU16mmqQZ4LVSVFJViMyslVVFVWlVeCM1bOr6K8/MKcvMKcXwWJqd/h117wFg4VysKv/aAOTXu0cYFMyHwjIWBj78ytkL2XH4v4qiViM41YcfT8gzdgz6Xd314zVi4tM9ekxxJeEKrZTPDIsMsiKKLCbQOnPWn3t3E/ci6mbjp3+HowXCfc2GBlql/taW0f2W0zPQ79NGf3lQ/xqbWpR919eD109XKaMahdDy9nqk0KsAsh0z8U9LkR9J7+9LWuNsa75w9p7+FAHZiYsrgIvI5KnLPjEiLxDfBr26+da7dWzrBskCB2V1zdedvDV+Ptp69+QeE3g8Np/h2A70VzJwtbEwM1DZVfBcWQODE4PD46MYNXPFGusc0kCkrQ5vqjd0v2XYtPzRaxPSPNNFSV3RwbNrM3d7M3g9AtqASqqaEiriSwKkhK/f45NSvma+bbT0nwZY9O/Ma7ayIuQbHaKysqutubOtqaWJnoa6qplJSWpWTkhH5KDP3wRSxLTmKbCdTX77gAkuaP7tny1NqxNYWHOi1QrYX3fk2bqX6H+Tl5/3PRgTyWP579zdsFru8/j+w+5/fNXfMHzRv+h8NTtZa8HxV4P7DoGizNhbsuXwh4S7/MUHR6dHfPJWO621k0oIe7nJwceP7DH5T53H0h4Oi/T+l0eAyPT+swfTfUndg5d4C1mUjp6umBRTa5gJfPkr1XT9x6IXRvnGp84PUwvLvHyG6eEqTlJUs2+GqA4QJ/G6b3SUjOPH/v1Zl7oXHJmWTRF0AHvhfwJ6ABfkQWAlEJaTO2nQ96G0cWQXLpqCgptG9uD7mC27nZudmbEz9tAF9SKAwCf11aOnFEhfCOd9FJwe/j7r2IFNd2EVfZkrIyCFwQGrsgLlnR2z99F8epMtTDi39EW3FxmWBqUC+F12CCxnyTEXq72UMuhrLyCv+XH6XZZoITq70XH60+dDO/iO6i67C3NLSL+6bp/SxMhfs0CB5UyZ5CReud8watGN9j88l7+y89ptOrwy8o7N7zD4tGdVk1uRd2cpJs+Ij3On3nxYLdVzlVKolTk5hCIwujHq0bLx7ZxUCPULVLiQXg2xEMepic8Bca8fmfa8GXH76m8wvCVyR8kyACkAFoo++dbWf84cVGkBTp3cFjD7ZXe7d17dzSUU1ZiXT6vAShbCjkv4A/cJYAd66HoZ/uPPvw7+N3dC6eeeWh9PpFxH/TA0GCJb6MYOuL733uzQv+r7nXnIuhXT2q3YGPcATpZG0ERWYjYlNqPq3tDsv2mSDB6+R1pxgxgZs6mB1cOsKzsWVtUNJ2H1JQbp8zcO7Qjov3XYVDX9r4QkqMjSfuXXv8/sjykQxuLdCmL1KMwO1x8qazj15FMysVJM/dOK3v0K7NmRVDMHdPFyv42z1/0DG/Z3vPPxLR/UIwTfyUfgQehETO3HoBtcM42JmAiLPRPTx7tnWt6WpDA0pw/D24sxv8HVw+/ObjsFN3X4LnhlinZjQISYRF7Nff+8Tmhrr69fkvySDqXAB9OIPadPwebwN7iwaTBrblvcO9tjFtADaTWD8RrLGZYHtpx6n7q4/egZ1DrsL0XECA9MbpfecM7Ui135JY6pg00Dm3cdKEvm3AkY2ewwiOeOCx4T15x5QBbbfPHgirH7Fkxo0lQ+DQteBlu6/kFgv6pZCMsui9wJUVEsfBuDPynhBdTm5LWFosHt0V8rJAtYRNJ+/FJOIMn1xsUL+ArZSZ2y6cv/8KKUEN9bSm9/eeOqBtbe9ymqWFza2h3TzgL/Xbj51n/A9eD5aOjVXOwZytSa1O2YW17DOBNz2Yjwv/3ImH7Dk3dkyv7WzErIEOZ9Qgu4GIh6rssJmgZtbIVb5QhYDmSQns3BzMz24YT0+9Qwm069DcIeziqqV7r+2//IQ2BxdgBG/xx29jLm2YRCTpnwT6yloXiFUZv/4Up6Y3U7qDT+iC4R0Wj+9eT12VKRkk5guuIaN7tRzZvcWlB6/+OnqbztWFxDLLeEfwzJ2w/rRYS3+qEYONiuXjug/r5oFm1jpYP+9aOGTh6K47Tj84dTe0misP1eCQTr/qP+ewcoq1Vnqpqqj+rnMavKamGC2drcb0bjmmp5eKcq12DiSH43SsrFtVK78/Scv9+RHFTxcfvHYdto4Rg2nO4PYhJ5cgazBxRgtWG/sWD7u5ewZUfqBz/GDh7j5207ztF+lkKlO8oNwS/BYwazBB8pIPF1dtnNWfjQYTd7bADvGwHp5RV9fsmz8Y8qhx7+MLpBCANL9QjgNCmdAxmODH/+LGCR8vr4EYLjQNJu4IQvILsJzS/bdf2jwZfK2499l3oQCew3XAlU10yTfP7DfBx6ta+4l9Wk3p31aAwQTtlf6/Bp9c1W+movxD2maCbBxQk2/YimOczTpR9CGrDaytIcpxz+KhbDmJ6NXG5fWp5TSbd5D4YM+lx63HboGQJbKQx3QAAXAdm7vzEtSnZCqpKcigqabsu3IUZHuzNacpPpTqoYd33qzhHeNvbJw5yBvq8lLNDtMXCwEIqncZvk5A/TKxqBFvbKytcXDp8KhLayDfI4RnEidIDwV4YYGrU8SFVXOHtIeAPnqYkssFUh4Cwczc/2VXEkq/V2sXSIgDScN5W64+fEuo4fX913/zEYh4MAf00Z0KcB7Xevw2OAPiRYGea0g7FnhoLiws6GFHFhfIffDq5LLO7vZkERSRDrjku4/aBA6bIrbHzQQj8CU123vC1r0XAgU3o/RpM4eGEedXj+/bmlIujBCHRHl/Lxkedn51l1qichiRSsaZ/n3psde4rZ9TkMi9BPb0/BGdom9snDrQGykfVtEnCZzW7V40NOHGxsl9WrNucdDQ4LeP0ZeUbPAxElFlDRUlyIM1aaA3b/vUrNx/Lj/mvVPzmpMsGjJe1nxU2x1EbabHb2LcRm0QpVpTbYpJfB/ge3pskZerjcQUGOwI88Zvz6yuLf6b1YM2SSAtb8+5+xkxcGnTkR5GAaEfwQB9GZVEDzu+XPq1a3Jv32ymEmrwFYn0m5Cm/MGheb4rRtF8ok26ImwnCH67A5ccmr39YrVK9UzpBauFV6eXQ0oXCXJRMiVzbXzhtO7wqlFPDi+AcNfa2iB4v6nd78LYMB+gjJiI4kEaTGg5uqdnn7YuvF3W+d7JzPnFe6faNQTNwZ0m9qbV7gv4iKLNBOnMu8zcw0jlOGO9ekGHFzhZGwuADPFHkHPCb/f0alOHBpkh2BUOUuFESfTFAQ1SsYvF7nMB3WbtY9aFc9XEntd3TDPQ1WQXdJJJO75fazh86eZF9xpDMmmlrxeUmmk2YgPUhkJBNUgisGlGX/BwALMJBXnIkgGyOsGe8aR+rNkzbv7/R2z3Qz+KCALH4IYj1C2zB0BFXm4vKPi94dht7sdqF++ivyakZMHN7p5i/AL8j3o1cox8hEoI4FMMwfP0VwgBfeEA+/GhBVLgvQFxlRc3T4HCWPQPIpwoeU/ZCbGv9LNmNUdw3Ru1+vj83VcYzLMCOTXA3XXdVB9WIymu8JAnFjbVjq8egzecxIWOYPubQWEtx21B5DwOIuNenFiybFx3lh7GCR4LdTXlIytG3d45XbLK8YKJk/4UMuVyzNZLD1/zJ15VPW6OW60ZPHpH9vDk7XXo+lOoa8R7h3t99vYLznWPNs7cm0IvELKZwF1rwOLD4FMsVGgqGoDH6639c2grh0KFCrw0IVjAb+d0Oya8d5+Hx/eYvQ88OnnlwdcCEMj5WdB52p6zd0MFtKH6EfhdPjmyANxdqWaEJv1xPl5h51e1cDJHUzzpk2rb8Xt9Fxykv5YDXyRHdPN4d26lWyMpH/2e3q5RF/+i/wiCL+aCb47p9duZ+H10cmjkl5otC2rkZ8r5mc9tBqs+COHifoQM8sv3X+d+5F4UFJVCXgb46GprKlZNMFRsJnhtdJqx68aTMK5KdF6A09/VrVOkbEsWfF0f7J0N/ux0IsnhFZGQ1mHqroiYZPpZs44jrIG8Jmx9GhbHoOSQrC/4yEKP/98SZ1ASBllbmugF+S6ZN7QD63xmGQRNAtawpTp8he+Sf25USdCZ7C5wHrd/8bCzGyZQXfyEbMElpAdbODd2zYB4WMQn+YyB7eDYB5TcdOJuTVUhPqzazViewG1zI93pg7x5G0BdWtjU5L0D14evBXG8IMDfv9ojwR+RsJnAS6vDlB0h4Z8Fy0rd07VTfbjVEKnjQj9lcOOFjAmMfD3gILnbnL8/iFPHh358GOcIu3Gtxm5mNkU1GExwJC01O6xExhTitCHDTfDRhXBMSYQO7lsbAr/yi3vN3HfhARIJvmFVGXhw3ozB7WqTVlrvQzzsv9unoZzDCSL/+3RyA/xvBkVAQBjvQIDr0tk7Ibx34Pr4zefFJeXcmysn9Kim3ajVJ+KSvnEbZP3IX3/sDnw00deGROrc+6JcMG8zQQnidpN3MlghfHg3j4WjuogCFhvbQAnJpaO7MiJ5evZPt9Gbjt94xgh39Jk+ex8Hu3Fpuf/bVaZfZo7BRHNaL/rVFItj66a2z3wXW5vWWrpBLGq4MRcB+KlvM2l7wNs/XoHcpzRfgN9C6ImlMNY080WEXZ/2Td6fX+mO8HEk1FTlfAenbTnHSbPECbF0Gbq2ZlgxnOI1HrKm39wD/wa+A4ShbtLaSb14oYY1vNuojbvPB3Buztl6HmK94Rq8/sVNwVi3qoY7FS8nqq+hnF67KTsZLGhgZqgTdXGNFISVChgpCGRrPWFLzXkmoAuJjyCK4cKmiZBmjUSaUkAK0ln1W3SI67rIiEbYYBIAO0Qvj1l1/IL/GwFtSHn07f52ODEhhRTKRGCV33Pm3rj07ygI2aqx5c29s+DNioIwDMoAezPj152iaNvvhe/iFq7WRLS7eP/VsJW+QGFUT8/Ta8dDiNiBi4/L61RBvvii4tKS8ory/6QYUJCXV1aQV1NTrqeq4uFiyfExgO+v77+/l+tlFZWcZop15ZxsTdq72++//HjWtt/lK9o2tQ06ulBcCZm0mb5m5LSfupPBuAkwMJ/6LpIFN46Pn9ObjdhIf3ljznQEnO/vndXes5G4s1Na21999BZcOsA5kUEFwYfPb9cMqNDOoAyIs4a64IOWHb4eSG0kvCzYTPD7A1uq33LEyOxM3dzo6OHgt2M6hJJRx4JFlMEQmbT+9PFb/40gI1Fy4jYTCDNipS+nVDOkNYcsncTFg42oQUuPQHgyxMmGX1htYVxfXJqMnc1BsuNOk3YwaDABUpum95UFgwk0dbQyWjPlj71KcScKkfZwAt1rwT+Br6OJEJGavufuvBy67CizBhOAeX7jJGwwCZ5UEHZ+YdOkLi0cBTfDTwUjAEmYukzZiYjB1Ke18529s7DBxB0yyGnk+9fYyf3bcO8gdXFk+chGFkYgEgTUT954hmDyvxM3QwYvPwoGE+f0QwKDCSRhxmaCau3t4UiO0X1aiCueN6IzUvODUmEWj+rqYiNGtlNyhSksLu01d//Dl6LmKCOXOzrULvm/GbP2JINJmDhQLBvdFZ+WijIrYIsUql9D+U/eRHmidMRtOAh8iEvpOnVn6g9BuZhpwwrM30vbp0L6Oto4soXR4eUjZyHpCw/W7d19s8CFBpA8+u+ztlO2SxaOnV9QAnkf4SASUj/Cd/noypE9Wkm4xc6AzZT7q6jrrL1JGdXDBemcXgoKcoeXj5LK9GW1wQjK7l9Mwt5mbfSF3gffHZ/5Bx6/kt3dJr/HYSNX+zJuMHm72W6Y0U/oeOEGHATgFXts9ZgTf41mJP6U1aMQFZ/aYdpuZqMcuAB2crO/sWM6Npi4gFS72Ld42LQ/67VVa8DUR9gNenZsMWwQggAQXN9kxIbhS49EJaSJKA/4j4Prd6NBf0F9EegCyXeeHlswvk8rEbvXbCa/Zs2amnepuwPAy0/pAAAgAElEQVROZ91n73vzMYk6FqJQnjO04+jev7NmydQ/c6P6cV8zP4hcxId0cMorKq88egfl8Iz1tUknjjjBO88+DFxyuEzkqpMUqQO5W4OOLJTuoAcqoHO1M9NQUfYP/UQ68UUju0jlUREkHms3dZfgal+kg1kbQWcbk/v/zNHAPky1AfSf+3BYH0/eC2Jin1amhroCGYr6sJ6Gav9Obrpaag9fRlfVqYr8nH7o2tOYxPQG9es1rJ0F6LLr7MMJf524+vg9xM0Bs06eDv5/z3GyNhGVMb92tPqAg09lv8X/QMYFfpLQdw+KysVcW6+hLos+gFDVxKbfyuLS/6WyoA/3/+cE59NBh+fr15f+WKH/17gO7K51n7OfKR98rhjg933qr7Ejerbg3sEXYiGw8h+/jcf5JNkTi0i1xlLpA571Pa/lhG2cYl7V9KX/I5zsvDy+FArW0s+adRwLS0rdRmyMTswgLjkpPuDVxPj0JX3LyQfnH4Ryq6uZ6Gi6O1uaNdBRV1WWV5AvLSvPLyz59j3vY2I6b947qFK8ZWb/Qf/J+VSNprgfabWZpqw/c8SP+Ww959dPGNZdvDRW4sKKcvul+65tPe3PrISdPR3v/z0L3A+ZFYMe7pDYs9XEbb8KS+hhJ4DL8jFdN87qL6ABfiQUASiISW59J+mzmSCPjvfEHeFxKULBpKGBmorSy+NLnO0Yc+WkQUdyWcAGYdupO5IziNYMpcJm4mgKEfeHrzy5HPA2PjVbsO6wSuzQzG7SQO8B7ZuR5YpDn8206qDfBl+Sl2iC8eL7tKWzVciJJXwfycjNH3mFVj7LORm9GFQZUm6c/Gus1JtNKRk/PMduTsv+ySDUHNbmhrqfrq5TVcEZrgkNBRgEbSfsiIgnzSCQMpsJ8uJ0nr476C2TtYB4B/jipklDurjz3sHXQhGA7RzPMZsJLvOos5m48r8MT7gS+C49KzcxPSf524+i0tKqyjo6WmqQ3dvV1sTTybJzSycDXU1ue1IuFEihIpTIpQevUDCYQM7d8wYJlVa6G8CUWji6C5wyMKvmmTuhxvXrbZk9gFkxKOUO4Q495+xDwWACNQ8sGooNJuLDXU9dNeDgPK+xm4WucYnzYiOF6ZvOomMwLRzVGRtMEsyiRpZGp9aM7b/4sAR96ewCOTMJps2UQFo6DkdeRyWOXXtKAuFI79K3XRNPFyvSybKO4OzBHbQ1VBkXe/uZgCdoFFKgAgrISjVo4UEoV0wFcXFp9vFuAlXNxe2F2/NFQF9H48bO6RqqsugQyRcQ7k1wuT3mV70WGPcpzRdeTpabZuL4UAlR79eh2bzhnSTsLNXdKLeZIG6i38KDzDodc0YQQoXXTe4t1aMpqnIQNjVneEdRW1PWrrKqcsSSIwk8JakpY8UAYVhwI1JaCyrO7ls0hAEIpJelk43J2fXjcfYB3hG+/TRi0d7rvHcYvIYsz+c2TlSUl2dQBraz3jK7v5uDOdu1IF1+am0myMs+fOWx1Kxc0uWWgGC/Dk2xJyAXN8i2oK2ixP3I1AXkbuk262/wEWFKAIr4HrwS5HsTlQX38rHdBETkUoSA1JPt067J+ml9pF5NERX8nJI1fMUxWAWJ2J7qZnsWDLEw1aOai3TTh4SuZzeMV1GiyYGHLWBSazOtOXL7ETI5DJeO6caWUaFBTvBqGuMjeV4vEiWMT8lcd+Q2iQQZJxUSHj9n5yXGxeAIANbSwtF45lMyGism9OjT1oUS0qwiWlBUOmLFUYIuwyRqDBngxvl4kUhQZkk5WBiunchY0S00YafQZnoc+mmj7z1E1Ibcx82dLBARBhExZg3rgEhFiF3nAo77PUcEFoJiQF2gAb9zVzJZf5dXhS3T+6oo45UiLyRkXh9dNcZQT4YyjdXEDkqA9Zi972UUw2mKuYKBn9mRlSO5H/EFQQTmjekCGUEJEpGm7lTZTDk/C0b+dQKdrdpFw2WotJyIE9TazKBX28YiNqa62V+Hb0ESBKq5UE0fAq37LzqUkY1E/XZQtqmD2bAenlRrLcv0wR/89JpxsuzYdPTG0+D3qGQWgKm4alJPfBJN4lcSfMKOrhyFyOqaRL0kJkWVzTRl0zlEQqwBGsgD27013kLnM0mm9ffmc5eJWymZP4YuPwoOcEwwJ43nmn/8XkZ+Jo0cYUJrcdADYQyFEujcwnGurEYYxSV9W7bnqlCIaGtgZ95AZseCOpA9G1tO6IvPOv8LMCU207k7L68+ekvdEIpLeXLfNmTlABWXNeLtu7R0NDXQQURI/5cfN5+4j4gwEojx+E3MltMPJehIUReIeendFucXoAjdP8huntXP0dLoj1sy8AF2VYet8M0tLkVH173zB4PnMjrySI0kG6b1hVBEqVGHiCLk20xQaWj2zstEZCK3r4KC3MS+rcmlKTXUIA33mF4I1Spef+wuKaWO6B8gOIweteo4OofRgMCCETi9Ck0TQVlR4ejKkbJ2QvfXAb+30ai4McFId3Kz79YKFWcDmmYeXWwgm/bqCT3p4oY0H/JtpunbLubkFaCjdCePRoZ69dCRBzVJxvVGyGaCKraTNpxBDSJR5Jm86QwiOTU40kIlcMhKJ4rkuA0pCHi52iD1VSJFKQFEnr6L23oGoV1VEHXjzL4CBMaPCCIwa3hHGxOcvqEOyTbTJf83SJ3KwSwZ3Q37wAr6soAnOFKJy56FxR+6FixIYvSenbgZcu3Re6TkggreOFyO5hHZPGsAmKo0M2WEXeq3H+PXnkRqV9XH28XD2YoRNGSEKRx6rpqE8w6QajOlZeZOXH8aqQkERa192jVBSiQEhRncxQ0pqZbsu5aJTOiZUGRA1Pm7EDqMBoHhPHo+PpgTOnJkN4Dzi3VTfcimiiK9jSfuoVZub8X4HigiJV0yjezewt6igXTpJLY2ZO4z7b8YmF9UIrYIVHbo0cpZXQ2XhRIC8aCOaNlMeQXFKw7+K0RoZB7P3XExN78IGXF+CzKkkztU2URKJBkRZsbAdk3sTaVb2ZtBYYevPUVKx06eDh5OlkiJJJXCQCjVWpnfaiLNZoLcx9vPo3W8DbO2P65LKsJ319JEz8UGrR/64zdfRsQkiyA7w02gxtaFAIRCRDlwdGnhyDAusspeXkHu4OLhUqx9ZUXVgt3XkDqVA7SXje0uxZgjpdqgzu6Q0AEpkWgWhjSbae3RO+XlaCXXgROKbq2daQaUpex6tUYr3gR+lBfsuoI4mAWFJTO2XkBNSEUF+Z44Gxlzo9LC1bqv9PoDbD/rD8WOmEOXD2fIUt2huQOfB/gWBQhAqLWMn/uTYzNBmRRIrkPBABEi2b6JLVRVI0RCZjp3Ry9GN+BtjN+TMJRHYOUhv68ZOahJ2LOFU31tddSkkil5Ns/sBws26VM5Mj5t1UE/1PSaO7QDaiJJtzxjenqZ6GhKt44CtCPhi11UXDZx81kBPJh61K0V3mQSFXsvFxtt9EJ+lh+4gWxmcMiAfODyE1HxpbHdkO4eNHLDrPggAJVNJ/hIYU64ebsvoVNIkYO7rpb6MBwZzWcOUngLAnKnDm5HIQO0SZNgMx288uRzSjaCanb2bISgVGiKBM59bd1sUZPt45f0Kw/foCYVR55F+66j9v4AwaBAqU87nPub+SmzbnJvbRUl5uUgT4I7QeEBodHk0SOH0ujuHqoqiuTQwlRERmByv7bgAyByc6lqSNRmgvT5O88h5/oNQwSbh852aPk1Iz5x2rnZIyjhmqN3ENxqCn4b6xeE4rmhj7ermrJUvaoRnJOiiGSgpzVDiorQlZZXzN19VRTFaW4zvo8U7ufRjKEE7GB69/GW0SQ+RG2mc3dfoVOLl3fsvfEmEy8cIlx7N7MToRXdTaCUymV/5Laa5iP5/oCx6ddeRn/I6J6XIvCbO7yj1Gw1HboahJrrN4wAJOPFC2MRZiIlTab3b0MJXeSJErKZIO500/G7aOrYEcldEzSx4kjVxM4UzSzGa47dRmqr6cLdUKTKbHEnlbKiYncv7MPHxYPhCz1tjbFS8V6B+NBtvij+zo/pgWs8MDbJ23s2sjKVxVIqhGymS/6v45LRijvlzqCWTay51/hCFAQgiLS5k7koLWluE5P47VZwBM1Ma2MH64TVR27X9pTZ+95utuqq+GCO2UH4g/uikV2g4sQft1j4YdfZh6k/fqEmuFxduYGd3VGTSqbkgbTgMqUvR1lCNtOWk/fQhAxirXEeZAmGBtlcujvPBkigDhVdLj98jeAhBUfTbl5OVKiMaUqMgLGB9uheCNXAlkCR7Nx8yMkkQUequ3RoZmukj4uvUw2zIPojuspiiK7kNhNkQI5ISBOEKHPPWrniTSZJ0PdCtf7A07C411GJkqhEdp/NJxBdJ4CiXTxx+m+yx5swvSWju8KOCGEyjBHYcy7gVyFaFbE4WPTvhFbFJ8ZGiDnGdhYNmjk0ZI4/M5wl/zLvRWbpXxO5tq7Ihc3XFBLBO25OFghKxRFpNwLhmf8GvkN2ndBAV8vJ2hjZ4ZNZwWwaGnT1YmvSkx95hfsuBaI5dj1wjQcEBkYGt5oktJmi4lMhTTMCQ8ZfhNZNbPg/wHcFImCoVw/ZBK+XA94ynnR7w3F0N5k6Nkcx7FHgdJOVh9MGeLNU1d3nEd1kcrQ0MjfSZSmq0iR2X9kL1JXQZtp/5QmyAw9VC1ztZW7DkKzhcLQzI4sUuXQqKqsOXX5CLk2xqD18+fFd9FexutDZuKM7Wzcz6ESJEV49Wzs3NGTfCz6/oGTfRUQ3mXq3wfGhjMzl6kytTPXBfq1+V6o/S2IzQejp2buhyMLSyMIIkrsjKx7igrnYmiAr4cm7LyFsjSnxDqD6/uAA0ropPo9mamoI4QsRqZNZmHTg6I2nP/OLhOjG0OMeuC4WQ8jXZNvXW7YKD0hiM118+Dq/CEWvQM5wyqBXWs15LPGdprboJk9Pz/756PUniVUj0vFzStat51FEKFDaF05UwR+TUhaYOBEEJvdpza5aExXllXsuPCKiMnV9IY1cK1fsfUEdwOJR9mmLbSZhiJ2+/VJYEyafY5uJCPoOVkhvtJ65x8zcO3DlSWVVJRFgKe3bEskc7pSqzC7i+vW12LU1cuUR8+6DtQ1xjxaO8gqSrPZrI4jvE0GgeWMLHU01IhTY1VfsmZeZnfcsLAFlJbHNRGR0HMwNiXSnuu+Nx2ElZeVUc6lGv7ik/Ljf82o3kfrYFifXQGo8+AkzvBubktnsR3WTCaDt1ALn1OA3wxi6B0fP3m4yFIAits10JfAdygtuSIXSFFUvZoamtHhs1dWUTQ10xOtDY2tIFeP/gu4zMr8n73JRdezgYO/hYkXjIGBWkiDQu42LhqqyJD1p7xMenfw88gvtbEVl6IXDokWFiqZ2HT0caOKEABvxbaZHyBVM5YXRwkQX3vq8d/C1uAg4WCLtGXMt8L24GhFsf+wm0ptMUGauqexlliM4pvR3V1VRZEtg9oFrT+jHR0SOUMXPwQLpvXARFZGmZh3cZchmEi++LOt73tN3SB/MNTZH2h2HFd8Th4YNAkKjkRX1ZlB4WUWFojxNZbwgKVTgq1hk0QDBmjmYSUFRM5QRJku2YV2boxxxzFHzV37xlXuvyFKZdDrY+5t0SIkTdLQyurZ1SmWdP4KabdF285BYa/FspmuP36N8MAcoWJsjvUci8TjR2dHSWJ9OduLy+vGr8MnrmM50+TScgQQHCHt/A3oejS3ExRC3ZwSBrp5OE3y8yiurysorqiorwRGkoYGOuroKI8LUxvTcg1e5xaW1PWX8flt8MMf4GPAToH/HZvxuS+E98WymfwPeIY6BE962JTxClib1CdOglsDVwHe02UyX/d9Sqwxh6s0dzAnTwAToQACivY6tHkMHJwI8Tt16QaA35V1bN8G1RCkHGTMQgIAY/kyQyvJxWJwAWig8ssM2E+FhsDZBep8J9LvzOKyyko7I/9jEbxHxKYQRpZZA00bYZqIWYdmhHv8182XkZ2T1VVVWbOqIZzuy4yMTgolhMz15Fwtbyoij4oDP5giPkLmpHmEa1BJI/fErJIKOX/bLAUhHPADK2ipKDjibJbXTTYaon7qD9CaTeyML2hwZZWjUsariICCGzRTwipkUzKKro6mmDLnjRG+PW/JFoJ66KiDJ9xE6N28Hh9MgzBXkD6MdrI3ALYYGKDALWUDg4n10vb8Bfzd7dKsUyML0wDoCAmL82j5G3mYya8C+QphozkIThFM0cRC79zySauhSv/1A/2DO0cqYahwwfRlBAEpQx6dmo6xsYztsM6E8PjIhm6g2E6T/Do9PQxwSbDORNUCmDbTJIkURnYiEtIzsnxQR55C9T71ZRlx+R0tsMxFHEVP4jcD1R6iH+LjamuGhwggwi4CoNtMj5DeZAEfzBugmsGZ2mMXlbqLPAiSD3saIq5dY7W+xwWZqZI0Tkok1qrhxrQhcDkA6RFRerm5ja5NapccPMAK0ICCqzfSADTaTKbaZSJo0Jnr1SKJEIZmXUYnUUS8trwgK/UgdfbIo430mspCUcTqR8WlxyZkog2DX0FBFWbzkOCirg2VjKQKi2kzP0a7Ly0HfGPkTJbbMkvraGuiL+joqiTohX334jHJmP47iEDRnYYx6Mi3qxghTJhGBuyEfSKRGBamm9niTiQpcMU3xEBDJZsrOzY9PQXoJwlHaDHnPZfEGh7nWuvVYYDO9j/lKXZamJ2+oPfgjZWxtLPHBHClAYiJ1Hj6nu/S1uKA7Y2cmcSHD7SlAQCSbKRThGte8mBjq4kQDvHhIfq2nrS55Z7p6FhaXJiRnUcTt6VvU07eC4jhojqLRlzWy+QUlQeHxiGvtjFcIiI+QbIgnks30ikrHERJx1tPRJJGaLJMyYMPZHAxQODVJuisrqkKivqA/AWyRzz6KPoZYQkAAQnzQz1dsaWaABwsjwDgCItlMYbFfGRdUFAH0dLHNJApOwtuwwp8J1IhMoCT/RVRCan5RiXCYmG5haYx6xnamEcL8RUKA6hBUkYQQ2EiurpwV8jWdBGqAH0oJAqLZTDGol9yC0dBSV1FSkJeSYWFajfra7LA+Yz+nUwHVq0+JVJAlnaa5CbaZSAdVFgkGvo1FXG3IGIeD5hAfIxkRT7jN9COv8GtGDvpwNNBigQsO+jByJNTWVFVQED43GFcnMjGDChkiY1mwSADFLY1w0BwV4y9bNOEX/gPy+Yot8FSXrVmJrrbC34tRnyk5/iAdEs162GYiE9QGmizAMzYpk4rQuffUuEmROTxQ9qiunJEe6unayVUZU6MCgZCIhMqqSiook0jTDOfeIxFNTIoAAsJtppgkSpbyBGTm31W3nhr/B/iuRAhosSHdQElZWWLad4n0E9QpIjZV0GM0nhnU15CTr4uGLFgKFiPw+mMi+tKbG+JaouiPkkxIKNxmiqbm+IN0dLU1WLAvQrrW1BGsp65EHXESKSeRXVUUTqJ//CokUUKKSBnjTSaKkJUxsu+pzA1LFpamuP46WVBiOsQQEG4zxSV9I8aCpt7aGso0cZINNpqqKqxQ9AvZznYRcexwZjJjQ30bVkwhGRfyLRv2mYzxbJfxaYqM+sJtpsS0bGSkFSSIpjo+mxOEj7jP1NTYYYMmkW0zIV51izuO2izJocUVGF8giEBG9s/UH78QFKyaSPq6LKhMUE1m/FEqERBuM32mwF+ECih1NFSpICuzNNVYss+UlE6yP1NSCjsWCbo4UFRmv5zkKf6Jmgxn5An4X0r6LMl+QrrimCBqCAixmSAM9VchC5L7Aaza2GYidXKpq7LDnykl8wepetf5QraDFLnicanpauGNVS4Y+EJCBKKoyXAmoTS1d8M1HmrHBj+hFQEhNlMy2Yt46pRTV2eH/w11CJBLWYMlZ3OZOSSfLMSmZpGLJEXUdPA+E0XIyhLZiM8sCBGFtBo6eIUgS9MSZV2F2Ezp33+iLD2vbHifiRcN4tcaquzwZ8rKJdlmYosDX338FiE+y2WewpevLFghaKixY89b5meTTAAgxGb6xgb3QM5AsWVfhC3TSkONHft22bn5JEKanvWzuLScRILUkcIrb+qwlR3KrNhV1VLHvqqyMyVR11SIzZSdQ+YLiVIwVJXxWoRMgNniz1ReXpnzs4AszdOyc8kiRTUdbXw2RzXE0k6/tLwi5RsLJrwmS9Zv0j5fsH6/ERBiM33/RdrbiGq8VVWwzUQmxmqKimSSo5IWiTZTFtneUdTpraOBfcCpQ1cmKH9N+45+1RQYCbas32Ri0si8kkJspoL8YrZApKrMmnc8KyBVUJRnhZwgZF4habM0kz2H0Wp4kcCWCYqqnGlZLNhkAvAUFVjzW4TqUGO5SENAiM30o4C0txFpItdCCL9CagFGwttKigoS9qS9WwF56TBYtM+kooIXCbRPNelimJbNjhAfBXlsM0nXzGOzNkJspsLiUrZop4GX3aQOlbJM7jNl/MgjFUUKiWEHPgrBlQ3SbAmLVlEQ8p6SjeHCWiKBgJC5WFFRgYSYIgihgn3ARUBJ9CaK7Nln+kXebmgmm4IeWLMRKPqswy3pRCArmyUrBLzPROe0wLwEIiDMZqqqFNgdoYfK+KiC1NFQZo/NROJuaF5BEakoUkVMSUFeTk7Il5cq3piutCCQlceOEB8FhbrSAjnWg/UICPvZLa9ii4rwFmGLqKyQU5E9Z3NVFaRZ9iSaX5SOMo4SpRReGSFekM+SFQLeZ5KRGckGNYXYTCXkvY0oRUNeDi9ESAZYRYE1Rz+l5M3SgiJ2OPCp4l1Vkue7LJLL/sUOmwlvqcri7ERVZyE2U0UVO/yZcDAq6RNMgT1nc2Xked0VlrCjIrUSeyxa0mcmJkgWAmzZZ1LBZwhkDTmmQxgBITZT3Qp2nM2pYN8OwlOBvQQqyNtnYsvZHHsHC0uODgK/Stixq1rKHrdadAYXS0IRAkJspip5dpx5VeCzObInCCsSBHOUrqoizbLHNhPZ8wjTQxeB0nJ2lFasKGHHcQe6I40lIw8BITaTOksC+OvWZYdtR97AUU+pkjRDhGpZlchzES0tZcevM57uVE8qWaBfUcaO2V5Qxg7bThbmDNZRiM2kpsSOXMMk7jTgOcFBgLy9G8oRlSfP3UEOb1hSPlyYASoIFLPEZiopLUMFMiyHzCMgxGZSZMk+Uzl5Hi0yPyX+C0BZJWkB/FRDqkyezcSW/RslvLFK9azC9JFBoJQlth0ygGFBKERAiM3ElsK3JHoBUwg2q0iXlbJmP5zEcsI4qplVkxQLSwgBtqRoKSnH+0yEBhp3JhEBYTYTS9LAlLMkvo/EkaOaVCF79sNJLCdcV8gXgmrUMX2MAH0IyLOkjltJCWvWb/QNHubEEAJCXhFs8WdiUZAXQwMtNtuSEtas7bQ0VMRWr5YOcnXYcTpXWM4O791aYMa3kUBAniVLhBLsA47EfMFC/EZAiM2kpanGFpwqylnjf8MKSEvYczanraFKFqQK5LlGkSUSXzrFZayxaPnKj2+igICaihIKYgiVoaiYHXmkhCqCG0gBAkJsJv166mxRsgy7gZM6VIWlrPmd0lInzbLXVFcmFUWqiFUUY5uJKmxlh66GGmkbtJSC9uNXIaX0MXGMgOgICLGZ6tfTEJ0Wsy2L2eN/wyxQInJnS6YiUIfEfSYtNdK2rETEWbJmv/Bslww43IsHAQ1VdqwQikrK8PEcz7jhSyYREGIz6bJnn6mwiB2VwpgcbXF4l7PHh0BHi7R9Jl11dthMFZVVJFbZE2de4LbSg4CGOjvO5gDxHz8LpAd3rAmbEZAem6kA20ykTsRSlngZw1pZXY205bI6ee7kpI4GH2IlxTiYiA8s+JboCLDoGOE7tplEH1fckkoEhNhM+uw5m8N+guTOk9IKdkRmmTTQJlFxLfLcyUmUii+pInw8xxcXfFNkBPS1NUVuy3DDH3l4n4nhIcDsOQgIsZl0dNTZEXtdp05+MT6bI3NWsyVNaEM9Mm0mHRbZTCwpSk/mpMS0SEWggTZr3FVzsM1E6tBjYhIjIMRmUpSXN9SrJzF1OjsWFLEmzotOWCTmxZazOQNS52cDUqlJDL4oHX/iYCJRYMJtakdAX5c1+0w5eUW164GfYAToQ0CIzQSCWBnq0icOAU6F2GYigF7NrhUs8QG3MKpfU3iJ75gZkLlrJbEYonT8kYcDsEXBCbepFQETA51anyH2IOdnPmISYXFkFAHhNlNDlthM3/HmLalzuIAl7jI2DRuQqLdJA9a8RXDSGhLHXTZJmbJntqdm5crmGGGtUUNAQahAJkbs2GfKxctuoWMpToOiQnacddo11BdHLSFtzQzYMdtBjRzpnfC3n0ZsPnlPyFDhx38iIFdX7umxRX/eE/IJVgjgrlolpBUSj9O//UBCDiyEzCMg3GYyJ/XsgzrAsZMgudjm5LPDgcC2oSGJijeor6mgIFfOhjo8udLrz/TmU1JI+GcSh1UWSIHNJK6aSgryxvrarNjC+ZKBbSZxhxe3pwQB4V8zcv1FKFHiP0Sz8IE3qeDmFbDAZoIM4Po6ZMb+yMnJGbHEDVyKFwll7Kl1SOp3jgFijUg92qZOgeRvOdQRx5QxAqIjINxmcrIyFp0cgy1zfmKXWDLhz8svJpMcNbRcbE1JJ2zHkreINMfNybElwwnps49uglbmBnSzlIhfenYersIuEXK4E8kICLeZLE30WFGWKA8niiV1bnxnw76dm70ZqUr/JuZsaUQ6TSoIZuf8ooIsCjRVFIT7DKAgpxTIYG9GZggFdYBUVlWmZmM3cOoAxpRFRUC4zQSUXK1ZsNWUkYuDUUUddVHaZf1gwSvZxb6hKLqI1caeJRurX7N+iqUXixqXV7HCL5lFiNYqqqMVO1YIoEAKPp6rdRjxA/oQEGk918jG5HnkF/qEkohTNl6FSIQb306Q0DKXDT7gzezIP5tzYsk+0zfpnfCrJ/RcOqYbZ2ZW1cZY514AACAASURBVK2qqqxTVl5RWlaeX1gM0YKRCWkvwuKjv377+CU9W/ZWSuDrbWWsa2FYv6GxrrGBDuRYMjXQNtPXMZIotRgVp9t8f1KI3/ya8cPLlTgZTAEjQAgBkWwmV2sTQkxo6Zyemw+V3iFxOS3cpJzJ9x8s2LRTUVJoZEP+DqgjS/aZkjOldp9JXkFOVYHPFriBrqZVnTrujuZje7fkfAOT0nNuPQk74vfsQ3yqFH8nXWxMO7jZejhZOtuZ2ZobKCuK9LstCiDGBto6mmqsyPUVn5wpika4DUaAUgRE+u41tmOBzQS7+elZP9mSgZPSQSVOPP07C97HzR0tqTCR62urmxnqJCMf21xSVvY9twCkJT7c7KVgbqQ7c1gH+HsQErnsnxvvo5PZq0tNye3MG0zt33ZIZ3ewbGo+JeuOm51ZwNsYsqhRR+dTYgZ1xDFljICICPBZzNXsCS8nSFpT8z5qdzJwrliShiSNDUi2cYVNB0r+eTpRRZlccTOk93hOXKC6ejV+d3blxY0TTPQpNC/ElUri9rD2A11irq2bN6ITpQYTSNjcyUJiOens+CkxnU52mBdGgC8CIllC6qpKrjbkByjxFYjITVYkZyOiIG19v7HBv9jLxZoiQFo2tqSIMrlkUzJxor8/EB3S1SPq6poJPl5/3GXbh2Gd3D5eXgO60CO4O0tsppjEb/QAgrlgBAQgIJLNBP3bNqHq/SRAOHEfpWaz4ERJXKUYaZ+M/AYGJPDxdKVqTno0tmAEdnGZpmbi6OvqmNVTVz22esyJv8aCu1v1Z2z4PL53y7ObJqqrKdMmLFtspsLiUnBfow0WzAgjwBcBUW2mFq42fPsjdTMlA3+jyBkQ9F/GjW1M9LTJzADOC1wzR3NWHEYnpGTxio2vuQiAk/jDA3NVlRW5d1hxATtkR1eOgWT0dEoL54CmBjp0cpSYV/SXNIn74o4YAVIQEPXL2ZqyNT0panCIxOFXCElofkXe+uzo4UCSrnzIqCkredib83mA2K2YZHxaUeuQtG5qe279eFbYvhwdvFytYIdMTp6BHOjezWxrxRGlBx+xGzhKwyGbsohqM4Efoo0p6ln2P6fiZTc50xj9qLEO7vbkqFoLlfZU2mS18BT7dvxXPOEFgdavQ7M1k3sLaoHMM9g2vbNnNlPitG9mxxRrsfh++oLdwMUCDDcmHwFRbSbg3Lt1Y/L5k0rxc0o2qfRklxjiFTFh86BdM2ptpg5ssJmScMYaYd/RxWO6WpnqCWvF/PPlE3pqa6oyJUdbN3bYTO8+SVUuCaaGG/MlgoAYNlNXLycinGjom1dQDBlraGAk3SxyfhbkF5WgrGOLxlaaGiqUStiqiQ363jC5xaWZ2XmU4sB24pDBa3K/tohr4WhpNKbnf7N0MiKqrXkDc0NdRliLxTQiPqWkrFysLrgxRoBcBMSwmbzdHNB/iySk4lyxRGfIlzTUt+u6UW++Q6rlVmyIFY3FLk3C5nv3Fo7CmjD8fMmYroy4MfGqjf6SGKSFEjrhsXiriXfc8DXdCIhhM6koK7RzR30L93My9vAgOofQt5m6e9FxTNzDy5kolNT3j/2KFwlCUHaxN9PWYOzYS4hwdeooKsj3b99MaDOqG3RD3rLkIPA6KolqKDB9jIAABMSwmYBKz1YuAmih8CjyM3YSJDoOcWi/ho316jVzaEhUSRH6+7RFfbaDEh8SpLnOmgijJFITBwsjkdox0cizsaWGujITnP/g2aWFk7IiC1IzvP6Y+Ifc+ANGgF4ExLOZBnRoClW16ZVQPG5Rn3ECD/EQq9k6JgnpCPY+7ZrUlJmKO9ZmBuBoQgVlEmlGxqSQSE1aSUHhNmRVc7dHosQCZNHsyoa4h9dRicgOJRZMFhAQzwAy1KvX0Q3pTB5RCdhmIjpvEa9RMLSzO1ENRe4/sJObyG2ZafguDttMwpE3a4BuzkZrZOw5H29X4VAy3SI68VtBIdIRKkwjhPlTi4B4NhPIMqRLc2olIkYdUjQVl+DACkIgolwLEyqwtm5KX0r6oV3cGcgwKM7o5eQVpGTgqnNCIEO5cG9DZOw5n/ZN5eUQn+91KqsqQ6O+CBlv/BgjQBkCYttMfTs0Qzm1bkVlVSwuf01guqR++/Ezv4gAAWq7ju7uSWdliUaWRn3pOgqUGLiwOBxJJAS8+pSV2RHCWITH1JUAEoH5H030dTQ6NG/0xy0kPwS+jkFSLiyUTCAgts1UX1u9kwfS3yt8PEdk5n6IR9qneGSvlkS0k6DvrMHtJehFZ5fwWHw8JwRvXS104+a01NWESE/jY9hYpZGbhKwCX0dL2BN3wwgQRkBsmwk4jvdpRZgvhQReReNgVMnhDUPYP6aFk7mjFd1O2d5u9ujsBPAd1/exX/nexze5CNTTQMgu4UrFuVBWlK92h8GPAzo1Qz8J3+tPidilicFJIuOsJbGZ+rZvYqKjiSxwbz5im0nywYlAOGXcGJ/WkismaU9INti/Q1NJe9PR72UEdu8QgjPS+ZkUFYRIT+Pjeuqq/dsjPdsBjPLyyqD3sTSigllhBP6HgCQ2E5QjGOPj9T8aiF1FRn+trKxETCjWiPM2BlHnGG0VpRFdPRjBcUzPFozwFZFpalbu14wcERvLZjN1VeYTINWGPGScr+0RI/cn9Eb3t50LCHZp4kKBL2hGQBKbCUSc0K8NsvEVUITr05cMmnGUDnaw4x2HanKmwV09qK4xV9sgernadHKjtiRwbaxFvP8i4rOILWWzmaqKErKKKyAWqtbes5G1qT6ycHEEC3yDXZoQHyKpFU9Cm8nKVL+TJ7pVnF7j4zmJZuz7mK9VEnWkodPMIUz6Yk/o34YGHSVmEfQOH1UIAk9NFV2bqQq9r9z0Ad6C0ETgWXhManZuPgKCYBFkDgEJbSbAac6wDsii9Qon8JBobMKiET2Yg20eZztTiXQip1PvNi6aauie7+Blt+BhhvMvxAsYCJaf5qdjfbwQ9wSHLE23n36gGRbMDiMACEhuM/Vs7exibYwmiCFhcWgKhrhUIR8S0JRw7vCOzAoGlSXmDu/ErAwCuEPq9ozsnwIa4EdKipL/1skaerr11CejvbEKI3LjSZisjQvWFwUECP2OLBjVBQUdasoQEZ/2Pbeg5n18RzACzyJQtJnANO+JQFWHRSO7oJx04FHoJ8GDK+NPlRBztUZ8OJaO6aaihJZzejXE/F9GFZaUVruJP2IEqEaAkM00rLsHmkUJwEPgGd5qEnPupGXmJiNZhQN+vsVUhZLm4IG+enwPSkiTQfTuiygyyEgtDQ1sM4kztlBatAvaOcGLSsoevvgojk64LUaABAQI2UyQdGD+CEQPLJ5gr1gxp0cwkojZmBoMRqbE4cT+bZHNTOb/Er8/BM34SgVCv3WCSEvps2E9PBHX7PpjfDyH+BBJoXhEf0emDvI21NNCEJjgd9ilSbxhuYfkom39NB95ZN52qiqKC8YiselVc2ghjAiHPtSEhXunCqds42Ih2sXgzm6NLOhOuy+aaP9tdftpREU5HlexMMONiSJA1GZSU1ZaPg7FA4v30V+/pGYThUeW+vuHIne408TedGjX5kgNwrSB7cwMdZASiSvMreAI7jW+qIaAAoIx/dVEROwjFMNePaknYkL9IU5OXkHwW1yv9w9M8AeqESBqM4F8Uwa0bWioS7Wg4tIHl6ZA7BUrMmoRMckZ2XkiN6ep4ebp/WjiJDIbFWWF7bP6i9yc1obYZqIVbhlgBltNLjZM5vgQivHxOy+EtsENMAIkIkCCzaSkIP/XpF4kykQWqfD4FLJIST2dW8+QS3bStqltt1aNEUR+SFcPL1crBAULj0tJSsdFVPiPTDE+nOMPjKC7sNW0aWZfQS2YfnY98P2v/GKmpcD8ZQgBEmwmQGtsLy8ET75vBkdUVqCXZBfJ2XXt8TvU5No6E7lNJi5EexcMRbN20M3H77lC4gteBLDjCy8aol9DHr42TWxFb09zy8Li0isBb2hmitnJMgLk2ExQ+33vwsGo4ZiUkXP9CXKmAGoogTyJad/fI5YBfHg3jxau1ghixRHJ3dF8Qh8US5leCcQ2E/9ZU16BnYX5IyP07o55A9BcIXAk9731XKgKuAE9CFRWSv+3jBybCcajcwtHH28XegZGdC5n774SvbHMtvwXsc0JqFKyc+5AxIdj6+yBCOYdeB6ekJ6FE4LzmTsVMvBrzkdtMm55OFmO7Ilu3oGQ8M+R8WlkKIppEEIgM+fXqdsvCZFgQ2fSbCZQdtfcQeDbhJTWD15EFhSWICUSgsJc9kfLslw7xQdS6iEIFK9IUF9ix8IhvHdQuIY6XOfvhaIgCWoyVOB9JgJDsmPWQC11FQIEqO265/xDahlg6sIQAK+ybrP3pmXlCmvI+udk2kzWZgYLEUtxWVxafuspDsAWNE1jE7+9jEoS1ILeZ642xrOHdKCXp4TcIA9Cn9bOEnamrNupu9K/1JMAvMo62LVRAtj+28VAT+uviSgG+nDkO3vvdSZ6Yb+Sw822nsUl5b3m7UfNwYMiFMm0mUDEFZN72ZjoUSSrZGSvBr6VrKOM9DpzD61X7L5Fw9BJYil0DuxfOgJOEoU2o7PBh/hUnNyyJuCVFTXv4TtiIDBzWAfUftu50peUle27/Jj7EV/QiQBEVwxbcjj4vawkkSbZZoIUlweXj6BzwITyuvssMr8AH8/VitOluwgd5Uzs49XWza5WWdF7YGqos3/JMNTk2n4aH1VUHxM4tax+C38WBwHwu1g3tY9cXZJfGeKIIKjtoetBuGSvIIAoezZ23ckbz2ToMIf8L0AnT8fRPVtSNkBiE4ZSjjh6rjbUAkI/xqV/r+0pzfchv/auech5CAkFAWb7sE5uQpvR2QCS1sQlfaOTI+YlCwhAUfZJ/Vqjqen33IJ9FwLRlE2KpZq97cJZlFbdNEBNvs0EQu+aNwipkKKzt3CuWP5z6eC1YP4PmLjru3K0pga6fqYCIDmwfCRSBVVgT2XHaX8BAuNHGAHJENg4va+xtoZkfanutfXk/R95hVRzwfS5CKzY/+/fl59wP8rIBSU2U31t9b+XDUcHwYA3MQnJmejIg4gkEJR+MzgcEWEm928D6SoQEUZcMXS01E6vHScvh1AWm5N3XuCkA+KOI24vFAH4bd+xANHN4Nz8oh2n7gtVATcgBYFtx+9tOimLaFNiM8GQ9OvQDHxTSBkb4kQgYGbP+QDidKSMwrF/n5ajURXc3FB355xBrIa3nZv9hukIVZkoLa/YewHPeVbPKUSFhxO6AR2boinc7ouBGdk4Pxnlg7PvYuCSf25QzgZJBlTZTKDsngVDrU31EdH6yL/PvmbgUlz/Gw2IDj2ERqQJeJXCJo2GOlrRZ/9DSuSrpWO79W3XROTmlDeEg1d8VEE5yjLJ4OiK0aYGOgiqDt6rK2X1XU7bcBz3ez53xyXa2KHGiEKbSV1N+dyGCQoKFLIQHU1YdoNpLHp7qW956k5IWm4+Cmqum9abXbFyAkA7vWacrZmBgAZ0PsorKN5x+gGdHDEvGUEADqPPrR+PZgzd8ZshT9/JStw7/fPt3J2XkzacleVcZ9QaNJ6NLddN8aF/XPlyhKQDfO/L4E2oCrTrHBIHN5ATctnYblIzBODD/u+OaehkTN5zMTDre57UwIsVQQcBWOcsHd0ZHXm4ksDrfMqmc7BI5t7BF2QhcPH+q9FrTsl42g5qbSYYqmXjuiNSh+5TYvqlB2gVCSFrKotL50rAu1gEYtFN9LWPrx0nJ0f5JBQXHyLtnayNr26dgsj2KlR93+h7l4g6uC9GoDYElo7rgc6uKq+Q8FO//RTeYeWFhITrS/5vRq4+LuMGE+BIx+vq9LrxiDg2rdp/o6SsnITpw2YSsMm09shtxjUAq+LipolQtY1xSUgXAAIADy1GJW70wPWgj5/TSdcRE8QIwK7qk8MLIIADQSg2+N759AVPe9JG5vLDtyNX+1ZUCjmUq6oS0oA0gZgjRIfNVE9d9d/tU1WVFZlT87+cIX/jkStBjIvBrABXHr6BdRizMgD33XMGtW5qy7gYFAkwoX+bhaOQOLmA0Mi52y5QpCYmK+MIGBton90wAaksG5wRgUqjQ5cdg0gXGR8gUtSHI7nhK46KEmRdVFRCCkeUidBhM4H+zramx1ePQSF9zbrjd2W5lEpZRcWqQ7cYn5GQOxvKVzEuBqUCbJ8zEJGE+A/fxMC+OqXKYuIyi0DrJjZ7FqKYsSkiPmXRnssyOy6kKA6HEptP3Bux6oTQHSYOu5z8IlL4okyEJpsJIIAi8Oun9WEci+zc/G1nZPeo+9ClJ3FMp/d0tjE5vHwk4zOBBgFOrB7TD43sA3N2XIKZT4PKmIUMIjBzcPtZg9shqPj+K0F+T8IQFIwVIoEf/YD5B5cfuCG6D1N5ufRv7NFnM8EsWTGhx6ienoxPlx1n/GUzVxNk6/nrKMOeTBBTdnnLZBVlBcanAQ0CyMnXvbB5UidPBxp4CWbxLSdvyqazgtvgpxgBiRGAbHx9W7tI3J26juPWnsJFICSAFwymIQsPiVt8V1VZSQJe7OpCq80E0BxbNaYt014skPdswe6r7BonUqT965Dfj19M1mPSUFW+t2+Wg4UhKeqwgoiyosKNHTO83Zj33ILCvafvvGAFaFhI1iEAy4PzWya3crVBTXL4xesxd3/OzwLUBENZHih43HvufnENJtCoo0cjlPUiRTa6bSYlBXm/XTNcbExJkV5iIlcfvX38Klri7mzsGBr55cCVYAYlV1SQv759qhd6v6pUY6KuqnR332wUdptmbLkQlZBGtb6YvmwioKqieHvPTDh5R019yKvSf/FBnLFJxHEJCY93GbrW/+VHEdtzm22Z1b8PGq4IXJGouKDbZgIdtDVVAw7MsTFlOF3y5E3niorLqMAUQZoV5ZWTN5wV/ViadBXA/f/UX2PZW4WXICBqykq3ds3q3sqJIB2C3fOLSnwWHMCOTQRhxN1rQwB+2/33z7Ey1autAVP3g97GTVx/iinuLOJ76Fpw+ym70sSv2bdv0dAlY7qySFOJRWXAZgJZ9etrBRycBykNJZabeMf4lMy1R24Sp8MKCptP3oMoEgZF3T57AJT2ZFAAxlmDC9eNnTMYdwn/nJI9aQ1+eTA+HaRWAEO9eo/2zzPWq4eahmfuhM6X4SppQocDQuRW/HNj2mZJUqjvmjdo1pD2QllIRwNmbCbAztxI9+E/c010NBnEccfZh6+ivjAoAD2s4VRu7TEmXb+Xj+m6YHQXepRFmQscTF/dNmXaQG9mhQQ3helbzjMrA+YuxQhYmOr5H5hbXxu5dLW7LwbO3XZRipGXWLWsH/ndZv296fg9CSjAkdy8EZ0k6MjSLozZTIBXI0ujh0cWGOppMYUd5JwYseJ4QaE0p+EC7Uas9BUlHRlFozB3eMeNs/pTRJx1ZKFQzD9Lh2+d3pdZyQ9eDVp9SFY2WZmFWja5QwUh2G3S1lBFTf29lx/P2ooXDH8MS/Db2KbD1z8MFduBCXKZ7l04REaO5LiQMWkzgRBgNgUfXsjgIR2c0M3dKc0rj8kbTyekZHHHm+YLMJh2zx9MM1P02S0e3/3U2rHgFM+gqOuP3dl/IZBBATBr6UbA1cHs0aH5CO42QdKmKevPQHZf6cZfFO3AzxXO49pP3Z2alStKe942Rnr1nh9bPHtoB96bsnDNsM0EENuaNwg6ssDMUIcpuI/5hSzdd40p7pTy3Xb6wfkHjCWAXja6KzaYahtfSBF+/+/Z9RhdiM/aeWn/5ce1SYjvYwQIItDMoeEL3yVN7BmOkq6pxRG/Zz1n7JXxBARQhrLFuC1wHidBbBAYTE8OLfB0saqJrdTfYd5mAoitzQyeHVvcyMKIKbi3nwl4KH5oJVPSisj3QUjksr9viNiY3GYQJbdzzsBNs/GRnCBcOzR3CDm+hNkSp7O2XYSFpiAp8TOMAAEEYEkcemq5jzdy6S6hoJDnmC2xid8IKMfWrrC9tO34PTiPe/MpSQIdOAaTnUUDCfpKQRckbCbAsaGh7jPfRV6uzNitYGgPXHI4Ml56Ute8+Zg0aOkRCRYQxOc0GEzHVoyaj0aFWuLqUErB0cro9allLZ2ZmfYc1WChOWr1cZy9htKBlmXiEPpwZevUEd2QC5sFxwzPsZtvBYfL1OiERnx2H7NxyT83JPvKu9oYvzy5VGYNJpgqqNhMIIpuPfWAA/OZWpHkFRR3n70v9dsPKfj+RCdmgC6/mPBtB9s3xHfx+H6tpQBGelSAvBuPjyyYOYjJYLqzd0N7zZT1owp6hls2uYDZdHbDhHWTe8OCCql/uflFPvP/Aa9wWcjVB4nZJq0/1XL81rAYCfPOdPNyenpsCfzIIzWINAtTt6qqimaWgtlVVlTN33kJohsEN6PoKZwPBh9bqKetQRF9GshCcaX203YlZzBg/MF3KejQAog0pkFN6WNx+eHbKWtP5haXMqWaqYHO+Q0T2jRjvswLFQjUdZ9CBVniNL/d327AXOwwcfnFonAl4O34tacgt6pYvWho7Ghp5LtyVAtXaxp40c8C3qoHrj5ZfdAPbESJuUNAz845g6BIjsQUpKMjcjYTB9YTN0OmbT5fUsZAnm748hxePqI100XxJJteUfGpnWbuycjOk6w7kV6d3e1PrZ9gpI9cLjsiStHc90NsysBlR6DUA818uewgeHjlxJ6rJ/SSvl9GbDNxR5nZC3A9HrTk8Mcv6cyKUZM72AKT+rfZOmsAZDOv+ZS9d+4EhS/6+99PiZIDrqKkcHjFSAhbYS8IJEqOqM0EGkImxv4LD0qQxJ04OtoqSgFHF7o1MidOik4KcFDdfc7f9Ffhhd+adVN9lo/vDsmH6NRXKnkVl5Sv9729/bR/WTljsdCtm9gcXzUavHelCWFkbab0+9sgd7Y0QS1Ul8KS0jnbLx278UxoS/obwCHD6vE9Jg/yhura9HMnkSO4K117+Hb/xcAQYnmbbY3qX9g2hXVvQxKRrEYKXZsJBM3Mzhu10tf/DQPFdJUVFbfPHTBjYDu2LLh9/Z7N2HKR/p05WIKcXDNuSBf3ahMLfySCAOwXQjH2rxk5RIgQ6Qvzf8nYrsvGdoeSL0TooNMXWZvps99GSxNZPM6GQulQBJP+NZ4ocxKiWf+a3HtED0/wxBKlPVJtvqRmH74W5HszhHhlyT6tnU+sG6+jpYaUgswKg7TNxIFm15mHyw78K5mTP0FwYcac2zRJXU2ZIB1KuwMyc7ZfhNqKlHLhSxzOMS9unOhsh1z+Fb7Ssusm/N4t+/uar18Ig/6G1qb6/ywZ1qUlw6WFSRk4ZG2myIurnWxMSNGRdUTSMnPHrTvlj2qeF6iaN2d4xykD2tZTZ8FpHRSMg4w5hy4H3XweSTxiGjLubpjeZ/HorqybVFQLzAKbCSCIiEkeusKXyImsxDiCV/jZDeMhOZvEFCjt+C7669g1Jz/Ep1LKhS/xCT5e+5YMU1NW4vsU3yQFgddRiUNXHIXCuqRQk4yITyvnDTP7Otuy2zJG1mb6cPGvxjbGkg2NdPQ6dDVo0d5rCDqGc+AFV43+nd3G+bRC1sn105f0s7dfnLobKkE6b75TyMpU7/yGiZ6NLfk+lfGb7LCZYJAgFnTVIb895wOgSBz9Yzaqp+fueUOQqgNQUla+/uidrafv019LDnA4sHg4Po+jZx7ChtOWk/f/ufKkqISBkAiOjnJ15YZ0brZsXHc2Wk7w03HracSQZUfoGS+xuEDkxJ0DcxTl2XcAJJaaQhvDMfSszedvPv8gtCWDDWxMDQZ3atanfRMPJySMifDo5GtP3t988j6c1MyCU/q33Tl3IOKnKwxOA9bYTByMYFtl0oYz8F/6IQNDYduM/mN9WjHu4QR7sGfvha46eJMRf5dhndz2LhoKWYXoHwJZ5ghjvWD3VXABYRYEOK2eMbRD5xaOzIohCnf4mgS9jjl7P/TKo3eM5CoTICTYoF29Gk0b4N27rauAZrL2CDIRLNpzNYk5Nz4RAYcCqT29Grdzt4c/miOFIYPgozfRga9jHr2KTskkOaEMZBs5vno0K77dIo4UFc1YZjMBBJBqYu/FR+sg1QQTmWxgqbF0XNfRvVoysjQE3f2C3q85ciciXsKkZETmENQE/GfJ8F5tkCuDQEQpdvV9/Cp65vaLjMdp25k3mNK3zbBuHjS/MEQcrFcfPl98+Pai/+v07J8idqGtGSy9Jvq0mjLAWzb9voXiDJuCO04/2HzqPoO7qkKF5G1ga2bQ3MnCzaFhU4eGTezMSHeXhsXSp89pb6K/QmmHt9FJ1CXeG9+75a6FQ1jhucWLP/3X7LOZOBiBub3k7+vn779i4KCuTh1YZ0zt3wZOuE0a0FRa+Ede4fEbz/6+/JiRRRgEx80f2Xn52O54w5b+r2g1jlArat/lwDWHb0Hm+mqPaP4ImyUdPOwGdnTr09aV8Wj5nwVFT17H3H724VZwxLccBvKTCQW/VWNLiGAf3Km51IQiClVZ4gZgKCzdc/VCAMO7qhLIDzaxg6mBhak+FFE1qq9loKNpUF+rgY6mprqKqqqSmopStcU2RPDk5Rfl5xfnFRR9/1WYkfUzLSs3JTs35Vsu5GmLS/5Gg+0I3kv7Fg7t2dpZAn1lsAtbbSbOUMGCcv7Oy88jvzAycvDO6Ohm27+ze//2TQ10NamQIfdX0c3gsGuB7x6EfKI/jwBoBDqO7OG5fpqPjOfLp2JwidDMzPm12ffOP9eCGYknrSY5JOjydDLv4OnYsbmDl4sNbTYBfDteRiQ8C08IfB39KuoLI56O1aCo+VFHU21Et+bj+rRGNo6kpsyI3IGEcysO+cEhFCLykCKGggJksatbWaeqsqIO8eg2giKpKisuH9tt4ehutH1nCQqMQnd220wcBC/cDf3roF9c+nemAAXDopmDWRfPRnC87e5oQXB7Nr+g4JkJ+QAAIABJREFU5GVkwtOwhJfv4x+HxTGY29DF2vjIilGeLlZMAYv5CkYgMe37miO3ztwJZfzHlysnhCi72Zt6Olk1czR3sjZ2tDRWVVHkPiV4AaHpMV/S38emvI9LfvfpK4QLMbLNLIoW8JvQ2bPROB+vvu2bsD07oij6Utcm+G3sqkM3g9/HUcdCNin3bddk9/zBFsb1ZVN9ibWWBpsJlC+rqPC98Xyj713S3eIkQNbGRM/VwczerIG1iT54LTTQq6erpaZTT73aTyecJuTmFf3MK/j+swCykMUmf4tOyoz7+i0mKYPxFbOhntby0d2mDmlXbSdZAjRwF6oRgGIUK/+58e+TMKoZSUAfTAcLE11rEwMLY10zfR1IeKOrrV6/nga4TWioK6sqw1GFnLyCvJKCgry8XEVFZXEZ/KuAmNDMH3mR8Wnp339mwFFF1s+ElCz4K2TChVFcrWGlMaKrx4ieLWg7uBdXQja2fxz6aeWRmyHhn9koPGoyO1gY7pk/qKtXY9QEY4U8UmIzcbCGn9qjV4M3nbqPoO8nSAgpZeXk6nL+QYkMdPYGeGcqJMBdOKLzhH5tSNwe4KWPrylC4O2npJ2nHlwOfMe4wU2RgoiThegQyL4xtEtzGU+2ROkwwWndjnMB/z7Gk1xCmCEybs2UXuN6MR/9LaECCHSTKpuJgyd4eJy/92rPOX9ys1YgMFjUitDS2Wr20A6DOrrJK+CycdRCTR31xJTsXecfQtkEVmzJUIcDbZRhU7lP+6ZgKrk7mtPGVMYZwZE0hE773niGWgoJlMcF4pYWj+k6uV9b7LpEcJik0GbiIuL/ImrH2YCA0I/IOj1wRWXwArLcDu7hOWOAt4u9GYNiYNYkIvA9t+DglccHLz1Oy80nkSwmxUEAfN6hZCm4g/i0dWFjkk/pGMdf+cUnboccvBoUnZghHRpRpAWY9QtGdRnXp1U15xCK2Ek9WWm2mTiD9zkl67jf8+O3QtA8sGNwhjXQ1Vo5sceYHi01NVQYFAOzpggBOP+9HPD6yPVnz8PjKWIhU2QhUNzbzdanjatPW1djA22Z0h1lZZ++izvm9xzSveK91WrD1MrVZsGIjn3aNZGDWD38jyQEpN9m4gAFWW3uPI/wvfn8/vMoFMKzSRo+ScjIy9WFTK9je7bw8W6KnZYkQZBtfaIS0k7cCoFkZnjZIO7QwZZSEwez7pBGoYVjqyY2eKUuLoC0tS8oLLn9NPyC/9v7IVGMpGWhTVOhjLTUVYZ385jary2EIgltjBuIi4Cs2ExcXCCny40nYbD+DgiNZjCMnysPbRfw6+/lajOkY7NBXdwZz0BIm9aYERcBqCUCeYwu3H91IygiJ6+Aex9f1EQAAovaNLXp4Gbf0dNRX0ejZgN8B1kEIB7Z73HYxYcy9wsPi+GOHo1GdPMY0NFNXRWXTqdqhsqczcQFMudnwc3giDvPPjwM/fgzv4h7X8ouIIW3dzP7Pt6u/do3waaSlA2uZOrAnuvjt9HXAt/ffR7JSMlCycSmtBdkGnS3N/NqYtu2qS3sJ+lpYzuJUrzpIA7G06OXnx6ERN0JiUzNyqWDJRM8ICMaHBn39W46qJMbRamVmVALXZ6yazNxxwReIS8+JMCO7t0XkeExqWimAOBKK+JFIwujrp4Onb2c2rs54AM4EUGTwWaQ2+l+SKT/y0/g85RfVCI7CEDiKDtzAwh282xk0aRRw2aNGqop46W51I7/h7iUuyFRj15EQdEI6XB7gji4Tp6Nuns17tbKCReJo3PiYpvpD7RhafIiLOFZWHzw+/hXUYksOheH1YazjUlbV+s2zezgDx8o/DGu+IMwBGDl8DYm6dm7+BeRX6AOifTtP2mqKbtYGTeyNnK0NnGzb9jMwRySagpDBT+XNgRgnr+L+foyPOFFREJQWHwaelWcBSBua1Tf3cW6TRMbKFJkZ9FAQEv8iDoEsM1UK7bgKg6rk7DY5PCY5HcxKeGxyUgtxOHQzdHKGOwkCHv2dDR3sWuIE2/UOpb4gZgIZH3Pex2dFB6bAl8BqFUC6elZlCoTHDsgd5+tib6Vqb69paGTlVEjK2NcMFHMKSATzZPSc8Kiv35ISP0YnxqekAbFGMrLK9HRHKaxm4OZi50ZWPmezpbYuQKFocE2kxijAAkD4UsVm5z5+WtmdPK3+K9ZSenfaYjCA/dtU0MdeyhAYaZvDa+BhgaNrU2szfRxBKkYg4ebEkAAJnls4rdPielQ7i0mOTMhOetrSlbqj18ESJLQFcrfGtavZ1JfS1+vnqWRrpWxnpWJnrmJnpmRLq75QwK+skcC5nlcYsaHhLSvqdnx6dlf0rKT0nKysnJzqS/aU19b3cJQDwoN2ZkY2FkaOf4fe1cBkMWzxOkQEGyxUMTueNjdid3d3d3dBXb+7S4wsbsLO7AbMVCQhveD0/Xcu9u77+PDwP0ez//u7Ozs7tzd7uzs7EzGVFkzOjrYWf97D+FPHzGXmeL0hHAX6e37L89ev3/l/8nvU6D/x8B3n74EBoUEBIUGBodEhkWEREThdl5EJFTCkdGRUYiYgvYQQMUsJoiKUXRM0giRtnCH2c7SwsrS3MbWOllia3s7m1QOtqlTOqRP4eCYMkmalPZ8DYjTc+KV44EDQcFhL99+fPHuI4I8vnoX8D4g8NPnIP+Ar7hdAY0srEbwFxQSGoaFCEaCUVH4NzIyWmoviGNl4Q+G2EICcegSJ7Kyt7PGv0nsrGGuYWNjlcQ2EZaQFEntUiVLDFEJe24EI4qHYXGSnAM0BxA3/dW7T2/eB/h/CvwYEOQXEIggoZ+DgoO+hnwNCvsYHBweEvE1Ijw0FFM+fpGob4GZ3cgo2sTYzNwM07st/m9plsTa2jaxdTLbRHZ21intbVMkS4wIjDFyf0oHm0T8pJhm+5+Z5zLTn/lceK84BxIsB2Lkp2hIUdFmxgjQy73tJdgHzQfGOZDwOMBlpoT3TPmIOAc4BzgHOAc4BzgHDM8BvskzPE85Rc4BzgHOAc4BzgHOgYTHAS4zJbxnykfEOcA5wDnAOcA5wDlgeA5wmcnwPOUUOQc4BzgHOAc4BzgHEh4HuMyU8J4pHxHnAOcA5wDnAOcA54DhOcBlJsPzlFPkHOAc4BzgHOAc4BxIeBzgMlPCe6Z8RJwDnAOcA5wDnAOcA4bnAJeZDM9TTpFzgHOAc4BzgHOAcyDhcYDLTAnvmfIRcQ5wDnAOcA5wDnAOGJ4DXGYyPE85Rc4BzgHOAc4BzgHOgYTHAS4zJbxnykfEOcA5wDnAOcA5wDlgeA5wmcnwPOUUOQc4BzgHOAc4BzgHEh4HuMyU8J4pHxHnAOcA5wDnAOcA54DhOcBlJsPzlFPkHOAc4BzgHOAc4BxIeBzgMlPCe6Z8RJwDnAOcA5wDnAOcA4bnAJeZDM9TTpFzgHOAc4BzgHOAcyDhcYDLTAnvmfIRcQ5wDnAOcA5wDnAOGJ4DXGYyPE85Rc4BzgHOAc4BzgHOgYTHAS4zJbxnykfEOcA5wDnAOcA5wDlgeA5wmcnwPOUUOQc4BzgHOAc4BzgHEh4HzBLekPiItHMgKipq35lbhy/cfeP30S5xomJ5MjesUNAmkaV2ChyTc4BzABzwuft8y5Erj176W1uYFsjh1LxqkSSJE3HOcA5wDiQwDhhHR0czhtRmzMqg4DAGAqMokZXFf6NbmZgYWJXVc+r6Nx8CGe1SRdFGUeERkcbRRmbmpjkzpRnXpTaF8CuzHhuPnLzqq6XF6iVyt61dXAum3jgfAoJq9HI/d+upmEIaB9tZAxs3ruIqBvK0HhyYtfbg2RuPNVZcMbKVna2VRmSO9kdxICQ0os/MTYu3nxD3yt7WetGQZk2q8u9IzBWe5hz46zmgomf69CX4wbO3QcGhAZ8CP4XoLDw1q1K4SvHcBmTSxVtP5m05ritBKwszpzTJIDlFRrIERF3J6oEf8Pmr5/Fr6Ilq3bQp7VVx4oIQHBJeu98CSmACwVefApsOX25rY12jZJ640Od1n79+f/bK/Zcfv2hhxYIhzey04HGcP48D7cf9t977EtWvgMDgpiOWW1tZuJXNTxXxLOcA58DfywEVPRMZGA5xLtx43H36xit3nxGgaqJO2fw7ZnRVRdOO0HH8qmWeZ7TjVyySfWynWkXzOBtc3aW9DxSmn//nSav2eWw4whbfejctP6d/Y6quAbMTlu4euXiXEkGn1EkfeU4yMTVWQuBwjRw4cPZWj2kbHzz3Y+P7HZyZIoktG4eX/oEc2H/6ZrXec5U6lgHf0c6JpmYG1rUrNcfhnAOcA/HNAa0fM2SOovkyn1g6sED29Nr7tPvU9Tf+Adrx2ZgBQcHS/RyjSt2y+b3n9i6ez+XPEZjQ25TJE0MYGta2GqPnv6Bo4bafjhKoFp+++XDxzhMKyLN6cKBysVxHFvazNDfXoy6v8us5sMn7wonL97W3u3A7S+397M2H/eduaafGMTkHOAekHDh55cFG74tS+G+BaJWZhM7ZWFt4DGiivaMREVHLPU9rx2djrtlz7qsu54Oz+jX6o6Ql8egaVSwkzv7i9Cu/T6/UZNknL9/94l4l1ObSpU5SJl/mhDq6hDSucz4PcTC9zOuU9kFdvq5isnbm6gPt1Dgm5wDnAMWBd+8/u/VfMHbpbgr+u7K6yUzoZcn8Lnbf71WZmqif3SzdcRLnegYZ3tLvqpFkDjaqBHG6lDFNMlW034WQKW2K39U02oWBmnrrxjq/G+o0/1WMHM6O/+rQ/6Zxj1zihRNznZSCqp/Sx6CQv4kFvK+cA38YB0Yt2fXxy1crSxXb61/Wa33WxYxpkgv9a1+npGpHccpz8NxtVTRVhFPXfK8/fAW0VEkT406ZKn62dClVcX4jAi5JaZE446mHaVI4mKiJRMns+U1pg7E/eVJu4W0wZsYToeXbTx46fxfEo3XZ4yVPlpjdHyfHP3fnxu45L+Uc+O0cuPXw1YrYo6roSMNoXuI+In1kJgfbmNXUwcpiYIvK6oomI6MF21hH/hrHsGjrNyId6pS0NlO3DkmmNpdpbDf+0OCLIf6IsynDA1PJ/KzTIgsz00I5MrKJ8FLtHHCwsdaOzDF/PQcCg0LHrdgrtBuuy+3acq7Z2b2tUYLfP2VziJdyDshzIDwystnw5WGx18zDItiXpuQpxAdUH5nJwsIUXTE2N3PJkLJCEZUpA5h7Tt6ALWRceu//KXDr4augAN1Mp3qltJBKbPOne7uxsPidysaRHaoz2NijcTnukY/BH12LrC3VpXxdaXJ8A3Kg7qAF+s1RQ1pXxQZDqSf1yhfI7ZJGqZTDOQc4BxgcGL90z3XfFwyE31Kkj8xkGqski4p1htm1XhnVfkdGRVMO31SrUAirvM6EhocDWKNUHlzfpUpls79RiyPbHynQzERxqpUiGxxSsUjOEe3lxaYyhbKM7+Zm8Bb/ZYKm5r9TPv6XOa9l7PA0K5zKCcg6eQZwTpdi5eg2sifd2TKmWjyshZYOcBzOAc4BigObDlyauHwfAZr/MY5v9JGZgmN1Zcax/7qVye+YXN374vKdpwUNG2GBTolF208K+N3qq4toAqaV8uZPp6bjD9lEgwV9/LUOyuO7uv03ug3sw0gr2DH3bFR2v0efRJa/7dyQdCYhJSxN9fnQEhIH/tixeJ+52XfmFnH3dP0wm1ZzPbqob97MP/RJEKGaVnE9tWxQcgfuc0vMWp7mHNDEgbtP3nQYvzoqWmTDpGaAq4muIZD02f5GRUSgacEpONy1wcBo/LI97M68/fB5++ErTar8j40mW3r0/B3fF34ock6XXLtXcWOddouyDccz0NTQUWX06G+bWsVaVity9sbD528+JrazLpbHOam9+p1EPRr6x6uY/PES/L/5gB69eAfnAj9NzbA60P3DLF0oq8+m0fD3e+fhK/j+LpI7U9pUSf5NlvJRcw7EkQNfAkPqD1wU+PPl7t96KvPTgPSRmb7GykyETOe6pSat2IsDOAKRTSzYclw/mWn+d69x3TScA5KmzUx/58kX6QYj8RvvzYl7Bam3ZIEsYghPG5wD5lzPZHCexpngu4+BVXt64BozRUnvzUzB7BnwR1HjWc4BzgHtHIDdd73BC28/fk1VMTX+UxZ0fY4MIsN/CpeGHVXNUvmoEUqzJ689uOkb4yxApx8ijXge90EVOE1prUvM2j9/leIRFXR6E/5qZEuuZ/rDnl/Q19DafTxkY9qY/e5D8z+MVbw7nAO/jgMdx68RGxeShv8c8wZ9ZKbQyJ9kJoyqa31Nd9kWbztGWKAxsdTrFJyJA7lR5YI6GQeY8p29RhZztPjnwJ9/Uhz/PPiDWoBngaq9PKQBqv+gLvKucA78exzoPGntqt1nZccdZSSybZLF+FVAfc7mYi/M/dRBmBnB2OjRC/+foJLMqj3nJveob2tjKSlRBKzacUoo616/rCKSXIHBZSb4Owj48jU8MsrO2tIxhf0fG5VFjhl/HMzvw5fAryG2iaxSxo+zx6jI6Nf+n0LCwq0szOFP0vJ3X1tjXEc31LOBTvvFm48REZH2NtbJk9j9mvjKED78Pn6OiorGRRA4/TLUWCg6IaERMa1E4KlGJUlsE0eTu09fgqv38jh74xHVCslGqJkZEMxfk8DtmWev3uP5JrOzQbTKX9OoUitBwWF+Hz4bRxulSGoXf09cqXXtcLDL1Mgk/r4C2Ny8eR8TSjWpva2WuBTae/43YoaGR7x7/wU9T5UisbleVjEIFtJ1yvol3y97SZkQqzmRgn8DRB+ZSbabneuVHuyxXbaIAL98DV2771yXBlrvvsGB+IPX71E9X5Z0RfI6EzpaEvo9OTFlzK1HLtw56eN7zsf37sPXWIFJqZWFWdYMqV1zZ2xYoSCc2unXlomKARhpjU58DQ2zMjcLCY8Iwf8hxMU4Lo7GD2IifmamJhARLHAaZGyMQoOLC5iM0CEslhGxjlnhrMvcLPZPw6eC6Ke4Anng/K33n4KEUUF3WLtUnt5NKuTNlp4ep455dAkxoY9euHvS5yEuDYTH3usEDbhdhX+KQjmdKrnmaFz5f7/F71Q8SdgQknYcuXLo8l3fZ+9eQKz4HqYDTwRugcoWzNaoQkGE1taRkSrouNKy7ciVY5fvPXjqh7sdIWExN0LwS+Ng+7+8zmUKo9FCcbSAjoyIOnP9ofe52xdvP/G5/wKtCE0I/8L1Wp5MjlVL5HYrmz9PlnTiItU0OFajt4cQUUAJOSAgCCGuUoic4grRn+LpIcp2A5PPtiOXMf/AnuHJmw/kycKTsEsmx8qu2auWyFOqoG5miDGjiDYOiQgPDsbEEIWJwsIMP1ML85h5Q7YbBIgPdtWuM9j03vB9QeatzOlS1C6db2DLythDEszfkkD3PI9f23fm1o2HL959CAwI/CrY18LjDDpZoVDWDvVK5xJdbNSvkzCA23f6xokr9+88fH390StipAyZyTVXxuol8jSvWuRXTi9xmYoJBwTh8ktISFhYJBYRTB3Y4JmZm2pZODAVrPY6s+f0jVuPXwsMR92ieZwbVSrcpmYx7SI1VrRmw5bjCZJeSRMQ1l++/Zg6mb3YpgWvtOqrKyUVR4gx2KQriWz1R91/+havY9CpuaQu3qf01YcIXpQIUJrI55Lm2sbRUrgspMHgRdtiXVkuHNq8S/3SBKfz+DVLPL/pnwiQSszq27Bv84oUUEsWj2HX8euLd544eP6OcCzIrpU2id3gttW6NSonfpbsKkJpFrfhvi8VNXO9m5af07+xlM4Qj21TVx+QwmUhMDP33T4hY7pvsW7SVh30Wi00r0AHXmd8d06Q0oTQU6bzTCkcEIgmMd+buZlZdHRwZDTCA306NodgHjh7a8yS3Uqbe9TtVK/07H6NrK308f2Ib2nogh1bDl4m6zdpl0rAKq68a9bsTo6pcQnczCQsLCI4JAx/X4JD8E0Gfw0LjY7EKHI4pZ7Sqz5VNy7ZIxfvVug6m0HB7+DMFEl0uJd+6fbT8ct37z5xk7rzJW0ie8bUg1tXbVWjSNwnF1zLH79832kfX2krYgjeutY1io7r4qaH5HT/ydsF246t3XeeSNViytJ0Bdfs7v0ba1wOL9x4VHfgItXo1EIr8Bdgim2HkVEEtFuxd55zZnK8tWUMSuv0med16oa0M7KQz8c9dNKsQwU7bbX3wq3HVeORw//ToBaV22kIYCV0zK3/fK/j12U7iUcW8+WammAjhL+hbauN7VxLwIT0NmvdwTnrD2HHK1vX3tZ6zbi2tUqrm7TKVo8j8MHTt1NW7lu977zqXI1Lwb2alNfvHtLjl/4jFnpuPXSZ7TEHe+mGlQqNbFcji1MqLePac9ynVv8FWjCB8/bnKQIKhco93GXr4qW1MDc3NzMRpuLktlYvDs6QxcSq7VhlgNL9LcyENmamkSbG2H9GREVtndzZrVx+gQ5Cmgxf4MmQchDv1XNGt3zZ1XfC8CXbePAijQflGBrWWRMjYwj9pNtBp+f+Suc4BtMzYcZvUKHAuv0XZJ8NAfr4vjp19YGWi1rY6glfuK21ZYuqRQiFeE2gbz2mrkcnSSuYOjOlhVLc8s37z2/8f9rvCjgvP37pNWvztuNX98zuqV2yRl1jvY4AWtYohjcGe53TNx+TTkoTWZ1SlczrXLJA1gyicFcLhjTDsgEHoeiztIoYEm0kL0kXyuE0qXud45cfeJ+7JcZHGhUwoZA5BV8sQeg7feOcTUdJVppAXXg9vf3o9cGFfbTsb8QUNnpfHDR3G3wliIFIY/6qWzY/1rkPAUEbDl0Snh1k+n2nb+GPQqayDzK+M6zMhLMMA/6mrvIeNm+nVFrCQ3dMnjggMPj6/VekFHvBtmNXrt9zdtmYNhr9wUq7+srvU7txq6mH7pI2OebEWw9fowlxFcxlK3ad3XHMZ+WY1rXLfJtkxQiy6dfvAvAc1++7SHoOtCR2idKndID0oLS7OHzhrmvrybtndVeNYYIXrOe0jUT7KNsHMRDdiPqmQRODY9L9Wlb+Xx5nRB9HME26LG55SEtjl+yWSktgtbNjcr8vgT73fqh57j15237Cmg37LkzpUx8fpmrLQ1tVdU6dbOWec58CgylkPLLg0BinwcKPbKQhmlfp4Q411/cSmf/ifWs1bNmCYS2aVv9Fs7TQCShIxiz0mrb2gFhagh6ujGv2oKDQI1ceiF8kVMGG7dyNR9fvPZ/Qva72MzucC49b7DVrwxFKHYB1IU/m1E6pkr37HHTh1mNh/caebc2e8xu9L3VvVHZ8ZzdVWTlXlnRD21Q9fukeezKXYbqREZ748LbVDl+4LZU2MNmgt+R5hkQrOtvDqu0+oMnOw9BV35O2go/l03dtvbh088HLzUcuE7NdXCqk8WmU6jR9/9xexfO5SEsJ5IyPb62+C9gvGEFGAkNjtytGjqe0wfRM6N85n4fF2k9T7Si8va2f2F4VbcrK/UPn7QAaNEzQM4nx40PPBPXSiHk7p6z2JqsbTDQmdK5dv3IhGIgIrUNZ0nXqeiWzrXQpkxxb3C9zeq2xgZ1qDmWEa1DSMxE+7D19o96AxdSXjNLUyRMvGtycbAgIPkngxlDzYUs9mRtlWKc93DmRVJEmhi/YOWnFPimcQCDpfjnpgbZaDFu285T87pYgk0SfxuVmD2xCsqqJge5bZ6w5KEXDYe7u2T3SpU4iFOHYrs7ABVhfpZiykBwZHW9vHSNbpB8QJ4blu81m1NWoZ8JbKnvqXzS385JhzfNk/XZQ9eSFv9uAhVTYAcRvmTeoaTu3EoxuyBZBlq3ay52SSsd1qjWyU00Bv++szXPWH5bWhfZizZi2WpZSzMKdJ64ha3mMb9Um5du7lciRyVEg++TV+1GLPbEgSVsBBDrvHdO7VC6WS7YUQPgUbjJsqVKpRjjRMwn42HoPmb9d9vUTE/yiTc+EL6XBkMX7z9DSfO0yeRcMakY0dj53n9cbsoiagrB+zxvUpGvDMuJ2ldJv/AOgKsZBgRIC4CM71BjXpfbq3Wd7TNugpF6iqqMPh+b3VpVcqVp6Z4NDwpsOWUxNYpUKZ9swpbNgXYQvrnIvd9n1FQ4Fl45oqaVpnOS2H7PywCV63qhfocC8gU1Tf3fmDJmp4eAl1GQORcvmqZ1cc2XS0tDsdYf6zf7Jsaq0ltIUMcxj++TV3lJ8AgFD/A/NIlnZBBTh1XvNk64mYuSd07tiWZm4Yu+ohbsoeVSMJk5ncUx2c8d4JWtOPKNqvVUaFVNTSv9iPdMPZYBSh7TDYTmR10XdvGD7kauwp1Yli5VWwNHu+1tMk2yVxEClNIxLGw1dgjePCEwwzriydni7uiWJwIS6mJTPrhgClbgsHRiUdJ24lihaZHHEQCVdjhiHkcbxedvaxSiEEvlcfNaPYghMwIcybOX49nGMgDaiXQ1IRVTrVBZmkhW7zdEuMKG6+6ajF289oegoZaG+kl2x0qZw2DPnh8CE6tjwbZnSGc9UiVS8w3U/AZftUpuxK6VmksVzZTq6uD8RmFARp7G75nTHnltMBIoEuNadJSdiitGoNISV8l1mUQJT65rFiMAE/Mnd6yVNLOMKFZvvNuNWQVdB0aSyWDCaDF1CBCYzM5OD8/vM6NOACEzAz5gm2eqx7cZ/PzCiKEAxU6vv/JNXHlBwkg0MDimZ36VU/iyVC2cvmssJCzwpkiawWUL4IOnf/3JlFCPjjGBK93o4mhcD9Utj/sGhoVRgwlSzeUpnIjCBOBR7+917UU8WC1i3qesnLv8WY5jdB6z0Yzt9O3djYELj1XrMSo0CE+igD12nrWcQNGARpNW6AxZSAhPOoHfM6k7MsSG9Na5YWLZRrCxzmWpvoRamrzoDFkoFpjwuaTdM6kgEJiBDMFo6vAXVFhQtVTrPOnpJRn9DYSILMxJsU6VwLZDx3eqQUWvBl8Up/7/szavKs4vg4xG3GbNyxAJPjQITKsIceeySXYR7RYTKAAAgAElEQVQClbCxsSyFw5D8LhB28W2ylyQsN9JPUoDo7VCN6o/GrMHO5oT2ujUq02XSOnbbEGZX7zrbr2UlBhokUBjzAQEbaPFiwKgSl6Lu09YLhlOESKPqRcRfBYHjntecvo2q9Z5LIOLEwUv3cLS3ZLimTQwmSnFdPdIpRWFPUL1p5cLLR7XRYhLkYGcNA3YcsenRqFAFrRTIlgE+t5QohIVH1Oo/79zNmNtJMPTu17wizEVxkc1942ElbQEwwZEJS3Z7uvdQIkvgmPWUzvsQR0+8zAhVYJvZu1nFwQt2EgokAUE/U9qfJqyMf6QT58n/7ZNl3YRubrAeI8MREjiGa123pPuGI2I42NvffWualA4arTpgm+nWbwFlgo0Jeu6An3SBaL2Ka/YNhy6L2xLS2EK0Hv3fjU2jlKypEB6g/+wt4i/BNZsT3GpLSQEyomPNrUeu+jx4IS1FQy1Grbi/Y7zs2W57t5L4I7Vc6owQphcCESdqlc6rMU4cxCZ0VXbgYoKq6dFLvA6evy1FG9SyinQ4sJXp1qyCVMsLgxtIe1r0iCWZxyXohtexq3efxky/+MFirFfjcnlc0l2687TfrC3YGQpw6b84K4TyG3s5aZFhIQNmb6aOiUF/Wq96lGkEXnIlW5FB7lsxHTk5JmV0rOGQJZfvyoj7E7rWll76wXbarWQeSozDtSG3fvNPLx+k5aZCkexOlPqQ0TdxEV7C/FnTa1eii+uK06UKZsORuhhCpQd57BACcgAO9WfdsgWTJrbGSu2x+ThDipq/+Rg22LKrEmTNg4v7kVaaDVu64cAlkqUSWZxSHls8gAL+lixrv6VHh2B4ZKfhyvHinSfZxJduPyEgdG3ww/SbXUXv0q2HLy/a9q05QuTxy/ckTSUqF80Fs0cKSLJLd5yilLSkiEoIQY4poE7ZM6KNdbOqrmsntJd9NWVpZkmXQhauHZj++8mXbBWsYYJMVrV4rnvbxsGqFIa6OIOHtqBOybyyVQTg7jO3cHzAQEARDGgGztkmiwMVQv0KhWSLGleTt7fA01w+stXOmV3J35xBP8kEstR0AkYq2IdpJ3L+5uMRC7yk+LDTLKEgYTRQ4AOcoDx9rckQp+/MzdQBHzrQtX4ZO1srqif5lO1p4NL30Pk7FL6Qhb6548S1YoEJ8Hsv/WCPL4sPIKJ0KxXhu/M85qNUKobbWOpz1UBMgaSdNZ/FkypUAuqxSSv2U0Bk8SbXK19QCgcEl5RhDCv9dZuy4cZ9GYGSwsSFcNnqBA0GndjZ4sIE4lEeWtAXRmnYVDSsWAjmKdACEjRpYu1eFXtWaRVdITjGlW6WIMdXL06/GMXyKN4YheHRnLWsmzSz1x+SimXoKjR/SiZ63ZuUl44FijpoEAOCgqVFFCRDmmQURHs2jSHuLWZMw5Ig0RlBYEJ80hNLBnjO7I64W2AFTCk8BjZmdBXmbrtOXmcgkCILC4N9lYRmfCRYH4Ae7UHSx5UZ1Yo4TWcoLWHMv+3YNRCBBWijSv9TpSaPQM3E8khGUPYMlXORsOtEzK112UqwH8zCnCixvMlWpIBxPJuDMSMx3KtSNNfKsW2UtvJUu0I2hb2dLFw7UItrJXTMa3Z3yqFO75YVGa1gy3JcziBRXKXPjM1KR+9ZnVIqXUDDtlLWCBraskHuKsYE4tZ/fRrmrl0mr5XdzMH0SslcoEieTLIbGFxcH+q+VXUUh87flp4DolaTyjKfZO6MqRkEtx+N+ZylP1hBSc0/cWOu44Q1UmQB4vyzRpBCO3RBRltD4SCLS0VSoH4QO+XtkxaCeLKdJ62TfbLZnFJBHyxLBK9xXjknC/goOk1cLVtFDISaxEpNaoTEtmVqR6yL4orY9tQonlsModJHL8vPmRSa3lm8G10mrZVW79O4PNQtFByCFOM4fuPhyxQ+yeI6wrgFniQrTtRU3u/BywY2MGJkIQ2NZo+pG6RwCmJvl4iCaM/aWKmYSWghlfi72S4DGQLTmRWDKCcXMHiXnVcJnVNX75M0IwFfeozSP6eIfs/i3rPO9ctqIUI0SVLk1bvOCFZBbWoVlx46SPFlIRrtmY5cuiN7JQezWMvhy3B3T5a4Q2L5uUxAhgM62VoUUByzmSpSzeJ2ff3BSwS0ikWyb5/ZRaouZhNJZP2TsQsbWbbU0UFF6oJd0YZJHaQdK5Uvi9IyLzR06/FP97Co1mEfI7sFFNByZXak8MVZnCeKsyQNpfQWuaMlghDHBBxoxYXCkm0nr92T1x8wrtmD83mypJVtF8dJbDMjfIBQWkjrYhGSbTG7M4vtN+8/l5ICZM3ec7LwDd4XlKxzbCxZ7+2NB69kCVJA2bWNwtGYtYnbRD93/ZE7T17LtlUop/y7KiDjbF22Fm5RweBdtkgMtIzxosD6jexYXdZ9QIXC2RnVcDv14+evDIQ4Fo1d4iWNDwiaOGiTpeysLMqjqwjMJVtrzCIvsTc+MU5ehQ8KOJjTlCafdXvP40a2mI40DQe/UqBGiJWcrKaxLkGTngKTIiGBKx3bp3eGGxoKjmzlIqy34tKdZ9IqUoiFROqV4vwJEMPLTHCmB3su1bFtO3IV+iRZtMU7TgrwLvX0P5iL0GZ1e+6Gok4IF/JHLPaS7SHbhvSl2tGSQBPOM2SJqwJxC6xSd3dBU4pD9F2zeurhncI0zp+ZmYUZu6vLRrSU9fCGHaHsh0eosU+O1isstEL19KmSEjrSRC4F+31g4hxKim8oSFxkJogvuKui1JOcyiNClSzpUylVnLxyn1IR4Iu2HpeNxaa0COG6KMMa+o3cnQ8cpTFOsccu3S3voom52D9/q+nMkTFwnYtMVYQPBkHclZv4n+JTgDNGRl0XZVX31NX7GRWFIsWzz9hiXDsd3r66LBFVz0MvDO1/gXQDt9gWK/iJzpxB/j3PyRTlpT4d0Bbcaqzcc5Y0SiUypmadoGVy/MksktTFRD9jDesoEJhxEr4NEShMNXIGnIEpOQ7ImJb1rjI+c8KivyhheJkJg++m4dYrVoLlcn4pcelRmKxhS5+VuR6wuYxb2WwEofSrgqM2odTrhLx5RNTPUYqphgK+BFEQ2axGTZi0bqvRK4S9adOKhbbM7KqfKs5UT4HtR3fgPfhHRpLCNQd4apaAvwFSMHVUbAZ6Mj0XJLVlqbiT/2w1L+7ey3ef4FBRDDFgGh7h9Ka20fsCwxNppjTy07TQHENn7nnsGpYH2V7hwGjaKm/ZomwZUsrCAayqbGkEjaO01lsFJa6ACd8wj15+M0MW12XP7G8/ymsOxBQMm9Z34xPTC6jZpEeTpHsZmNJ/crmLikLdq3efX77zlNCRTbCnx9pl8knVwwIdhEyRJUiA77XNfgRfe2Lh9uPC+QNVBQfQNgpa8xJ5M1PIJAtdY2q51xI7dtlWhIopRd7hCSmSyJAyCUlTiT1nbsrvAb7jRbNm0+9ICv81yMUx1fWoSB5nhfaNGAa+qPLrv0qlfhoEHocHpdx+vQoFGZtOUg97WendsWXfzbE71C9DMPVIaLSwNmFK6MYx3q1lfl8jwmWg30EfvgR/T7L+a8zcMSvV7DNt445YYy/4CFkzQebkS6kiBQ+Ps1WyEZN1bC0a21YdLumo3pIs/LKwb5dQd2dIRSHBvpR796n8KQlFRI8se4liE1zjpbjrRcVUzABksno+oTk4Aliz77xs0wdO3YQEKVvkKLfMCJi9m1aQ/1qMjOCbQEoNTpWkQDHEVsNtEjE+0vDHgyviFFCaNYmLpCMlpy9kzT75o0mBXprv7n9kybO5t0PBgIyQ0lvxac08GwX9IA38J93QKaF0kptK2d1D/fIFYRQr20rNknlkd5sbFGLECkTYceITJ5ZvC3XxZrJNoU1NZGyhZHsuBZqZKH15Utx4gSRh2kJh7AwxlHToT4vzSDpGJeJFZsLJbhsNHv3hwWL3qZ8UOYgbIFh/Q+SqWz4/1VedstGx0dBUq3QQ3UCWIpdViOiE+AJSZAIJ1CYzReguM/WatsF981E0hNNP+AiRmj2SPqgmNPKHQUc/P+YCQStmcLqQ2JB2sk0jkpQsnAATMb1G4SoQwZQmEEBNCjQIRG/bNTgxP8q0oIRVJqOHSexsGKVeJ67Jlm45elUWDiDD6AEXqkd2rCmtWKdsftkL8LCLYhw/YQ6B930pNdXF/stXdZkpKIy155E2Gh8QWCacu/6EQTmpg8zwCT4igpG0NLGLGboL+MZMD1VSggRiztwpAQ1xKAmyARPQnFFOwghxe7n3RCjFDmrjpA5S+RLyKPy7EgokEXPKERvhlEDECQgmCEwshlBpe6ZN0oFztyl8cTYuYk9sjB8xMX3S+u3hhZbY2l/ghIaof3ERytO+PuOJtzrxIjOhtx3rlWYb/Qgjmrf5uHhoK3d/s/5u7VZCSTksxmekNdozwftfCwWX/3CxNbxdddkmEIpKFi4AP2i4WQpMEx2/kp5T18/dfCymorHJ2gnt4sifuE9tWrYOAkNk/jVjbYxkrxEJRCzjZnLL5vkLf3nlikz/dQSFR+m5kJy69kAIy6DUYGLmWSQCyChVBPz8jccwqZEi4NKoFChAEMVKqQhwBCnbPKVTxULZoM/D5wNXyP1bVNo0pZNSlaXDWihJseM71Uopp0JTPUEICpYZEdWBMObZOoUcT1kEOWa852jUwUZRaYFS9i0KBCFWur8iDCdaXyleddqJCRoeD7/DZxUFDlsblsISnpOurRvRvKqrcH4E+Qm+hU4tHwQvZdJusi+CgAI76IoJ04qZfR1YCHku7dIvgyAkl95tqepttRgnIICc3h34lRVZM2Bc+oF73TVL51YKCUkow5MbfO3AhasAEe4249F1rFOK4OiXUN2PErIrR7XJ6JgMNnriCK/4tDZP7JDLJS1BIwlEGmcf0EIVSZAZCbanE6pitynrEbZTAGKqXeF1eowGZ74UEXE2Ms7LRmhEhJigAdMMAUM1hBN7s8L+tpWOYuM+NL3Nmc5ff8RuPbEN67oNe2WFNHb+1mO4ABY38fC5H8PIBrExxcjSNLz44E8Kl4XAWfPxxf26TF0nvhWIPg9pW21Qu2rSKvCxef76QylcDIHfVHFWNh0Wb6+ubHOyQATckIUToB3zyZoyNbUgcvX+c0YwmVg9k15yvOpOT19pjAxcNnHosuJ9dcZ0IZCC3Tp81yGNHQKsAhg+WdiXSROr+ZUwYz4UBIeGNbSiiSF7bpJlikGB7P0kuylV2wPVrQ7ox30bz+6koUrjS2ZC/3o2KqcqMwFtweajHrFq0hOX7wvOeSsVzQn1TxxHqF1mwgnX+K5ufZtV3H3y+nXflzh3wy2MhuULSre5CHA7afleytmrtJ/GRirrilDFkvmBicn2mbmJCEwCfMp/3i2rFdEe205MTUgHx3nZiIwfJTy6xzA3wTYXAfVkgyUL44pmCqyBzIMbLR6npJzUAolWndcVqJyOdaSuUBgDZvuMUNWZ33z4ipKZLjJDnfgxw7Uy+qlUVCSv89V1I6/cfQal15cvX5Mls6taNJfUjTtusM/fdGTOpiNsQ1q0EqphM/AnyEy3Hqm4RWDHJlI9I7t6/wVDZtJbzxSXExyld0AL/Lqc83ehInubJCbONnYE5g1RdHZxRSHtwJRigaP6ULDAKclM0XFwR2IQcSsuMpOquMOQUwmfEeCdpP/kRDzKTBWL5ITXVDjUZ49/1Z5zk3vWx8WHtfu/WaTqF2COakVXj5Hwu9hKzlJVIAs3lWOW7JIGhKIaFbLh2oKiGDPvnRHKCMFIRcBAEZzXdZmy7uD8vgRN1wRbttBCLZz5kethrUUajWJaeiFQwH7/WwSZSnxmHs0EMksZzleoVnTN6q1nUnU4xDAwiumk2u1I32f05ymFiAf7ydAyk0C8YPYM+BM3RNKw6Jq17tDcTUfgipMAGYkoDVYRYWF6qVgYrepedPuhyoUDSyuW7Z2q7PLoGcs4T289k0FMZ3TlFvzFUwF8xBQ+GOimHqxplTzlCs2pOqo2VlPCPX7xrlzhbOLOk3SYmgaXYEoTUarfubSOBKL6Rklq/AAgUtaPjFxKy2vzVcNuR472r4bFlz2TMI4ejcqpDghT4eaDl0JCI4SIbwiZVLMUK7aGKsFvCMwVXSsRIyMEda/Tf2HRNlOIwISw2IiKyqAQqU07zVbkCvSHz9uhFLP60Pm7KzxPM7rBLgrVsLSwKWjf3knpGBuxXjz2qWUl1xxSggTy7tMXkpYm/JTvt2NbX67QT6dU0up6Q1R117KUcQWMcUyGKmxGAYFtMQMEqS8xKUTcN3apGDPuaURQmbB0d8ZaQ+GeShCY4H9/aKsqcaccquH8Lu6tsCn4fWS9qLBPYJ+rMrcVMS2/C5D3fif0Sm89k6rmkj1q/UrfMj3evfvAGqn2Ft99UHFUoeoKVVVX5CfnqEzoIRx8aO8qhRlpCEWTFlUQ1S7JhqupiEzNWRO+QCeMeRudtPXbE+ojiUsX29QoLhu9gaK5bv/5/7xOC8sDJJK4XAf7QTnOrxGinnUevyZvk7Ge3y+hwAmy16xuS0e0NLdi6edMmAIB6aHqgjfEY9uklfsJvjSB4KaqodmktQRIpN6qj+8UjZk6DPacHs08vjRl+gnEoSQV1/17j2L+++SlvzhLpe8pb76bVyvC9oBAkdIpq1+8ueAQtutBvGdYW1k/1cn0vWRlZbtN8n1K66VYzetbBhckcESS2W34yMW7ELFLINOncblrG0fmU1BH6dRUnK4v6NSSAjIWyOBQlt2VWZxdzr4PYHmJ0/ve3G+RmaABUmBkDBgLh5aAbgwKQtFX5hMBjoUF6+oPENjXNYDAeOiRcdAzxXmti2EAe8aOwVD+qVp6WJqyVkyB8J9wM0N5iD9K1EfyA1f3FCx229QsJtz2YtQ+evH+xVtPgIAbYZCZGJjai+LyGmFKnbX2IKI3iI9ySuRz2Tq1U2qm0xShe6rCkBa0tfvOq5pufAoM7jpl/Y4ZXbWzhWAaa7K5IugyCVVFtEwdbSBLY9bclCJZ4iEdaw6Zu12WGNsc57SPr2wtmPyP6lBDtsggQP0EVNWlXXXlU20XriOpAbK1pI9efQgNj1A5EKQo6pg94+PbfdoGsVU4buH9N6q1bCgPKe1oDXO/AfVMGlqT9tEIrvxloCIQ4lSIcjJJUzVxmRHnWIacZpBB3Cdqbu0bYlCoyubh7uM3RXKzdP9aWoxW+1rU9UxqZ2QRygrOuOiZtFhYq3JAdQPGoKAq8GnRg/wJJ+aMMZKi+NUzoZmuDcuSxpQSOEEQdO+1SuRSMpFTqqsE1/uI1/vMzdwNxwydt0MsMCFE/OFFfbUITOiPRpnJkunpRBCYVKfOnceubVUONqnEnBg4U5fDqvi9zEKzDfv3Gj/+yz6bM1bbZA9sURlu4n+QE6VwOQXRi0WAH0lcilFyqD23f2PZu8c/Ksctpd+kZsW0aEGPVE9YVNuVHiOzHw0+1RsPXsaNGYq1cRYJzW7J9tPFApNLupSXVg7TKDCBtOqiDiUWWx+g0/VJM21WidSYVY2RVQ9KVDWXUqdEVB/0y/4WPZOqefLVu8/0G464lrWak1VVmUn14pE1w3sc8/KKuJ/SdFwUBFJqekDYMpPGBTFSzShKj47FR5V4l5lyZHKszAzrKB5Vh/qlxdm4pPVwKoptPa70V+01l4q0Va1ErvWT2mvfW5tq9BfH1KZg7HC8dmH1MESUY/Ohx9SNsJNl40hLVZcWaRUKouJCnbkBZxYaWanpwOElZd3kTrhhQHVJyM6P9WIlLVq87ZgUCEjPRmXb1TWMdlOWPoCqdkWyFXG3ma1tUD1gVZWZ7O2sqaYTWarons9ek9fVUXR0zcJfUZ4mY5d4nhIf+eITOLa4n063aNkhfdArVe2dThFP9dO2wlYJ/qsYLFJ9cKqjsEnE8lrEaJpdpJ+MyKapWmptpvJOnrhqgHcyqXI4GqGHqqKJ6vcIt2VKgw2Lgz2TftML1RP2nByDrDwZsZ1yqfr0EnoSHBlBdenPzMa7zIRhd2tcTsvg06dOUr24inyghY6AozrpUKRwNaNCl1nUlX7guKRNvmliJ41PXaCpxbibal2adbC1PjC/Dy4T/TeuHTuKAm6U9J65SUqBDWFrudh1hdK47DjZLNISPzhFEtsTSwZWKpJT2tXlu05L3RpBybTCSyZURe9G5QRXF1I6BoSwbb+UGsLKmkY5LgRqsfUlSmTFcGksCHZELdQ9du2BmIJB0hOW7SnfeRYCA1DUVo1tI/U7QOFQWdVNrerCphp8WtyiqogmRhan0ynHJgOa6vQVITlUFRNHOgnTmZCqhpKiRrImTG+0BM2wiRTJ7NkE4b9bv2sWYrJwLsPW60eqXYhWtQFPkdRW3KI4HZd7cybifYaYqC5p1XtzjAmf/bqq6ueEbmr0a6jLmOIF91fITNCrQx5S7X4nt5JsL6uqFMQIqm+AGBkHYRW7zDwl2UBj/t04pZOdLcttoJiOkGa8W2JkhhcioLWuXhTBJZBAyLBhCu7ICbW1e8/DuRTJakkYx+FkTaBvyfQxzea/OfNk0IoZF4KMDu6U9rn3xEUq6puEJFFn0EJxmNI9x33cenlQuzFs9BcNaz5nUBNC8A9MZHKS16WRrrL1DaqTeNZ0dMzdzBIIaUtIHDp/Jy62FxQ1LHUdx68auchLOu2P7FAD/koofNWsqguPCDVfWbqdaqlvz+W7LHzd8mUapOGvasEoMjkmUyIOuKolnFJd42hlbYNSnTjD06RQkZmwbzzj8zCO7WBjnJEZ8VrVDE7V27VLBsXPWfVcjzE6tsjCqKhTkar3KSVq7B0yqcU+4CNovz3xK2QmSEI96pVhDxXSSfs4+/4WN6F9KoObg1p95/nIeTNrWLZAoRxOYrJa0uzNCqEQxjQ5FPsC6N6obFM138ptxq589OIdIa6asNYmlzDoWKgpzBl12QubFj2TQBymhZN61Xu2ezJidIgPO+D0skjryaU7zICfiCx1Rtbsv+CV6JYvZn1EOL65aXTnegY7C2YMNqZI++v4M6ECWdP9DKBz7EBOqsJNdmdHimLuWEmdAoqzMD3cf/qmGBKXdL/ZW5Z5npFSgH/zIW2rSuGqkLgfHukkM7H3Boze5pGLMUDwpbb5pEhIMG5gCQg5nWN2XEo/vfVMSgR/wDVaJvyooJ6C8zx4smXjrd4ro0VmV5GWsh/KV7V7rKpyT7YM3yJeSJuOC4R9aKjRPk+183obsFozLXfJwNm3Twjab0/8CpkJg2xbt5RSYCmBBTVL5nVU20wQZkVr6LW55k93qMfWszceEeLiRL1KhcRZjWkLbWah7Bc96ufiYR1qMi7Yo2NQlY1ZuktjD4FmygwcpoWOdRwosHceup53wDZ/Rp8Ga8e1E6920DadvPYAfiJ8X/xw7ocoPcPaVL23bdzWqV2c06XQMkyD4Kia9Cq1UrJAVqUiAR6sfBMHCBFMN3HYqFT4OXAKqrjmzKh6vLVw23F2rzSW7jhyReqvVahbo0TuRJb6WOSo2gubqc0MbAUqNTRVmUnpMKtsIZUni70c1ZY4G6Tm4dOVeY9Mfz2TmvTPdhQiHoJO6QLZ0rPxt+y7EHePAyXzZma08iVYxasqW5DNmzkNI/STxtMJRveUijSarqrur8yZBwtKrQOu0b8x20ePRslP3I3gkHCcHW3yvrBuz7n7ar61xRXZaRXbOtnKOtlIChRgfVK/fL713pdkCQLYVRfrb40vgVJbYvjJKw/mbDoqhojTxfPIf0IWzGk3mnnwROhHMX0UUWaPuV3SzOzfuP3ENaS6NLFmz/kaxXM3ruIqLZJCtJu0S+sKEBPm7Ta2utiCaRWhuuxRXfLz/9x9+kbcH4Sviva1i1ctkTtxIisIka/efQqJiMDbktLBFkcVuV3Swk8BVfcPz0KmgQTDOOmPDUlrpzQKdsDa6kVyYQdP1cWVLtdcGc/4yO8iBOR9p2/hcmJetWWMokxl4bOg96zNFJBkC2WX1+9aMMOgorramo7Y2CpbLuqol3RJNqHmE8BIiVrxvC7QjDJW2c9BwVaWik/245evsv0RgLh9jCBrDIT40zPpZPrJ6CFVVKFQdrx1FFCc/RQS5rHu8MhONcVAXdMIgMioItxlZiCwQzOVV7jqKxBkh9NmNIoi9jtvplHNo+YgykJfmcns5/2/0ljYBhsW2lZVgTikpa5T1m3Yf4GYLoC9JfNkXjqylU4XSmS7qjJ9yNYxN4+58cFeFKUVGUdvsLOuWCSHtIoSRIvQptHXwMx1h5RaATxFMvk5iy0VmZmYMmiSInaUXKkhapvaJaoUzUWqyyYGuG/HhW3ZIgrI3tawRX6BFNuKnP16aKFPdVgpC/PhdDWHQGCCHu7oor7LRrWGYwhE2mpazbV/q8rD21Uf0qZquzolyxXJ8dcJTBgyXBOxvZOz3fAEMOPrNapcWJar9csWlIWLgT1n6HztQFwdac9jPs/ffKSAJJtEIswJRYybRwKCquLHUm32jXtYITIKnAIryRBWlmZVi7E+Z6m7UUIWiQ8SZ6Ti0nrlC4iz0rSu2xJCQdWC3jzOh/6kLXGiRum84qxsevraA9g+yRZpBOLOjVPqpErIHwK+si3NPweyBNkqxXMrUQbchuGGILaaibJkFM2U3K21yTriEPWy/dTil1K2YojUo4ksHlMTYaxtVQVhxKYs1GLiqt1nicAEIEZ36PK9km2nPIizV159ZCbEhkMnmNY4MixBKNDMCqchWNJUN39iiqrTIpDZtx8FavDUcvD8bTFlKv3khT8FEbJfA1ku6azUtsICkeDvDo5lm7CSnHzBLGzRkGbs7cgLv4+D522XJUgB2ZOmKVMPRJHSI8u2w1U9WRdajIz4Zj4sGH9M6t2gtNp5hx5dNUgVtgTJbqIj0w/C5yDWNO2nHA4Cl/Jqls0n23TTqq6qx3Mnrj6YttpbtjoFxG12fQoAACAASURBVJ6v76zNp67St+28vrvXp/CF7Cs/eXFKNRqo6uSAqcae6YkniHncSfWWfX/NInZ7SVUh2ba1i5O0NPGO6fz6BVM46FC7hJSgGKLTfCuuqGpoRSnIxXXjksapulJEQkIWLuObj17OFmsI8vLtJ+FrXrysCkXtlVmHSySv3wUQCtKEn7+iv3LEBKvM3PFCFy4lKIYwdrlPnrMsWc0kS4mYLEl/DWUtakBjLxmEjjQRyjxlJvh2THd0TIGK0IhJtB3z350n8sEcX378UmfAQtVTyJ/ISTL6yEzCTgKe4STUVACd5F5H6K5Vv3CKrpYVKFyDg6ynb96zzfoWbjtBNY3s09cfLt17JoUTSKg2cfIjM16smdx2DXrFxcNakIZkE5gIpBcApZja1KXSej8glMXVj4LYlCkz3h/7Ym2wthCqjYcvEZsPN1bQmlAd+y1ZnEPp3W6dcvmzKN+BYgfbeuH3Sand2mXy2yt4i4FlIW4/KFUk8GHzdqj6U8XAa/efN2f9YfeN9An4DeVI9Whiqedp6dQW9DV048FLpAOyCbYQI1SxZt7Df/NeZl2EgC67GAcxA26wjXtwoZhhdOz7/IcdnnSkL97Ky5TArFM2fy6mgTlwGEoLaVtiSLiaQMnWeYhJ6Zru2bi8ahVE4ezMNGAQKExd5d1h0trhCzylVyi61C8tNoukWnz8+j0FEWefKgj6wGlXuwT7VngqtQgTSvE9V+8+63nqhrgbVFrjsw5Ru4nJ8M/E3qhonP2sEllSPRdnZb2EY4qgzP6wN/M8wbpCfvvx63V7L4gp65rWR2YKjvVkDxsLqruqbbeoWUx6p6xB2fy6HpoEMucpoRtCJ9ld+hIYzEbw2Hh4j+h1xKS56cClEq0mSXcnYjpamgb+R2aIeCVdS4tqRYvncxY3R6WjYwTtVewjG1Rhy5SRESCj8gtlxmUMYQqOkcy6bEFW6NbG/ReEoM5CFu+V1DRHZQC/sBi2KXq3hsOdcd3rKFV/9FpeFSrg31NWRPdtxlqBcOdA9U45rOybDl+2Ye95pb69+xhYqescLGP2ttaz+zak0N4z9SjP3nzoMmGNeIZ5+fZjifbToHKn6FDZr8EqcTaA75TKgaolzsqGLGwyfFnH8avFaEI6gGlXJMWnIO79GlEQkr31WH6vLCA8E91sIFWQwBZ0Qlc3MUQ2zd7wMDalgWp3x/RzRSbbSQrYrJqrc7rkFFCaxT6q/diVOEOQFgEC+PC524XISzP7NpT6kcFihEu4snUBvOmr6AQfi8IdhUeWxC4Rg6bQVnYnlSt1r9/J7H8QQr73lPVKvdUJ/ol5sAhSjKMb5WPDmC5ANynd/0j7lpLpU1Q2pvW8jUcrdJohJuV9jnVwJGAeOM0SMcXUZNM6y0yQGe8//bYBevyKpRKUtofwFLUkXis76n7fG/4npcQpyIcv6quUldrFHKwKbv3mNx++FEYzXSevc649vMmwpdDvUW1RWd9nP9iCiZ4qFbLw3A3iskUCUEnwwmZl57Su7EuIuCk20H0rgziKvjJPBkM1hJj+xJQD2Dr8D0yjq0+BKm7N8RKOXLRLPEAw88b9F2LIH5X+zBwvusrWjjSp6lqxUDbZEV1RjhqBc/27CrdF+jarWDyfiyxBAYg7B500fJjYODUftWKYB21Fh93F5oOX8zUdh6uLIDinf+N0Ug9tzDsEqLVi19nMbsMQTQWxqOv0mZe5zkgfpmpK6PmT75oAhK9W2jnkypxWQJb99+S1h9QUv2jbCWjUMqWVuWj5gTkXIcqyrHaKtAujYyU3Ikcv3yNoVOKV3yex7wxxKaz32J6fBGSxMCquLqQZG6rPavPqV6b6XNqWdghOk2f1piVv2ep4c6r28ngoUdRhiijTecakVTFnytDGtalVTLb6sLbVlWIMXL7zRLYKgD73nivtpUd2rAE3e0oVBTiUu4gBz8DZfOgyVYrXoE7vuTB+p+BUVhwEjCoSZ98HsE75gcl4suz7uaj7+Yu6lW1m5q0FbKKwBxN3GJEDBs3dhps9YuBzhQVXjHPn+VtxVte0zjLT9oOXichy+NwdXdvr0OAnjzh4NdlXFWTpP9TgiOjZ6w+ydcXAdI5JpHovMQLSWIxx3Q8+9zBvCn6KEaw3R0ZHCk2cffnu097TN/D9LNxyHBM9PFCLS4X0e+ZUCxzGXIydUL+mLCUBqsOh+YGzt6TtEsjL9yxjSbYthUDktdwRBqEPvmHNJlkqoRT3TUD7+ElFZkIEZbEHAaEW/Fj6PmMdZ1B9+JXZZ29ZKn30hH0NCgi48SF2QEU6v+fkDZxYkaw4seuED+XGUygtmtt5Vj/1tWdKz3oMe1jSEAT/yau9k1Xs97+Wk+oOWNhsyJLK3d3TVB3ceOgS4SkXy+PcvLorwScJtv9AAQ3RAxFNZda6Qzh9CA0Ph0V8s6oypAhNJFbtOQsx5ZzPQ9c2k6FREBeRNDt63YfPQUu2nSTInseu9Zy+AW67B7SsQoAk8egVS88H5virvczug5vB6T8hSBLX7j7Hokiy4sS+szfFWZLGZcMRGkJNY+2RfTEInffKX+6bDzIHl6QiEu+U64rR9Eu7lctft2x+LXVhqOpSd2TWuiOr9/bAO1mn3/zsDUblbTZesFuA4mdyj7pKdGCev3Zce4hoUoR9Z24rCcF4T6T4gFQskr13E5XpWqhYvjjrTsC0Vd7iKf3E5ftF20158H2HINu0APysttYIaIwVR0B4o2wc+UFN2yp73k31uZaamb/7hsOkytELd2v3nY/sgFaVCRAJ9uU7AVP2mE9MhJ3WzdcAtl9TVh8gFKetO9C6VnGpepMgSBPVisdE4YXMKBR1V/N1KaUADc3tR6+kcAqCLSm2mUoWGwIyHMD8L2emczdZ16opstgUrpnQYeZq78ELdlJF4mytPgugJMcsXyJ3poLZMoiLhLRqhLjbj1my8NB21RduP/GJebbYZuyqa+tHwlm2tHVArvs+l4ULQNwywP0C9nXla7efMSig6NbDlyULZJHiYI/7gCnp+770hwqdcfyPE1Ip2Ucv/LPVH10we/qCWdMnT2aHhwujRWyA4G4Ax4gIABkSEWlmYoz7KQ6JbVLa26ZN5ZDVKXWmtOrafmlbukLuPHrDrvLg2ducEveS4iowZVs6rEWL0f+JgUhD2Bq+cCcUORQc2dkbZO6EwjRq69ROUmQpxMHOetOUTmU7zVC9UIO6UCteuvMUfxQdnCPv9egle3cMa8lpH18Kn5GFFe2BeX1wAWX9fpY5wo5j1xzK9oE5MMzY6yt4gsXsnM8ljawbW6EDMFp/+OxtNmdH9HDd3ouQMPq1qIilVNq9249Vnuz1B8/Z3szhh2XRsBbNRyyjFM+Qt2AbMKVXfWmj87cckwIhUG6d0kl2paeQbz1SPGASMO8pqCdR+kBtv+r7jDVxUT3RI7tidJtHL2do0TjG9Pa5HxU8FEAwyntubxiVM1ovnNNpZr+GPadtpHCwH0bQhVY1aQUV9oeLdpygkJHNmclxy5QuGi3uG1cqDOJSIgIEc1jVnh4ViqDjSXFEeO7Wt2+tXa1isPJesv2HlE9RgCIKm0mXDCkpOJV9/n1RpuAke1f5VX+o/MII1e89eaOq/nTNlalkfheGMe7EFXthgvy/nBnP33i48cAVfJV9mlWgFqmMcspgMgQhkU4tFA+FT2VNqDwjCyvIqf/tv+774wQEV4VbjVhO6bEZFFCEt6f3d1M+mNq1rMW6OSJLymPTEWpykUXDJD52oZdskRjYWbNfKFxYG9Wx5tqJHeF7ukn1IkpuVwTieJwQmODLeNX4drJr/wXJ6iLuFdKX7j4hkiVVhCzkVNjwSuFiCHb5LUauwFMTA4U0zNiv31eRO1fuYRmOQO99zCfm2IXxU/LMu2DLUYZbGhCEPdORSywVpr+//GYXbMeyDc3EpBX7Riz0HDZ/56glu5CeufYgvHBBUzhvy/Gpqw8MnbcDnq4QjNnZbXjyiv0aDl4C54qyjGKMTnuR34cvvgqGDoSIEq8IAhLNaxSVNVXBdIl4W2JMpHGafO3ej09VKM3qlOrosoHaI7gVyZ1ps7ZlmGpdyGLD4O3RR2nf0rkuy9iWIlgge/pzK4fgxBAybtFcTlQplYXABMjioS1KFZQR2VGEWWjFmLYM8QKzx+yNR7pMWgefZ3ipKhfNKasqePf+s3RJpjqj5cni+sKSoTJ3O2atPwx1AkUQK8fVu/SGB5qqve49Nfqe2SY55aGaOHvzoewFMex2thykT4ioul4nrytpYihM/bIQ5Y8u7g9dqZ7Vba0hMGmJ7tCjUbkBLStJW+kxbcOth/Tk2X3SWqn3Jsjlxxb1Q4elRGQhNUvlZcezhxgN60AYbBGBCfHjoYFmGK0LDS3bqShRkZ7cVLhrRhA8j/uQtDjx4s3Ho2oxKNd5s/Y5hNq6Ce2xNSJZaQIyZe8Zm3Dyg68Sxm0TutCme4Wzy2goKDqlCslPCxSaUtZ0zJgxSmUEjm9g74nrjYYt23jgIgEKibvP3u4+dT2FvW0yB1tVDxNCldyZ0y7YehxbfxwnN1TYCFKtCFnMUCMWeU5fdTDaCC+P+u/czcfXbj9Nk8IhfaqkSuHH82dLf/7mY1/mXU20hGuue2b3aFzlfwId2LRCgX/uxmNGJ9KmcFgztq3UGy+0X1NW7h+9aBfb0wlswA9fuJsmmb2TYzKpfAahZ+LyvegDowMoevTy3bU7zzJnSJH2e0BQCLhbDlzCbcz3anURvwnt5syURvpBnvHxbTBoCTmiVerD1bvPLC3M/5cro9ip2uo9Z3HQqWrlfeTsbQe7RNmcU0vHjuYWe556H6AydqVeUXDchMdNik0HLy/beQphTQto+OQoCuwsQt01HrRIyfqE1L3z+E1AQBBUknApSYDSROmCWf6XLQOWJbHlRERk1HrvCwgXk8TOGi4q7jx5M3bRrhnrDlLVcaZ8cH4f+Eyn4OxsNqfUJfJl3nXieojahSmKDjSym6Z2YTg+trOxckya2It5yQU04XZreIca/41pS8LOw4H72r0X2JPApO51ejEPRDA1I4qZauvoAA68drv3sJbYPkKaqTd4kXSlpPhw/cFLeBYtgCcb66KFKiXZAjky5HBKdejCXbFWD5PABu9LYRERUJtio3jL9+XgeTukntOheUA87/xZVTxloy287Vh1Ri32Yl+bRbuHzt/K5ZwWkw/pIUbaZcLqPWfkjwUJGnYIPneeYfePiZcADZvAIXXjioUPnLvDPuKXNgpG7fPojTlfWiQLgaycyMzs0M8bkrDwSGg6bS0t0qZ0wO3m276vukxev/XoVYqCW+m8u2b3TOJgQ8HZ2Wol82w/cpVh1SCu3qpGsU3Yw5uaeJ+9xV6Mzl5/jOAzhRXigGED3GH86r1qAZFwUH7/yZvCOTOJpUAcgjcYsgTx/sQdk6YxvyGoUfYMqdnzGxZW+CDcfOgSXlQpETEEPh0Pze8rDSieyTH5Bu+LjJUxVdLEK8e2tWZ6GxE3JE0bM65IALtKl9mB4WFPXr4Hv6SVKQhmt4xOKeFFEE4FqSIq22/WltnrD53/b7BrHpXtwoA5W89e9X0f9BWuGvGFaJKVqMaMjKAiypIhFe795nVJj0jpVDkoV+8zV0klmCV9yhHtq7eoXoTSr0L0aTJ06f4ztyhqQhY7jAPz+iJQNlU6fN6O2RsOs7UsVBWILGeXDxL7XG41esWmmJlUB18POA89u2Jw23GrLtx8zD7Ro1rHAYdrNqd1kztmTBMze8LiuHKPOarrhJgI3oqZA5u0cysBz9FVentgaReXstN4cAuHtpCaalbr5aHEeTZBdikGO7hV1Qnd6L0Lu5ZS6fAFO9ftPS/YwCnhUHBY1+XNmg7KpOol8lBF4uyFW4+7Td5w+S59ECbGEafhHr1nwzJT+zbQ2/k7rjJ0m7TOS9t9k+QOtlN71sMTF/dBKb3c81Sv6ZtkZWhcdOhUt8SIdjWk3xGc63SZtl7WPTpMVeYPagqPpkotiuG4pz1h+V4lXRE6MLpTjZ6NylOSH2zeV+w+q7pOiBvCq5XPJf30nnXhW1UMp9KwW+83a/MGuaNnClPIYkcxsHnFER1rQViWRRAD+07fOHfLMS1KelILq+yRhf2g1caMvWDLcejOSZFqAkrNy6uHU6xTraUdAYLF2KW7lu44JfvyUHTA/671Sk/pXV+PgDzeZ272nL5J6SWhGkIWM/a4TrXgUFdapAUCI7ZK3edgI8dAxqTapl6pmb0bCocYOEqGOw8GvlCUNold+wZlxnauRTCxihVtPeXuE5XzZYKPhLGR0ZBWVRDlE+mK3WZjYy8uVU1XLZ5rn0cvNtqTV+8bDl4sPegXamE2a1ur6Iy+jcSim5ggFppq3efIblPxvXi792R/g2JSsmmZE3oxXtECLrgmDUUoHDDgPmEkLnBGRUFXAc9ykRGR8LKDwOmQY9AVvCgQ/6MiIp1S/9iaiEmJ0ziGxKGyqsCEKjgPxr8Q7ISgypHf90ff//vNHXlM50Qu5E1js0DGHcfg8Aj84HjaxsYqk5yPV8wIRxb3W7T1xMpdZ274voRaHk8li1OKsgWzNa5QUIm/OHHYPq3rgs1Htx6+dPneC9RCB2BEU7KAi1uZ/C1rFJX9OHM7p+nWsCwwYV4THB6JjoVF4odIBoikEisQwqOrsQn4CeMJGwtzY1MT3GGxtbFCFfIrkDVDyiSJwZOY0YFEOIhExTyayG9SlLEpLvyaWJibWlmYgw6Gg6dml8iqVH6XFA62aAeHhraJLGMooN3IaMQDjoLnCDzTGCpgKdy3GEESt4MwbmISHRmZ7PstUHsbq9Y1isXYCaEGLITCMQ5Uxi9mCDFcj1XEmZqawtsy+o+odqGhYS6xvkwT2yVqVsWVURfNol2qrlOqJGTgJFGjWO74kJmwBuPgwzltco3rPemPbCKnU+qKrtkxoUP7g3cPY4vldlRoZBSYhj/clRO4Db4lwuO2tDQ1N4U8ndFRxcQKB/+X1g47eunexn0Xthy5wrAfhzalQfkCneuXUTUmkB0CAeI4z9O9B1qcs+EQrM6V1l1sMNrXKdmjYVn2bpKQRaK9W8kyBbLOXHcQhw4v/GLMHNOlcMjlkq5SkRxQQitZ47WvV8o1TyZ42cHmWBg+FsW8Lukaly/Yvl5pzC3iJhhpGKZgOzR77aEF24/DHo5gwvsudAxYZfPIxUjOkjF1jRK58KRsElnhU8Lko/HJppObf0ijSEALuH5SxyGtq67YfWYvDr+VLXyxz25UqTAuHQubGTERpXTurOn6Nq+Ir5tMPuFwshc7+8RMp/hyjWO+QEszUwsLcwTdEyJ8WcZKY/mzpuvZpKy0bsykBS/PcnWxNpjJmVErdU9XOG6iwYwPd9zc1x/y2HRU6XYY1JMIyD2sdTWNB5fSbsB/962tOdZ4nXXfePi65FROjI+Ico0q/69TnZK6es8RE8Ht8gurhk7+b9/yXaelO0wsDTAEnNO3cdaMqUgtRFjC+osgnuYmxjFrwffFRVim8ZThZRkICOCR42crLoSsqFEyT81SefAWYCUJwVICjwLRsatJrPNuYU6GZIb9Q+x8bopFJ0+WdELTOElEHEBM/mQlCsdSgOVMEAti3wqoKqzNzC0sTGPCh0RFJVOwryVjQQKv9PmVQ3ceu7rzxLXLt589fOEPYR0qqNwZU5d1zdGmZjG2bRb0CydXDqnRZx4lC2J2WjaiZdz9HqvomcQj+RfSMGr5Ehxqkwirvan28eI9EW7HKE3x2klxTC0cwMUf59rDlGZJLRQYOPg4728dJ9VtMKr8xiK8e3cevYas/+zV+3dfgiLCIhB1J0USO2xdCmRNL55YDdXJT1+CT1y5d/3+C9hjBoVEgGzqJLZZnFKX+182tl2toTpA0cF1Cqzl2Pkw7JOoKrJZHAcgIAkm/GT2MDOwkMX5xUCY7l5/8OL+c78vX3DROxybUnt7m2zpU0EZ+WvuLvzi8erdHN5JnE/B1vatfwAON/FR2NlaO6dNUSx3JhxJwwJVb8pURSiBzt989ODJ2yd+Hz99DoI4AlnEyTEpfJOWzOeiPcw8RVY2C93E7uM+OAJ++/6zrZ01bFpcczjly5ZBi05RluA/BYSfkTV7zp698TgoJATGORVdc1QrllvWtlhXtnCZSVeOcfw/ggMIVS29RGaonvVtUn7WAJmbaIaiz+lwDnAOcA5wDvyNHDCYAP43Dp73+e/lAC6RLRrWHCcy8TGEzd70XYf4aIXT5BzgHOAc4Bz4uzgQL0vO38UC3tu/lAOd65U+tWSglnAKug4Qrt5hHalrLY7POcA5wDnAOZCwOcBlpoT9fBPy6HDh8d6zt3mc00gHCf0T7Axi7gXo+wtQixGhL2Fej3OAc4BzgHPgb+WAyr25v3VYvN8JmgOw8cSdqemrD5ArY7jW0aRK4fKFs6VP4WBnlyiLU0rBlSLURR8DvuLyGi53GBtFG+MaYHR0YFDIu4BA2E17Hb+u5AVe6o8nQXOUD45zgHOAc4BzQJ0D3AZcnUcc44/iAAL0wjPWTlF0J3gr2Te/T9F8mfXo555TN5qPWB7wcxQaqKnCzy3UgxqvwjnAOcA5wDmQgDnAz+YS8MNNmEMbMne7WGDCIBF9Tz+BCXXhnmTV6DYUp9gxmClknuUc4BzgHOAc+Ec4wGWmf+RBJ5BhQsk0f/MxajBKfkcpNKVsxaI5qaLqzADjFDLPcg5wDnAOcA78IxzgMtM/8qATyDAjYj2PU4NBxCUKolMW4cDE+Djp69qwnBjC05wDnAOcA5wDnAPgQJwWG85BzoFfzAEEAIgJBfPzb/vhKz8DdMtt2v9TzO0p/RrCsa9uJDg25wDnAOcA58A/wAF6+fkHhsyH+BdzAGEQSuanbb0R9hhha/Ub1amrD4Ys2EnqIqo23D6RLE9wDnAOcA5wDnAOEA5wmYmwgif+Dg5M71MfgSrFfYUrgSrd3Tfq6LwbbghGzN9ZrussEhcdITb/G91aTJmnOQc4BzgHOAc4BwgHuK8Bwgqe+Gs44HnsWouRK6Qxegtmz9CiWpHSBbPkz5JeNjBnSGjEw+dvT/o8PHzh7t7TN4i0BOcCDcsWWDqqtU0iy7+GC7yjnAOcA5wDnAO/lgNcZvq1/OatGYgDT174D5u3fcuxqxERUVKSCHGfIVWS1Ckc4JrSzMw4PCLyY0Cw/6cvz99+ioqm8RGT3L1vwzhevpP2gUM4BzgHOAc4BxIYB7jMlMAe6L81HD//z+sOXNh+5CrcecsKT0rsMDUxLpozY9USud3K5M+TNZ0SGodzDnAOcA5wDnAOEA5wmYmwgif+Yg4EBYf53H925d5zRER58/bTU7+Pbz9+Dg2NiIiMjI42sre1Tm6fKHXyJFnSJ8+WIXX+HBkKZMtgY23xFw+Yd51zgHOAc4Bz4JdzgMtMv5zlvEHOAc4BzgHOAc4BzoG/kAP83txf+NB4lzkHOAc4BzgHOAc4B345B7jM9MtZzhvkHOAc4BzgHOAc4Bz4CznAZaa/8KHxLnMOcA5wDnAOcA5wDvxyDnCZ6ZeznDfIOcA5wDnwN3PgQ0DQszcf/uYR8L5zDujJATM96/FqnAOcA5wDnAP/GAcu3noyYqHnsUv3wiIiHZPbD2heqU/zCiYm8bv3/vj566YDFxmcds2dCf5sGQi8iHPAUBzgMpOhOMnpcA5wDnAOJGQO3Lj/olSHGaHh4cIgX/sH9Hffev+536JhzeN12KFh4av3nLv39O2Hz0GyDY3uVJPLTLKc4UCDcyB+9wcG7y4nyDnAOcA5wDlgcA7cePDi9bsANtmRi3cRgYlgLt1xKr7P6VIntz/z3+BnuycXz5WJtCtOhIV8E+PEQJ7mHIgPDnCZKT64ymlyDnAOcA78NRwIDY+oP2ix+4ZD7B6fuHJfioBgRIjeKIUbHIJYkMM61pAlGxwaJgvnQM4Bg3OAy0wGZyknyDnAOcA58DdxYOjcHQ+e+5mqmSUpiSbGxsa/ZrS5nNPINhQcHikL50DOAYNzgMtMBmcpJ8g5wDnAOfDXcOD+k7cLthzX0t2CWdJL0SAulcqfWQqPD0hye1tZspGREbJwDuQcMDgHuMxkcJZygpwDnAOcA38HB4K+hjYcskSwUoqMimJ3umfT8lKE9nVKZk6fUgqPD4iFpfylpdAIrmeKD35zmjIc4DKTDFM4iHOAc4Bz4F/gwAD3rdd9XwgjNVU7YmtS1RU31MzMvq0a0DB1rld6wdBmv4xRZibyh4AREdG/rA+8oX+cA/Ji+z/OFD58zgHOAc6BBM+BCcv2LNp24scwTdW30GM61erWoOz5m4+iIqP/lytjmpQOP6rHf0rREVS0ioYs/rvGW/hXOMBlpn/lSfNxcg5wDnAOEA4cPX9nzJJdJIuEqg24gJwyqV2t0vnEFX9lGlquiAhaQgqP5HqmX/kQ/um21DcW/zR7+OA5BzgHOAcSHAe2Hr5crc/8yKifRA0ThZOvP2r0xkYyx3Pwd/BHdZJ3JgFzgOuZEvDD/YeG9sY/4ObDl0/fwFFwiJW5ebpUDoVzZHRMYW9YFsAP8qW7zz5+DrJPZJXbJe3/cmUyMZWZwbU0GhAUfPDc7esPXn4OCk6e2CZftvTl/5fDxtpCS10tOL7P/C7feeL3KSg8PMIxmX2xPM4Z0yXXUlGM8+7956NXHjx4/vbdxy9QQiS1t8ntnKZk/izJHGzEaLqmwyMjj128d/X201cfP9tYW+bOlKaia/YUyRLrSgf4cCx06+GrB8/8/D5+MY6KTmZvkyVj6gJZ05t+t7nRThOv0IFzt+8/84NVTybHZKUKZMnilEqojlaWbj3RpJprcgf5e1uqrfj5fz7l4/vy7cdoE+NMaUA8q4OdtWotWYTIiKir95/73H326JU/LLgjo6NSJU2cNaNj2UJZoQGSrUIBoV4aqBVYrwAAIABJREFUt2T3T+JSLEbUzyIUVcsg2ccv/S/cfITn5f85KDQsIllim/SOSUvmc8mVWd6JgMZGo+Oh5zh8vPfsDS4VvvIPiAiPsLGxypI+ZaFcToksDfaRktEhEM2eEz7nbz7GV1a7dL4ieZ1JkWwCs8fxS/fuPn0LV+wQIhPbWmG2K5kvc9pUSWTxOdCAHOAyE83M6r09/N4HUtBoo+jIyCijmE/TxM7KPHky+/mDmuAFXbT1+MItx0zMTEJCI8IiIjCdYesWFRWFc3ds2izMzGyszIyMTSoWyTGjTwOBZp1+85+88jcxM42MtVs0NTOOiogsWzBb06qu3adtpNpFNsooCpjGRlGoYmdtVbKAy8RudQCv0mW235fAyMhoTOigEBqJ+7ZRcJSCVdzEyNjKyhyiA7qyZHhL4QvEet9k+DJLS7PoaIwFU7exqalJcEj4/CFND5277X3uDtU0hoyhABNwS3OzFEltB7SoXP5/2S/ceNR23GrQCQ2NQNMYNBkyGjY3M0W7FhamKe1svRf1FWhijt584LK1lTmU6iAL7TrmI5tEFqeXD6Ya1TWL/s9ad3Cl12nfl/7SuhAUWtcq1s6thLmpqbQUEBxPdJq8Hs/I1MwsZhh4uqZGJsYmFjE8NAHnezQq37xGUWBu3H9h9NLd95++FdNJ42DbsVHZgS2r6CTrQJoZv3zvpgOXKJfKDlYWLWsXH9mxVookMgvz+euPOk5aa2qKtwX/i8azAxvRTTNhaNGRGyZ2EqSiLYcuT1y228f3lbirGNSQ1pXHd62jUcjbe/rG7NUHD1++J11ZQapo3owNKhRK7WCH1ywsPCIoJDwoJOxrSIxfQRsL826NyyrZnSC268x1BxduOf7xy1eqe7XL5B3fxS23i9a189Q137FLd524/ADrjZgU0ngubhUL9WtW0SWDpvtcWMiHz92+8dBlarCFsjsNal2ldAGX/rM3r/e+lN05dcUiOYW28K25tpmMISeysoj54iO/vTn4rCxMYt6czOlTrZ3QHsi3H70e7rHd6/RNsS4Ez65OmQLjutTKkcmR6jwji3dg4fYTnseufQoMlqLhudQqnXdi19q5XNJKSwUIvrse0zcs3HpcFmHqyv14eZLZWkcaGYdGhGOi6FK/DKy8W49eCcFUtooAPLlsIL5uBgI8jC/afmLjgYvUF0Sq5HNJM6RNNdiYE4hSAhOItEgGJEXSDHn43G/kol17Tl3HBoyqhMftVjpvt4ZlSxbIQhWJs1NXea/wOo1pgUy2+O7wteLdAFrKFPY7ZnQl+HigvWZsIr7UJ63cP6Gr2/D21QmCOAG5asrK/btO+FA6QgEnr0u6JlUKp00JgdwyLCIK7yf+gkJCIQ3jw8RUhm2PmBpP68EBYzxUPaol4CpHLt7tP2fLtXsvZMeIiWlo26oFs6WvUy4/FoYnL/xnrjuwzPN0SJi8g5CKhWKEIUgtZCN1xsf3yMV7E5bvE5ZMUxPjXk0qNK5YqGAup6n/7Z+22vvL11DZprNlTAXry3IFs+bJmg4IXsevTV9zECuHLDKAw9tWgwu42mXzCys6tqSHzt9ZvPPEvtO3hCou6VJ2bVC6dc3iUJwMmLPF88R1JVLNq7pitahbPr+9jfWXwBD3jYcXbTr68uMXWfwsjsl6t6yc09mxXOFsAsKdx6/PXPUdscTrjf9nAYIVt3HlQvhXloJG4JNX7+sOXCB+UuB27fIF3vh9XLTjFAlNldUp1aKhzUlnxMSxhO88etXr2DXPUzfEcJKe0at+r+YV2o9btWbPeQKkEhlSJ902rUvhnE4UXDY7bcW+kUt2Ccu8pbn5iPbVKhXNCYXT6MW7hTUVmowd07tIZ+Sg4LCNBy7M3XCYEoZIKzc3jcY71nfWZvf1h5U+6aZVXNdPjFnIGT/EQ203btXOY9cIDt55TMTlC2bFUu2++cjzNx9JkWwi9NwCCzMZIdXz6LVuE9e8+vRtQ9LBrXjrWiUevXzXZ8ZmQYSCwO0xsEmX+qVlyRIg5JVpa7yHz99Jhpk6eeKmlV0zpU3udeTqocv3BExQ69Wk/MTudSDxk7rSxKmrD9z6LyRvC6JzFCvggsBm+8/c8v/eVaHWPveeVUvkJhSwbh25dG/ZjlOBwTIfbIHs6a+sHQHJuM2Y/5QmB/RwSve6/VpWIjSVEviCes3YeOh8jLttyNZlC2c3NjMJDgu/fv8FtCDiWtaW5rP7N4KgIwYK6Ucv3jUYsvjq3efSIiUIbsnB6PvY5XsHz9xauecc1RapFXhyrtK2Ae/t6MVe8zYdE6a7EvlcMqSw/xQc8vb9lyt3nxEKQqJF9SILBze3tbGk4OKsmWsXqbhQp2x+sRQixtc1vePIlRaj/hM2AKgLIalhxUKl8mY+cvnuBu9L5JWrX6HAwkHNlJSj1+89v3Tn6chFXrIcc06X/OHOiULHhnhsm7r6ANVJfHF3tozJmvGbmlMoxQa178zN2KWTPgDuVjJPlRJ5oLhdtvPUDd+XFB0qK0wRFJBndeUAl5lkOIbdWNXusw9e+jb5ijHsEll+PuEhhiCNWN9F20wV7yMJwvIRLdvVKUmyJIG9wtB5O5Ad16nWyE41CRyTY76m48MlW2cg9G5afk7/xgRTSPScun6egj+6yAsLpdt9DC1X4zF3n7zBXHB17QjxZzl83g5scSj6QvbmxlHU5hXSRp7GY2VnhHa1ii0f3UZKB4tTqY4zAK9cNKf3vN5SBJ0gmMer9pgrVtUsG9aifb1SAhGcs/yv1eQXft9Wd8xBk3rUGdy6ilITncevWeJ5Slo6pWe9i7cfbzt8FRSc0yaH6k1WoWVrbXlm+SBBlpUSESBY6VuOWLbh0GUhC6ni8MK+RDYavXjXuKW7hSIsewfm9SZFYoIQaHLXG0nEDnHR0cX9IHATgVhcJE5DKOnZuJwYIk6Db2W7zLz35Ic6DUePO2d2rV0mv4CGM5V8LcYT2Vdcl6RlZaZZaw7iWjuZ7j36NerZrIJQ5cDZW1V6/vim3Ac0hqxDqFEJLA/Vu7kTwQilRXM57V/QF9K8gDnMY/vk1d6kVv5s6fa590LAMgIRJ6BRKNhiIlEniD8xLFELNh8btciLiER4KBBwxdWRxharQtfZFBBZyExDWldrOmwZpgWcneHQ8OELf/HrSqowlAoCzkbvi5Big0NjQqphV7BuckdyBoczmlajVngdp3c7fZpVmN2vEWlCSCzefmLO+sOQIF+++0SJgwICJjfnNMnEtTrXL9u1YRkB8vT1h8xuw6TyCkqVZCZsKav09hB0SzjP3Tm9q/it9th4pM+MTeSVEFrJmznN6RVDGGKTSeHOVBVUrFs2/3aR5kYgpce//WZsmr3xCKmIB3dq2UCirdx88HLjoUtIKSR1r5ndcXmQQKgEVPJF2k6lgMgSmUlWYBLwFwxuRjgPCETPaj09Tl57IKY2q1/Dvs0qCpCvoWHF20z1eSC/1RdwuMwk5p7e6RhVIf9RHIAedd3EDli6KDiyUAIFBtHbSnw20IpLkQHx/yCvjMnl7IhSfJMDW1cVV4Sufmav+mIISfvJRdAc3r6G7J4etd5/pE8YAcTQsmdMjQR282KBCZCJPepCtYuE9IdJlgJCx4uzDwooZP0/yLSLopyxcQ+wBs/s01C2onYg7GxaDFkqXoEqFclJBCbQwRo5vfcPNmLdGjJ3+9z1h5WaqFu+gGzR8p2nIDCVyp/loeeEBzvHP/CceGHVUEfJAoxltfGwZdJDIjHNzpPWEIEJ8O6NyonXj0GtqiS2sRLwsTrW7rcAhhTi6kI6SeJEFUrkksIBAUMgMEFE2DmjKyZHyEY4AJJiQjKD2CGFAwIpoVpvD7HABKBb2fxEYEI2ZfLEA1tUpqpXLJK9d6Ny5M8MB5s//1bsONVfJDAVze1MBCYgVi6Wq2R+F1ID6yj2+iRLJYZ4bBcLTChdMqIVEZiQndC9LjR/pBbUkKU6zMDROYGIE10nriUCE+Aj2v8IZwbZom/zigfn9cbuQqgS+JU+qQEcp9UOtt/ENTHlV34BHSestre18prV7c2B6be2jHntPQ3qEDGOkIYaBoduUrgAgUDZfMQKQWACZFi7akRgQhYDXz++g72kA/M2H4XtFEUTyqc7W8de2zBy7sAmVJGQxW24axtHi//Ey7aTY9JMaVLIVpQFQr6H/E0O4xpWKCR+4VEFknGTioWoutcfvlq15ywFFGelApO4NC7pTd4XxAITSE3qXocITMg2qlTI7fvmAVnsHCp0nfXg5/N6cQdc8zhDrhJDxGm85FINE0EICfsp6nCzEUspgSmPS1oiMKEWrKwmdqlNqgsJbCfIV4lECgUv6lQtnmVzgJ7d2Nj/TimUrm1qFZcd7+GLd6Twbg1klOFAO+3zUIoMyJ0nb/Bvx7olrSSebdvVLZXELpG01onL96GroOAQDurLTcRAg80phSxk7zx5jUTPhjLKhiEKmpiDF2SG3NathOyqfPpWjO8WadN3Y9utWDibdpsVKREB0nrcSupksHX1IhRy/YoFiRQiFA1f5KlklpFewXYSQbiwKdzn0TPj9/035GPPmd0g+VE/cHWagpYOmCs8Ty/3OiOugkcvzuJoo0ax/7d3FXBVJl3ftRBr7cS1Y+3uxFrFWFtRsTFX3VVX13ax11q7xQC7C7sxsQsbu1BWTKzvDyPD3Jkzlwv4vt+7Mvw2zpw5E8+5T5w5GSYMwVbVqO9MUrjJkCKJOJDDYAgkj8Pz/4CUAyMdlEldG1XkvRyAggH+17wpAv2nrhUNnayrsWI/bVGzpDgKMJRPgzvWnvR7U/aP5DIFR7oulo567euVkWZoIqyCW8dliDsMrxINmjuPXpzosVPEF8jukC+7g4jB6i0td3jt7uP+U1aLNAz2ueRH6pJFypIFso4NPcNACBC7OJwxDeF4C+te4Ku3q0e78rB8yLvLRnXAp44PZAA0N53HekJglfBo4njWapi7qMCes/aARIbKtaUUl2E4Dk5ZHqYvkYbomsnCc0tP8T0hHepm6zl+BWIyeK+n1zG4B/AmAyqXkvV2wE/w3CGRhdv8LsoRf3An6jjKU1wIZ9Em1YqJGMBt65QSMThCtx++WH0tcxr1fMW6YCeFBRAw3lHkoTev4BSPHFqqKrGRY2G+CgNqlM2fLLGFu9KtR8+7O1fmDyYOPNIQ04wEB4zMpGUa9CiwyKjd0yhbWI6Mwcob9W/r0Yv+Aa9U/Kb954BsXkP+0gOJz2eXhhXUIfgorqLO31lDo3ukISu3n5AwaMIBGYqE0gXoKKqG1Yo4pCI+AAs2eqsndaia4GuoLoHr3XH0gorffCD4kpvUCN/NUx0rYuCmqlqgSuTLItIAht93ibwWSLzgXEculshY0z5UlyD1QjZyH9wanyURD7EJcomIYfBfi7eTqqYnz1/2mrhSpM+YJpnq/FuheC6RBgfuVdu/GPJEvL29xWZ4V4Y0SdeN6yKK4AjA4b0i4KP4kaD3xEU/SRxhQ1Q/Leg5IEeKE2KrbUI+ACKSw51GLBE1gsDXLJ2P9zKgQtEcIgZ6u/GLt4kYwPgydRzlIQnjJZXfHZQVCmeXxkJ/cEQ5vew6fFEiGzZrg4RBs2vjikV/zAhAJzORCmnQd2xQvlKJH8UJobsSVVm8Cz5GXgfP8yYH3Dd7S2ZQqCrX7DrJCRggfSkZcin1+EsDpSZiGCVMpJv3Hwcs2XJUHA59XocRS0QM4BSJE0oYNG/cfQpvBxUPDMJrSHzUkXAE/MfSsx6BsaqTFoJGpbX2n7o6bdVeCcmbdlSa0Hev8CJaApcpOGY83z3pntdYRBvwIQDKF8rOrcAwl0tvD0aJCD5xCGCcFqSnFTdP/d7TyaOXNNY0becAIRPYPvjbpoRWtqrlK49d746jFxELI137/lNXJAxrwjPJc9sxqQtn6IOnrxbO9QMzk0m9aCJchRTX/l5KWJcknS2fbc2+s/A64k0GLN4a/CJzrk7IasBDzugY6hIkDoQY5Ln1iIgBjKMS6c+EroWbDkvEeNkt8ToGr+cGjrI2XqIMt4mgMJUGEcsqMrciTXqfubGHclPTRUI0r1minPIBxkJNqhZVl8NXYffRSyp+4uLtUqBT6byZVbLcmdJKSHfKSBE3bmyJjDVn9GsupQDIkSE1SXnz/lMVDzWAJI4wmgxpkqvEORXGbjh07gzlXIyYIO8LN8UZ0qdMouaAyJEpjXTDe3gdl47vi7YcwddUnApwFsEMx7uy/0Bc+OgFWzkBA87euC9h4BoIjxZpXdBM6d0E0vMLytcbvYryN3hW/Baju9cPhiz/apfLT8pYq/fKkhDGHb/gZzk6uDXMMhElMPHixFLJ1GdfpZEwsWPTtxYnC6L0x7xXBHwu+4nqMda1dNsxeFKKZLqUEIhKEck4rEvDFF7RFz4BDZy7enft7lNSHw42EgZNHBTVfBNjF25T7xk2luQYTr+7jl2GdwQ8WSHoYEIEHg7uUAvHHnhGOlcvumFSV7702j2nuUM6RwLISD2Y6hsPISPr9pwWBxo4ihwwMpM1BrapQ5vn5q7ZLw3z3HocGLxY1b+FG2UBAmGo+D61oJRMbLhDmqTwEVGnOnzuBh5vEQ+vBYRbk+vicL9ih4WqCYLLgo2HYFBrUo345LNpXWqVkr5eDD99lXLJXsGyILn02r2n4Z0q7hMhe9B+O5XLG+m0NGw2uHeogWP4PpGxUcmpbDpz1h4UN8ZgUj+EroIaBy/HIjnVSYBZZslwYGBzmanYUzI7pFSHq2p8BEWqZ0R7zYctVVJZ56e6ubBFAykbEy86Jm4Mrjyi4op3pUpKKPkPniXM0NOX7eGjGJCVunb8fEkt7T6wTiILkTh2kgdhskmVkrBUpqR+942HLkD5IU747j3h1wWNVLkOf8F5WaSEha5O+fy6DzMSjIjEDIZPlehlxQkQk1+W0o3hw6aqcpOGurjx4QD8FEelt9SFQFen+5CLs4mwHRXtKBIE51ux7Y+8dgx9YLl53Q6fB1q8PWxbM/JUkzx3qgcGB01ZGFVmgrun16FgJbr6pwqOjAZP1p+d6nJ63BXDOta+vWl04IHJHiM6iNzTuXUjqoAP50CKZMSD6U09mHyIASLKASMzWeMYEgqQrkUrtlkcguGSvPPYRbjfkj6eOHIhGo4vA8HFfZM35BJSV8HJ2mi8qXDa5jQAPLYFqwcGtnciXYsWbrIghuCCQPEqxX9UH3s+J971jsUtDCWsS7oKIKGywpP/R+uf+FgOILh69Q4Lu5L7+kPobVa9GKeJHLBSMUxgnmSJiNcH8N8njq+ughBxVRBBWi2V0goGngFIAqQS7DwkW1i2eZ+XchFhFGlMUdUPOF9evh5253xZjtL2o+udpdMoMLHi0E/3a+oTSxqeuPvzl6VD/6duFT2qbgDPxY4Tl0MHffk/RAkJw5rqWicu3uKU8IiHBZA3OZD8e+Inhi0VYfychgH4eq3Za6FLSK/JoomTSYHmbkgAIc4w448WLX4qIWI4jHxZHLYFyJ1ddmnCKBiOD1tGRQHpXKO4eibBe0ZeRaN+kbSb8iilHa5XkO15aZBTIBviTC3/8KP8KLjpoPOjxtYW8JJ2HUP+Ocspv7S+i0Hf6iSxhITctnbvGQmJZhJL3yBOQH8RFDUVpyeB6iVzk2nYVOIXGlbYU/lvyQfz2T80M9W1DMYWDkT+VrNl9n87DV69TanPPJSrXkcu8KtDFhY4ciKKAe84jhSBxYKqad9xXwgujoWzWy9v+XPFQqSewHPrMdGoD6cBkPVr8xMkIXFFBh85f0MMv1q4yRt4F82rnw9v60Rr1zwEBwW4vyAiBvlUEP9FvsbmC5ccEPhm9d7T8HasVZb2sOFLhwtsEfIGceLEoXHmHMOAhJSXEs7fx8/flCjfUckdJBqpmSk9oSvCjSHKxxhCOlyTH6cXVFgW/JeldZE1UcLompovaQxkTFCHJIhnpyIjhFGzEO32uaIe35GWk5wWeb8k/PV7Tzhm7T7avpCI0sRgFPnxgEGETwgA2iOxKcIws9bsOaWD20Iekw97ohhCJRIjnazYDBfOpok+23PqqjQWgVfT+jrDos3xMBjNG+jCmwDwNkAguojh8McI3tU6iYRPaDsAoxuC/8UARng6zx3YUkr68ELxCmdLkMlW0CWFF/D9xKHvKd5vDdh/8op6qsGAJJq3SnxKWEHKCWtrKH3It6LgaITqU8XoqIeYnuH9+/d0h8FGigPhGLAjNec3NahVrVJk2lyPLUecyn5xZfXwOgKBoFHlonjpABCjlxkv3LccQQg0e+A9tx8DsmlNWrrivINNBKGtqiEJLkR4Plk+4gvX7iGPGUKIEWgKSQhZ+PhwDkBOQhIBNPFi3bLvLE7zyHLJe0mgbuVCiUbb4eAr9UKxNLzrzwzp4RXsF9W+bllIfgiFU+OPDp25Bn9z9plZs/skjF8ta5YgDT3SKlaawR5UlmkGGbGqomB4ZE8n/05cul26QDaxC8nMxaYtMJL5kmSXbjwQ/bvPU4nmFm70VpORBlL2iPuhWUDJtUSkWiyMtBkFD6EiG5AxVXWMIx0pMAEyC4tLMziZEuxJJtmDS1n93jPU4apSBMmjOdmRczc4LAK6n578/EtJFOtULJA+aSKIueKEHEbo2dz13vuO+a78q3OBXBk4XgXUkrEqjYhJrblzLt4kFGmI9odZ0OvQ+YcBgTl+SF2nQgFuhkZU3Zx1B6au3KO6ebHlPmi0OCRzMETn1Sdu3nYY8Yy+q902HTxzw+/x90kSOJXOB5cDPhzq3snLd7MsnRwZBtjsOBU2JLKQ93n61tLGhVBvFaSCe/wsUEwDYX07cDC3TsB7s/2QhsMi8PZdUAwlzvE15XKXOCGhixWnMnCEOGBkpnDYVSJvZnxOpKQ1GLNu3xm47MDwDEXOkQt+7eqUZtUDGlcpjFetNCmqAm0/cgFJhCE6rNp1Ckeu+pUKSzRqs3WtUqrMBDL3jYeZzMQUP1D2AFmnUiEkCA4IqV8hTrVw8xG3LnWR3BIvKfQ2q1ZUigITiRkMCaxJ1SLqVcAhCQ7USKiNVAJLvY4jvzbL59a0RglVZsJU7psOD+8SbLNfGiImqoG76tLWMdfvhikeREo7O9kQI/aqMHJPS0iy8KdEIzWTU4Y/0Nx64C9S+imprdALMxNpaRIHMviVZSwPkMEVXqi/2Io16sN7Qp+EoardCkhE3CCVsDQxZCZUp1HLYgT+Q7ib5Mwsv9wfPHkuTYgmngW4u6l4FfNK0DzdVPRtjN4+bpgORpyB+q7FuPsoAA8gD+3GfT6yZwMUBhEHSvDVB/4V249dM6FrJcuoRoksQs0UinDJht+694ycBzWaxNxjoIEhFbn4Jy/dDQUJMgBBncMrb4gz6GSmOBrzLoQmcXjUYZyRpFz/0IohM+TIBVshT8M/AfFiMPqrC73XSHugxC/7dXd5446symX7QQEodWNWMLfuPbFdZsrhkMrKVGJX8ZCYTRHDYP+Al5LSDnh/y5JEjDJvROrzqAsZjMQBIzNJDCGarZxK9Z+2TupAljnIDYh9WLjlMLqcQx26W9YspUobIFi0+TBkJrgK4jyNxGhI1iJNqDahC0F5E9U6s2bPKYhrqCi0aOtRFCph+QChwq1TuQhWkeaBfyJMEohcXRYSvte8ejj6LTbcxak0eRXwXofM5HXkPNLPdGtckREjW123sUt52j2+gcXQrnWpG1zn9bgvsndWLkZYDzmxLcCzf16SZCjlROJjaE6rCP6n6SOCTaixCklJaF4qJauwCMracI1dRNYModW4XtkLFhw2J4oFkpPHpcKsGjoW6TNplapcvOr3MH9OWcty44GFizRWgS2sQqEc0nIvXhM2I2Sy3jHrN4ky3CaKDZM0qK9I4j9QXIJLU0DAKzFLjYtTqZMX/P5esYechCFx0oCdbuWYjrXK5SfJIipwx9fcOS/fviXnF5EQYaes2D16gRczJ1UunmupW7vek9eoDz5Goe6kOJbD4fp6c8qvC0Bb1nfKWhZtAFFv6Yj2SGGF9K3EKvTGgwmhTyVykUchP5O/ElzM9hMLtSepv+80b5VHGoWlOgeExRRKxIZKxjDlC+eAZ5hafuCS30OpNgPoyaxmVagkWLrlDD5cDtBvnHCHRSuCljVKko/w4g3eODZBMkCMKIqKM56UL5IDcozKH5ytoUuHighdzTVuT+qoVk6E2ymkE5RTgEM35KGmIRVk2cBWtUqqMwCzZOsx6I03e59HfFm1snlJGgmJAHvyKlbvOgm/kyUbD4MhPLlUooTx6lUqJM2AJs6+yMMJix7ecShYpvNFUAfqMGSqTBCTSVCAf6vx5whSnKB11grdToBHBXKyV3Y3ovZwl1I+kbOpyA8aZUAcTQ4CdQZ7ihL3hueI9irxISVFNeT1C0JMAxvi1rGOWu8i6APhSOEXWtBGXcsKJiYlA4Fe5x2FutXkbG+U1JHI+NfXpRpJzJFw1arfZybqFnNMVADtnaMRcfhayMyUq+HgvpPXMIEJDpQo56IreYZRKOTMx4oAatWJTQ7rbi1OEGkAyvhqXf+u0WMKE5iQ7wqFmypqgk+xypfK09R6pC8gRWgzDnXDqb84GjnsDfVEY4L3ylsFSPLFkjiBne0vQ3iGrR3fVQ3xgY1b3TUq+EpI1/rldBltJErTtJED9MNj4+BoQhYc+V80p3qxSDwzbskOOHS71CgpVnZrVquUSozXLjwPNh48i6JOtcvZ6grdvKZWXJsVEsHuIqQ8htwmOl3yPazbewq1FOB10cCxMDIwcbx1oImSWRv0ENfghbBq7+lyhbKjJCqfAWZEDouA57bjSGILjLMNFcvFgSQMXzESr3OLDvpA5FbGDPbxvoJ6VRfyY28XV9wkmSfQl/JcEUdZgT9rXvHxNFYqdSpdGh7oUVoqMvoSL4vQS8wG9ap00P/DpXovSuz7BGM+AAAgAElEQVRIaE/8XjcfPIWyRN2VdUx8pTwIo0eteHKgzomY9H8a3b3BzP7NRVdrdU5M2M5tEap6qV2ylKxSWGJ0d44Vbz+4otfrPaNB31ncBgcNLsqNia8dy0WCWzqZSXeraKRxdeKIYVAGMX8zN6S1Y8NQiWjvrF6qXUmcNLbmQAIaUqsX0Z9AXCu+xtdbx9tPlGyECclbi7w/yXeCuCUJRuGEwW2dpHP7qt0+UoaUPUcvwfAtjoVhdFb/FiLGwFHnAP3Gifq839gMzk60TIByE7hSZD4Ur7eNUynp/ma9A6evg+BSr1JhKy9HcR7AkEvUzLPAHzp/E9kCS+XLIsby4CF3EdROfCr4pI+cvwVNGw1zbCAsknwGEUB5LHw/XCx1WrARkAnE5647gPIjSMlTPE9mcZLIwQ6piSxzmOrdZ9oIpeqT2LoOyZNIG4jEOzdQ8TT6Mnlqi8kTUsHwPr531WQ80pZ0zSCNxQ0lGHRDJLw9ZZtjNIuGtYX0ICbownF2nlC9GG74bjPWixP+2tRxJJW8ETRkLQ48Aqd8/cQZbIEzaYrbkC47iB4n8+LAkSu5JoAcgRSH5veBi56VzSCr8uLNsgRphV7XFWiZuoyTZdTc3ij4U6TFiHWCExiUBwPa1uQDdYBOoZXAUqznw7+uDzimhXAMUQ+KMZ4IHq+C9RO6hOtSaUUNQ75aybAGfl3WAd2t9Z5Ku4WpXlPaU+DTJv9eXYhUgZOKXnWsiEH2y01/dxOjQXFWHzZzA6dB2uGufy3nTQBIfLP4z7YixsBfhQNGZrKJjY0qFyaPEThwow6iGCeF6TI50IIOO523sNkwx3bW2lI64dvFbMg/yZsM0Ak6IIYBEXZDid5KE9IYaqmqBJgKj27jykXFrmBxzVJwZL3skrkVTxwSCThX1rSk/7JONgoKKQWvLqTW/CJV6OpAEWO9FDGnzJo+FYc5AKGTLC/DCawAHxTrEiOOG8dWmSmm4i0uLgfp4dSS/jihxgq1TbgO93AeMG/Ugq2/jPEs1Hw4D12EyL5n1m8TejcRh4twlgzEtYOAVdERKcOF8+aQfarYEDKc/q2GRXmyprXyMS4Cg5HnQHgoWtkM6vaovRG1Fj3RFLHOQ/nqIr6ybLuxXL2E1ZH7dMKvjdVtqJiI65loK5U6sy0YOKo7dpoginoYNfMPZ1tcOePo9UzkFslM6LZsEjT5cyj5rkJGftDok8jTDmxnyGWvrvgpEqcxdZYQTM0y+S6sGBpcojT0dDTS3atmj8kj5m/pPWlV3qZDWSFR0P6YKe3KMa5rx3W2/XCuWdOgCQ4YmYlgiorCwai+I+GyA8rmlD6mVW3atQiFI6CSUee3gmlQtQh/SEQymBLUrJgQdFBLTiTjsFS4lOOtAK1qyzIZI65XsQB8mKSBLRUBjhO0orRfvJcDKPW6apfPlOV7EFlDVn5AlHUFyxwBbOxrTX6aF29op9pyhSMgO/LtSYDfI4v4ONYLwTp35nQiJb7TYpPDS0OyqPOm7QCZ9BnDbbe6qlkJpNXh9L18ZIehrrUZHjobVL1AGARKi0BnCc+n9j+XPb6ov/eCvlZcUjA2bxYLVvBVVm47LuYY43grgO6peUUFV7+i/O4xeSVLL3WEAnQYvlhcFJF0M/5ovvnvbmTCUlBeunJXpGdwRD+Ltx4Sdw6mKpI7kzQ5tHpOPaZIWRja1i6ty9kjDY+l2ZldPDrYMK7NhntpIbLZuM9M5IcTu7JnSMUCfkUkDWt2DmLS6mrF2nXW9w68SKet2IsULaRDpGPRXKTu6qUSg8y2+lJJwgJ88TyZ1PBS4EnT8SdyPTa71f/C7DB7QEukV+XuTai8OXD6+vFLdkAJirorCIvePf3Xi6uGSuGKVmc1nRHjgK1n04jN+i1St3UqJVWdxFVC7dGsWnH1cqGG+WXsMjWUrFXNEjozuToJwyCdQf1KBT23nZAIapfPT57YEApEuge2pmQ7aU6pCZms57gVXK/OexEbyGEOwNMQKjekXeAYBiCsLwtVLkMi23PsstOvUznHkDdhcJe68HKVyJDXaqePr4REzkwJw5okvkB2BzFPDKOMFZ77rTQ/Xr6+t4kQ5QpFsksltFBlZViMTdJwNFfs9BnWsU52q8YgePrDWoS6hOLwDxonLVVV9lnz4YHhSpxQhff6+HYa5QG/XbdOdTo2qAB7FkSTJwGBCAlEtKDox6aOFTEI/MQDon7kEMC/fNuJZlYVrsfOISNEQL3Q4u0I/CRzKUnyBFv9mSZ1Mmq9idt78Pj5vHUHf2lUUQoMxIH+xNLBcPqWPvkYG6gkWxcntBG+fOuRSgl7aEXFaXLg1LVqsjfpflCn4piYGh9wnuGJUzIgtt5oywg0N5Q0TXATCjn1OS2qCIXEyBBUbM3OUYmIHGJnR0iBIIY7xLjFO/gQPE0ebu2kQraIo6xcIpeaKeoFFbePqQIovM5FNSoJyvm2OYCEfO2HL8FtCWXwoHY106ZI8uZd0JOAl/ATiGcXJ6tDKitqVD6JAaLIAaNnspWBFYrlVF128HrFsVudIjiUrCLh6E0qpdThEgZikIRB00Vx12U0jasUVb1Zy+TNbP3zrM4PDGQySGZSF4KEq5XMIyFZk7w6eHeRxCISNY9FgQldCPD+bcJKuK6LZICb/1RSZfiDpwESGWveo/IDta9ThiSOEPKh/z9q2mvMgCwS0jylCmbFx15CogmrZe8JK1U8x8Cjs8Wgeap5MSiI/myonj06fdJ7zYeHLT1m4TbHjhOQkOy3FlVRkwcVHvAixv0MwTdfDgfbBSbMBnVITU2+4z+mrSUlWrYHFIar0WPqrQdh+YqQVKktZTUjq0Q/sKwrx+ZEHGiFohYqXsTQQXj8iypjh6zfu2b9ijMAG8v/m4byWSG9kvkQFbh5T87UAJqyBbOqVWU2Hyay1D5WYto/x/ikrgKMLnmV6BYjDtTZ8jiNjkB1nCLrr/n7v+BTMUDnQRVP43H1Poj2XJQCL9jkE5bsEAUmIFG6oHLnCdDeSdvo3sRRwqB5X9ktkIgaRiEBiRgHA11dHYkyKk2coIq0HAWBCS8ZOB0iaxceTBhAMqVLjgcTr3cjMEWFvbaPNTKTrbwiXXasZA1oo3ybC+XKkDtLWlvXE+iqlsgjFXBFwTJkexJIwkAIOvUryeJaU8rZKGyMHlLzF0D5pHs4nasXl8Q1NOtXKaKf/kuP64glXMMkEg+avl6qDQcLvap8grKBTLl01U9+OWZxSNGhIeGwojtA+2nMKFCBiPtkcLCbVxULNy/gYTJrU7+cSgzMhkPn3GYTKih0oUZsy6HuCBdQ63u80qg6VOlKF0747h0tdWHdiZ47+01Zw9RQ7ep+BeHStVEF8tr9Hj5rM2i+FPjDKJGwvtmAuQgvlb5kUAip1YSu+RE6G18qS+Gf3b4k4uf7QVU6wDCSSvnBGQHsdJN/d+bEDCiRL7OE0TUf+wfqwgPvUyJ+a6W+JARHVcmE5RCrK97tmw+eW0+VS4PiSvec6urkSLcQEtiKqdixdFxN3ZtYsWVr08WbxO+y0+cKyi9yjl2/83jMom28KQK6DFJvqAT0GKgqWeEBNkBJqgdKsHTUgi3iWoBR0SG/Uo37OqUOvHKHuK7uTR1V1TVb4i3lUhlLk+FJ2pXY3LDvdPOB85nKv13d0mKXgf/LHDAyUwQY3qqWxc0K+3GtsrIahk8Hyz2+0LwJAHmexKbtMN59rYWcAhjYoHIhK/4rHepbiAUwfjetVsz25UTKGqXyQrEkYpz1U+Gg3LCyhdeXU7m8SZQE/+JsDD5J5QJGF4Shq36yCayPS3U4OUqTHLX0nEAvAknUdKATejTSGSakCVlz6oq9iE9Uu2au2qsiO9UrR1pLe7tUQ0pPlR6YwbM3uo5YjMRdYi/S8JRtMxqWhRGd64p4Br/T6JlUg5TOiRUfc3VaYBCfhRAn3nXhxn0ORxqAIraqYnJis607eLZKp4midzPwPpf8SrcZc/D09cl9mkhWTiQiGh1SBUjcjPeFG2KTwScu3JSQMBCrhSOZEwwUfm2GLCBLtiHNvRhCiDmbVg7/AMCWhlSN3ATSNtBE6V81nT3iM9RSlbrCNRhepu2Yyct2T/TY2XzgvFo9p5KiFbzQIHVhRV4yj28GWkPYvnmTA9yJGBiIZS36zb5s2z2gml/J6jrYEjJYDp29cerS3f0mry7mMor0IsDqdx4+w38hdEq/C5nnGpSqW9s53ztM9Eev9HdU8R/AeXj2wBbSb33ssh8CMKWxx87fkjB4tAe2c5KQvPn8JZGL9bUmwxMfJQH4BdsMW8RDQS/ceCARmOZ/kwNGZooAt3NkSi16WNetUID0++MzdqkfdshGFFKEQv35JAxwqWMhrjWzms4bqbrFPGa1SuZNkSShNKGNTXy3WgniGjLSom6olbHdGlUUe8X0USJegnUqepCpBiaYadyHuEgBdFBcS3Ou3OUjYXo2qVS3kmw7YzS6zDR47TbtP2f9Hgux6fiFW+6bjkqTw791SOc6EpI14ZG2xK0ND0OTaFAex8Gpb/MBc+DL2XmUB5IWIg0PiqC5D3LB/SYRoxmk0TOxz4xIj1ztYpPDTzTp1Cd57hA/fu3dFiPLADJYsoEIF3r49B+IOEjsDiTpTsuXEIG5Q1vrXKpR4S77zwPr9pg6YMoamGLLtvuraMuRSHvYr1W1OoqVE3Mixr6apX3t4Klrki4EsuYay98LttFlVLrOxKE5n1DHpmHfmWo8FK6Xf6iwOuIEa5TLJ16adRiO86jyKypKoVfrNWmVNAo3BsruqqK8lVTRyN/RY9zy3yau9PQ6BgPiz5qT259zN89ctQ931DnFdb08lU8SfDtw8iq2B8VblU7jUYW6Uokfxd36v6AdBx8/ke+01MkJezSmAgeGzd70y/jlYxZtR5HHXi2qivNzeM76Qyh8XqXrhNHuWzkSwGPKXgb8zfuyudNKfk5S/4oaWb+1qCyuhQPb1sNhWjHWtXynxXsGx9EVozrojoV4Ru49skiYxCZ5GvAqQjEQc9YeePYiTPYaPHMDUl4hTTGbDSzFI4kHEzE0sHercp54UQaOOgeMD3jEeNiudhl+NkLRWeuDW9Up3X/6OtzTIKtSPLdYtMH6QLUXMhBe2YdDKpXCrapC4ewqjYjpUr989wkrGMZZk61ApLcCt6pdGi84RtA0vNSUsCUhkp8VZ4UBsUZoGWMr86OrfP5s209cVmkwQ3aqMBPkNtRIF89eS7edgLjGLVkIuxsxz0ID37Z2qfG9bIrQFrcBjf25a3fr9ZnRtk7pRlWKJEmc4MRFP7e5m8VPKehx1vSa0h2ykThWhKF0nNKnWZcxniKSw/+8fCP5+P/SuKJTBdnACnq8am/eDz6Cq3/bj16Eo7SI33H0ktjk8KUr93BP8rJrHL/X5xqHAWBXEJvwD1KJQpaSjKf40sO5B7ltoIwpXSj7TyXzqKGUbDbkWV07sWt51wlqMAEIsBPYKPEPXxoZLoZ0oqVP6AM8Rneo3HE8r9YHLVGv8cs9R7vy4cPnbhbL1OOn2Ta9J5w/OAEHkiVKAJMS00agvnWVjuPmD20jyqmQOTgxlBCT+zQlAzg+UwXQIKh9ihUTBYhO+t79rVnl7JlSQwKb4LlTrVs8q19z6Ydji+JLzB95vg0JqFs+/+I/2+096QulndSF5qw1+/FfSFTwd5F6B3Ws7XX0Ins18S646JV3HQerKEroYP9enj15FwB8mJGPVMRweJP3uW6NK/EmAOinVa9qkSBjmmSrxnbKkyUdqhziThO7AENuxlkFonbHEWG/LPDXFFckNhBFEeBpJN6BkIFwi7JcJ9LkOgPr6K71r95+sn5f2AFpwNS1jsVzwUrLZoCBbJ9PsEzJ/vAErRjtaiWBy4Ub98h7Hsh9J67YXsFQKp6NhxH6YPwDQ0fsz5+lGqO4pVMlS5w+VRLEClQslL1qqTy2V8ELvTLzf2sciDV06FBr/abPkgMoAIfATjyK6VJ8P/V3Z+upWRB5fury7cu3HmKOEZ3r2F7L2nLNLy08KvBdQOOXxpUqW57/VPqsGVLBBRLqk6SJ4iM8lcemqpThYlImTbRp/zmWYXb+YBfVU1Wa4c3boO1HLgLZvm4ZXYkuaUiGtMkWbz6qfnuGuNZGFReJmDUL5MhQKl9mxA+zEmkYu3T7cZwg3wW933/qWrs/F/FCvHh1juxa76+eDVWnBz4zXIlnrznAmxz4pUklJFzYdPDciUu3UYIG7/cth85LhgAIdrum9cwVnqcaZAtE3KjFDfhaDIBT1O8tq43t3lC9tfDK/m3Syr0+V6QhrOlz6c7boPeZ06WAfRBn0HnrDw2bsZ6sHhP4Nuj6rYf29nEzpksheu/ihlG/Xpgcmhu1fBturcDXb+88Djhy4RaCpGYs2/3yTVDFojlIJkNkyeaQAql6dPo8fkXNqhTxGNE+YXw7jpEAPFPNfipx+96T86EWCgBHzt5E+cUb95+MX7JzkudOPgQ6mG3TftVFP4DDeJZ5ci9cy8w1+06d97t+/6n3met/TF27ZvcpNhVuoQVDWtXQeBAiO4ZasyxD2uSI+kbef8Q3rNl7GnfOsu0n/ASvdjbzmO71f2nqyDcsAY7FciG+kgxuh4Pj7H7NR3SrZxc3ds6MabxPXr1x318ajmbdsvk8x7hKSlng06VMUihnhk0HzvLL52OBQebJ+cNa58/+RdKCtLf/1FXnAfO5boMTMwDaqTTJEsWJHZt/nkvkyXLm6l1fv+BXn/SHd1GPppVXju6YKX1ybAy/9dZDsjoHQ3Ay3Dq1B//tLt18sHHvmV7jlpO3NG7R01fvYOdpkiVOFFItIGH8eA/9X+CEI62O58t9aGtS7w6VNvwRP3z6iF+f3agoIbd5/5lE9vEeP3+Bgui/TlzJFbHIGuM1ubvuPYzcVOt2nRzrvg33krQB1tx13DdD6qSws0uOqiTxgo3eZNwARF6SG3hB4XUNZSFuvL+X7rrz6BnyKdiev43cg0FyDnxnxSzCiQwgcqBG98k4lbp1rD2wQy0RT8LLvI41GzgPgst9r7+imGEM3gkONfviwb6+fmTGtMnI5URk9U4TobyBxmLy781EfCRg6GwGzlhfrWTubVN7hDscdSKz1OmP4/vpJQML5KJTEaqTzF93sMuYZeKxDDuf1LsJebLnwxH93mPcslW7T5Efe+S1Qv7xoe2dJBMDH84BuNHAKsSbHBjU3unPTnXg6AM7CBMEeRcAnPMaVC6MPEYIXRHxVmC8+p0Hzj3te5ekgV4BAi5KJai9567e7TjS49HzF/DgxjMLtuBDHhcy4ufPyB0QjIn1HWwBjsVzIpf3gOnrNu4/+wJSzIePkCPRFe+7mEGgROX64H8/IwAK72v3Ia3ESIKfe80QD9nqHsLFtKpVClK17ieD8q+926JgyYmaCIqHqX2b2ShkYwJIkL0mrr5+9zE5G776yIM8vPPP1h+6lFV64QyAksnwm0H96ROX5E8sFoLea2rfpsh4Se06GJezwWAEZEm9OFxdXeeG+3PkvM0Tl+2WtHQgRlqKPs5VSW2iONXdh8+bDZyLzJYciQDAzs0cXX8uJ2bThktcr79X4hKQZp1RggNurrWbWdWFQ4brNWnF6l1fREMMhE6xcdWif/VoKNqbGvWdfeTcjc/vP+Bj/OLdB0nJCg1cAvs4iRPYx48d68I6N+5nCSPR71NWo9QS3xKcqJrULNmnZVWc6PjlAMCzP2jqWp4rFY9V10YV+rWpyfeAV0qptqMhYH169+HFuyDcupBdxN8dsSaJEtjBU6Jwzozrxndmk8PY2nzQXC74sqvzGN4u3HsMYm6LwfOgEeQ7F3cLzSWyhU3s2ciK3WDGyn1z1x9EtoLXIT7geCLw3rb77rs3Hz9BJmPTooINnsTdM34TVZviQhxGykoI97wZCQAbXj++q41pvSIxf7QaYmSmCP/ceH8hhHXOwJYIww53MJ7bX8Z6FMj5g6S7DncgSTBk1kbgh3WsTfZKSO8z18Z77HTrVDdywXribDhodh27tFfzKsi4I+J1MOwjj/z/mdLXWUdA4nGWQrbD6w/98VZqULGQ7fIWZoP+BtoORBG/CXofN06sVEkTlymQrZ5jQSv2MnEPOplpcIdanNvQF245cA769vefPmVMkxzK/3zZHGwRXsWFGAzJ6ej5W3ce+N99GhA3Fj45dulTJytfIFuELlmdNooYaAsquI4TP0WRmBAGLCjnrAyE+xGUFnBAuffoGT6/0BulTp64WO5M5QvKqa2sTMK74B67cofPoTPXAgPfvI/xKUkCe6Rjrle+oI2chD9yyxol+Cf82u3H+05dOX/9PhQqKBObJ2Nqx5K5pXQ+fGkO5Kg3CA5GvMkA+LddWevGYHiZbD1w1vvc9WeBb1InSVgw1w+oHAC9ozTEShP3HvSmMWN8lzFdcqnqgDgKzynEvo8fP2XLkCpPVkLyFok5jCDNmw/9IZE4pEjyQ7pkOpGX08NAHCw3fQwW02Pro/MYPXzJz1+5g2BPqKsLZM+gE2HxnvQ+ey3gxetUyRMXyZXRup8omxnbwAEASSOtbxg5OzZ5n4dDfe4s6ZpVL0ZqmPiliQA80DfsP7Pz6IWn/i/ffvoIgSNT2hROpfNWKJrD+oriJF8Fxg+Uu8lQVeyO0OSocWQlZX+EpormxEZmiuY3gLn8YA5Ah1/MhdAzjepWr1/rn6IPj5CcCbkGonK9TL8SlRn+dWNJmQmecGeWDfrXXYvZ8P8mB+AR33LwfG4ZjMQmYZT03zXRFmE0EpNHqyEmbi5a/dzmYiPGgYSh7p8RG/avpe7bqvr68Z3VNEi2XxDyO8BZ2Hb6b4CSdNJKpKlP8g1cr7mE/z4HmlQremB2b+SkiPTSUFNFojZ2pJf7hgeauLlv+Mc1l2YrB+BYQJLicEbiv1Xk0bM3Fm85BuMOu0B4t2ROmyzl94kSJLCLHzdOjFjBFcw+f/j46v17OJDdvOcvZVdio5788wq5lL5VFqnXpcYugCa2nXm1qqwymEhyANb8OesO8CypsGjDPQDOIUkTxItjB/fukAfz0yc4ML5++fbmo2eqsRgLPw8IS1gQyX2YYXi0DRMMBwwHyM8e2BIntIR4dGDR8DmbBoU4zOFiq5fMg/oM4fq2w9Ni7JLtSAIkipzfhwQuRQeOWbnGeHG+BKhboTFdhgO2cGDRpsPthy9mhjkUk1g4pHW+0JBG3XDoeqes3DvG3UtMJ5FAKayuG27wVjhgbHNWmGO6ojsH1CRG3ypHNu4/wwUmaNeWjeoQrsAEVmRySDG9n3P/NjU4W1ANEMXaeDM6AKTAbR87VnS4dnON/2kOoC5vu+GLuCfT4mFtwxWYsCUoehHwO+OP5nx7CG/MkyU9bxog0hwwMlOkWWcGfjsc+GwRuRx2Xbr6FWEU3wq0dMtRfikZ0ybnYd4caQUoXTAr721Ro8R/OaqIL/3/BZDlw6LPnfP/xfZosu7S7Sd4ygOktrI9HBL8KV8oLLld7TJ5bAn0jiZcjcplGpkpKtwzY78RDrx5/568EuTXIfHfIDImEgh/+bt1/ymS8oW2wv//1pBUq6BDaZ1RXeuHP+Dbogikbp6Xb6LNnfNt/Zr/y1cD4QlqJ9t3iJSqjBi53WcObGn7QENphQNGZrLCHNMVXTjwyD+QvNSrd+W8OyTZN4BsW7cMvwrU0EAyQGQV4hgdAKdUFFudunIfCJBjc1o/5+gWzIw0Rc8o11rfe9HlztHdGwb/VTiAkp2ih0DLoQuQ5jTcmZFQdIrnrn6hJbfH9miYJkX0spiHy6JIE5jaKZFmnRn47XDgb88dJ33vqNeDYrRfJRmpOvP/GiaLQ0rk/+S5zq/deeK+0fvFq7eI0EH5KrHECnYOccr77PWpK/a4DnP3CqlqhxIQS0e2/6l03v+16/pP72fvCd/5G73VVSBN1i6XHyVK1C6DMRywnQPJkyT8MXMauBuy+kUPn75A5Wy4eNvZxUH+T0TMiVNBL37q0m2kIO/05yKPHSdQ4wuhr9P6NXOtV04kM3BUOGByWkaFe2bsv5sDSCV8/c6TJV7H3OZsEiO/xKv61blK5wblkyS0h48PEh+LXd8ejBz3w2Zs2OnjK14avEfTpkicPHH8mLFjIl/zvceogRtmeMqRMXWn+uVd65ePbpUZ8N06eOZat7HLUKxQZBeHSxfIgiz8SBYf3y6OWOeEExjAcMBGDqCcS0hBpDNS1WGUTEC9y3jxYqOkEmrMidWpURG13c9luzd1tD31uY2bieZkRmaK5jdAtL581Ch1HbEEqm9Yo968CwpCdMqnzx8/fkZRBlia4MucIHYsKFrixIuLHlRSqx499CiobLjP54qP7+2rNx8i1wsKibx7/fblhw8oJQZmpEyWCCJUroxpC+ZwqFg0Z65MaaLhPYSisHkaDUXtYtwYyBYYXMb4A9JafcL9E3zjxIoRO2ZMe7u4uHkgZ9conXdW/xbRkEvmkr8uB/wDXu3xuXz68p1zN+7defQcOqeXr9+iWhRuNiRpgmyUJvn3uTKmypMtfYXCOfB4RrdojK/Lbd1sRmbSccbgDQcMBwwHDAcMBwwHDAfCOGB8wMN4YSDDAcMBwwHDAcMBwwHDAR0HjMyk44zBGw4YDhgOGA4YDhgOGA6EccDITGG8MJDhgOGA4YDhgOGA4YDhgI4DRmbSccbgDQcMBwwHDAcMBwwHDAfCOGBkpjBeGMhwwHDAcMBwwHDAcMBwQMcBIzPpOGPwhgOGA4YDhgOGA4YDhgNhHDAyUxgvDGQ4YDhgOGA4YDhgOGA4oOOAkZl0nDF4wwHDAcMBwwHDAcMBw4EwDhiZKYwXBjIcMBwwHDAcMBwwHDAc0HHAyEw6zhi84YDhgOGA4YDhgOGA4UAYB4zMFMYLAxkOGA4YDhgOGA4YDhgO6DhgZCYdZwzecOiYWF0AAAArSURBVMBwwHDAcMBwwHDAcCCMA0ZmCuOFgQwHDAcMBwwHDAcMBwwHdBz4P5qYSU87nwG2AAAAAElFTkSuQmCC</xsl:text>
	</xsl:variable>
	
<xsl:variable name="titles" select="xalan:nodeset($titles_)"/><xsl:variable name="titles_">
				
		<title-annex lang="en">Annex </title-annex>
		<title-annex lang="fr">Annexe </title-annex>
		
			<title-annex lang="zh">Annex </title-annex>
		
		
				
		<title-edition lang="en">
			
			
				<xsl:text>Version</xsl:text>
			
		</title-edition>
		
		<title-edition lang="fr">
			
				<xsl:text>Édition </xsl:text>
			
		</title-edition>
		

		<title-toc lang="en">
			
				<xsl:text>Contents</xsl:text>
			
			
			
		</title-toc>
		<title-toc lang="fr">
			
				<xsl:text>Sommaire</xsl:text>
			
			
			</title-toc>
		
			<title-toc lang="zh">Contents</title-toc>
		
		
		
		<title-page lang="en">Page</title-page>
		<title-page lang="fr">Page</title-page>
		
		<title-key lang="en">Key</title-key>
		<title-key lang="fr">Légende</title-key>
			
		<title-where lang="en">where</title-where>
		<title-where lang="fr">où</title-where>
					
		<title-descriptors lang="en">Descriptors</title-descriptors>
		
		<title-part lang="en">
			
			
			
		</title-part>
		<title-part lang="fr">
			
			
			
		</title-part>		
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-subpart lang="en">			
			
		</title-subpart>
		<title-subpart lang="fr">		
			
		</title-subpart>
		
		<title-modified lang="en">modified</title-modified>
		<title-modified lang="fr">modifiée</title-modified>
		
			<title-modified lang="zh">modified</title-modified>
		
		
		
		<title-source lang="en">
			
				<xsl:text>SOURCE</xsl:text>
						
			 
		</title-source>
		
		<title-keywords lang="en">Keywords</title-keywords>
		
		<title-deprecated lang="en">DEPRECATED</title-deprecated>
		<title-deprecated lang="fr">DEPRECATED</title-deprecated>
				
		<title-list-tables lang="en">List of Tables</title-list-tables>
		
		<title-list-figures lang="en">List of Figures</title-list-figures>
		
		<title-list-recommendations lang="en">List of Recommendations</title-list-recommendations>
		
		<title-acknowledgements lang="en">Acknowledgements</title-acknowledgements>
		
		<title-abstract lang="en">Abstract</title-abstract>
		
		<title-summary lang="en">Summary</title-summary>
		
		<title-in lang="en">in </title-in>
		
		<title-partly-supercedes lang="en">Partly Supercedes </title-partly-supercedes>
		<title-partly-supercedes lang="zh">部分代替 </title-partly-supercedes>
		
		<title-completion-date lang="en">Completion date for this manuscript</title-completion-date>
		<title-completion-date lang="zh">本稿完成日期</title-completion-date>
		
		<title-issuance-date lang="en">Issuance Date: #</title-issuance-date>
		<title-issuance-date lang="zh"># 发布</title-issuance-date>
		
		<title-implementation-date lang="en">Implementation Date: #</title-implementation-date>
		<title-implementation-date lang="zh"># 实施</title-implementation-date>

		<title-obligation-normative lang="en">normative</title-obligation-normative>
		<title-obligation-normative lang="zh">规范性附录</title-obligation-normative>
		
		<title-caution lang="en">CAUTION</title-caution>
		<title-caution lang="zh">注意</title-caution>
			
		<title-warning lang="en">WARNING</title-warning>
		<title-warning lang="zh">警告</title-warning>
		
		<title-amendment lang="en">AMENDMENT</title-amendment>
		
		<title-continued lang="en">(continued)</title-continued>
		<title-continued lang="fr">(continué)</title-continued>
		
	</xsl:variable><xsl:variable name="bibdata">
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']"/>
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'localized-strings']"/>
	</xsl:variable><xsl:variable name="tab_zh">　</xsl:variable><xsl:template name="getTitle">
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
	</xsl:template><xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable><xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable><xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/><xsl:variable name="linebreak" select="'&#8232;'"/><xsl:attribute-set name="root-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="link-style">
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		
		
		
		
		
				
		
		
			<xsl:attribute name="font-family">Courier</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="permission-style">
		
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="permission-name-style">
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="permission-label-style">
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-style">
		
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-name-style">
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-label-style">
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-subject-style">
	</xsl:attribute-set><xsl:attribute-set name="requirement-inherit-style">
	</xsl:attribute-set><xsl:attribute-set name="recommendation-style">
		
			<xsl:attribute name="margin-top">6pt</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-name-style">
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
			<xsl:attribute name="padding-bottom">1mm</xsl:attribute>
			<xsl:attribute name="margin-bottom">1mm</xsl:attribute>
			<xsl:attribute name="background-color">rgb(165,165,165)</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-label-style">
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-style">
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-style">
		
		
		
		
		
		
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-body-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-name-style">
		
		
		
		
		
		
		
		
		
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>			 
		
		
		
		
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-p-style">
		
		
		
		
		
		
		
		
					
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-name-style">
		
			<xsl:attribute name="padding-right">10mm</xsl:attribute>
		
		
		
				
	</xsl:attribute-set><xsl:attribute-set name="table-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
		
		
		
		
				
		
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="margin-top">0pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-style">
				
			<xsl:attribute name="font-size">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-example-style">
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-top">8pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="xref-style">
		
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="eref-style">
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-style">
		
		
		
		
				
		
		
		
		
		
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>			
			<xsl:attribute name="line-height">115%</xsl:attribute>
		
		
		
		
	</xsl:attribute-set><xsl:variable name="note-body-indent">10mm</xsl:variable><xsl:variable name="note-body-indent-table">5mm</xsl:variable><xsl:attribute-set name="note-name-style">
		
		
		
		
		
		
		
		
		
		
		
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-p-style">
		
		
		
				
		
		
		
		
		
			<xsl:attribute name="margin-top">12pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-style">
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-name-style">		
		
				
		
	</xsl:attribute-set><xsl:attribute-set name="quote-style">		
		
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="quote-source-style">		
		
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
		
				
				
	</xsl:attribute-set><xsl:attribute-set name="termsource-style">
		
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="origin-style">
		
		
			<xsl:attribute name="color">blue</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="term-style">
		
	</xsl:attribute-set><xsl:attribute-set name="figure-name-style">
		
				
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="text-align">left</xsl:attribute>
			<xsl:attribute name="color">rgb(68, 84, 106)</xsl:attribute>
			<xsl:attribute name="font-weight">normal</xsl:attribute>
			<xsl:attribute name="font-style">italic</xsl:attribute>
			<xsl:attribute name="margin-top">0pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
			
	</xsl:attribute-set><xsl:attribute-set name="formula-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		
		
			<xsl:attribute name="space-before">12pt</xsl:attribute>
			<xsl:attribute name="space-after">0pt</xsl:attribute>
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="figure-pseudocode-p-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-graphic-style">
		
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		
		
		
				

	</xsl:attribute-set><xsl:attribute-set name="tt-style">
		
		
			<xsl:attribute name="font-family">Courier</xsl:attribute>			
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="domain-style">
				
	</xsl:attribute-set><xsl:attribute-set name="admitted-style">
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="deprecates-style">
		
	</xsl:attribute-set><xsl:attribute-set name="definition-style">
		
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable><xsl:attribute-set name="add-style">
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<!-- <xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
	</xsl:attribute-set><xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable><xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set><xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable><xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable><xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>
	</xsl:template><xsl:template name="processMainSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" mode="contents"/>			
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']" mode="contents"/>	
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]" mode="contents"/>		
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']" mode="contents"/>		
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]" mode="contents"/>
	</xsl:template><xsl:template name="processPrefaceSectionsDefault">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']"/>
	</xsl:template><xsl:template name="processMainSectionsDefault">			
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']"/>
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']"/>
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]"/>
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']"/>
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]"/>
	</xsl:template><xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template><xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<!-- <xsl:call-template name="add-zero-spaces"/> -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template><xsl:template match="*[local-name()='table']" name="table">
	
		<xsl:variable name="table-preamble">
			
			
		</xsl:variable>
		
		<xsl:variable name="table">
	
			<xsl:variable name="simple-table">	
				<xsl:call-template name="getSimpleTable"/>			
			</xsl:variable>
		
			<!-- <xsl:if test="$namespace = 'bipm'">
				<fo:block>&#xA0;</fo:block>				
			</xsl:if> -->
			
			<!-- $namespace = 'iso' or  -->
			
					
			
				<xsl:call-template name="fn_name_display"/>
			
				
			
			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/tr[1]/td)"/>
			
			<!-- <xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="*[local-name()='thead']">
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable> -->
			<!-- cols-count=<xsl:copy-of select="$cols-count"/> -->
			<!-- cols-count2=<xsl:copy-of select="$cols-count2"/> -->
			
			<xsl:variable name="colwidths">
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col'])">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
			
			<!-- <xsl:variable name="colwidths2">
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:call-template>
			</xsl:variable> -->
			
			<!-- cols-count=<xsl:copy-of select="$cols-count"/>
			colwidthsNew=<xsl:copy-of select="$colwidths"/>
			colwidthsOld=<xsl:copy-of select="$colwidths2"/>z -->
			
			<xsl:variable name="margin-left">
				<xsl:choose>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			
			<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">			
				
					<xsl:attribute name="font-size">10pt</xsl:attribute>
				
				
							
							
							
				
				
				
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
					<xsl:attribute name="space-after">12pt</xsl:attribute>
										
				
				
				
				
				
				
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->
					
							
					
						<xsl:choose>
						<xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
						<xsl:otherwise>100%</xsl:otherwise>
					</xsl:choose>
					
				</xsl:variable>
				
				<xsl:variable name="table_attributes">
					<attribute name="table-layout">fixed</attribute>
					<attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></attribute>
					<attribute name="margin-left"><xsl:value-of select="$margin-left"/>mm</attribute>
					<attribute name="margin-right"><xsl:value-of select="$margin-left"/>mm</attribute>
					
					
					
					
					
					
						<attribute name="margin-left">0mm</attribute>
						<attribute name="margin-right">0mm</attribute>
									
									
									
					
									
					
				</xsl:variable>
				
				
				<fo:table id="{@id}" table-omit-footer-at-break="true">
					
					<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">					
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or .//*[local-name()='fn'][local-name(..) != 'name']"/>				
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
							<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="xalan:nodeset($colwidths)//column">
								<xsl:choose>
									<xsl:when test=". = 1 or . = 0">
										<fo:table-column column-width="proportional-column-width(2)"/>
									</xsl:when>
									<xsl:otherwise>
										<fo:table-column column-width="proportional-column-width({.})"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
							<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
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
				
				<!-- insert footer as table -->
				<!-- <fo:table>
					<xsl:for-each select="xalan::nodeset($table_attributes)/attribute">
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:for-each select="xalan:nodeset($colwidths)//column">
						<xsl:choose>
							<xsl:when test=". = 1 or . = 0">
								<fo:table-column column-width="proportional-column-width(2)"/>
							</xsl:when>
							<xsl:otherwise>
								<fo:table-column column-width="proportional-column-width({.})"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</fo:table>-->
				
				
				
				
					<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				
				
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
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name() = 'name']"/><xsl:template match="*[local-name()='table']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="table-name-style">
				
				
				<xsl:apply-templates/>				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template><xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
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
						<xsl:for-each select="xalan:nodeset($table)/*/tr">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
								
								<!-- <xsl:if test="$namespace = 'bipm'">
									<xsl:for-each select="*[local-name()='td'][$curr-col]//*[local-name()='math']">									
										<word><xsl:value-of select="normalize-space(.)"/></word>
									</xsl:for-each>
								</xsl:if> -->
								
							</xsl:variable>
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​', ' '))"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
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

			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="text()" mode="td_text">
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:value-of select="translate(., $zero-space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template><xsl:template match="*[local-name()='link']" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template><xsl:template match="*[local-name()='math']" mode="td_text">
		<xsl:variable name="mathml">
			<xsl:for-each select="*">
				<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="math_text" select="normalize-space(xalan:nodeset($mathml))"/>
		<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
	</xsl:template><xsl:template match="*[local-name()='table2']"/><xsl:template match="*[local-name()='thead']"/><xsl:template match="*[local-name()='thead']" mode="process">
		<xsl:param name="cols-count"/>
		<!-- font-weight="bold" -->
		<fo:table-header>
			
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template><xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>		
		<!-- row for title -->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black">
				<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']" mode="presentation"/>
				<xsl:for-each select="ancestor::*[local-name()='table'][1]">
					<xsl:call-template name="fn_name_display"/>
				</xsl:for-each>				
				<fo:block text-align="right" font-style="italic">
					<xsl:text> </xsl:text>
					<fo:retrieve-table-marker retrieve-class-name="table_continued"/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="process_tbody">		
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tfoot']"/><xsl:template match="*[local-name()='tfoot']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooter2">
		<xsl:param name="cols-count"/>
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		<xsl:if test="../*[local-name()='tfoot'] or           $isNoteOrFnExist = 'true'">
		
			<fo:table-footer>
			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
				
				<!-- if there are note(s) or fn(s) then create footer row -->
				<xsl:if test="$isNoteOrFnExist = 'true'">
				
					
				
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							<!-- except gb -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- show Note under table in preface (ex. abstract) sections -->
							<!-- empty, because notes show at page side in main sections -->
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">										
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>										
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
					
				</xsl:if>
			</fo:table-footer>
		
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		
		<xsl:if test="$isNoteOrFnExist = 'true'">
		
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
			
			<fo:table keep-with-previous="always">
				<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">
					<xsl:choose>
						<xsl:when test="@name = 'border-top'">
							<xsl:attribute name="{@name}">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:when test="@name = 'border'">
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
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
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							
							<!-- except gb  -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">
										show Note under table in preface (ex. abstract) sections
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>
										empty, because notes show at page side in main sections
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
				
			</fo:table>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='tbody']">
		
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
		
		
		
		<xsl:apply-templates select="../*[local-name()='thead']" mode="process">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			

			<xsl:apply-templates/>
			<!-- <xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/> -->
		
		</fo:table-body>
		
	</xsl:template><xsl:template match="*[local-name()='tr']">
		<xsl:variable name="parent-name" select="local-name(..)"/>
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					
					
					
					
					
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					
					
				</xsl:if>
				
				
				
				
				<!-- <xsl:if test="$namespace = 'bipm'">
					<xsl:attribute name="height">8mm</xsl:attribute>
				</xsl:if> -->
				
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>center</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			
			
			
			
			
				<xsl:attribute name="padding">1mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(0, 51, 102)</xsl:attribute>
				<xsl:attribute name="color">white</xsl:attribute>
				<xsl:attribute name="border">solid 0.5pt rgb(153, 153, 153)</xsl:attribute>
				<xsl:attribute name="height">5mm</xsl:attribute>
			
			
			
			
			
			
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
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
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="display-align">
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
	</xsl:template><xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			
			
			
			
			
			
			
			
				<xsl:attribute name="padding-top">1mm</xsl:attribute>			
				<xsl:attribute name="border">solid 0.5pt rgb(153, 153, 153)</xsl:attribute>
				<xsl:attribute name="height">5mm</xsl:attribute>
			
			
			
			
			
			<xsl:if test=".//*[local-name() = 'table']">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
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
			<fo:block>
								
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']" priority="2"/><xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				
				
				
				
				
				
				<fo:inline padding-right="2mm">
					
					
					
					
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						
				</fo:inline>
				
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='name']" mode="process"/><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					
					
						<xsl:attribute name="id">
							<xsl:value-of select="@reference"/>
							<xsl:text>_</xsl:text>
							<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
						</xsl:attribute>
					
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
					
					
					
					
					
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						
							<xsl:attribute name="vertical-align">super</xsl:attribute>
						
						
						
						
						
						
						
						<xsl:value-of select="@reference"/>
						
						
					</fo:inline>
					<fo:inline>
						
						<!-- <xsl:apply-templates /> -->
						<xsl:copy-of select="./node()"/>
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_name_display">
		<!-- <xsl:variable name="references">
			<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		$references=<xsl:copy-of select="$references"/> -->
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_display_figure">
		<xsl:variable name="key_iso">
			 <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- current hierarchy is 'figure' element -->
		<xsl:variable name="following_dl_colwidths">
			<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
				<xsl:variable name="html-table">
					<xsl:variable name="doc_ns">
						
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
					</xsl:variable>
					<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
					<!-- <xsl:element name="{$ns}:table"> -->
						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					<!-- </xsl:element> -->
				</xsl:variable>
				
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="2"/>
					<xsl:with-param name="table" select="$html-table"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:variable>
		
		
		<xsl:variable name="maxlength_dt">
			<xsl:for-each select="*[local-name() = 'dl'][1]">
				<xsl:call-template name="getMaxLength_dt"/>			
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="xalan:nodeset($references)//fn">
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
											<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
												
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block text-align="justify" margin-bottom="12pt">
											
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											
											<!-- <xsl:apply-templates /> -->
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
		
	</xsl:template><xsl:template match="*[local-name()='fn']">
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:inline font-size="80%" keep-with-previous.within-line="always">
			
			
			
			
				<xsl:attribute name="vertical-align">super</xsl:attribute>
				<xsl:attribute name="color">blue</xsl:attribute>
			
			
				<xsl:attribute name="text-decoration">underline</xsl:attribute>
			
			
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="@reference"/><xsl:text>_</xsl:text>
						<xsl:value-of select="ancestor::*[local-name()='table'][1]/@id"/>
					</xsl:attribute>
				
				
				<xsl:value-of select="@reference"/>
				
			</fo:basic-link>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='dl']">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
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
			
			<fo:block-container>
				
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				
				
				<xsl:variable name="parent" select="local-name(..)"/>
				
				<xsl:variable name="key_iso">
					 <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$parent = 'formula' and count(*[local-name()='dt']) = 1"> <!-- only one component -->
						
						
							<fo:block margin-bottom="12pt" text-align="left">
								
								<xsl:variable name="title-where">
									
									
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-where'"/>
										</xsl:call-template>
									
								</xsl:variable>
								<xsl:value-of select="$title-where"/><xsl:text> </xsl:text>
								<xsl:apply-templates select="*[local-name()='dt']/*"/>
								<xsl:text/>
								<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
							</fo:block>
						
					</xsl:when>
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">
							
							
							
							
							<xsl:variable name="title-where">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-where'"/>
									</xsl:call-template>
																
							</xsl:variable>
							<xsl:value-of select="$title-where"/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
							
							
							
							<xsl:variable name="title-key">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-key'"/>
									</xsl:call-template>
								
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
					<fo:block>
						
						
						
						
						<fo:block>
							
							
							
							
							<fo:table width="95%" table-layout="fixed">
								
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'">
										<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
									</xsl:when>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
										
									</xsl:when>
								</xsl:choose>
								<!-- create virtual html table for dl/[dt and dd] -->
								<xsl:variable name="html-table">
									<xsl:variable name="doc_ns">
										
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
									</xsl:variable>
									<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
									<!-- <xsl:element name="{$ns}:table"> -->
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									<!-- </xsl:element> -->
								</xsl:variable>
								<!-- html-table<xsl:copy-of select="$html-table"/> -->
								<xsl:variable name="colwidths">
									<xsl:call-template name="calculate-column-widths">
										<xsl:with-param name="cols-count" select="2"/>
										<xsl:with-param name="table" select="$html-table"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
								<xsl:variable name="maxlength_dt">							
									<xsl:call-template name="getMaxLength_dt"/>							
								</xsl:variable>
								<xsl:call-template name="setColumnWidth_dl">
									<xsl:with-param name="colwidths" select="$colwidths"/>							
									<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
								</xsl:call-template>
								<fo:table-body>
									<xsl:apply-templates>
										<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
									</xsl:apply-templates>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>		
		<xsl:param name="maxlength_dt"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
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
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <fo:table-column column-width="15%"/>
				<fo:table-column column-width="85%"/> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getMaxLength_dt">
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
			<!-- <xsl:for-each select="*[local-name()='dt']">
				<xsl:sort select="string-length(normalize-space(.))" data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="string-length(normalize-space(.))"/>
				</xsl:if>
			</xsl:for-each> -->
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template><xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
		<xsl:param name="key_iso"/>
		
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='dt']" mode="dl">
		<tr>
			<td>
				<xsl:apply-templates/>
			</td>
			<td>
				
				
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				
			</td>
		</tr>
		
	</xsl:template><xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		
		<fo:table-row>
			
			<fo:table-cell>
				
				<fo:block margin-top="6pt">
					
					
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						
					</xsl:if>
					
					
					
					
					
						<xsl:attribute name="margin-top">0pt</xsl:attribute>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					
					
					<xsl:apply-templates/>
					<!-- <xsl:if test="$namespace = 'gb'">
						<xsl:if test="ancestor::*[local-name()='formula']">
							<xsl:text>—</xsl:text>
						</xsl:if>
					</xsl:if> -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					
					<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:if> -->
					
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<fo:table-row>
				<fo:table-cell>
					<fo:block margin-top="6pt">
						<xsl:if test="normalize-space($key_iso) = 'true'">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						<xsl:text>&#xA0;</xsl:text>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
			</xsl:if>
		</xsl:if> -->
	</xsl:template><xsl:template match="*[local-name()='dd']" mode="dl"/><xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']"/><xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<fo:inline font-weight="bold">
			
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='tt']">
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:variable name="_font-size">
				
				
				
				
				
				
				
				
				
				
				
				
				
				10
				
						
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='add']">
		<xsl:choose>
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
		
	</xsl:template><xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20"/>
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-20%"><!-- alignment-baseline="middle" -->
				<!-- <xsl:attribute name="width">7mm</xsl:attribute>
				<xsl:attribute name="content-height">100%</xsl:attribute> -->
				<xsl:attribute name="height">5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template><xsl:template match="*[local-name()='del']">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline> 
	</xsl:template><xsl:template name="recursiveSmallCaps">
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
  </xsl:template><xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
					<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
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
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| )','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| |,)','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces">
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
	</xsl:template><xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template><xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template><xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/><xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
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
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@colspan" mode="simple-table-colspan"/><xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template><xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template><xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]"/>
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template><xsl:template match="tr" mode="simple-table-rowspan">
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
	</xsl:template><xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:when test="$language_current_2 != ''">
					<xsl:value-of select="$language_current_2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//*[local-name()='bibdata']//*[local-name()='language']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<!-- <xsl:value-of select="translate(substring($substr, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($substr, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(substring($str2, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($str2, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>		
	</xsl:template><xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<fo:inline xsl:use-attribute-sets="mathml-style">
			
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<xsl:variable name="mathml">
				<xsl:apply-templates select="." mode="mathml"/>
			</xsl:variable>
			<fo:instream-foreign-object fox:alt-text="Math">
				
				
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy-of select="xalan:nodeset($mathml)"/>
			</fo:instream-foreign-object>			
		</fo:inline>
	</xsl:template><xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = ' '])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<mathml:mspace width="0.5ex"/>
	</xsl:template><xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/><xsl:template match="*[local-name()='localityStack']"/><xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
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
			
			<xsl:choose>
				<xsl:when test="$target = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{@target}" fox:alt-text="{@target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<!-- <xsl:value-of select="$target"/> -->
								<xsl:call-template name="add-zero-spaces-link-java">
									<xsl:with-param name="text" select="$target"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']" mode="process"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='appendix']/*[local-name()='title']"/><xsl:template match="*[local-name()='appendix']/*[local-name()='title']" mode="process">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'callout']">		
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<fo:inline>				
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>		
	</xsl:template><xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>		
	</xsl:template><xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-modified'"/>
				</xsl:call-template>
			
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:text>—</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:text> — </xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'xref']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'formula']" name="formula">
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
				<fo:block id="{@id}" xsl:use-attribute-sets="formula-style">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'note']" name="note">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style">
			
			
				<xsl:if test="ancestor::ogc:ul or ancestor::ogc:ol and not(ancestor::ogc:note[1]/following-sibling::*)">
					<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
				</xsl:if>
			
			
			
			<fo:block-container margin-left="0mm">
				
				
				
				
				
				

				
					<fo:block>
						
						
						
						
						
						
						<fo:inline xsl:use-attribute-sets="note-name-style">
							<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						</fo:inline>
						<xsl:apply-templates/>
					</fo:block>
				
				
			</fo:block-container>
		</fo:block-container>
		
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1">
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
	</xsl:template><xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">			
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name'] |               *[local-name() = 'termnote']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']" mode="presentation">
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
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'terms']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">
			
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline>
				<xsl:apply-templates/>
				<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'ogc'">
					<xsl:text>.</xsl:text>
				</xsl:if> -->
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container id="{@id}">			
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="*[local-name() = 'note']">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'image']">
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
							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" xsl:use-attribute-sets="image-graphic-style"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="image_src">
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
	</xsl:template><xsl:template match="*[local-name() = 'image']" mode="cross_image">
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
				<!-- width=<xsl:value-of select="$width"/> -->
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<!-- height=<xsl:value-of select="$height"/> -->
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template><xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/><xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($contents)/doc">
						<xsl:choose>
							<xsl:when test="count(xalan:nodeset($contents)/doc) &gt; 1">
								<xsl:for-each select="xalan:nodeset($contents)/doc">
									<fo:bookmark internal-destination="{contents/item[1]/@id}" starting-state="hide">
										<fo:bookmark-title>
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
								<xsl:for-each select="xalan:nodeset($contents)/doc">
								
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
						<xsl:apply-templates select="xalan:nodeset($contents)/contents/item" mode="bookmark"/>				
					</xsl:otherwise>
				</xsl:choose>
				
				
				
					<xsl:if test="//*[local-name() = 'figure'][@id and *[local-name() = 'name']]">					
						<fo:bookmark internal-destination="{//*[local-name() = 'figure'][@id and *[local-name() = 'name']][1]/@id}" starting-state="hide">
							<fo:bookmark-title>Figures</fo:bookmark-title>
							<xsl:for-each select="//*[local-name() = 'figure'][@id and *[local-name() = 'name']]">
								<fo:bookmark internal-destination="{@id}">
									<fo:bookmark-title><xsl:apply-templates select="*[local-name() = 'name']/text()" mode="bookmarks"/></fo:bookmark-title>
								</fo:bookmark>
							</xsl:for-each>
						</fo:bookmark>					
					</xsl:if>
				
				
				
				
				
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template><xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)/figure">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:if test="xalan:nodeset($contents)/table">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="getLangVersion">
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
	</xsl:template><xsl:template match="item" mode="bookmark">
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
	</xsl:template><xsl:template match="title" mode="bookmark"/><xsl:template match="text()" mode="bookmark"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |         *[local-name() = 'image']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">			
			<fo:block xsl:use-attribute-sets="figure-name-style">
				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/><xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template><xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
		<!-- 
		<xsl:for-each select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()">
			<xsl:value-of select="."/>
		</xsl:for-each>
		-->
		
	</xsl:template><xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertTitleAsListItem">
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
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template><xsl:template name="extractSection">
		<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template><xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'fn']" mode="contents"/><xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/><xsl:template match="*[local-name() = 'fn']" mode="contents_item"/><xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'em']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
	
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
	
				<fo:block xsl:use-attribute-sets="sourcecode-style">
					<xsl:variable name="_font-size">
						
												
						
						
						
						
						
						
						
								
						
						
						
						10						
						
								
				</xsl:variable>
				<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
				<xsl:if test="$font-size != ''">
					<xsl:attribute name="font-size">
						<xsl:choose>
							<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
							<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
					<xsl:apply-templates/>			
				</fo:block>
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']/text()" priority="2">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces-java">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>
				
					<xsl:text>:</xsl:text>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='label']" mode="presentation"/>
			<xsl:apply-templates select="@obligation" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='subject']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">
				
					<xsl:if test="../@type = 'class'">
						<xsl:attribute name="background-color">white</xsl:attribute>
					</xsl:if>
				
				<xsl:apply-templates/>
				
					<xsl:text>:</xsl:text>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/@obligation" mode="presentation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'inherit']">
		<fo:block xsl:use-attribute-sets="requirement-inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
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
						<xsl:call-template name="getSimpleTable"/>			
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<!-- <fo:table-column column-width="35mm"/>
						<fo:table-column column-width="115mm"/> -->
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="requirement">		
		<fo:table-header>			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template><xsl:template match="*[local-name()='tbody']" mode="requirement">		
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">			
			<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
				<!-- <xsl:attribute name="border">1pt solid black</xsl:attribute> -->
				<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
				<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
				<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
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
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(165, 165, 165)</xsl:attribute>				
			</xsl:if>
			<xsl:if test="ancestor::*[local-name()='table']/@type = 'recommendtest'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>				
			</xsl:if> -->
			
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
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
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>				 
				<xsl:if test="parent::*[local-name()='tr']/preceding-sibling::*[local-name()='tr'] and not(*[local-name()='table'])">
					<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>					
				</xsl:if>
			</xsl:if> -->
			<!-- 2nd line and below -->
			
			<fo:block>			
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt" color="rgb(237, 193, 35)"> <!-- font-weight="bold" margin-bottom="4pt" text-align="center"  -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block> <!-- margin-bottom="10pt" -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'example']">
		<fo:block id="{@id}" xsl:use-attribute-sets="example-style">
			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
			<xsl:variable name="element">
				block				
				
				<xsl:if test=".//*[local-name() = 'table']">block</xsl:if> 
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="contains(normalize-space($element), 'block')">
					<fo:block xsl:use-attribute-sets="example-body-style">
						<xsl:apply-templates/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:inline>
						<xsl:apply-templates/>
					</fo:inline>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']" mode="presentation">

		<xsl:variable name="element">
			block
			
			<xsl:if test="following-sibling::*[1][local-name() = 'table']">block</xsl:if> 
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			block
			
			
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="normalize-space($element) = 'block'">
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
	</xsl:template><xsl:template match="*[local-name() = 'termsource']">
		<fo:block xsl:use-attribute-sets="termsource-style">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>					
					
						<xsl:text>[</xsl:text>
					
					<xsl:apply-templates/>					
					
						<xsl:text>]</xsl:text>
					
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'origin']">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			
				<fo:inline>
					
					
					
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-source'"/>
						</xsl:call-template>
					
					
					<xsl:text>: </xsl:text>
				</fo:inline>
			
			<fo:inline xsl:use-attribute-sets="origin-style">
				<xsl:apply-templates/>
			</fo:inline>
			</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'quote']">		
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			
			<fo:block-container margin-left="0mm">
		
				<fo:block xsl:use-attribute-sets="quote-style">
					<!-- <xsl:apply-templates select=".//*[local-name() = 'p']"/> -->
					
					<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
				</fo:block>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>				
					</fo:block>
				</xsl:if>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'eref']">
	
		<xsl:variable name="bibitemid">
			<xsl:choose>
				<xsl:when test="//*[local-name() = 'bibitem'][@hidden='true' and @id = current()/@bibitemid]"/>
				<xsl:when test="//*[local-name() = 'references'][@hidden='true']/*[local-name() = 'bibitem'][@id = current()/@bibitemid]"/>
				<xsl:otherwise><xsl:value-of select="@bibitemid"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="normalize-space($bibitemid) != ''">
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						
							<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
							<xsl:attribute name="font-size">80%</xsl:attribute>
							<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
							<xsl:attribute name="vertical-align">super</xsl:attribute>
											
						
					</xsl:if>	
											
					<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
						<xsl:if test="normalize-space(@citeas) = ''">
							<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
						</xsl:if>
						<xsl:if test="@type = 'inline'">
							
								<xsl:attribute name="color">blue</xsl:attribute>
								<xsl:attribute name="text-decoration">underline</xsl:attribute>
							
							
							
						</xsl:if>

						<xsl:apply-templates/>
					</fo:basic-link>
							
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="padding">
			
			
			
			
			
			
			
			
			
			
			
			
			
				<xsl:choose>
					<xsl:when test="$depth &gt;= 5"/>
					<xsl:when test="$depth &gt;= 4">5</xsl:when>
					<xsl:when test="$depth &gt;= 3 and ancestor::ogc:terms">3</xsl:when>
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
		
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		
		<xsl:choose>
			<xsl:when test="$language = 'zh'">
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
		
	</xsl:template><xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'deprecates']">
		<xsl:variable name="title-deprecated">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-deprecated'"/>
				</xsl:call-template>
			
		</xsl:variable>
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:value-of select="$title-deprecated"/>: <xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p']">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block> </fo:block>
	</xsl:template><xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">
		
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			
			
			
						
			
			
				<xsl:variable name="pos"><xsl:number count="ogc:sections/ogc:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable> <!--  | ogc:sections/ogc:terms -->
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
						
			
			
			<xsl:apply-templates/>
		</fo:block>
		
		
		
	</xsl:template><xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/><xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3"/><xsl:template match="/*/*[local-name() = 'bibliography']/*[local-name() = 'references'][@normative='true']">
		
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'review']">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template><xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
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
							<xsl:apply-templates select="." mode="ul_ol"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates select="." mode="ul_ol"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="index" select="document($external_index)"/><xsl:variable name="dash" select="'–'"/><xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable><xsl:template match="@*|node()" mode="index_add_id">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_add_id"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId"/>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id"/>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $dash) and $remove = 'true'">
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
				<xsl:variable name="page" select="$index//item[@id = $id]"/>
				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_next" select="$index//item[@id = $id_next]"/>
				
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_prev" select="$index//item[@id = $id_prev]"/>
				
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
	</xsl:template><xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template><xsl:template name="generateIndexXrefId">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		
		<xsl:variable name="docid">
			<xsl:call-template name="getDocumentId"/>
		</xsl:variable>
		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']" priority="4">
		<xsl:apply-templates/>
		<fo:block>
		<xsl:if test="following-sibling::*[local-name() = 'clause']">
			<fo:block> </fo:block>
		</xsl:if>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'ul']" priority="4">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" priority="4">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'bookmark']" name="bookmark">
		<fo:inline id="{@id}" font-size="1pt"/>
	</xsl:template><xsl:template match="*[local-name() = 'errata']">
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
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="processBibitem">
		
		
		<!-- end BIPM bibitem processing-->
		
		
			<!-- start OGC bibtem processing -->
			<xsl:choose>
				<xsl:when test="*[local-name() = 'formattedref']">
					<xsl:apply-templates select="*[local-name() = 'formattedref']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="personalAuthors">
						<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']/*[local-name() = 'person']">
							<xsl:call-template name="processPersonalAuthor"/>
						</xsl:for-each>
						<xsl:if test="not(*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']/*[local-name() = 'person'])">
							<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='editor']/*[local-name() = 'person']">
								<xsl:call-template name="processPersonalAuthor"/>
							</xsl:for-each>
						</xsl:if>
					</xsl:variable>
					
					<xsl:variable name="city" select="*[local-name() = 'place']"/>
					<xsl:variable name="year">
						<xsl:choose>
							<xsl:when test="*[local-name() = 'date'][@type = 'published']">
								<xsl:for-each select="*[local-name() = 'date'][@type = 'published']">
									<xsl:call-template name="renderDate"/>									
								</xsl:for-each>								
							</xsl:when>
							<xsl:when test="*[local-name() = 'date'][@type = 'issued']">
								<xsl:for-each select="*[local-name() = 'date'][@type = 'issued']">
									<xsl:call-template name="renderDate"/>									
								</xsl:for-each>
							</xsl:when>
							<xsl:when test="*[local-name() = 'date'][@type = 'circulated']">
								<xsl:for-each select="*[local-name() = 'date'][@type = 'circulated']">
									<xsl:call-template name="renderDate"/>									
								</xsl:for-each>								
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="*[local-name() = 'date']">
									<xsl:call-template name="renderDate"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="uri" select="*[local-name() = 'uri']"/>
					
					
					<!-- citation structure:
					{personal names | organisation}: {document identifier}, {title}. {publisher}, {city} ({year})
					-->
					
					<!-- Author(s) -->
					<xsl:choose>
						<xsl:when test="xalan:nodeset($personalAuthors)//author">
							<xsl:for-each select="xalan:nodeset($personalAuthors)//author">
								<xsl:apply-templates/>
								<xsl:if test="position() != last()">, </xsl:if>
							</xsl:for-each>
							<xsl:text>: </xsl:text>
						</xsl:when>
						<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'abbreviation']">
							<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'abbreviation']">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">/</xsl:if>
							</xsl:for-each>
							<xsl:text>: </xsl:text>
						</xsl:when>
						<xsl:when test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">									
							<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">
								<xsl:value-of select="."/>
								<xsl:if test="position() != last()">, </xsl:if>
							</xsl:for-each>
							<xsl:text>: </xsl:text>
						</xsl:when>
					</xsl:choose>
					
					
					<xsl:variable name="document_identifier">
						<xsl:call-template name="processBibitemDocId"/>
					</xsl:variable>
					
					<xsl:value-of select="$document_identifier"/>
					
					<xsl:apply-templates select="*[local-name() = 'note']"/>
					
					<xsl:variable name="isDraft">
						<xsl:variable name="stage" select="normalize-space(*[local-name() = 'status']/*[local-name() = 'stage'])"/>						
						<xsl:if test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization'][*[local-name() = 'name']/text() = 'Open Geospatial Consortium'] and            $stage != '' and            $stage != 'published' and $stage != 'deprecated' and $stage != 'retired'">true</xsl:if>
					</xsl:variable>	 
					
					<xsl:if test="$isDraft = 'true'">
						<xsl:text> (Draft)</xsl:text>
					</xsl:if>
					
					<xsl:text>, </xsl:text>
					
					<xsl:choose>
						<xsl:when test="*[local-name() = 'title'][@type = 'main' and @language = 'en']">
							<xsl:apply-templates select="*[local-name() = 'title'][@type = 'main' and @language = 'en']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="*[local-name() = 'title']"/>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:text>. </xsl:text>
					
					<xsl:if test="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">									
						<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name']">
							<xsl:value-of select="."/>
							<xsl:if test="position() != last()">, </xsl:if>
						</xsl:for-each>
						<xsl:if test="normalize-space($city) != ''">, </xsl:if>
					</xsl:if>
					
					<xsl:value-of select="$city"/>
					
					<xsl:if test="(*[local-name() = 'contributor'][*[local-name() = 'role']/@type = 'publisher']/*[local-name() = 'organization']/*[local-name() = 'name'] or normalize-space($city) != '') and normalize-space($year) != ''">
						<xsl:text> </xsl:text>
					</xsl:if>
					
					<xsl:if test="normalize-space($year) != ''">
						<xsl:text>(</xsl:text>
						<xsl:value-of select="$year"/>
						<xsl:text>). </xsl:text>
					</xsl:if>
					
					<xsl:if test="normalize-space($uri) != ''">
						<fo:inline>
							
							<xsl:text> </xsl:text>
							<fo:basic-link external-destination="{$uri}" fox:alt-text="{$uri}">
								<xsl:value-of select="$uri"/>							
							</fo:basic-link>
						</fo:inline>
					</xsl:if>
					
				</xsl:otherwise>
			</xsl:choose>
			<!-- end OGC bibitem processing-->
		 
		
		
		 
		
		
	</xsl:template><xsl:template name="processBibitemDocId">
		<xsl:variable name="_doc_ident" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($_doc_ident) != ''">
				<xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]/@type"/>
				<xsl:if test="$type != '' and not(contains($_doc_ident, $type))">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="$_doc_ident"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]/@type"/>
				<xsl:if test="$type != ''">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if>
				<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="processPersonalAuthor">
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
	</xsl:template><xsl:template name="renderDate">		
			<xsl:if test="normalize-space(*[local-name() = 'on']) != ''">
				<xsl:value-of select="*[local-name() = 'on']"/>
			</xsl:if>
			<xsl:if test="normalize-space(*[local-name() = 'from']) != ''">
				<xsl:value-of select="concat(*[local-name() = 'from'], '–', *[local-name() = 'to'])"/>
			</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'initial']/text()" mode="strip">
		<xsl:value-of select="translate(.,'. ','')"/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'forename']/text()" mode="strip">
		<xsl:value-of select="substring(.,1,1)"/>
	</xsl:template><xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'label']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template><xsl:template name="text_input">
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
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'checkbox']">
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
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'radio']">
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
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'select']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'textarea']">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template><xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="convertDateLocalized">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_january</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '02'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_february</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '03'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_march</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '04'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_april</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '05'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_may</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '06'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_june</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '07'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_july</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '08'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_august</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '09'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_september</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '10'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_october</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '11'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_november</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '12'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_december</xsl:with-param></xsl:call-template></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="addPDFUAmeta">
		<xsl:variable name="lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
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
							
								<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()"/>									
							
							
						</xsl:variable>
						<xsl:value-of select="normalize-space($abstract)"/>
					</dc:description>
					<pdf:Keywords>
						<xsl:call-template name="insertKeywords"/>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
	</xsl:template><xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="concat(local-name(..), '_', text())"/> -->
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getLevel">
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
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<!-- <xsl:when test="parent::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when> -->
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
	</xsl:template><xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
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
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
			<xsl:with-param name="normalize-space" select="$normalize-space"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template><xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">			
			
			
			
			
			
			
			
				<xsl:value-of select="document('')//*/namespace::ogc"/>
			
			
			
			
			
						
			
			
			
			
		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template><xsl:template name="getLanguage">
		<xsl:param name="lang"/>		
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="setId">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>					
		</xsl:attribute>
	</xsl:template><xsl:template name="add-letter-spacing">
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
	</xsl:template><xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getLocalizedString">
		<xsl:param name="key"/>	
		
		<xsl:variable name="curr_lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		
		<xsl:variable name="data_value" select="normalize-space(xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang])"/>
		
		<xsl:choose>
			<xsl:when test="$data_value != ''">
				<xsl:value-of select="$data_value"/>
			</xsl:when>
			<xsl:when test="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]">
				<xsl:value-of select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$key"/></xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="setTrackChangesStyles">
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
					<!-- <xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute> -->
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="LRM" select="'‎'"/><xsl:variable name="RLM" select="'‏'"/><xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template><xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template></xsl:stylesheet>