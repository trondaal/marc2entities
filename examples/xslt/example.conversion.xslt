<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">
   <xsl:param name="confidence" as="xs:boolean" select="false()"/>
   <xsl:param name="merge" as="xs:boolean" select="true()"/>
   <xsl:param name="rdf" as="xs:boolean" select="false()"/>
   <xsl:param name="inverse" as="xs:boolean" select="true()"/>
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <xsl:template match="/*:collection">
      <xsl:variable name="collection-frbrized">
         <xsl:copy>
            <xsl:call-template name="copy-attributes"/>
            <xsl:for-each select="*:record">
               <xsl:call-template name="create-record-entity-set"/>
            </xsl:for-each>
         </xsl:copy>
      </xsl:variable>
      <xsl:variable name="collection-merged">
         <xsl:choose>
            <xsl:when test="$merge">
               <xsl:apply-templates select="$collection-frbrized" mode="merge"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:copy-of select="$collection-frbrized"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$rdf">
            <xsl:apply-templates select="$collection-merged" mode="rdf"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy-of select="$collection-merged"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template name="MARC21-100-Person">
      <xsl:variable name="this_template_name" select="'MARC21-100-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'100'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='100']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Person'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='100'][. = $this_field][*:subfield/@code = ('a','c','d','u','0')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','c','d','u','0')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfPerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:titleOfThePerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithPerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = '0'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:identifierForAgent'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-110-CorporateBody">
      <xsl:variable name="this_template_name" select="'MARC21-110-CorporateBody'"/>
      <xsl:variable name="tag" as="xs:string" select="'110'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='110']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:CorporateBody'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='110'][. = $this_field][*:subfield/@code = ('a','b','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','b','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'b'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'u:hierarchicalSubordinate'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:placeAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-111-CorporateBody">
      <xsl:variable name="this_template_name" select="'MARC21-111-CorporateBody'"/>
      <xsl:variable name="tag" as="xs:string" select="'111'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='111']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:CorporateBody'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='111'][. = $this_field][*:subfield/@code = ('a','b','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','b','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'b'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'u:hierarchicalSubordinate'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:placeAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])">
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <frbrizer:relationship>
                     <xsl:attribute name="type"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                     <xsl:attribute name="itype"
                                    select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:for-each>
            </xsl:if>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-130-Work">
      <xsl:variable name="this_template_name" select="'MARC21-130-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'130'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='130']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Work'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='130'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:titleOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'm'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'o'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'r'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:key'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='520'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-240-Work">
      <xsl:variable name="this_template_name" select="'MARC21-240-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'240'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='240']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Work'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='240'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:titleOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'm'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'o'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'r'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:key'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-245-Work">
      <xsl:variable name="this_template_name" select="'MARC21-245-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'245'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Work'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='245'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:titleOfWork'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'b'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'm'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'o'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'r'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:key'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-246-Work">
      <xsl:variable name="this_template_name" select="'MARC21-246-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'246'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Work'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='246'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:titleOfWork'"/>
                              <xsl:with-param name="select"
                                              select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'b'])), ' : ')"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'm'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'o'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'r'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:key'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-600-Person">
      <xsl:variable name="this_template_name" select="'MARC21-600-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'600'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='600']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Person'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='600'][. = $this_field][*:subfield/@code = ('a','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfPerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:titleOfThePerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithPerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='130']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="$record/node()[@tag='600']">
               <xsl:variable name="target_template_name" select="'MARC21-600-Work'"/>
               <xsl:variable name="target_tag" select="'600'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:for-each select="node()[@code='t']">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code" select="t"/>
                  <xsl:variable name="target_subfield_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                        <xsl:attribute name="itype"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_subfield_code,$target_field_position,$target_subfield_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-600-Work">
      <xsl:variable name="this_template_name" select="'MARC21-600-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'600'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='600']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:for-each select="node()[@code='t']">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code" select="t"/>
            <xsl:variable name="anchor_subfield_code" select="t"/>
            <xsl:variable name="this_subfield_position"
                          as="xs:string"
                          select="string(position())"/>
            <xsl:element name="{name(ancestor-or-self::*:record)}"
                         namespace="{namespace-uri(ancestor-or-self::*:record)}">
               <xsl:attribute name="id"
                              select="string-join(($record/@id,$this_template_name,$tag,$this_subfield_code,$this_field_position,$this_subfield_position), ':')"/>
               <xsl:attribute name="type" select="'c:Work'"/>
               <xsl:attribute name="templatename" select="$this_template_name"/>
               <xsl:if test="$confidence">
                  <xsl:element name="frbrizer:confidence">
                     <xsl:attribute name="rule" select="$this_template_name"/>
                     <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                     <xsl:attribute name="cnt" select="'1'"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$record/*:datafield[@tag='600'][. = $this_field][*:subfield/@code = ('t','d','f','g','k','m','n','o','p','r')]">
                  <xsl:copy>
                     <xsl:call-template name="copy-attributes"/>
                     <xsl:for-each select="*:subfield[@code = ('t','d','f','g','k','m','n','o','p','r')]">
                        <xsl:if test="@code = 't'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:titleOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'd'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'f'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'g'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'k'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:formOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'm'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'n'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'o'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'p'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'r'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:key'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:copy>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='130']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-610-CorporateBody">
      <xsl:variable name="this_template_name" select="'MARC21-610-CorporateBody'"/>
      <xsl:variable name="tag" as="xs:string" select="'610'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='610']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Person'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='610'][. = $this_field][*:subfield/@code = ('a','b','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','b','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'b'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'u:hierarchicalSubordinate'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:placeAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='130']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="$record/node()[@tag='610']">
               <xsl:variable name="target_template_name" select="'MARC21-610-Work'"/>
               <xsl:variable name="target_tag" select="'610'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:for-each select="node()[@code='t']">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code" select="t"/>
                  <xsl:variable name="target_subfield_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                        <xsl:attribute name="itype"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_subfield_code,$target_field_position,$target_subfield_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-610-Work">
      <xsl:variable name="this_template_name" select="'MARC21-610-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'610'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='610']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:for-each select="node()[@code='t']">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code" select="t"/>
            <xsl:variable name="anchor_subfield_code" select="t"/>
            <xsl:variable name="this_subfield_position"
                          as="xs:string"
                          select="string(position())"/>
            <xsl:element name="{name(ancestor-or-self::*:record)}"
                         namespace="{namespace-uri(ancestor-or-self::*:record)}">
               <xsl:attribute name="id"
                              select="string-join(($record/@id,$this_template_name,$tag,$this_subfield_code,$this_field_position,$this_subfield_position), ':')"/>
               <xsl:attribute name="type" select="'c:Work'"/>
               <xsl:attribute name="templatename" select="$this_template_name"/>
               <xsl:if test="$confidence">
                  <xsl:element name="frbrizer:confidence">
                     <xsl:attribute name="rule" select="$this_template_name"/>
                     <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                     <xsl:attribute name="cnt" select="'1'"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$record/*:datafield[@tag='610'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
                  <xsl:copy>
                     <xsl:call-template name="copy-attributes"/>
                     <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                        <xsl:if test="@code = 'a'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:titleOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'd'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'f'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'g'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'k'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:formOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'm'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'n'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'o'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'p'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'r'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:key'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:copy>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='130']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-611-CorporateBody">
      <xsl:variable name="this_template_name" select="'MARC21-611-CorporateBody'"/>
      <xsl:variable name="tag" as="xs:string" select="'611'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='611']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Person'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='611'][. = $this_field][*:subfield/@code = ('a','b','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','b','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'b'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'u:hierarchicalSubordinate'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:placeAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='130']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(exists(*:subfield[@code= 't']))">
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="$record/node()[@tag='611']">
               <xsl:variable name="target_template_name" select="'MARC21-611-Work'"/>
               <xsl:variable name="target_tag" select="'611'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:for-each select="node()[@code='t']">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code" select="t"/>
                  <xsl:variable name="target_subfield_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                        <xsl:attribute name="itype"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_subfield_code,$target_field_position,$target_subfield_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-611-Work">
      <xsl:variable name="this_template_name" select="'MARC21-611-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'611'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='611']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:for-each select="node()[@code='t']">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code" select="t"/>
            <xsl:variable name="anchor_subfield_code" select="t"/>
            <xsl:variable name="this_subfield_position"
                          as="xs:string"
                          select="string(position())"/>
            <xsl:element name="{name(ancestor-or-self::*:record)}"
                         namespace="{namespace-uri(ancestor-or-self::*:record)}">
               <xsl:attribute name="id"
                              select="string-join(($record/@id,$this_template_name,$tag,$this_subfield_code,$this_field_position,$this_subfield_position), ':')"/>
               <xsl:attribute name="type" select="'c:Work'"/>
               <xsl:attribute name="templatename" select="$this_template_name"/>
               <xsl:if test="$confidence">
                  <xsl:element name="frbrizer:confidence">
                     <xsl:attribute name="rule" select="$this_template_name"/>
                     <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                     <xsl:attribute name="cnt" select="'1'"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$record/*:datafield[@tag='611'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
                  <xsl:copy>
                     <xsl:call-template name="copy-attributes"/>
                     <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                        <xsl:if test="@code = 'a'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:titleOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'd'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'f'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'g'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'k'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:formOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'm'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'n'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'o'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'p'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'r'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:key'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:copy>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='130']">
                  <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
                  <xsl:variable name="target_tag" select="'130'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='240']">
                  <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
                  <xsl:variable name="target_tag" select="'240'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
                  <xsl:variable name="target_tag" select="'245'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
                  <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
                  <xsl:variable name="target_tag" select="'246'"/>
                  <xsl:variable name="target_field"
                                select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                     <frbrizer:relationship>
                        <xsl:attribute name="type" select="'frsad:P2002'"/>
                        <xsl:attribute name="itype" select="'frsad:P2001'"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-630-Work">
      <xsl:variable name="this_template_name" select="'MARC21-630-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'630'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='630']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Work'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='630'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:titleOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'm'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'o'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'r'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:key'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag='130']">
               <xsl:variable name="target_template_name" select="'MARC21-130-Work'"/>
               <xsl:variable name="target_tag" select="'130'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'frsad:P2002'"/>
                     <xsl:attribute name="itype" select="'frsad:P2001'"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag='240']">
               <xsl:variable name="target_template_name" select="'MARC21-240-Work'"/>
               <xsl:variable name="target_tag" select="'240'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'frsad:P2002'"/>
                     <xsl:attribute name="itype" select="'frsad:P2001'"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag='245'][not(exists($record/*:datafield[@tag=('246') and *:subfield[@code='i'  ] = 'Orginaltittel'])) and not(exists($record/*:datafield[@tag=('240', '130')]))]">
               <xsl:variable name="target_template_name" select="'MARC21-245-Work'"/>
               <xsl:variable name="target_tag" select="'245'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'frsad:P2002'"/>
                     <xsl:attribute name="itype" select="'frsad:P2001'"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag='246'][*:subfield[@code='i'] = 'Originaltittel']">
               <xsl:variable name="target_template_name" select="'MARC21-246-Work'"/>
               <xsl:variable name="target_tag" select="'246'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:if test="((frbrizer:linked($this_field, $target_field)))">
                  <frbrizer:relationship>
                     <xsl:attribute name="type" select="'frsad:P2002'"/>
                     <xsl:attribute name="itype" select="'frsad:P2001'"/>
                     <xsl:attribute name="href"
                                    select="string-join(($record/@id,$target_template_name,$target_tag,$target_field_position), ':')"/>
                  </frbrizer:relationship>
               </xsl:if>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Person">
      <xsl:variable name="this_template_name" select="'MARC21-700-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'700'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='700']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Person'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='700'][. = $this_field][*:subfield/@code = ('a','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfPerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:titleOfThePerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithPerson'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag='700']">
               <xsl:variable name="target_template_name" select="'MARC21-700-Work'"/>
               <xsl:variable name="target_tag" select="'700'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:for-each select="node()[@code='t']">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code" select="t"/>
                  <xsl:variable name="target_subfield_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                        <xsl:attribute name="itype"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_subfield_code,$target_field_position,$target_subfield_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Work">
      <xsl:variable name="this_template_name" select="'MARC21-700-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'700'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='700']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:for-each select="node()[@code='t']">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code" select="t"/>
            <xsl:variable name="anchor_subfield_code" select="t"/>
            <xsl:variable name="this_subfield_position"
                          as="xs:string"
                          select="string(position())"/>
            <xsl:element name="{name(ancestor-or-self::*:record)}"
                         namespace="{namespace-uri(ancestor-or-self::*:record)}">
               <xsl:attribute name="id"
                              select="string-join(($record/@id,$this_template_name,$tag,$this_subfield_code,$this_field_position,$this_subfield_position), ':')"/>
               <xsl:attribute name="type" select="'c:Work'"/>
               <xsl:attribute name="subtype" select="$anchor_field/*:subfield[@code='k']"/>
               <xsl:attribute name="templatename" select="$this_template_name"/>
               <xsl:if test="$confidence">
                  <xsl:element name="frbrizer:confidence">
                     <xsl:attribute name="rule" select="$this_template_name"/>
                     <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                     <xsl:attribute name="cnt" select="'1'"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$record/*:datafield[@tag='700'][. = $this_field][*:subfield/@code = ('t','d','f','g','k','m','n','o','p','r')]">
                  <xsl:copy>
                     <xsl:call-template name="copy-attributes"/>
                     <xsl:for-each select="*:subfield[@code = ('t','d','f','g','k','m','n','o','p','r')]">
                        <xsl:if test="@code = 't'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:titleOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'd'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'f'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'g'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'k'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:formOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'm'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'n'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'o'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'p'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'r'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:key'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:copy>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-710-CorporateBody">
      <xsl:variable name="this_template_name" select="'MARC21-710-CorporateBody'"/>
      <xsl:variable name="tag" as="xs:string" select="'710'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='710']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Person'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='710'][. = $this_field][*:subfield/@code = ('a','b','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','b','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'b'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'u:hierarchicalSubordinate'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:placeAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag='710']">
               <xsl:variable name="target_template_name" select="'MARC21-710-Work'"/>
               <xsl:variable name="target_tag" select="'710'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:for-each select="node()[@code='t']">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code" select="t"/>
                  <xsl:variable name="target_subfield_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                        <xsl:attribute name="itype"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_subfield_code,$target_field_position,$target_subfield_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-710-Work">
      <xsl:variable name="this_template_name" select="'MARC21-710-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'710'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='710']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:for-each select="node()[@code='t']">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code" select="t"/>
            <xsl:variable name="anchor_subfield_code" select="t"/>
            <xsl:variable name="this_subfield_position"
                          as="xs:string"
                          select="string(position())"/>
            <xsl:element name="{name(ancestor-or-self::*:record)}"
                         namespace="{namespace-uri(ancestor-or-self::*:record)}">
               <xsl:attribute name="id"
                              select="string-join(($record/@id,$this_template_name,$tag,$this_subfield_code,$this_field_position,$this_subfield_position), ':')"/>
               <xsl:attribute name="type" select="'c:Work'"/>
               <xsl:attribute name="templatename" select="$this_template_name"/>
               <xsl:if test="$confidence">
                  <xsl:element name="frbrizer:confidence">
                     <xsl:attribute name="rule" select="$this_template_name"/>
                     <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                     <xsl:attribute name="cnt" select="'1'"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$record/*:datafield[@tag='710'][. = $this_field][*:subfield/@code = ('t','d','f','g','k','m','n','o','p','r')]">
                  <xsl:copy>
                     <xsl:call-template name="copy-attributes"/>
                     <xsl:for-each select="*:subfield[@code = ('t','d','f','g','k','m','n','o','p','r')]">
                        <xsl:if test="@code = 't'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:titleOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'd'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'f'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'g'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'k'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:formOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'm'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'n'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'o'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'p'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'r'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:key'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:copy>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-711-CorporateBody">
      <xsl:variable name="this_template_name" select="'MARC21-711-CorporateBody'"/>
      <xsl:variable name="tag" as="xs:string" select="'711'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='711']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Person'"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='711'][. = $this_field][*:subfield/@code = ('a','b','c','d','u')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','b','c','d','u')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:nameOfCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'b'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'u:hierarchicalSubordinate'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'c'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:placeAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:dateAssociatedWithCorporateBody'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'u'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'a:affiliation'"/>
                              <xsl:with-param name="select" select="frbrizer:trim(.)"/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag='711']">
               <xsl:variable name="target_template_name" select="'MARC21-711-Work'"/>
               <xsl:variable name="target_tag" select="'711'"/>
               <xsl:variable name="target_field"
                             select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                             as="xs:string"
                             select="string(position())"/>
               <xsl:for-each select="node()[@code='t']">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code" select="t"/>
                  <xsl:variable name="target_subfield_position"
                                as="xs:string"
                                select="string(position())"/>
                  <xsl:if test="($target_field = $this_field)">
                     <frbrizer:relationship>
                        <xsl:attribute name="type"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())"/>
                        <xsl:attribute name="itype"
                                       select="frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())"/>
                        <xsl:attribute name="href"
                                       select="string-join(($record/@id,$target_template_name,$target_tag,$target_subfield_code,$target_field_position,$target_subfield_position), ':')"/>
                     </frbrizer:relationship>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-711-Work">
      <xsl:variable name="this_template_name" select="'MARC21-711-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'711'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='711']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:for-each select="node()[@code='t']">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code" select="t"/>
            <xsl:variable name="anchor_subfield_code" select="t"/>
            <xsl:variable name="this_subfield_position"
                          as="xs:string"
                          select="string(position())"/>
            <xsl:element name="{name(ancestor-or-self::*:record)}"
                         namespace="{namespace-uri(ancestor-or-self::*:record)}">
               <xsl:attribute name="id"
                              select="string-join(($record/@id,$this_template_name,$tag,$this_subfield_code,$this_field_position,$this_subfield_position), ':')"/>
               <xsl:attribute name="type" select="'c:Work'"/>
               <xsl:attribute name="templatename" select="$this_template_name"/>
               <xsl:if test="$confidence">
                  <xsl:element name="frbrizer:confidence">
                     <xsl:attribute name="rule" select="$this_template_name"/>
                     <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                     <xsl:attribute name="cnt" select="'1'"/>
                  </xsl:element>
               </xsl:if>
               <xsl:for-each select="$record/*:datafield[@tag='711'][. = $this_field][*:subfield/@code = ('t','d','f','g','k','m','n','o','p','r')]">
                  <xsl:copy>
                     <xsl:call-template name="copy-attributes"/>
                     <xsl:for-each select="*:subfield[@code = ('t','d','f','g','k','m','n','o','p','r')]">
                        <xsl:if test="@code = 't'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:titleOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'd'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'f'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:dateOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'g'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'k'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:formOfWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'm'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'n'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'o'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'p'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                        <xsl:if test="@code = 'r'">
                           <xsl:copy>
                              <xsl:call-template name="copy-content">
                                 <xsl:with-param name="type" select="'w:key'"/>
                                 <xsl:with-param name="select" select="."/>
                              </xsl:call-template>
                           </xsl:copy>
                        </xsl:if>
                     </xsl:for-each>
                  </xsl:copy>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-730-Work">
      <xsl:variable name="this_template_name" select="'MARC21-730-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'730'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag='730']">
         <xsl:variable name="this_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="anchor_field"
                       select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
         <xsl:variable name="this_field_position"
                       as="xs:string"
                       select="string(position())"/>
         <xsl:element name="{name(ancestor-or-self::*:record)}"
                      namespace="{namespace-uri(ancestor-or-self::*:record)}">
            <xsl:attribute name="id"
                           select="string-join(($record/@id,$this_template_name,$tag,$this_field_position), ':')"/>
            <xsl:attribute name="type" select="'c:Work'"/>
            <xsl:attribute name="subtype"
                           select="if ($anchor_field/*:subfield[@code='k']) then $anchor_field/*:subfield[@code='k'] else $record/*:datafield[@tag='380']/*:subfield[@code = 'a']"/>
            <xsl:attribute name="templatename" select="$this_template_name"/>
            <xsl:if test="$confidence">
               <xsl:element name="frbrizer:confidence">
                  <xsl:attribute name="rule" select="$this_template_name"/>
                  <xsl:attribute name="src" select="tokenize(tokenize(base-uri(), '/')[last()], '-')[1]"/>
                  <xsl:attribute name="cnt" select="'1'"/>
               </xsl:element>
            </xsl:if>
            <xsl:for-each select="$record/*:datafield[@tag='730'][. = $this_field][*:subfield/@code = ('a','d','f','g','k','m','n','o','p','r')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a','d','f','g','k','m','n','o','p','r')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:titleOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:dateOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'g'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="frbrizer:marc21rdftype(.)"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'k'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'm'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:mediumOfPerformance'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'o'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:otherDistinguishingCharacteristicOfTheWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'p'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:numberingOfPart'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                     <xsl:if test="@code = 'r'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:key'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='380'][frbrizer:linked($anchor_field, .)][*:subfield/@code = ('a')]">
               <xsl:copy>
                  <xsl:call-template name="copy-attributes"/>
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:copy>
                           <xsl:call-template name="copy-content">
                              <xsl:with-param name="type" select="'w:formOfWork'"/>
                              <xsl:with-param name="select" select="."/>
                           </xsl:call-template>
                        </xsl:copy>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:copy>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="*:record" name="create-record-entity-set">
      <xsl:variable name="record-step1">
         <frbrizer:record-entity-set>
            <xsl:call-template name="MARC21-100-Person"/>
            <xsl:call-template name="MARC21-110-CorporateBody"/>
            <xsl:call-template name="MARC21-111-CorporateBody"/>
            <xsl:call-template name="MARC21-130-Work"/>
            <xsl:call-template name="MARC21-240-Work"/>
            <xsl:call-template name="MARC21-245-Work"/>
            <xsl:call-template name="MARC21-246-Work"/>
            <xsl:call-template name="MARC21-600-Person"/>
            <xsl:call-template name="MARC21-600-Work"/>
            <xsl:call-template name="MARC21-610-CorporateBody"/>
            <xsl:call-template name="MARC21-610-Work"/>
            <xsl:call-template name="MARC21-611-CorporateBody"/>
            <xsl:call-template name="MARC21-611-Work"/>
            <xsl:call-template name="MARC21-630-Work"/>
            <xsl:call-template name="MARC21-700-Person"/>
            <xsl:call-template name="MARC21-700-Work"/>
            <xsl:call-template name="MARC21-710-CorporateBody"/>
            <xsl:call-template name="MARC21-710-Work"/>
            <xsl:call-template name="MARC21-711-CorporateBody"/>
            <xsl:call-template name="MARC21-711-Work"/>
            <xsl:call-template name="MARC21-730-Work"/>
         </frbrizer:record-entity-set>
      </xsl:variable>
      <xsl:variable name="record-step2">
         <xsl:apply-templates select="$record-step1" mode="create-inverse-relationships"/>
      </xsl:variable>
      <xsl:variable name="record-step3">
         <xsl:apply-templates select="$record-step2" mode="create-keys"/>
      </xsl:variable>
      <xsl:variable name="record-step4">
         <xsl:apply-templates select="$record-step3" mode="remove-record-entity-set-parent-element"/>
      </xsl:variable>
      <xsl:copy-of select="$record-step4"/>
   </xsl:template>
   <xsl:template match="frbrizer:record-entity-set" mode="create-key-mapping-step-1">
      <frbrizer:keymap>
         <xsl:for-each select="*:record">
            <xsl:choose>
               <xsl:when test="@templatename = 'MARC21-100-Person'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:nameOfPerson'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:titleOfPerson'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:dateAssociatedWithPerson'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-110-CorporateBody'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:nameOfCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'u:hierarchicalSubordinate'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:placeAssociatedWithCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:dateAssociatedWithCorporateBody'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-111-CorporateBody'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:nameOfCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'u:hierarchicalSubordinate'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:placeAssociatedWithCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:dateAssociatedWithCorporateBody'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-600-Person'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:nameOfPerson'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:titleOfPerson'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:dateAssociatedWithPerson'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-610-CorporateBody'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:nameOfCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'u:hierarchicalSubordinate'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:placeAssociatedWithCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:dateAssociatedWithCorporateBody'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-611-CorporateBody'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:nameOfCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'u:hierarchicalSubordinate'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:placeAssociatedWithCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:dateAssociatedWithCorporateBody'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-700-Person'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:nameOfPerson'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:titleOfPerson'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type= 'a:dateAssociatedWithPerson'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-710-CorporateBody'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:nameOfCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'u:hierarchicalSubordinate'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:placeAssociatedWithCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:dateAssociatedWithCorporateBody'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-711-CorporateBody'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:nameOfCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'u:hierarchicalSubordinate'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:placeAssociatedWithCorporateBody'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'a:dateAssociatedWithCorporateBody'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </frbrizer:keymap>
   </xsl:template>
   <xsl:template match="frbrizer:record-entity-set" mode="create-key-mapping-step-2">
      <frbrizer:keymap>
         <xsl:for-each select="*:record">
            <xsl:choose>
               <xsl:when test="@templatename = 'MARC21-245-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-246-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </frbrizer:keymap>
   </xsl:template>
   <xsl:template match="frbrizer:record-entity-set" mode="create-key-mapping-step-3">
      <frbrizer:keymap>
         <xsl:for-each select="*:record">
            <xsl:choose>
               <xsl:when test="@templatename = 'MARC21-600-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-610-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-611-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-700-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-710-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-711-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </frbrizer:keymap>
   </xsl:template>
   <xsl:template match="frbrizer:record-entity-set" mode="create-key-mapping-step-4">
      <frbrizer:keymap>
         <xsl:for-each select="*:record">
            <xsl:choose>
               <xsl:when test="@templatename = 'MARC21-130-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-240-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-630-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
               <xsl:when test="@templatename = 'MARC21-730-Work'">
                  <xsl:element name="frbrizer:keyentry">
                     <xsl:variable name="keystring" as="xs:string*">
                        <xsl:sequence>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:titleOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:dateOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:formOfWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:numberingOfPart'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:mediumOfPerformance'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:key'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(*:datafield/*:subfield[@*:type = 'w:otherDistinguishingCharacteristicOfTheWork'])"/>
                           <xsl:value-of select="frbrizer:sort-keys(string-join(frbrizer:sort-relationships(*:relationship[frbrizer:isWorkToActorType(@type)])/@href, ''))"/>
                        </xsl:sequence>
                     </xsl:variable>
                     <xsl:attribute name="key"
                                    select="concat('{', frbrizer:typefilter(@type), '=', string-join(frbrizer:keyfilter($keystring), ';'), '}')"/>
                     <xsl:attribute name="id" select="@id"/>
                  </xsl:element>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
      </frbrizer:keymap>
   </xsl:template>
   <xsl:template match="*:record-entity-set" mode="create-keys">
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
      <xsl:variable name="keys-phase-4">
         <xsl:apply-templates select="$set-phase-3" mode="create-key-mapping-step-4"/>
      </xsl:variable>
      <xsl:variable name="set-phase-4">
         <xsl:apply-templates select="$set-phase-3" mode="replace-keys">
            <xsl:with-param name="keymapping" select="$keys-phase-4"/>
         </xsl:apply-templates>
      </xsl:variable>
      <xsl:copy-of select="$set-phase-4"/>
   </xsl:template>
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
   <xsl:template match="*:record-entity-set" mode="replace-keys" name="replace-keys"><!-- Template for replacing internal keys with descriptive keys in the runtime generated keymap-->
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
   <xsl:template match="*:record-entity-set"
                 mode="remove-record-entity-set-parent-element">
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
   <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/"
                 name="local:keyfilter"
                 as="xs:string*">
        <xsl:param name="key" as="xs:string*"/>
        <xsl:for-each select="$key">
            <xsl:if test=". != ''"><!-- removing empty strings -->
                <xsl:value-of select="replace(replace(replace(lower-case(string-join(., ';')), '[^\p{L}\p{N}{};:]+', ':'), ':::', ':'), ':;:', ':')"/>
            </xsl:if>
        </xsl:for-each>       
    </xsl:function>
   <xsl:function xmlns:local="http://idi.ntnu.no/frbrizer/"
                 name="local:typefilter"
                 as="xs:string">
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
   <xsl:template match="/*:collection" mode="merge">
            <xsl:copy>
                <xsl:for-each select="@*"><!--Copying the attributes of the collection element -->
                    <xsl:copy/>
                </xsl:for-each>
                <xsl:for-each-group select="//*:record" group-by="@id, @type" composite="yes"> <!-- control field deduplication -->
                    <xsl:sort select="@type"/>
                    <xsl:sort select="@id"/>
                    <xsl:element name="{local-name(current-group()[1])}"
                         namespace="{namespace-uri(current-group()[1])}">
                        <xsl:attribute name="id" select="current-group()[1]/@id"/>
                        <xsl:attribute name="type" select="current-group()[1]/@type"/>  
                        <xsl:for-each-group select="current-group()/*:controlfield"
                                   group-by="@tag, @ind1, @ind2, @type, string(.)"
                                   composite="true">
                            <xsl:sort select="@tag"/>
                            <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                                <xsl:copy-of select="@*"/>
                                <xsl:value-of select="current-group()[1]"/>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each-group select="current-group()/*:datafield"
                                   group-by="@tag, @ind1, @ind2, @type, *:subfield/@code, *:subfield/@type, *:subfield/string"
                                   composite="true">
                            <xsl:sort select="@tag"/>
                            <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                                <xsl:copy-of select="current-group()[1]/@tag"/>
                                <xsl:copy-of select="current-group()[1]/@ind1"/>
                                <xsl:copy-of select="current-group()[1]/@ind2"/>
                                <xsl:copy-of select="current-group()[1]/@type"/>
                                <xsl:for-each-group select="current-group()/*:subfield"
                                         group-by="@code, @type, normalize-space(.)"
                                         composite="yes">
                                    <xsl:sort select="@code"/>
                                    <xsl:sort select="@type"/>
                                    <xsl:element name="{name(current-group()[1])}"
                                     namespace="{namespace-uri(current-group()[1])}">
                                        <xsl:copy-of select="current-group()[1]/@code"/>
                                        <xsl:copy-of select="current-group()[1]/@type"/>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </xsl:element>
                                </xsl:for-each-group>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each-group select="current-group()/*:relationship"
                                   group-by="@type, @href"
                                   composite="yes">
                            <xsl:sort select="@type"/>
                            <xsl:sort select="@href"/>
                            <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                                <xsl:copy-of select="@* except @itype"/>
                            </xsl:element>
                        </xsl:for-each-group>
                        <xsl:for-each-group select="current-group()/*:confidence"
                                   group-by="@rule, @src"
                                   composite="yes">
                            <xsl:element name="{name(current-group()[1])}"
                               namespace="{namespace-uri(current-group()[1])}">
                                <xsl:attribute name="rule" select="current-group()[1]/@rule"/>
                                <xsl:attribute name="src" select="current-group()[1]/@src"/>
                                <xsl:attribute name="cnt" select="sum(current-group()/@cnt)"/>
                            </xsl:element>
                        </xsl:for-each-group>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:copy>
    </xsl:template>
   <xsl:template xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:a="http://rdaregistry.info/Elements/a/"
                 xmlns:c="http://rdaregistry.info/Elements/c/"
                 xmlns:e="http://rdaregistry.info/Elements/e/"
                 xmlns:u="http://rdaregistry.info/Elements/u/"
                 xmlns:w="http://rdaregistry.info/Elements/w/"
                 xmlns:m="http://rdaregistry.info/Elements/m/"
                 xmlns:frsad="http://iflastandards.info/ns/fr/frsad/"
                 xmlns:frbrer="http://iflastandards.info/ns/fr/frbr/frbrer/"
                 xmlns:marcrdf="http://marc21rdf.info/elements/"
                 match="/*:collection"
                 mode="rdf">
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
                <rdf:Description>
                    <xsl:variable name="type" select="current-group()[1]/@type"/>
                    
                    <xsl:attribute name="rdf:about"
                              select="replace(current-group()[1]/@id, '[^\p{L}\p{N}]', '')"/>
                    
                    <!-- If using a licenced version of Saxon (pe, ee), it is possible to use functions in Java to create UUID based on a string -->
                    <!-- <xsl:attribute name="rdf:about" select="uuid:to-string(uuid:nameUUIDFromBytes(string:getBytes(current-group()[1]/@id/string())))" 
                        xmlns:uuid="java:java.util.UUID" xmlns:string="java:java.lang.String"/> -->
                    
                    <xsl:attribute name="rdf:type"
                              select="concat('http://rdaregistry.info/Elements/c/', substring-after(current-group()[1]/@type, ':'))"/>
                    <xsl:for-each-group select="current-group()//*:subfield"
                                   group-by="@type, text()"
                                   composite="yes">
                        <xsl:if test="tokenize(@type, ':')[1] = ('c', 'u', 'a', 'w', 'e', 'm')">
                            <xsl:element name="{@type}">
                                <xsl:copy-of select="current-group()[1]/text()"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each-group>
                    <xsl:for-each-group select="current-group()/*:relationship"
                                   group-by="@type, @href"
                                   composite="yes">
                        <xsl:sort select="@type"/>
                        <xsl:if test="tokenize(@type, ':')[1] = ('c', 'u', 'a', 'w', 'e', 'm')">
                            <xsl:element name="{@type}">
                                <xsl:attribute name="rdf:resource"
                                       select="replace(current-group()[1]/@href, '[^\p{L}\p{N}]', '')"/>
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
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:marc21rdftype"
                 as="xs:string">
            <xsl:param name="node" as="element()"/>
            <xsl:variable name="prefix" select="'marcrdf'"/>
            <xsl:variable name="tag" select="$node/ancestor-or-self::node()[@tag]/@tag"/>
            <xsl:variable name="code" select="$node/ancestor-or-self::node()[@code]/@code"/>
            <xsl:variable name="ind1"
                    select="if (matches($node/ancestor-or-self::node()[@tag]/@ind1, '[a-zA-Z0-9]')) then $node/ancestor-or-self::node()[@tag]/@ind1 else '_'"/>
            <xsl:variable name="ind2"
                    select="if (matches($node/ancestor-or-self::node()[@tag]/@ind2, '[a-zA-Z0-9]')) then $node/ancestor-or-self::node()[@tag]/@ind2 else '_'"/>
            <xsl:value-of select="if (local-name($node) eq 'controlfield') then concat($prefix, ':M', $tag) else concat($prefix, ':M', $tag, $ind1, $ind2, $code)"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:linked"
                 as="xs:boolean"><!-- returns true if the two fields have the same marc 21 link ($8), or if there is no linking subfields in the target (second parameter) -->
            <xsl:param name="anchor" as="element()"/>
            <xsl:param name="target" as="element()"/>
      <!-- <xsl:value-of select="(some $x in $anchor/subfield[@code='8'] satisfies $x = $target/subfield[@code='8']) or (not(exists($anchor/subfield[@code='8'])) and not(exists($target/subfield[@code='8'])))"/>  -->
            <xsl:value-of select="(some $x in $anchor/*:subfield[@code = '8'] satisfies $x = $target/*:subfield[@code = '8']) or (not(exists($target/*:subfield[@code = '8'])))"/>
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
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:relatorcode2rdatype">
            <xsl:param name="relatorcodes" as="xs:string*"/>
            <xsl:param name="inverse" as="xs:boolean"/>
      <!-- true will return inverse property -->
            <xsl:variable name="relatorcode" select="$relatorcodes[1]"/>
            <xsl:choose><!-- default if empty value for relatorcode-->
                <xsl:when test="empty($relatorcode) and $inverse eq false()">
                    <xsl:value-of select="'a:authorOf'"/>
                </xsl:when>
                <xsl:when test="empty($relatorcode) and $inverse eq true()">
                    <xsl:value-of select="'w:author'"/>
                </xsl:when>
         <!-- Work related relatorcodes aut, drt, act, edt, clb -->
                <xsl:when test="$relatorcode eq 'aut' and $inverse eq false()">
                    <xsl:value-of select="'a:authorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'aut' and $inverse eq true()">
                    <xsl:value-of select="'w:author'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'cmp' and $inverse eq false()">
                    <xsl:value-of select="'a:composerOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'cmp' and $inverse eq true()">
                    <xsl:value-of select="'w:composer'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'drt' and $inverse eq false()">
                    <xsl:value-of select="'a:directorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'drt' and $inverse eq true()">
                    <xsl:value-of select="'w:director'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'act' and $inverse eq false()">
                    <xsl:value-of select="'u:actorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'act' and $inverse eq true()">
                    <xsl:value-of select="'u:actor'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'edt' and $inverse eq false()">
                    <xsl:value-of select="'a:compilerOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'edt' and $inverse eq true()">
                    <xsl:value-of select="'w:compiler'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ctb' and $inverse eq false()">
                    <xsl:value-of select="'a:contributorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ctb' and $inverse eq true()">
                    <xsl:value-of select="'w:contributor'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'aui' and $inverse eq false()">
                    <xsl:value-of select="'a:authorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'aui' and $inverse eq true()">
                    <xsl:value-of select="'w:author'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ill' and $inverse eq false()">
                    <xsl:value-of select="'a:artistOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ill' and $inverse eq true()">
                    <xsl:value-of select="'w:artist'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'clr' and $inverse eq false()">
                    <xsl:value-of select="'a:artistOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'clr' and $inverse eq true()">
                    <xsl:value-of select="'w:artist'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'cmt' and $inverse eq false()">
                    <xsl:value-of select="'a:authorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'cmt' and $inverse eq true()">
                    <xsl:value-of select="'w:author'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ive' and $inverse eq false()">
                    <xsl:value-of select="'a:intervieweeOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ive' and $inverse eq true()">
                    <xsl:value-of select="'w:interviewee'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ivr' and $inverse eq false()">
                    <xsl:value-of select="'a:interviewerOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ivr' and $inverse eq true()">
                    <xsl:value-of select="'w:interviewer'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'aus' and $inverse eq false()">
                    <xsl:value-of select="'a:screenwriterOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'aus' and $inverse eq true()">
                    <xsl:value-of select="'w:screenwriter'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'lyr' and $inverse eq false()">
                    <xsl:value-of select="'a:lyricistOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'lyr' and $inverse eq true()">
                    <xsl:value-of select="'w:lyricist'"/>
                </xsl:when>
         <!-- Expression related relatorcode -->
                <xsl:when test="$relatorcode eq 'abr' and $inverse eq false()">
                    <xsl:value-of select="'a:abridgerOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'abr' and $inverse eq true()">
                    <xsl:value-of select="'e:abridger'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'cnd' and $inverse eq false()">
                    <xsl:value-of select="'a:conductorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'cnd' and $inverse eq true()">
                    <xsl:value-of select="'e:conductor'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'nrt' and $inverse eq false()">
                    <xsl:value-of select="'a:narratorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'nrt' and $inverse eq true()">
                    <xsl:value-of select="'e:narrator'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'trl' and $inverse eq false()">
                    <xsl:value-of select="'a:translatorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'trl' and $inverse eq true()">
                    <xsl:value-of select="'e:translator'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'adp' and $inverse eq false()">
                    <xsl:value-of select="'a:adapterOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'adp' and $inverse eq true()">
                    <xsl:value-of select="'e:adaptor'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'prf' and $inverse eq false()">
                    <xsl:value-of select="'a:performerOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'prf' and $inverse eq true()">
                    <xsl:value-of select="'e:performer'"/>
                </xsl:when>
         <!-- Manifestation -->
                <xsl:when test="$relatorcode eq 'pbd' and $inverse eq false()">
                    <xsl:value-of select="'u:editorOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'pbd' and $inverse eq true()">
                    <xsl:value-of select="'u:editor'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'pbl' and $inverse eq false()">
                    <xsl:value-of select="'a:publisherOf'"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'pbl' and $inverse eq true()">
                    <xsl:value-of select="'m:publisher'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'UNTYPED'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:isRelatorCodeToWork"
                 as="xs:boolean">
            <xsl:param name="relatorcode" as="xs:string*"/>
            <xsl:value-of select="$relatorcode = ('aut', 'cmp', 'drt', 'act', 'edt', 'ctb', 'aui', 'ill', 'clr', 'cmt', 'ive', 'ivr', 'aus', 'lyr') or empty($relatorcode)"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:isRelatorCodeToExpression"
                 as="xs:boolean">
            <xsl:param name="relatorcode" as="xs:string*"/>
            <xsl:value-of select="$relatorcode = ('abr', 'cnd', 'nrt', 'trl', 'adp', 'prf' )"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:isRelatorCodeToManifestation"
                 as="xs:boolean">
            <xsl:param name="relatorcode" as="xs:string*"/>
            <xsl:value-of select="$relatorcode = ('pbd', 'pbl')"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:isWorkToActorType"
                 as="xs:boolean">
            <xsl:param name="type"/>
            <xsl:value-of select="$type = ( 'w:creator', 'w:author', 'w:composer', 'w:director', 'u:actor', 'w:compiler', 'w:contributor', 'w:artist', 'w:artist', 'w:interviewee', 'w:interviewer',  'w:screenwriter', 'w:lyricist')"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:isExpressionToActorType"
                 as="xs:boolean">
            <xsl:param name="type"/>
            <xsl:value-of select="$type = ('e:abridger', 'e:conductor', 'e:narrator', 'e:translator', 'e:adaptor', 'e:performer', 'e:contributor', 'e:narrator', 'e:actor')"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:isAugmentation"
                 as="xs:boolean">
            <xsl:param name="relatorcode" as="xs:string*"/>
            <xsl:value-of select="$relatorcode = ('aui', 'ill', 'cwt')"/>
        </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 name="frbrizer:augmentationTitle"
                 as="xs:string">
            <xsl:param name="relatorcode" as="xs:string*"/>
            <xsl:choose>
                <xsl:when test="$relatorcode eq 'aui'">
                    <xsl:value-of select="'[Introduction] '"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'ill'">
                    <xsl:value-of select="'[Illustrations] '"/>
                </xsl:when>
                <xsl:when test="$relatorcode eq 'cwt'">
                    <xsl:value-of select="'[Comments] '"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'[Unknown]'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:function>
</xsl:stylesheet>
