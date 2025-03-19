# marc2frbr

marc2frbr is a tool for performing interpretations and conversion of bibliographic MARC records in XML to new entity-centric models such as FRBR or BIBFRAME. The tools is intended for experimental conversions and it's strong feature is the use of highly customizable rules that allows the tool to be adapted to different catalogues, output models and formats.

1. Create a rule file in xml
1. Use an XSLT processor and run make.xslt on the rules file to create a an XSLT file for the actual conversions
1. Transform one or more MARC record collections (XML files) using the created XSLT conversion file

The tool is tested with Saxon 9, but makes use of some XSLT 3.0 features and you should use the last version of Saxon.

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


The intermediary format can directly be translated into RDF (supported by the tool). Keys are used to uniquely identify each entity for merging and deduplication purposes. See sample code in rdf.xslt for transforming keys to uuid hashing identifiers (requires licenced version of Saxon as it relies on extension function. 



An example rule set and example data file is found in the example directory. Use the run.sh script to run the example (bash script that works on linux and mac, but needs to be adapted if you are using Windows terminal).
