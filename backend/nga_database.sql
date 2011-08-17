#############################################################################################################
##### Complete info about the cells
CREATE OR REPLACE VIEW ocpn_nga_charts_with_params
AS
SELECT 
  c.number AS number, c.scale AS scale, c.title AS title, c.edition AS edition, c.date AS date, c.correction AS correction, c.width AS width, c.height AS height, c.tiles AS tiles, c.xtiles AS xtiles, c.ytiles AS ytiles, c.tilesize AS tilesize, c.zoomlevel AS zoomlevel, c.has_addition AS has_additions, c.status_id as status_id, c.bsb_chf AS bsb_chf,
  k.GD AS GD, k.PR AS PR, k.PP AS PP, IF(k.PP IS NULL, NULL, FLOOR(ABS(k.PP))) as PPdeg, IF(k.PP IS NULL, NULL, ROUND((ABS(k.PP) - FLOOR(ABS(k.PP))) * 60)) as PPmin, IF(k.PP IS NULL, NULL, IF(k.PP >= 0, 1, -1)) AS PPhemi, k.UN AS UN, k.SD AS SD, k.DTMx AS DTMx, k.DTMy AS DTMy, ABS(k.DTMx) AS DTMx_abs, ABS(k.DTMy) AS DTMy_abs, IF(k.DTMx IS NULL, NULL, IF(k.DTMx < 0, -1, 1)) AS DTMx_dir, IF(k.DTMy IS NULL, NULL, IF(k.DTMy < 0, -1, 1)) AS DTMy_dir, k.DTMdat AS DTMdat, k.changed AS changed, k.changed_by AS changed_by, k.bsb_type AS bsb_type, k.locked_by AS locked_by, k.comments as comments,
  psw.latitude AS South, psw.longitude AS West, pne.latitude AS North, pne.longitude AS East, c.bsb_chf_other AS bsb_chf_other, k.GD_other AS GD_other, k.PR_other AS PR_other, k.UN_other AS UN_other, k.SD_other AS SD_other, k.DTMdat_other AS DTMdat_other, c.status_other as status_other, 

  FLOOR(ABS(psw.latitude)) + (FLOOR((ABS(psw.latitude) - FLOOR(ABS(psw.latitude))) * 60) + ROUND((ABS(psw.latitude) - FLOOR(ABS(psw.latitude)) - FLOOR((ABS(psw.latitude) - FLOOR(ABS(psw.latitude))) * 60) / 60) * 3600) DIV 60) DIV 60 AS Sdeg, (FLOOR((ABS(psw.latitude) - FLOOR(ABS(psw.latitude))) * 60) + ROUND((ABS(psw.latitude) - FLOOR(ABS(psw.latitude)) - FLOOR((ABS(psw.latitude) - FLOOR(ABS(psw.latitude))) * 60) / 60) * 3600) DIV 60) % 60 AS Smin, ROUND((ABS(psw.latitude) - FLOOR(ABS(psw.latitude)) - FLOOR((ABS(psw.latitude) - FLOOR(ABS(psw.latitude))) * 60) / 60) * 3600) % 60 AS Ssec, IF(psw.latitude IS NULL, NULL, IF(psw.latitude >= 0, 1, -1)) AS Snhemi,
 
  FLOOR(ABS(pne.latitude)) + (FLOOR((ABS(pne.latitude) - FLOOR(ABS(pne.latitude))) * 60) + ROUND((ABS(pne.latitude) - FLOOR(ABS(pne.latitude)) - FLOOR((ABS(pne.latitude) - FLOOR(ABS(pne.latitude))) * 60) / 60) * 3600) DIV 60) DIV 60 AS Ndeg, (FLOOR((ABS(pne.latitude) - FLOOR(ABS(pne.latitude))) * 60) + ROUND((ABS(pne.latitude) - FLOOR(ABS(pne.latitude)) - FLOOR((ABS(pne.latitude) - FLOOR(ABS(pne.latitude))) * 60) / 60) * 3600) DIV 60) % 60 AS Nmin, ROUND((ABS(pne.latitude) - FLOOR(ABS(pne.latitude)) - FLOOR((ABS(pne.latitude) - FLOOR(ABS(pne.latitude))) * 60) / 60) * 3600) % 60 AS Nsec, IF(pne.latitude IS NULL, NULL, IF(pne.latitude >= 0, 1, -1)) AS Nnhemi,

  FLOOR(ABS(pne.longitude)) + (FLOOR((ABS(pne.longitude) - FLOOR(ABS(pne.longitude))) * 60) + ROUND((ABS(pne.longitude) - FLOOR(ABS(pne.longitude)) - FLOOR((ABS(pne.longitude) - FLOOR(ABS(pne.longitude))) * 60) / 60) * 3600) DIV 60) DIV 60 AS Edeg, (FLOOR((ABS(pne.longitude) - FLOOR(ABS(pne.longitude))) * 60) + ROUND((ABS(pne.longitude) - FLOOR(ABS(pne.longitude)) - FLOOR((ABS(pne.longitude) - FLOOR(ABS(pne.longitude))) * 60) / 60) * 3600) DIV 60) % 60 AS Emin, ROUND((ABS(pne.longitude) - FLOOR(ABS(pne.longitude)) - FLOOR((ABS(pne.longitude) - FLOOR(ABS(pne.longitude))) * 60) / 60) * 3600) % 60 AS Esec, IF(pne.longitude IS NULL, NULL, IF(pne.longitude >= 0, 1,-1)) AS Eehemi,
  
  FLOOR(ABS(psw.longitude)) + (FLOOR((ABS(psw.longitude) - FLOOR(ABS(psw.longitude))) * 60) + ROUND((ABS(psw.longitude) - FLOOR(ABS(psw.longitude)) - FLOOR((ABS(psw.longitude) - FLOOR(ABS(psw.longitude))) * 60) / 60) * 3600) DIV 60) DIV 60 AS Wdeg, (FLOOR((ABS(psw.longitude) - FLOOR(ABS(psw.longitude))) * 60) + ROUND((ABS(psw.longitude) - FLOOR(ABS(psw.longitude)) - FLOOR((ABS(psw.longitude) - FLOOR(ABS(psw.longitude))) * 60) / 60) * 3600) DIV 60) % 60 AS Wmin, ROUND((ABS(psw.longitude) - FLOOR(ABS(psw.longitude)) - FLOOR((ABS(psw.longitude) - FLOOR(ABS(psw.longitude))) * 60) / 60) * 3600) % 60 AS Wsec, IF(psw.longitude IS NULL, NULL, IF(psw.longitude >= 0, 1, -1)) AS Wehemi,

  psw.x AS Xsw, psw.y AS Ysw, pnw.x AS Xnw, pnw.y AS Ynw, pne.x AS Xne, pne.y AS Yne, pse.x AS Xse, pse.y AS Yse
