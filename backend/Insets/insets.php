<?php
// ### Start the session
session_start();

$_SESSION['wp-user']['id'] = 1;

// ### First let's see if the user is logged-in and if not redirect to the login page
if(!$_SESSION['wp-user']['id']) {
	header('Location: http://opencpn.info/en/nga-charts-edit');
	exit;
}
?>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>NGA Charts project - Insets manager</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="robots" content="noindex,nofollow" />

<link rel="stylesheet" type="text/css" media="screen" href="themes/redmond/jquery-ui.custom.css" />
<link rel="stylesheet" href="css/jquery.Jcrop.css" type="text/css" />
<link rel="stylesheet" type="text/css" media="screen" href="themes/ui.jqgrid.css" />
<link rel="stylesheet" type="text/css" media="screen" href="themes/ui.multiselect.css" />

<style>
.ui-tabs-nav li {position: relative;}
.ui-tabs-selected a span {padding-right: 10px;}
.ui-tabs-close {display: none;position: absolute;top: 3px;right: 0px;z-index: 800;width: 16px;height: 14px;font-size: 10px; font-style: normal;cursor: pointer;}
.ui-tabs-selected .ui-tabs-close {display: block;}
.ui-layout-west .ui-jqgrid tr.jqgrow td { border-bottom: 0px none;}
.ui-datepicker {z-index:1200;}
.unsavedstyle {color: #FF0000; background-color: #FFCCCC; font-weight: bold; border: 2px solid; border-color: #FF0000; padding: 5px; margin: 10px;}
.resetstyle {color: #333333; background-color: #CCCCCC; font-weight: bold; border: 2px solid; border-color: #999999; padding: 5px; margin: 10px;}
</style>
<script src="js/jquery-1.6.4.min.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
<script src="js/jquery.Jcrop.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery.mousewheel.min.js"></script>
<script type="text/javascript" src="js/jquery.timers-1.2.js"></script>
<script src="js/grid.locale-en.js" type="text/javascript"></script>
<script src="js/jquery.jqGrid.min.js" type="text/javascript"></script>
<script src="js/jquery.layout.js" type="text/javascript"></script>
<script src="js/jquery.dump.js" type="text/javascript"></script>
<script type="text/javascript">
	$.jgrid.no_legacy_api = true;
	$.jgrid.useJSON = true;
</script>
<script src="js/ui.multiselect.js" type="text/javascript"></script>
<script src="js/jquery.tablednd.js" type="text/javascript"></script>
<script src="js/jquery.contextmenu.js" type="text/javascript"></script>

<body>
<h1>NGA Charts project - Inset definition tool</h1>
<table id="list5" class="table" summary="Inset list"></table>
<div id="pager5"></div>
<br/>
<a href="#" id="unsaved" class="unsavedstyle">Save changes to the inset shape...</a>&nbsp;<a href="#" id="reset" class="resetstyle">Reset shape changes...</a>
<br/><br/>
<script type="text/javascript">

var lastsel2;
var cursel;
var handleevents;
var changed;
var shape;
jQuery("#list5").jqGrid({
   	url:'chartlist.php', 
			datatype: "json", 
			colNames:['ID','Chart nr.','Inset', 'Type', 'Title','Scale', 'X', 'Y', 'Width', 'Height'], 
			colModel:[
			{name:'id',index:'id', width:50}, 
			{name:'number',index:'number', width:50, sorttype:"int", editable: true, editrules:{required:true, integer: true, minValue:0, maxValue: 99999}}, 
			{name:'inset_id',index:'inset_id', width:40, editable: true,edittype:"select",editoptions:{value:"A:A;B:B;C:C;D:D;E:E;F:F;G:G;H:H;I:I;J:J;K:K;L:L;M:M;N:N;O:O;P:P;Q:Q;R:R;S:S;T:T;U:U;V:V;W:W;X:X;Y:Y;Z:Z"}, editrules:{required:true}},
			{name:'bsb_type',index:'bsb_type', width:70, editable: true,edittype:"select",editoptions:{value:"INSET:INSET;PLAN:PLAN;PANEL:PANEL"}, editrules:{required:true}}, 
			{name:'title',index:'title', width:400, sortable:false, editable:true, editrules:{required:true}}, 
			{name:'scale',index:'scale', width:80,align:"right", sorttype:"int", editable: true, editrules:{required:true, integer: true, minValue:0, maxValue: 9999999}}, 
			{name:'x',index:'x', width:50,align:"right", sorttype:"int", editable: true, editrules:{integer: true, minValue:0, maxValue: 99999}}, 
			{name:'y',index:'y', width:50,align:"right", sorttype:"int", editable: true, editrules:{integer: true, minValue:0, maxValue: 99999}}, 
			{name:'w',index:'w', width:50,align:"right", sorttype:"int", editable: true, editrules:{integer: true, minValue:0, maxValue: 99999}}, 
			{name:'h',index:'h', width:50,align:"right", sorttype:"int", editable: true, editrules:{integer: true, minValue:0, maxValue: 99999}}
			],
			onSelectRow: function(id){
				if(id && id!==lastsel2){
					cursel=id;
					if (lastsel2 && changed){
						jQuery('#list5').jqGrid('editRow', lastsel2, true); //Had to add this to force the AJAX callback... WHY??? 
						jQuery('#list5').jqGrid('saveRow', lastsel2, false);
						jQuery("#unsaved").hide();
					}
					changed=false;
					lastsel2=id;
					handleevents=false;
					var ret = jQuery("#list5").jqGrid('getRowData',id);
					var chart = "http://opencpn.info/nga/chartimages/thumbs/" + ret.number + "_zl3.jpg";
					jcrop_api.setImage(chart, function(){
						if(ret.x != "" && ret.y != "" && ret.w !="" && ret.h!="")
						{
							x = Math.round(parseInt(ret.x) / 12.5);
							y = Math.round(parseInt(ret.y) / 12.5);
							w = Math.round(parseInt(ret.w) / 12.5);
							h = Math.round(parseInt(ret.h) / 12.5);
							x2 = x+w;
							y2 = y+h;
							shape = [x, y, x2, y2];
							jcrop_api.setSelect(shape);
						};
						handleevents=true;
					});
				};
			},
			height:300,
			rowNum:20,
   			rowList:[20,50,100],
		   	pager: '#pager5',
		   	sortname: 'id',
			viewrecords: true,
			sortorder: "desc",
    		caption:"NGA Charts - Insets",
			editurl:"save.php"
<?php
if(isset($_GET["chart"]))
			echo ',postData:{"search":"true","searchField":"number","searchString":"'.(int)$_GET["chart"].'"}';
?>

});
jQuery("#list5").jqGrid('navGrid',"#pager5",{edit:true,add:true,del:false});

jQuery("#unsaved").click( function(){
	jQuery('#list5').jqGrid('editRow', cursel, true); //Had to add this to force the AJAX callback... WHY??? 
	jQuery('#list5').jqGrid('saveRow', cursel, false);
	changed = false;
	lastsel2 = cursel;
	jQuery("#unsaved").hide();
	jQuery("#reset").hide();
});

jQuery("#reset").click( function(){
	jcrop_api.setSelect(shape);
	changed = false;
	jQuery("#unsaved").hide();
	jQuery("#reset").hide();
});

</script>

<script type="text/javascript">
	var jcrop_api; // Holder for the API
	jQuery(function($){
		initJcrop();
		jQuery("#unsaved").hide();
		jQuery("#reset").hide();
				
		function initJcrop()
		{
			$('#target').Jcrop({onSelect: setCoords,
            onChange: setCoords},function(){
				jcrop_api = this;
				});
			};
		});

	function setCoords(c)
  	{
    	// variables can be accessed here as
      	// c.x, c.y, c.x2, c.y2, c.w, c.h
      	if (handleevents)
      	{
      		jQuery("#list5").setRowData( cursel, {x: Math.round(c.x * 12.5), y: Math.round(c.y * 12.5), w: Math.round(c.w * 12.5), h: Math.round(c.h * 12.5)} );
      		changed=true;
      		jQuery("#unsaved").show();
      		jQuery("#reset").show();
      	};
  	};

</script>

<img src="dummy.png" id="target" alt="Chart" />

</body>
</html>

