#!/bin/sh

echo "Creating xslt conversion"
java -cp "../jar/SaxonHE11-4j/saxon-he-11.4.jar"  net.sf.saxon.Transform -xsl:"../xslt/make.xslt" -s:"rules/rules.xml" -o:"xslt/marc2rda.xslt" 


echo "Running transformation of local files in directory"
java -cp "../jar/SaxonHE11-4j/saxon-he-11.4.jar" net.sf.saxon.Transform -xsl:"xslt/marc2rda.xslt" -s:"input/examples.xml" -o:"output/examples.rdf" merge=false rdf=false

