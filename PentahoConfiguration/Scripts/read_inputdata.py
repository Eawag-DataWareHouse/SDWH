#!/usr/bin/python
###############################################################################################
# If you are working with the swiss coordinate system ' coord_syst = "CH1903" ' ,             #
#  in this case for coordinates in the form (x,y,z), all coordinates are positive             #
#  and x > y                                                                                  #
#  Remark : the convention in the CH1903 is (E,N)=(y,x) with E>N (the origin is in Bordeaux)  #
# To run the code use the syntax : python read_inputdata.py data_file.txt > error_log.txt     #
###############################################################################################


### Change this variable if needed ###
coord_syst = "CH1903"



import sys

# print ('Number of arguments:', len(sys.argv), 'arguments.')
# print ('Argument List:', str(sys.argv))


i = 0
j = 0
error_lines = [] # line where there is an error
error_message = [] # what kind of error
string_tmp = "" # used to build the error message
import re # regular expression

with open(sys.argv[1],'r') as f:

    for line in f:
        i += 1
        j = 0

        if i>1: #we exclude the first line
            tmp_line = line.split(";") #split the columns for each line in the loop
            #DATE check
            if re.findall(r"^(19|20)\d\d[- /.](0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[ /.]([01]?[0-9]|2[0-3])[: /.]([0-5][0-9])[: /.]([0-5][0-9])$",tmp_line[0]):
                j += 0
            else:
                j += 1
                error_message.append(" Error in date ; ")

            # PARAMETER check
            if re.findall("^(?=.*[a-zA-Z]).{1,100}$",tmp_line[1]):
                j +=0
            else:
                j +=1
                error_message.append(" Error in Parameter ; ")


            #VALUE check
            try:
                float(tmp_line[2])
            except :
                j += 1
                error_message.append(" Error in Value ; ")

            #COORDINATE check
            if coord_syst == "CH1903":
                try :
                    float(tmp_line[4])
                    float(tmp_line[5])
                    if ((float(tmp_line[4]) < 0) or (float(tmp_line[5]) < 0) or (float(tmp_line[4]) < float(tmp_line[5]))):
                     j += 1
                     error_message.append(" Error in Coordinate ; ")

                except:
                    j +=1
                    error_message.append(" Error in Cooordinate ; ")



        # If there is an error we keep the line and the error type
        if j>0:

            string_tmp = str(i)
            for k in error_message:
                string_tmp += k
            error_lines.append("Line "+string_tmp)
            string_tmp = ""
            error_message = []

# if there is at least one problem we print it (otherwise nothing happens)
if len(error_lines)>0:
    #print("Error(s) in file : "+str(sys.argv[1]))
    for item in error_lines:
        print(item)
    print("\n")
