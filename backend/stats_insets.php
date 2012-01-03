<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>NGA Charts project stats</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="robots" content="noindex,nofollow" />
<style type="text/css">
table, td, th
{
border:1px solid green;
}
th
{
background-color:green;
color:white;
}
</style>
</head>
<body>
<h1>NGA Charts project stats - insets</h1>
<a href="stats.php">Base chart stats</a>
<?php
require_once("config.php");
$link = mysql_connect($server, $usr, $pwd);
mysql_select_db($db);
$query = '
(SELECT ((@rownum0:=@rownum0+1) - 1) DIV 50 + 1 AS page, c.number AS number, \'misc\' AS region  FROM ocpn_nga_charts c, (SELECT @rownum0:=0) r WHERE number < 10000 ORDER BY number ASC)
UNION
(SELECT ((@rownum1:=@rownum1+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum1:=0) r WHERE number >= 10000 AND number < 20000 ORDER BY number ASC)
UNION
(SELECT ((@rownum2:=@rownum2+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum2:=0) r WHERE number >= 20000 AND number < 30000 ORDER BY number ASC)
UNION
(SELECT ((@rownum3:=@rownum3+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum3:=0) r WHERE number >= 30000 AND number < 40000 ORDER BY number ASC)
UNION
(SELECT ((@rownum4:=@rownum4+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum4:=0) r WHERE number >= 40000 AND number < 50000 ORDER BY number ASC)
UNION
(SELECT ((@rownum5:=@rownum5+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum5:=0) r WHERE number >= 50000 AND number < 60000 ORDER BY number ASC)
UNION
(SELECT ((@rownum6:=@rownum6+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum6:=0) r WHERE number >= 60000 AND number < 70000 ORDER BY number ASC)
UNION
(SELECT ((@rownum7:=@rownum7+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum7:=0) r WHERE number >= 70000 AND number < 80000 ORDER BY number ASC)
UNION
(SELECT ((@rownum8:=@rownum8+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum8:=0) r WHERE number >= 80000 AND number < 90000 ORDER BY number ASC)
UNION
(SELECT ((@rownum9:=@rownum9+1) - 1) DIV 50 + 1 AS page, c.number AS number, c.number DIV 10000 AS region  FROM ocpn_nga_charts c, (SELECT @rownum9:=0) r WHERE number >= 90000 AND number < 100000 ORDER BY number ASC)';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	$paging[$r['number']] = array('page' => $r['page'], 'region' => $r['region']);
}

echo '<h3>Number of insets with defined extents</h3>';
$query = 'SELECT COUNT(*) AS cnt FROM ocpn_nga_kap WHERE bsb_type != \'BASE\' AND active=1 AND cropped IS NOT NULL';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo $r['cnt'];
}

echo '<h3>Total number of insets in the DB</h3>';
$query = 'SELECT COUNT(*) AS cnt FROM ocpn_nga_kap WHERE bsb_type != \'BASE\' AND active=1';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo $r['cnt'];
}

echo '<h2>Charts with defined insets without extents set</h2>';
$query = 'SELECT DISTINCT number FROM ocpn_nga_kap WHERE active=1 AND bsb_type != \'BASE\' AND cropped IS NULL';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo '<a href="http://opencpn.info/en/nga-charts-status-'.$paging[$r['number']]['region'].'?page='.$paging[$r['number']]['page'].'#'.$r['number'].'">'.$r['number'].'</a> ';
}

echo '<h2>Charts with insets marked with \'X\' (the insets should be marked A, B, C...)</h2>';
$query = 'SELECT DISTINCT number FROM ocpn_nga_kap WHERE active=1 AND bsb_type != \'BASE\' AND NU LIKE \'%X\'';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo '<a href="http://opencpn.info/en/nga-charts-status-'.$paging[$r['number']]['region'].'?page='.$paging[$r['number']]['page'].'#'.$r['number'].'">'.$r['number'].'</a> ';
}


echo '<h2>Duplicate inset IDs (two or more insets marked with the same letter)</h2>';
$query = 'SELECT number FROM ocpn_nga_kap WHERE active=1 AND bsb_type != \'BASE\' GROUP BY number, NU HAVING ( COUNT(NU) > 1 )';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo '<a href="http://opencpn.info/en/nga-charts-status-'.$paging[$r['number']]['region'].'?page='.$paging[$r['number']]['page'].'#'.$r['number'].'">'.$r['number'].'</a> ';
}

echo '<h2>Charts not having any inset defined, but marked as they should by chart status</h2>';
$query = 'SELECT number FROM ocpn_nga_charts WHERE status_id IN (2,3,9,10) AND number not IN (SELECT number FROM ocpn_nga_kap WHERE bsb_type != \'BASE\')';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo '<a href="http://opencpn.info/en/nga-charts-status-'.$paging[$r['number']]['region'].'?page='.$paging[$r['number']]['page'].'#'.$r['number'].'">'.$r['number'].'</a> ';
}

?>
</body>
</html>

