<?xml version="1.0"?>
<p:declare-step version="1.0" name="ooxml2jats" xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" exclude-inline-prefixes="c">

    <p:input port="source">
        <p:document href="source/ooxml-unpacked/word/document.xml"/>
    </p:input>

    <!--    <p:input port="footnotes" kind="parameter"/>-->

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
                    <c:param name="footnotes" value="source/ooxml-unpacked/word/footnotes.xml"/>
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

    <p:identity/>

</p:declare-step>
