#!/usr/bin/python

siteName = raw_input('Enter a site name : ')
siteDescr = raw_input('Enter a site description : ')
siteStreet = raw_input('Enter a Street : ')
siteCity = raw_input('Enter a city : ')
siteCoordX = raw_input('Enter the X-coordinate : ')
siteCoordY = raw_input('Enter the Y-coordinate : ')
bool_z = raw_input('Is there a Z-coordinate ? (y/n)')
if bool_z == 'y' :
 siteCoordZ = raw_input('Enter the Z-coordinate : ')
else :
 siteCoordZ = ""
 
meta_file = open("MetaDataFile_test.xml",'w')

meta_file.write("<siteMetadata> \n")
meta_file.write("<siteName>{}</siteName> <!-- must be unique! --> \n".format(siteName) )
meta_file.write("<siteDescription>{}</siteDescription> \n".format(siteDescr) )
meta_file.write("<street>{}</street> \n".format(siteStreet) )
meta_file.write("<city>{}</city> \n".format(siteCity) )
meta_file.write("<coordinates>\n")
meta_file.write("<coordX>{}</coordX> <!-- all coordinates (x,y,z) must be *identical* to the one in the standardized file format -->\n".format(siteCoordX) )
meta_file.write("<coordY>{}</coordY> \n".format(siteCoordY) )
meta_file.write("<coordZ>{}</coordZ> \n".format(siteCoordZ) )
meta_file.write("</coordinates> \n")
meta_file.write("\n")
meta_file.write("</siteMetadata> \n")

meta_file.close()




