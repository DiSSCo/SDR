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
		transform-origin: 0 0;
	}
	
	#roi-container {
		width:100%;
		overflow:scroll;
		
	}

	polygon {
		fill: green;
		opacity: 0.5;
	}
	
	.poly5 { fill:hsl(6, 80%, 50%); }
	.poly10 { fill:hsl(12, 80%, 50%); }
	.poly15 { fill:hsl(18, 80%, 50%); }
	.poly20 { fill:hsl(24, 80%, 50%); }
	.poly25 { fill:hsl(30, 80%, 50%); }
	.poly30 { fill:hsl(36, 80%, 50%); }
	.poly35 { fill:hsl(42, 80%, 50%); }
	.poly40 { fill:hsl(48, 80%, 50%); }
	.poly45 { fill:hsl(54, 80%, 50%); }
	.poly50 { fill:hsl(60, 80%, 50%); }
	.poly55 { fill:hsl(66, 80%, 50%); }
	.poly60 { fill:hsl(72, 80%, 50%); }
	.poly65 { fill:hsl(78, 80%, 50%); }
	.poly70 { fill:hsl(84, 80%, 50%); }
	.poly75 { fill:hsl(90, 80%, 50%); }
	.poly80 { fill:hsl(96, 80%, 50%); }
	.poly85 { fill:hsl(102, 80%, 50%); }
	.poly90 { fill:hsl(108, 80%, 50%); }
	.poly95 { fill:hsl(114, 80%, 50%); }
	.poly100 { fill:hsl(120, 80%, 50%); }
	
	polygon:hover {
		opacity: 0.25;
		cursor: pointer;
	}
	
	#image1 {
		position: absolute;
		width:100%;
	}

	.label{
		position: absolute;
		top:0;
		left:0;
		background-color:white;
		padding:20px;
		font-family:sans-serif;
		font-size:16px;
	}
</style>
<div id="contents">
	<div id="roi-container">
		<img id="image1" />
		<svg id="visualisation">
			<image id="roi-image">
		</svg>
		<div class="label">name<br>date<br>species </label>
	</div>
</div>
<script defer='defer'>
	window.addEventListener("load", function(){
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
					
				x['polygon'].forEach(function(y, i){
					var point = svg.createSVGPoint();
					point.x = y[0];
					point.y = y[1];
					polygon.points.appendItem(point);
				});
				//polygon.setAttributeNS("http://www.w3.org/2000/svg", "fill", hsl_col_perc(x['transcription']['confidence'], 0, 120));
				var label = document.createElement("div");
				var container = document.getElementById("roi-container");
				container.appendChild(label);
				label.classList.add("label");
				var class_name = "Class name: " + x['class_name'] + "<br>";
				var region_confidence = "Region confidence: " + x['confidence'] + "<br>";
				var transcription = "Transcription: " + x['transcription']['text'] + "<br>";
				var transcription_confidence = "Transcription confidence: " + x['transcription']['confidence'] + "<br>";
				label.innerHTML = class_name + region_confidence + transcription + transcription_confidence;
				polygon.classList.add("poly" + round_up_to_nearest_5_percent(x['transcription']['confidence']));
				svg.appendChild(polygon);		
				
			});
			
			svg.setAttribute("height", img.naturalHeight);
			svg.setAttribute("width", img.naturalWidth);
			var scale = img.clientWidth / img.naturalWidth;
			svg.style.transform = "scale(" + scale + ")";
		});
		img.setAttribute("src", imageURL);
	});
	
	window.addEventListener('resize', function(event) {
		var img = document.getElementById("image1");
		var svg = document.getElementById("visualisation");
		svg.setAttribute("height", img.naturalHeight);
		svg.setAttribute("width", img.naturalWidth);
		var scale = img.clientWidth / img.naturalWidth;
		svg.style.transform = "scale(" + scale + ")";
	}, true);
	
        
	function hsl_col_perc(percent, start, end) {
	  var b = (end - start) * percent,
			c = b + start;

	  // Return a CSS HSL string
	  return 'hsl('+c+', 100%, 50%)';
	}
	
	function round_up_to_nearest_5_percent(fraction) {
		percent = fraction *100;
		return (Math.ceil(percent/5)*5) / 100;
	}
	
</script>