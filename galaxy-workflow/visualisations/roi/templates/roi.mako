<script type="text/javascript" src="/static/jquery.min.js"></script>
<style>
	div.roi {
		position:absolute;
		border:3px solid red;
	}
	div.roi:hover {
		border:3px solid yellow;
	}
	#roi-container div span{
		color:red;
		font-size: 15px;
		  padding: 10px;
		  background-color:white;
		  display:block;
		  float:left;
	}
</style>
hello world
<h1>${sdo.name | h} | ${visualization_name}</h1>
<img id="roiImage" src="" />
<div id="container">
</div>
<script defer='defer'>
	var rawUrl = '${h.url_for( controller="/datasets", action="index" )}';
	var sdoId = '${trans.security.encode_id( sdo.id )}';
	var dataUrl = rawUrl + '/' + sdoId + '/display?to_ext=json';
	
	$.ajax(dataUrl, {
		        dataType    : 'text',
		        success     : parseJson
		    });
	function parseJson( data ) {
	

	    var opends = JSON.parse(data);
	alert(opends['regions']);
		opends['regions'].forEach(function(x, i){ 
		var left = x['polygon'][0][0];
		var top = x['polygon'][0][1];
		var width = x['polygon'][2][0] - x['polygon'][0][0];
		var height = x['polygon'][3][1] - x['polygon'][0][1];
		var name = x['class_name'];
		console.log(name, left, top, width, height);
		var div = $('<div class="roi"><span>test</span></div>').width(width).height(height).css({top: top, left: left});
		$('#roi-container').append(div);
		$(div).children().first().text(name)		
	});
	}
</script>