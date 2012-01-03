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

echo '<h2>Charts with defined insets without extents set</h2>';
$query = 'SELECT DISTINCT number FROM ocpn_nga_kap WHERE active=1 AND bsb_type != \'BASE\' AND cropped IS NULL';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo $r['number'].' ';
}

echo '<h2>Charts with insets marked with \'X\' (the insets should be marked A, B, C...)</h2>';
$query = 'SELECT DISTINCT number FROM ocpn_nga_kap WHERE active=1 AND bsb_type != \'BASE\' AND NU LIKE \'%X\'';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo $r['number'].' ';
}


echo '<h2>Duplicate inset IDs (two or more insets marked with the same letter)</h2>';
$query = 'SELECT number FROM ocpn_nga_kap WHERE active=1 AND bsb_type != \'BASE\' GROUP BY number, NU HAVING ( COUNT(NU) > 1 )';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo $r['number'].' ';
}

echo '<h2>Charts not having any inset defined, but marked as they should by chart status</h2>';
$query = 'SELECT number FROM ocpn_nga_charts WHERE status_id IN (2,3,9,10) AND number not IN (SELECT number FROM ocpn_nga_kap WHERE bsb_type != \'BASE\')';
$res = mysql_query($query);
while($r = mysql_fetch_array($res))
{
	echo $r['number'].' ';
}

?>
</body>
</html>
