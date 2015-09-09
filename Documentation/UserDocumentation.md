Documentation Sensor Data Warehouse
===================================

Download a pdf version of this document [here](https://gitprint.com/Eawag-DataWareHouse/SDWH/blob/master/Documentation/UserDocumentation.md).

Introduction
============

xxxx.

[https://github.com/Eawag-DataWareHouse/SDWH](https://github.com/Eawag-DataWareHouse/SDWH)

System Architecture
===================

Data flow
---------

The overall system architecture is shown Figure 1.

Figure 1 : System Architecture

Different types of sources (usually sensors in the field) provide so
called raw files. The raw files are moved to the landing zone, a special
directory (see left part of Figure 1). Afterwards, these files are
converted into a standardized text file using an source specific script
and stored in a specific directory called data pool.

These text files are standardized in order to have the same file format
even though they contain different signals from various sources.

Next, the staging area pulls the data from the data pool and stores the
files in a database of the data warehouse. The process of extracting,
transforming and loading data into the staging area is called ETL
(extract, transform and load) that in turn is done by the tool Pentaho.
Pentaho can be considered as a workflow tool that allows doing typical
database operations such as joining, filtering or splitting tables in a
graphical way. Pentaho also allows calling scripts such as R-code from
different environments. The final stage of the data warehouse is called
data mart (see right part of Figure 1). The data mart is used for
querying the data. It may contain different database views to simplify
the access to the database by pre-joining existing database tables.

Data model
----------

The logical data model expressed as an entity relationship diagram is shown below
![Connection](images/DataModel.png?raw=true)

Landingzone
-----------

The landingzone directoy must have the structure shown in Figure 3. The
Directory `Landingzone` on GitHub provides a concrete example:
https://github.com/Eawag-DataWareHouse/SDWH

![Connection](images/Landingzone.png?raw=true)


Conversion of raw data
----------------------

The files arriving in the landing zone are called raw data. Every raw
data file must be converted in a so called Standardized file format by a
conversion script. Typically needs every source an individually adapted
conversion script.

### Standardized file format

The standardized file format for the input data is a csv file with seven
columns: `Timestamp`, `Parameter`, `Value`, `Group_ID`, `X`, `Y` and `Z`. The
`Group_ID` is used to group measurements with the same timestamp.
`Group_ID` should be a concatenated string . The columns `Group_ID` and
the coordinates must exist but may remain empty.

The values in the parameter column must be identical to the parameters
listed in `parameters.xml` file.

- File name: source name with `data_` as a prefix e.g.
`data_Flodar1.csv`.

- File format: csv file with semicolon delimited (`;`)

- Data format: `yyyy-mm-dd hh:mm:ss` (in range `'1000-01-01 00:00:00'` to
`'9999-12-31 23:59:59'`)

- Column names: The first column contains the header. The columns must
be in the following order: `Timestamp`, `Parameter`, `Value`, `Group_ID`,
`X`, `Y`, `Z`

- Missing values: an empty field in the file corresponds to an empty
values (do not write `NA` or similar).

- Value column: must contain numerical values. See below for
non-numerical values.

### Conversion script

The conversion script should read the raw data from
`/home/SDWH/Landingzone/newSourceType/newInstance/rawData` and write the
output (a standardized file) into
`/home/SDWH/Landingzone/newSourceType/newInstance/data`

Loading data
============

Assumptions
-----------

For this section we assume that SDWH is setup with the following
directories:

- Directory serving as landingzone: `/home/SDWH/Landingzone`
- Directory containing the Pentaho configuration files (DI
repository): `/home/SDWH/PentahoConfiguration/`
- Directory for log files: `/home/SDWH/Logs`

The following names are used for the examples in this documentation.

- Name of the sourceType = `newSourceType`
- Name of the sourceType instance = `newInstance`
- Name of the conversion script = `instance2Standard.r`



Add new source type
-------------------

1. Add a new directory of name newSourceType under
`/home/SDWH/Landingzone/newSourceType` Replace `newSourceType`
with the name of the new source file you want to add.

2. Under directory `/home/SDWH/Landingzone/newSourceType/` create a
file called `sourceType_metadata.xml` and insert the value for the
following parameters accordingly.
The user needs to take the responsibility for the uniqueness of the
sourceTypeId. The following example shows a description for a
weather radar data set. For other data sets, update the values in
bold accordingly.
```SQL
<sourceTypeMetadata>
  <!-- sourceTypeId a primary key and should never be changed -->
  <sourceTypeId>11111</sourceTypeId>
  <sourceTypeName>WR</sourceTypeName>
  <sourceTypeDescription>Meteo Swiss standard rain product. Contact
  person Herr. XXX , Technical
  details:PID=TZC,RADAR=ADL,REQ_RADAR=ADL,QUALITY=777,THR_QUAL=555,filter=0</sourceTypeDescription>
</sourceTypeMetadata>
```

_NOTES_

- The name of the file should always be `sourceType_metadata.xml`

- If the field does not have a value leave it empty

- Make sure that the sourceTypeID is unique. Check the column
SourceTypeID of the database table SourceType.


Add a new instance of a source type
-----------------------------------

1. Create the following three directories:
```
/home/SDWH/Landingzone/newSourceType/newInstance
/home/SDWH/Landingzone/newSourceType/newInstance/data
/home/SDWH/Landingzone/newSourceType/newInstance/rawData
```

2. Copy the conversion script to the directory
`/home/SDWH/Landingzone/newSourceType/newInstance/instance2Standard.r`

3. Create shell script file called `RunConversionScript.sh`
```
for i in \*.\${EXT};
     do
     Rscript instance2Standard.r ./rawData/$i
     done
```

4. Create a file called site_metadata.xml under
`/home/SDWH/Landingzone/newSourceType/newInstance/`.
Fill out the values for the site meta using the following file
structure. The following example shows a description for a SCAN data
set.
```XML
<siteMetadata>
  <sourceTypeName>UVvisSpectrometer</sourceTypeName>
  <name>scan01Dresden</name>
  <siteDescription>ms01Dresden</siteDescription>
  <street>Flensburger Straße</street>
  <city>Schacht 24G35, Mischsystem</city>
  <coordinates>
    <coordX>600000</coordX>
    <coordY>250030</coordY>
    <coordZ></coordZ>
  </coordinates>
  <picture id="one">
    <pathToThePicture>./rawData/24G35_regenwetter.jpg</pathToThePicture>
    <description>one</description>
    <date></date>
  </picture>
  <picture id="two">
    <pathToThePicture>./rawData/IMG_0312.JPG</pathToThePicture>
    <description>two</description>
    <date></date>
  </picture>
  <picture id="three">
    <pathToThePicture>./rawData/IMG_0732.JPG</pathToThePicture>
    <description>three</description>
    <date></date>
  </picture>
</siteMetadata>
```

5. Create a file called `source_metadata.xml` at
`/home/SDWH/Landingzone/newSourceType/newInstance/`


The following example shows the source meta data for SCAN data set. For
other data sets, update the values in bold accordingly.
```XML
<sourceMetadata>
  <sourceId>11280256_50_0x0100_spectro::lyser_INFLUENTV160</sourceId>
  <sourceTypeId>123</sourceTypeId>
  <serial>11280256</serial>
  <sourceDescription></sourceDescription>
  <pathToRScript></pathToRScript>
  <integration>
    <lengthX>2289.59254016954</lengthX>
    <lengthY></lengthY>
    <angle>0.549108420177344</angle>
    <time></time>
  </integration>
</sourceMetadata>
```

_NOTE_

If you have more than one instances, do the same for all the instances.
Make sure that the `sourceID` is unique. Check the column `SourceID` of the
database table Source.


Add a new parameter
-------------------

Create a file called `Parameters.xml` under `/home/SDWH/Landingzone/`,
if it doesn't exist. Example:
```XML
<parameters>
  <parameter>
    <!-- parameter-name has to be identically to the parameter from the std
	 format -->
    <parameterName>Absorbance 200.00</parameterName>
    <parameterUnit>m-1</parameterUnit>
    <parameterDescription>absorbance at 200.00 nm
    wavelength</parameterDescription>
  </parameter>
  <parameter>
    <!-- parameter-name has to be identically to the parameter from the std
	 format -->
    <parameterName>Absorbance 202.50</parameterName>
    <parameterUnit>m-1</parameterUnit>
    <parameterDescription>absorbance at 202.50 nm
    wavelength</parameterDescription>
  </parameter>
  <parameter>
    <!-- parameter-name has to be identically to the parameter from the std
	 format -->
    <parameterName>rain intensity</parameterName>
    <parameterUnit>mm/h</parameterUnit>
    <parameterDescription></parameterDescription>
  </parameter>
</parameters>
```
### Encode non-numerical measurements

1. Create a file called `valueDefinition.xml` under
`newSourceType/home/SDWH/Landingzone/newSourceType/valueDefinition.xml`

And then enter the values as follows
```XML
<valueDefinition>
  <definition id='NA'>
    <deviceTypeId>123</deviceTypeId>
    <name>NA</name>
    <value>-1</value>
  </definition>
  <definition id='Null'>
    <deviceTypeId>123</deviceTypeId>
    <name>Null</name>
    <value>-2</value>
  </definition>
</valueDefinition>
```

_NOTE_
Remember that you need to give a code for all the string
values you have in your data (assign a corresponding number value to a
string values in standard file format).


Add a comment or manual quality flag to signals
===============================================

Write a comment to one or more signal

1. Select `Signal_ID` for comment or DQ-check e.g. by range of date
```SQL
SELECT s.Signal_ID
FROM WaterResearch.factTable as s,
WaterResearch.DateTime as dt,
WaterResearch.signalHasDateTime as sdt,
WaterResearch.DateTimeGroup as dtg
WHERE s.signal_ID=sdt.signal_ID and dt.DateTime_ID=sdt.DateTime_ID
and
dt.date BETWEEN '2013-06-09 21:05:00' AND '2013-06-10 21:05:00';
```

2. Insert the comments or validation rules for the data quality
checks.

_Note_
This automatically generates new `DQ_ID every` time you insert
a new record. The value for column `Manual` should be `yes/no/comment`.


```SQL
INSERT INTO WaterResearch.DQ_Data (DQ_Description, Manual)
VALUES (
("The value is below 0", "yes"),
("The value is above 0", "no"),
("The values are modified for analysis purpose", "comment")
);
```

3. Get the DQ_ID for the comment or for the data quality checks
```SQL
SELECT dq.DQ_ID
FROM WaterResearch.DQ_Data as dq
WHERE dq.DQ_Description="The values are modified for analysis purpose";
```

4. Associate the `Signal_ID` with `DQ_ID` and insert it into
SignalHasQualityInfo table. Note: The timestamps will be added
automatically(could also be added manually). `QualityInfo_ID` which is
a unique identifier of this table will be automatically generated.
```SQL
INSERT INTO WaterResearch.SignalHasQualityInfo (signal_ID, DQ_ID,
DQ_Status)
VALUES (
(1,1, "not ok"),
(2,10, "ok"),
(100,1, "not ok"),
(22,10, "ok"),
(5,3, "comment"),
(200,3, "comment"),
(201,3, "comment"),
(202,3, "comment")
);
```

5. Add data quality comment. Select the `QualityInfo_ID` which you need
to comment and use it for the insert statement below. The timestamps
will be added automatically (could also be added manually).

```SQL
INSERT INTO WaterResearch.DQ_Comment(QualityInfo_ID,
DQCommentDescription)
VALUES (
(1, "DQ_comment one"),
(2, "DQ_comment two"),
(3, "DQ_comment three")
);
```


Extracting data
===============

The basic information to connect to the database:

- user name and password to log into the database
- server address/host name
- database port number: `3306 `(default for mysql)
- database name: `WaterResearch`

Connect from R
--------------

Example how to connect to the database from R:
```R
library(RMySQL)
# Create a database connection object.
mydb <- dbConnect(MySQL(), user='user', password='password', dbname=WaterResearch, host=localhost)
```

(On Ubuntu install RMySQL via: `sudo apt-get install r-cran-rmysql`)

Modify data in the database
===========================

The steps taken to manage the changes are:

​1. Apply your changes either in the metadata files or in the
standardized file.

​2. Before deleting and inserting the signal, select and look at the
data and make sure that the data you select is correct.

In the following example the data from date `2015-10-05 03:16:00` and from
the device instance of serial number `11280256` are used for
demonstration.

Note: Before running this query, create an index for the biggest table
to optimize the query time performance (I.e. for the `factTable`).

The general statement is as follows:
```
CREATE UNIQUE INDEX nameOfTheIndex ON indexedTableName(columnName);
```
This statement creates the index signalID for the column `Signal_ID` of
the table factTable
```SQL
CREATE UNIQUE INDEX signalID ON factTable(Signal_ID);
SELECT *
FROM
factTable as s,
DateTime as dt,
signalHasDateTime as sdt,
Source as src
WHERE
s.signal_ID=sdt.signal_ID and
dt.DateTime_ID=sdt.DateTime_ID and
dt.date='2015-10-05 03:16:00' and
s.Source_ID=src.Source_ID and src.Serial="11280256";

DELETE
FROM factTable as s
USING DateTime as dt
LEFT OUTER JOIN signalHasDateTime as sdt
LEFT OUTER JOIN Source as src
WHERE
s.signal_ID=sdt.signal_ID and
dt.DateTime_ID=sdt.DateTime_ID and
dt.date='0034-10-05 03:16:00' and
s.Source_ID=src.Source_ID and
src.Serial="11280256"
```

Note: It is also possible to use the between clause in the
where-statement

Example:
```
dt.date BETWEEN '0034-10-05 03:16:00' AND '0034-10-07 03:16:00'
```

3. Finally, run the shell script `runAllTransformationAndJobs.sh` or wait
for crontab to handle the execution of this script automatically.

Example SQL queries
===================

Give me the rain from Weather radar at coordinate(x,y) between time `t1`
and `t2`:
```SQL
SELECT *
FROM WaterResearch.factTable as s,
WaterResearch.DateTime as dt,
WaterResearch.signalHasDateTime as sdt,
WaterResearch.Source as src,
WaterResearch.Coordinates as coord
WHERE s.signal_ID=sdt.signal_ID and
dt.DateTime_ID=sdt.DateTime_ID and
s.Source_ID=src.Source_ID and
s.Coordinates_ID=coord.Coordinates_ID and
src.Serial="Weather Radar-123456" and
coord.Coord_X=600 and coord.Coord_Y=500 and
dt.Date BETWEEN '0034-10-05 03:16:00' AND '0035-10-05 03:16:00' ;
```

Give me all spectra from the SCAN probe measured at time `t`:
```SQL
SELECT *
FROM WaterResearch.factTable as s,
WaterResearch.DateTime as dt,
WaterResearch.signalHasDateTime as sdt,
WaterResearch.Source as src
WHERE s.signal_ID=sdt.signal_ID and
dt.DateTime_ID=sdt.DateTime_ID and
s.Source_ID=src.Source_ID and
src.Serial="11280256" and
dt.Date BETWEEN '0034-10-05 03:16:00' AND '0035-10-05 03:16:00';
```

Give me the 100 newest measurement of weather radar where
`10<xcoord<=20` and `33<ycoord<=40`:
```SQL
SELECT *
FROM WaterResearch.factTable as s,
WaterResearch.DateTime as dt,
WaterResearch.signalHasDateTime as sdt,
WaterResearch.Source as src,
WaterResearch.Coordinates as coord
WHERE s.signal_ID=sdt.signal_ID and
dt.DateTime_ID=sdt.DateTime_ID and
s.Source_ID=src.Source_ID and
s.Coordinates_ID=coord.Coordinates_ID and
src.Serial="Weather Radar-123456" and
coord.Coord_X BETWEEN 10 AND 20 and
coord.Coord_Y BETWEEN 33 AND 40
ORDER BY dt.Date DESC
LIMIT 100;
```

List all sites:
```SQL
SELECT  WaterResearch.Site;
```

Give me all sources for which measurements are available at Site `S`:

```SQL
SELECT src.Source_ID, src.SourceTypeID, src.Serial, src.Description
FROM WaterResearch.factTable as s,
WaterResearch.Source as src,
WaterResearch.Coordinates as coord,
WaterResearch.Site as site
WHERE s.Source_ID=src.Source_ID and
s.Coordinates_ID=coord.Coordinates_ID and
coord.Coordinates_ID=site.Coordinates_ID and
site.Name="scan01Dresden";
```

Give me all images from site `S`:

```SQL
SELECT pic.BLOBs
FROM WaterResearch.Picture AS pic and
WaterResearch.Site as site
WHERE pic.Site_ID=site.Site_ID;
```
