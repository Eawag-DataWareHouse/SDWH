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

