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
<h1>NGA Charts project stats</h1>
<a href="stats_insets.php">Inset stats</a>
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

if (isset($_GET['region_id']) && isset($_GET['status_id']))
{
	$region = (int)$_GET['region_id'];
	$status = $_GET['status_id'];
	$low = $region * 10000;
	$high = ($region + 1) * 10000;
	if ($region == -1)
	{
		$low = 0;
		$high = 99999;
	}
	$query = "SELECT * FROM ocpn_nga_charts_with_params WHERE number >= ".$low." AND number < ".$high." AND status_id = ".$status;
	$res = mysql_query($query);
	echo "<table>\n";
	$header = false;
	while($r = mysql_fetch_array($res))
	{
		echo "<tr>\n";
		if (!$header)
		{
			foreach ($r as $k => $v)
				if (!is_numeric($k))
					echo "<th>".$k."</th>\n";
			$header = true;
			echo "</tr>\n<tr>\n";
		}
		foreach ($r as $k => $v)
			if (!is_numeric($k)) 
			{
				if ($k != 'number')
					echo "<td>".$v."</td>\n";
				else
				{
					if ($v >=10000)
						$reg = (int) floor($v / 10000);
					else
						$reg = 'misc';
					echo '<td><a href="http://opencpn.info/en/nga-charts-status-'.$reg.'?page='.$paging[$v]['page'].'#'.$v.'">'.$v.'</a></td>';
				}
			}
		echo "</tr>\n";
	}
	
	echo "</table>\n";
}
else
{
for ($i = -1; $i <= 9; $i++)
{
	$low = $i * 10000;
	$high = ($i + 1) * 10000;
	if ($i == -1)
	{
		$low = 0;
		$high = 99999;
	}
	$query = "SELECT COUNT(*) AS nr, status_text, status_id FROM ocpn_nga_charts_with_params WHERE number >= ".$low." AND number < ".$high." GROUP BY status_text";
	$res = mysql_query($query);
	if ($i == 0)
		$region = 'Miscelaneous';
	else
		$region = $i;
	if ($i == -1)
		echo "<h2>Overall</h2>";
	else
		echo "<h2>Region ".$region."</h2>\n";
	echo "<table>\n";
	echo "<tr><th>Status</th><th># of charts</th></tr>\n";
	while($r = mysql_fetch_array($res))
	{
		if (!$r['status_text'])
			$status = 'Untouched';
		else
			$status = '<a href="stats.php?region_id='.$i.'&status_id='.$r['status_id'].'">'.$r['status_text'].'</a>';
		echo "<tr><td>".$status."</td><td>".$r['nr']."</td></tr>\n";
	}
	echo "</table>\n";
}
}
?>
</body>
</html>
