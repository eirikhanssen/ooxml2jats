<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:j2e="https://github.com/eirikhanssen/jats2epub" 
    exclude-result-prefixes="xs xlink j2e w">
    
    <xsl:strip-space elements="*"/>
    
    <xsl:output method="xml" indent="yes"/>

    <xsl:include href="ooxml_parser_common.xsl"/>

    <xsl:template match="/">
        <article>
            <xsl:apply-templates/>
        </article>
    </xsl:template>

    <!-- insert footnote-refs -->
    <!--
        in the final JATS document the id of the footnote should start counting from 1, even if it
        starts counting differently in the source document
    -->
    <xsl:template match="w:r[w:footnoteReference]">
        <xsl:variable name="footnoteId" select="w:footnoteReference/@w:id"/>
        <xsl:element name="footnoteReference">
            <!-- footnote content should be placed directly to the back matter of the JATS xml at a later stage -->
            <xsl:attribute name="fn" select="$footnoteId"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="w:p[ancestor::w:tbl]"/>
    
    <!-- extract tables -->
    <xsl:template match="w:tbl">
        <table>
            <xsl:apply-templates mode="table"/>
        </table>
    </xsl:template>
    
    <xsl:template match="w:tr" mode="table">
        <tr>
            <xsl:apply-templates mode="table"/>
        </tr>
    </xsl:template>
    
    <xsl:template match="w:tc" mode="table">
        <td>
            <xsl:apply-templates mode="table"/>
        </td>
    </xsl:template>
    
    <xsl:template match="w:p[ancestor::w:tc]" mode="table">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
