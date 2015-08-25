SELECT s.Signal_ID
INTO tempSignalIDs
FROM  WaterResearch.factTable as s,
      WaterResearch.DateTime as dt,
      WaterResearch.signalHasDateTime as sdt,
      WaterResearch.Source as src
WHERE s.signal_ID=sdt.signal_ID and 
      dt.DateTime_ID=sdt.DateTime_ID and
	  s.Source_ID=src.Source_ID and
	  src.sourceName="PluvioNr01" and
      dt.date BETWEEN '2013-03-22 14:11:00' AND '2013-03-22 14:29:00';

INSERT INTO WaterResearch.DQ_Data (DQ_Description, Manual)
VALUES ("The values are modified to test the SDWH", "comment"),
	   ("these where also changed, just for fun","comment");

SELECT dq.DQ_ID
INTO tempDQIDs
FROM   WaterResearch.DQ_Data as dq
WHERE  dq.DQ_Description="these where also changed, just for fun";


INSERT INTO WaterResearch.SignalHasQualityInfo (signal_ID, DQ_ID, DQ_Status)
values (6,3,"not ok"),
       (8,3,"not ok"),
       (9,3,"not ok"),
       (10,3,"not ok"),
       (11,3,"not ok"),
       (13,3,"not ok"),
       (14,3,"not ok"),
       (15,3,"not ok"),
       (21,3,"not ok"),
       (27,3,"not ok"),
       (29,3,"not ok"),
       (30,3,"not ok"),
       (32,3,"not ok"),
       (33,3,"not ok"),
       (34,3,"not ok"),
       (36,3,"not ok"),
       (37,3,"not ok"),
       (41,3,"not ok"),
       (45,3,"not ok");



# automated approach, untested

SELECT s.Signal_ID
INTO tempSignalIDs
FROM  WaterResearch.factTable as s,
      WaterResearch.DateTime as dt,
      WaterResearch.signalHasDateTime as sdt,
      WaterResearch.Source as src
WHERE s.signal_ID=sdt.signal_ID and 
      dt.DateTime_ID=sdt.DateTime_ID and
	  s.Source_ID=src.Source_ID and
	  src.sourceName="PluvioNr01" and
      dt.date BETWEEN '2013-03-22 14:11:00' AND '2013-03-22 14:29:00';

INSERT INTO WaterResearch.DQ_Data (DQ_Description, Manual)
VALUES ("The values are modified to test the SDWH", "comment"),
	   ("these where also changed, just for fun","comment");

SELECT dq.DQ_ID
INTO tempDQIDs
FROM   WaterResearch.DQ_Data as dq
WHERE  dq.DQ_Description="these where also changed, just for fun";


INSERT INTO WaterResearch.SignalHasQualityInfo (signal_ID, DQ_ID, DQ_Status)
SELECT Signal_ID from tempSignalIDs
Union
SELECT DQ_ID 'ok' AS DQ_Status from tempDQIDs


