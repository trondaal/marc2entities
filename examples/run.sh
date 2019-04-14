#!/bin/sh

echo "Creating xslt conversion"
java -cp "../jar/saxon/saxon9he.jar"  net.sf.saxon.Transform -xsl:"../xslt/make.xslt" -s:"rules/example-rules.xml" -o:"xslt/marc2rda.xslt" 


echo "Running transformation of local files in directory"
java -cp "../jar/saxon/saxon9he.jar" net.sf.saxon.Transform -xsl:"xslt/marc2rda.xslt" -s:"input/examples.xml" -o:"output/examples.rdf" merge=true rdf=false

