# marc2entities

marc2entitiers is a tool for performing interpretations and conversion of bibliographic MARC records in XML to new entity-centric models such as FRBR or BIBFRAME. The tools is intended for experimental conversions and it's strong feature is the use of highly customizable rules that allows the tool to be adapted to different catalogues, output models and formats.

1. Create a rule file in xml
1. Use an XSLT processor and run make.xslt on the rules file to create a an XSLT file for the actual conversions
1. Transform one or more MARC record collections (XML files) using the created XSLT conversion file

The tool should use the last version of Saxon, but may work well with versions > 8.

An example of the rule file can be found in the examples diretory. The format is rather simple, but since some selections and conditions make use of xpath-expressions and userdefined xpath-funtions, the overall rules can be rather intricate and complex.
```
       <entity tag="240" code="1" code-condition="starts-with(., 'http')" type="http://rdaregistry.info/Elements/c/C10001" templatename="MARC21-130240-Work">

    <!-- each entity identifies a specific type of entity at a specific tag or tag + code in the record with, it is possible to list tags or codes using comma separated list, and use conditions-->
    <!-- @type is the URI type the entityshould be given, @templatename has to be a unique string identifying this rule -->
      
        <!-- attributes is a listing of datafields and subfields that will be mapped/included for this entity -->
        <!-- @select is only needed if the data element has to be processed - such as removing hardcoded ISBD separators -->
        <attributes>  
            <datafield tag="240">
                <subfield code="a" type="http://rdaregistry.info/Elements/w/datatype/P10088"/>
                 <subfield code="f" type="http://rdaregistry.info/Elements/w/datatype/P10219"/>
                <subfield code="n" type="http://rdaregistry.info/Elements/w/datatype/P10012"/>
            </datafield>
        </attributes>        
        
        <!-- identifier is used for an xpath to select what should be used as identifier, the system is mainly intended for hard-coded identifiers but also supports automatically generating identifiers from the content -->        
        <!-- since we are iterating over subfield 1 in this case, we can just use . to select -->
        <!-- see example rules for how to construct identifiers, this is permed on the generated rdf entity and rules should be based on this -->        
        <identifier>.</identifier>
        
        <!-- Describing how this entity relates to other entities identified in the same record -->
        <!-- Type of the relationship can be statically coded or retrieved from the data, in this case the person template iterates over $4 and  we use a condition to select only persons relating to the work based on the vocabulary used-->        
        <relationships>
           <relationship type="{$target_subfield}">
                <target entity="MARC21-100700Person" condition="starts-with($target_subfield, 'http://rdaregistry.info/Elements/w/')" />
            </relationship>
        </relationships>
    </entity>
```

The result is in RDF and the result is deduplicated by merking entities with the same URI and removing duplicate properties. 
```
   <rdac:C10001 rdf:about="http://viaf.org/viaf/6694158070654408780004">
      <rdfs:label>Onkel, Onkel (Grass, Günter)</rdfs:label>
      <rdawd:P10088>Onkel, Onkel</rdawd:P10088>
      <rdaxd:P00018>http://viaf.org/viaf/6694158070654408780004</rdaxd:P00018>
      <rdawo:P10061 rdf:resource="http://viaf.org/viaf/102319859"/>
      <rdawd:P10004 rdf:resource="https://schema.nb.no/Bibliographic/Values/V1000"/>
   </rdac:C10001>
```

An example rule set and example data file is found in the example directory. Use the run.sh script to run the example (bash script that works on linux and mac, but needs to be adapted if you are using Windows terminal).
