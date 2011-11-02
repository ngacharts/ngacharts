<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>NGA Charts project stats</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="http://opencpn.info/wp-content/themes/acquiamarina/style.css" type="text/css" media="screen" />
<meta name="robots" content="noindex,nofollow" />
</head>
<body>
<h1>NGA Charts project PLY submission</h1>
<?php
require_once("config.php");
if (isset($_POST['chart']) && count($_FILES) == 1 && $_FILES['gpx']['error'] == 0 && strtolower($_FILES['gpx']['name']) === $_POST['chart'].'.gpx' && $_FILES['gpx']['size'] < 100000)
{
	$command = $gpx_ply_import.' '.$_FILES['gpx']['tmp_name'].' '.$_POST['chart'];
	system($command);
?>
	<br/>
	Thank you for submitting the chart boundary polygon.
	<br/>
	The chart will be updated within a couple of minutes.
<?php
}
else
{
	echo $_POST['chart'].' - '.count($_FILES).' - '. $_FILES['gpx']['error'].' - '. strtolower($_FILES['gpx']['name']).' - '.$_FILES['gpx']['size'];
}
?>
</body>
</html>
