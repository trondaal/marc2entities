<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"
    xmlns:a="http://rdaregistry.info/Elements/a/"
    xmlns:c="http://rdaregistry.info/Elements/c/"
    xmlns:e="http://rdaregistry.info/Elements/e/"
    xmlns:u="http://rdaregistry.info/Elements/u/"
    xmlns:w="http://rdaregistry.info/Elements/w/"
    xmlns:m="http://rdaregistry.info/Elements/m/"
    xmlns:frsad="http://iflastandards.info/ns/fr/frsad/"
    xmlns:frbrer="http://iflastandards.info/ns/fr/frbr/frbrer/"
    xmlns:marcrdf="http://marc21rdf.info/elements/">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/*:collection" mode="rdf">
        <rdf:RDF xml:base="http://idi.ntnu.no/frbrized/">
            <xsl:namespace name="a" select="'http://rdaregistry.info/Elements/a/'"/>
            <xsl:namespace name="c" select="'http://rdaregistry.info/Elements/c/'"/>
            <xsl:namespace name="e" select="'http://rdaregistry.info/Elements/e/'"/>
            <xsl:namespace name="u" select="'http://rdaregistry.info/Elements/u/'"/>
            <xsl:namespace name="w" select="'http://rdaregistry.info/Elements/w/'"/>
            <xsl:namespace name="m" select="'http://rdaregistry.info/Elements/m/'"/>
            <xsl:namespace name="frsad" select="'http://iflastandards.info/ns/fr/frsad/'"/>
            <xsl:namespace name="frbrer" select="'http://iflastandards.info/ns/fr/frbr/frbrer/'"/>
            <xsl:namespace name="marcrdf" select="'http://marc21rdf.info/elements/'"/>
            <xsl:for-each-group select="//*:record" group-by="@id">
                <xsl:sort select="@type"/>
                <xsl:sort select="@id"/>
                <rdf:Description >
                    <xsl:variable name="type" select="current-group()[1]/@type"/>
                    
                    <xsl:attribute name="rdf:about" select="replace(current-group()[1]/@id, '[^\p{L}\p{N}]', '')" />
                    
                    <!-- If using a licenced version of Saxon (pe, ee), it is possible to use functions in Java to create UUID based on a string -->
                    <!-- <xsl:attribute name="rdf:about" select="uuid:to-string(uuid:nameUUIDFromBytes(string:getBytes(current-group()[1]/@id/string())))" 
                        xmlns:uuid="java:java.util.UUID" xmlns:string="java:java.lang.String"/> -->
                    
                    <xsl:attribute name="rdf:type" select="concat('http://rdaregistry.info/Elements/c/', substring-after(current-group()[1]/@type, ':'))"/>
                    <xsl:for-each-group select="current-group()//*:subfield" group-by="@type, text()" composite="yes">
                        <xsl:if test="tokenize(@type, ':')[1] = ('c', 'u', 'a', 'w', 'e', 'm')">
                            <xsl:element name="{@type}">
                                <xsl:copy-of select="current-group()[1]/text()"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:relationship" group-by="@type, @href" composite="yes">
                        <xsl:sort select="@type"/>
                        <xsl:if test="tokenize(@type, ':')[1] = ('c', 'u', 'a', 'w', 'e', 'm')">
                            <xsl:element name="{@type}">
                                <xsl:attribute name="rdf:resource" select="replace(current-group()[1]/@href, '[^\p{L}\p{N}]', '')" />
                                <!-- If using a licenced version of Saxon (pe, ee), it is possible to use functions in Java to create UUID based on a string -->
                                <!-- <xsl:attribute name="rdf:resource" select="uuid:to-string(uuid:nameUUIDFromBytes(string:getBytes(current-group()[1]/@href/string())))" 
                                    xmlns:uuid="java:java.util.UUID" xmlns:string="java:java.lang.String"/> -->
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each-group>
                </rdf:Description>
            </xsl:for-each-group>
        </rdf:RDF>
    </xsl:template>
</xsl:stylesheet>