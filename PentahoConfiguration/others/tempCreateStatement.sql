delimiter $$

CREATE DATABASE `temp` /*!40100 DEFAULT CHARACTER SET latin1 */$$

USE temp

delimiter $$

CREATE TABLE `Temp` (
  `deviceTypeId` int(11) DEFAULT NULL,
  `deviceTypeName` tinytext,
  `deviceTypeDescription` tinytext,
  `parameterName` tinytext,
  `parameterUnit` tinytext,
  `parameterDescription` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `TempDataMetadata` (
  `Timestamp` datetime DEFAULT NULL,
  `Parameter` varchar(100) DEFAULT NULL,
  `Value` bigint(20) DEFAULT NULL,
  `Goup_ID` int(11) DEFAULT NULL,
  `X` bigint(20) DEFAULT NULL,
  `Y` bigint(20) DEFAULT NULL,
  `Z` double DEFAULT NULL,
  `updateDate` tinytext,
  `sourceId` tinytext,
  `sourceTypeId` tinytext,
  `serial` tinytext,
  `sourceDescription` tinytext,
  `pathToRScript` tinytext,
  `lengthX` double DEFAULT NULL,
  `lengthY` double DEFAULT NULL,
  `angle` double DEFAULT NULL,
  `time` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `TempDateTime` (
  `Timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `TempDevice` (
  `sourceTypeId` int(11) DEFAULT NULL,
  `Serial` tinytext,
  `sourceDescription` tinytext,
  `coordX` int(11) DEFAULT NULL,
  `coordY` int(11) DEFAULT NULL,
  `coordZ` tinytext,
  `lengthX` double DEFAULT NULL,
  `lengthY` tinytext,
  `angle` double DEFAULT NULL,
  `timestamp` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `sample` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `tempSequenceIDGenerator` (
  `Goup_ID` int(11) DEFAULT NULL,
  `sourceId` varchar(255) DEFAULT NULL,
  `sourceTypeId` varchar(255) DEFAULT NULL,
  `Source_ID` varchar(100) DEFAULT NULL,
  `Coordinates_ID` int(11) DEFAULT NULL,
  `Integration_ID` int(11) DEFAULT NULL,
  `ParameterID` int(11) DEFAULT NULL,
  `DateTime_ID` int(11) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `tempSignal` (
  `Value` bigint(20) DEFAULT NULL,
  `Source_ID` varchar(200) DEFAULT NULL,
  `Coordinates_ID` int(11) DEFAULT NULL,
  `Integration_ID` int(11) DEFAULT NULL,
  `ParameterID` int(11) DEFAULT NULL,
  `DateTime_ID` int(11) DEFAULT NULL,
  `Group_ID` int(11) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


delimiter $$

CREATE TABLE `tempSignalHasDateTime` (
  `DateTime_ID` int(11) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$


