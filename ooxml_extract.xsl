<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:j2e="https://github.com/eirikhanssen/jats2epub" 
    exclude-result-prefixes="xs xlink j2e w">
    
    <xsl:strip-space elements="*"/>
    
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="footnotes" as="xs:string"/>
    <xsl:variable name="styles" select="doc('stylemap.xml')/styles/style"/>
    <xsl:variable name="footnotes_in_doc" select="doc($footnotes)/w:footnotes"/>

    <xsl:template match="/">
        <document>
            <xsl:apply-templates select=".//w:p"/>
        </document>
    </xsl:template>

    <xsl:template match="w:p">
        <xsl:variable name="elName"
            select="$styles[name=current()/w:pPr/w:pStyle/@w:val]/transformTo"/>
        <xsl:choose>
            <xsl:when test="$elName != ''">
                <xsl:element name="{$elName}">
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- paragraphs without a listed style are just plain p's -->
                <!-- generate this p-element only if there is textcontent and it contains non-whitespace characters -->
                <xsl:if test="matches(. , '[^\s]')">
                    <p>
                        <xsl:apply-templates select="*"/>
                    </p>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="w:r">
        <xsl:variable name="elName"
            select="$styles[name=current()/w:rPr/w:rStyle/@w:val]/transformTo"/>
        <xsl:choose>
            <xsl:when test="$elName != ''">
                <xsl:element name="{$elName}">
                    <xsl:apply-templates select="*"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- preserve italic formatting -->
    <xsl:template match="w:t[../w:rPr/w:i]">
        <italic><xsl:value-of select="."/></italic>
    </xsl:template>
    
    <!-- preserve bold formatting -->
    <xsl:template match="w:t[../w:rPr/w:b]">
        <bold><xsl:value-of select="."/></bold>
    </xsl:template>
    
    <!-- mark up hyperlinks as uri -->
    <xsl:template match="w:t[ancestor::w:hyperlink]">
        <uri><xsl:value-of select="."/></uri>
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

</xsl:stylesheet>
