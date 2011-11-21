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
<br />
<a href="#" id="a1">Get data from selected row</a>
<br />
<a href="#" id="a2">Delete row 2</a>
<br />
<a href="#" id="a3">Update amounts in row 1</a>
<br />
<a href="#" id="a4">Add row with id 99</a>
<br />

<script type="text/javascript">
var lastsel2;
var cursel;
var handleevents;
jQuery("#list5").jqGrid({
   	url:'chartlist.php', 
			datatype: "json", 
			colNames:['ID','Chart nr.','Inset', 'Type', 'Title','Scale', 'X', 'Y', 'Width', 'Height'], 
			colModel:[
			{name:'id',index:'id', width:50}, 
			{name:'number',index:'number', width:50, sorttype:"int", editable: true}, 
			{name:'inset_id',index:'inset_id', width:40, editable: true,edittype:"select",editoptions:{value:"A:A;B:B;C:C;D:D;E:E;F:F;G:G;H:H;I:I;J:J;K:K;L:L;M:M;N:N;O:O;P:P;Q:Q;R:R;S:S;T:T;U:U;V:V;W:W;X:X;Y:Y;Z:Z"}},
			{name:'bsb_type',index:'bsb_type', width:70, editable: true,edittype:"select",editoptions:{value:"INSET:INSET;PLAN:PLAN;PANEL:PANEL"}}, 
			{name:'title',index:'title', width:400, sortable:false, editable:true}, 
			{name:'scale',index:'scale', width:80,align:"right", sorttype:"int", editable: true}, 
			{name:'x',index:'x', width:50,align:"right", sorttype:"int"}, 
			{name:'y',index:'y', width:50,align:"right", sorttype:"int"}, 
			{name:'w',index:'w', width:50,align:"right", sorttype:"int"}, 
			{name:'h',index:'h', width:50,align:"right", sorttype:"int"}
			],
			onSelectRow: function(id){
				cursel=id;
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
						jcrop_api.setSelect([x, y, x2, y2]);
					};
					handleevents=true;
				});
				
				/*
				if(id && id!==lastsel2){ 
					jQuery('#list5').jqGrid('restoreRow',lastsel2); 
					jQuery('#list5').jqGrid('editRow',id,true); 
					lastsel2=id; 
				}
				else if(id){
					jQuery('#list5').jqGrid('saveRow', lastsel2); 
				}
				*/
			},
			height:300,
			rowNum:20,
   			rowList:[20,50,100],
		   	pager: '#pager5',
		   	sortname: 'id',
			viewrecords: true,
			sortorder: "desc",
    			caption:"Simple data manipulation",
			editurl:"someurl.php" 
});
jQuery("#list5").jqGrid('navGrid',"#pager5",{edit:true,add:true,del:false});
jQuery("#a1").click( function(){
	var id = jQuery("#list5").jqGrid('getGridParam','selrow');
	if (id)	{
		var ret = jQuery("#list5").jqGrid('getRowData',id);
		alert("id="+ret.id+" invdate="+ret.invdate+"...");
	} else { alert("Please select row");}
});
jQuery("#a2").click( function(){
	var su=jQuery("#list5").jqGrid('delRowData',12);
	if(su) alert("Succes. Write custom code to delete row from server"); else alert("Allready deleted or not in list");
});
jQuery("#a3").click( function(){
	var su=jQuery("#list5").jqGrid('setRowData',11,{amount:"333.00",tax:"33.00",total:"366.00",note:"<img src='images/user1.gif'/>"});
	if(su) alert("Succes. Write custom code to update row in server"); else alert("Can not update");
});
jQuery("#a4").click( function(){
	var datarow = {id:"99",invdate:"2007-09-01",name:"test3",note:"note3",amount:"400.00",tax:"30.00",total:"430.00"};
	var su=jQuery("#list5").jqGrid('addRowData',99,datarow);
	if(su) alert("Succes. Write custom code to add data in server"); else alert("Can not update");
});
	
	
</script>

<script type="text/javascript">
	var jcrop_api; // Holder for the API
	jQuery(function($){
		initJcrop();
				
		function initJcrop()
		{
			//$('.requiresjcrop').hide();
			$('#target').Jcrop({onSelect: setCoords,
            onChange: setCoords},function(){
				//$('.requiresjcrop').show();
				jcrop_api = this;
				//jcrop_api.animateTo([100,100,400,300]);
				//$('#can_click,#can_move,#can_size').attr('checked','checked');
				//$('#ar_lock,#size_lock,#bg_swap').attr('checked',false);
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
      	};
  	};

</script>

<img src="dummy.png" id="target" alt="Flowers" />

</body>
</html>

