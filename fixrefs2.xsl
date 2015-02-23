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

    <xsl:variable name="authors">
      
        <xsl:analyze-string select="$textcontent" regex="(.*)\(([0-9]{{4}})\)">
          <xsl:matching-substring>
            <xsl:variable name="authorstring" select="regex-group(1)"/>
            <xsl:variable name="authorstringNormalized"
              select="replace($authorstring,'\.\s*[,]*\s*&amp;','.,')"/>

            <xsl:for-each select="tokenize($authorstringNormalized, '\.,')">
              <xsl:variable name="auth" select="."/>
              <name><xsl:value-of select="$auth"/></name>
              <person>

              <xsl:analyze-string select="$auth" regex="\s*([^,]).*">
                <xsl:matching-substring>
                  <surname>
                    <xsl:value-of select="regex-group(1)"/>
                  </surname>
                </xsl:matching-substring>
              </xsl:analyze-string>

              <xsl:analyze-string select="$auth" regex="\s*([\c]{{1}}).*">
                <xsl:matching-substring>
                  <surInitial>
                    <xsl:value-of select="regex-group(1)"/>
                  </surInitial>
                </xsl:matching-substring>
              </xsl:analyze-string>

              <xsl:analyze-string select="$auth" regex=".*,(.*)$">
                <xsl:matching-substring>
                  <given-names>
                    <xsl:value-of select="normalize-space(regex-group(1))"/>
                  </given-names>
                </xsl:matching-substring>
              </xsl:analyze-string>
              </person>
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

    <xsl:element name="ref">

      <xsl:element name="mixed-citation">
        <xsl:if test="ext-link">
          <xsl:attribute name="publication-format">
            <xsl:value-of select="'web'"/>
          </xsl:attribute>
        </xsl:if>
<!--        <xsl:apply-templates select="$authors"/>-->
      </xsl:element>
      
      <element-citation>
        <person-group>
          <xsl:for-each select="$authors/person">
                <name><xsl:value-of select="name"></xsl:value-of></name>
                <surname><xsl:value-of select="surname"/></surname>
            <given-names><xsl:value-of select="given-names"/></given-names>
              <xsl:value-of select="."/>
          </xsl:for-each>
        </person-group>
      </element-citation>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>
