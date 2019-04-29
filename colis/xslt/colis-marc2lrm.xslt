<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">
   <xsl:param name="debug" as="xs:boolean" select="false()"/>
   <xsl:param name="include_MARC001_in_entityrecord"
              as="xs:boolean"
              select="false()"/>
   <xsl:param name="include_MARC001_in_controlfield"
              as="xs:boolean"
              select="false()"/>
   <xsl:param name="include_MARC001_in_subfield" as="xs:boolean" select="false()"/>
   <xsl:param name="include_MARC001_in_relationships"
              as="xs:boolean"
              select="false()"/>
   <xsl:param name="include_labels" as="xs:boolean" select="false()"/>
   <xsl:param name="include_entitylabels" as="xs:boolean" select="false()"/>
   <xsl:param name="include_anchorvalues" as="xs:boolean" select="false()"/>
   <xsl:param name="include_templateinfo" as="xs:boolean" select="false()"/>
   <xsl:param name="include_sourceinfo" as="xs:boolean" select="false()"/>
   <xsl:param name="include_keyvalues" as="xs:boolean" select="false()"/>
   <xsl:param name="include_internal_key" as="xs:boolean" select="false()"/>
   <xsl:param name="include_counters" as="xs:boolean" select="false()"/>
   <xsl:param name="merge" as="xs:boolean" select="true()"/>
   <xsl:param name="rdf" as="xs:boolean" select="true()"/>
   <xsl:param name="ignore_indicators_in_merge" as="xs:boolean" select="true()"/>
   <xsl:param name="include_id_as_element" as="xs:boolean" select="false()"/>
   <xsl:param name="include_missing_reverse_relationships"
              as="xs:boolean"
              select="true()"/>
   <xsl:param name="include_target_entity_type" as="xs:boolean" select="false()"/>
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <xsl:template match="/*:collection">
      <xsl:variable name="collection-unmerged">
         <xsl:copy>
            <xsl:call-template name="copy-attributes"/>
            <xsl:for-each select="*:record">
               <xsl:call-template name="record-set"/>
            </xsl:for-each>
         </xsl:copy>
      </xsl:variable>
      <xsl:variable name="collection-merged">
         <xsl:choose>
            <xsl:when test="$merge">
               <xsl:apply-templates select="$collection-unmerged" mode="merge"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="$collection-unmerged"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$rdf">
            <xsl:apply-templates select="$collection-merged" mode="rdfify"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$collection-merged"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="*:record" name="record-set">
      <xsl:variable name="step1">
         <frbrizer:record-set>
            <xsl:call-template name="MARC21-100-Person"/>
            <xsl:call-template name="MARC21-600-Person"/>
            <xsl:call-template name="MARC21-700-Person"/>
            <xsl:call-template name="MARC21-800-Person"/>
            <xsl:call-template name="MARC21-130-Work"/>
            <xsl:call-template name="MARC21-240-Work"/>
            <xsl:call-template name="MARC21-245-Work"/>
            <xsl:call-template name="MARC21-600-Work"/>
            <xsl:call-template name="MARC21-700-Work"/>
            <xsl:call-template name="MARC21-700-Work-Related"/>
            <xsl:call-template name="MARC21-800-Work"/>
            <xsl:call-template name="MARC21-830-Work"/>
            <xsl:call-template name="MARC21-130-Expression"/>
            <xsl:call-template name="MARC21-240-Expression"/>
            <xsl:call-template name="MARC21-245-Expression"/>
            <xsl:call-template name="MARC21-700-Expression"/>
            <xsl:call-template name="MARC21-001-Manifestation"/>
            <xsl:call-template name="MARC21-773-Manifestation"/>
         </frbrizer:record-set>
      </xsl:variable>
      <xsl:variable name="step2">
         <xsl:apply-templates select="$step1" mode="create-inverse-relationships"/>
      </xsl:variable>
      <xsl:variable name="step3">
         <xsl:apply-templates select="$step2" mode="create-keys"/>
      </xsl:variable>
      <xsl:variable name="step6">
         <xsl:apply-templates select="$step3" mode="remove-record-set"/>
      </xsl:variable>
      <xsl:copy-of select="$step6"/>
   </xsl:template>
   <xsl:template name="MARC21-001-Manifestation">
      <xsl:variable name="this_template_name" select="'MARC21-001-Manifestation'"/>
      <xsl:variable name="tag" as="xs:string" select="'001'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('001')]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10007'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Manifestation'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:controlfield[@tag='001'][$this_field_position]">
               <xsl:copy>
                  <xsl:call-template name="copy-content">
                     <xsl:with-param name="type" select="'http://marc21rdf.info/elements/marc/M001'"/>
                     <xsl:with-param name="select" select="."/>
                     <xsl:with-param name="marcid" select="$marcid"/>
                  </xsl:call-template>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='020'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30004'"/>
                              <xsl:with-param name="label" select="'has identifier for the manifestation'"/>
                              <xsl:with-param name="select" select="concat('urn:isbn:', replace(., '\D', ''))"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='022'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30004'"/>
                              <xsl:with-param name="label" select="'has identifier for the manifestation'"/>
                              <xsl:with-param name="select" select="concat('urn:issn:', ./replace(., '\D', ''))"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='024'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30004'"/>
                              <xsl:with-param name="label" select="'has identifier for the manifestation'"/>
                              <xsl:with-param name="select"
                                              select="concat('urn:',frbrizer:idprefix(../@ind1) ,':', replace(., '\D', ''))"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='245'][*:subfield/@code = ('a','c')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','c')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30156'"/>
                              <xsl:with-param name="label" select="'has title proper'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'b'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30117'"/>
                              <xsl:with-param name="label" select="'has statement of responsibility'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='250'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30107'"/>
                              <xsl:with-param name="label" select="'has edition statement'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='260'][*:subfield/@code = ('a','b','c','e','f','g')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','b','c','e','f','g')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30088'"/>
                              <xsl:with-param name="label" select="'has place of publication'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'b'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30083'"/>
                              <xsl:with-param name="label" select="'has publisher'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30011'"/>
                              <xsl:with-param name="label" select="'has date of publication'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'e'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30111'"/>
                              <xsl:with-param name="label" select="'has publication statement'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30175'"/>
                              <xsl:with-param name="label" select="'has manufacturers name'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30109'"/>
                              <xsl:with-param name="label" select="'has manufacture statement'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='300'][*:subfield/@code = ('a','c')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','c')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30182'"/>
                              <xsl:with-param name="label" select="'has extent'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30169'"/>
                              <xsl:with-param name="label" select="'has dimensions'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='337'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30001'"/>
                              <xsl:with-param name="label" select="'has carrier type'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='338'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30002'"/>
                              <xsl:with-param name="label" select="'has media type'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='490'][*:subfield/@code = ('a','v','l')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','v','l')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30106'"/>
                              <xsl:with-param name="label" select="'has series statement'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'v'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30165'"/>
                              <xsl:with-param name="label" select="'has numbering of serials'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'l'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://marc21rdf.info/elements/marc/M49000l'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('773')]">
               <xsl:variable name="target_template_name" select="'MARC21-773-Manifestation'"/>
               <xsl:variable name="target_tag_value" select="'773'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/m/P30020'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/m/P30033'"/>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="label" select="'is contained in (manifestation)'"/>
                  </xsl:if>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="ilabel" select="'is container for (manifestation)'"/>
                  </xsl:if>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10007'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-100-Person">
      <xsl:variable name="this_template_name" select="'MARC21-100-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'100'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('100')][*:subfield/@code = '1p']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10004'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Person'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='100'][. = $this_field][*:subfield/@code = ('a','d','1p')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','1p')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50111'"/>
                              <xsl:with-param name="label" select="'has name of the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50107'"/>
                              <xsl:with-param name="label" select="'has date associated with the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50094'"/>
                              <xsl:with-param name="label" select="'has identifier for person'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="not(*:subfield[@code = '4']) ">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('245')][false()]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Work'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($this_field, $target_field))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('drt')">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50048'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10013'"/>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('drt')">
               <xsl:for-each select="$record/node()[@tag=('245')][false()]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50048'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10013'"/>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-130-Expression">
      <xsl:variable name="this_template_name" select="'MARC21-130-Expression'"/>
      <xsl:variable name="tag" as="xs:string" select="'130'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('130')][*:subfield/@code = '1w']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Expression'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:controlfield[@tag='008']">
               <xsl:copy>
                  <xsl:call-template name="copy-content">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                     <xsl:with-param name="label" select="'has language of expression'"/>
                     <xsl:with-param name="select" select="substring(., 36, 3)"/>
                     <xsl:with-param name="marcid" select="$marcid"/>
                  </xsl:call-template>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='740'][@ind2 = '0' and frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20312'"/>
                              <xsl:with-param name="label" select="'has title'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='041'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a','d','e','f','j')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','e','f','j')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'e'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'j'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='130'][. = $this_field][*:subfield/@code = ('s','l','g')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('s','l','g')]">
                     <xsl:if test="@code = 's'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'l'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20312'"/>
                              <xsl:with-param name="label" select="'has title'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='336'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20001'"/>
                              <xsl:with-param name="label" select="'has content type'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('001')]">
               <xsl:variable name="target_template_name" select="'MARC21-001-Manifestation'"/>
               <xsl:variable name="target_tag_value" select="'001'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/e/P20059'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/m/P30139'"/>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="label" select="'has manifestation of expression'"/>
                  </xsl:if>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="ilabel" select="'has expression manifested'"/>
                  </xsl:if>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10007'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-130-Work">
      <xsl:variable name="this_template_name" select="'MARC21-130-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'130'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('130')][*:subfield/@code = '1w']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='130'][. = $this_field][*:subfield/@code = ('a','f','n','k','1w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','k','1w')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10219'"/>
                              <xsl:with-param name="label" select="'has date of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10002'"/>
                              <xsl:with-param name="label" select="'has identifier for work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('130')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-130-Expression'"/>
               <xsl:variable name="target_tag_value" select="'130'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="($target_field = $this_field)">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10078'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20231'"/>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="label" select="'has expression of work'"/>
                     </xsl:if>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="ilabel" select="'has work expressed'"/>
                     </xsl:if>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('800')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-800-Work'"/>
               <xsl:variable name="target_tag_value" select="'800'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10019'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10147'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('830')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-830-Work'"/>
               <xsl:variable name="target_tag_value" select="'830'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10019'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10147'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2 ne '2' and *:subfield[@code='t'] and *:subfield[@code=('4')]]">
               <xsl:variable name="target_template_name" select="'MARC21-700-Work-Related'"/>
               <xsl:variable name="target_tag_value" select="'700'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="$target_field/*:subfield[@code = '4']"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1p']">
               <xsl:variable name="target_template_name" select="'MARC21-600-Person'"/>
               <xsl:variable name="target_tag_value" select="'600'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10261'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/a/P50249'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10004'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-600-Work'"/>
               <xsl:variable name="target_tag_value" select="'600'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10257'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10264'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-240-Expression">
      <xsl:variable name="this_template_name" select="'MARC21-240-Expression'"/>
      <xsl:variable name="tag" as="xs:string" select="'240'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('240')][*:subfield/@code = '1w']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Expression'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:controlfield[@tag='008']">
               <xsl:copy>
                  <xsl:call-template name="copy-content">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                     <xsl:with-param name="label" select="'has language of expression'"/>
                     <xsl:with-param name="select" select="substring(., 36, 3)"/>
                     <xsl:with-param name="marcid" select="$marcid"/>
                  </xsl:call-template>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='041'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a','d','e','f','j')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','e','f','j')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'e'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'j'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='240'][. = $this_field][*:subfield/@code = ('s','l','g')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('s','l','g')]">
                     <xsl:if test="@code = 's'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'l'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20312'"/>
                              <xsl:with-param name="label" select="'has title'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='336'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20001'"/>
                              <xsl:with-param name="label" select="'has content type'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('001')]">
               <xsl:variable name="target_template_name" select="'MARC21-001-Manifestation'"/>
               <xsl:variable name="target_tag_value" select="'001'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/e/P20059'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/m/P30139'"/>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="label" select="'has manifestation of expression'"/>
                  </xsl:if>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="ilabel" select="'has expression manifested'"/>
                  </xsl:if>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10007'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-240-Work">
      <xsl:variable name="this_template_name" select="'MARC21-240-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'240'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('240')][*:subfield/@code = '1w']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='240'][. = $this_field][*:subfield/@code = ('a','f','n','k','1w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','k','1w')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10219'"/>
                              <xsl:with-param name="label" select="'has date of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10002'"/>
                              <xsl:with-param name="label" select="'has identifier for work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-240-Expression'"/>
               <xsl:variable name="target_tag_value" select="'240'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="($target_field = $this_field)">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10078'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20231'"/>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="label" select="'has expression of work'"/>
                     </xsl:if>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="ilabel" select="'has work expressed'"/>
                     </xsl:if>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('800')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-800-Work'"/>
               <xsl:variable name="target_tag_value" select="'800'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10019'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10147'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('830')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-830-Work'"/>
               <xsl:variable name="target_tag_value" select="'830'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10019'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10147'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2 ne '2' and *:subfield[@code='t'] and *:subfield[@code=('4')]]">
               <xsl:variable name="target_template_name" select="'MARC21-700-Work-Related'"/>
               <xsl:variable name="target_tag_value" select="'700'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="$target_field/*:subfield[@code = '4']"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1p']">
               <xsl:variable name="target_template_name" select="'MARC21-600-Person'"/>
               <xsl:variable name="target_tag_value" select="'600'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10261'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/a/P50249'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10004'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-600-Work'"/>
               <xsl:variable name="target_tag_value" select="'600'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10257'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10264'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-245-Expression">
      <xsl:variable name="this_template_name" select="'MARC21-245-Expression'"/>
      <xsl:variable name="tag" as="xs:string" select="'245'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('245')][false()]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Expression'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:controlfield[@tag='007']">
               <xsl:copy>
                  <xsl:call-template name="copy-content">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20001'"/>
                     <xsl:with-param name="label" select="'has content type'"/>
                     <xsl:with-param name="select" select="substring(., 1, 1)"/>
                     <xsl:with-param name="marcid" select="$marcid"/>
                  </xsl:call-template>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:controlfield[@tag='008']">
               <xsl:copy>
                  <xsl:call-template name="copy-content">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                     <xsl:with-param name="label" select="'has language of expression'"/>
                     <xsl:with-param name="select" select="substring(., 36, 3)"/>
                     <xsl:with-param name="marcid" select="$marcid"/>
                  </xsl:call-template>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='740'][@ind2 = '0' and frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20312'"/>
                              <xsl:with-param name="label" select="'has title'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='041'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a','d','e','f','j')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','e','f','j')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'e'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'j'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='245'][. = $this_field][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20312'"/>
                              <xsl:with-param name="label" select="'has title'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'b'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='336'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20001'"/>
                              <xsl:with-param name="label" select="'has content type'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('001')]">
               <xsl:variable name="target_template_name" select="'MARC21-001-Manifestation'"/>
               <xsl:variable name="target_tag_value" select="'001'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/e/P20059'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/m/P30139'"/>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="label" select="'has manifestation of expression'"/>
                  </xsl:if>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="ilabel" select="'has expression manifested'"/>
                  </xsl:if>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10007'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-245-Work">
      <xsl:variable name="this_template_name" select="'MARC21-245-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'245'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('245')][false()]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='245'][. = $this_field][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'b']), frbrizer:trim(../*:subfield[@code = 'c'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('245')][false()]">
               <xsl:variable name="target_template_name" select="'MARC21-245-Expression'"/>
               <xsl:variable name="target_tag_value" select="'245'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="($target_field = $this_field)">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10078'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20231'"/>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="label" select="'has expression of work'"/>
                     </xsl:if>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="ilabel" select="'has work expressed'"/>
                     </xsl:if>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('800')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-800-Work'"/>
               <xsl:variable name="target_tag_value" select="'800'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10019'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10147'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('830')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-830-Work'"/>
               <xsl:variable name="target_tag_value" select="'830'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10019'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10147'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2 ne '2' and *:subfield[@code='t'] and *:subfield[@code=('4')]]">
               <xsl:variable name="target_template_name" select="'MARC21-700-Work-Related'"/>
               <xsl:variable name="target_tag_value" select="'700'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="$target_field/*:subfield[@code = '4']"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1p']">
               <xsl:variable name="target_template_name" select="'MARC21-600-Person'"/>
               <xsl:variable name="target_tag_value" select="'600'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10261'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/a/P50249'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10004'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1w']">
               <xsl:variable name="target_template_name" select="'MARC21-600-Work'"/>
               <xsl:variable name="target_tag_value" select="'600'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10257'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10264'"/>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-600-Person">
      <xsl:variable name="this_template_name" select="'MARC21-600-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'600'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('600')][*:subfield/@code = '1p']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10004'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Person'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='600'][. = $this_field][*:subfield/@code = ('a','d','1p')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','1p')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50111'"/>
                              <xsl:with-param name="label" select="'has name of the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50107'"/>
                              <xsl:with-param name="label" select="'has date associated with the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50094'"/>
                              <xsl:with-param name="label" select="'has identifier for person'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="not(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-600-Work'"/>
                  <xsl:variable name="target_tag_value" select="'600'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-600-Work'"/>
                  <xsl:variable name="target_tag_value" select="'600'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('drt')">
               <xsl:for-each select="$record/node()[@tag=('600')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-600-Work'"/>
                  <xsl:variable name="target_tag_value" select="'600'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50048'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10013'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-600-Work">
      <xsl:variable name="this_template_name" select="'MARC21-600-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'600'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('600')][*:subfield/@code = '1w']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='600'][. = $this_field][*:subfield/@code = ('t','f','n','k','1w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','k','1w')]">
                     <xsl:if test="@code = 't'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10219'"/>
                              <xsl:with-param name="label" select="'has date of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10002'"/>
                              <xsl:with-param name="label" select="'has identifier for work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Expression">
      <xsl:variable name="this_template_name" select="'MARC21-700-Expression'"/>
      <xsl:variable name="tag" as="xs:string" select="'700'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Expression'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:controlfield[@tag='008']">
               <xsl:copy>
                  <xsl:call-template name="copy-content">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                     <xsl:with-param name="label" select="'has language of expression'"/>
                     <xsl:with-param name="select" select="substring(., 36, 3)"/>
                     <xsl:with-param name="marcid" select="$marcid"/>
                  </xsl:call-template>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='041'][frbrizer:linked($anchor_field, .) and not(exists($anchor_field/*:subfield[@code = 'l']))][*:subfield/@code = ('a','d','e','f','j')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','e','f','j')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'e'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'j'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='336'][frbrizer:linked($anchor_field, .) and (not($anchor_field/*:subfield[@code='h']))][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20001'"/>
                              <xsl:with-param name="label" select="'has content type'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='700'][. = $this_field][*:subfield/@code = ('h','l','g','t','s')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('h','l','g','t','s')]">
                     <xsl:if test="@code = 'h'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20001'"/>
                              <xsl:with-param name="label" select="'has content type'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'l'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20006'"/>
                              <xsl:with-param name="label" select="'has language of expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20312'"/>
                              <xsl:with-param name="label" select="'has title'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 't' and not(exists($record/*:datafield[@tag = '740' and frbrizer:linked($anchor_field, .)]))">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20312'"/>
                              <xsl:with-param name="label" select="'has title'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 's'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/P20003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the expression'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('001')]">
               <xsl:variable name="target_template_name" select="'MARC21-001-Manifestation'"/>
               <xsl:variable name="target_tag_value" select="'001'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <frbrizer:relationship>
                  <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/e/P20059'"/>
                  <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/m/P30139'"/>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="label" select="'has manifestation of expression'"/>
                  </xsl:if>
                  <xsl:if test="$include_labels">
                     <xsl:attribute name="ilabel" select="'has expression manifested'"/>
                  </xsl:if>
                  <xsl:if test="$include_target_entity_type">
                     <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10007'"/>
                  </xsl:if>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="href"
                                 select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  <xsl:if test="$include_internal_key">
                     <xsl:attribute name="intkey"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                  </xsl:if>
                  <xsl:if test="$include_MARC001_in_relationships">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </frbrizer:relationship>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Person">
      <xsl:variable name="this_template_name" select="'MARC21-700-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'700'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('700')][*:subfield/@code = '1p' and *:subfield[@code='4'] = ('aut', 'drt', 'act', 'trl', 'nrt', 'act')]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10004'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Person'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='700'][. = $this_field][*:subfield/@code = ('a','d','4','1p')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','4','1p')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50111'"/>
                              <xsl:with-param name="label" select="'has name of the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50107'"/>
                              <xsl:with-param name="label" select="'has date associated with the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '4'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'relator code'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50094'"/>
                              <xsl:with-param name="label" select="'has identifier for person'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="not(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Work'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Work'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked-strict($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('245')][false()]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('130')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag_value" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aui')">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Work'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field))) and ($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('drt')">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Work'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked-strict($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50048'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10013'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('drt')">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50048'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10013'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('drt')">
               <xsl:for-each select="$record/node()[@tag=('245')][false()]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50048'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10013'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('drt')">
               <xsl:for-each select="$record/node()[@tag=('130')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag_value" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50048'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10013'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('trl')">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked-strict($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50145'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20037'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('trl')">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50145'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20037'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('trl')">
               <xsl:for-each select="$record/node()[@tag=('245')][false()]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50145'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20037'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('trl')">
               <xsl:for-each select="$record/node()[@tag=('130')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50145'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20037'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('nrt')">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked-strict($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50608'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20378'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('nrt')">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50608'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20378'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('nrt')">
               <xsl:for-each select="$record/node()[@tag=('245')][false()]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50608'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20378'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('nrt')">
               <xsl:for-each select="$record/node()[@tag=('130')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50608'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20378'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('act')">
               <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'700'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked-strict($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50071'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20012'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('act')">
               <xsl:for-each select="$record/node()[@tag=('240')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50071'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20012'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('act')">
               <xsl:for-each select="$record/node()[@tag=('245')][false()]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50071'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20012'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('act')">
               <xsl:for-each select="$record/node()[@tag=('130')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Expression'"/>
                  <xsl:variable name="target_tag_value" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50071'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20012'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Work">
      <xsl:variable name="this_template_name" select="'MARC21-700-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'700'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='700'][. = $this_field][*:subfield/@code = ('t','f','n','k','1w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','k','1w')]">
                     <xsl:if test="@code = 't'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10219'"/>
                              <xsl:with-param name="label" select="'has date of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10002'"/>
                              <xsl:with-param name="label" select="'has identifier for work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2='2' and *:subfield[@code='t'] and not(*:subfield[@code='i'])]">
               <xsl:variable name="target_template_name" select="'MARC21-700-Expression'"/>
               <xsl:variable name="target_tag_value" select="'700'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="($target_field = $this_field)">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/w/P10078'"/>
                     <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/e/P20231'"/>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="label" select="'has expression of work'"/>
                     </xsl:if>
                     <xsl:if test="$include_labels">
                        <xsl:attribute name="ilabel" select="'has work expressed'"/>
                     </xsl:if>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10006'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('700')][*:subfield/@code = '1w' and @ind2 ne '2' and *:subfield[@code='t'] and *:subfield[@code=('4')]]">
               <xsl:variable name="target_template_name" select="'MARC21-700-Work-Related'"/>
               <xsl:variable name="target_tag_value" select="'700'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="($target_field/*:subfield[@code='t'] and frbrizer:linked($this_field, $target_field))">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="$target_field/*:subfield[@code='4']"/>
                     <xsl:if test="$include_target_entity_type">
                        <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                     </xsl:if>
                     <xsl:if test="$include_counters">
                        <xsl:attribute name="c" select="1"/>
                     </xsl:if>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     <xsl:if test="$include_internal_key">
                        <xsl:attribute name="intkey"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                     </xsl:if>
                     <xsl:if test="$include_MARC001_in_relationships">
                        <xsl:element name="frbrizer:mid">
                           <xsl:attribute name="i" select="$marcid"/>
                           <xsl:if test="$include_counters">
                              <xsl:attribute name="c" select="1"/>
                           </xsl:if>
                        </xsl:element>
                     </xsl:if>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Work-Related">
      <xsl:variable name="this_template_name" select="'MARC21-700-Work-Related'"/>
      <xsl:variable name="tag" as="xs:string" select="'700'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('700')][*:subfield/@code = '1w' and @ind2 ne '2' and *:subfield[@code='t'] and *:subfield[@code=('4')]]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='700'][. = $this_field][*:subfield/@code = ('t','f','n','k','1w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','k','1w')]">
                     <xsl:if test="@code = 't'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10219'"/>
                              <xsl:with-param name="label" select="'has date of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10002'"/>
                              <xsl:with-param name="label" select="'has identifier for work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-773-Manifestation">
      <xsl:variable name="this_template_name" select="'MARC21-773-Manifestation'"/>
      <xsl:variable name="tag" as="xs:string" select="'773'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('773')]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10007'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Manifestation'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='773'][. = $this_field][*:subfield/@code = ('a','w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','w')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30156'"/>
                              <xsl:with-param name="label" select="'has title proper'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/m/P30004'"/>
                              <xsl:with-param name="label" select="'identifier - record number'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-800-Person">
      <xsl:variable name="this_template_name" select="'MARC21-800-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'800'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('800')][*:subfield/@code = '1p']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10004'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Person'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='800'][. = $this_field][*:subfield/@code = ('a','d','1p')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','d','1p')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50111'"/>
                              <xsl:with-param name="label" select="'has name of the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50107'"/>
                              <xsl:with-param name="label" select="'has date associated with the person'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/a/P50094'"/>
                              <xsl:with-param name="label" select="'has identifier for person'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="not(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag=('800')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-800-Work'"/>
                  <xsl:variable name="target_tag_value" select="'800'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="*:subfield[@code = '4'] = ('aut')">
               <xsl:for-each select="$record/node()[@tag=('800')][*:subfield/@code = '1w']">
                  <xsl:variable name="target_template_name" select="'MARC21-800-Work'"/>
                  <xsl:variable name="target_tag_value" select="'800'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/a/P50195'"/>
                        <xsl:attribute name="itype" select="'http://rdaregistry.info/Elements/w/P10061'"/>
                        <xsl:if test="$include_target_entity_type">
                           <xsl:attribute name="target_type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
                        </xsl:if>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        <xsl:if test="$include_internal_key">
                           <xsl:attribute name="intkey"
                                          select="string-join(($record/@id,$target_template_name,$target_tag_value,$target_field_position), ':')"/>
                        </xsl:if>
                        <xsl:if test="$include_MARC001_in_relationships">
                           <xsl:element name="frbrizer:mid">
                              <xsl:attribute name="i" select="$marcid"/>
                              <xsl:if test="$include_counters">
                                 <xsl:attribute name="c" select="1"/>
                              </xsl:if>
                           </xsl:element>
                        </xsl:if>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-800-Work">
      <xsl:variable name="this_template_name" select="'MARC21-800-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'800'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('800')][*:subfield/@code = '1w']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='800'][. = $this_field][*:subfield/@code = ('t','f','n','k','1w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','k','1w')]">
                     <xsl:if test="@code = 't'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10219'"/>
                              <xsl:with-param name="label" select="'has date of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10002'"/>
                              <xsl:with-param name="label" select="'has identifier for work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-830-Work">
      <xsl:variable name="this_template_name" select="'MARC21-830-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'830'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('830')][*:subfield/@code = '1w']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor"
                       as="xs:string"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'http://rdaregistry.info/Elements/c/C10001'"/>
            <xsl:if test="$include_labels">
               <xsl:attribute name="label" select="'Work'"/>
            </xsl:if>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$include_counters">
               <xsl:attribute name="c" select="1"/>
            </xsl:if>
            <xsl:if test="$include_anchorvalues">
               <xsl:element name="frbrizer:anchorvalue">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="."/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_templateinfo">
               <xsl:element name="frbrizer:templatename">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_internal_key">
               <xsl:element name="frbrizer:intkey">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:value-of select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
               </xsl:element>
            </xsl:if>
            <xsl:if test="$include_MARC001_in_entityrecord">
               <xsl:element name="frbrizer:mid">
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:attribute name="i" select="$marcid"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='830'][. = $this_field][*:subfield/@code = ('a','f','n','k','1w')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:if test="$include_counters">
                     <xsl:attribute name="c" select="1"/>
                  </xsl:if>
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','k','1w')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10088'"/>
                              <xsl:with-param name="label" select="'has title of the work'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10219'"/>
                              <xsl:with-param name="label" select="'has date of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10003'"/>
                              <xsl:with-param name="label"
                                              select="'has other distinguishing characteristic of the work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10004'"/>
                              <xsl:with-param name="label" select="'has form of work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '1w'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/P10002'"/>
                              <xsl:with-param name="label" select="'has identifier for work'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
                  <xsl:if test="$include_MARC001_in_subfield">
                     <xsl:element name="frbrizer:mid">
                        <xsl:attribute name="i" select="$marcid"/>
                        <xsl:if test="$include_counters">
                           <xsl:attribute name="c" select="1"/>
                        </xsl:if>
                     </xsl:element>
                  </xsl:if>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="frbrizer:record-set" mode="create-key-mapping-step-1">
      <frbrizer:keymap>
         <xsl:for-each select="*:record">
            <xsl:choose>
               <xsl:when test="@templatename = 'MARC21-100-Person'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-personid(*:datafield[@tag='100']))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-600-Person'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-personid(*:datafield[@tag='600']))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-700-Person'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-personid(*:datafield[@tag='700']))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-800-Person'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-personid(*:datafield[@tag='800']))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-001-Manifestation'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(if ((*:datafield[@tag=(&#34;020&#34;,&#34;024&#34;)][1]/*:subfield[@code='a'])[1]) then (*:datafield[@tag=(&#34;020&#34;,&#34;024&#34;)][1]/*:subfield[@code='a'])[1]/replace(., '\(.*\)', '') else concat('http://example.org/', *:controlfield[@tag='001']))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-773-Manifestation'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(concat('http://example.org/', (*:datafield[@tag='773'][1]/*:subfield[@code='w']/replace(., '\W', ''))[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </frbrizer:keymap>
   </xsl:template>
   <xsl:template match="frbrizer:record-set" mode="create-key-mapping-step-2">
      <frbrizer:keymap>
         <xsl:for-each select="*:record">
            <xsl:choose>
               <xsl:when test="@templatename = 'MARC21-130-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='130'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-240-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='240'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-245-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='245'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-600-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='600'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-700-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='700'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-700-Work-Related'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='700'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-800-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='800'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-830-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys(frbrizer:create-workid(*:datafield[@tag='830'], frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/w/P10061']/@href)[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </frbrizer:keymap>
   </xsl:template>
   <xsl:template match="frbrizer:record-set" mode="create-key-mapping-step-3">
      <frbrizer:keymap>
         <xsl:for-each select="*:record">
            <xsl:choose>
               <xsl:when test="@templatename = 'MARC21-130-Expression'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys((frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/e/P20231']/@href))[1])"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((//.[@type='http://rdaregistry.info/Elements/e/P20006'])[1]))"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((*:datafield/*:subfield[@type='http://rdaregistry.info/Elements/e/P20001']/replace(., ' ', ''))[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-240-Expression'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys((frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/e/P20231']/@href))[1])"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((//.[@type='http://rdaregistry.info/Elements/e/P20006'])[1]))"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((*:datafield/*:subfield[@type='http://rdaregistry.info/Elements/e/P20001']/replace(., ' ', ''))[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-245-Expression'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys((frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/e/P20231']/@href))[1])"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((//.[@type='http://rdaregistry.info/Elements/e/P20006'])[1]))"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((*:datafield/*:subfield[@type='http://rdaregistry.info/Elements/e/P20001']/replace(., ' ', ''))[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-700-Expression'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="key">
                        <xsl:value-of select="frbrizer:sort-keys((frbrizer:sort-relationships(*:relationship[@type = 'http://rdaregistry.info/Elements/e/P20231']/@href))[1])"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((//.[@type='http://rdaregistry.info/Elements/e/P20006'])[1]))"/>
                        <xsl:value-of select="frbrizer:sort-keys('/')"/>
                        <xsl:value-of select="frbrizer:sort-keys(lower-case((*:datafield/*:subfield[@type='http://rdaregistry.info/Elements/e/P20001']/replace(., ' ', ''))[1]))"/>
                     </xsl:variable>
                     <xsl:variable name="keyvalue" select="lower-case(replace($key, ' ', ''))"/>
                     <xsl:attribute name="key" select="$keyvalue"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </frbrizer:keymap>
   </xsl:template>
   <xsl:template match="*:record-set" mode="create-keys">
      <xsl:variable name="set-phase-0" select="."/>
      <xsl:variable name="keys-phase-1">
         <xsl:apply-templates select="$set-phase-0" mode="create-key-mapping-step-1"/>
      </xsl:variable>
      <xsl:variable name="set-phase-1">
         <xsl:apply-templates select="$set-phase-0" mode="replace-keys">
            <xsl:with-param name="keymapping" select="$keys-phase-1"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:variable name="keys-phase-2">
         <xsl:apply-templates select="$set-phase-1" mode="create-key-mapping-step-2"/>
      </xsl:variable>
      <xsl:variable name="set-phase-2">
         <xsl:apply-templates select="$set-phase-1" mode="replace-keys">
            <xsl:with-param name="keymapping" select="$keys-phase-2"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:variable name="keys-phase-3">
         <xsl:apply-templates select="$set-phase-2" mode="create-key-mapping-step-3"/>
      </xsl:variable>
      <xsl:variable name="set-phase-3">
         <xsl:apply-templates select="$set-phase-2" mode="replace-keys">
            <xsl:with-param name="keymapping" select="$keys-phase-3"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:copy-of select="$set-phase-3"/>
   </xsl:template>
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 name="copy-content">
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
        <xsl:if test="$include_labels and ($label ne '')">
            <xsl:if test="$label ne ''">
                <xsl:attribute name="label" select="$label"/>
            </xsl:if>
        </xsl:if>
        <xsl:value-of select="normalize-space($select)"/>
        <xsl:if test="$include_MARC001_in_controlfield">
            <xsl:if test="string($marcid) ne ''">
                <xsl:element name="frbrizer:mid">
                    <xsl:attribute name="i" select="$marcid"/>
                </xsl:element>
            </xsl:if>
        </xsl:if>
    </xsl:template>
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 name="copy-attributes">
        <xsl:for-each select="@*">
            <xsl:copy/>
        </xsl:for-each>
    </xsl:template>
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 match="*:record-set"
                 mode="replace-keys"
                 name="replace-keys">
        <xsl:param name="keymapping" required="yes"/>
        <xsl:copy>
            <xsl:call-template name="copy-attributes"/>
            <xsl:for-each select="*:record">
                <xsl:variable name="record_id" select="@id"/>
                <xsl:choose>
                    <xsl:when test="$keymapping//*:keyentry[@id = $record_id]">
                        <xsl:copy>
                            <xsl:for-each select="@*">
                                <xsl:choose>
                                    <xsl:when test="local-name() = 'id'">
                                        <xsl:attribute name="id" select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:if test="$include_sourceinfo">
                                <xsl:element name="frbrizer:source">
                                    <xsl:attribute name="c" select="1"/>
                                    <xsl:value-of select="$record_id"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$include_keyvalues">
                                <xsl:element name="frbrizer:keyvalue">
                                    <xsl:if test="$include_counters">
                                        <xsl:attribute name="f.c" select="1"/>
                                    </xsl:if>
                                    <xsl:value-of select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:if test="$include_id_as_element">
                                <xsl:element name="frbrizer:idvalue">
                                    <xsl:attribute name="c" select="'1'"/>
                                    <xsl:attribute name="id" select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                    <xsl:value-of select="$keymapping//*:keyentry[@id = $record_id]/@key"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:for-each select="node()">
                                <xsl:choose>
                                    <xsl:when test="@href = $keymapping//*:keyentry/@id">
                                        <xsl:variable name="temp" select="@href"/>
                                        <xsl:copy>
                                            <xsl:for-each select="@*">
                                                <xsl:choose>
                                                  <xsl:when test="local-name() = 'href'">
                                                  <xsl:attribute name="href" select="$keymapping//*:keyentry[@id = $temp]/@key"/>
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
                                                  <xsl:attribute name="href" select="$keymapping//*:keyentry[@id = $href]/@key[1]"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:copy-of select="."/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                            <xsl:copy-of select="frbrizer:mid"/>
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
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 match="*:record-set"
                 mode="remove-record-set">
        <xsl:copy-of select="//*:record"/>
    </xsl:template>
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 match="*:record-set"
                 mode="create-inverse-relationships">
        <xsl:if test="$include_missing_reverse_relationships">
            <xsl:variable name="record-set" select="."/>
            <xsl:copy>
                <xsl:for-each select="*:record">
                    <xsl:variable name="record" select="."/>
                    <xsl:variable name="this-entity-id" select="@id"/>
                    <xsl:copy>
                        <xsl:copy-of select="@* | node()"/>
                        <xsl:for-each select="$record-set/*:record[*:relationship[(@href = $this-entity-id)]]">
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
                                        <xsl:if test="exists(@isubtype)">
                                            <xsl:attribute name="subtype" select="@isubtype"/>
                                        </xsl:if>
                                        <xsl:if test="exists(@subtype)">
                                            <xsl:attribute name="isubtype" select="@subtype"/>
                                        </xsl:if>
                                        <xsl:if test="$include_target_entity_type">
                                            <xsl:attribute name="target_type" select="$target-entity-type"/>
                                        </xsl:if>
                                        <xsl:if test="$include_counters">
                                            <xsl:attribute name="c" select="'1'"/>
                                        </xsl:if>
                                        <xsl:attribute name="href" select="$target-entity-id"/>
                                        <xsl:if test="$include_labels">
                                            <xsl:if test="@ilabel ne ''">
                                                <xsl:attribute name="label" select="@ilabel"/>
                                            </xsl:if>
                                            <xsl:if test="@label ne ''">
                                                <xsl:attribute name="ilabel" select="@label"/>
                                            </xsl:if>
                                        </xsl:if>
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
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 match="/*:collection"
                 mode="merge"
                 name="merge">
        <xsl:param name="ignore_indicators_in_merge" select="false()" required="no"/>
        <xsl:copy>
            <xsl:for-each-group select="//*:record" group-by="@id">
                <xsl:sort select="@type"/>
                <xsl:sort select="@subtype"/>
                <xsl:sort select="@id"/>
                <xsl:element name="{name(current-group()[1])}"
                         namespace="{namespace-uri(current-group()[1])}">
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
                    <xsl:for-each-group select="current-group()/*:controlfield"
                                   group-by="string-join((@tag, @type, string(.)), '')">
                        <xsl:sort select="@tag"/>
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
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
                    <xsl:for-each-group select="current-group()/*:datafield"
                                   group-by="                             normalize-space(string-join(((@tag), @type,                             (if ($ignore_indicators_in_merge) then                                 ()                             else                                 (@ind1, @ind2)), *:subfield/@code, *:subfield/@type, *:subfield/text()), ''))">
                        <xsl:sort select="@tag"/>
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                            <xsl:copy-of select="current-group()[1]/@tag"/>
                            <xsl:copy-of select="current-group()[1]/@ind1"/>
                            <xsl:copy-of select="current-group()[1]/@ind2"/>
                            <xsl:copy-of select="current-group()[1]/@type"/>
                            <xsl:copy-of select="current-group()[1]/@subtype"/>
                            <xsl:copy-of select="current-group()[1]/@label"/>
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:for-each-group select="current-group()/*:subfield"
                                         group-by="concat(@code, @type, text())">
                                <xsl:sort select="@code"/>
                                <xsl:sort select="@type"/>
                                <xsl:for-each select="distinct-values(current-group()/text())">
                                    <xsl:element name="{name(current-group()[1])}"
                                        namespace="{namespace-uri(current-group()[1])}">
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
                                    <xsl:element name="{name(current-group()[1])}"
                                        namespace="{namespace-uri(current-group()[1])}">
                                        <xsl:attribute name="i" select="."/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:relationship"
                                   group-by="concat(@type, @href, @subtype)">
                        <xsl:sort select="@type"/>
                        <xsl:sort select="@subtype"/>
                        <xsl:sort select="@id"/>
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                            <xsl:copy-of select="@* except (@c | @ilabel | @itype | @isubtype)"/>
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:for-each-group select="current-group()/*:mid" group-by="@i">
                                <xsl:for-each select="distinct-values(current-group()/@i)">
                                    <xsl:element name="{name(current-group()[1])}"
                                        namespace="{namespace-uri(current-group()[1])}">
                                        <xsl:attribute name="i" select="."/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:template" group-by=".">
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/mid" group-by="@i">
                        <xsl:for-each select="distinct-values(current-group()/@i)">
                            <xsl:element name="{name(current-group()[1])}"
                                  namespace="{namespace-uri(current-group()[1])}">
                                <xsl:attribute name="i" select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:anchorvalue" group-by=".">
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:idvalue" group-by="@id">
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
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
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:keyvalue" group-by=".">
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                            <xsl:if test="current-group()[1]/@c">
                                <xsl:attribute name="c" select="sum(current-group()/@c)"/>
                            </xsl:if>
                            <xsl:value-of select="current-group()[1]"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:label" group-by=".">
                        <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
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
    </xsl:template>
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 match="/*:collection"
                 mode="rdfify"
                 name="rdfify">
        <rdf:RDF xml:base="http://example.org/rda/">
            <xsl:for-each-group select="( //@type[starts-with(., 'http')])"
                             group-by="replace(., tokenize(., '/')[last()], '')">
                <xsl:namespace name="{tokenize(., '/')[last() - 1]}" select="current-grouping-key()"/>
            </xsl:for-each-group>
            <xsl:for-each-group select="//*:record[starts-with(@type, 'http')]"
                             group-by="@id, @type"
                             composite="yes">
                <xsl:sort select="@type"/>
                <xsl:sort select="@id"/>
                <xsl:variable name="p" select="tokenize(@type, '/')[last() - 1]"/>
                <xsl:variable name="n" select="tokenize(@type, '/')[last()]"/>
                <xsl:element name="{concat($p, ':', $n)}"
                         namespace="{replace(@type, tokenize(@type, '/')[last()], '')}">
                    <xsl:attribute name="rdf:about" select="@id"/>
                    <xsl:for-each-group select="current-group()//(*:subfield, *:controlfield)[starts-with(@type, 'http')]"
                                   group-by="@type, text()"
                                   composite="yes">
                        <xsl:variable name="pre" select="tokenize(@type, '/')[last() - 1]"/>
                        <xsl:variable name="nm" select="tokenize(@type, '/')[last()]"/>
                        <xsl:element name="{concat($pre, ':', $nm)}"
                               namespace="{replace(@type, tokenize(@type, '/')[last()], '')}">
                            <xsl:copy-of select="current-group()[1]/text()"/>
                        </xsl:element>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:relationship[starts-with(@type, 'http')]"
                                   group-by="@type, @href"
                                   composite="yes">
                        <xsl:sort select="@type"/>
                        <xsl:variable name="pre" select="tokenize(@type, '/')[last() - 1]"/>
                        <xsl:variable name="nm" select="tokenize(@type, '/')[last()]"/>
                        <xsl:element name="{concat($pre, ':', $nm)}"
                               namespace="{replace(@type, tokenize(@type, '/')[last()], '')}">
                            <xsl:attribute name="rdf:resource" select="current-group()[1]/@href"/>
                        </xsl:element>                        
                    </xsl:for-each-group>
                </xsl:element>
            </xsl:for-each-group>
        </rdf:RDF>
    </xsl:template>
   <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 name="local:sort-keys">
        <xsl:param name="keys"/>
        <xsl:perform-sort select="distinct-values($keys)">
            <xsl:sort select="."/>
        </xsl:perform-sort>
    </xsl:function>
   <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 name="local:sort-relationships">
        <xsl:param name="relationships"/>
        <xsl:perform-sort select="$relationships">
            <xsl:sort select="@id"/>
        </xsl:perform-sort>
    </xsl:function>
   <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="local:create-personid">
            <xsl:param name="datafield"/>
            <xsl:choose>
                <xsl:when test="$datafield/*:subfield[@code = '1p']">
                    <xsl:value-of select="($datafield/*:subfield[@code = '1p'])[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="replace(lower-case(string-join(($datafield/*:subfield[@code = 'a'], $datafield/*:subfield[@code = 'b'], $datafield/*:subfield[@code = 'c'], $datafield/*:subfield[@code = 'd']), '')), '[^A-Za-z0-9]', '')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:function>
   <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="local:create-workid">
            <xsl:param name="datafield"/>
            <xsl:param name="relationship"/>
            <xsl:choose>
                <xsl:when test="$datafield/*:subfield[@code = '1w']">
                    <xsl:value-of select="($datafield/*:subfield[@code = '1w'])[1]"/>
                </xsl:when>
                <xsl:when test="$datafield[@tag='240']">
                    <xsl:variable name="value"
                          select="replace(lower-case(string-join(($datafield/*:subfield[@code = 'a'], $datafield/*:subfield[@code = 'k'], $datafield/*:subfield[@code = 'n'], $datafield/*:subfield[@code = 'o'], $datafield/*:subfield[@code = 'p']), '')), '[^A-Za-z0-9]', '')"/>
                    <xsl:value-of select="$relationship||'/'||$value"/>
                </xsl:when>
                <xsl:when test="$datafield[@tag='245']">
                    <xsl:variable name="value"
                          select="replace(lower-case(string-join(($datafield/*:subfield[@code = 'a'], $datafield/*:subfield[@code = 'b']), '')), '[^A-Za-z0-9]', '')"/>
                    <xsl:value-of select="$relationship||'/'||$value"/>
                </xsl:when>
                <xsl:when test="$datafield[@tag=('600', '700', '800')]">
                    <xsl:variable name="value"
                          select="replace(lower-case(string-join(($datafield/*:subfield[@code = 't'], $datafield/*:subfield[@code = 'k'], $datafield/*:subfield[@code = 'n'], $datafield/*:subfield[@code = 'o'], $datafield/*:subfield[@code = 'p']), '')), '[^A-Za-z0-9]', '')"/>
                    <xsl:value-of select="$relationship||'/'||$value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$relationship||'/noidentifier'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:linked"
                 as="xs:boolean">
            <!-- returns true if the two fields have the same marc 21 link ($8), or if there is no linking subfields in target or source -->
            <xsl:param name="anchor" as="element()"/>
            <xsl:param name="target" as="element()"/>
            <xsl:value-of select="(some $x in $anchor/subfield[@code='8'] satisfies $x = $target/subfield[@code='8']) or (not(exists($anchor/subfield[@code='8'])) or not(exists($target/subfield[@code='8'])))"/>  
            <!--<xsl:value-of select=" (some $x in $anchor/*:subfield[@code = '8'] satisfies $x = $target/*:subfield[@code = '8']) or (not(exists($target/*:subfield[@code = '8'])))"/>-->
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:linked-strict"
                 as="xs:boolean">
            <!-- returns true if the two fields have the same marc 21 link ($8) -->
            <xsl:param name="anchor" as="element()"/>
            <xsl:param name="target" as="element()"/>
            <xsl:value-of select="some $x in $anchor/*:subfield[@code = '8'] satisfies $x = $target/*:subfield[@code = '8']"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:trim"
                 as="xs:string*">
            <xsl:param name="value" as="element()*"/>
            <xsl:for-each select="$value">
                <xsl:value-of select="replace(., '[ \.,/:]+$', '')"/>
            </xsl:for-each>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:idprefix">
            <xsl:param name="value"/>
            <xsl:choose>
                <xsl:when test="$value = '0'">
                    <xsl:value-of select="'isrc'"/>
                </xsl:when>
                <xsl:when test="$value = '1'">
                    <xsl:value-of select="'upc'"/>
                </xsl:when>
                <xsl:when test="$value = '2'">
                    <xsl:value-of select="'ismn'"/>
                </xsl:when>
                <xsl:when test="$value = '3'">
                    <xsl:value-of select="'ian'"/>
                </xsl:when>
                <xsl:when test="$value = '4'">
                    <xsl:value-of select="'sici'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'unknown'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:function>
</xsl:stylesheet>
