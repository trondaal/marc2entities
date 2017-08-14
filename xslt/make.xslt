<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:frbrizer="http://idi.ntnu.no/frbrizer/" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="utilsfile" select="'utils.xslt'"/>
    <xsl:variable name="mergefile" select="'merge.xslt'"/>
    <xsl:variable name="rdffile" select="'rdf.xslt'"/>
      <xsl:template match="/*:templates">
        <xsl:element name="xsl:stylesheet">
            <xsl:attribute name="version" select="'3.0'"/>
            <xsl:namespace name="frbrizer" select="'http://idi.ntnu.no/frbrizer/'"/>
            <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
            <xsl:namespace name="frbrizer" select="'http://idi.ntnu.no/frbrizer/'"/>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'confidence'"/>
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
                <xsl:attribute name="select" select="'false()'"/>
            </xsl:element>
            <xsl:element name="xsl:param">
                <xsl:attribute name="name" select="'inverse'"/>
                <xsl:attribute name="as" select="'xs:boolean'"/>
                <xsl:attribute name="select" select="'true()'"/>
            </xsl:element>
            <xsl:element name="xsl:output">
                <xsl:attribute name="method" select="'xml'"/>
                <xsl:attribute name="version" select="'1.0'"/>
                <xsl:attribute name="encoding" select="'UTF-8'"/>
                <xsl:attribute name="indent" select="'yes'"/>
            </xsl:element>
            <xsl:call-template name="collection-processing"/>
            <xsl:call-template name="create-record-processing-templates"/>
            <xsl:call-template name="record-postprocessing"/>
            <xsl:call-template name="create-key-mapping-templates"/>
            <xsl:call-template name="create-key-replacement-template"/>
            <xsl:copy-of select="doc($utilsfile)/*:stylesheet/(xsl:template, xsl:function)"/>
            <xsl:copy-of select="doc($mergefile)/*:stylesheet/(xsl:template, xsl:function)"/>
            <xsl:copy-of select="doc($rdffile)/*:stylesheet/(xsl:template, xsl:function)"/>
            <xsl:copy-of select="stylesheet/*"/> <!-- copy any stylesheet templates or functions in the rules file -->
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-record-processing-templates">
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
                    <xsl:attribute name="select" select="string-join(('''', *:anchor/@tag, ''''), '')"/>
                </xsl:element>
                <xsl:if test="exists(anchor/@code)">
                    <xsl:element name="xsl:variable">
                        <xsl:attribute name="name" select="'code'"/>
                        <xsl:attribute name="select" select="anchor/@code"/>
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
            <xsl:attribute name="select" select=" string-join(('node()[@tag=''', anchor/@tag, ''']', if (anchor/@condition) then concat('[', anchor/@condition, ']') else ()), '')"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_field'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'anchor_field'"/>
                <xsl:attribute name="select" select="'(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_field_position'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'string(position())'"/>
            </xsl:element>
            <xsl:choose>
                <xsl:when test="exists(anchor/code)">
                    <xsl:call-template name="code-for-each"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="record-processing"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template name="code-for-each">
        <xsl:element name="xsl:for-each">
            <xsl:attribute name="select" select=" string-join(('node()[@code=''', anchor/code/@code, ''']', if (anchor/code/@condition) then string-join(('[', anchor/code/@condition, ']'), '') else ()), '')"/>
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
                <xsl:attribute name="select" select="anchor/code/@code"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'anchor_subfield_code'"/>
                <xsl:attribute name="select" select="anchor/code/@code"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'this_subfield_position'"/>
                <xsl:attribute name="as" select="'xs:string'"/>
                <xsl:attribute name="select" select="'string(position())'"/>
            </xsl:element>
            <xsl:call-template name="record-processing"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="record-processing">
        <xsl:element name="xsl:element">
            <xsl:attribute name="name" select="'{name(ancestor-or-self::*:record)}'"/>
            <xsl:attribute name="namespace" select="'{namespace-uri(ancestor-or-self::*:record)}'"/><!-- getting name of record-element from source file to preserve the namespace -->
            <xsl:variable name="record-identifier-string">
                <xsl:call-template name="internal-id-template">
                    <xsl:with-param name="code" select="if (anchor/code) then '$this_subfield_code' else ()"/>
                    <xsl:with-param name="code-pos" select="if (anchor/code) then '$this_subfield_position' else ()"/>
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
            <xsl:element name="xsl:attribute">
                <xsl:attribute name="name" select="'templatename'"/>
                <xsl:attribute name="select" select="'$this_template_name'"/>
            </xsl:element>
            <xsl:element name="xsl:if">
                <xsl:attribute name="test" select="'$confidence'"/>
                <xsl:element name="xsl:element">
                    <xsl:attribute name="name" select="'frbrizer:confidence'"/>
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'rule'"/>
                        <xsl:attribute name="select" select="'$this_template_name'"/>
                    </xsl:element>
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'src'"/>
                        <xsl:attribute name="select" select="if (@src) then frbrizer:xpathify(@src) else '''nn''' "/>
                    </xsl:element>
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'cnt'"/>
                        <xsl:attribute name="select" select=" '''1''' "/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:call-template name="controlfields"/>
            <xsl:call-template name="datafields"/>
            <xsl:call-template name="relationships"/>
        </xsl:element>
    </xsl:template>
    <xsl:template name="datafields">
        <xsl:if test="count(attributes/datafield) &gt; 0">
            <xsl:variable name="anchortag" select="anchor/@tag"/>
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
                            <xsl:with-param name="t" select="@type"/>
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
                            <xsl:with-param name="t" select="@type"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="datafield">
        <xsl:param name="p" required="yes"/>
        <xsl:param name="t" required="no" select="''"/>
        <xsl:element name="xsl:for-each">
            <xsl:attribute name="select" select="$p"/>
            <xsl:element name="xsl:copy">
                <xsl:element name="xsl:call-template">
                    <xsl:attribute name="name" select="'copy-attributes'"/>
                </xsl:element>
                <xsl:if test="string($t) ne ''">
                    <xsl:element name="xsl:attribute">
                        <xsl:attribute name="name" select="'type'"/>
                        <xsl:attribute name="select" select="frbrizer:xpathify($t)"/>
                    </xsl:element>
                </xsl:if>
                <xsl:element name="xsl:for-each">
                    <xsl:variable name="p">
                        <xsl:element name="part">
                            <xsl:value-of select="'*:subfield[@code = ('''"/>
                        </xsl:element>
                        <xsl:element name="part">
                            <xsl:value-of select="string-join((for $c in distinct-values(*:subfield/@code) return $c), ''',''')"/>
                        </xsl:element>
                        <xsl:element name="part">
                            <xsl:value-of select="''')]'"/>
                        </xsl:element>
                    </xsl:variable>
                    <xsl:attribute name="select" select="string-join($p/part, '')"/>
                    <xsl:for-each select="*:subfield">
                        <xsl:element name="xsl:if">
                            <xsl:attribute name="test" select="string-join(('@code = ''', @code, '''', if (exists(@condition)) then concat(' and ', @condition) else ()), '')"/>
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
                                                <xsl:attribute name="select" select="if (exists(@select) and (string-length(@select)) != 0) then                                                             @select                                                         else                                                             ('.')"/>
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
            <xsl:variable name="tag_var" select="anchor/@tag"/>
            <xsl:for-each select="attributes/controlfield">
                <xsl:choose>
                    <xsl:when test="@tag = $tag_var">
                        <xsl:variable name="p1" select="'$record/*:controlfield[@tag='''"/>
                        <xsl:variable name="p2" select="@tag"/>
                        <xsl:variable name="p3" select="''']'"/>
                        <xsl:variable name="p4" select="'[$this_field_position]'"/>
                        <xsl:variable name="p5" select="if (exists(condition)) then (string-join(('[', condition, ']'), '')) else ('')"/>
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
                        <xsl:call-template name="controlfield">
                            <xsl:with-param name="p" select="string-join(($p1, $p2, $p3), '')"/>
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
            <xsl:element name="xsl:copy">
                <xsl:element name="xsl:call-template">
                    <xsl:attribute name="name" select="'copy-content'"/>
                    <xsl:if test="string($type) ne ''">
                        <xsl:element name="xsl:with-param">
                            <xsl:attribute name="name" select="'type'"/>
                            <xsl:attribute name="select" select="frbrizer:xpathify($type)"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:element name="xsl:with-param">
                        <xsl:attribute name="name" select="'select'"/>
                        <xsl:attribute name="select" select="if (exists($select) and (string-length($select)) != 0) then                                     $select                                 else                                     ('.')"/>
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
        <xsl:for-each select="*:relationships/*:relationship/*:target[@entity = //*:templates/*:entity/@templatename]"><!-- condition in the xpath-selection is used to avoid linking to non-existing templates -->
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
            <xsl:attribute name="select" select="string-join(('$record/node()[@tag=''', string($target_template/anchor/@tag), ''']', if ($target_template/anchor/@condition) then concat('[', $target_template/anchor/@condition, ']')  else ()), '')"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_template_name'"/>
                <xsl:attribute name="select" select="string-join(('''', $target_template_name, ''''), '')"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_tag'"/>
                <xsl:attribute name="select" select="string-join(('''', $target_template/anchor/@tag, ''''), '')"/>
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
                <xsl:when test="exists($target_template/anchor/code)">
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
            <xsl:attribute name="select" select="                     string-join(('node()[@code=''', string($target_template/anchor/code/@code), ''']',                     if ($target_template/anchor/code/@condition) then                         concat('[', $target_template/anchor/code/@condition, ']')                     else                         ()), '')"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_subfield'"/>
                <xsl:attribute name="select" select="'.'"/>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'target_subfield_code'"/>
                <xsl:attribute name="select" select="$target_template/anchor/code/@code"/>
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
            <xsl:variable name="target_condition" select="                     if (@condition) then                         string-join(('(', @condition, ')'), '')                     else                         ()"/>
            <xsl:variable name="same_target_tag_condition" select="                     if ((@same-field = 'true' and ($target_template/anchor/@tag eq ancestor::entity/anchor/@tag))) then                         '($target_field = $this_field)'                     else                         ()"/>
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
            <xsl:variable name="identifier_string">
                <xsl:call-template name="internal-id-template">
                    <xsl:with-param name="template_name" select="'$target_template_name'"/>
                    <xsl:with-param name="tag" select="'$target_tag'"/>
                    <xsl:with-param name="code" select="                             if ($target_template/anchor/code) then                                 '$target_subfield_code'                             else                                 ()"/>
                    <xsl:with-param name="tag-pos" select="'$target_field_position'"/>
                    <xsl:with-param name="code-pos" select="                             if ($target_template/anchor/code) then                                 '$target_subfield_position'                             else                                 ()"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="xsl:attribute">
                <xsl:attribute name="name" select="'href'"/>
                <xsl:attribute name="select" select="$identifier_string"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="internal-id-template"><!-- template for creating internal identifier value -->
        <xsl:param name="id" required="no" select="'$record/@id'"/>
        <xsl:param name="template_name" required="no" select="'$this_template_name'"/>
        <xsl:param name="tag" required="no" select="'$tag'"/>
        <xsl:param name="code"/>
        <xsl:param name="tag-pos" required="no" select="'$this_field_position'"/>
        <xsl:param name="code-pos"/>
        <xsl:variable name="elements" select="string-join(($id, $template_name, $tag, $code, $tag-pos, $code-pos), ',')"/>
        <xsl:value-of select="concat('string-join((', $elements, '), '':'')')"/>
    </xsl:template>
    <xsl:template name="collection-processing"><!-- parent template for processing the collection of frbrized records-->
        <xsl:variable name="templates" select="."/>
        <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'/*:collection'"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'collection-frbrized'"/>
                <xsl:element name="xsl:copy">
                    <xsl:element name="xsl:call-template">
                        <xsl:attribute name="name" select="'copy-attributes'"/>
                    </xsl:element>
                    <xsl:element name="xsl:for-each">
                        <xsl:attribute name="select" select="'*:record'"/>
                        <xsl:element name="xsl:call-template">
                            <xsl:attribute name="name" select="'create-record-entity-set'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'collection-merged'"/>
                <xsl:element name="xsl:choose">
                    <xsl:element name="xsl:when">
                        <xsl:attribute name="test" select="'$merge'"/>
                        <xsl:element name="xsl:apply-templates">
                            <xsl:attribute name="select" select="'$collection-frbrized'"/>
                            <xsl:attribute name="mode" select="'merge'"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="xsl:otherwise">
                        <xsl:element name="xsl:copy-of">
                            <xsl:attribute name="select" select="'$collection-frbrized'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:choose">
                <xsl:element name="xsl:when">
                    <xsl:attribute name="test" select="'$rdf'"/>
                    <xsl:element name="xsl:apply-templates">
                        <xsl:attribute name="select" select="'$collection-merged'"/>
                        <xsl:attribute name="mode" select="'rdf'"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="xsl:otherwise">
                    <xsl:element name="xsl:copy-of">
                        <xsl:attribute name="select" select="'$collection-merged'"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="record-postprocessing">
        <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'*:record'"/>
            <xsl:attribute name="name" select="'create-record-entity-set'"/>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'record-step1'"/>
                <xsl:element name="frbrizer:record-entity-set">
                    <xsl:for-each select="*:entity">
                        <xsl:element name="xsl:call-template">
                            <xsl:attribute name="name" select="@templatename"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'record-step2'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$record-step1'"/>
                    <xsl:attribute name="mode" select="'create-inverse-relationships'"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'record-step3'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$record-step2'"/>
                    <xsl:attribute name="mode" select="'create-keys'"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:variable">
                <xsl:attribute name="name" select="'record-step4'"/>
                <xsl:element name="xsl:apply-templates">
                    <xsl:attribute name="select" select="'$record-step3'"/>
                    <xsl:attribute name="mode" select="'remove-record-entity-set-parent-element'"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="xsl:copy-of">
                <xsl:attribute name="select" select="'$record-step4'"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template name="create-key-mapping-templates">
        <xsl:variable name="rules" select="."/>
        <xsl:variable name="ordernumbers" select=" for $i in xs:integer(min(entity/key/@order)) to xs:integer(max(entity/key/@order)) return  $i"/>
        <xsl:for-each select="$ordernumbers">
            <xsl:variable name="keyorder" select="."/>
            <xsl:element name="xsl:template">
                <xsl:attribute name="match" select="'frbrizer:record-entity-set'"/>
                <xsl:attribute name="mode" select="concat('create-key-mapping-step-', $keyorder)"/>
                <xsl:element name="frbrizer:keymap">
                    <xsl:element name="xsl:for-each">
                        <xsl:attribute name="select" select="'*:record'"/>
                        <xsl:element name="xsl:choose">
                            <xsl:for-each select="$rules/*:entity[*:key/@order = $keyorder]">
                                <xsl:element name="xsl:when">
                                    <xsl:attribute name="test" select="concat('@templatename = ''', @templatename, '''')"/>
                                    <xsl:element name="xsl:element">
                                        <xsl:attribute name="name" select="'frbrizer:keyentry'"/>
                                        <xsl:element name="xsl:variable">
                                            <xsl:attribute name="name" select="'keystring'"/>
                                            <xsl:attribute name="as" select="'xs:string*'"/>
                                            <xsl:element name="xsl:sequence">
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
                                            </xsl:element>
                                            </xsl:element>
                                        <xsl:element name="xsl:attribute">
                                            <xsl:attribute name="name" select="'key'"/>
                                            <xsl:attribute name="select" select="'concat(''{'', frbrizer:keyfilter(@type), ''='', string-join(frbrizer:keyfilter($keystring), '';''), ''}'')'"/>
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
        <xsl:variable name="ordernumbers" select=" for $i in xs:integer(min(*:entity/*:key/@order)) to xs:integer(max(*:entity/*:key/@order)) return $i"/>
        <xsl:element name="xsl:template">
            <xsl:attribute name="match" select="'*:record-entity-set'"/>
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
    <xsl:function name="frbrizer:xpathify"><!-- This function will process the content as an XPATH-query if it starts with curly braces --><!-- If not it will simply treat the content as a text --><!-- The intended use is to avoid having to type 'text' all the time for attribute-values and rather --><!-- require the rule writer to specify that something is an xquery when it is -->
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