# marc2frbr

marc2frbr is a tool for performing interpretations and conversion of bibliographic MARC records in XML to new entity-centric models such as LRM or BIBFRAME. The tools is intended for experimental conversions and it's strong feature is the use of highly customizable rules that allows the tool to be adapted to different catalogues, output models and formats.

1. Create a rule file in xml
1. Use an XSLT processor and run make.xslt on the rules file to create a an XSLT file for the actual conversions
1. Transform one or more MARC record collections (XML files) using the created XSLT conversion file

The tools allows for easy experimentation with ways of interepreting the records and different outputs.

An example of the rule file can be found in the examples diretory. The format is rather simple, but since some selections and conditions make use of xpath-expressions and userdefined xpath-funtions, the overall rules can be rather intricate and complex.
```
   <!-- Agent entries main 
        conditions are checking if there is a URI in $1 to identifty the person and URI in $4 for relating the person to the entities -->
    <entity tag="100" condition="exists(*:subfield[@code = '1']/starts-with(., 'http')) and not(*:subfield/@code = 't')" code="4" code-condition="starts-with(., 'http')"
                      type="http://rdaregistry.info/Elements/c/C10002" templatename="MARC21-100-Person" label="Person">
        <note>Persons identified in field 100 </note>
        <attributes>
            <datafield tag="100" condition=". eq $this_field">
                <subfield code="a" type="http://www.w3.org/2000/01/rdf-schema#label" select="frbrizer:trim(.)" label="rdf label"/>
                <subfield code="a" type="http://rdaregistry.info/Elements/a/datatype/P50385" select="frbrizer:trim(.)" label="has name of the agent"/>
                <subfield code="d" type="http://rdaregistry.info/Elements/a/datatype/P50339" select="frbrizer:trim(.)" label="has related timespan of agent"/>
                <subfield code="1" type="http://rdaregistry.info/Elements/x/datatype/P00018" label="has identifier for agent"/>
            </datafield>
        </attributes>
        <key order="1">
            <element>frbrizer:trim(*:datafield[@tag=('100')]/*:subfield[@code='1'][starts-with(., 'http')][1])</element>
        </key>
        <relationships>
            <!-- relationships are described from the WEMI entities to the person -->
        </relationships>
    </entity>
 
    <!-- Main entry work 
         essentially iterating over 240-fields with a subfield 1 used for URI to identify entity
         -->
    <entity tag="240" code="1" code-condition="starts-with(., 'http')" type="http://rdaregistry.info/Elements/c/C10001" templatename="MARC21-240-Work" label="Work">
        <attributes>
            <datafield tag="240"  condition=". eq $this_field">
                <subfield code="a" type="http://www.w3.org/2000/01/rdf-schema#label"
                                    select="frbrizer:trim(.) || (if ($record/*:datafield[@tag='100'])
                                    then ' (' || $record/*:datafield[@tag='100']/*:subfield[@code='a']/replace(., '[\s,/:=]+$', '') || ')' else () )" label="rdf label"/>
                <subfield code="a" type="http://rdaregistry.info/Elements/w/datatype/P10088" select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                <subfield code="f" type="http://rdaregistry.info/Elements/w/datatype/P10219" />
                <subfield code="n" type="http://rdaregistry.info/Elements/w/datatype/P10012"/>
                <subfield code="1" type="http://rdaregistry.info/Elements/x/datatype/P00018"/>
            </datafield>
            <datafield tag="520">
                <subfield code="a" type="http://rdaregistry.info/Elements/w/datatype/P10330" label="note"/>
            </datafield>
        </attributes>
        <key order="1">
            <element>frbrizer:trim(*:datafield[@tag=('240')]/*:subfield[@code='1'][starts-with(., 'http')][last()])</element>
        </key>
        <relationships>
            <relationship type="{$target_subfield}">
                <target entity="MARC21-100-Person" condition="starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/')  and frbrizer:linked($anchor_field, $target_field, false())" />
            </relationship>
            <relationship type="{$target_subfield}">
                <target entity="MARC21-758-Related-Work" condition="starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/') and frbrizer:linked($anchor_field, $target_field, false())"/>
            </relationship>
        </relationships>
    </entity>
```

The tool uses an intermediary format in the transformation, with each created entity as a separat MARC XML record. This format is based on the intial structure of records, datafields and subfields, enhanced with relationships and semantic typing according to the intended output.

