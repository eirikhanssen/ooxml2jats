<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- for <p> elements with position less than 3 ( the two first p-elements ) -->
    <!-- if it has child element <bold> that has just the text Abstract or Keywords -->
    <!-- 
        then delete that child <bold> child element, rename this element to abstract or keywords,
        and remove colon and space from the beginning of the text() node following 
    -->

    <xsl:template match="p[position() &lt; 3][bold]">
        <xsl:choose>
            <xsl:when test="matches(bold[1], '^Abstract[:]\s*$')">
                <abstract>
                    <xsl:apply-templates mode="abstract_and_keywords"/>
                </abstract>
            </xsl:when>
            <xsl:when test="matches(bold[1], '^Keywords[:]?\s*$')">
                <keywords>
                    <xsl:apply-templates mode="abstract_and_keywords"/>
                </keywords>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="bold" mode="abstract_and_keywords">
        <xsl:choose>
            <xsl:when test="matches(. , '^Abstract[:]?\s*$|^Keywords[:]?\s*$')"></xsl:when>
            <xsl:otherwise>
                <bold>
                    <xsl:apply-templates/>
                </bold>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- remove colon and space from the beginning of the string inside abstract and keywords -->
    <xsl:template match="text()[1]" mode="abstract_and_keywords">
        <xsl:analyze-string select="." regex="^(:|\s)\s*">
            <xsl:matching-substring/>
            <xsl:non-matching-substring>
                <xsl:copy/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>