FROM ocpn_nga_charts c 
   LEFT JOIN ocpn_nga_kap k ON (c.number = k.number and k.active = 1) 
   LEFT JOIN ocpn_nga_kap_point psw ON (k.kap_id = psw.kap_id AND psw.active=1 AND psw.sequence=1 AND psw.point_type='REF') 
   LEFT JOIN ocpn_nga_kap_point pne ON (k.kap_id = pne.kap_id AND pne.active=1 AND pne.sequence=3 AND pne.point_type='REF')
   LEFT JOIN ocpn_nga_kap_point pse ON (k.kap_id = pse.kap_id AND pse.active=1 AND pse.sequence=4 AND pse.point_type='REF')
   LEFT JOIN ocpn_nga_kap_point pnw ON (k.kap_id = pnw.kap_id AND pnw.active=1 AND pnw.sequence=2 AND pnw.point_type='REF')

#############################################################################################################
##### Fill in ocpn_nga_kap with the main plans for each chart
SET @timestamp = NOW();
SET @user = 1;
INSERT INTO ocpn_nga_kap (number, is_main, status_id, locked, scale, title, changed, changed_by, active, NU)
   SELECT number, 1, 0, 0, scale, title, @timestamp, @user, 1, CONVERT(number, CHAR) FROM ocpn_nga_charts;

