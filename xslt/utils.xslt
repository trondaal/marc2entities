<!-- Templates from this file are copied into the conversion file by make.xsl --><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:frbrizer="http://idi.ntnu.no/frbrizer/" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:param name="debug" as="xs:boolean" select="false()"/>
    <xsl:param name="lexical" as="xs:boolean" select="false()"/>
    <xsl:param name="include_MARC001_in_entityrecord" as="xs:boolean" select="false()"/>
    <xsl:param name="include_MARC001_in_controlfield" as="xs:boolean" select="false()"/>
    <xsl:param name="include_MARC001_in_subfield" as="xs:boolean" select="false()"/>
    <!--<xsl:param name="include_labels" as="xs:boolean" select="false()"/>-->
    <xsl:param name="include_anchorvalues" as="xs:boolean" select="false()"/>
    <xsl:param name="include_templateinfo" as="xs:boolean" select="false()"/>
    <xsl:param name="include_sourceinfo" as="xs:boolean" select="false()"/>
    <xsl:param name="include_keyvalues" as="xs:boolean" select="false()"/>
    <xsl:param name="include_internal_key" as="xs:boolean" select="false()"/>
    <xsl:param name="include_counters" as="xs:boolean" select="false()"/>
    <xsl:param name="UUID_identifiers" as="xs:boolean" select="true()"/>
    <xsl:param name="merge" as="xs:boolean" select="true()"/>
    <xsl:param name="include_id_as_element" as="xs:boolean" select="false()"/>
    <xsl:param name="include_missing_reverse_relationships" as="xs:boolean" select="true()"/>
    <!--<xsl:param name="include_target_entity_type" as="xs:boolean" select="false()"/>-->
    <xsl:param name="include_entity_labels" as="xs:boolean" select="true()"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <!--Template for copying subfield content. This template is used by the entity-templates-->
    <xsl:template name="copy-content">
        <xsl:param name="type" required="no" select="''"/>
        <xsl:param name="subtype" required="no" select="''"/>
        <xsl:param name="label" required="no" select="''"/>
        <xsl:param name="select" required="no"/>
        <xsl:param name="marcid" required="no"/>
        <xsl:call-template name="copy-attributes"/>
        <xsl:if test="$type ne ''">
            <xsl:attribute name="type" select="$type"/>
        </xsl:if>
        <xsl:if test="$subtype ne ''">
            <xsl:attribute name="subtype" select="$subtype"/>
        </xsl:if>
        <xsl:value-of select="normalize-space($select)"/>
        <xsl:if test="$include_MARC001_in_controlfield">
            <xsl:if test="string($marcid) ne ''">
                <xsl:element name="frbrizer:mid">
                    <xsl:attribute name="i" select="$marcid"/>
                </xsl:element>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!--Template for copying the attributes of an element -->
    <xsl:template name="copy-attributes">
        <xsl:for-each select="@*">
            <xsl:copy/>
        </xsl:for-each>
    </xsl:template>
    <!-- Template for replacing internal keys with descriptive keys -->
    <xsl:template match="*:record-set" mode="replace-keys" name="replace-keys">
        <xsl:param name="keymapping" required="yes"/>
        <xsl:copy>
            <xsl:call-template name="copy-attributes"/>
            <xsl:for-each select="*:record">
                <xsl:variable name="record_id" select="@id"/>
                <xsl:choose>
                    <xsl:when test="$keymapping//*:keyentry[@id = $record_id]">
                        <xsl:copy>
                            <xsl:for-each select="@*">
                                <xsl:choose>
                                    <xsl:when test="local-name() = 'id'">
                                        <xsl:attribute name="id" select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:if test="$include_sourceinfo">
                                <xsl:element name="frbrizer:source">
                                    <xsl:attribute name="c" select="1"/>
                                    <xsl:value-of select="$record_id"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$include_keyvalues">
                                <xsl:element name="frbrizer:keyvalue">
                                    <xsl:if test="$include_counters">
                                        <xsl:attribute name="f.c" select="1"/>
                                    </xsl:if>
                                    <xsl:value-of select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$include_id_as_element">
                                <xsl:element name="frbrizer:idvalue">
                                    <xsl:attribute name="c" select="'1'"/>
                                    <xsl:attribute name="id" select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                    <xsl:value-of select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:for-each select="node()">
                                <xsl:choose>
                                    <xsl:when test="@href = $keymapping//*:keyentry/@id">
                                        <xsl:variable name="temp" select="@href"/>
                                        <xsl:copy>
                                            <xsl:for-each select="@*">
                                                <xsl:choose>
                                                  <xsl:when test="local-name() = 'href'">
                                                  <xsl:attribute name="href" select="$keymapping//*:keyentry[@id = $temp]/@key"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="."/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                            <xsl:for-each select="node()">
                                                <xsl:copy-of select="."/>
                                            </xsl:for-each>
                                        </xsl:copy>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:when test="exists(*:relationship[@href = $keymapping//*:keyentry/@id])">
                        <xsl:copy>
                            <xsl:call-template name="copy-attributes"/>
                            <xsl:for-each select="node()">
                                <xsl:choose>
                                    <xsl:when test="local-name() = 'relationship'">
                                        <xsl:variable name="href" select="@href"/>
                                        <xsl:copy>
                                            <xsl:for-each select="@*">
                                                <xsl:choose>
                                                  <xsl:when test="local-name() = 'href' and exists($keymapping//*:keyentry[@id = $href]/@key)">
                                                  <xsl:attribute name="href" select="$keymapping//*:keyentry[@id = $href]/@key[1]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="."/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                            <xsl:copy-of select="frbrizer:mid"/>
                                        </xsl:copy>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:sort-keys">
        <xsl:param name="keys"/>
        <xsl:perform-sort select="distinct-values($keys)">
            <xsl:sort select="."/>
        </xsl:perform-sort>
    </xsl:function>
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:sort-relationships">
        <xsl:param name="relationships"/>
        <xsl:perform-sort select="$relationships">
            <xsl:sort select="@id"/>
        </xsl:perform-sort>
    </xsl:function>
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:trimsort-targets">
        <xsl:param name="relationships"/>
        <xsl:perform-sort select="for $r in distinct-values($relationships) return local:trim-target($r)">
            <xsl:sort select="."/>
        </xsl:perform-sort>
    </xsl:function>
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:trim-target">
        <xsl:param name="value" as="xs:string"/>
        <xsl:value-of select="let $x := $value return if (matches($x, '\w+:(/?/?)[^\s]+')) then (tokenize(replace($x, '/$', ''), '/'))[last()] else $x"/>
    </xsl:function>   
    <xsl:template match="*:record-set" mode="create-inverse-relationships">
        <xsl:if test="$include_missing_reverse_relationships">
            <xsl:variable name="record-set" select="."/>
            <xsl:copy>
                <xsl:for-each select="*:record">
                    <xsl:variable name="record" select="."/>
                    <xsl:variable name="this-entity-id" select="@id"/>
                    <xsl:copy>
                        <xsl:copy-of select="@* | node()"/>
                        <xsl:for-each select="$record-set/*:record[*:relationship[(@href = $this-entity-id)]]">
                            <xsl:variable name="target-entity-type" select="@type"/>
                            <xsl:variable name="target-entity-label" select="@label"/>
                            <xsl:variable name="target-entity-id" select="@id"/>
                            <xsl:for-each select="*:relationship[(@href eq $this-entity-id) and exists(@itype)]">
                                <xsl:variable name="rel-type" select="@type"/>
                                <xsl:variable name="rel-itype" select="@itype"/>
                                <xsl:if test="not(exists($record/*:relationship[@href eq $target-entity-id and @itype = $rel-type and @type = $rel-itype]))">
                                    <xsl:copy>
                                        <xsl:if test="exists(@itype)">
                                            <xsl:attribute name="type" select="@itype"/>
                                        </xsl:if>
                                        <xsl:if test="exists(@type)">
                                            <xsl:attribute name="itype" select="@type"/>
                                        </xsl:if>
                                        <xsl:if test="exists(@isubtype)">
                                            <xsl:attribute name="subtype" select="@isubtype"/>
                                        </xsl:if>
                                        <xsl:if test="exists(@subtype)">
                                            <xsl:attribute name="isubtype" select="@subtype"/>
                                        </xsl:if>
                                        <xsl:if test="$include_counters">
                                            <xsl:attribute name="c" select="'1'"/>
                                        </xsl:if>
                                        <xsl:attribute name="href" select="$target-entity-id"/>
                                        <xsl:copy-of select="node()"/>
                                    </xsl:copy>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:for-each>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    <xsl:template match="/*:collection" mode="merge" name="merge">
        <xsl:param name="ignore_indicators_in_merge" select="false()" required="no"/>
        <xsl:copy>
            <xsl:for-each-group select="//*:record" group-by="@id">
                <xsl:sort select="@type"/>
                <xsl:sort select="@subtype"/>
                <xsl:sort select="@id"/>
                <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                    <xsl:attribute name="id" select="current-group()[1]/@id"/>
                    <xsl:attribute name="type" select="current-group()[1]/@type"/>
                    <xsl:if test="exists(current-group()/@subtype)">
                        <xsl:attribute name="subtype">
                            <xsl:variable name="temp">
                                <xsl:perform-sort select="string-join(distinct-values(current-group()/@subtype[. ne '']), '-')">
                                    <xsl:sort select="."/>
                                </xsl:perform-sort>
                            </xsl:variable>
                            <xsl:value-of select="string-join($temp, '/')"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="current-group()[1]/@label">
                        <xsl:attribute name="label" select="current-group()[1]/@label"/>
                    </xsl:if>
                    <xsl:if test="current-group()[1]/@c">
                        <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                    </xsl:if>
                    <xsl:for-each-group select="current-group()/*:controlfield" group-by="string-join((@tag, @type, string(.)), '')">
                        <xsl:sort select="@tag"/>
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:copy-of select="@* except @c"/>
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                            <xsl:for-each-group select="current-group()/*:mid" group-by="@i">
                                <xsl:for-each select="distinct-values(current-group()/@i)">
                                    <frbrizer:mid>
                                        <xsl:attribute name="i" select="."/>
                                    </frbrizer:mid>
                                </xsl:for-each>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:datafield" group-by="normalize-space(string-join(((@tag), @type,                             (if ($ignore_indicators_in_merge) then                                 ()                             else                                 (@ind1, @ind2)), *:subfield/@code, *:subfield/@type, *:subfield/text()), ''))">
                        <xsl:sort select="@tag"/>
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:copy-of select="current-group()[1]/@tag"/>
                            <xsl:copy-of select="current-group()[1]/@ind1"/>
                            <xsl:copy-of select="current-group()[1]/@ind2"/>
                            <xsl:copy-of select="current-group()[1]/@type"/>
                            <xsl:copy-of select="current-group()[1]/@subtype"/>
                            <xsl:copy-of select="current-group()[1]/@label"/>
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:for-each-group select="current-group()/*:subfield" group-by="concat(@code, @type, text())">
                                <xsl:sort select="@code"/>
                                <xsl:sort select="@type"/>
                                <xsl:for-each select="distinct-values(current-group()/text())">
                                    <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                        <xsl:copy-of select="current-group()[1]/@code"/>
                                        <xsl:copy-of select="current-group()[1]/@type"/>
                                        <xsl:copy-of select="current-group()[1]/@subtype"/>
                                        <xsl:if test="current-group()[1]/@label">
                                            <xsl:copy-of select="current-group()[1]/@label"/>
                                        </xsl:if>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each-group>
                            <xsl:for-each-group select="current-group()/*:mid" group-by="@i">
                                <xsl:for-each select="distinct-values(current-group()/@i)">
                                    <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                        <xsl:attribute name="i" select="."/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:relationship" group-by="concat(@type, @href, @subtype)">
                        <xsl:sort select="@type"/>
                        <xsl:sort select="@subtype"/>
                        <xsl:sort select="@id"/>
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:copy-of select="@* except (@c | @ilabel | @itype | @isubtype)"/>
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:for-each-group select="current-group()/*:mid" group-by="@i">
                                <xsl:for-each select="distinct-values(current-group()/@i)">
                                    <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                        <xsl:attribute name="i" select="."/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:template" group-by=".">
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/mid" group-by="@i">
                        <xsl:for-each select="distinct-values(current-group()/@i)">
                            <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                <xsl:attribute name="i" select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:anchorvalue" group-by=".">
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:idvalue" group-by="@id">
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:if test="current-group()[1]/@id">
                                <xsl:copy-of select="current-group()/@id"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:source" group-by=".">
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:keyvalue" group-by=".">
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:label" group-by=".">
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="normalize-space(current-group()[1])"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:intkey" group-by=".">
                        <xsl:element name="intkey">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="/*:collection" mode="rdfify" name="rdfify" xmlns:map="http://www.w3.org/2005/xpath-functions/map">
        <xsl:variable name="collection" select="."/>
        <rdf:RDF>
            <xsl:for-each select="in-scope-prefixes($collection)">
                <xsl:variable name="prefix" select="."/>
                <xsl:variable name="uri" select="namespace-uri-for-prefix(., $collection)"/>
                <xsl:if test="$prefix ne '' and not(starts-with($prefix, 'xs'))">
                    <xsl:namespace name="{$prefix}" select="$uri"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:variable name="prefixmap" select="map:merge(for $i in in-scope-prefixes($collection) return map{namespace-uri-for-prefix($i, $collection) : $i})"/>
            
            <xsl:for-each-group select="//*:record[starts-with(@type, 'http')]" group-by="@id, @type" composite="yes">
                <xsl:variable name="entity_type" select="tokenize(@type, '[/#]')[last()]"/>
                <xsl:variable name="entity_namespace" select="replace(@type, $entity_type, '')"/>
                <xsl:try>
                    <xsl:element name="{$prefixmap($entity_namespace) || ':' || $entity_type}" namespace="{$entity_namespace}">
                        <xsl:attribute name="rdf:about" select="if (starts-with(@id, 'http')) then @id else 'http://example.org/'||@id" />
                        <xsl:for-each-group select="current-group()//(*:subfield, *:controlfield)[starts-with(@type, 'http')]" group-by="@type, replace(lower-case(text()), '[^A-Za-z0-9]', '')" composite="yes">
                            <xsl:variable name="property_type" select="tokenize(@type, '[/#]')[last()]"/>
                            <xsl:variable name="property_namespace" select="replace(@type, $property_type, '')"/>
                            <xsl:element name="{$prefixmap($property_namespace) || ':' || $property_type}" namespace="{$property_namespace}">
                                <xsl:copy-of select="current-group()[1]/text()"/>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each-group select="current-group()/*:relationship[starts-with(@type, 'http')]" group-by="@type, @href" composite="yes">
                            <xsl:sort select="@type"/>
                            <xsl:variable name="property_type" select="tokenize(@type, '[/#]')[last()]"/>
                            <xsl:variable name="property_namespace" select="replace(@type, $property_type, '')"/>
                            <xsl:element name="{$prefixmap($property_namespace) || ':' || $property_type}" namespace="{$property_namespace}">
                                <xsl:attribute name="rdf:resource" select="if(starts-with(current-group()[1]/@href, 'http')) then current-group()[1]/@href else 'http://example.org/'||current-group()[1]/@href" />
                            </xsl:element>                        
                        </xsl:for-each-group>
                    </xsl:element>
                    <xsl:catch xmlns:err="http://www.w3.org/2005/xqt-errors">
                            <xsl:message terminate="no">
                                <xsl:value-of select="'Error converting to rdf in record:'"/>
                                <xsl:copy-of select="."></xsl:copy-of>  
                            </xsl:message>                       
                    </xsl:catch>
                </xsl:try>
            </xsl:for-each-group>
        </rdf:RDF>
    </xsl:template>
</xsl:stylesheet>