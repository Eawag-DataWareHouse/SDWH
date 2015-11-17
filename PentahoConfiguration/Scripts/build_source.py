#!/usr/bin/python

sourceName = raw_input('Enter a source name : ')
sourceTypeName = raw_input('Enter a source Type name : ')
sourceSerial = raw_input('Enter a serial : ')
sourceDescr = raw_input('Enter a source desciption : ')
sourceLengthX = raw_input('Enter the X-length : ')
sourceLengthY = raw_input('Enter the Y-length : ')
sourceAngle = raw_input('Is there an angle : ')
sourceTime = raw_input('Is there a time :')

 
meta_file = open("source_metadata.xml",'w')

meta_file.write("<sourceMetadata> \n")
meta_file.write("\t<sourceName>{}</sourceName> \n".format(sourceName) )
meta_file.write("\t<sourceTypeName>{}</sourceTypeName> \n".format(sourceTypeName) )
meta_file.write("\t<serial>{}</serial> \n".format(sourceSerial) )
meta_file.write("\t<sourceDescription>{}</SourceDescription> \n\n".format(sourceDescr) )
meta_file.write("\t<integration>\n")
meta_file.write("\t\t<lengthX>{}</lengthX> \n".format(sourceLengthX) )
meta_file.write("\t\t<lengthY>{}</lengthY> \n".format(sourceLengthY) )
meta_file.write("\t\t<angle>{}</angle> \n".format(sourceAngle) )
meta_file.write("\t\t<time>{}</time> \n".format(sourceTime) )
meta_file.write("\t</integration>\n")

meta_file.write("</sourceMetadata> \n")


meta_file.close()




