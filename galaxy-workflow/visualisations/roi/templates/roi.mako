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
<img id="roi-image" src="" />
<div id="roi-container">
</div>
<script defer='defer'>
	var rawUrl = '${h.url_for( controller="/datasets", action="index" )}';
	var sdoId = '${trans.security.encode_id( sdo.id )}';
	var dataUrl = rawUrl + '/' + sdoId + '/display?to_ext=json';
	
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open( "GET", dataUrl, false ); // false for synchronous request
	xmlHttp.send( null );

	var opends = JSON.parse(xmlHttp.responseText);
    document.getElementById("roi-image").src = opends['images']['availableImages'][0]['source'];
	
	opends['regions'].forEach(function(x, i){ 
		var left = x['polygon'][0][0];
		var top = x['polygon'][0][1];
		var width = x['polygon'][2][0] - x['polygon'][0][0];
		var height = x['polygon'][3][1] - x['polygon'][0][1];
		var name = x['class_name'];
		console.log(name, left, top, width, height);
		var div =  document.createElement("div");
		var span =  document.createElement("span");
		span.innerHTML = name;
		div.appendChild(span);
		document.getElementById("roi-container").appendChild(div);
		div.setAttribute("style","width:" + width + "px, "+ "height:" + height + "px, " + "top:" + top + "px, " + "left:" + left + "px");
	});
	
</script>