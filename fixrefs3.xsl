<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:j2e="https://github.com/eirikhanssen/jats2epub">
  <xsl:output method="xml" indent="yes"/>

  <!-- 'debug=on|true|1' can be specified as a paramenter during runtime, and then debug output will be shown -->
  <xsl:param name="debug" as="xs:string">off</xsl:param>
  
  <xsl:variable name="debugMode" as="xs:boolean">
    <!-- decide if debugMode is on or off and assign true or false boolean to $debugMode variable -->
    <!-- case insensitive match using the "i" flag -->
    <xsl:value-of select="matches($debug , '^(on|true|1|yes)$' , 'i')"/>
  </xsl:variable>
  
  <xsl:function name="j2e:replaceAmpInAuthorstring" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <!-- replace the &amp; (preceeded by comma and optional space) before the last author in authorstring with comma -->
    <!-- then different authors in the authorstring will be separated by (last initial) (dot) (comma) -->
    <xsl:value-of select="replace($originalString, ',*?\s*&amp;' , ',')"/>
  </xsl:function>

  <xsl:function name="j2e:normalizeInitialsInAuthorstring" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of
      select="
      normalize-space(
        replace(
          replace(
              replace(
                $originalString , '(\s\c)\s' , '$1. ') ,
                '(\c{3,})(\s\c)' , '$1,$2') ,
                '(\c{3,},\s\c),' , '$1.,')
              )"/>
    <!-- (inner replace) - Correct missing dot after initial: Molander, A => Molander, A. -->
    <!-- (middle replace) - Correct missing comma after surname: Lundberg U. => Lundberg, U. -->
    <!-- (outer replace) - Correct missing dot after initial: Lund, A, = > Lund, A., -->
    <!-- (outer replace) - Correct missing dot after initial: Krantz, J, => Krantz, J., -->
  </xsl:function>

  <xsl:function name="j2e:prepareTokens" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <!-- replace comma and whitespace between two authors in authorstring with vertical bar -->
    <xsl:value-of select="replace($originalString, '(\c\.),\s*?' , '$1|')"/>
  </xsl:function>

  <xsl:function name="j2e:tokenizeAuthors" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of select="j2e:prepareTokens(j2e:replaceAmpInAuthorstring(j2e:normalizeInitialsInAuthorstring($originalString)))"/>
  </xsl:function>

  <xsl:function name="j2e:getSurnameFromTokenizedAuthor" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of select="replace($originalString, '^([^,]*),.*$' , '$1')"/>
  </xsl:function>

  <xsl:function name="j2e:getGivenNameFromTokenizedAuthor" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of select="normalize-space(replace($originalString, '^.*,(.*)$' , '$1'))"/>
  </xsl:function>

  <xsl:function name="j2e:getFirstChar" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of select="replace($originalString, '^(\c{1}).*$' , '$1')"/>
  </xsl:function>

  <xsl:function name="j2e:createRefId" as="xs:string">
    <xsl:param name="authors" as="node()*"/>
    <xsl:param name="year" as="xs:string"/>

    <xsl:variable name="authorInitials">
      <xsl:for-each select="$authors/person-group/name">
        <xsl:value-of select="j2e:getFirstChar(./surname)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:value-of select="concat($authorInitials, $year)"/>
  </xsl:function>

  <xsl:function name="j2e:createRefId" as="xs:string">
    <xsl:param name="year" as="xs:string"/>
    <xsl:value-of select="$year"/>
  </xsl:function>

  <xsl:function name="j2e:getPublisherString" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <!-- Extract publisher string from a book type reference in a reference list -->
    <!-- This function assumes $originalString to be of a book type reference; a ref that is tested to be $isBook eq true() -->
    <!-- It's important to use the lazy/non-greedy quantifiers such as *? as opposed to *
         to get the shortest possible match and not the longest possible match -->
    <!-- $1 with preceeding regex is important to allow publisher-loc such as {New York, NY: Wiley} -->
    <!-- $2 makes {, } optional, so publisher-loc such as {New York: Basic Books.} is also correctly matched. 
         This grouping should not be carried over to the output -->
    <!-- $3 allows forward-slash in publisher-loc as in {Stockholm/Stehag: Symposion.} -->
    <!-- the negated character class [^:] in $3 is important in order to match text only around the last colon
         in the case where a colon might be used earlier in the string -->
    <xsl:value-of select="normalize-space(replace($originalString , '.*?[,.\]]?\s+([^,.\]]*?\c\c+(,\s)?)?([\c/]{2,}:[^:]*?)$' , '$1$3'))"/>
  </xsl:function>

  <xsl:function name="j2e:getPublisherLoc" as="xs:string">
    <xsl:param name="publisherString" as="xs:string"/>
    <!-- Get all text before colon -->
    <xsl:value-of select="normalize-space(replace($publisherString, '^([^:]*?):.*', '$1'))"/>
  </xsl:function>

  <xsl:function name="j2e:getPublisherName" as="xs:string">
    <xsl:param name="publisherString" as="xs:string"/>
    <!-- Get all text after colon, but leave out optional dot in the end -->
    <xsl:value-of select="normalize-space(replace($publisherString, '.*?:([^:]*?)\.?$', '$1'))"/>
  </xsl:function>
  
  <xsl:function name="j2e:getEditorString" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of select="replace($originalString , '^.*?In([^()]*?)[,.\s]*?\((RE|E)ds?\.\).*$' , '$1' )"></xsl:value-of>
  </xsl:function>
  
  <xsl:function name="j2e:tokenizeEditorString" as="xs:string">
    <xsl:param name="originalString" as="xs:string"/>
    <xsl:value-of select="replace($originalString , '(,|&amp;)' , '|' )"></xsl:value-of>
  </xsl:function>

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

    <xsl:variable name="tokenizedAuthors" as="xs:string">
      <xsl:value-of select="j2e:tokenizeAuthors($authors)"/>
    </xsl:variable>

    
    <xsl:variable name="isBook" as="xs:boolean">
      <!-- Check if the end of the reference to see if it ends with a typical book type reference to a publisher -->
      <!-- Allow some flexibility in publisher-name and publisher-loc such as spaces, slash, hyphen -->
      <!-- Example publisher strings that should match:  
          [(...) Malmö: Liber.] 
          [(...) Cambridge: Polity Press.]
          [(...) Stockholm/Stehag: Symposion.]
          [(...) Stockholm: Sveriges Kommuner och Landsting.]
      -->
      <xsl:value-of select="matches($textcontent, '[-\c/]{2,}:\s+[-\c\s/]{2,}.?$')"/>
    </xsl:variable>

    <xsl:variable name="isBookChapter" as="xs:boolean">
      <xsl:value-of select="matches($textcontent, '((Re|E)ds?\.)')"/>
    </xsl:variable>

    <xsl:variable name="editorString">
      <xsl:if test="$isBookChapter eq true()">
        <xsl:value-of select="normalize-space(j2e:getEditorString($textcontent))"/>
      </xsl:if>
    </xsl:variable>
    
    <xsl:variable name="isParsableEditorString" as="xs:boolean">
      <xsl:value-of select="false()"/>
      <!-- WIP placeholder for matches() -->
    </xsl:variable>
    
    <!-- WIP placeholder hasParsablePublisherString  -->

    <!-- WIP placeholder isParsablePublisherString -->

    <!-- WIP placeholder isParsableEditorString -->

    <xsl:variable name="hasYearInParanthesis" as="xs:boolean">
      <xsl:value-of select='matches($textcontent, ".*\([0-9]{4}\).*")'/>
    </xsl:variable>

    <xsl:variable name="isUnknownRefType" as="xs:boolean">
      <xsl:value-of select="not($hasYearInParanthesis) or not($isParsableAuthorString)"/>
    </xsl:variable>

    <xsl:variable name="taggedAuthors">
      <xsl:choose>
        <xsl:when test="$isParsableAuthorString eq true()">
          <!-- process $authors -->
          <person-group person-group-type="author">
            <xsl:for-each select="tokenize($tokenizedAuthors, '\|')">
              <xsl:variable name="author" select="normalize-space(.)"/>
              <name>
                <surname>
                  <xsl:value-of select="j2e:getSurnameFromTokenizedAuthor($author)"/>
                </surname>
                <given-names>
                  <xsl:value-of select="j2e:getGivenNameFromTokenizedAuthor($author)"/>
                </given-names>
              </name>
            </xsl:for-each>
          </person-group>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="taggedEditors">
      <xsl:choose>
        <xsl:when test="$isParsableEditorString eq true()">
          <!-- WIP placeholder process $editors -->
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="publisher">
      <xsl:choose>
        <xsl:when test="$isBook eq true()">
          <publisher-loc>
            <xsl:value-of select="j2e:getPublisherLoc(j2e:getPublisherString($textcontent))"/>
          </publisher-loc>
          <publisher-name>
            <xsl:value-of select="j2e:getPublisherName(j2e:getPublisherString($textcontent))"/>
          </publisher-name>
        </xsl:when>
        <xsl:otherwise/>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="ref">
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="$isUnknownRefType eq false()">
            <xsl:value-of select="j2e:createRefId($taggedAuthors, $year)"/>
          </xsl:when>
          <xsl:when test="$hasYearInParanthesis eq true()">
            <xsl:text>___ </xsl:text>
            <xsl:value-of select="$year"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>___</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <!-- publication-type: book-chapter|book|journal -->
      <xsl:if test="$isBook eq true()">
        <xsl:attribute name="publication-type">
        <xsl:choose>
          <xsl:when test="$isBookChapter eq true()">
            <xsl:text>book-chapter</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>book</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <!-- publication-format: print|web -->

      <xsl:attribute name="publication-format">
        <xsl:choose>
          <xsl:when test="ext-link">
            <xsl:text>web</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>print</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>

      <xsl:choose>
        <xsl:when test="$isUnknownRefType eq true()">
          <mixed-citation>
            <xsl:apply-templates/>
          </mixed-citation>
        </xsl:when>

        <xsl:when test="$isUnknownRefType eq false()">
          <element-citation>
            <xsl:apply-templates select="$taggedAuthors"/>
            <year>
              <xsl:value-of select="$year"/>
            </year>
            <xsl:if test="$isBook eq true()">
              <publisher-loc>
                <xsl:value-of select="$publisher/publisher-loc"/>
              </publisher-loc>
              <publisher-name>
                <xsl:value-of select="$publisher/publisher-name"/>
              </publisher-name>
            </xsl:if>
          </element-citation>
        </xsl:when>
        <xsl:otherwise>
          <errorInXSLT/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:if test="$debugMode eq true()">
        <xsl:text>&#xa;</xsl:text>
        <debugMode>
          <debug>On</debug>
          <originalRef>
            <xsl:apply-templates/>
          </originalRef>
          <authors>
            <xsl:value-of select="$authors"/>
          </authors>
          <tokenizedAuthors>
            <xsl:value-of select="$tokenizedAuthors"/>
          </tokenizedAuthors>
          <editorstring>
            <xsl:value-of select="$editorString"/>
          </editorstring>
          <tokenizedEditorString>
            <xsl:value-of select="j2e:tokenizeEditorString($editorString)"/>
          </tokenizedEditorString>
          <publisherString><xsl:value-of select="j2e:getPublisherString($textcontent)"/></publisherString>
        </debugMode>
      </xsl:if>

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
