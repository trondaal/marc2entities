#!/bin/sh
export  CLASSPATH="../jar/saxonhe/saxon9he.jar"


echo "Creating xslt conversion"
java net.sf.saxon.Transform -xsl:"../xslt/make.xslt" -s:"rules/example-rules.xml" -o:"xslt/example.conversion.xslt" 


echo "Running transformation of local files in directory"
java net.sf.saxon.Transform -xsl:"xslt/example.conversion.xslt" -s:"input/example-01.xml" -o:"output/example-01.rdf" merge=true rdf=true
