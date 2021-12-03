<style>
	div.roi {
		position:absolute;
		border:1px solid green;
	}

	div.roi:hover {
		background-color:green;
		opacity:0.3;
	}

	div span{
		color:red;
		font-size: 15px;
	    padding: 10px;
		background-color:white;
		display:block;
		float:left;
	}
</style>
<div id="roi-container">
	<svg id="visualisation">
		<img id="roi-image" src="" />
	</svg>
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
		var polygon = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
		polygon.setAttribute("points", "");
		x['polygon'].forEach(function(y){
			
			polygon.setAttribute("points", polygon.getAttribute("points") + " " + y.toString());
			polygon.setAttribute("class","roi");
		
		});
		document.getElementById("visualisation").appendChild(polygon);
		
	});
	
</script>