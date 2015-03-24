<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
   version="2.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
      <unique-words>
	<xsl:value-of select="count(//word)"/>
      </unique-words>
</xsl:template>

</xsl:stylesheet>
