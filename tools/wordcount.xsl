<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
   version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
<xsl:variable name="wordcount">
  <wordcount>
    <xsl:for-each-group group-by="." select="
          for $w in //text()/tokenize(., '\W+')[.!=''] return lower-case($w)">
      <xsl:sort select="count(current-group())" order="descending"/>
      <word word="{current-grouping-key()}" frequency="{count(current-group())}"/>
    </xsl:for-each-group>
  </wordcount>
</xsl:variable>
  <xsl:sequence select="$wordcount"/>
  <stats>
      <unique-words>
	<xsl:value-of select="count($wordcount/wordcount/word)"/>
      </unique-words>
  </stats>
</xsl:template>

</xsl:stylesheet>
