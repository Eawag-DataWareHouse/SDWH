#!/usr/bin/python

sourceName = raw_input('Enter a source Type name : ')
sourceDescr = raw_input('Enter a source Type description : ')
 
meta_file = open("sourceType_metadata.xml",'w')

meta_file.write("<sourceTypeMetadata> \n")
meta_file.write("\t<sourceTypeName>{}</sourceTypeName> <!-- must be unique! --> \n".format(sourceName) )
meta_file.write("\t<sourceTypeDescription>{}</sourceTypeDescription> \n".format(sourceDescr) )
meta_file.write("</sourceTypeMetadata> \n")

meta_file.close()




