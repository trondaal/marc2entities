<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"
                 xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
                 xmlns:map="http://www.w3.org/2005/xpath-functions/map"
                 xmlns:mmmm="http://www.loc.gov/MARC21/slim/"
                 xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
                 xmlns:rdaao="http://rdaregistry.info/Elements/a/object/"
                 xmlns:rdac="http://rdaregistry.info/Elements/c/"
                 xmlns:rdaco="http://rdaregistry.info/termList/RDAContentType/"
                 xmlns:rdact="http://rdaregistry.info/termList/RDACarrierType/"
                 xmlns:rdaed="http://rdaregistry.info/Elements/e/datatype/"
                 xmlns:rdaeo="http://rdaregistry.info/Elements/e/object/"
                 xmlns:rdamd="http://rdaregistry.info/Elements/m/datatype/"
                 xmlns:rdamo="http://rdaregistry.info/Elements/m/object/"
                 xmlns:rdamt="http://rdaregistry.info/termList/RDAMediaType/"
                 xmlns:rdat="http://rdaregistry.info/termList/"
                 xmlns:rdawd="http://rdaregistry.info/Elements/w/datatype/"
                 xmlns:rdawo="http://rdaregistry.info/Elements/w/object/"
                 xmlns:rdaxd="http://rdaregistry.info/Elements/x/datatype/"
                 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                 xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                 xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                 xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 version="3.0">
   <xsl:param name="merge" as="xs:boolean" select="true()"/>
   <xsl:param name="rdf" as="xs:boolean" select="false()"/>
   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   <xsl:variable name="prefixmap" as="map(xs:string, xs:string)">
      <xsl:map>
         <xsl:map-entry key="'http://www.loc.gov/mads/rdf/v1#'" select="'mads'"/>
         <xsl:map-entry key="'http://www.loc.gov/MARC21/slim/'" select="'mmmm'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/a/datatype/'" select="'rdaad'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/a/object/'" select="'rdaao'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/c/'" select="'rdac'"/>
         <xsl:map-entry key="'http://rdaregistry.info/termList/RDAContentType/'"
                         select="'rdaco'"/>
         <xsl:map-entry key="'http://rdaregistry.info/termList/RDACarrierType/'"
                         select="'rdact'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/e/datatype/'" select="'rdaed'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/e/object/'" select="'rdaeo'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/m/datatype/'" select="'rdamd'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/m/object/'" select="'rdamo'"/>
         <xsl:map-entry key="'http://rdaregistry.info/termList/RDAMediaType/'" select="'rdamt'"/>
         <xsl:map-entry key="'http://rdaregistry.info/termList/'" select="'rdat'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/w/datatype/'" select="'rdawd'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/w/object/'" select="'rdawo'"/>
         <xsl:map-entry key="'http://rdaregistry.info/Elements/x/datatype/'" select="'rdaxd'"/>
         <xsl:map-entry key="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'" select="'rdf'"/>
         <xsl:map-entry key="'http://www.w3.org/2000/01/rdf-schema#'" select="'rdfs'"/>
         <xsl:map-entry key="'http://www.w3.org/2004/02/skos/core#'" select="'skos'"/>
         <xsl:map-entry key="'http://www.w3.org/XML/1998/namespace'" select="'xml'"/>
      </xsl:map>
   </xsl:variable>
   <xsl:template match="/*:collection">
      <xsl:message select="map:keys($prefixmap)"/>
      <xsl:variable name="entity-collection">
         <rdf:RDF xml:base="http://example.org/marc2entities/">
            <xsl:namespace name="mads" select="'http://www.loc.gov/mads/rdf/v1#'"/>
            <xsl:namespace name="mmmm" select="'http://www.loc.gov/MARC21/slim/'"/>
            <xsl:namespace name="rdaad" select="'http://rdaregistry.info/Elements/a/datatype/'"/>
            <xsl:namespace name="rdaao" select="'http://rdaregistry.info/Elements/a/object/'"/>
            <xsl:namespace name="rdac" select="'http://rdaregistry.info/Elements/c/'"/>
            <xsl:namespace name="rdaco"
                            select="'http://rdaregistry.info/termList/RDAContentType/'"/>
            <xsl:namespace name="rdact"
                            select="'http://rdaregistry.info/termList/RDACarrierType/'"/>
            <xsl:namespace name="rdaed" select="'http://rdaregistry.info/Elements/e/datatype/'"/>
            <xsl:namespace name="rdaeo" select="'http://rdaregistry.info/Elements/e/object/'"/>
            <xsl:namespace name="rdamd" select="'http://rdaregistry.info/Elements/m/datatype/'"/>
            <xsl:namespace name="rdamo" select="'http://rdaregistry.info/Elements/m/object/'"/>
            <xsl:namespace name="rdamt" select="'http://rdaregistry.info/termList/RDAMediaType/'"/>
            <xsl:namespace name="rdat" select="'http://rdaregistry.info/termList/'"/>
            <xsl:namespace name="rdawd" select="'http://rdaregistry.info/Elements/w/datatype/'"/>
            <xsl:namespace name="rdawo" select="'http://rdaregistry.info/Elements/w/object/'"/>
            <xsl:namespace name="rdaxd" select="'http://rdaregistry.info/Elements/x/datatype/'"/>
            <xsl:namespace name="rdf" select="'http://www.w3.org/1999/02/22-rdf-syntax-ns#'"/>
            <xsl:namespace name="rdfs" select="'http://www.w3.org/2000/01/rdf-schema#'"/>
            <xsl:namespace name="skos" select="'http://www.w3.org/2004/02/skos/core#'"/>
            <xsl:namespace name="xml" select="'http://www.w3.org/XML/1998/namespace'"/>
            <xsl:for-each select="*:record">
               <xsl:call-template name="create-record-set"/>
            </xsl:for-each>
         </rdf:RDF>
      </xsl:variable>
      <xsl:variable name="with-constructed-identifiers">
         <xsl:apply-templates select="$entity-collection" mode="create-identifier"/>
      </xsl:variable>
      <xsl:variable name="merged">
         <xsl:apply-templates select="$with-constructed-identifiers" mode="merge"/>
      </xsl:variable>
      <xsl:copy-of select="$merged"/>
   </xsl:template>
   <xsl:template match="*:record" name="create-record-set">
      <rdf:Description>
         <xsl:attribute name="rdf:about" select="*:controlfield[@tag='001']"/>
         <frbrizer:recordset rdf:parseType="Collection">
            <xsl:call-template name="MARC380"/>
            <xsl:call-template name="MARC336"/>
            <xsl:call-template name="MARC337"/>
            <xsl:call-template name="MARC338"/>
            <xsl:call-template name="MARC041"/>
            <xsl:call-template name="MARC041additional"/>
            <xsl:call-template name="MARC008language"/>
            <xsl:call-template name="MARC21-100700Person"/>
            <xsl:call-template name="MARC21-130240-Work"/>
            <xsl:call-template name="MARC21-130240-Expression"/>
            <xsl:call-template name="MARC21-245-Manifestation"/>
            <xsl:call-template name="MARC21-600-Person"/>
            <xsl:call-template name="MARC21-6XX-Work"/>
            <xsl:call-template name="MARC21-700-Related-Work"/>
            <xsl:call-template name="MARC21-700-Work-Analytical"/>
            <xsl:call-template name="MARC21-700-Expression-Analytical"/>
            <xsl:call-template name="MARC21-758-Related-Work"/>
            <xsl:call-template name="MARC21-8XX-Work-Series"/>
         </frbrizer:recordset>
      </rdf:Description>
   </xsl:template>
   <xsl:template name="MARC008language">
      <xsl:variable name="this_template_name" select="'MARC008language'"/>
      <xsl:variable name="tag" as="xs:string" select="'008'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('008')][string-length(.) eq 40 and matches(substring(., 36, 3), '[a-z][a-z][a-z]')]">
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
         <xsl:element name="{frbrizer:create-class-name('http://www.w3.org/2004/02/skos/core#Concept')}">
            <xsl:attribute name="rdf:about"
                            select="concat('http://id.loc.gov/vocabulary/iso639-2/', substring(., 36, 3))"/>
            <xsl:element name="frbrizer:template">
               <xsl:value-of select="$this_template_name"/>
            </xsl:element>
            <xsl:for-each select="$record/*:controlfield[@tag='008'][$this_field_position]">
               <xsl:call-template name="create-property-from-subfield">
                  <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                  <xsl:with-param name="value" select="substring(., 36, 3)"/>
               </xsl:call-template>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC041">
      <xsl:variable name="this_template_name" select="'MARC041'"/>
      <xsl:variable name="tag" as="xs:string" select="'041'"/>
      <xsl:variable name="code" as="xs:string" select="'a, d'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('041')]">
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
         <xsl:for-each select="node()[@code=('a','d')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://www.w3.org/2004/02/skos/core#Concept')}">
               <xsl:attribute name="rdf:about"
                               select="concat('http://id.loc.gov/vocabulary/iso639-2/', .)"/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='041'][generate-id(.) = generate-id($anchor_field)][*:subfield/@code = ('a','d')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d')]">
                     <xsl:if test="@code = 'a' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC041additional">
      <xsl:variable name="this_template_name" select="'MARC041additional'"/>
      <xsl:variable name="tag" as="xs:string" select="'041'"/>
      <xsl:variable name="code"
                     as="xs:string"
                     select="'b, e, f, g, i, j, k, l, m, n, p, q, r, t'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('041')]">
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
         <xsl:for-each select="node()[@code=('b','e','f','g','i','j','k','l','m','n','p','q','r','t')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://www.w3.org/2004/02/skos/core#Concept')}">
               <xsl:attribute name="rdf:about"
                               select="concat('http://id.loc.gov/vocabulary/iso639-2/', .)"/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='041'][generate-id(.) = generate-id($anchor_field)][*:subfield/@code = ('b','e','f','g','i','j','k','l','m','n','p','q','r','t')]">
                  <xsl:for-each select="*:subfield[@code = ('b','e','f','g','i','j','k','l','m','n','p','q','r','t')]">
                     <xsl:if test="@code = 'b' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'e' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'g' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'i' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'j' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'k' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'l' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'm' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'p' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'q' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'r' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't' and generate-id(.) = generate-id($anchor_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-100700Person">
      <xsl:variable name="this_template_name" select="'MARC21-100700Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'100, 110, 111, 700, 710, 711'"/>
      <xsl:variable name="code" as="xs:string" select="'4'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('100','110','111','700','710','711')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
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
         <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10002')}">
               <xsl:attribute name="rdf:about"
                               select="frbrizer:trim(../*:subfield[@code='1'][starts-with(., 'http')][1])"/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='100'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='110'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='111'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='700'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='710'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='711'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-130240-Expression">
      <xsl:variable name="this_template_name" select="'MARC21-130240-Expression'"/>
      <xsl:variable name="tag" as="xs:string" select="'130, 240'"/>
      <xsl:variable name="code" as="xs:string" select="'1'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('130','240')][count($record/*:datafield[@tag='700' and @ind2 = '2' and *:subfield/@code = 't']) = 0]">
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
         <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10006')}">
               <xsl:attribute name="rdf:about"
                               select="frbrizer:trim(../*:subfield[@code='1'][starts-with(., 'http')][1]) || &#34;/&#34; || generate-id(.)"/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='130'][*:subfield/@code = ('a')]">
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/e/datatype/P20316'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='240'][*:subfield/@code = ('a')]">
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/e/datatype/P20316'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='740'][frbrizer:linked($anchor_field, ., true())][*:subfield/@code = ('a')]">
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/e/datatype/P20315'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='245'][*:subfield/@code = ('a')]">
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/e/datatype/P20312'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code='b'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), $record/*:datafield[@tag='041']/*:subfield[@code=('a', 'd')][1], $record/*:datafield[@tag='336']/*:subfield[@code='a'][1]), ' / ')"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('245')]">
                  <xsl:variable name="target_template_name" select="'MARC21-245-Manifestation'"/>
                  <xsl:variable name="target_tag_value" select="'245'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:call-template name="create-property-from-subfield">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/object/P20059'"/>
                     <xsl:with-param name="resource"
                                      select="'http://example.org/' || (if (($record/*:datafield[@tag=('020','022','024')][1]/*:subfield[@code='a'])[1]) then ($record/*:datafield[@tag=('020','022','024')][1]/*:subfield[@code='a'])[1]/replace(., '\D', '') else if ($record/*:controlfield[@tag=('001')]) then $record/*:controlfield[@tag=('001')][1]/replace(., '\D', '') else replace($record/*:datafield[@tag='245']/*:subfield[@code='a'],  '[^a-zA-Z0-9 -]', '' ) || '-' || generate-id(.))"/>
                  </xsl:call-template>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('130','240')][*:subfield/@code = '1']">
                  <xsl:variable name="target_template_name" select="'MARC21-130240-Work'"/>
                  <xsl:variable name="target_tag_value" select="'130, 240'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="($target_field = $this_field)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/object/P20231'"/>
                           <xsl:with-param name="resource" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('100','110','111','700','710','711')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
                  <xsl:variable name="target_template_name" select="'MARC21-100700Person'"/>
                  <xsl:variable name="target_tag_value" select="'100, 110, 111, 700, 710, 711'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/e/') and frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="$target_subfield"/>
                           <xsl:with-param name="resource"
                                            select="frbrizer:trim(../*:subfield[@code='1'][starts-with(., 'http')][1])"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('008')][string-length(.) eq 40 and matches(substring(., 36, 3), '[a-z][a-z][a-z]')]">
                  <xsl:variable name="target_template_name" select="'MARC008language'"/>
                  <xsl:variable name="target_tag_value" select="'008'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                        <xsl:with-param name="resource"
                                         select="concat('http://id.loc.gov/vocabulary/iso639-2/', substring(., 36, 3))"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('041')]">
                  <xsl:variable name="target_template_name" select="'MARC041'"/>
                  <xsl:variable name="target_tag_value" select="'041'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('a','d')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                           <xsl:with-param name="resource"
                                            select="concat('http://id.loc.gov/vocabulary/iso639-2/', .)"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('041')]">
                  <xsl:variable name="target_template_name" select="'MARC041additional'"/>
                  <xsl:variable name="target_tag_value" select="'041'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('b','e','f','g','i','j','k','l','m','n','p','q','r','t')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/e/datatype/P20065'"/>
                           <xsl:with-param name="resource"
                                            select="concat('http://id.loc.gov/vocabulary/iso639-2/', .)"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('336')]">
                  <xsl:variable name="target_template_name" select="'MARC336'"/>
                  <xsl:variable name="target_tag_value" select="'336'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/e/datatype/P20001'"/>
                           <xsl:with-param name="resource" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-130240-Work">
      <xsl:variable name="this_template_name" select="'MARC21-130240-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'130, 240'"/>
      <xsl:variable name="code" as="xs:string" select="'1'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('130','240')][*:subfield/@code = '1']">
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
         <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10001')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='130'][. eq $this_field][*:subfield/@code = ('a','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='240'][. eq $this_field][*:subfield/@code = ('a','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value"
                                            select="frbrizer:trim(.) || ' (' || $record/*:datafield[@tag='100']/*:subfield[@code='a']/replace(., '[\s,/:=]+$', '') || ')'"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='520'][*:subfield/@code = ('a')]">
                  <xsl:for-each select="*:subfield[@code = ('a')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10330'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('100','110','111','700','710','711')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
                  <xsl:variable name="target_template_name" select="'MARC21-100700Person'"/>
                  <xsl:variable name="target_tag_value" select="'100, 110, 111, 700, 710, 711'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/')  and frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="$target_subfield"/>
                           <xsl:with-param name="resource"
                                            select="frbrizer:trim(../*:subfield[@code='1'][starts-with(., 'http')][1])"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('600','610','611')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
                  <xsl:variable name="target_template_name" select="'MARC21-600-Person'"/>
                  <xsl:variable name="target_tag_value" select="'600, 610, 611'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('1')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(not($target_field/*:subfield/@code = 't') and frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/object/P10319'"/>
                           <xsl:with-param name="resource" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('600','610','611','630')][*:subfield/@code = '1' and  (if (@tag eq '630') then true() else *:subfield/@code = 't')]">
                  <xsl:variable name="target_template_name" select="'MARC21-6XX-Work'"/>
                  <xsl:variable name="target_tag_value" select="'600, 610, 611, 630'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(not($this_field/*:subfield/@code = '1') or not($this_field/*:subfield[@code = '1'] = $target_field/*:subfield[@code = '1'])  and frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/object/P10257'"/>
                           <xsl:with-param name="resource" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('700','710','711','730')][exists(*:subfield[@code = '1' and starts-with(., 'http')]) and not(@ind2 = '2') and (if (@tag eq '730') then true() else *:subfield/@code = 't')]">
                  <xsl:variable name="target_template_name" select="'MARC21-700-Related-Work'"/>
                  <xsl:variable name="target_tag_value" select="'700, 710, 711, 730'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/') and frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="$target_subfield"/>
                           <xsl:with-param name="resource"
                                            select="frbrizer:trim(../*:subfield[@code='1'][starts-with(.,'http')][last()])"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('758')]">
                  <xsl:variable name="target_template_name" select="'MARC21-758-Related-Work'"/>
                  <xsl:variable name="target_tag_value" select="'758'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('4')][starts-with(., 'http') and exists($this_field/*:subfield[@code = '1']/starts-with(., 'http')) ]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/') and frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="$target_subfield"/>
                           <xsl:with-param name="resource"
                                            select="../*:subfield[@code='1' and starts-with(., 'http')][last()]"/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('800','810','811','830')]">
                  <xsl:variable name="target_template_name" select="'MARC21-8XX-Work-Series'"/>
                  <xsl:variable name="target_tag_value" select="'800, 810, 811, 830'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/object/P10019'"/>
                        <xsl:with-param name="resource" select="."/>
                     </xsl:call-template>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/node()[@tag=('380')]">
                  <xsl:variable name="target_template_name" select="'MARC380'"/>
                  <xsl:variable name="target_tag_value" select="'380'"/>
                  <xsl:variable name="target_field"
                                 select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
                  <xsl:variable name="target_field_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
                     <xsl:variable name="target_subfield" select="."/>
                     <xsl:variable name="target_subfield_code"
                                    as="xs:string"
                                    select="$target_subfield/@code"/>
                     <xsl:variable name="target_subfield_position"
                                    as="xs:string"
                                    select="string(position())"/>
                     <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10004'"/>
                           <xsl:with-param name="resource" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-245-Manifestation">
      <xsl:variable name="this_template_name" select="'MARC21-245-Manifestation'"/>
      <xsl:variable name="tag" as="xs:string" select="'245'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('245')]">
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
         <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10007')}">
            <xsl:attribute name="rdf:about"
                            select="'http://example.org/' || (if (($record/*:datafield[@tag=('020','022','024')][1]/*:subfield[@code='a'])[1]) then ($record/*:datafield[@tag=('020','022','024')][1]/*:subfield[@code='a'])[1]/replace(., '\D', '') else if ($record/*:controlfield[@tag=('001')]) then $record/*:controlfield[@tag=('001')][1]/replace(., '\D', '') else replace($record/*:datafield[@tag='245']/*:subfield[@code='a'],  '[^a-zA-Z0-9 -]', '' ) || '-' || generate-id(.))"/>
            <xsl:element name="frbrizer:template">
               <xsl:value-of select="$this_template_name"/>
            </xsl:element>
            <xsl:for-each select="$record/*:controlfield[@tag='001']">
               <xsl:call-template name="create-property-from-subfield">
                  <xsl:with-param name="type" select="'marc'"/>
                  <xsl:with-param name="value" select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$record/*:controlfield[@tag='003']">
               <xsl:call-template name="create-property-from-subfield">
                  <xsl:with-param name="type" select="'marc'"/>
                  <xsl:with-param name="value" select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$record/*:controlfield[@tag='008']">
               <xsl:call-template name="create-property-from-subfield">
                  <xsl:with-param name="type" select="'marc'"/>
                  <xsl:with-param name="value" select="."/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='020'][*:subfield/@code = ('a')]">
               <xsl:for-each select="*:subfield[@code = ('a')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value" select="'ISBN ' || frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30004'"/>
                        <xsl:with-param name="value" select="'ISBN ' || ."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                        <xsl:with-param name="value"
                                         select="'ISBN-' || replace(., '\D', '') || (if (../*:subfield[@code='q' and matches(., '^[0-9]*$')]) then '-' || ../*:subfield[@code='q' and matches(., '^[0-9]*$')][1]  else '')"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='022'][*:subfield/@code = ('a')]">
               <xsl:for-each select="*:subfield[@code = ('a')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30004'"/>
                        <xsl:with-param name="value" select="'ISSN ' || ."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                        <xsl:with-param name="value" select="concat('issn-', ./replace(., '\D', ''))"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='024'][*:subfield/@code = ('a')]">
               <xsl:for-each select="*:subfield[@code = ('a')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30004'"/>
                        <xsl:with-param name="value" select="frbrizer:idprefix(../@ind1) || ' ' || ."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                        <xsl:with-param name="value"
                                         select="concat(frbrizer:idprefix(../@ind1) ,'-', replace(., '\D', ''))"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='245'][. = $this_field][*:subfield/@code = ('a','b','c','n','p')]">
               <xsl:for-each select="*:subfield[@code = ('a','b','c','n','p')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30156'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'b'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30142'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30117'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'n'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30014'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'p'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30134'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='250'][*:subfield/@code = ('a')]">
               <xsl:for-each select="*:subfield[@code = ('a')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30107'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='260'][*:subfield/@code = ('x','a','b','c','e','f','g')]">
               <xsl:for-each select="*:subfield[@code = ('x','a','b','c','e','f','g')]">
                  <xsl:if test="@code = 'x'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30111'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30111'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'b'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30111'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30111'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30088'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'b'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30083'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30011'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'e'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30087'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'f'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30175'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'g'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30010'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='264'][@ind2='0'][*:subfield/@code = ('a','b','c')]">
               <xsl:for-each select="*:subfield[@code = ('a','b','c')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30110'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30086'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'b'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30174'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30009'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='264'][@ind2='1'][*:subfield/@code = ('a','b','c')]">
               <xsl:for-each select="*:subfield[@code = ('a','b','c')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30111'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30088'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'b'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30083'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30011'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='264'][@ind2='2'][*:subfield/@code = ('a','b','c')]">
               <xsl:for-each select="*:subfield[@code = ('a','b','c')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30108'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30085'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'b'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30173'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30008'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='264'][@ind2='3'][*:subfield/@code = ('a','b','c')]">
               <xsl:for-each select="*:subfield[@code = ('a','b','c')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30109'"/>
                        <xsl:with-param name="value" select="frbrizer:publication(..)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30087'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'b'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30175'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30010'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='264'][@ind2='4'][*:subfield/@code = ('c')]">
               <xsl:for-each select="*:subfield[@code = ('c')]">
                  <xsl:if test="@code = 'c'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30007'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='300'][*:subfield/@code = ('a')]">
               <xsl:for-each select="*:subfield[@code = ('a')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30182'"/>
                        <xsl:with-param name="value" select="frbrizer:extent(..)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='337'][*:subfield/@code = ('0')]">
               <xsl:for-each select="*:subfield[@code = ('0')]">
                  <xsl:if test="@code = '0'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30002'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='338'][*:subfield/@code = ('0')]">
               <xsl:for-each select="*:subfield[@code = ('0')]">
                  <xsl:if test="@code = '0'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30001'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='490'][*:subfield/@code = ('a','v')]">
               <xsl:for-each select="*:subfield[@code = ('a','v')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30106'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'v'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30165'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='500'][*:subfield/@code = ('a')]">
               <xsl:for-each select="*:subfield[@code = ('a')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30137'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='505'][*:subfield/@code = ('a','g','r','t')]">
               <xsl:for-each select="*:subfield[@code = ('a','g','r','t')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30137'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'g'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30137'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'r'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30137'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30137'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='773'][*:subfield/@code = ('t')]">
               <xsl:for-each select="*:subfield[@code = ('t')]">
                  <xsl:if test="@code = 't' and . ne $record/*:datafield[@tag='245']/*:subfield[@code='a']">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30050'"/>
                        <xsl:with-param name="value"
                                         select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code='d']), frbrizer:trim(../*:subfield[@code='g'])), ', ') || '.'"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('100','110','111','700','710','711')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
               <xsl:variable name="target_template_name" select="'MARC21-100700Person'"/>
               <xsl:variable name="target_tag_value" select="'100, 110, 111, 700, 710, 711'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/m/') and frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="$target_subfield"/>
                        <xsl:with-param name="resource"
                                         select="frbrizer:trim(../*:subfield[@code='1'][starts-with(., 'http')][1])"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('337')]">
               <xsl:variable name="target_template_name" select="'MARC337'"/>
               <xsl:variable name="target_tag_value" select="'337'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30002'"/>
                        <xsl:with-param name="resource" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('338')]">
               <xsl:variable name="target_template_name" select="'MARC338'"/>
               <xsl:variable name="target_tag_value" select="'338'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/m/datatype/P30001'"/>
                        <xsl:with-param name="resource" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-600-Person">
      <xsl:variable name="this_template_name" select="'MARC21-600-Person'"/>
      <xsl:variable name="tag" as="xs:string" select="'600, 610, 611'"/>
      <xsl:variable name="code" as="xs:string" select="'1'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('600','610','611')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
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
         <xsl:for-each select="node()[@code=('1')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10002')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='600'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='610'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='611'][. eq $this_field][*:subfield/@code = ('a','d','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','d','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50385'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'd'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/a/datatype/P50339'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-6XX-Work">
      <xsl:variable name="this_template_name" select="'MARC21-6XX-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'600, 610, 611, 630'"/>
      <xsl:variable name="code" as="xs:string" select="'1'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('600','610','611','630')][*:subfield/@code = '1' and  (if (@tag eq '630') then true() else *:subfield/@code = 't')]">
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
         <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10001')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='600'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value"
                                            select="frbrizer:trim(.) || ' (' || ../*:subfield[@code='a']/replace(., '[\s,/:=]+$', '') || ')'"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='610'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='611'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='630'][. eq $this_field][*:subfield/@code = ('a','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Expression-Analytical">
      <xsl:variable name="this_template_name" select="'MARC21-700-Expression-Analytical'"/>
      <xsl:variable name="tag" as="xs:string" select="'700, 710, 711, 730'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('700','710','711','730')][exists(*:subfield[@code = '1']/starts-with(., 'http'))  and  @ind2='2' and (if (@tag eq '730') then true() else *:subfield/@code = 't')]">
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
         <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10006')}">
            <xsl:attribute name="rdf:about"
                            select="./*:subfield[@code='1' and starts-with(., 'http')][last()] || &#34;/&#34; || generate-id(.)"/>
            <xsl:element name="frbrizer:template">
               <xsl:value-of select="$this_template_name"/>
            </xsl:element>
            <xsl:for-each select="$record/*:datafield[@tag='700'][. eq $this_field][*:subfield/@code = ('t','l')]">
               <xsl:for-each select="*:subfield[@code = ('t','l')]">
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value"
                                         select="string-join((frbrizer:trim(.), $record/*:datafield[@tag='041']/*:subfield[@code=('a', 'd')][1], $record/*:datafield[@tag='336']/*:subfield[@code='a'][1]), ' / ')"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'l'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                        <xsl:with-param name="value" select="lower-case(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20312'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='710'][. eq $this_field][*:subfield/@code = ('t','l')]">
               <xsl:for-each select="*:subfield[@code = ('t','l')]">
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'l'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                        <xsl:with-param name="value" select="lower-case(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20312'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='711'][. eq $this_field][*:subfield/@code = ('t','l')]">
               <xsl:for-each select="*:subfield[@code = ('t','l')]">
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'l'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                        <xsl:with-param name="value" select="lower-case(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20312'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='730'][. eq $this_field][*:subfield/@code = ('a','l')]">
               <xsl:for-each select="*:subfield[@code = ('a','l')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'l'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                        <xsl:with-param name="value" select="lower-case(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20312'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='740'][frbrizer:linked($anchor_field, ., true())][*:subfield/@code = ('a')]">
               <xsl:for-each select="*:subfield[@code = ('a')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20315'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('245')]">
               <xsl:variable name="target_template_name" select="'MARC21-245-Manifestation'"/>
               <xsl:variable name="target_tag_value" select="'245'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:call-template name="create-property-from-subfield">
                  <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/object/P20059'"/>
                  <xsl:with-param name="resource"
                                   select="'http://example.org/' || (if (($record/*:datafield[@tag=('020','022','024')][1]/*:subfield[@code='a'])[1]) then ($record/*:datafield[@tag=('020','022','024')][1]/*:subfield[@code='a'])[1]/replace(., '\D', '') else if ($record/*:controlfield[@tag=('001')]) then $record/*:controlfield[@tag=('001')][1]/replace(., '\D', '') else replace($record/*:datafield[@tag='245']/*:subfield[@code='a'],  '[^a-zA-Z0-9 -]', '' ) || '-' || generate-id(.))"/>
               </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('700','710','711','730')][exists(*:subfield[@code = '1']/starts-with(., 'http'))  and @ind2='2' and (if (@tag eq '730') then true() else *:subfield/@code = 't')]">
               <xsl:variable name="target_template_name" select="'MARC21-700-Work-Analytical'"/>
               <xsl:variable name="target_tag_value" select="'700, 710, 711, 730'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:if test="($target_field = $this_field)">
                  <xsl:call-template name="create-property-from-subfield">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/e/object/P20231'"/>
                     <xsl:with-param name="resource"
                                      select="./*:subfield[@code='1' and starts-with(., 'http')][last()]"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('100','110','111','700','710','711')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
               <xsl:variable name="target_template_name" select="'MARC21-100700Person'"/>
               <xsl:variable name="target_tag_value" select="'100, 110, 111, 700, 710, 711'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/e/') and frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="$target_subfield"/>
                        <xsl:with-param name="resource"
                                         select="frbrizer:trim(../*:subfield[@code='1'][starts-with(., 'http')][1])"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('008')][string-length(.) eq 40 and matches(substring(., 36, 3), '[a-z][a-z][a-z]')]">
               <xsl:variable name="target_template_name" select="'MARC008language'"/>
               <xsl:variable name="target_tag_value" select="'008'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                  <xsl:call-template name="create-property-from-subfield">
                     <xsl:with-param name="type"
                                      select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                     <xsl:with-param name="resource"
                                      select="concat('http://id.loc.gov/vocabulary/iso639-2/', substring(., 36, 3))"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('041')]">
               <xsl:variable name="target_template_name" select="'MARC041'"/>
               <xsl:variable name="target_tag_value" select="'041'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('a','d')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20006'"/>
                        <xsl:with-param name="resource"
                                         select="concat('http://id.loc.gov/vocabulary/iso639-2/', .)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('041')]">
               <xsl:variable name="target_template_name" select="'MARC041additional'"/>
               <xsl:variable name="target_tag_value" select="'041'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('b','e','f','g','i','j','k','l','m','n','p','q','r','t')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20065'"/>
                        <xsl:with-param name="resource"
                                         select="concat('http://id.loc.gov/vocabulary/iso639-2/', .)"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('336')]">
               <xsl:variable name="target_template_name" select="'MARC336'"/>
               <xsl:variable name="target_tag_value" select="'336'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/e/datatype/P20001'"/>
                        <xsl:with-param name="resource" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Related-Work">
      <xsl:variable name="this_template_name" select="'MARC21-700-Related-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'700, 710, 711, 730'"/>
      <xsl:variable name="code" as="xs:string" select="'4'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('700','710','711','730')][exists(*:subfield[@code = '1' and starts-with(., 'http')]) and not(@ind2 = '2') and (if (@tag eq '730') then true() else *:subfield/@code = 't')]">
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
         <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10001')}">
               <xsl:attribute name="rdf:about"
                               select="frbrizer:trim(../*:subfield[@code='1'][starts-with(.,'http')][last()])"/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='700'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value"
                                            select="frbrizer:trim(.) || ' (' || ../*:subfield[@code='a']/replace(., '[\s,/:=]+$', '') || ')'"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='710'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='711'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='730'][. eq $this_field][*:subfield/@code = ('a','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-700-Work-Analytical">
      <xsl:variable name="this_template_name" select="'MARC21-700-Work-Analytical'"/>
      <xsl:variable name="tag" as="xs:string" select="'700, 710, 711, 730'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('700','710','711','730')][exists(*:subfield[@code = '1']/starts-with(., 'http'))  and @ind2='2' and (if (@tag eq '730') then true() else *:subfield/@code = 't')]">
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
         <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10001')}">
            <xsl:attribute name="rdf:about"
                            select="./*:subfield[@code='1' and starts-with(., 'http')][last()]"/>
            <xsl:element name="frbrizer:template">
               <xsl:value-of select="$this_template_name"/>
            </xsl:element>
            <xsl:for-each select="$record/*:datafield[@tag='700'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
               <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value"
                                         select="frbrizer:trim(.) || ' (' || ../*:subfield[@code='a']/replace(., '[\s,/:=]+$', '') || ')'"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                        <xsl:with-param name="value"
                                         select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'f'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'n'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = '1'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='710'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
               <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                        <xsl:with-param name="value"
                                         select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'f'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'n'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = '1'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='711'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
               <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 't'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                        <xsl:with-param name="value"
                                         select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'f'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'n'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = '1'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/*:datafield[@tag='730'][. eq $this_field][*:subfield/@code = ('a','f','n','1')]">
               <xsl:for-each select="*:subfield[@code = ('a','f','n','1')]">
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                        <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'a'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                        <xsl:with-param name="value"
                                         select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'f'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = 'n'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
                  <xsl:if test="@code = '1'">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                        <xsl:with-param name="value" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('130','240')][*:subfield/@code = '1']">
               <xsl:variable name="target_template_name" select="'MARC21-130240-Work'"/>
               <xsl:variable name="target_tag_value" select="'130, 240'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:call-template name="create-property-from-subfield">
                     <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/object/P10019'"/>
                     <xsl:with-param name="resource" select="."/>
                  </xsl:call-template>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600','610','611')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
               <xsl:variable name="target_template_name" select="'MARC21-600-Person'"/>
               <xsl:variable name="target_tag_value" select="'600, 610, 611'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('1')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/object/P10319'"/>
                        <xsl:with-param name="resource" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('600','610','611','630')][*:subfield/@code = '1' and  (if (@tag eq '630') then true() else *:subfield/@code = 't')]">
               <xsl:variable name="target_template_name" select="'MARC21-6XX-Work'"/>
               <xsl:variable name="target_tag_value" select="'600, 610, 611, 630'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()) and not($this_field/*:subfield[@code = '1'] = $target_field/*:subfield[@code = '1']))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="'http://rdaregistry.info/Elements/w/object/P10257'"/>
                        <xsl:with-param name="resource" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('100','110','111','700','710','711')][exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')]">
               <xsl:variable name="target_template_name" select="'MARC21-100700Person'"/>
               <xsl:variable name="target_tag_value" select="'100, 110, 111, 700, 710, 711'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/') and frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="$target_subfield"/>
                        <xsl:with-param name="resource"
                                         select="frbrizer:trim(../*:subfield[@code='1'][starts-with(., 'http')][1])"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('700','710','711','730')][exists(*:subfield[@code = '1' and starts-with(., 'http')]) and not(@ind2 = '2') and (if (@tag eq '730') then true() else *:subfield/@code = 't')]">
               <xsl:variable name="target_template_name" select="'MARC21-700-Related-Work'"/>
               <xsl:variable name="target_tag_value" select="'700, 710, 711, 730'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('4')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/') and frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="$target_subfield"/>
                        <xsl:with-param name="resource"
                                         select="frbrizer:trim(../*:subfield[@code='1'][starts-with(.,'http')][last()])"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('758')]">
               <xsl:variable name="target_template_name" select="'MARC21-758-Related-Work'"/>
               <xsl:variable name="target_tag_value" select="'758'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('4')][starts-with(., 'http') and exists($this_field/*:subfield[@code = '1']/starts-with(., 'http')) ]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/')  and frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type" select="$target_subfield"/>
                        <xsl:with-param name="resource"
                                         select="../*:subfield[@code='1' and starts-with(., 'http')][last()]"/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$record/node()[@tag=('380')]">
               <xsl:variable name="target_template_name" select="'MARC380'"/>
               <xsl:variable name="target_tag_value" select="'380'"/>
               <xsl:variable name="target_field"
                              select="(ancestor-or-self::*:datafield, ancestor-or-self::*:controlfield)"/>
               <xsl:variable name="target_field_position"
                              as="xs:string"
                              select="string(position())"/>
               <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
                  <xsl:variable name="target_subfield" select="."/>
                  <xsl:variable name="target_subfield_code"
                                 as="xs:string"
                                 select="$target_subfield/@code"/>
                  <xsl:variable name="target_subfield_position"
                                 as="xs:string"
                                 select="string(position())"/>
                  <xsl:if test="(frbrizer:linked($anchor_field, $target_field, false()))">
                     <xsl:call-template name="create-property-from-subfield">
                        <xsl:with-param name="type"
                                         select="'http://rdaregistry.info/Elements/w/datatype/P10004'"/>
                        <xsl:with-param name="resource" select="."/>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
         </xsl:element>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-758-Related-Work">
      <xsl:variable name="this_template_name" select="'MARC21-758-Related-Work'"/>
      <xsl:variable name="tag" as="xs:string" select="'758'"/>
      <xsl:variable name="code" as="xs:string" select="'4'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('758')]">
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
         <xsl:for-each select="node()[@code=('4')][starts-with(., 'http') and exists($this_field/*:subfield[@code = '1']/starts-with(., 'http')) ]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10001')}">
               <xsl:attribute name="rdf:about"
                               select="../*:subfield[@code='1' and starts-with(., 'http')][last()]"/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='758'][. = $this_field][*:subfield/@code = ('a','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC21-8XX-Work-Series">
      <xsl:variable name="this_template_name" select="'MARC21-8XX-Work-Series'"/>
      <xsl:variable name="tag" as="xs:string" select="'800, 810, 811, 830'"/>
      <xsl:variable name="code" as="xs:string" select="'1'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('800','810','811','830')]">
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
         <xsl:for-each select="node()[@code=('1')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://rdaregistry.info/Elements/c/C10001')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='800'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value"
                                            select="frbrizer:trim(.) || ' (' || ../*:subfield[@code='a']/replace(., '[\s,/:=]+$', '') || ')'"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='810'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='811'][. eq $this_field][*:subfield/@code = ('t','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('t','f','n','1')]">
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 't'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
               <xsl:for-each select="$record/*:datafield[@tag='830'][. eq $this_field][*:subfield/@code = ('a','f','n','1')]">
                  <xsl:for-each select="*:subfield[@code = ('a','f','n','1')]">
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type" select="'http://www.w3.org/2000/01/rdf-schema#label'"/>
                           <xsl:with-param name="value" select="frbrizer:trim(.)"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'a'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10088'"/>
                           <xsl:with-param name="value"
                                            select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'f'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10219'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = 'n'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/w/datatype/P10012'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:if test="@code = '1'">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://rdaregistry.info/Elements/x/datatype/P00018'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC336">
      <xsl:variable name="this_template_name" select="'MARC336'"/>
      <xsl:variable name="tag" as="xs:string" select="'336'"/>
      <xsl:variable name="code" as="xs:string" select="'0'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('336')]">
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
         <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://www.w3.org/2004/02/skos/core#Concept')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='336'][generate-id(.) = generate-id($this_field)][*:subfield/@code = ('0')]">
                  <xsl:for-each select="*:subfield[@code = ('0')]">
                     <xsl:if test="@code = '0' and generate-id(.) = generate-id($this_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC337">
      <xsl:variable name="this_template_name" select="'MARC337'"/>
      <xsl:variable name="tag" as="xs:string" select="'337'"/>
      <xsl:variable name="code" as="xs:string" select="'0'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('337')]">
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
         <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://www.w3.org/2004/02/skos/core#Concept')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='337'][generate-id(.) = generate-id($this_field)][*:subfield/@code = ('0')]">
                  <xsl:for-each select="*:subfield[@code = ('0')]">
                     <xsl:if test="@code = '0' and generate-id(.) = generate-id($this_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC338">
      <xsl:variable name="this_template_name" select="'MARC338'"/>
      <xsl:variable name="tag" as="xs:string" select="'338'"/>
      <xsl:variable name="code" as="xs:string" select="'0'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('338')]">
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
         <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://www.w3.org/2004/02/skos/core#Concept')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='338'][generate-id(.) = generate-id($this_field)][*:subfield/@code = ('0')]">
                  <xsl:for-each select="*:subfield[@code = ('0')]">
                     <xsl:if test="@code = '0' and generate-id(.) = generate-id($this_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:template name="MARC380">
      <xsl:variable name="this_template_name" select="'MARC380'"/>
      <xsl:variable name="tag" as="xs:string" select="'380'"/>
      <xsl:variable name="code" as="xs:string" select="'0'"/>
      <xsl:variable name="record" select="."/>
      <xsl:variable name="marcid" select="*:controlfield[@tag='001']"/>
      <xsl:for-each select="node()[@tag=('380')]">
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
         <xsl:for-each select="node()[@code=('0')][starts-with(., 'http')]">
            <xsl:variable name="this_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="anchor_subfield" select="(ancestor-or-self::*:subfield)"/>
            <xsl:variable name="this_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="anchor_subfield_code"
                           as="xs:string"
                           select="$this_subfield/@code"/>
            <xsl:variable name="this_subfield_position"
                           as="xs:string"
                           select="string(position())"/>
            <xsl:element name="{frbrizer:create-class-name('http://www.w3.org/2004/02/skos/core#Concept')}">
               <xsl:attribute name="rdf:about" select="."/>
               <xsl:element name="frbrizer:template">
                  <xsl:value-of select="$this_template_name"/>
               </xsl:element>
               <xsl:for-each select="$record/*:datafield[@tag='380'][generate-id(.) = generate-id($this_field)][*:subfield/@code = ('0')]">
                  <xsl:for-each select="*:subfield[@code = ('0')]">
                     <xsl:if test="@code = '0' and generate-id(.) = generate-id($this_subfield)">
                        <xsl:call-template name="create-property-from-subfield">
                           <xsl:with-param name="type"
                                            select="'http://www.w3.org/2004/02/skos/core#subjectIndicator'"/>
                           <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                     </xsl:if>
                  </xsl:for-each>
               </xsl:for-each>
            </xsl:element>
         </xsl:for-each>
      </xsl:for-each>
   </xsl:template>
   <xsl:function name="frbrizer:construct-identifier">
      <xsl:param name="record"/>
      <xsl:choose>
         <xsl:when test="$record/frbrizer:template = 'MARC21-130240-Expression'">
            <xsl:value-of select="string-join((($record/*:P20231/@rdf:resource)[1], 'C10006', frbrizer:trimsort-targets($record/*:P20006/@rdf:resource), frbrizer:trimsort-targets($record/*:P20001/@rdf:resource), frbrizer:trimsort-targets($record/(*:P20037, *:P20022, *:P20049, *:P20330)/@rdf:resource)), '/')"/>
         </xsl:when>
         <xsl:when test="$record/frbrizer:template = 'MARC21-700-Expression-Analytical'">
            <xsl:value-of select="string-join(((frbrizer:sort-properties($record/*:P20231/@rdf:resource))[1], string-join(frbrizer:trimsort-targets(($record/*:P20037, $record/*:P20022, $record/*:P20049, $record/*:P20330)/@rdf:resource), '/')), '/')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$record/@rdf:about"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:template xmlns:err="http://www.w3.org/2005/xqt-errors"
                  name="create-property-from-subfield">
      <xsl:param name="type" required="no" select="''"/>
      <xsl:param name="value" required="no"/>
      <xsl:param name="resource" required="no"/>
      <xsl:if test="$type ne '' and starts-with($type, 'http')">
         <xsl:try>
            <xsl:variable name="property-name" select="tokenize($type, '[/#]')[last()]"/>
            <xsl:variable name="property-namespace" select="replace($type, $property-name, '')"/>
            <xsl:element name="{$prefixmap($property-namespace) || ':' || $property-name}"
                          namespace="{$property-namespace}">
               <xsl:choose>
                  <xsl:when test="$resource ne ''">
                     <xsl:attribute name="rdf:resource" select="normalize-space($resource)"/>
                  </xsl:when>
                  <xsl:when test="$value ne ''">
                     <xsl:value-of select="normalize-space($value)"/>
                  </xsl:when>
                  <xsl:otherwise/>
               </xsl:choose>
            </xsl:element>
            <xsl:catch>
               <xsl:message terminate="no">
                  <xsl:value-of select="'Error converting to rdf property : ' || $type"/>
                  <xsl:value-of select="', Value : ' || $value"/>
                  <!--<xsl:value-of select="$entity_type"></xsl:value-of>-->
                  <xsl:value-of select="$err:description"/>
               </xsl:message>
            </xsl:catch>
         </xsl:try>
      </xsl:if>
   </xsl:template>
   <xsl:template xmlns:err="http://www.w3.org/2005/xqt-errors" name="copy-content">
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
      <!--<xsl:if test="$include_labels and ($label ne '')">
            <xsl:if test="$label ne ''">
                <xsl:attribute name="label" select="$label"/>
            </xsl:if>
        </xsl:if>-->
      <xsl:value-of select="normalize-space($select)"/>
   </xsl:template>
   <xsl:template xmlns:err="http://www.w3.org/2005/xqt-errors" name="copy-attributes">
      <xsl:for-each select="@*">
         <xsl:copy/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template xmlns:err="http://www.w3.org/2005/xqt-errors"
                  match="rdf:RDF"
                  mode="create-identifier"
                  name="create-identifier">
      <rdf:RDF>
         <xsl:for-each select="rdf:Description/frbrizer:recordset/*">
            <xsl:sort select="name()"/>
            <xsl:sort select="@rdf:about"/>
            <xsl:variable name="record" select="."/>
            <xsl:copy>
               <xsl:for-each select="@*">
                  <xsl:choose>
                     <xsl:when test="name() = 'rdf:about'">
                        <xsl:attribute name="rdf:about" select="frbrizer:construct-identifier($record)"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:copy-of select="."/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
               <!-- copy remaining of record -->
               <xsl:for-each select="node()">
                  <xsl:copy-of select="."/>
               </xsl:for-each>
            </xsl:copy>
         </xsl:for-each>
      </rdf:RDF>
   </xsl:template>
   <xsl:template xmlns:err="http://www.w3.org/2005/xqt-errors"
                  match="rdf:RDF"
                  mode="merge"
                  name="merge">
      <xsl:copy>
         <xsl:for-each-group select="*" group-by="(name() || @rdf:about)">
            <xsl:element name="{current-group()[1]/name()}">
               <xsl:copy-of select="current-group()[1]/@*"/>
               <xsl:for-each-group select="* except frbrizer:template"
                                    group-by="name() || . || @rdf:resource">
                  <xsl:copy-of select="current-group()[1]"/>
               </xsl:for-each-group>
            </xsl:element>
         </xsl:for-each-group>
      </xsl:copy>
   </xsl:template>
   <xsl:function xmlns:err="http://www.w3.org/2005/xqt-errors"
                  name="frbrizer:create-class-name">
      <xsl:param name="type" required="yes"/>
      <xsl:variable name="property-name" select="tokenize($type, '[/#]')[last()]"/>
      <xsl:variable name="property-namespace" select="replace($type, $property-name, '')"/>
      <xsl:copy-of select="$prefixmap($property-namespace) || ':' || $property-name"/>
   </xsl:function>
   <xsl:function xmlns:err="http://www.w3.org/2005/xqt-errors" name="frbrizer:get-namespace">
      <xsl:param name="type" required="yes"/>
      <xsl:variable name="property-name" select="tokenize($type, '[/#]')[last()]"/>
      <xsl:variable name="property-namespace" select="replace($type, $property-name, '')"/>
      <xsl:value-of select="$property-namespace"/>
   </xsl:function>
   <xsl:function xmlns:err="http://www.w3.org/2005/xqt-errors"
                  xmlns:local="http://idi.ntnu.no/frbrizer/"
                  name="local:sort-keys">
      <xsl:param name="keys"/>
      <xsl:perform-sort select="distinct-values($keys)">
         <xsl:sort select="."/>
      </xsl:perform-sort>
   </xsl:function>
   <xsl:function xmlns:err="http://www.w3.org/2005/xqt-errors"
                  xmlns:local="http://idi.ntnu.no/frbrizer/"
                  name="local:sort-properties">
      <xsl:param name="properties"/>
      <xsl:perform-sort select="$properties">
         <xsl:sort select="."/>
      </xsl:perform-sort>
   </xsl:function>
   <xsl:function xmlns:err="http://www.w3.org/2005/xqt-errors"
                  xmlns:local="http://idi.ntnu.no/frbrizer/"
                  name="local:trimsort-targets"
                  as="xs:string*">
      <xsl:param name="relationships"/>
      <xsl:perform-sort select="for $r in distinct-values($relationships) return if (local:trim-target($r) ne '') then local:trim-target($r) else ()">
         <xsl:sort select="."/>
      </xsl:perform-sort>
   </xsl:function>
   <xsl:function xmlns:err="http://www.w3.org/2005/xqt-errors"
                  xmlns:local="http://idi.ntnu.no/frbrizer/"
                  name="local:trim-target">
        <!-- This function transforms a list of uris to a list of strings containing the last part of the uri-->
      <xsl:param name="value" as="xs:string"/>
      <xsl:value-of select="let $x := $value return if (matches($x, '\w+:(/?/?)[^\s]+')) then (tokenize(replace($x, '/$', ''), '/'))[last()] else $x"/>
   </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  name="frbrizer:validateURI">
      <xsl:param name="uri"/>
      <xsl:param name="field"/>
      <xsl:choose>
         <xsl:when test="xs:anyURI($uri) and starts-with($uri, 'http')">
            <xsl:value-of select="$uri"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:message terminate="no">Emty or invalid URI '<xsl:value-of select="$uri"/>' in field <xsl:value-of select="$field"/>
            </xsl:message>
            <xsl:value-of select="$uri"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  name="frbrizer:linked"
                  as="xs:boolean">
            <!-- returns true if the two fields have the same marc 21 link ($8), or if there is no linking subfields in target or source -->
      <xsl:param name="source" as="element()" required="yes"/>
      <xsl:param name="target" as="element()" required="yes"/>
      <xsl:param name="strict" as="xs:boolean" required="yes"/>
      <xsl:choose>
         <xsl:when test="$strict">
                    <!-- returns true if the two fields have the same marc 21 link ($8), or if there is no linking subfields in either source nor target -->
            <xsl:sequence select="some $x in $source/*:subfield[@code = '8'] satisfies $x = $target/*:subfield[@code = '8']"/>
         </xsl:when>
         <xsl:otherwise>
                    <!-- returns true if the two fields have the same marc 21 link ($8), or if there is no linking subfields in target -->
            <xsl:sequence select="(some $x in $source/*:subfield[@code = '8'] satisfies $x = $target/*:subfield[@code = '8']) or not(exists($target/*:subfield[@code='8']))"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  name="frbrizer:trim"
                  as="xs:string*">
      <xsl:param name="value" as="element()*"/>
      <xsl:for-each select="$value">
         <xsl:value-of select="replace(., '[\s\.,/:=]+$', '')"/>
      </xsl:for-each>
   </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  name="frbrizer:extent"
                  as="xs:string">
      <xsl:param name="datafield" as="element()"/>
      <xsl:variable name="extent">
         <xsl:if test="$datafield/*:subfield[@code='a']">
            <xsl:value-of select="replace($datafield/*:subfield[@code='a'], '[\s;:]+$', '')"/>
         </xsl:if>
         <xsl:if test="$datafield/*:subfield[@code='b']">
            <xsl:value-of select="' : ' || replace($datafield/*:subfield[@code='b'], '[\s;:]+$', '')"/>
         </xsl:if>
         <!--<xsl:if test="$datafield/*:subfield[@code='c']">
                    <xsl:value-of select="' ; ' || replace($datafield/*:subfield[@code='c'], '[\s;:]+$', '')"/>
                </xsl:if>-->
         <xsl:for-each select="$datafield/*:subfield[@code='c']/replace(., '[\s\.;:]+$', '')">
            <xsl:value-of select="', ' || replace(string-join(., ' ; '), '[\s\.]+$', '')"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="replace(string-join($extent, ''), '[ \.]+$', '') || '.'"/>
   </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  name="frbrizer:publication"
                  as="xs:string">
      <xsl:param name="datafield" as="element()"/>
      <xsl:variable name="formatted" as="xs:string*">
         <xsl:for-each-group select="$datafield/*:subfield"
                              group-starting-with="*:subfield[@code = 'a']">
            <xsl:variable name="part" as="xs:string*">
               <xsl:for-each select="current-group()[@code = 'a']">
                  <xsl:value-of select="replace(., '[\s,;:]+$', '')"/>
               </xsl:for-each>
               <xsl:for-each select="current-group()[@code = 'b']">
                  <xsl:value-of select="' : ' || replace(., '[\s,;:]+$', '')"/>
               </xsl:for-each>
               <xsl:for-each select="current-group()[@code = 'c']/replace(., '[\s\.]+$', '')">
                  <xsl:value-of select="', ' || replace(string-join(., ' ; '), '[\s\.]+$', '')"/>
               </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="string-join($part, '')"/>
         </xsl:for-each-group>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="matches($formatted[last()], '\.$')">
            <xsl:value-of select="string-join($formatted, ' ; ')"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="string-join($formatted, ' ; ') || '.'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   <xsl:function xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                  name="frbrizer:idprefix">
      <xsl:param name="value"/>
      <xsl:choose>
         <xsl:when test="$value = '0'">
            <xsl:value-of select="'ISRC'"/>
         </xsl:when>
         <xsl:when test="$value = '1'">
            <xsl:value-of select="'UPC'"/>
         </xsl:when>
         <xsl:when test="$value = '2'">
            <xsl:value-of select="'ISMN'"/>
         </xsl:when>
         <xsl:when test="$value = '3'">
            <xsl:value-of select="'IAN'"/>
         </xsl:when>
         <xsl:when test="$value = '4'">
            <xsl:value-of select="'SICI'"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'NN'"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
</xsl:stylesheet>
