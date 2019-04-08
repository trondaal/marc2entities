#!/bin/sh
export  CLASSPATH="../jar/saxon/saxon9he.jar"


echo "Creating xslt conversion"
java net.sf.saxon.Transform -xsl:"../xslt/make.xslt" -s:"rules/example-rules.xml" -o:"xslt/marc2rda.xslt" 


echo "Running transformation of local files in directory"
java net.sf.saxon.Transform -xsl:"xslt/marc2rda.xslt" -s:"input/examples.xml" -o:"output/examples.rdf" merge=true rdf=true

