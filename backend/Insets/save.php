<?php
// ### Start the session
session_start();

$_SESSION['wp-user']['id'] = 1;

// ### First let's see if the user is logged-in and if not redirect to the login page
if(!$_SESSION['wp-user']['id']) {
	header('Location: http://opencpn.info/en/nga-charts-edit');
	exit;
}

//$fh = fopen('/var/www/virtualhosts/opencpn.xtr.cz/tmp/inset', 'w');
include("config.php");
// connect to the database
$link = mysql_connect($server, $usr, $pwd) or die("Connection Error: " . mysql_error());

mysql_select_db($db) or die("Error conecting to db.");

$id = (int)$_POST['id'];

$number = (int)$_POST['number'];
$inset_id = mysql_real_escape_string($_POST['inset_id']);
$bsb_type = mysql_real_escape_string($_POST['bsb_type']);
$title = mysql_real_escape_string($_POST['title']);
$scale = (int)$_POST['scale'];
$x = (int)$_POST['x'];
$y = (int)$_POST['y'];
$w = (int)$_POST['w'];
$h = (int)$_POST['h'];
$x1 = $x + $w;
$y1 = $y + $h;

//test the data
if ($number == 0)//The following would be confusing for added records: || $x1 == 0 || $y1 == 0 || $x1 - $x < 100 || $y1 - $y < 100)
	die(); //Not properly defined or too small to be an inset
//fwrite($fh, $_POST['oper']."\n");
switch($_POST['oper'])
{
	case 'edit':
		$sql = 'INSERT INTO ocpn_nga_kap (number, is_main, status_id, scale, title, NU, GD ,PR, PP ,UN, SD, DTMx, DTMy, DTMdat, changed, changed_by, active, locked, bsb_type, GD_other, PR_other, UN_other, SD_other, DTMdat_other, locked_by ,comments ,noPP, noDTM, kap_generated, gpx, inset_id) SELECT number, is_main, status_id, scale, title, NU, GD ,PR, PP ,UN, SD, DTMx, DTMy, DTMdat, changed, changed_by, 0, locked, bsb_type, GD_other, PR_other, UN_other, SD_other, DTMdat_other, locked_by ,comments ,noPP, noDTM, kap_generated, gpx, inset_id FROM ocpn_nga_kap WHERE active=1 AND kap_id='.$id;
		$r = mysql_query($sql);
		
		$sql = 'UPDATE ocpn_nga_kap SET number='.$number.', scale='.$scale.', title=\''.$title.'\', bsb_type=\''.$bsb_type.'\', NU=\''.$number.$inset_id.'\', changed=CURRENT_TIMESTAMP(), changed_by='.$_SESSION['wp-user']['id'].', inset_id=\''.$inset_id.'\' WHERE kap_id='.$id;
		$r = mysql_query($sql);
		
		$sql = 'SELECT MIN(x) AS minx, MIN(y) AS miny FROM ocpn_nga_kap_point WHERE active=1 AND point_type=\'CROP\' AND kap_id='.$id;
		$res = mysql_query($sql);
		if(mysql_num_rows($res) > 0)
		{
			$row = mysql_fetch_array($res);
			//recalculate the existing REFs 
			$shiftx = $x - (int)$row['minx'];
			$shifty = $y - (int)$row['miny'];
			$sql = 'UPDATE ocpn_nga_kap_point SET x=x-'.$shiftx.', y=y-'.$shifty.' WHERE active=1 AND kap_id='.$id.' AND point_type=\'REF\'';
			mysql_query($sql);
		}
		$sql = 'UPDATE ocpn_nga_kap_point SET active = 0 WHERE point_type=\'CROP\' AND kap_id='.$id;
		mysql_query($sql);
		$sql = 'INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active) VALUES ('.$id.', NULL, NULL, '.$x.', '.$y.', \'CROP\', '.$_SESSION['wp-user']['id'].', CURRENT_TIMESTAMP(), 1, 1)';
		mysql_query($sql);
		$sql = 'INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active) VALUES ('.$id.', NULL, NULL, '.$x1.', '.$y1.', \'CROP\', '.$_SESSION['wp-user']['id'].', CURRENT_TIMESTAMP(), 2, 1)';
		mysql_query($sql);
		break;
	case 'add':
		$sql = 'INSERT INTO ocpn_nga_kap (number, is_main, status_id, scale, title, NU, GD ,PR, PP ,UN, SD, DTMx, DTMy, DTMdat, changed, changed_by, active, locked, bsb_type, GD_other, PR_other, UN_other, SD_other, DTMdat_other, locked_by ,comments ,noPP, noDTM, kap_generated, gpx, inset_id) VALUES ('.$number.', 0, 16, '.$scale.', \''.$title.'\', NULL, NULL ,NULL, NULL ,NULL, NULL, NULL, NULL, NULL, CURRENT_TIMESTAMP(), '.$_SESSION['wp-user']['id'].', 1, 0, \''.$bsb_type.'\', NULL, NULL, NULL, NULL, NULL, NULL,NULL, NULL, NULL, NULL, NULL, \''.$inset_id.'\')';
		//fwrite($fh, $sql."\n");
		mysql_query($sql);
		$id = mysql_insert_id($link);
		$sql = 'INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active) VALUES ('.$id.', NULL, NULL, '.$x.', '.$y.', \'CROP\', '.$_SESSION['wp-user']['id'].', CURRENT_TIMESTAMP(), 1, 1)';
		//fwrite($fh, $sql."\n");
		mysql_query($sql);
		$sql = 'INSERT INTO ocpn_nga_kap_point (kap_id, latitude, longitude, x, y, point_type, created_by, created, sequence, active) VALUES ('.$id.', NULL, NULL, '.$x1.', '.$y1.', \'CROP\', '.$_SESSION['wp-user']['id'].', CURRENT_TIMESTAMP(), 2, 1)';
		//fwrite($fh, $sql."\n");
		mysql_query($sql);
		break;
}

mysql_close($link);
fclose($fh);

/*
$fh = fopen('/var/www/virtualhosts/opencpn.xtr.cz/tmp/inset', 'w');
fwrite($fh, var_export($_POST, TRUE));
fwrite($fh, var_export($_REQUEST, TRUE));
fclose($fh);
*/
/*
array (
  'number' => '14221',
  'inset_id' => 'A',
  'bsb_type' => 'PLAN',
  'title' => 'Lanoraie Anchorage',
  'scale' => '18000',
  'x' => '2188',
  'y' => '738',
  'w' => '1263',
  'h' => '950',
  'oper' => 'edit',
  'id' => '16100',
)

array (
  'number' => '14800',
  'inset_id' => 'A',
  'bsb_type' => 'INSET',
  'title' => 'Test',
  'scale' => '10000',
  'x' => '0',
  'y' => '0',
  'w' => '0',
  'h' => '0',
  'oper' => 'add',
  'id' => '_empty',
)
  
)array (
  'number' => '111',
  'inset_id' => 'A',
  'bsb_type' => 'INSET',
  'title' => 'aaa',
  'scale' => '111',
  'x' => '',
  'y' => '',
  'w' => '',
  'h' => '',
  'oper' => 'add',
  'id' => '_empty',
) 
*/
?>