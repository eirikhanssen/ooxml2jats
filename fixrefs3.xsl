<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="/references">
    <ref-list>
      <xsl:for-each select="p">
        <xsl:call-template name="refparser"/>
      </xsl:for-each>
    </ref-list>
  </xsl:template>

  <xsl:template name="refparser">

    <xsl:variable name="textcontent" select="."/>

    <xsl:variable name="year">
      <xsl:analyze-string select="$textcontent" regex=".*\(([0-9]{{4}})\)">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="authors">
      <xsl:analyze-string select="$textcontent" regex="(..*)\(\d{{4}}\)">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="isParsableAuthorString" as="xs:boolean">
      <xsl:value-of select="matches($authors, '^\s*[\c][\c]*,\s*[\c]')"/>
    </xsl:variable>

    <xsl:variable name="isBookChapter" as="xs:boolean">
      <xsl:value-of select="matches($textcontent, '(Eds\.)')"/>
    </xsl:variable>

    <xsl:variable name="hasYearInParanthesis" as="xs:boolean">
      <xsl:value-of select='matches($textcontent, ".*\([0-9]{4}\).*")'/>
    </xsl:variable>

    <xsl:variable name="isUnknownRefType" as="xs:boolean">
      <xsl:value-of select="not($hasYearInParanthesis) or not($isParsableAuthorString)"/>
    </xsl:variable>

    <xsl:element name="ref">
      <!-- publication-type: book-chapter|book|journal -->
      <xsl:if test="$isBookChapter eq true()">
        <xsl:attribute name="publication-type">
          <xsl:value-of select="'book-chapter'"/>
        </xsl:attribute>
      </xsl:if>
      <!-- publication-format: print|web -->
      <xsl:if test="ext-link">
        <xsl:attribute name="publication-format">
          <xsl:value-of select="'web'"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="$isUnknownRefType eq true()">
          <mixed-citation>
            <xsl:apply-templates/>
          </mixed-citation>
        </xsl:when>
        <xsl:when test="$isUnknownRefType eq false()">
          <element-citation>
            <authors>
              <xsl:value-of select="$authors"/>
            </authors>
            <year>
              <xsl:value-of select="$year"/>
            </year>
          </element-citation>
        </xsl:when>
        <xsl:otherwise>
          <errorInXSLT/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:element>
  </xsl:template>

  <xsl:template match="ext-link">
    <uri>
      <xsl:value-of select="./@xlink:href"/>
    </uri>
  </xsl:template>

  <xsl:template match="uri">
    <uri>
      <xsl:value-of select="."/>
    </uri>
  </xsl:template>

</xsl:stylesheet>
