<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:frbrizer="http://idi.ntnu.no/frbrizer/" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="basic-uri" select="'utils.xslt'"/>
    <xsl:template match="/*:templates">
        <xsl:variable name="_templates" select="."/>
        <xsl:element name="xsl:stylesheet">
            <xsl:attribute name="version" select="'3.0'"/>
            <!--<xsl:attribute name="exclude-result-prefixes" select="'xs local'"/>-->
            <!-- ad hoc hardcoding of namespace that is used for functions (local) and for generated data (f) -->
            <xsl:namespace name="frbrizer" select="'http://idi.ntnu.no/frbrizer/'"/>
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:namespace name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
            <xsl:namespace name="map" select="'http://www.w3.org/2005/xpath-functions/map'"/>
            <xsl:for-each select="in-scope-prefixes($_templates)">
                <xsl:variable name="prefix" select="."/>
                <xsl:variable name="uri" select="namespace-uri-for-prefix(., $_templates)"/>
                <xsl:if test="$prefix ne '' and not(starts-with($prefix, 'xs'))">
                    <xsl:namespace name="{$prefix}" select="$uri"/>
                </xsl:if>
            </xsl:for-each>
       

            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'merge'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'true()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'rdf'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:output">
                <xsl:attribute name="method" select="'xml'"/>
                <xsl:attribute name="version" select="'1.0'"/>
                <xsl:attribute name="encoding" select="'UTF-8'"/>
                <xsl:attribute name="indent" select="'yes'"/>
            </xsl:element>
            
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'prefixmap'"/>
                <xsl:attribute name="as" select="'map(xs:string, xs:string)'"/>
                <xsl:element name="xsl:map">
                    <xsl:for-each select="in-scope-prefixes(.)">
                        <xsl:variable name="prefix" select="."/>
                        <xsl:variable name="uri" select="namespace-uri-for-prefix(., $_templates)"/>
                        <xsl:if test="$prefix ne '' and not(starts-with($prefix, 'xs'))">
                            <xsl:element name="xsl:map-entry">
                                <xsl:attribute name="key" select="concat('''', $uri, '''')"/>
                                <xsl:attribute name="select" select="concat('''', $prefix, '''')"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="collection-template"/>
            <xsl:call-template name="templates-template"/>
            <xsl:call-template name="entity"/>
            <xsl:call-template name="construct-identifiers-function"/>
            <!-- Retrieving templates and functions from utils.xslt -->
            <xsl:copy-of select="doc($basic-uri)/*/xsl:template"/>
            <xsl:copy-of select="doc($basic-uri)/*/xsl:function"/>
            <!-- Retrieving userdefined functions from the rules file -->
            <xsl:copy-of select="stylesheet/*"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="entity">
        <xsl:for-each select="entity">
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
        <xsl:if test="exists(@type) and @type ne ''">
            <xsl:element name="xsl:element">
                <xsl:attribute name="name" select="'{frbrizer:create-class-name(''' || @type || ''')}'"/>
                <xsl:choose>
                    <xsl:when test="identifier">
                        <xsl:element name="xsl:attribute">
                            <xsl:attribute name="name" select="'rdf:about'"/>
                            <xsl:attribute name="select" select="identifier"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="xsl:attribute">
                            <xsl:attribute name="name" select="'rdf:nodeID'"/>
                            <xsl:attribute name="select" select="'generate-id(.)'"/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:element name="xsl:element">
                    <xsl:attribute name="name" select="'frbrizer:template'"/>
                    <xsl:element name="xsl:value-of">
                        <xsl:attribute name="select" select="'$this_template_name'"/>
                    </xsl:element>
                </xsl:element>
                <xsl:call-template name="controlfields"/>
                <xsl:call-template name="datafields"/>
                <xsl:call-template name="relationships"/>
            </xsl:element>
        </xsl:if>
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
                                        <xsl:element name="xsl:call-template">
                                            <xsl:attribute name="name" select="'create-property-from-subfield'"/>
                                            <xsl:element name="xsl:with-param">
                                              <xsl:attribute name="name" select="'type'"/>
                                              <xsl:attribute name="select" select="frbrizer:xpathify(@type)"/>
                                            </xsl:element>
                                            <xsl:element name="xsl:with-param">
                                                <xsl:attribute name="name" select="'value'"/>
                                                <xsl:attribute name="select" select=" if (exists(@select) and (string-length(@select)) != 0) then @select else ('.')"/>
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
        <xsl:param name="select" required="no" select="''"/>
        <xsl:element name="xsl:for-each">
            <xsl:attribute name="select" select="$p"/>
            <xsl:if test="string($type) ne ''">
                <xsl:element name="xsl:call-template">
                    <xsl:attribute name="name" select="'create-property-from-subfield'"/>
                    <xsl:element name="xsl:with-param">
                        <xsl:attribute name="name" select="'type'"/>
                        <xsl:attribute name="select" select="frbrizer:xpathify(@type)"/>
                    </xsl:element>
                    <xsl:element name="xsl:with-param">
                        <xsl:attribute name="name" select="'value'"/>
                        <xsl:attribute name="select" select=" if (exists(@select) and (string-length(@select)) != 0) then @select else ('.')"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="relationships">
        <xsl:for-each select="*:relationships/*:relationship/*:target[@entity = //*:templates/*:entity/@templatename]">
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
        <xsl:if test="exists(../@type)">
            <xsl:element name="xsl:call-template">
                <xsl:attribute name="name" select="'create-property-from-subfield'"/>
                <xsl:element name="xsl:with-param">
                    <xsl:attribute name="name" select="'type'"/>
                    <xsl:attribute name="select" select="frbrizer:xpathify(../@type)"/>
                </xsl:element>
                <xsl:element name="xsl:with-param">
                    <xsl:attribute name="name" select="'resource'"/>
                    <xsl:attribute name="select" select="$target_template/identifier"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    <!-- parent template for record processing -->
    <xsl:template name="collection-template">
        <xsl:variable name="templates" select="."/>
        <xsl:element name="xsl:template">
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:attribute name="match" select="'/*:collection'"/>
            <xsl:element name="xsl:message">
                <xsl:attribute name="select" select="'map:keys($prefixmap)'"/>
            </xsl:element>    
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'entity-collection'"/>
                <xsl:element name="rdf:RDF">
                    <xsl:attribute name="xml:base" select="'http://example.org/marc2entities/'"/>
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
                    <xsl:element name="xsl:for-each">
                        <xsl:attribute name="select" select="'*:record'"/>
                        <xsl:element name="xsl:call-template">
                            <xsl:attribute name="name" select="'create-record-set'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'with-constructed-identifiers'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$entity-collection'"/>
                    <xsl:attribute name="mode" select="'create-identifier'"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'merged'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$with-constructed-identifiers'"/>
                    <xsl:attribute name="mode" select="'merge'"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:copy-of">
                <xsl:attribute name="select" select="'$merged'"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
   
    <xsl:template name="construct-identifiers-function">
        <xsl:element name="xsl:function">
            <xsl:attribute name="name" select="'frbrizer:construct-identifier'"/>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'record'"/>
            </xsl:element>
            <!--<xsl:element name="xsl:message">
                <xsl:element name="xsl:copy-of">
                    <xsl:attribute name="select" select="'$record'"/>
                </xsl:element>
            </xsl:element>-->
            <xsl:element name="xsl:choose">
                <xsl:for-each select="*:entity[identifier-constructed]">
                    <xsl:element name="xsl:when">
                        <xsl:attribute name="test" select="'$record/frbrizer:template = ' || '''' || @templatename || ''''"/>
                        <xsl:variable name="construct" as="xs:string" select="string-join(for $i in identifier-constructed/element return $i, ', ')"/>
                        <xsl:element name="xsl:value-of">
                            <xsl:attribute name="select" select="'string-join((' || $construct || '), ''/'')'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                <xsl:element name="xsl:otherwise">
                    <xsl:element name="xsl:value-of">
                        <xsl:attribute name="select" select="'$record/@rdf:about'"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>    
    </xsl:template>
    
    <xsl:template name="templates-template">
        <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'*:record'"/>
            <xsl:attribute name="name" select="'create-record-set'"/>
                <xsl:element name="rdf:Description">
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'rdf:about'"/>
                        <xsl:attribute name="select" select="'*:controlfield[@tag=''001'']'"/>
                    </xsl:element>
                    <xsl:element name="frbrizer:recordset">
                        <xsl:attribute name="rdf:parseType" select="'Collection'"/>
                        <xsl:for-each select="*:entity">
                            <xsl:element name="xsl:call-template">
                                <xsl:attribute name="name" select="@templatename"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
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