#############################################################################################################
##### Save calibration points for a chart (Works just in Phase 1, where there is 1 KAP per chart)
#=== Input from the user ===============
SET @chart_number = 37112;
SET @user = 1;

SET @deglatsw = 49;
SET @minlatsw = 53;
SET @seclatsw = 54;
SET @deglonsw = 0;
SET @minlonsw = 50;
SET @seclonsw = 24;
SET @EWcoef = 1; #1 for E, -1 for W

SET @deglatne = 50;
SET @minlatne = 11;
SET @seclatne = 48;
SET @deglonne = 1;
SET @minlonne = 31;
SET @seclonne = 0;
SET @NScoef = 1; #1 for N, -1 for S

SET @xsw = 766;
SET @ysw = 12568;
SET @xnw = 815;
SET @ynw = 730;
SET @xne = 18094;
SET @yne = 799;
SET @xse = 18044;
SET @yse = 12641;

SET @NU = CONVERT(@chart_number, CHAR);
SET @GD = 'WGS84';
SET @PR = 'MERCATOR';
SET @PP = -999;
/*
The following has to be implemented later when generating the KAPs
#Mercator
IF @PP = -999 AND @PR = 'MERCATOR' THEN 
  SET @PP = (@latsw + @latne) / 2 ;
END IF
#Transverse Mercator
IF @PP = -999 AND @PR = 'TRANSVERSE MERCATOR' THEN 
  SET @PP = (@lonsw + @lonne) / 2 ;
END IF
*/
SET @UN = 'METERS';
SET @SD = 'MLLW';
SET @DTMx = 0.0; 
SET @DTMy = 0.0;

#=== Past this line just server-side calculations and defaults ===================
SET @timestamp = NOW();
SET @latsw = @NScoef * (@deglatsw + @minlatsw / 60 + @seclatsw / 3600);
SET @lonsw = @EWcoef * (@deglonsw + @minlonsw / 60 + @seclonsw / 3600);
SET @latne = @NScoef * (@deglatne + @minlatne / 60 + @seclatne / 3600);
SET @lonne = @EWcoef * (@deglonne + @minlonne / 60 + @seclonne / 3600);

SET @KAPismain = 1; #Phase 1 - all of them are main
SET @KAPstatus = 0; #For now, let's say we don't need status for individual KAPs
SET @KAPlocked = 0; #Phase 1  - all of them are unlocked
SET @SWcorner = 1;
SET @NWcorner = 2;
SET @NEcorner = 3;
SET @SEcorner = 4;
#find the KAP
SELECT kap_id, scale, title INTO @kap_id, @scale, @title FROM ocpn_nga_kap WHERE active = 1 AND number = @chart_number LIMIT 0,1;
#Invalidate the existing KAP info
UPDATE ocpn_nga_kap SET active = 0 WHERE kap_id = @kap_id;
#Insert the new KAP info
INSERT INTO ocpn_nga_kap (number, is_main, status_id, locked, scale, title, NU, GD, PR, PP, UN, SD, DTMx, DTMy, changed, changed_by, active)
VALUES (@chart_number, @KAPismain, @KAPstatus, @KAPlocked, @scale, @title, @NU, @GD, @PR, @PP, @UN, @SD, @DTMx, @DTMy, @timestamp, @user, 1);
SET @new_kap_id = LAST_INSERT_ID();
#Invalidate the existing points
UPDATE ocpn_nga_kap_point SET active = 0 WHERE kap_id = @kap_id;
#Insert the new points
INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active)
VALUES (@new_kap_id, @latsw, @lonsw, @xsw, @ysw, 'REF', @user, @timestamp, @SWcorner, 1);
INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active)
VALUES (@new_kap_id, @latne, @lonsw, @xnw, @ynw, 'REF', @user, @timestamp, @NWcorner, 1);
INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active)
VALUES (@new_kap_id, @latne, @lonne, @xne, @yne, 'REF', @user, @timestamp, @NEcorner, 1);
INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active)
VALUES (@new_kap_id, @latsw, @lonne, @xse, @yse, 'REF', @user, @timestamp, @SEcorner, 1);
