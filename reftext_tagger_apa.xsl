<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:j2e="https://github.com/eirikhanssen/jats2epub" version="2.0" exclude-result-prefixes="xs xlink j2e">
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml"/>
  
  <xsl:function name="j2e:hasOnlySingleYear" as="xs:boolean">
    <xsl:param name="textRefNode" as="element(textRefs)"/>
    <xsl:value-of select="matches($textRefNode, '\(\d\d\d\d\)' )"/>
  </xsl:function>
  
  <xsl:function name="j2e:hasOneAuthorOneYear" as="xs:boolean">
    <xsl:param name="textRefNode" as="element(textRefs)"/>
    <xsl:value-of select="matches($textRefNode, '^\([\c]+,\s*\d{4}\)$' )"/>
  </xsl:function>
  
  <xsl:function name="j2e:createXrefSingleYear" as="element(xref)">
    <xsl:param name="textRefNode" as="element(textRefs)"/>
    <xsl:variable name="textRefPrecidingSiblingTextNode" as="xs:string" select="$textRefNode/preceding-sibling::text()[1]"/>
    <xsl:analyze-string select="$textRefNode" regex="^(\()([^()]{{4}})(\))$">
      <xsl:matching-substring>
        <xsl:variable name="year" select="regex-group(2)"/>
        <xsl:element name="xref">
          <xsl:attribute name="ref-type">bibr</xsl:attribute>
          <xsl:attribute name="id" select="concat('___', $year)"/>
          <xsl:attribute name="preceding-text" select="$textRefPrecidingSiblingTextNode"/>
          <xsl:value-of select="$year"/>
        </xsl:element>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:copy/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>
  
  <xsl:function name="j2e:createXrefOneAuthorOneYear" as="element(xref)">
    <xsl:param name="textRefNode" as="element(textRefs)"/>
    <xsl:analyze-string select="$textRefNode" regex="^\(([-\c]+),\s*(\d{{4}})\)$">
      <xsl:matching-substring>
        <xsl:variable name="year" select="regex-group(2)"/>
        <xsl:variable name="surname" select="regex-group(1)"/>
        <xsl:variable name="author_surname_caps" select="replace($surname , '\P{Lu}','')">
        </xsl:variable>
        <xsl:element name="xref">
          <xsl:attribute name="ref-type">bibr</xsl:attribute>
          <xsl:attribute name="id" select="concat($author_surname_caps, $year)"/>
          <xsl:value-of select="replace(regex-group(0), '(^\(|\)$)','')"/>
        </xsl:element>
      </xsl:matching-substring>
      
      <xsl:non-matching-substring>
        <xsl:copy/>
      </xsl:non-matching-substring>
      
    </xsl:analyze-string>
    
  </xsl:function>
  
  <xsl:template match="textRefs">
    <xsl:element name="textRefs">
      <xsl:choose>
        <xsl:when test="j2e:hasOnlySingleYear(.) eq true()">
          <xsl:attribute name="type">
            <xsl:value-of select="'hasOnlySingleYear'"/>
          </xsl:attribute>
          <xsl:text>(</xsl:text><xsl:sequence select="j2e:createXrefSingleYear(.)"/><xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:when test="j2e:hasOneAuthorOneYear(.) eq true()">
          <xsl:attribute name="type">
            <xsl:value-of select="'hasOneAuthorOneYear'"/>
          </xsl:attribute>
          <xsl:text>(</xsl:text><xsl:sequence select="j2e:createXrefOneAuthorOneYear(.)"/><xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <!-- identity transform, default template -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="node()|@*"/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
