<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>NGA Charts project stats</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="http://opencpn.info/wp-content/themes/acquiamarina/style.css" type="text/css" media="screen" />
<meta name="robots" content="noindex,nofollow" />
</head>
<body onload="self.focus();">
<h1>NGA Charts project PLY submission</h1>
<?php
if (isset($_GET['chart']))
{
?>
<form name="gpxplyfrm"enctype="multipart/form-data" action="gpxuploader.php" method="POST">
<input type="file" id="gpx" name="gpx" onchange="check_file()" />
<input type="hidden" id="chart" name="chart" value="<?php echo $_GET['chart']; ?>" />
<input type="submit" value="Send" />
</form>
<br/>
Note, that the filename HAS TO BE &lt;chart number&gt;.gpx
<script>
function check_file()
{
    str=document.getElementById('gpx').value.toUpperCase();
    suffix=".GPX";
    suffix2=".gpx";
    if(!(str.indexOf(suffix, str.length - suffix.length) !== -1||
	str.indexOf(suffix2, str.length - suffix2.length) !== -1))
    	{
            alert('File type not allowed,\nAllowed file: *.gpx');
            document.getElementById('gpx').value='';
        }
    }
</script>
<?php
}
?>
</body>
</html>
