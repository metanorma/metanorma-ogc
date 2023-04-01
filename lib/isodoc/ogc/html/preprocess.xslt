<preprocess-xslt>
  <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mn="http://riboseinc.com/isoxml" version="1.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>
    <xsl:preserve-space elements="*"/>
    <xsl:template match="@* | node()">
      <xsl:copy><xsl:apply-templates select="@* | node()"/></xsl:copy>
    </xsl:template>
    <xsl:template match="mn:note/mn:name">
      <xsl:copy><xsl:apply-templates select="@*|node()"/><xsl:if test="normalize-space() != ''">:<mn:tab/></xsl:if></xsl:copy>
    </xsl:template>
  </xsl:stylesheet>
</preprocess-xslt>
