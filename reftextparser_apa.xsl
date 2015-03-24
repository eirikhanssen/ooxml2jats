<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:j2e="https://github.com/eirikhanssen/jats2epub"
  exclude-result-prefixes="xs xlink j2e">

  <xsl:strip-space elements="*"/>

  <xsl:output method="xml"/>

  <xsl:function name="j2e:isAssumedToBeReference" as="xs:boolean">
    <!-- decide if text is a running text reference or not -->
    <!-- Return true or false. -->
    <!--
      It is assumed that if the contents of the parenthesis ends with 4 digits and optionally space before the closing parenthesis
      then it must contain atleast one running text reference
    -->
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of select="matches( $originalString , '\d{4}')"/>
  </xsl:function>
  
  <xsl:function name="j2e:citationSplitter" as="item()*">
    <!-- break up the citation-string to individual references -->
    <xsl:param name="originalString" as="xs:string"/>
    
    <!-- testing function output -->
    <xsl:analyze-string select="$originalString" regex="(;\s*|(/d/d/d/d),\s*)">
      <xsl:matching-substring> <xsl:value-of select="regex-group(2)"></xsl:value-of><xsl:text>|</xsl:text> </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <!-- auto-tag running references in the text -->
  <!-- WIP also need to do this for references in back/fn-group/p and possibly in title elements as well -->
  <xsl:template match="p[ancestor::body]/text()">
    <!-- select text that is parenthesized and analyze it further to see if it contains references or not -->
    <xsl:analyze-string select="." regex="(\([^()]*?\))">
      <xsl:matching-substring>
        <xsl:choose>
          <xsl:when test="j2e:isAssumedToBeReference(regex-group(1)) eq true()">
            <textRefs>
                <!-- <xsl:value-of select="regex-group(1)"/>-->
              <xsl:sequence select="j2e:citationSplitter(regex-group(1))"/>
            </textRefs>
          </xsl:when>
          <xsl:otherwise>
            <!-- uncomment <unmatched> to debug refparsing -->
            <!--<unmatched>-->
            <xsl:value-of select="."/>
            <!--</unmatched>-->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <!-- for all text that is not in paranthesis, just copy unmodified -->
        <xsl:copy/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>

  <!-- properly mark up footnotes in the running text -->

  <xsl:template match="footnoteReference">
    <sup>
      <xsl:element name="xref">
        <xsl:attribute name="ref-type">
          <xsl:text>fn</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="rid">
          <xsl:text>fn</xsl:text><xsl:value-of select="@fn"/>
        </xsl:attribute>
        <xsl:value-of select="@fn"/>
      </xsl:element>
    </sup>
  </xsl:template>

  <!-- identity transform, default template -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>