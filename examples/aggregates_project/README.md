The input files in this example are records demonstrating works with parts and aggregates.
Records are elaborated with VIAF identifier for work and persons, and RDA registry URIs for person relationship.
Some tweaks have been made to the data: 
Analytical entries are used to identify parts, and using ind1 to signal if the collection as a whole is a work or not (value = 0 if it is a work)
Linking subfields ($8) is used to connect persons to correct work or expression.

The URIs for expressions are scripted as a concatenation of wok-uri along with language code and content type code.

