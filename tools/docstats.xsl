<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="words">
            <words>
                <xsl:call-template name="text"/>
            </words>    
        </xsl:variable>
        <stats>
            <words><xsl:value-of select="count($words/words/w)"/></words>
            <xref_bibr><xsl:value-of select="count(//xref[@ref-type='bibr'])"/></xref_bibr>
            <xref_footnotes><xsl:value-of select="count(//xref[@ref-type='fn'])"/></xref_footnotes>
            <xref_aff><xsl:value-of select="count(//xref[@ref-type='aff'])"/></xref_aff>
            <xref_total><xsl:value-of select="count(//xref)"/></xref_total>
            <mixed-citations><xsl:value-of select="count(//mixed-citation)"/></mixed-citations>
            <element-citations><xsl:value-of select="count(//element-citation)"/></element-citations>
            <referenced_journal_articles><xsl:value-of select="count(//element-citation[@publication-type='journal'])"/></referenced_journal_articles>
            <referenced_books><xsl:value-of select="count(//element-citation[@publication-type='book'])"/></referenced_books>
            <referenced_book-chapters><xsl:value-of select="count(//element-citation[@publication-type='book-chapter'])"/></referenced_book-chapters>
            <ref_total><xsl:value-of select="count(//ref)"/></ref_total>
            <references_web><xsl:value-of select="count(//element-citation[@publication-format='web'])"/></references_web>
            <references_print><xsl:value-of select="count(//element-citation[@publication-format='print'])"/></references_print>
            <sec><xsl:value-of select="count(//sec)"/></sec>
            <title><xsl:value-of select="count(//title)"/></title>
            <p><xsl:value-of select="count(//p)"/></p>
            <names_reflist_author><xsl:value-of select="count(//name[parent::person-group[@person-group-type='author']])"/></names_reflist_author>
            <names_reflist_editor><xsl:value-of select="count(//name[parent::person-group[@person-group-type='editor']])"/></names_reflist_editor>
            <names_article_authors><xsl:value-of select="count(//name[parent::contrib[@contrib-type='author']])"/></names_article_authors>
            <names_total><xsl:value-of select="count(//name)"/></names_total>
            <elements_in_total><xsl:value-of select="count(//*)"/></elements_in_total>
        </stats>
        
    </xsl:template>
    <xsl:template match="//text()" name="text">
        <xsl:for-each select="tokenize(. , '\s')">
            <xsl:if test="matches(., '[^\s]')">
                <w>
                    <xsl:value-of select="."/>
                </w>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
