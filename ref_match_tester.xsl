<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!-- check all parantheses to see if they are assumed to be refs or are unmatched -->
  <!-- need to make sure unmatched refs are marked up as unmatched in reftextparser_apa.xsl -->
  <xsl:template match="/">
    <paranthesized_text>
      <xsl:apply-templates/>
    </paranthesized_text>
  </xsl:template>
  
  <xsl:template match="text()"/>
  <xsl:template match="text()[parent::refsAssumed]">
    <refsAssumed>
      <xsl:value-of select="."/>
    </refsAssumed>
  </xsl:template>
  
  <xsl:template match="text()[parent::unmatched]">
    <noRef>
      <xsl:value-of select="."/>
    </noRef>
  </xsl:template>
</xsl:stylesheet>