CREATE DATABASE `temp` /*!40100 DEFAULT CHARACTER SET latin1 */;

use temp

CREATE TABLE `sample` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `Temp` (
  `deviceTypeId` int(11) DEFAULT NULL,
  `deviceTypeName` tinytext,
  `deviceTypeDescription` tinytext,
  `parameterName` tinytext,
  `parameterUnit` tinytext,
  `parameterDescription` tinytext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `TempDataMetadata` (
  `Timestamp` datetime DEFAULT NULL,
  `Parameter` varchar(100) DEFAULT NULL,
  `Value` double DEFAULT NULL,
  `Goup_ID` int(11) DEFAULT NULL,
  `X` bigint(20) DEFAULT NULL,
  `Y` bigint(20) DEFAULT NULL,
  `Z` double DEFAULT NULL,
  `serial` tinytext,
  `sourceDescription` tinytext,
  `lengthX` double DEFAULT NULL,
  `lengthY` double DEFAULT NULL,
  `angle` double DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `sourceName` varchar(200) DEFAULT NULL,
  `sourceTypeName` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `TempDateTime` (
  `Timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tempSequenceIDGenerator` (
  `Goup_ID` int(11) DEFAULT NULL,
  `sourceId` varchar(255) DEFAULT NULL,
  `sourceTypeId` varchar(255) DEFAULT NULL,
  `Source_ID` int(11) DEFAULT NULL,
  `Coordinates_ID` int(11) DEFAULT NULL,
  `Integration_ID` int(11) DEFAULT NULL,
  `ParameterID` int(11) DEFAULT NULL,
  `DateTime_ID` int(11) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tempSignal` (
  `Value` double DEFAULT NULL,
  `Source_ID` int(11) DEFAULT NULL,
  `Coordinates_ID` int(11) DEFAULT NULL,
  `Integration_ID` int(11) DEFAULT NULL,
  `ParameterID` int(11) DEFAULT NULL,
  `DateTime_ID` int(11) DEFAULT NULL,
  `Group_ID` int(11) DEFAULT NULL,
  `Timestamp` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tempSignalHasDateTime` (
  `DateTime_ID` int(11) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `tmpsignalWithSeqID` (
  `Timestamp` datetime DEFAULT NULL,
  `Parameter` varchar(100) DEFAULT NULL,
  `Value` double DEFAULT NULL,
  `Goup_ID` int(11) DEFAULT NULL,
  `X` bigint(20) DEFAULT NULL,
  `Y` bigint(20) DEFAULT NULL,
  `Z` double DEFAULT NULL,
  `sourceId` varchar(255) DEFAULT NULL,
  `sourceTypeId` varchar(255) DEFAULT NULL,
  `serial` varchar(255) DEFAULT NULL,
  `sourceDescription` varchar(255) DEFAULT NULL,
  `lengthX` double DEFAULT NULL,
  `lengthY` double DEFAULT NULL,
  `angle` double DEFAULT NULL,
  `time` int(11) DEFAULT NULL,
  `Source_ID` int(11) DEFAULT NULL,
  `Coordinates_ID` int(11) DEFAULT NULL,
  `Integration_ID` int(11) DEFAULT NULL,
  `ParameterID` int(11) DEFAULT NULL,
  `DateTime_ID` int(11) DEFAULT NULL,
  `Signal_ID` int(11) DEFAULT NULL,
  `sourceName` varchar(200) DEFAULT NULL,
  `sourceTypeName` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

