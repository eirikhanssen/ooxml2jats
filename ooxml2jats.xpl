<?xml version="1.0"?>
<p:declare-step version="1.0" name="ooxml2jats" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" exclude-inline-prefixes="c">

    <p:input port="source">
        <!--<p:document href="source/ooxml-unpacked/word/document.xml"/>-->
        <p:document href="source/nylenna-ooxml/word/document.xml"/>
    </p:input>

    <!-- <p:input port="footnotes" kind="parameter"/> -->

    <p:output port="result"/>

    <p:serialization port="result" indent="true"/>

    <p:xslt name="autotag_ooxml_firstpass" version="2.0">
        <p:input port="source">
            <p:pipe step="ooxml2jats" port="source"/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="ooxml_extract.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:inline>
                <c:param-set>
                    <!--<c:param name="footnotes" value="source/ooxml-unpacked/word/footnotes.xml"/>-->
                    <c:param name="footnotes" value="source/nylenna-ooxml/word/footnotes.xml"/>
                </c:param-set>
            </p:inline>
        </p:input>
    </p:xslt>

    <p:xslt name="autotag_ooxml_kwd_abstract" version="2.0">
        <p:input port="source"/>
        <p:input port="stylesheet">
            <p:document href="kwd_abstract.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>

    <p:rename match="p[preceding-sibling::h2='References']" new-name="ref"/>

    <p:delete match="h2[.='References']"/>

    <p:xslt name="group_to_front_body_back" version="2.0">
        <p:input port="source"/>
        <p:input port="stylesheet">
            <p:document href="group_to_front_body_back.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>

    <p:xslt name="section_and_header_cleanup" version="2.0">
        <p:input port="source"/>
        <p:input port="stylesheet">
            <p:document href="section_and_header_cleanup.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>

    <!-- parse the <ref> elements in the <ref-list> and autogenerate <element-citation> and <mixed-citation> markup -->
    <!-- refparser_apa.xsl assumes apa style formatting of references. --> 
    <!-- other citation styles can be accommodated by creating a refparser for other styles and using it here. -->
    <p:xslt name="reflistparser" version="2.0">
        <p:input port="source"/>
        <p:input port="stylesheet">
            <p:document href="reflistparser_apa.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>

    <!-- parse text nodes in <p> and <title> elements. Inspect every paranthesis using regex to see if it contains reference(s) -->
    <!--
        if it contains reference(s), try to mark each reference up using the following format:
        <xref type="bibr" rid="concat({first letter of each author's surnames}, {year})">{reference text}</xref>
        it also marks up <footnoteReference>'s to appropriate JSATS markup in the running text
    -->
    
    <p:xslt name="reftextparser" version="2.0">
        <p:input port="source"/>
        <p:input port="stylesheet">
            <p:document href="reftextparser_apa.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
    </p:xslt>

    <!-- this identity is the target of the <p:insert> step that places the footnotes xml document inside the main xml document -->

    <p:identity name="document_before_footnotes_are_inserted"/>

    <!-- extract footnotes and place them in a new xml document where <fn-group> is the root with <fn> children -->
    <!-- maybe path to footnotes.xml should be given as a parameter (it could also be derived from the location of document.xml) -->
    <!-- Later this document containing the footnotes needs to be inserted into the main document's back section -->

    <p:xslt name="extract_footnotes" version="2.0">
        <p:input port="source"/>
        <p:input port="stylesheet">
            <p:document href="extract_footnotes.xsl"/>
        </p:input>
        <p:input port="parameters">
            <p:inline>
                <c:param-set>
                    <c:param name="footnotes" value="source/ooxml-unpacked/word/footnotes.xml"/>
                </c:param-set>
            </p:inline>
        </p:input>
    </p:xslt>

    <!-- Insert footnotes into the back section of the main document -->

    <p:insert name="insert_footnotes_into_main_document" match="article/back" position="first-child">
        <p:input port="source">
            <p:pipe step="document_before_footnotes_are_inserted" port="result"/>
        </p:input>
        <p:input port="insertion">
            <p:pipe step="extract_footnotes" port="result"/>
        </p:input>
    </p:insert>
    
    <p:identity/>

</p:declare-step>
