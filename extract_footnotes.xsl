<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  exclude-result-prefixes="xs w">

  <xsl:strip-space elements="*"/>

  <xsl:output method="xml" indent="yes"/>

  <xsl:include href="ooxml_parser_common.xsl"/>

  <xsl:template match="/">
    <xsl:call-template name="extract_footnotes"/>
  </xsl:template>

  <xsl:template name="extract_footnotes">
    <fn-group>
      <xsl:for-each select="$footnotes_in_doc/w:footnote">
        <xsl:choose>
          <xsl:when test="not( matches( @w:type , 'continuationSeparator|separator' ) )">
            <xsl:element name="fn">
              <xsl:attribute name="id">
                <xsl:value-of select="concat( 'fn', @w:id )"/>
              </xsl:attribute>
              <xsl:apply-templates/>
            </xsl:element>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </fn-group>
  </xsl:template>

</xsl:stylesheet>
