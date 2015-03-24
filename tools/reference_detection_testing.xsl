<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml" indent="yes"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select="//textRefs"/>
    <stats>
      <textRefs><xsl:value-of select="count(//textRefs)"/></textRefs>
    </stats>
  </xsl:template>  
  
  <xsl:template match="textRefs">
    <!-- further processing of contents inside, identify types of text references, number of text references contained, tokenize them -->
    <textRefs>
      <xsl:apply-templates/>
    </textRefs>
  </xsl:template>
  
  <!-- identify paranthesized text that is not in textRefs elements -->
  
  <!-- identity transform, default template -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>