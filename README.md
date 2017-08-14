# marc2frbr

marc2frbr is a tool for performing interpretations and conversion of bibliographic MARC records in XML to new entity-centric models such as FRBR or BIBFRAME. The tools is intended for experimental conversions and it's strong feature is the use of highly customizable rules that allows the tool to be adapted to different catalogues, output models and formats.

1. Create a rule file in xml
1. Use an XSLT processor and run make.xslt on the rules file to create a an XSLT file for the actual conversions
1. Transform one or more MARC record collections (XML files) using the created XSLT conversion file

The tool is tested with Saxon 9, but makes use of some XSLT 3.0 features and you should use the last version of Saxon.

An example of the rule file can be found in the examples diretory. The format is rather simple, but since some selections and conditions make use of xpath-expressions and userdefined xpath-funtions, the overall rules can be rather intricate and complex.
```
    <entity type="c:Person" templatename="MARC21-100-Person">
    <!-- each entity identifies a specific type of entity at a specific tag in the record -->
    <!-- @type identifies the type of the entity, @templatename has to be a unique string identifying this rule -->
        <anchor tag="100"/>
        <!-- @tag is the tag that this rule is used for, one entity per occurence of the tag --> 
        <attributes>
        <!-- The fields that will be mapped/included for this entity -->
            <datafield tag="100">
                <subfield code="a" type="a:nameOfPerson" select="frbrizer:trim(.)"/>
                <subfield code="c" type="a:titleOfThePerson"  select="frbrizer:trim(.)"/>
                 <subfield code="d" type="a:dateAssociatedWithPerson" select="frbrizer:trim(.)"/>
                <subfield code="u" type="a:affiliation" select="frbrizer:trim(.)"/>
                <subfield code="0" type="a:identifierForAgent" select="frbrizer:trim(.)"/>
            </datafield>
        </attributes>
        <key order="1">
        <!-- The values that will be used to create a key for this entity -->
        <!-- Can be based on type-attributes, or tags and codes -->
            <element>*:datafield/*:subfield[@*:type= 'a:nameOfPerson']</element>
            <element>*:datafield/*:subfield[@*:type= 'a:titleOfPerson']</element>
            <element>*:datafield/*:subfield[@*:type= 'a:dateAssociatedWithPerson']</element>
        </key>
        <relationships>
        <!-- Describing how this entity relates to other entities identified in the same record -->
        <!-- In this example, we dynamically decide the type of the relationship using a function 
        that looks up the relator code. The list of targets identify what entities to set up relationships to.
        We are only relating to entities that actually have been created, and there is no need for further conditions. -->
            <relationship condition="frbrizer:isRelatorCodeToWork(*:subfield[@code = '4'])" 
            type="{frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], false())}" 
            itype="{frbrizer:relatorcode2rdatype($anchor_field/*:subfield[@code='4'], true())}">
                <target entity="MARC21-240-Work"/>
                <target entity="MARC21-245-Work"/>
                <target entity="MARC21-246-Work"/>
            </relationship>
        </relationships>
    </entity>
```

The tool uses an intermediary format in the transformation, with each created entity as a separat MARC XML record. This format is based on the intial structure of records, datafields and subfields, enhanced with relationships and semantic typing according to the intended output.

```
<record xmlns:frbrizer="http://idi.ntnu.no/frbrizer/"
         xmlns:xs="http://www.w3.org/2001/XMLSchema"
         id="{cperson=christieagatha;18901976}"
         type="c:Person"
         templatename="MARC21-100-Person">
    <datafield tag="100" ind1="1" ind2=" ">
       <subfield code="a" type="a:nameOfPerson">Christie, Agatha</subfield>
       <subfield code="d" type="a:dateAssociatedWithPerson">1890-1976</subfield>
    </datafield>
    <frbrizer:relationship type="a:authorOf" href="{cwork={cperson=christieagatha;18901976};themaninthebrownsuit}"/>
 </record>
```

The intermediary format can directly be translated into RDF (supported by the tool). Keys are used to uniquely identify each entity for merging and deduplication purposes. See sample code in rdf.xslt for transforming keys to uuid hashing identifiers (requires licenced version of Saxon as it relies on extension function. 

```
<rdf:Description rdf:about="cpersonchristieagatha18901976"
                  rdf:type="http://rdaregistry.info/Elements/c/Person">
    <a:nameOfPerson>Christie, Agatha</a:nameOfPerson>
    <a:authorOf rdf:resource="cworkcpersonchristieagatha18901976themaninthebrownsuit"/>
 </rdf:Description>
 <rdf:Description rdf:about="cworkcpersonchristieagatha18901976themaninthebrownsuit"
                  rdf:type="http://rdaregistry.info/Elements/c/Work">
    <w:titleOfWork>The man in the brown suit</w:titleOfWork>
    <w:author rdf:resource="cpersonchristieagatha18901976"/>
 </rdf:Description>
```

An example rule set and example data file is found in the example directory. Use the run.sh script to run the example (bash script that works on linux and mac, but needs to be adapted if you are using Windows terminal).
