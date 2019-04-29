#!/bin/sh

echo "Creating xslt conversion"
java -cp "../jar/saxon/saxon9he.jar"  net.sf.saxon.Transform -xsl:"../xslt/make.xslt" -s:"rules/colis-lrm-rules.xml" -o:"xslt/colis-marc2lrm.xslt" 
java -cp "../jar/saxon/saxon9he.jar"  net.sf.saxon.Transform -xsl:"../xslt/make.xslt" -s:"rules/colis-bibframe-rules.xml" -o:"xslt/colis-marc2bibframe.xslt" 



echo "Running transformation of local files in directory"
java -cp "../jar/saxon/saxon9he.jar" net.sf.saxon.Transform -xsl:"xslt/colis-marc2lrm.xslt" -s:"input" -o:"output-lrm" merge=true rdf=true
java -cp "../jar/saxon/saxon9he.jar" net.sf.saxon.Transform -xsl:"xslt/colis-marc2bibframe.xslt" -s:"input" -o:"output-bibframe" merge=true rdf=true

