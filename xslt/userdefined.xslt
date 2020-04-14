<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:template match="/*:collection" mode="userdefined" name="tolexicalmarcxml">
        <xsl:apply-templates select="." mode="copy"/>
    </xsl:template> 
    
    <xsl:template match="node()|@*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- renaming from numeric typenames to lexical typenames -->
    <xsl:template match="@type" mode="copy">
        <xsl:variable name="currenttype" select="."/>
        <xsl:variable name="lexicaltype" select="doc('rda.xml')/*:RDF/*:Description[@*:about=$currenttype]/*:lexicalAlias[ends-with(@*:resource, '.en')]/@*:resource"/>
        <xsl:choose>
            <xsl:when test="$lexicaltype ne ''">
                <xsl:attribute name="type">
                    <xsl:value-of select="doc('rda.xml')/*:RDF/*:Description[@*:about=$currenttype]/*:lexicalAlias[ends-with(@*:resource, '.en')]/@*:resource"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="type">
                    <xsl:value-of select="$currenttype"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

  
</xsl:stylesheet>