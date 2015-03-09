<?xml version="1.0"?>
<p:declare-step version="1.0" xmlns:p="http://www.w3.org/ns/xproc" name="fixrefs-pipeline">

  

  <p:input port="source">
    <p:document href="refs.temp.xml"/>
  </p:input>

  <p:output port="result"/>
  <p:serialization port="result" indent="true"/>

  <p:xslt name="fixrefs" version="2.0">
    <p:input port="source">
      <p:pipe step="fixrefs-pipeline" port="source"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="fixrefs.xsl"/>
    </p:input>
    <p:input port="parameters">
      <p:empty/>
    </p:input>
  </p:xslt>

  <p:identity/>

</p:declare-step>
