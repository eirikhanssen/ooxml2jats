<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="/references">
    <ref-list>
      <xsl:apply-templates/>
    </ref-list>
  </xsl:template>
  
  <xsl:template match="references/p">
    <xsl:variable name="textcontent" select="."/>
    <xsl:element name="ref">
      <xsl:variable name="autogenID">
        <xsl:analyze-string select="$textcontent" regex="(.*)\(([0-9]{{4}})\)">
          <xsl:matching-substring>
            <xsl:variable name="authors" select="regex-group(1)"/>
            <xsl:variable name="modauthors" select="replace($authors,'\.\s*[,]*\s*&amp;','.,')"/>
            <xsl:for-each select="tokenize($modauthors, '\.,')">
              <xsl:variable name="auth" select="."/>
              <xsl:analyze-string select="$auth" regex="\s*([\c]{{1}}).*">
                <xsl:matching-substring>
                  <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
              </xsl:analyze-string>
            </xsl:for-each>
            <!-- string-join() -->
            <!--<authors><xsl:value-of select="$authors"/></authors>-->
            <!--<modauthors><xsl:value-of select="$modauthors"/></modauthors>-->
            <xsl:value-of select="regex-group(2)"/>
          </xsl:matching-substring>
          <!--<xsl:non-matching-substring>
        <nomatch><xsl:value-of select="$textcontent"/></nomatch>
      </xsl:non-matching-substring>-->
        </xsl:analyze-string>
      </xsl:variable>
      <xsl:attribute name="id">
        <xsl:value-of select="$autogenID"/>
      </xsl:attribute>
      <textcontent>
        <xsl:value-of select="$textcontent"/>
      </textcontent>
      <!-- generate ID based on regex pattern-matching of the string before the first opening paranthesis + year in paranthesis (requires xslt>=2.0 -->
      <xsl:element name="mixed-citation">
        <xsl:if test="ext-link">
          <xsl:attribute name="publication-format">
            <xsl:value-of select="'web'"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
