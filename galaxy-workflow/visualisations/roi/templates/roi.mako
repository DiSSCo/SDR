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
		opacity: 0.7;
	}
	
	.label5, .poly5 {   background-color:hsl(6, 80%, 50%);   fill:hsl(6, 80%, 50%); }
	.label10, .poly10 {  background-color:hsl(12, 80%, 50%);  fill:hsl(12, 80%, 50%); }
	.label15, .poly15 {  background-color:hsl(18, 80%, 50%);  fill:hsl(18, 80%, 50%); }
	.label20, .poly20 {  background-color:hsl(24, 80%, 50%);  fill:hsl(24, 80%, 50%); }
	.label25, .poly25 {  background-color:hsl(30, 80%, 50%);  fill:hsl(30, 80%, 50%); }
	.label30, .poly30 {  background-color:hsl(36, 80%, 50%);  fill:hsl(36, 80%, 50%); }
	.label35, .poly35 {  background-color:hsl(42, 80%, 50%);  fill:hsl(42, 80%, 50%); }
	.label40, .poly40 {  background-color:hsl(48, 80%, 50%);  fill:hsl(48, 80%, 50%); }
	.label45, .poly45 {  background-color:hsl(54, 80%, 50%);  fill:hsl(54, 80%, 50%); }
	.label50, .poly50 {  background-color:hsl(60, 80%, 50%);  fill:hsl(60, 80%, 50%); }
	.label55, .poly55 {  background-color:hsl(66, 80%, 50%);  fill:hsl(66, 80%, 50%); }
	.label60, .poly60 {  background-color:hsl(72, 80%, 50%);  fill:hsl(72, 80%, 50%); }
	.label65, .poly65 {  background-color:hsl(78, 80%, 50%);  fill:hsl(78, 80%, 50%); }
	.label70, .poly70 {  background-color:hsl(84, 80%, 50%);  fill:hsl(84, 80%, 50%); }
	.label75, .poly75 {  background-color:hsl(90, 80%, 50%);  fill:hsl(90, 80%, 50%); }
	.label80, .poly80 {  background-color:hsl(96, 80%, 50%);  fill:hsl(96, 80%, 50%); }
	.label85, .poly85 {  background-color:hsl(102, 80%, 50%); fill:hsl(102, 80%, 50%); }
	.label90, .poly90 {  background-color:hsl(108, 80%, 50%); fill:hsl(108, 80%, 50%); }
	.label95, .poly95 {  background-color:hsl(114, 80%, 50%); fill:hsl(114, 80%, 50%); }
	.label100, .poly100 { background-color:hsl(120, 80%, 50%); fill:hsl(120, 80%, 50%); }
	
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
		padding:20px;
		font-family:sans-serif;
		font-size:16px;
		display:none;
	}
</style>
<div id="contents">
	<div id="roi-container">
		<img id="image1" />
		<svg id="visualisation">
			
		</svg>
		
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
		var img = document.getElementById("image1");

		img.addEventListener('load', (event) => {

			var svg = document.getElementById("visualisation");
			opends['regions'].forEach(function(x){ 
				var polygon = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
					
				x['polygon'].forEach(function(y){
					var point = svg.createSVGPoint();
					point.x = y[0];
					point.y = y[1];
					polygon.points.appendItem(point);
				});
				
				var label = document.createElement("div");
				var container = document.getElementById("roi-container");
				container.appendChild(label);
				label.classList.add("label");
				label.classList.add("label" + round_up_to_nearest_5_percent(x['transcription']['confidence']));
				var class_name = "Class name: " + x['class_name'] + "<br>";
				var region_confidence = "Region confidence: " + x['confidence'] + "<br>";
				var transcription = "Transcription: " + x['transcription']['text'] + "<br>";
				var transcription_confidence = "Transcription confidence: " + x['transcription']['confidence'] + "<br>";
				label.innerHTML = class_name + region_confidence + transcription + transcription_confidence;
				polygon.classList.add("poly" + round_up_to_nearest_5_percent(x['confidence']));
				svg.appendChild(polygon);	

				//wire up the hover
				polygon.addEventListener("mouseover", function( event ) {
				    //get index of calling element
					var index = Array.prototype.indexOf.call(event.target.parentElement.children, this);
				    //show matching label
					document.getElementsByClassName("label")[index].style.display = "block";
				}, false);
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
	
	function round_up_to_nearest_5_percent(fraction) {
		percent = fraction *100;
		return (Math.ceil(percent/5)*5);
	}
	
</script>