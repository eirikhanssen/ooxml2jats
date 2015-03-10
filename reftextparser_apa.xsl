<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:j2e="https://github.com/eirikhanssen/jats2epub"
  exclude-result-prefixes="xs xlink j2e">

  <xsl:strip-space elements="*"/>

  <xsl:output method="xml"/>

  <!-- auto-tag running references in the text -->
  <!--<xsl:template match="text()">
    <xsl:analyze-string select="(\([^()]*?\))">
      <xsl:matching-substring>
        <running-text-refs>
          <xsl:value-of select="regex-group(1)"/>
        </running-text-refs>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>-->

  <!-- properly mark up footnotes in the running text -->

  <xsl:template match="footnoteReference">
    <sup>
      <xsl:element name="xref">
        <xsl:attribute name="ref-type">
          <xsl:text>fn</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="rid">
          <xsl:text>fn</xsl:text><xsl:value-of select="@fn"/>
        </xsl:attribute>
        <xsl:value-of select="@fn"/>
      </xsl:element>
    </sup>
  </xsl:template>

  <!-- identity transform, default template -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>