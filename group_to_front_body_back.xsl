<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:template match="article">
        <article>
            <front>
                <journal-meta/>
                <article-meta>
                    <title-group>
                        <article-title>
                            <xsl:apply-templates select="article-title"/>
                        </article-title>
                        <xsl:apply-templates select="abstract"/>
                        <kwd-group kwd-group-type="author-generated">
                            <xsl:for-each select="tokenize(keywords, ',')">
                                <kwd><xsl:value-of select="normalize-space(.)"/></kwd>
                            </xsl:for-each>
                        </kwd-group>
                    </title-group>
                </article-meta>
            </front>
            <body>
                <xsl:for-each-group select="p|h1|h2|h3|h4" group-starting-with="h2">
<!--                    <xsl:choose>-->
<!--                        <xsl:when test="current-group()[self::h2]">-->
                            <section lvl="2">
                                <xsl:for-each-group select="current-group()" group-starting-with="h3">
                                    <xsl:choose>
                                        <xsl:when test="current-group()[self::h3]">
                                            <section lvl="3">
                                                <xsl:apply-templates select="current-group()"/>
                                            </section>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="current-group()"/>
                                        </xsl:otherwise>
                                    </xsl:choose>    
                                </xsl:for-each-group>
                            </section>                            
                        <!--</xsl:when>-->
                        <!--<xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>-->
                    <!--</xsl:choose>-->
                    
                </xsl:for-each-group>
            </body>
            <back>
                <ref-list>
                    <xsl:apply-templates select="ref"/>                    
                </ref-list>
            </back>
        </article>
    </xsl:template>

    <xsl:template match="abstract">
        <abstract>
            <p><xsl:apply-templates/></p>
        </abstract>
    </xsl:template>

    <xsl:template match="ref">
        <ref>
            <xsl:apply-templates/>
        </ref>
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    <!--
    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>-->
    
</xsl:stylesheet>