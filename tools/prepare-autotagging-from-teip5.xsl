<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:j2e="https://github.com/eirikhanssen/jats2epub"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs xlink j2e tei">
  <xsl:output method="xml" indent="yes"/>

<xsl:template match="TEI">
  <article>
    <front></front>
    <body>
      <xsl:apply-templates select="text/body"/>  
    </body>
    <back></back>
  </article>
</xsl:template>

<xsl:template match="text/body">
  <xsl:apply-templates/>
</xsl:template>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="hi[@rend='italic']">
    <italic>
      <xsl:value-of select="."/>
    </italic>
  </xsl:template>
  <!--
  <xsl:template match="p">
    <ref>
      <xsl:apply-templates/>
    </ref>
  </xsl:template>-->

</xsl:stylesheet>
