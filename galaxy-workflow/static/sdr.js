var baseurl = window.location.origin 
var xmlHttp = new XMLHttpRequest();

xmlHttp.open( "GET", baseurl+"/api/workflows", false ); // false for synchronous request
xmlHttp.send( null );
var workflows = JSON.parse(xmlHttp.responseText);

xmlHttp.open( "GET", baseurl+"/api/users/current", false ); // false for synchronous request
xmlHttp.send( null );
var username = JSON.parse(xmlHttp.responseText)["username"];
var batchid = "";

var select = document.createElement("select");
select.name = "Workflows";
select.id = "Workflows"
workflows.forEach(function(element){
    var option = document.createElement("option");
    option.text = element["name"];
    option.value = element["url"];
    select.appendChild(option);
}
		 );
var label = document.createElement("label");
label.innerHTML = "Choose your workflow: "
label.htmlFor = "Workflows";

document.getElementById("wf-holder").appendChild(label).appendChild(select);
select.addEventListener('change', getWorkflowInputs);		
var event = new Event('change');
select.dispatchEvent(event);
var invocationIds = [];

var lines = "";
var index = 1;
var selectedWorkflow = "";
var start = "";
var wf = "";
var zip = new JSZip();
document.getElementById('fileinput').addEventListener('change', readSingleFile);

function InvokeWorkflow() {
    var specimen = lines[index].split(",");
    var historyId = document.getElementById("Histories").value;
    var xhr = new XMLHttpRequest();
    xhr.open("POST", selectedWorkflow + "/invocations", false);
    xhr.setRequestHeader('Content-Type', 'application/json');
    var payload = JSON.stringify({
	history: "hist_id=" + historyId,
	inputs : {
	    "Catalog number": specimen[0],
	    "Image license": specimen[1],
	    "Image URI": specimen[2],
	    "Object type": specimen[3],
	    "Rights holder": specimen[4],
	    "Institution URL": specimen[5],
	    "Higher classification": specimen[6],
	    "Person name": specimen[7],
	    "Person identifier": specimen[8],
	    "Batch id": batchid,
	    "User id": username
	},
	inputs_by: 'name'
    });
    xhr.send(payload);
    
    //save the invocation id 
    var invocationResult = JSON.parse(xhr.responseText);
    invocationIds.push(invocationResult["id"]);
    
    var span = document.createElement("span");
    span.innerHTML = (new Date().getTime() - start) + "ms > Submitting specimen " + specimen[0] + " with payload: " + payload;
    var logDiv = document.getElementById("upload_results3");
    logDiv.appendChild(span);
    logDiv.innerHTML += "<br/>";
    logDiv.scrollTop = logDiv.scrollHeight;

    
    index++;
    if(index < lines.length)
    {
	setTimeout(InvokeWorkflow, 0);
    }
    else
    {
	document.getElementById("upload_results4").style.display = "block";
	document.getElementById("spinner").style.display = "block";
	setTimeout(function() {
	    pollHistories(historyId);
	    top.document.getElementById("history-refresh-button").click();
	}, 2000);						
    }
}

function pollHistories(historyId) {			
    var url = "/api/histories/" + historyId;
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", url, false ); // false for synchronous request
    xmlHttp.send( null );
    var hist = JSON.parse(xmlHttp.responseText);
    var state_ids = hist["state_ids"];

    if(state_ids["new"].length===0 && state_ids["upload"].length===0 && state_ids["queued"].length===0 && state_ids["running"].length===0)
    {
	processResults(historyId);
    }
    else {
	setTimeout(function() {
	    pollHistories(historyId);
	}, 1000);
    }
}

