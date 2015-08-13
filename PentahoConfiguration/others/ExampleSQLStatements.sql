#Tested standard Query for Source Instance and date range

SELECT dt.Date, s.Value, src.Source_ID, sqi.DQ_Status, dq.DQ_Description, par.Name, par.Unit 
FROM    WaterResearch.factTable as s
LEFT JOIN  WaterResearch.SignalHasQualityInfo as sqi
      ON s.signal_ID=sqi.signal_ID
LEFT JOIN  WaterResearch.signalHasDateTime as sdt
      ON s.signal_ID=sdt.signal_ID
LEFT JOIN  WaterResearch.DateTime as dt
      ON dt.DateTime_ID=sdt.DateTime_ID
LEFT JOIN  WaterResearch.Source as src
      ON s.Source_ID=src.Source_ID
LEFT JOIN  WaterResearch.DQ_Data as dq
      ON sqi.DQ_ID=dq.DQ_ID
LEFT JOIN  WaterResearch.Parameter as par
      ON s.Parameter_ID=par.ParameterID
WHERE src.Serial="PL123" and
      dt.Date BETWEEN '2013-03-22 14:03:00' AND '2013-03-22 14:35:00'
Order BY dt.Date asc;

#Exampels from Fasika
#Give me the rain from Weather radar at coordinate(x,Y) between time t1 and t2

SELECT * 
FROM    WaterResearch.factTable as s,
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

#Give me all spectra from the SCAN probe measured at time t
SELECT * 
FROM    WaterResearch.factTable as s,
        WaterResearch.DateTime as dt,
        WaterResearch.signalHasDateTime as sdt,
        WaterResearch.Source as src
WHERE s.signal_ID=sdt.signal_ID and 
      dt.DateTime_ID=sdt.DateTime_ID and
      s.Source_ID=src.Source_ID and
      src.Serial="11280256" and
      dt.Date BETWEEN '0034-10-05 03:16:00' AND '0035-10-05 03:16:00';

#Give me the 100 newest measurement of weather radar where "10<xcoord<=20" and "33<ycoord<=40"
SELECT * 
FROM    WaterResearch.factTable as s,
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

#List all sites
SELECT * FROM WaterResearch.Site;


#Give me all sources for which measurements are available at Site S
SELECT src.Source_ID, src.SourceTypeID, src.Serial, src.Description 
FROM    WaterResearch.factTable as s,
        WaterResearch.Source as src,
        WaterResearch.Coordinates as coord,
        WaterResearch.Site as site
WHERE s.Source_ID=src.Source_ID and
      s.Coordinates_ID=coord.Coordinates_ID and
      coord.Coordinates_ID=site.Coordinates_ID and
      site.Name="scan01Dresden";

# Give me all images from site S

SELECT pic.BLOBs 
FROM WaterResearch.Picture AS pic and
     WaterResearch.Site as site
WHERE pic.Site_ID=site.Site_ID;

