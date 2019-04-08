<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"
    xmlns:c="http://rdaregistry.info/Elements/c/"
    xmlns:w="http://rdaregistry.info/Elements/w/"
    xmlns:a="http://rdaregistry.info/Elements/a/"
    xmlns:e="http://rdaregistry.info/Elements/e/"
    xmlns:marc="http://marc21rdf.info/elements/marc/"
    xmlns:m="http://rdaregistry.info/Elements/m/">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/*:collection">
        <rdf:RDF xml:base="http://example.org/rda/">
            <xsl:for-each-group select="( //@type)" group-by="replace(., tokenize(., '/')[last()], '')">
                <xsl:namespace name="{tokenize(., '/')[last() - 1]}" select="current-grouping-key()"/>
            </xsl:for-each-group>
            <xsl:for-each-group select="//*:record" group-by="@id, @type" composite="yes">
                <xsl:sort select="@type"/>
                <xsl:sort select="@id"/>
                <xsl:variable name="p" select="tokenize(@type, '/')[last() - 1]"/>
                <xsl:variable name="n" select="tokenize(@type, '/')[last()]"/>
                <xsl:element name="{concat($p, ':', $n)}">
                    <xsl:attribute name="rdf:about" select="@id" />
                    <xsl:attribute name="rdf:type" select="@type"/>
                    <xsl:for-each-group select="current-group()//*:subfield" group-by="@type, text()" composite="yes">
                        <xsl:variable name="pre" select="tokenize(@type, '/')[last() - 1]"/>
                        <xsl:variable name="nm" select="tokenize(@type, '/')[last()]"/>
                        <xsl:element name="{concat($pre, ':', $nm)}">
                            <xsl:copy-of select="current-group()[1]/text()"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:relationship" group-by="@type, @href" composite="yes">
                        <xsl:sort select="@type"/>
                        <xsl:variable name="pre" select="tokenize(@type, '/')[last() - 1]"/>
                        <xsl:variable name="nm" select="tokenize(@type, '/')[last()]"/>
                        <xsl:element name="{concat($pre, ':', $nm)}">
                            <xsl:attribute name="rdf:resource" select="current-group()[1]/@href" />
                        </xsl:element>                        
                    </xsl:for-each-group>
                </xsl:element>
            </xsl:for-each-group>
        </rdf:RDF>
    </xsl:template>
</xsl:stylesheet>