function processResults(historyId){
    document.getElementById("spinner").style.display = "none";
 
    var jobId = "";
    var results = [];

    invocationIds.forEach(function(invocationId){
	var url = "/api/invocations/" + invocationId;
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open( "GET", url, false ); // false for synchronous request
	xmlHttp.send( null );
	var hist = JSON.parse(xmlHttp.responseText);
	//iterate through the steps
	jobId = hist["steps"][hist["steps"].length - 2]["job_id"]; //TODO: why does it need to be the second to last?????
	var catnum = hist["input_step_parameters"]["Catalog number"]["parameter_value"];
	//now we have the output job id	we can get the result					
	
	url = "/api/histories/" + historyId + "/contents/" + jobId + "/display";
	xmlHttp.open( "GET", url, false ); // false for synchronous request
	xmlHttp.send( null );
	var output = xmlHttp.responseText;
	results.push(output);
	//now zip them up clientside and download like this
	//https://stuk.github.io/jszip/
	zip.file(catnum + ".json", output);
    });
    let btn = document.createElement("button");
    btn.innerHTML = "Download results";
    btn.addEventListener('click', downloadResults);
    document.getElementById("upload_results4").appendChild(btn);
}

function downloadResults(evt){
    
    zip.generateAsync({type:"base64"}).then(function (base64){
	window.location = "data:application/zip;base64," + base64;
    }, 
					    function (err) {
						//do something if there's an error
					    });
}

function runWorkflows(evt) {
    
    document.getElementById("upload_results3").style.display = "block";
    selectedWorkflow = document.getElementById("Workflows").value;
    index = 1;
    start = new Date().getTime();
    
    document.getElementById("Workflows").disabled=true;
    document.getElementById("Histories").disabled=true;
    document.getElementById("fileinput").disabled=true;
    document.getElementById("upload_buttons").querySelector('button').disabled=true;
    invocationIds = [];
    batchid = Date.now();
    InvokeWorkflow();
}

function getWorkflowInputs(evt) {
    document.getElementById('wf-inputs').innerHTML = "";
    var v = evt.target.value;
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open( "GET", v, false ); // false for synchronous request
    xmlHttp.send( null );
    wf = JSON.parse(xmlHttp.responseText);
    Object.values(wf["inputs"]).forEach(function(element){
	var li = document.createElement("li");
	li.innerHTML = element["label"];
	document.getElementById('wf-inputs').appendChild(li);
    }
				       );
}

function readSingleFile(evt) {
    var f = evt.target.files[0]; 
    if (f) {
	document.getElementById("upload_results2").style.display = "block";
	var success_text = "";
	var r = new FileReader();
        r.onload = function(e) { 
	    var contents = e.target.result;
	    success_text = "File Uploaded! <br />" + "name: " + f.name + "<br />" + "type: " + f.type + "<br />" + "size: " + f.size + " bytes <br />";
	    lines = contents.split("\n"), output = [];
	    for (var i=0; i<lines.length; i++) {
		output.push("<tr><td>" + lines[i].split(",").join("</td><td>") + "</td></tr>");
	    }
	    output = "<table>" + output.join("") + "</table>";
	    document.getElementById('upload_results').innerHTML = success_text;
	    document.getElementById("upload_results").style.display = "block";
	    document.getElementById('upload_results2').innerHTML = output;
	}
	r.readAsText(f);
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open( "GET", baseurl+"/api/histories", false ); // false for synchronous request
	xmlHttp.send( null );
	var histories = JSON.parse(xmlHttp.responseText);
	var select1 = document.createElement("select");
	select1.name = "Histories";
	select1.id = "Histories"
	histories.forEach(function(element){
	    var option = document.createElement("option");
	    option.text = element["name"];
	    option.value = element["id"];
	    select1.appendChild(option);
	}
			 );
	var label1 = document.createElement("label");
	label1.innerHTML = "Choose your history: "
	label1.htmlFor = "Histories";

	document.getElementById("upload_buttons").appendChild(label1).appendChild(select1);
	document.getElementById("upload_buttons").innerHTML += "<br/>";
	
	let btn = document.createElement("button");
	btn.innerHTML = "Run workflow";
	btn.addEventListener('click', runWorkflows);
	document.getElementById("upload_buttons").appendChild(btn);
    } 
    else { 
	alert("Failed to load file");
    }
}

function loadPreviousresults() {}					

function openTab(evt, tabName) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
	tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
	tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(tabName).style.display = "block";
    evt.currentTarget.className += " active";
}

function getUserId() {
    xmlHttp.open( "GET", baseurl+"/api/users/current", false ); // false for synchronous request
    xmlHttp.send( null );
    username = JSON.parse(xmlHttp.responseText)["username"];
    
}

