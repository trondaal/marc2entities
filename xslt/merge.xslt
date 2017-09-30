<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0"
    xmlns:frbrizer="http://idi.ntnu.no/frbrizer/">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/*:collection" mode="merge" xmlns:frbrizer="http://idi.ntnu.no/frbrizer/">
            <xsl:copy>
                <xsl:for-each select="@*"><!--Copying the attributes of the collection element -->
                    <xsl:copy/>
                </xsl:for-each>
                <xsl:for-each-group select="//*:record" group-by="@id, @type" composite="yes"> <!-- control field deduplication -->
                    <xsl:sort select="@type"/>
                    <xsl:sort select="@id"/>
                    <xsl:element name="{local-name(current-group()[1])}"  namespace="{namespace-uri(current-group()[1])}">
                        <xsl:attribute name="id" select="current-group()[1]/@id"/>
                        <xsl:attribute name="type" select="current-group()[1]/@type"/>  
                        <xsl:for-each-group select="current-group()/*:controlfield" group-by="@tag, @ind1, @ind2, @type, string(.)" composite="true">
                            <xsl:sort select="@tag"/>
                            <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                <xsl:copy-of select="@*"/>
                                <xsl:value-of select="current-group()[1]"/>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each-group select="current-group()/*:datafield" group-by="@tag, @ind1, @ind2, @type, *:subfield/@code, *:subfield/@type, *:subfield/string" composite="true">
                            <xsl:sort select="@tag"/>
                            <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                <xsl:copy-of select="current-group()[1]/@tag"/>
                                <xsl:copy-of select="current-group()[1]/@ind1"/>
                                <xsl:copy-of select="current-group()[1]/@ind2"/>
                                <xsl:copy-of select="current-group()[1]/@type"/>
                                <xsl:for-each-group select="current-group()/*:subfield" group-by="@code, @type, normalize-space(.)" composite="yes">
                                    <xsl:sort select="@code"/>
                                    <xsl:sort select="@type"/>
                                    <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                        <xsl:copy-of select="current-group()[1]/@code"/>
                                        <xsl:copy-of select="current-group()[1]/@type"/>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:element>
                                </xsl:for-each-group>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each-group select="current-group()/*:relationship" group-by="@type, @href" composite="yes">
                            <xsl:sort select="@type"/>
                            <xsl:sort select="@href"/>
                            <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                <xsl:copy-of select="@* except @itype"/>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each-group select="current-group()/*:confidence" group-by="@rule, @src" composite="yes">
                            <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                                <xsl:attribute name="rule" select="current-group()[1]/@rule"/>
                                <xsl:attribute name="src" select="current-group()[1]/@src"/>
                                <xsl:attribute name="cnt" select="sum(current-group()/@cnt)"/>
                            </xsl:element>
                        </xsl:for-each-group>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:copy>
    </xsl:template>
        
</xsl:stylesheet>