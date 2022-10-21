<!-- Templates from this file are copied into the conversion file by make.xsl -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:frbrizer="http://idi.ntnu.no/frbrizer/" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    version="3.0">

    <xsl:param name="merge" as="xs:boolean" select="true()"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <!--Template for copying subfield content. This template is used by the entity-templates-->
    
    <xsl:variable name="prefixmap" as="map(xs:string, xs:string)">
        <xsl:map/>
    </xsl:variable>
    <xsl:function name="frbrizer:create-class-name">
        <xsl:param name="type" required="yes"/>
        <xsl:variable name="property-name" select="tokenize($type, '[/#]')[last()]"/>
        <xsl:variable name="property-namespace" select="replace($type, $property-name, '')"/>
        <xsl:copy-of select="$prefixmap($property-namespace) || ':' || $property-name"/>
    </xsl:function>
    <xsl:function name="frbrizer:get-namespace">
        <xsl:param name="type" required="yes"/>
        <xsl:variable name="property-name" select="tokenize($type, '[/#]')[last()]"/>
        <xsl:variable name="property-namespace" select="replace($type, $property-name, '')"/>
        <xsl:value-of select="$property-namespace"/>
    </xsl:function>
    <xsl:template name="create-property-from-subfield">
        <xsl:param name="type" required="no" select="''"/>
        <xsl:param name="value" required="no"/>
        <xsl:param name="resource" required="no"/>
        <xsl:if test="$type ne '' and starts-with($type, 'http')">
        <xsl:try>
            <xsl:variable name="property-name" select="tokenize($type, '[/#]')[last()]"/>
            <xsl:variable name="property-namespace" select="replace($type, $property-name, '')"/>
            <xsl:element name="{$prefixmap($property-namespace) || ':' || $property-name}" namespace="{$property-namespace}">
            <xsl:choose>
                <xsl:when test="$resource ne ''">
                    <xsl:attribute name="rdf:resource" select="normalize-space($resource)"/>
                </xsl:when>
                <xsl:when test="$value ne ''">
                    <xsl:value-of select="normalize-space($value)"/>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
            </xsl:element>

            <xsl:catch>
                <xsl:message terminate="no">
                    <xsl:value-of select="'Error converting to rdf property : ' || $type"/>
                    <xsl:value-of select="', Value : ' || $value"/>
                    <!--<xsl:value-of select="$entity_type"></xsl:value-of>-->
                    <xsl:value-of select="$err:description"></xsl:value-of>
                </xsl:message> 
            </xsl:catch>
        </xsl:try>
        </xsl:if> 

          
    </xsl:template>
    
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
        <!--<xsl:if test="$include_labels and ($label ne '')">
            <xsl:if test="$label ne ''">
                <xsl:attribute name="label" select="$label"/>
            </xsl:if>
        </xsl:if>-->
        <xsl:value-of select="normalize-space($select)"/>

    </xsl:template>
    
    <!--Template for copying the attributes of an element -->
    <xsl:template name="copy-attributes">
        <xsl:for-each select="@*">
            <xsl:copy/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Template for creating derived identifiers and removes the recordsetlevel-->
    <xsl:template match="rdf:RDF" mode="create-identifier" name="create-identifier">
        <rdf:RDF>
            <xsl:for-each select="rdf:Description/frbrizer:recordset/*">
            <xsl:sort select="name()"/>
            <xsl:sort select="@rdf:about"/>
            <xsl:variable name="record" select="."/>
            <xsl:copy>
               <xsl:for-each select="@*">
                    <xsl:choose>
                        <xsl:when test="name() = 'rdf:about'">
                            <xsl:attribute name="rdf:about" select="frbrizer:construct-identifier($record)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- copy remaining of record -->
                <xsl:for-each select="node()">
                    <xsl:copy-of select="."/>
                </xsl:for-each> 
                </xsl:copy>
            </xsl:for-each>
            </rdf:RDF>
    </xsl:template>
    
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:sort-keys">
        <xsl:param name="keys"/>
        <xsl:perform-sort select="distinct-values($keys)">
            <xsl:sort select="."/>
        </xsl:perform-sort>
    </xsl:function>
    
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:sort-properties">
        <xsl:param name="properties"/>
        <xsl:perform-sort select="$properties">
            <xsl:sort select="."/>
        </xsl:perform-sort>
    </xsl:function>
    
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:trimsort-targets" as="xs:string*">
        <xsl:param name="relationships"/>
            <xsl:perform-sort select="for $r in distinct-values($relationships) return if (local:trim-target($r) ne '') then local:trim-target($r) else ()">
                <xsl:sort select="."/>
            </xsl:perform-sort>
    </xsl:function>
    
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:trim-target">
        <!-- This function transforms a list of uris to a list of strings containing the last part of the uri-->
        <xsl:param name="value" as="xs:string"/>
        <xsl:value-of select="let $x := $value return if (matches($x, '\w+:(/?/?)[^\s]+')) then (tokenize(replace($x, '/$', ''), '/'))[last()] else $x"/>
    </xsl:function>   


    <xsl:template match="rdf:RDF" mode="merge" name="merge">
        <xsl:copy>
            <xsl:for-each-group select="*" group-by="(name() || @rdf:about)">
                <xsl:element name="{current-group()[1]/name()}">
                    <xsl:copy-of select="current-group()[1]/@*"/>
                    <xsl:for-each-group select="* except frbrizer:template" group-by="name() || . || @rdf:resource">
                        <xsl:copy-of select="current-group()[1]"/>   
                    </xsl:for-each-group>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>