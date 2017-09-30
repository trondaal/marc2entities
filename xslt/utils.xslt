<!-- Templates from this file are copied into the conversion file by make.xsl -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:param name="debug" as="xs:boolean" select="false()"/>
    <xsl:param name="merge" as="xs:boolean" select="true()"/>
    <xsl:param name="inverse" as="xs:boolean" select="true()"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <xsl:template name="copy-content"><!--Template for copying subfield content. This template is used by the entity-templates-->
        <xsl:param name="type" required="no" select="''"/>
        <xsl:param name="select" required="no"/>
        <xsl:call-template name="copy-attributes"/>
        <xsl:if test="$type ne ''">
            <xsl:attribute name="type" select="$type"/>
        </xsl:if>
        <xsl:value-of select="normalize-space($select)"/>
    </xsl:template>
    
    <xsl:template name="copy-attributes">
        <xsl:for-each select="@* except (@*:xsi | @*:schemaLocation)"><!--Template for copying the attributes of an element -->
            <xsl:copy/>
        </xsl:for-each>
    </xsl:template>
  
    <xsl:template match="*:record-entity-set" mode="replace-keys" name="replace-keys" xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"><!-- Template for replacing internal keys with descriptive keys in the runtime generated keymap-->
        <xsl:param name="keymapping" required="yes"/>
        <xsl:copy>
            <xsl:call-template name="copy-attributes"/>
            <xsl:for-each select="*:record">
                <xsl:variable name="record_id" select="@id"/>
                <xsl:choose>
                    <xsl:when test="$keymapping//*:keyentry[@id = $record_id]">
                        <xsl:copy>
                            <xsl:for-each select="@*"><!-- updating attribute on record -->
                                <xsl:choose>
                                    <xsl:when test="local-name() = 'id'">
                                        <xsl:attribute name="id" select="$keymapping//*:keyentry[@id = $record_id]/@key"/> 
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:for-each select="node()">
                                <xsl:choose>
                                    <xsl:when test="@href = $keymapping//*:keyentry/@id">
                                        <xsl:variable name="href" select="@href"/>
                                        <xsl:copy>
                                            <xsl:for-each select="@*">
                                                <xsl:choose>
                                                    <xsl:when test="local-name() = 'href'">
                                                        <xsl:attribute name="href" select="$keymapping//*:keyentry[@id = $href]/@key"/>
                                                       
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
                                                        <xsl:attribute name="href" select="$keymapping//*:keyentry[@id = $href]/@key"/>
                                                        
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
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*:record-entity-set" mode="remove-record-entity-set-parent-element">
        <xsl:copy-of select="//*:record"/>
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
 
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:keyfilter" as="xs:string*">
        <xsl:param name="key" as="xs:string*"/>
        <xsl:for-each select="$key">
            <xsl:choose>
                <xsl:when test=". = ''">
                    <!-- return nothing -->
                </xsl:when>
                <xsl:when test="matches(., '\{.*\}')">
                    <!-- return as is -->
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace(lower-case(replace(.,'^[^\p{L}\p{N}]|[^\p{L}\p{N}]+$', '')), '[^\p{N}\p{L}]+', ' ')"/>
                    <!--<xsl:value-of select="replace(replace(replace(lower-case(string-join(., ';')), '[^\p{L}\p{N}{};:]+', ':'), ':::', ':'), ':;:', ':')"/>-->
                </xsl:otherwise>
            </xsl:choose>

        </xsl:for-each>       
    </xsl:function>
    
    <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/" name="local:typefilter" as="xs:string">
        <xsl:param name="typename" as="xs:string"/>
        <xsl:value-of select="lower-case(substring-after($typename, ':'))"/>
    </xsl:function>
   
    <xsl:template match="*:record-entity-set" mode="create-inverse-relationships"><!--template for adding inverse relationships --><!--uses a record-set as input and outputs a new record-set-->
        <xsl:if test="$inverse">
            <xsl:variable name="record-set" select="."/>
            <xsl:copy>
                <xsl:for-each select="*:record">
                    <xsl:variable name="record" select="."/>
                    <xsl:variable name="this-entity-id" select="@id"/>
                    <xsl:copy>
                        <xsl:copy-of select="@* | node()"/>
                        <!-- copies all attributes and elements from the record, and the following code adds inverse relationships to entities that have this record as target -->
                        
                        <xsl:for-each select="$record-set/*:record[*:relationship[(@href = $this-entity-id) and @itype]]">
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
    

</xsl:stylesheet>