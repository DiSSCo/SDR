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
	
	#visualisation {
		position:absolute;
	}
	
	#roi-container {
		width:100%;
		overflow:scroll;
	}

	polygon {
		stroke: green;
		fill: green;
		opacity: 0.5;
	}
	
	polygon:hover {
		opacity: 0.25;
	}
	
	#image1 {
		position: absolute;
	}
	
	#contents span{
		position: absolute;
		top:0;
		left:0;
	}
</style>
<div id="contents">
	<div id="roi-container">
		<img id="image1" />
		<svg id="visualisation">
			<image id="roi-image">
		</svg>
	</div>
</div>
<script defer='defer'>
	var rawUrl = '${h.url_for( controller="/datasets", action="index" )}';
	var sdoId = '${trans.security.encode_id( sdo.id )}';
	var dataUrl = rawUrl + '/' + sdoId + '/display?to_ext=json';
	
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open( "GET", dataUrl, false ); // false for synchronous request
	xmlHttp.send( null );

    var opends = JSON.parse(xmlHttp.responseText);
	var imageURL = opends['images']['availableImages'][0]['source'];
    document.getElementById("roi-image").setAttributeNS("http://www.w3.org/2000/svg", 'href', imageURL);
	var img = document.getElementById("image1");

	
	img.addEventListener('load', (event) => {

		var svg = document.getElementById("visualisation");
		opends['regions'].forEach(function(x){ 
			var polygon = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
			svg.appendChild(polygon);			
			x['polygon'].forEach(function(y, i){
				var point = svg.createSVGPoint();
				point.x = y[0];
				point.y = y[1];
				polygon.points.appendItem(point);
			});
		});
		var img = document.getElementById('roi-image')
		svg.setAttribute("height", img.naturalHeight);
		svg.setAttribute("width", img.naturalWidth);
	});
	img.setAttribute("src", imageURL);

	
</script>