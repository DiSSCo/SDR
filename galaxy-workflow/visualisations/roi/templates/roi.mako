<style>
	div.roi {
		position:absolute;
		stroke:1px solid green;
	}

	div.roi:hover {
		fill:green;
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
	svg#visualisation {
		width:100%;
		heighth:100%;
	}
</style>
<div id="roi-container">
	<svg id="visualisation">
		<image id="roi-image" href="" />
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
    document.querySelector("image").setAttributeNS('http://www.w3.org/1999/xlink', 'href', opends['images']['availableImages'][0]['source']);
	
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