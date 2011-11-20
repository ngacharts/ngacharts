<?php
include("config.php");
// connect to the database
$link = mysql_connect($server, $usr, $pwd) or die("Connection Error: " . mysql_error());

$page = (int)$_GET['page']; // get the requested page
$limit = (int)$_GET['rows']; // get how many rows we want to have into the grid
$sidx = mysql_real_escape_string($_GET['sidx']); // get index row - i.e. user click to sort
$sord = mysql_real_escape_string($_GET['sord']); // get the direction
if(!$sidx) $sidx =1;
if(!$limit) $limit =10;

mysql_select_db($db) or die("Error conecting to db.");
$result = mysql_query("SELECT COUNT(*) AS count FROM ocpn_nga_kap WHERE active = 1 AND bsb_type != 'BASE' AND number IN (SELECT number FROM ocpn_nga_charts)");
$row = mysql_fetch_array($result,MYSQL_ASSOC);
$count = $row['count'];

if( $count > 0 ) {
	$total_pages = ceil($count/$limit);
} else {
	$total_pages = 0;
}
if ($page > $total_pages) $page=$total_pages;
$start = $limit*$page - $limit; // do not put $limit*($page - 1)
if ($start < 0) $start=0;
//$SQL = "SELECT a.id, a.invdate, b.name, a.amount,a.tax,a.total,a.note FROM invheader a, clients b WHERE a.client_id=b.client_id ORDER BY $sidx $sord LIMIT $start , $limit";

$SQL = "SELECT kap_id AS id, number, inset_id, bsb_type, title, scale, (SELECT MIN(x) FROM ocpn_nga_kap_point WHERE kap_id = k.kap_id AND active = 1 AND point_type='CROP') AS x, ((SELECT MAX(x) FROM ocpn_nga_kap_point WHERE kap_id = k.kap_id AND active = 1 AND point_type='CROP') - (SELECT MIN(x) FROM ocpn_nga_kap_point WHERE kap_id = k.kap_id AND active = 1 AND point_type='CROP')) AS w, ((SELECT MAX(y) FROM ocpn_nga_kap_point WHERE kap_id = k.kap_id AND active = 1 AND point_type='CROP') - (SELECT MIN(y) FROM ocpn_nga_kap_point WHERE kap_id = k.kap_id AND active = 1 AND point_type='CROP')) AS h  FROM ocpn_nga_kap k WHERE active = 1 AND bsb_type != 'BASE' AND number IN (SELECT number FROM ocpn_nga_charts) ORDER BY $sidx $sord LIMIT $start , $limit";
//echo $SQL;
$result = mysql_query( $SQL ) or die("Couldn t execute query.".mysql_error());

$responce->page = $page;
$responce->total = $total_pages;
$responce->records = $count;
$i=0;
while($row = mysql_fetch_array($result,MYSQL_ASSOC)) {
    $responce->rows[$i]['id']=$row[id];
    $responce->rows[$i]['cell']=array($row[id],$row[number],$row[inset_id],$row[bsb_type],$row[title],$row[scale],$row[x],$row[y],$row[w],$row[h]);
    $i++;
}
echo json_encode($responce);
?>
