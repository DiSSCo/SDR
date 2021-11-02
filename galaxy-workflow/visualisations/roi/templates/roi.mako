<link type="text/css" rel="Stylesheet" media="screen" href="/plugins/visualizations/roi/static/roi.css ">

<img src="https://raw.githubusercontent.com/DiSSCo/SDR/main/galaxy-workflow/samples/images/nhmuk-012539905.jpg" />
<div id="container">
</div>

<script defer='defer'>
	var opends_json = '{"authoritative":{"physicalSpecimenId":"asda","institution":["asd","sasa"],"materialType":"Herbarium sheet"},"images":{"availableImages":[{"source":"https://raw.githubusercontent.com/DiSSCo/SDR/main/galaxy-workflow/samples/images/nhmuk-012539905.jpg","license":"CC0"}]},"higher_classification":"asas","payloads":{"name":"original image","filename":"b0ea10dd-e024-492f-abef-857f92f4c373.jpeg","width":2160,"height":1440,"mediaType":"image/jpeg","size n":742474},"regions":[{"polygon":[[1507,258],[1906,258],[1906,565],[1507,565]],"confidence":0.98,"class_name":"scale_bar"},{"polygon":[[385,396],[1155,365],[1184,1119],[413,1150]],"confidence":0.76,"class_name":"specimen"},{"polygon":[[1496,641],[1932,641],[1932,928],[1496,928]],"confidence":0.98,"class_name":"label"},{"polygon":[[1496,1001],[2036,990],[2041,1212],[1501,1226]],"confidence":0.97,"class_name":"bar_code"}]}';

	var opends = JSON.parse(opends_json);

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
</script>