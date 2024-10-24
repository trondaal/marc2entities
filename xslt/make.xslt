<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:frbrizer="http://idi.ntnu.no/frbrizer/" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="utils-uri" select="'utils.xslt'"/>
    <xsl:param name="excludetemplates" required="no">
        <!-- if used, it will exclude creation of entities from these templates as well as relationships to them -->
    </xsl:param>
    <xsl:template match="/*:templates">
        <xsl:element name="xsl:stylesheet">
            <xsl:attribute name="version" select="'3.0'"/>
            <!--<xsl:attribute name="exclude-result-prefixes" select="'xs local'"/>-->
            <!-- ad hoc hardcoding of namespace that is used for functions (local) and for generated data (f) -->
            <xsl:namespace name="frbrizer" select="'http://idi.ntnu.no/frbrizer/'"/>
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'debug'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_MARC001_in_entityrecord'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_MARC001_in_controlfield'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_MARC001_in_subfield'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_MARC001_in_relationships'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_anchorvalues'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_templateinfo'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_sourceinfo'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_keyvalues'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_internal_key'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_counters'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'merge'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'true()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'rdf'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'true()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'ignore_indicators_in_merge'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'true()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_id_as_element'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'include_missing_reverse_relationships'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'true()'"/>
            </xsl:element>
            <!--<xsl:choose>
                <xsl:when test="$userdefined-uri">
                    <xsl:element name="xsl:param">
                        <xsl:attribute name="name" select="'userdefined'"/>
                        <xsl:attribute name="as" select="'xs:boolean'"/>
                        <xsl:attribute name="select" select="'true()'"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="xsl:param">
                        <xsl:attribute name="name" select="'userdefined'"/>
                        <xsl:attribute name="as" select="'xs:boolean'"/>
                        <xsl:attribute name="select" select="'false()'"/>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>-->
            <xsl:element name="xsl:output">
                <xsl:attribute name="method" select="'xml'"/>
                <xsl:attribute name="version" select="'1.0'"/>
                <xsl:attribute name="encoding" select="'UTF-8'"/>
                <xsl:attribute name="indent" select="'yes'"/>
            </xsl:element>
            <xsl:call-template name="collection-template"/>
            <xsl:call-template name="templates-template"/>
            <xsl:call-template name="entity"/>
            <xsl:call-template name="create-key-mapping-templates"/>
            <xsl:call-template name="create-key-replacement-template"/>
            <!-- Retrieving templates and functions from utils.xslt -->
            <xsl:copy-of select="doc($utils-uri)/*/xsl:template"/>
            <xsl:copy-of select="doc($utils-uri)/*/xsl:function"/>
            <!-- Retrieving templates and functions from userdefined -->
            <!--<xsl:if test="$userdefined-uri">
                <xsl:copy-of select="doc($userdefined-uri)/*/xsl:template"/>
                <xsl:copy-of select="doc($userdefined-uri)/*/xsl:function"/>
            </xsl:if>-->
            <!-- Retrieving userdefined functions from the rules file -->
            <xsl:copy-of select="stylesheet/*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="entity">
        <xsl:for-each select="entity[if ($excludetemplates) then not(contains($excludetemplates, @templatename)) else true()]">
            <xsl:sort select="@templatename"/>
            <xsl:element name="xsl:template">
                <xsl:attribute name="name" select="@templatename"/>
                <xsl:element name="xsl:variable">
                    <xsl:attribute name="name" select="'this_template_name'"/>
                    <xsl:attribute name="select" select="string-join(('''', @templatename, ''''), '')"/>
                </xsl:element>
                <xsl:element name="xsl:variable">
                    <xsl:attribute name="name" select="'tag'"/>
                    <xsl:attribute name="as" select="'xs:string'"/>
                    <xsl:attribute name="select" select="string-join(('''', @tag, ''''), '')"/>
                </xsl:element>
                <xsl:if test="exists(@code)">
                    <xsl:element name="xsl:variable">
                        <xsl:attribute name="name" select="'code'"/>
                        <xsl:attribute name="as" select="'xs:string'"/>
                        <xsl:attribute name="select" select="string-join(('''', @code, ''''), '')"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="xsl:variable">
                    <xsl:attribute name="name" select="'record'"/>
                    <xsl:attribute name="select" select="'.'"/>
                </xsl:element>
                <xsl:element name="xsl:variable">
                    <xsl:attribute name="name" select="'marcid'"/>
                    <xsl:attribute name="select" select="'*:controlfield[@tag=''001'']'"/>
                </xsl:element>
                <xsl:call-template name="tag-for-each"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="tag-for-each">
        <xsl:element name="xsl:for-each">
            <xsl:variable name="taglist" select="'('''||string-join(tokenize((@tag), '\D+'), ''',''')||''')'"/>
            <xsl:attribute name="select" select="'node()[@tag=' || $taglist  || ']' || (if (@condition) then '[' || @condition || ']' else ())"/>          
            <!--<xsl:attribute name="select" select=" string-join(('node()[@tag=''', @tag, ''']', if (@condition) then concat('[', @condition, ']') else ()), '')"/>-->
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_field'"/>              
                <xsl:attribute name="select" select="'(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'anchor_field'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'anchor'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_field_position'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'string(position())'"/>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="exists(@code)">
                    <xsl:call-template name="code-for-each"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="record-template"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="code-for-each">
        <xsl:element name="xsl:for-each">
            <xsl:variable name="codelist" select="'('''||string-join(tokenize((@code), '\W+'), ''',''')||''')'"/>
            <!--<xsl:attribute name="select" select="'node()[@tag='  || $codelist || ']' || (if (@condition)      then '[' || @condition      || ']' else ())"/>-->
            <xsl:attribute name="select" select="'node()[@code=' || $codelist || ']' || (if (@code-condition) then '[' || @code-condition || ']' else ())"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_subfield'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:subfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'anchor_subfield'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:subfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_subfield_code'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'$this_subfield/@code'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'anchor_subfield_code'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'$this_subfield/@code'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_subfield_position'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'string(position())'"/>
            </xsl:element>
            <xsl:call-template name="record-template"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="record-template">
        <xsl:element name="xsl:element">
            <xsl:attribute name="name" select="'{name(ancestor-or-self::*:record)}'"/>
            <xsl:attribute name="namespace" select="'{namespace-uri(ancestor-or-self::*:record)}'"/>
            <!-- getting name of record-element from source file to preserve the namespace -->
            <xsl:variable name="record-identifier-string">
                <xsl:call-template name="internal-id-template">
                    <xsl:with-param name="code" select="if (@code) then '$this_subfield_code' else  ()"/>
                    <xsl:with-param name="code-pos" select="if (@code) then '$this_subfield_position' else ()"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="xsl:attribute">
                <xsl:attribute name="name" select="'id'"/>
                <xsl:attribute name="select" select="$record-identifier-string"/>
            </xsl:element>
            <xsl:if test="exists(@type) and @type ne ''">
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'type'"/>
                    <xsl:attribute name="select" select="frbrizer:xpathify(@type)"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="exists(@subtype) and @subtype ne ''">
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'subtype'"/>
                    <xsl:attribute name="select" select="frbrizer:xpathify(@subtype)"/>
                </xsl:element>
            </xsl:if>
            <!--<xsl:if test="exists(@label) and @label ne ''">
                <xsl:element name="xsl:if">
                    <xsl:attribute name="test" select="'$include_labels'"/>
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'label'"/>
                        <xsl:attribute name="select" select="frbrizer:xpathify(@label)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>-->
            <xsl:element name="xsl:attribute">
                <xsl:attribute name="name" select="'templatename'"/>
                <xsl:attribute name="select" select="'$this_template_name'"/>
            </xsl:element>
            <xsl:call-template name="controlfields"/>
            <xsl:call-template name="datafields"/>
            <xsl:call-template name="relationships"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="datafields">
        <xsl:if test="count(attributes/datafield) &gt; 0">
            <xsl:variable name="anchortag" select="@tag"/>
            <xsl:for-each select="attributes/datafield">
                <xsl:choose>
                    <xsl:when test="@tag = $anchortag">
                        <xsl:variable name="p1" select="'$record/*:datafield[@tag='''"/>
                        <xsl:variable name="p2" select="@tag"/>
                        <xsl:variable name="p3" select="''']'"/>
                        <xsl:variable name="p5" select="if (exists(@condition)) then (string-join(('[', @condition, ']'), '')) else ('[. = $this_field]')"/>
                        <xsl:variable name="p6" select="concat('[*:subfield/@code = (''', string-join((for $c in distinct-values(*:subfield/@code) return $c), ''','''), ''')]')"/>
                        <xsl:call-template name="datafield">
                            <xsl:with-param name="p" select="string-join(($p1, $p2, $p3, $p5, $p6), '')"/>
                            <xsl:with-param name="type" select="@type"/>
                            <!--<xsl:with-param name="subtype" select="@subtype"/>
                            <xsl:with-param name="label" select="@label"/>-->
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="p1" select="'$record/*:datafield[@tag='''"/>
                        <xsl:variable name="p2" select="@tag"/>
                        <xsl:variable name="p3" select="''']'"/>
                        <xsl:variable name="p5" select="if (exists(@condition)) then (string-join(('[', @condition, ']'), '')) else ('')"/>
                        <xsl:variable name="p6" select="concat('[*:subfield/@code = (''', string-join((for $c in distinct-values(*:subfield/@code) return $c), ''','''), ''')]')"/>
                        <xsl:call-template name="datafield">
                            <xsl:with-param name="p" select="string-join(($p1, $p2, $p3, $p5, $p6), '')"/>
                            <xsl:with-param name="type" select="@type"/>
                            <!--<xsl:with-param name="subtype" select="@subtype"/>
                            <xsl:with-param name="label" select="@label"/>-->
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="datafield">
        <xsl:param name="p" required="yes"/>
        <xsl:param name="type" required="no" select="''"/>
        <xsl:element name="xsl:for-each">
            <xsl:attribute name="select" select="$p"/>
            <xsl:element name="xsl:copy">
                <xsl:element name="xsl:call-template">
                    <xsl:attribute name="name" select="'copy-attributes'"/>
                </xsl:element>
                <xsl:if test="string($type) ne ''">
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'type'"/>
                        <xsl:attribute name="select" select="frbrizer:xpathify($type)"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="xsl:for-each">
                    <xsl:variable name="p">
                        <xsl:element name="part">
                            <xsl:value-of select="'*:subfield[@code = ('''"/>
                        </xsl:element>
                        <xsl:element name="part">
                            <xsl:value-of select="string-join((for $c in distinct-values(*:subfield/@code)  return $c), ''',''')"/>
                        </xsl:element>
                        <xsl:element name="part">
                            <xsl:value-of select="''')]'"/>
                        </xsl:element>
                    </xsl:variable>
                    <xsl:attribute name="select" select="string-join($p/part, '')"/>
                    <xsl:for-each select="*:subfield[@code ne '*']">
                        <xsl:element name="xsl:if">
                            <xsl:attribute name="test" select="string-join(('@code = ''', @code, '''', if (exists(@condition)) then concat(' and ', @condition)  else ()), '')"/>
                            <xsl:choose>
                                <xsl:when test="exists(@type)">
                                    <xsl:element name="xsl:copy">
                                        <xsl:element name="xsl:call-template">
                                            <xsl:attribute name="name" select="'copy-content'"/>
                                            <xsl:if test="exists(@type) and @type ne ''">
                                                <xsl:element name="xsl:with-param">
                                                  <xsl:attribute name="name" select="'type'"/>
                                                  <xsl:attribute name="select" select="frbrizer:xpathify(@type)"/>
                                                </xsl:element>
                                            </xsl:if>
                                            <xsl:element name="xsl:with-param">
                                                <xsl:attribute name="name" select="'select'"/>
                                                <xsl:attribute name="select" select=" if (exists(@select) and (string-length(@select)) != 0) then @select else ('.')"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="xsl:copy-of">
                                        <xsl:attribute name="select" select="'.'"/>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="controlfields">
        <xsl:if test="count(attributes/controlfield) &gt; 0">
            <xsl:variable name="tag" select="@tag"/>
            <xsl:for-each select="attributes/controlfield">
                <xsl:choose>
                    <xsl:when test="@tag = $tag">
                        <xsl:variable name="p1" select="'$record/*:controlfield[@tag='''"/>
                        <xsl:variable name="p2" select="@tag"/>
                        <xsl:variable name="p3" select="''']'"/>
                        <xsl:variable name="p4" select="'[$this_field_position]'"/>
                        <xsl:variable name="p5" select="if (exists(@condition)) then (string-join(('[', @condition, ']'), '')) else ('')"/>
                        <xsl:call-template name="controlfield">
                            <xsl:with-param name="p" select="string-join(($p1, $p2, $p3, $p4, $p5), '')"/>
                            <xsl:with-param name="type" select="@type"/>
                            <!--<xsl:with-param name="subtype" select="@subtype"/>
                            <xsl:with-param name="label" select="@label"/>-->
                            <xsl:with-param name="select" select="@select"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="p1" select="'$record/*:controlfield[@tag='''"/>
                        <xsl:variable name="p2" select="@tag"/>
                        <xsl:variable name="p3" select="''']'"/>
                        <xsl:variable name="p5" select="if (exists(@condition)) then (string-join(('[', @condition, ']'), '')) else ('')"/>
                        <xsl:call-template name="controlfield">
                            <xsl:with-param name="p" select="string-join(($p1, $p2, $p3, $p5), '')"/>
                            <xsl:with-param name="type" select="@type"/>
                            <!--<xsl:with-param name="subtype" select="@subtype"/>
                            <xsl:with-param name="label" select="@label"/>-->
                            <xsl:with-param name="select" select="@select"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="controlfield">
        <xsl:param name="p" required="yes"/>
        <xsl:param name="type" required="no" select="''"/>
        <!---<xsl:param name="label" required="no" select="''"/>
        <xsl:param name="subtype" required="no" select="''"/>-->
        <xsl:param name="select" required="no" select="''"/>
        <xsl:element name="xsl:for-each">
            <xsl:attribute name="select" select="$p"/>
            <xsl:element name="xsl:copy">
                <xsl:element name="xsl:call-template">
                    <xsl:attribute name="name" select="'copy-content'"/>
                    <xsl:if test="string($type) ne ''">
                        <xsl:element name="xsl:with-param">
                            <xsl:attribute name="name" select="'type'"/>
                            <xsl:attribute name="select" select="frbrizer:xpathify($type)"/>
                        </xsl:element>
                    </xsl:if>
                    <!--<xsl:if test="string($subtype) ne ''">
                        <xsl:element name="xsl:with-param">
                            <xsl:attribute name="name" select="'subtype'"/>
                            <xsl:attribute name="select" select="frbrizer:xpathify($subtype)"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="string($label) ne ''">
                        <xsl:element name="xsl:with-param">
                            <xsl:attribute name="name" select="'label'"/>
                            <xsl:attribute name="select" select="frbrizer:xpathify($label)"/>
                        </xsl:element>
                    </xsl:if>-->
                    <!--<xsl:if test="string($type) ne ''">
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name" select="'type'"/>
							<xsl:attribute name="select" select="concat('''', $type, '''')"/>							
						</xsl:element>
						<xsl:element name="xsl:with-param">
							<xsl:attribute name="name" select="'label'"/>
							<xsl:attribute name="select" select="concat('''', $label, '''')"/>
						</xsl:element>
					</xsl:if>-->
                    <xsl:element name="xsl:with-param">
                        <xsl:attribute name="name" select="'select'"/>
                        <xsl:attribute name="select" select="if (exists($select) and (string-length($select)) != 0) then $select else ('.')"/>
                    </xsl:element>
                    <xsl:element name="xsl:with-param">
                        <xsl:attribute name="name" select="'marcid'"/>
                        <xsl:attribute name="select" select="'$marcid'"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="relationships">
        <xsl:for-each select="*:relationships/*:relationship/*:target[@entity = //*:templates/*:entity/@templatename][if ($excludetemplates) then not(contains($excludetemplates, @entity)) else true()]">
            <!-- the predicate (condition) is used to avoid linking to non-existing templates -->
            <xsl:choose>
                <xsl:when test="exists(parent::*:relationship/@condition)">
                    <xsl:element name="xsl:if">
                        <xsl:attribute name="test" select="string(parent::*:relationship/@condition)"/>
                        <xsl:call-template name="relationship-target-tag-for-each"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="relationship-target-tag-for-each"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="relationship-target-tag-for-each">
        <xsl:element name="xsl:for-each">
            <xsl:variable name="target_template_name" select="string(@entity)"/>
            <xsl:variable name="target_template" select="//*:templates/*:entity[@templatename = $target_template_name]"/>
            <xsl:variable name="taglist" select="'('''||string-join(tokenize(($target_template/@tag), '\D+'), ''',''')||''')'"/>
            <xsl:attribute name="select" select="'$record/node()[@tag=' || $taglist || ']' || (if ($target_template/@condition) then '[' || $target_template/@condition || ']' else ())"/>
            <!--<xsl:attribute name="select" select="string-join(('$record/node()[@tag=''', string($target_template/@tag), ''']',if ($target_template/@condition) then concat('[', $target_template/@condition, ']') else ()), '')"/>-->
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_template_name'"/>
                <xsl:attribute name="select" select="string-join(('''', $target_template_name, ''''), '')"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_tag_value'"/>
                <xsl:attribute name="select" select="string-join(('''', $target_template/@tag, ''''), '')"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_field'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_field_position'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'string(position())'"/>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="exists($target_template/@code)">
                    <xsl:call-template name="relationship-target-code-for-each">
                        <xsl:with-param name="target_template" select="$target_template"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="relationship-with-or-without-if">
                        <xsl:with-param name="target_template" select="$target_template"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="relationship-target-code-for-each">
        <xsl:param name="target_template"/>
        <xsl:element name="xsl:for-each">
            <xsl:variable  name="codelist" select="'('''||string-join(tokenize(($target_template/@code), '\W+'), ''',''')||''')'"/>
            <!--<xsl:attribute name="select" select="'$record/node()[@tag=' || $codelist || ']' || (if      ($target_template/@condition) then '[' || $target_template/@condition || ']' else ())"/>-->
            <xsl:attribute name="select" select="'node()[@code=' || $codelist || ']' || (if ($target_template/@code-condition) then '[' || $target_template/@code-condition || ']' else ())"/>          
            <!--<xsl:attribute name="select" select="string-join(('node()[@code=''', string($target_template/@code), ''']', if ($target_template/@code-condition) then concat('[', $target_template/@code-condition, ']') else ()), '')"/>-->
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_subfield'"/>
                <xsl:attribute name="select" select="'.'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_subfield_code'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'$target_subfield/@code'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_subfield_position'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'string(position())'"/>
            </xsl:element>
            <xsl:call-template name="relationship-with-or-without-if">
                <xsl:with-param name="target_template" select="$target_template"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="relationship-with-or-without-if">
        <xsl:param name="target_template"/>
        <xsl:choose>
            <xsl:when test="exists(@condition) or (@same-field eq 'true')">
                <xsl:call-template name="relationship-if">
                    <xsl:with-param name="target_template" select="$target_template"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="relationship">
                    <xsl:with-param name="target_template" select="$target_template"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="relationship-if">
        <xsl:param name="target_template"/>
        <xsl:element name="xsl:if">
            <xsl:variable name="target_condition" select="if (@condition) then string-join(('(', @condition, ')'), '') else ()"/>
            <xsl:variable name="same_target_tag_condition" select="if ((@same-field = 'true' and ($target_template/@tag eq ancestor::entity/@tag))) then '($target_field = $this_field)'  else  ()"/>
            <xsl:attribute name="test" select="string-join(($target_condition, $same_target_tag_condition), ' and ')"/>
            <xsl:call-template name="relationship">
                <xsl:with-param name="target_template" select="$target_template"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template name="relationship">
        <xsl:param name="target_template"/>
        <xsl:element name="frbrizer:relationship">
            <xsl:variable name="target_typeid" select="$target_template/@type"/>
            <xsl:if test="exists(../@type)">
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'type'"/>
                    <xsl:attribute name="select" select="frbrizer:xpathify(../@type)"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="exists(../@itype)">
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'itype'"/>
                    <xsl:attribute name="select" select="frbrizer:xpathify(../@itype)"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="exists(../@subtype)">
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'subtype'"/>
                    <xsl:attribute name="select" select="frbrizer:xpathify(../@subtype)"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="exists(../@isubtype)">
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'isubtype'"/>
                    <xsl:attribute name="select" select="frbrizer:xpathify(../@isubtype)"/>
                </xsl:element>
            </xsl:if>
            <!--<xsl:if test="exists(../@label)">
                <xsl:element name="xsl:if">
                    <xsl:attribute name="test" select="'$include_labels'"/>
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'label'"/>
                        <xsl:attribute name="select" select="frbrizer:xpathify(../@label)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>-->
            <!--<xsl:if test="exists(../@ilabel)">
                <xsl:element name="xsl:if">
                    <xsl:attribute name="test" select="'$include_labels'"/>
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'ilabel'"/>
                        <xsl:attribute name="select" select="frbrizer:xpathify(../@ilabel)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>-->
            <!--<xsl:element name="xsl:if">
				<xsl:attribute name="test" select="'$include_labels'"/>
				<xsl:if test="exists(../@label)">
					<xsl:element name="xsl:attribute">
						<xsl:attribute name="name" select="'label'"/>
						<xsl:attribute name="select" select="concat('''',../@label,'''')"/>
					</xsl:element>
				</xsl:if>
				<xsl:if test="exists(../@ilabel)">
					<xsl:element name="xsl:attribute">
						<xsl:attribute name="name" select="'ilabel'"/>
						<xsl:attribute name="select" select="concat('''',../@ilabel,'''')"/>
					</xsl:element>
				</xsl:if>
			</xsl:element>-->
            <!--<xsl:element name="xsl:if">
                <xsl:attribute name="test" select="'$include_target_entity_type'"/>
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'target_type'"/>
                    <xsl:attribute name="select" select="concat('''', $target_typeid, '''')"/>
                </xsl:element>
            </xsl:element>-->
            <xsl:variable name="identifier_string">
                <xsl:call-template name="internal-id-template">
                    <xsl:with-param name="template_name" select="'$target_template_name'"/>
                    <xsl:with-param name="tag" select="'$target_tag_value'"/>
                    <xsl:with-param name="code" select="                             if ($target_template/@code) then                                 '$target_subfield_code'                             else                                 ()"/>
                    <xsl:with-param name="tag-pos" select="'$target_field_position'"/>
                    <xsl:with-param name="code-pos" select="                             if ($target_template/@code) then                                 '$target_subfield_position'                             else                                 ()"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="xsl:attribute">
                <xsl:attribute name="name" select="'href'"/>
                <xsl:attribute name="select" select="$identifier_string"/>
            </xsl:element>
            <xsl:element name="xsl:if">
                <xsl:attribute name="test" select="'$include_internal_key'"/>
                <xsl:element name="xsl:attribute">
                    <xsl:attribute name="name" select="'intkey'"/>
                    <xsl:attribute name="select" select="$identifier_string"/>
                </xsl:element>
            </xsl:element>
 
        </xsl:element>
    </xsl:template>
    <!-- template for creating internal identifier value -->
    <xsl:template name="internal-id-template">
        <xsl:param name="id" required="no" select="'$record/@id'"/>
        <xsl:param name="template_name" required="no" select="'$this_template_name'"/>
        <xsl:param name="tag" required="no" select="'$tag'"/>
        <xsl:param name="code"/>
        <xsl:param name="tag-pos" required="no" select="'$this_field_position'"/>
        <xsl:param name="code-pos"/>
        <xsl:variable name="elements" select="string-join(($id, $template_name, $tag, $code, $tag-pos, $code-pos), ',')"/>
        <xsl:value-of select="concat('string-join((', $elements, '), '':'')')"/>
    </xsl:template>
    <!-- parent template for record processing -->
    <xsl:template name="collection-template">
        <xsl:variable name="templates" select="."/>
        <xsl:element name="xsl:template">
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:attribute name="match" select="'/*:collection'"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'entity-collection'"/>
                <xsl:element name="xsl:copy">
                    <xsl:for-each select="in-scope-prefixes($templates)">
                        <xsl:variable name="prefix" select="."/>
                        <xsl:variable name="uri" select="namespace-uri-for-prefix(., $templates)"/>
                        <xsl:if test="$prefix ne '' and not(starts-with($prefix, 'xs'))">
                            <xsl:element name="xsl:namespace">
                                <xsl:attribute name="name" select="$prefix"/>
                                <xsl:attribute name="select" select="concat('''', $uri, '''')"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:element name="xsl:call-template">
                        <xsl:attribute name="name" select="'copy-attributes'"/>
                    </xsl:element>
                    <xsl:element name="xsl:for-each">
                        <xsl:attribute name="select" select="'*:record'"/>
                        <xsl:element name="xsl:call-template">
                            <xsl:attribute name="name" select="'create-record-set'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'entity-collection-merged'"/>
                <xsl:element name="xsl:choose">
                    <xsl:element name="xsl:when">
                        <xsl:attribute name="test" select="'$merge'"/>
                        <xsl:element name="xsl:apply-templates">
                            <xsl:attribute name="select" select="'$entity-collection'"/>
                            <xsl:attribute name="mode" select="'merge'"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xsl:otherwise">
                        <xsl:element name="xsl:copy-of">
                            <xsl:attribute name="select" select="'$entity-collection'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!--<xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'entity-collection-userdefined'"/>
                <xsl:element name="xsl:choose">
                    <xsl:element name="xsl:when">
                        <xsl:attribute name="test" select="'$userdefined'"/>
                        <xsl:element name="xsl:apply-templates">
                            <xsl:attribute name="select" select="'$entity-collection-merged'"/>
                            <xsl:attribute name="mode" select="'userdefined'"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xsl:otherwise">
                        <xsl:element name="xsl:copy-of">
                            <xsl:attribute name="select" select="'$entity-collection-merged'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>-->
            <xsl:element name="xsl:choose">
                <xsl:element name="xsl:when">
                    <xsl:attribute name="test" select="'$rdf'"/>
                    <xsl:element name="xsl:apply-templates">
                        <xsl:attribute name="select" select="'$entity-collection-merged'"/>
                        <xsl:attribute name="mode" select="'rdfify'"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="xsl:otherwise">
                    <xsl:element name="xsl:copy-of">
                        <xsl:attribute name="select" select="'$entity-collection-merged'"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="templates-template">
        <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'*:record'"/>
            <xsl:attribute name="name" select="'create-record-set'"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'step1'"/>
                <xsl:element name="frbrizer:record-set">
                    <xsl:for-each select="*:entity[if ($excludetemplates) then not(contains($excludetemplates, @templatename)) else true()]">
                        <xsl:element name="xsl:call-template">
                            <xsl:attribute name="name" select="@templatename"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'step2'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$step1'"/>
                    <xsl:attribute name="mode" select="'create-inverse-relationships'"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'step3'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$step2'"/>
                    <xsl:attribute name="mode" select="'create-keys'"/>
                </xsl:element>
            </xsl:element>
            <!--<xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'step4'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$step3'"/>
                    <xsl:attribute name="mode" select="'remove-record-set'"/>
                </xsl:element>
            </xsl:element>-->
            <xsl:element name="xsl:copy-of">
                <xsl:attribute name="select" select="'$step3//*:record'"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-key-mapping-templates">
        <xsl:variable name="keyfilter" select="keyfilter"/>
        <xsl:variable name="rules" select="."/>
        <xsl:variable name="ordernumbers" select="for $i in xs:integer(min(entity/key/@order)) to xs:integer(max(entity/key/@order)) return $i"/>
        <xsl:for-each select="$ordernumbers">
            <xsl:variable name="order" select="."/>
            <xsl:element name="xsl:template">
                <xsl:attribute name="match" select="'frbrizer:record-set'"/>
                <xsl:attribute name="mode" select="concat('create-key-mapping-step-', $order)"/>
                <xsl:element name="frbrizer:keymap">
                    <xsl:element name="xsl:for-each">
                        <xsl:attribute name="select" select="'*:record'"/>
                        <xsl:element name="xsl:choose">
                            <xsl:for-each select="$rules/*:entity[*:key/@order = $order]">
                                <xsl:element name="xsl:when">
                                    <xsl:attribute name="test" select="concat('@templatename = ''', @templatename, '''')"/>
                                    <xsl:element name="xsl:element">
                                        <xsl:attribute name="name" select="'frbrizer:keyentry'"/>
                                        <xsl:element name="xsl:variable">
                                            <xsl:attribute name="name" select="'key'"/>
                                            <xsl:attribute name="as" select="'xs:string*'"/>

                                                <xsl:for-each select="*:key/*:related">
                                                    <xsl:element name="xsl:value-of">
                                                      <xsl:attribute name="select" select="string-join(('frbrizer:sort-relationships(*:relationship[@type =''', ., ''']/@href)'), '')"/>
                                                    </xsl:element>
                                                </xsl:for-each>
                                                <xsl:for-each select="*:key/*:element">
                                                    <xsl:element name="xsl:value-of">
                                                      <xsl:attribute name="select" select="string-join(('frbrizer:sort-keys(', ., ')'), '')"/>
                                                    </xsl:element>
                                                </xsl:for-each>
                                                <!--<xsl:element name="xsl:value-of">
                                                    <xsl:attribute name="select" select="'concat(''\'',@type, ''#'')'"/>
                                                </xsl:element>-->
                                            
                                        </xsl:element>
                                        <xsl:element name="xsl:variable">
                                            <xsl:attribute name="name" select="'keyvalue'"/>
                                            <xsl:attribute name="select" select="$keyfilter"/>
                                        </xsl:element>
                                        <xsl:element name="xsl:attribute">
                                            <xsl:attribute name="name" select="'key'"/>
                                            <xsl:attribute name="select" select="'$keyvalue'"/>
                                        </xsl:element>
                                        <xsl:element name="xsl:attribute">
                                            <xsl:attribute name="name" select="'id'"/>
                                            <xsl:attribute name="select" select="'@id'"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="create-key-replacement-template">
        <xsl:variable name="ordernumbers" select="for $i in xs:integer(min(*:entity/*:key/@order)) to xs:integer(max(*:entity/*:key/@order)) return $i"/>
        <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'*:record-set'"/>
            <xsl:attribute name="mode" select="'create-keys'"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'set-phase-0'"/>
                <xsl:attribute name="select" select="'.'"/>
            </xsl:element>
            <xsl:for-each select="$ordernumbers">
                <xsl:variable name="order" select="."/>
                <xsl:element name="xsl:variable">
                    <xsl:attribute name="name" select="string-join(('keys-phase-', string($order)), '')"/>
                    <xsl:element name="xsl:apply-templates">
                        <xsl:attribute name="select" select="string-join(('$set-phase-', string($order - 1)), '')"/>
                        <xsl:attribute name="mode" select="string-join(('create-key-mapping-step-', string($order)), '')"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="xsl:variable">
                    <xsl:attribute name="name" select="string-join(('set-phase-', string($order)), '')"/>
                    <xsl:element name="xsl:apply-templates">
                        <xsl:attribute name="select" select="string-join(('$set-phase-', string($order - 1)), '')"/>
                        <xsl:attribute name="mode" select="'replace-keys'"/>
                        <xsl:element name="xsl:with-param">
                            <xsl:attribute name="name" select="'keymapping'"/>
                            <xsl:attribute name="select" select="string-join(('$keys-phase-', string($order)), '')"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
            <xsl:element name="xsl:copy-of">
                <xsl:attribute name="select" select="string-join(('$set-phase-', string(max($ordernumbers))), '')"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:function name="frbrizer:xpathify">
        <!-- This function will process the content as an XPATH-query if it starts with curly braces -->
        <!-- If not it will simply treat the content as a text -->
        <!-- The intended use is to avoid having to type 'text' all the time for attribute-values and rather -->
        <!-- require the rule writer to specify that something is an xquery when it is -->
        <xsl:param name="astring" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="starts-with($astring, '{') and ends-with($astring, '}')">
                <xsl:value-of select="replace($astring, '[\{\}]', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('''', $astring, '''')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>