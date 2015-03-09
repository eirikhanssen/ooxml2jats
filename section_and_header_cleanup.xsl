<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <!-- 
    This just removes the <section lvl="2"> wrapped around the first paragraphs 
    that have no <h2> element in the group, but leaves the children in place.
    
    The reason for this is to accomodate the required structure defined by the JATS tagset
    -->
    <xsl:template match="section[@lvl='2'][not(h2)]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- rename <section> to <sec> to accomodate the JATS tagset -->
    <xsl:template match="section">
        <sec>
            <xsl:comment><xsl:text> START sec lvl </xsl:text><xsl:value-of select="@lvl"></xsl:value-of><xsl:text> </xsl:text></xsl:comment>
            <xsl:apply-templates/>
            <xsl:comment><xsl:text> END of sec lvl </xsl:text><xsl:value-of select="@lvl"></xsl:value-of><xsl:text> </xsl:text></xsl:comment>
        </sec>
    </xsl:template>

    <!-- rename h2|h3|h4 elements to <title> to accomodate the JATS tagset -->
    <xsl:template match="h2|h3|h4">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>