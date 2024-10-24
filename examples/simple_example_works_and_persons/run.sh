#!/bin/sh

echo "Creating xslt conversion"
java -cp "SaxonHE12-5J/saxon-he-12.5.jar"  net.sf.saxon.Transform -xsl:"../../xslt/make.xslt" -s:"rules/conversionrules.xml" -o:"xslt/marc2rda.xslt" 

echo "Running transformation of local files in directory"
java -cp "SaxonHE12-5J/saxon-he-12.5.jar" net.sf.saxon.Transform -xsl:"xslt/marc2rda.xslt" -s:"input/example.xml" -o:"output/example.rdf"

