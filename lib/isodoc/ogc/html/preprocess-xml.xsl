<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:mn="https://www.metanorma.org/ns/ogc"
xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="xml"
version="1.0"
encoding="UTF-8"
indent="no"/>
<xsl:preserve-space elements="*"/>

<!-- note/name -->
<xsl:template match="mn:note/mn:name">
  <xsl:copy><xsl:apply-templates select="normalize-space(@*|node())" /><xsl:if test="normalize-space() != ''"><xsl:text>:</xsl:text><mn:tab/></xsl:if></xsl:copy>
</xsl:template>
</xsl:stylesheet>
