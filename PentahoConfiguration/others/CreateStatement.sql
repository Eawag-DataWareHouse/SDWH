delimiter $$

CREATE DATABASE `WaterResearch` /*!40100 DEFAULT CHARACTER SET latin1 */$$


delimiter $$

CREATE TABLE `Coordinates` (
  `Coordinates_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Coord_Y` double DEFAULT NULL,
  `Coord_X` double DEFAULT NULL,
  `Coord_Z` double DEFAULT NULL,
  PRIMARY KEY (`Coordinates_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2503 DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `DQ_Comment` (
  `Comment_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DQCommentDescription` varchar(100) DEFAULT NULL,
  `QualityInfo_ID` int(11) DEFAULT NULL,
  `DQCommentTimestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Comment_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `DQ_Data` (
  `DQ_ID` int(11) NOT NULL AUTO_INCREMENT,
  `DQ_Description` text,
  `Manual` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`DQ_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `DateTime` (
  `DateTime_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Date` datetime DEFAULT NULL,
  PRIMARY KEY (`DateTime_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2002 DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `DateTimeGroup` (
  `DateTime_ID` int(11) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL,
  `Group_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `Integration` (
  `Integration_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Length_x` double DEFAULT NULL,
  `Length_y` double DEFAULT NULL,
  `Angle` double DEFAULT NULL,
  `Time` date DEFAULT NULL,
  PRIMARY KEY (`Integration_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `Parameter` (
  `ParameterID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) DEFAULT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `Unit` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ParameterID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `Picture` (
  `Picture_ID` int(11) NOT NULL AUTO_INCREMENT,
  `BLOBs` longblob,
  `Date` datetime DEFAULT NULL,
  `Description` varchar(45) DEFAULT NULL,
  `Site_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`Picture_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `SignalHasQualityInfo` (
  `Signal_ID` int(11) DEFAULT NULL,
  `DQ_ID` int(11) DEFAULT NULL,
  `Timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `DQ_Status` varchar(45) DEFAULT NULL,
  `QualityInfo_ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`QualityInfo_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `Site` (
  `Site_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `Street` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `Description` varchar(100) DEFAULT NULL,
  `Coordinates_ID` int(11) DEFAULT NULL,
  PRIMARY KEY (`Site_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `Source` (
  `SourceTypeID` varchar(200) DEFAULT NULL,
  `Serial` varchar(100) DEFAULT NULL,
  `Description` varchar(500) DEFAULT NULL,
  `Source_ID` varchar(200) NOT NULL,
  `sur_key` int(11) NOT NULL,
  PRIMARY KEY (`Source_ID`,`sur_key`),
  KEY `idx_Device_lookup` (`SourceTypeID`,`Description`,`Serial`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `SourceType` (
  `SourceType_ID` varchar(200) NOT NULL,
  `Name` text,
  `Descritpion` text,
  PRIMARY KEY (`SourceType_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `ValueDefinition` (
  `SourceType_ID` int(11) DEFAULT NULL,
  `Code_ID` int(11) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `Value` int(11) DEFAULT NULL,
  PRIMARY KEY (`Code_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `factTable` (
  `Value` bigint(20) DEFAULT NULL,
  `Coordinates_ID` int(11) DEFAULT NULL,
  `Integration_ID` int(11) DEFAULT NULL,
  `Parameter_ID` int(11) DEFAULT NULL,
  `Source_ID` varchar(200) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL,
  UNIQUE KEY `signal_ID` (`Signal_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `signalHasDateTime` (
  `DateTime_ID` int(11) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE DATABASE `WaterResearch` /*!40100 DEFAULT CHARACTER SET latin1 */$$

