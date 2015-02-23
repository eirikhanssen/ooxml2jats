<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema">
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

    <xsl:variable name="isBookChapter" as="xs:boolean">
      <xsl:value-of select="matches($textcontent, '(Eds\.)')"/>
    </xsl:variable>
    
    <xsl:variable name="hasYearInParanthesis" as="xs:boolean">
      <xsl:value-of select='matches($textcontent, ".*\([0-9]{4}\).*")'/>
    </xsl:variable>

    <xsl:variable name="isUnknownRefType" as="xs:boolean">
      <xsl:value-of select="not($hasYearInParanthesis)"></xsl:value-of>
    </xsl:variable>

    <xsl:variable name="year">
      <xsl:analyze-string select="$textcontent" regex=".*\(([0-9]{{4}})\)">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:variable name="authors">
      <xsl:analyze-string select="$textcontent" regex="([^(]*)[(]">
        <xsl:matching-substring>
          <xsl:value-of select="regex-group(1)"/>
        </xsl:matching-substring>
      </xsl:analyze-string>
    </xsl:variable>

    <xsl:element name="ref">
      <xsl:attribute name="isBookChapter">
        <xsl:value-of select="$isBookChapter"/>
      </xsl:attribute>

      <xsl:attribute name="hasYearInParanthesis">
        <xsl:value-of select="$hasYearInParanthesis"/>
      </xsl:attribute>
      
      <!--<xsl:attribute name="unknown">
        <xsl:value-of select="$isUnknownRefType"/>
      </xsl:attribute>-->

      <xsl:choose>
        <xsl:when test="$isUnknownRefType eq true()">
          <mixed-citation>
            <!--<isUnknownRefTypeState>
              <xsl:value-of select="$isUnknownRefType"></xsl:value-of>
            </isUnknownRefTypeState>-->
            <xsl:value-of select="$textcontent"/>
          </mixed-citation>
        </xsl:when>
        <xsl:when test="$isUnknownRefType eq false()">
          <element-citation>
            <!--<isUnknownRefTypeState>
              <xsl:value-of select="$isUnknownRefType"></xsl:value-of>
            </isUnknownRefTypeState>-->
            <authors>
              <xsl:value-of select="$authors"/>
            </authors>
            <year>
              <xsl:value-of select="$year"/>
            </year>
          </element-citation>
        </xsl:when>
        <xsl:otherwise>
        <error/>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