The intermediary format can directly be translated into RDF (supported by the tool). Keys are used to uniquely identify each entity for merging and deduplication purposes. 

```
<?xml version="1.0" encoding="UTF-8"?>
<rdf:RDF xmlns:ex="http://www.example.org/"
         xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"
         xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
         xmlns:map="http://www.w3.org/2005/xpath-functions/map"
         xmlns:marc="http://www.loc.gov/MARC21/slim"
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
         xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <rdac:C10001 rdf:about="http://viaf.org/viaf/1307171191134758030004">
      <rdaxd:P00018>http://viaf.org/viaf/1307171191134758030004</rdaxd:P00018>
      <rdawd:P10088>Stella Maris</rdawd:P10088>
      <rdfs:label>Stella Maris (McCarthy, Cormac)</rdfs:label>
      <rdawd:P10330>"From the best-selling, Pulitzer Prize-winning author of The Road comes the second volume of a two-volume masterpiece: Stella Maris is an intimate portrait of grief and longing, as a young woman in a psychiatric facility seeks to understand her own existence. Black River Falls, Wisconsin, 1972: Alicia Western, twenty years old, with forty thousand dollars in a plastic bag, admits herself to the hospital. A doctoral candidate in mathematics at the University of Chicago, Alicia has been diagnosed with paranoid schizophrenia, and she does not want to talk about her brother, Bobby. Instead, she contemplates the nature of madness, the human insistence on one common experience of the world; she recalls a childhood where, by the age of seven, her own grandmother feared for her; she surveys the intersection of physics and philosophy; and she introduces her cohorts, her chimeras, the hallucinations that only she can see. All the while, she grieves for Bobby, not quite dead, not quite hers. Told entirely through the transcripts of Alicia's psychiatric sessions, Stella Maris is a searching, rigorous, intellectually challenging coda to The Passenger, a philosophical inquiry that questions our notions of God, truth, and existence"-</rdawd:P10330>
      <rdawo:P10061 rdf:resource="http://viaf.org/viaf/29558386"/>
      <rdawo:P10122 rdf:resource="http://viaf.org/viaf/470166838899836200007"/>
   </rdac:C10001>
   <rdac:C10001 rdf:about="http://viaf.org/viaf/220031159">
      <rdaxd:P00018>http://viaf.org/viaf/220031159</rdaxd:P00018>
      <rdawd:P10088>The road</rdawd:P10088>
      <rdfs:label>The road (McCarthy, Cormac)</rdfs:label>
      <rdawo:P10061 rdf:resource="http://viaf.org/viaf/29558386"/>
   </rdac:C10001>
   <rdac:C10001 rdf:about="http://viaf.org/viaf/470166838899836200007">
      <rdaxd:P00018>http://viaf.org/viaf/470166838899836200007</rdaxd:P00018>
      <rdawd:P10088>The passenger</rdawd:P10088>
      <rdfs:label>The passenger (McCarthy, Cormac)</rdfs:label>
      <rdawo:P10061 rdf:resource="http://viaf.org/viaf/29558386"/>
   </rdac:C10001>
   <rdac:C10002 rdf:about="http://viaf.org/viaf/29558386">
      <rdaxd:P00018>http://viaf.org/viaf/29558386</rdaxd:P00018>
      <rdaad:P50385>McCarthy, Cormac</rdaad:P50385>
      <rdfs:label>McCarthy, Cormac</rdfs:label>
      <rdaad:P50339>1933-2023</rdaad:P50339>
   </rdac:C10002>
   <rdac:C10006 rdf:about="http://viaf.org/viaf/1307171191134758030004/exp/eng/1020">
      <rdaed:P20316>Stella Maris</rdaed:P20316>
      <rdaed:P20312>Stella Maris</rdaed:P20312>
      <rdfs:label>Stella Maris (McCarthy, Cormac)</rdfs:label>
      <rdaed:P20001 rdf:resource="http://rdaregistry.info/termList/RDAContentType/1020"/>
      <rdaed:P20006 rdf:resource="http://id.loc.gov/vocabulary/iso639-2/eng"/>
      <rdaeo:P20231 rdf:resource="http://viaf.org/viaf/1307171191134758030004"/>
   </rdac:C10006>
   <rdac:C10006 rdf:about="http://viaf.org/viaf/220031159/exp/eng/1020">
      <rdaed:P20316>The road</rdaed:P20316>
      <rdaed:P20312>The road</rdaed:P20312>
      <rdfs:label>The road (McCarthy, Cormac)</rdfs:label>
      <rdaed:P20001 rdf:resource="http://rdaregistry.info/termList/RDAContentType/1020"/>
      <rdaed:P20006 rdf:resource="http://id.loc.gov/vocabulary/iso639-2/eng"/>
      <rdaeo:P20231 rdf:resource="http://viaf.org/viaf/220031159"/>
   </rdac:C10006>
   <rdac:C10006 rdf:about="http://viaf.org/viaf/470166838899836200007/exp/eng/1020">
      <rdaed:P20316>The passenger</rdaed:P20316>
      <rdaed:P20312>The passenger</rdaed:P20312>
      <rdfs:label>The passenger (McCarthy, Cormac)</rdfs:label>
      <rdaed:P20001 rdf:resource="http://rdaregistry.info/termList/RDAContentType/1020"/>
      <rdaed:P20006 rdf:resource="http://id.loc.gov/vocabulary/iso639-2/eng"/>
      <rdaeo:P20231 rdf:resource="http://viaf.org/viaf/470166838899836200007"/>
   </rdac:C10006>
   <rdac:C10007 rdf:about="http://example.org/isbn-0307265439">
      <rdamd:P30004>ISBN 0307265439</rdamd:P30004>
      <rdaxd:P00018>isbn-0307265439</rdaxd:P00018>
      <rdfs:label>ISBN0307265439</rdfs:label>
      <rdamd:P30004>ISBN 9780307265432</rdamd:P30004>
      <rdaxd:P00018>isbn-9780307265432</rdaxd:P00018>
      <rdfs:label>ISBN9780307265432</rdfs:label>
      <rdamd:P30156>The road</rdamd:P30156>
      <rdamd:P30117>Cormac McCarthy</rdamd:P30117>
      <rdamd:P30107>1st ed</rdamd:P30107>
      <rdamd:P30088>New York</rdamd:P30088>
      <rdamd:P30111>New York : Alfred A. Knopf, 2006</rdamd:P30111>
      <rdamd:P30083>Alfred A. Knopf</rdamd:P30083>
      <rdamd:P30011>2006</rdamd:P30011>
      <rdamd:P30182>241 p., 25 cm.</rdamd:P30182>
      <rdamd:P30137>Winner of the Pulitzer Prize in 2006 as well as the James Tait Black Memorial Prize for Fiction. McCarthy is a 1981 MacArthur Fellow.</rdamd:P30137>
      <rdamd:P30001 rdf:resource="http://rdaregistry.info/termList/RDACarrierType/1049"/>
      <rdamd:P30002 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1007"/>
      <rdamo:P30139 rdf:resource="http://viaf.org/viaf/220031159/exp/eng/1020"/>
   </rdac:C10007>
   <rdac:C10007 rdf:about="http://example.org/isbn-0307269000">
      <rdamd:P30004>ISBN 0307269000</rdamd:P30004>
      <rdaxd:P00018>isbn-0307269000</rdaxd:P00018>
      <rdfs:label>ISBN0307269000</rdfs:label>
      <rdamd:P30004>ISBN 9780307269003</rdamd:P30004>
      <rdaxd:P00018>isbn-9780307269003</rdaxd:P00018>
      <rdfs:label>ISBN9780307269003</rdfs:label>
      <rdamd:P30156>Stella Maris</rdamd:P30156>
      <rdamd:P30117>Cormac McCarthy</rdamd:P30117>
      <rdamd:P30107>First edition</rdamd:P30107>
      <rdamd:P30088>New York</rdamd:P30088>
      <rdamd:P30111>New York : Alfred A. Knopf, 2022</rdamd:P30111>
      <rdamd:P30083>Alfred A. Knopf</rdamd:P30083>
      <rdamd:P30011>2022</rdamd:P30011>
      <rdamd:P30007>©2022</rdamd:P30007>
      <rdamd:P30182>189 pages, 25 cm.</rdamd:P30182>
      <rdamd:P30137>"This is a Borzoi book"- Title page verso.</rdamd:P30137>
      <rdamd:P30137>Sequel to: The Passenger.</rdamd:P30137>
      <rdamd:P30001 rdf:resource="http://rdaregistry.info/termList/RDACarrierType/1049"/>
      <rdamd:P30002 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1007"/>
      <rdamo:P30139 rdf:resource="http://viaf.org/viaf/1307171191134758030004/exp/eng/1020"/>
   </rdac:C10007>
   <rdac:C10007 rdf:about="http://example.org/isbn-9780307455291">
      <rdamd:P30004>ISBN 9780307455291 (pbk.)</rdamd:P30004>
      <rdaxd:P00018>isbn-9780307455291</rdaxd:P00018>
      <rdfs:label>ISBN9780307455291 (pbk.)</rdfs:label>
      <rdamd:P30156>The road</rdamd:P30156>
      <rdamd:P30117>Cormac McCarthy</rdamd:P30117>
      <rdamd:P30107>1st Vintage International ed</rdamd:P30107>
      <rdamd:P30088>New York</rdamd:P30088>
      <rdamd:P30111>New York : Vintage International, c2008</rdamd:P30111>
      <rdamd:P30083>Vintage International</rdamd:P30083>
      <rdamd:P30011>c2008</rdamd:P30011>
      <rdamd:P30182>287 p., 21 cm.</rdamd:P30182>
      <rdamd:P30001 rdf:resource="http://rdaregistry.info/termList/RDACarrierType/1049"/>
      <rdamd:P30002 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1007"/>
      <rdamo:P30139 rdf:resource="http://viaf.org/viaf/220031159/exp/eng/1020"/>
   </rdac:C10007>
   <rdac:C10007 rdf:about="http://example.org/isbn-9781447245834">
      <rdamd:P30004>ISBN 9781447245834 (ePub ebook)</rdamd:P30004>
      <rdaxd:P00018>isbn-9781447245834</rdaxd:P00018>
      <rdfs:label>ISBN9781447245834 (ePub ebook)</rdfs:label>
      <rdamd:P30156>The passenger</rdamd:P30156>
      <rdamd:P30117>Cormac McCarthy</rdamd:P30117>
      <rdamd:P30088>London</rdamd:P30088>
      <rdamd:P30111>London : Picador, 2022</rdamd:P30111>
      <rdamd:P30083>Picador</rdamd:P30083>
      <rdamd:P30011>2022</rdamd:P30011>
      <rdamd:P30182>1 online resource.</rdamd:P30182>
      <rdamd:P30001 rdf:resource="http://rdaregistry.info/termList/RDACarrierType/1018"/>
      <rdamd:P30002 rdf:resource="http://rdaregistry.info/termList/RDAMediaType/1003"/>
      <rdamo:P30139 rdf:resource="http://viaf.org/viaf/470166838899836200007/exp/eng/1020"/>
   </rdac:C10007>
   <skos:Concept rdf:about="http://id.loc.gov/vocabulary/iso639-2/eng">
      <rdfs:label>eng</rdfs:label>
   </skos:Concept>
   <skos:Concept rdf:about="http://rdaregistry.info/termList/RDACarrierType/1018">
      <skos:subjectIndicator>http://rdaregistry.info/termList/RDACarrierType/1018</skos:subjectIndicator>
   </skos:Concept>
   <skos:Concept rdf:about="http://rdaregistry.info/termList/RDACarrierType/1049">
      <skos:subjectIndicator>http://rdaregistry.info/termList/RDACarrierType/1049</skos:subjectIndicator>
   </skos:Concept>
   <skos:Concept rdf:about="http://rdaregistry.info/termList/RDAContentType/1020">
      <skos:subjectIndicator>http://rdaregistry.info/termList/RDAContentType/1020</skos:subjectIndicator>
   </skos:Concept>
   <skos:Concept rdf:about="http://rdaregistry.info/termList/RDAMediaType/1003">
      <skos:subjectIndicator>http://rdaregistry.info/termList/RDAMediaType/1003</skos:subjectIndicator>
   </skos:Concept>
   <skos:Concept rdf:about="http://rdaregistry.info/termList/RDAMediaType/1007">
      <skos:subjectIndicator>http://rdaregistry.info/termList/RDAMediaType/1007</skos:subjectIndicator>
   </skos:Concept>
</rdf:RDF>
```

An example rule set and example data file is found in the example directory. Simple scripts are provided for running the generation of the transformation xslt and the final transformation
