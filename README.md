# marc2frbr

marc2frbr is a tool for performing interpretations and conversion of bibliographic MARC records in XML to new entity-centric models such as FRBR or BIBFRAME. The tools is intended for experimental conversions and it's strong feature is the use of highly customizable rules that allows the tool to be adapted to different catalogues, output models and formats.

1. Create a rule file in xml
1. Use an XSLT processor and run make.xslt on the rules file to create a an XSLT file for the actual conversions
1. Transform one or more MARC record collections (XML files) using the created XSLT conversion file

The tool is tested with Saxon 9, but makes use of some XSLT 3.0 features and you should use the last version of Saxon.

An example of the rule file can be found in the examples diretory. The format is rather simple, but since some selections and conditions make use of xpath-expressions and userdefined xpath-funtions, the overall rules can be rather intricate and complex.
```
    <!-- Main entry work -->
    <entity tag="130, 240" condition="*:subfield/@code = '1'" code="1" code-condition="starts-with(., 'http')"
            type="http://rdaregistry.info/Elements/c/C10001" templatename="MARC21-130240-Work" label="Work">
            <!-- What fields and subfields to iterate over and conditions for determining if a work entity should be created, type of entity to create -->
            <!-- We can process 130 and 240 in the same way, but differ in attributes and relationshhips -->
        <attributes>
            <datafield tag="130"  condition=". eq $this_field">
                <!-- What attributes to extract and what type they should be assigned -->
                <subfield code="a" type="http://www.w3.org/2000/01/rdf-schema#label" select="frbrizer:trim(.)"/>
                <subfield code="a" type="http://rdaregistry.info/Elements/w/datatype/P10088"
                    select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                <subfield code="f" type="http://rdaregistry.info/Elements/w/datatype/P10219" label="has date of work"/>
                <subfield code="n" type="http://rdaregistry.info/Elements/w/datatype/P10012"/>
                <subfield code="1" type="http://rdaregistry.info/Elements/x/datatype/P00018"/>
                <subfield code="k" type="http://rdaregistry.info/Elements/x/datatype/P00029"/>
            </datafield>
            <datafield tag="240"  condition=". eq $this_field">
                <subfield code="a" type="http://www.w3.org/2000/01/rdf-schema#label"
                        select="frbrizer:trim(.) || (if ($record/*:datafield[@tag='100']) then ' (' || $record/*:datafield[@tag='100']/*:subfield[@code='a']/replace(., '[\s,/:=]+$', '') || ')' else () )" />
                <subfield code="a" type="http://rdaregistry.info/Elements/w/datatype/P10088"
                        select="string-join((frbrizer:trim(.), frbrizer:trim(../*:subfield[@code = 'p'])), ' : ')"/>
                <subfield code="f" type="http://rdaregistry.info/Elements/w/datatype/P10219"/>
                <subfield code="n" type="http://rdaregistry.info/Elements/w/datatype/P10012"/>
                <subfield code="1" type="http://rdaregistry.info/Elements/x/datatype/P00018"/>
                <subfield code="k" type="http://rdaregistry.info/Elements/x/datatype/P00029"/>
            </datafield>
            <datafield tag="520">
                <subfield code="a" type="http://rdaregistry.info/Elements/w/datatype/P10330" label="note"/>
            </datafield>
        </attributes>
        <key order="1">
            <!-- What to use as key and finally identifier for the entity -->
            <element>frbrizer:trim(*:datafield[@tag=('130', '240')]/*:subfield[@code='1'][starts-with(., 'http')][last()])</element>
        </key>
        <relationships>
        <!-- Relationships are defined by a type, and the entity template that creates the entities it should point to (from the same record) -->
            <relationship type="{$target_subfield}">
                <target entity="MARC21-100700Person" type="http://rdaregistry.info/Elements/c/C10002"
                        condition="starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/')  and frbrizer:linked($anchor_field, $target_field, false())" />
            </relationship>
            <relationship type="http://rdaregistry.info/Elements/w/object/P10319" >
                <target entity="MARC21-600-Person"
                        condition="not($target_field/*:subfield/@code = 't') and frbrizer:linked($anchor_field, $target_field, false())" type="http://rdaregistry.info/Elements/c/C10002"/>
            </relationship>
            <relationship type="http://rdaregistry.info/Elements/w/object/P10257">
                <target entity="MARC21-6XX-Work"
                        condition = "not($this_field/*:subfield/@code = '1') or not($this_field/*:subfield[@code = '1'] = $target_field/*:subfield[@code = '1'])
                                    and frbrizer:linked($anchor_field, $target_field, false())"
                        type="http://rdaregistry.info/Elements/c/C10001"/>
            </relationship>
            <relationship type="{$target_subfield}">
                <target entity="MARC21-700-Related-Work" type="http://rdaregistry.info/Elements/c/C10001"
                        condition="starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/') and frbrizer:linked($anchor_field, $target_field, false())"/>
            </relationship>
            <!-- hack: using ind1 i data with value > 0 to indicate that a part of relationship is to be created for added analytical entries -->
            <relationship type="http://rdaregistry.info/Elements/w/object/P10147" condition="$this_field/@ind1 != '0'" label="part of work">
                <target entity="MARC21-700-Work-Analytical" type="http://rdaregistry.info/Elements/c/C10001"/>
            </relationship>
            <relationship type="{$target_subfield}">
                <target entity="MARC21-758-Related-Work" type="http://rdaregistry.info/Elements/c/C10001"
                        condition="starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/') and frbrizer:linked($anchor_field, $target_field, false())"/>
            </relationship>
            <relationship type="http://rdaregistry.info/Elements/w/object/P10019" label="part of work">
                <target entity="MARC21-8XX-Work-Series" type="http://rdaregistry.info/Elements/c/C10001"/>
            </relationship>
        </relationships>
    </entity>
```

The tool uses an intermediary format in the transformation, with each created entity as a separat MARC XML record. This format is based on the intial structure of records, datafields and subfields, enhanced with relationships and semantic typing according to the intended output.


The intermediary format can directly be translated into RDF (supported by the tool). Keys are used to uniquely identify each entity for merging and deduplication purposes. See sample code in rdf.xslt for transforming keys to uuid hashing identifiers (requires licenced version of Saxon as it relies on extension function. 



An example rule set and example data file is found in the example directory. Use the run.sh script to run the example (bash script that works on linux and mac, but needs to be adapted if you are using Windows terminal).
