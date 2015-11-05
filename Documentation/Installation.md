Setup of the Sensor Data Ware House
===================================

Download a pdf version of this document [here](https://gitprint.com/Eawag-DataWareHouse/SDWH/blob/master/Documentation/Installation.md).

This document explains  how to install the required software packages

* Sun java Runtime Environment (JRE) version 1.5 or newer

* Panthao Data Intgration V 5.2 or newer

* Maria DB, V 15.1 or newer

* MySQL Workbench

* R to run the conversion scripts (alternatively Python, Julia, Matlab ... could be used)

and how to configure the data warehouse.

General information and the configuration files can be found on
 [github](https://github.com/Eawag-DataWareHouse/SDWH). Also some
 [example data](https://github.com/Eawag-DataWareHouse/SDWH-Landingzone) are
 available.


System requirements
===================================

The Linux operating system *Ubuntu* is required for Pentaho to work
properly. Preferable use the latest LTS version.



Installations
===================================

Pentaho
-----------

*Source:* [http://wiki.pentaho.com/display/EAI/01.+Installing+Kettle]

Installation:

1. Update the package index :
`sudo apt-get update`

2. Install Sun java Runtime Environment (JRE) version 1.5 or newer:
`sudo apt-get install default-jre`

3. Download Pentaho Data Integration version >5.2: [http://sourceforge.net/projects/pentaho/files/Data%20Integration/](http://sourceforge.net/projects/pentaho/files/Data%20Integration/)

4. extract it in directory: `/home/datalab/` and move to that directory using `cd ~/home/datalab/data_integration`

5. make all shell scripts executable by: `chmod +x *.sh`

6. download the connector "mysql-connector-java-5.1.35.tar.gz" from
[http://dev.mysql.com/downloads/connector/j/](http://dev.mysql.com/downloads/connector/j/)

7. unpack it and copy the `*.jar` file to `/home/datalab/data-integration/lib`

8. Increase the amount of RAM Pentaho is alowed to use: edit the
variable `PENTAHO_DI_JAVA_OPTIONS` in the file `/home/datalab/data-integration/spoon.sh`. Precisely change the number ("#") after `-XX : MaxPermSize = #m


MariaDB
-----------

*Source:* [http://lintut.com/install-mariadb-in-ubuntu-linux/]

1. Add apt key:
```
sudo apt-get install python-software-properties
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
```
2. Add the repository for Ubuntu version 14.04
```
sudo add-apt-repository 'deb http://mirror.klaus-uwe.me/mariadb/repo/5.5/ubuntu trusty main'
```

3. Install MariaDB
```
sudo apt-get update 
sudo apt-get install mariadb-server
```

**Note**: the above installer will prompt for a MariaDB password for the "root" account.



MySQL Workbench
-----------

MySQL Workbench is a graphical user interface to manage databases.
Installation:
```
sudo apt-get install mysql-client-5.5
sudo apt-get install mysql-workbench
sudo apt-get install mysql-server
```

R
-----------

*Source:* [http://cran.r-project.org/bin/linux/ubuntu/]

1. Add repositories with the latest R packages:
Add to the file `/etc/apt/sources.list` the line
```
deb http://<my.favorite.cran.mirror>/bin/linux/ubuntu trusty/
```
replacing
`<my.favorite.cran.mirror>` by the actual URL of your favorite CRAN
mirror. See [here](http://cran.r-project.org/mirrors.html) for the list of
CRAN mirrors. Example: `deb http://stat.ethz.ch/CRAN/bin/linux/ubuntu
trusty/`

2. add key:
```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
```
3. To install the R
```
sudo apt-get update
sudo apt-get install r-base r-base-dev
```

### Install rgdal package
You need to install all the R packages you use in your conversion scripts. 

(Remark) Usually this works as follows:
```
sudo R
```
then use
```
install.packages("package name")
```
within R

In our case, to read the radar images you need the "rgdal" package which is tricky to install under ubuntu. Here is a way that worked:
```
sudo apt-get install aptitude      # install aptitude as an alternative to apt-get
sudo aptitude install libgdal-dev  # install the package (you will be asked
                                   # if you accept a recomended solution, say yes)
sudo aptitude install libproj-dev  # install the proj.4 projection library
sudo aptitude install libgdal1-dev # install the package (you will be asked
                                   # if you accept a recomended solution, say no for
                                   # the first solution and yes for the second)
```
After this try
```
install.packages("rgdal")
```
within R

Download configuration files
===================================

All configuration files and some example data are stored on gitHub:
[https://github.com/Eawag-DataWareHouse/SDWH](https://github.com/Eawag-DataWareHouse/SDWH)

If necessary install git first:
```
sudo apt-get install git
```

Clone (download) the files from GitHub (first move to the directory where SDWH will be imported):
```
git clone https://github.com/Eawag-DataWareHouse/SDWH.git
```
This creates a directory SDWH to which is referred below.

Give rights to execute all shell scripts:
```
cd SDWH
chmod +x $(find -name "*.sh")
```



Initial Configuration
===================================

This section describes how to create the empty databases and how to
configure Pentaho. The DWH requires three components to be set up and
linked correctly:

1. two databases, called `WaterResearch` and `temp`.

2. a "DI Repository" that holds the the configuration files of Pentaho
and shell scripts

3. a landing zone, that is a directory with a specific structure


Create databases
-----------

### Start MariaDB service
```
sudo service mysql start
```
Note: The  MySQL command line interface can be entered via: `mysql -u root -p`

### Create databases

Execute the following sql scripts from shell:
```
mysql -u root -p < ~/SDWH/PentahoConfiguration/SQLqueries/tempCreateStatement.sql
mysql -u root -p < ~/SDWH/PentahoConfiguration/SQLqueries/CreateStatement.sql
```

Then open MySQL workbench and create a new connection:
![Connection](images/newconnection.jpg?raw=true)


Create a DI Repository
-----------

We have to tell Pentaho where the configuration files are stored (a so
called DI Repository which stands for data integration).

Start Pentaho (Spoon):
```
~/datalab/data-integration/spoon.sh
```

In Pentaho (Spoon):

1. Click on **Tools** > **Repository** > **Connect**. The **Repository Connection** dialog box appears.

2. In the **Repository Connection** dialog box, click the add button (+).

3. Select **Kettle file repository** and click **OK**. The** Repository Configuration** dialog box appears.

4. Enter the path to `SDWH/PentahoConfiguration/`, i.e. where the
Pentaho files are stored. Give it a descriptive name such as "PentahoFiles". Modify the
variable `PentahoRep` in `SDWH/PentahoConfiguration/shellScripts/runAllTransformationAndJobs.sh` accordingly.

5. Go to **Tools **> **Options**. The kettle options will appear then
check the **show repository dialog at startup?** box.

6. restart Pentaho.

Connecting Pentaho to MariaDB
-----------

The connection is setup automatically. However, you have to change the Password used for mariaDB.

1. go to the tab **View** -> **Transformations** -> **Database connections** -> **MariaDBConnect**
-> **rightclick** -> **edit and add**:

	**User Name**: root

	**Password**: (MariaD Password)

2. go to the tab **View** -> **Transformations** -> **Database connections** -> **tempDatabaseConnection**
-> **rightclick** -> **edit and add**:

	**User Name**: root

	**Password**: (MariaDB Password)

Use the test button at the bottom of the dialogue box to confirm a correct
connection.


Create landingzone
-----------

The landingzone in a directory with special structure as described in
the [user manual](UserDocumentation.md). Alternatively
 git
repository can be cloned to obtain a Landingzone containing some
example data:

```git clone https://github.com/Eawag-DataWareHouse/SDWH-Landingzone.git```


Adapt paths
-----------

Edit the paths in the shell script
`SDWH/PentahoConfiguration/shellScripts/runAllTransformationsAndJobs.sh`; the
paths for the *landingzone*, the *pentaho repository *and the *log
files* must be defined.

Open the file
`~/SDWH/PentahoConfiguration/transformations/JoinDataMetadatafile.ktr`
in Pentaho (spoon). Right click on the box names *Join Rows (cartesian
product)* > *edit step* and modify the *Temp directory*.

Set up cron jobs
-----------

open crontab file with
```
crontab -e
```
add the following at the end of the file (Warning don't write the following line without replacing the "`*`"):
```
* * * * * ~/SDWH/PentahoConfiguration/shellScripts/runAllTransformationAndJobs.sh
```
where \* are replaced by \* minute (from 0 to 59) \* hour (from 0 to 23)
\* day of month (from 1 to 31) * month (from 1 to 12) \* day of week
(from 0 to 6) (0=Sunday) The meaning of the stars is to run the script
every minute, every hour, every day, every month and all day of the
week.  Example: run the shell script every 30 minutes:
```
30 * * * * ~/SDWH/PentahoConfiguration/shellScripts/runAllTransformationAndJobs.sh
```
For more options see [https://help.ubuntu.com/community/CronHowto].


Relaunch DWH
===================================

After a restart of the server the following steps are required to
(re)launch the DWH.

Start MariaDB service: `sudo service mysql start`
