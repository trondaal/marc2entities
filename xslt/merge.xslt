<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:frbrizer="http://idi.ntnu.no/frbrizer/" version="2.0"><xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/><!-- Template is moved to basic.xslt --><!--<xsl:template match="/*:collection" mode="merge" name="merge">
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
                    <xsl:for-each-group select="current-group()/*:datafield" group-by="normalize-space(string-join(((@tag), @type, (if ($ignore_indicators_in_merge) then () else (@ind1, @ind2)), *:subfield/@code, *:subfield/@type, *:subfield/text()), ''))">
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
                            <xsl:for-each-group select="current-group()/*:subfield" group-by="concat(@code,@type, text())">
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
                    <xsl:for-each-group select="current-group()/*:relationship" group-by="concat(@type,@href,@subtype)">
                        <xsl:sort select="@type"/>
                        <xsl:sort select="@subtype"/>
                        <xsl:sort select="@id"/>
                        <xsl:element name="{name(current-group()[1])}" namespace="{namespace-uri(current-group()[1])}">
                            <xsl:copy-of select="@* except (@c|@ilabel|@itype|@isubtype)"/>
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
    </xsl:template>--></xsl:stylesheet>