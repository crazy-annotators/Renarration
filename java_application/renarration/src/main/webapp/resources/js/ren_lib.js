//////////////////////////////////////////////////////////////////////////////////
// changed functions
////////////////////////////////////////////////////////////////////////////////
function applyRenarration(){
	var action = document.getElementById('action');
	var selectedText = document.getElementById('selectedText');
	var tempTransform = transform;
	var dt = new Date();	

	
	tempTransform["@id"] = generateUUID();
	tempTransform.createdAt = dt.toISOString();
    
	
	if(action.value=="Remove"){
		Parent_selectedElement.style.display = "none";
		tempTransform.action = "oa:Remove";
		
		// selection
		tempTransform.selection = source_selection;
		tempTransform.selection.value = "#xpointer(" + Parent_selectedElement_XPath + ")";
		tempTransform.selection["@id"] = generateUUID();
		tempTransform.narration = "";
		//tempTransform.audience = [];
		
		//alert(JSON.stringify(renarration_template));
		transforms[transformLength] = JSON.stringify(tempTransform);
		transformLength = transformLength + 1;
	}
	else{
		if(Parent_selectedElement.tagName=="IMG"){
			var elm_ren_type = document.getElementById('renarration_type0');
			var cur_ren_type  = elm_ren_type.options[elm_ren_type.selectedIndex].value;
			var audience_elem = document.getElementById('audience_type0');
			var audience_type  = audience_elem.options[audience_elem.selectedIndex].value;
			
			if(cur_ren_type == "image"){
				Parent_selectedElement.src = document.getElementById('image_identifier0').value;
				
				tempTransform.action = "oa:Replace";
		
				// selection
				tempTransform.selection = source_selection;
				tempTransform.selection.value = "#xpointer(" + Parent_selectedElement_XPath + ")";
				tempTransform.selection["@id"] = generateUUID();
				
				// image renarration
				tempTransform.narration = visual_content;
				tempTransform.narration["@id"] = document.getElementById('image_identifier0').value;
				tempTransform.narration["@type"] = "dctypes:Image";																	
				
				if(audience_type.length>0){
					tempTransform.audience = [audience_type];
				}
				
				transforms[transformLength] = JSON.stringify(tempTransform);
				transformLength = transformLength + 1;				
				
			}
			else{
				alert('Please provide a url for the image!');
			}
			
		}else{
				tempTransform.action = "oa:Replace";
				var narrations = [];
				var narrationslength = 0;
				renarrationHTML = "<div id=\"renarration\">";
				for(var i=0; i<=rn_collection_num; i++){
					var elm_ren_type = document.getElementById('renarration_type' + i);
					var cur_ren_type  = elm_ren_type.options[elm_ren_type.selectedIndex].value;
					
					var audience_elem = document.getElementById('audience_type' + i);
					var audience_type  = audience_elem.options[audience_elem.selectedIndex].value;
					var audience;
					
					if(audience_type.length>0){
						audience = [audience_type];
					}
					else {
						audience = [];
					}
					
					if(cur_ren_type == "embedded"){
						renarrationHTML = renarrationHTML + "<p>" + document.getElementById('embedded_text' + i).value + "</p>";
						
						// json-ld
						var id = generateUUID();
						var embedcontent = document.getElementById('embedded_text' + i).value;
						//alert(document.getElementById('annotation_id' + i).value);
						var temp = "";
						var annotation_id = document.getElementById('annotation_id' + i).value;
						
						if(annotation_id.length > 0){
							temp = JSON.stringify({"@id" : id, "@type":"cnt:ContentAsText", "content":embedcontent, "accessedFrom" : {"@id" : annotation_id, "@type" : "oa:Annotation"}});
						}
						else{
							temp = JSON.stringify({"@id" : id, "@type":"cnt:ContentAsText", "content":embedcontent});
						}
						
						 //var temp = JSON.stringify({"@id" : id, "@type":"cnt:ContentAsText", "content":embedcontent});
						 narrations[narrationslength] = temp;
						 narrationslength = narrationslength + 1;
						
					}
					else if(cur_ren_type == "image"){
						renarrationHTML = renarrationHTML + "<img src=\""+ document.getElementById('image_identifier' + i).value +"\">";
						
						narrations.push(JSON.stringify({"@id" : document.getElementById('image_identifier' + i).value, "@type":"dctypes:Image"}));
					}
					else if(cur_ren_type == "audio"){
						renarrationHTML = renarrationHTML + "<audio controls><source src=\""+document.getElementById('audio_identifier' + i).value+"\">Your browser does not support the audio element.</audio>";								
					
						narrations.push(JSON.stringify({"@id" : document.getElementById('audio_identifier' + i).value, "@type":"dctypes:Sound"}));
					}
					else if(cur_ren_type == "video"){
						renarrationHTML = renarrationHTML + "<video controls><source src=\""+document.getElementById('video_identifier' + i).value+"\">Your browser does not support the video tag.</video>";						
					
						narrations.push(JSON.stringify({"@id" : document.getElementById('video_identifier' + i).value, "@type":"dctypes:MovingImage"}));
					}
				}
				renarrationHTML = renarrationHTML + "</div>";				
				
				if(rn_collection_num==0){
					//alert(JSON.parse(narrations[0]));
					tempTransform.narration = JSON.parse(narrations[0]);
				}
				else{
					//alert(narrations.length);
					var list = "[" + narrations[0];
					for(var k=1; k<narrations.length; k++){
							list = list + "," + narrations[k];							
					}
					list = list + "]";
					tempTransform.narration = JSON.parse('{"@id" : "' + generateUUID() +'", "@type" : "rn:List", "nodes" : ' + list + '}');
					 
				}
				
				if('undefined' == typeof selectedText.value || selectedText.value=="" || selectedText.value.length==0){	
					Parent_selectedElement.innerHTML = renarrationHTML;
					
					tempTransform.selection = source_selection;
					tempTransform.selection.value = "#xpointer(" + Parent_selectedElement_XPath + ")";
					tempTransform.selection["@id"] = generateUUID();
				}
				else{
					var oldHTML = Parent_selectedElement.innerHTML;
					var elm_ren_type = document.getElementById('renarration_type0');
					var cur_ren_type  = elm_ren_type.options[elm_ren_type.selectedIndex].value;
					if(rn_collection_num==0 && cur_ren_type == "embedded"){
						
						Parent_selectedElement.innerHTML = oldHTML.replace(new RegExp(selectedText.value,"gm"),document.getElementById('embedded_text0').value);
					}
					else{
						Parent_selectedElement.innerHTML = oldHTML.replace(new RegExp(selectedText.value,"gm"),renarrationHTML);
					}
					
					
					tempTransform.selection = source_list_selection;
					tempTransform.selection["@id"] = generateUUID();
					tempTransform.selection.nodes =  [{
								"@id" : generateUUID(),
								"@type" : "rn:XPathSelector",
								"value" : "#xpointer(" + Parent_selectedElement_XPath + ")"
							},
						    {
								"@id" : generateUUID(),
								"@type" : "rn:PrefixSuffixSelector",
								"prefix" : "",
								"suffix" : "",
								"text" : selectedText.value 
							}];
				}
				
				transforms[transformLength] = JSON.stringify(tempTransform);
				transformLength = transformLength + 1;
		}
	}
	
	closeRenarrationDiv();
	clearAndHideSelectionTextDiv();
	//writeTransformArray();
}

function writeTransformArray(){
	var transform_value = document.getElementById('transforms');
	var str = "";
 for(var i=0; i<transforms.length; i++){
	 str = str + transforms[i];
 }	
 transform_value.value = str;
}

function setSelectionText(){
	var action = document.getElementById('action');
	if(action.value!="Remove"){
		var selectedText = document.getElementById('selectedText');
		selectedText.value=getSelectionText();
		var selectedTextDiv = document.getElementById('selectedTextDiv');
		selectedTextDiv.innerHTML = "<b>Selected Text</b><br>" + selectedText.value + "<br><br>" + 
									"<div onclick='clearAndHideSelectionTextDiv();' style='width:100px;cursor:pointer;border: solid 2px black;'>Clear Selection</div>";
		selectedTextDiv.style.display="block";
	}
}

function clearAndHideSelectionTextDiv(){
	var selectedText = document.getElementById('selectedText');
    selectedText.value="";
	var selectedTextDiv = document.getElementById('selectedTextDiv');
	selectedTextDiv.style.display="none";
}

function closeRenarrationDiv(){
	var divElement = window.parent.document.getElementById('ReNarrationDiv');
	rn_collection_num = 0;
	divElement.style.display = 'none';
	
	var actionElement = document.getElementById('action');
	actionElement.selectedIndex = 0;	
}

function removeOrReplace(){
	var action = document.getElementById('action');
	if(action.value=="Remove"){
		clearAndHideSelectionTextDiv();
		var rnContent = document.getElementById('dynamic_content');
		rnContent.innerHTML = "";
	}
	else{
		var rnContent = document.getElementById('dynamic_content');
		rnContent.innerHTML = renarrationContent();
	}
}

function renarrationContent(){
	return rn_dyn_content.replace(/=nth=/g, rn_collection_num);
}

function enableDivRenarration(ith){
	// first make all elements invisible
	var div1 = document.getElementById('embedded' + ith);
	var div2 = document.getElementById('image' + ith);
	var div3 = document.getElementById('audio' + ith);
	var div4 = document.getElementById('video' + ith);
	var div5 = document.getElementById('audience' + ith);
	
	div1.style.display = 'none';
	div2.style.display = 'none';
	div3.style.display = 'none';
	div4.style.display = 'none';
	div5.style.display = 'none';
	
	var divRT = document.getElementById('renarration_type' + ith);
	var divE = document.getElementById(divRT.options[divRT.selectedIndex].value + ith);
	divE.style.display = 'block';
	
	//div5.style.display = 'block';
}

function getDBPediaReferenceData(){
	for(var i=0; i<Annotations.length; i++){
		var jsonData = JSON.parse(Annotations[i]);
		if(jsonData.body["@id"].indexOf("dbpedia")>=0){
			getReferenceDataFromDBPedia(i);
		}
	}
}

function setAnnotationId(annotationID){
	var selectedText = getSelectionText();
	var annotation_id_element = document.getElementById('annotation_id' + rn_collection_num);
	var embeddedText = document.getElementById('embedded_text' + rn_collection_num);
	
	var renarrationType = document.getElementById('renarration_type' + rn_collection_num);
	annotation_id_element.value = annotationID;
	embeddedText.value = selectedText;	
	
	renarrationType.selectedIndex = 1;
	
	enableDivRenarration(rn_collection_num);
}

function addTransform(){
	rn_collection_num = rn_collection_num + 1;
	var rnContent = document.getElementById('dynamic_content');
	//rnContent.innerHTML = rnContent.innerHTML + renarrationContent();
	
	var newdiv = document.createElement('span');
	newdiv.setAttribute('id','span' + rn_collection_num);
	newdiv.innerHTML = renarrationContent();
	rnContent.appendChild(newdiv);
}

function deleteTransform(nth){
	if(rn_collection_num>nth){
		alert('You can start deleting only from the last transform!');
	}
	else if(nth==0){
		alert('There must be at least one transform');
		
	}else{		
		var elem = document.getElementById("span"+nth);
		elem.parentElement.removeChild(elem);
		rn_collection_num = rn_collection_num - 1;
	}
}

function getListOfAnnotations(){		
	var result = "<table><tr><td><b>List Of Annotations</b></td></tr>";
	//alert(Annotations.length);
	for(var i=0; i<Annotations.length; i++){
		var jsonData = JSON.parse(Annotations[i]);
		result = result + "<tr onmouseup=\"setAnnotationId('"+jsonData["@id"]+"')\"><td> annotated by " + jsonData.annotatedBy.name + " at <font color=\"red\">" + jsonData.annotatedAt + "</font>";

		var objects = Object.keys(jsonData.body);
		//alert("Emrah");
		for(var j=0; j<objects.length; j++){
			if(objects[j]!="@id"){
				result = result + "<div style=\"display:block;\">";
				
				if(objects[j]=="@type" || objects[j]=="value"){
					result = result + "<div style=\"display:inline-block;width:100px;\"><a href=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">" + objects[j] + "</a> : </div>";
				}
				
				else if(objects[j]=="format" || objects[j]=="language"){
					result = result + "<div style=\"display:inline-block;width:100px;\"><a href=\""+ namespaces["dc"] + "\">" + objects[j] + "</a> : </div>";
				}				
				
				else if(objects[j].indexOf(":")>=0){
						result = result + "<div style=\"display:inline-block;width:100px;\"><a href=\""+ namespaces[objects[j].split(":")[0]] + "\">" + objects[j] + "</a> : </div>";
				}
				
				if(jsonData.body[objects[j]].indexOf("oa:")>=0){
					result = result + "<div style=\"display:inline-block;width:100px;\"><a href=\""+ namespaces["oa"] + "\">" + jsonData.body[objects[j]] + "</a></div><br>";
				}
				else {
					result = result + "<div style=\"display:inline-block;width:100px;\">" + jsonData.body[objects[j]] + "</div><br>";
				}
				
				result = result + "</div>";
			}
			//alert(objects[j] + jsonData.body[objects[j]]);			
		}
		
		if(jsonData.body["@id"].indexOf("dbpedia")>=0){
			result = result + "<div style=\"display:inline-block;\"><input style=\"display:none;\" type\"text\" id=\"ref_text_dbpedia"+i+"\" value=\""+jsonData.body["@id"]+"\"><b>Referenced Data from DBPedia :</b> <br><div id=\"ref_dbpedia_"+i+"\">xxx</div></div>";
		}
		
		result = result +  "</td></tr>";	
	}
	return result+"</table>";
}

function setContentInDiv(){
	//var xpath = document.getElementById('selectedElementXPath');
	//xpath.innerHTML = '<b>Selected Element</b> : ' + Parent_selectedElement_XPath;
	
	var xpathAnnotation = document.getElementById('selectedElementXPathAnnotation');
	xpathAnnotation.innerHTML = '<b>Selected Element</b> : ' + Parent_selectedElement_XPath;
	if(Parent_selectedElement.tagName=="IMG"){	
		imgString = "<img id= 'annotated_image' onclick='setPos()' onmousemove='followMe()' src='"+Parent_selectedElement.src+"'>";
		setPosFlag = -1;
		annotated_imageID = "annotated_image";
		annotationDIV = "contentFromIFrameAnnotation";
		document.getElementById('contentFromIFrameAnnotation').innerHTML=imgString;				
	}
	else{
		var contentAnnotation = document.getElementById('contentFromIFrameAnnotation');
		contentAnnotation.addEventListener ("mouseup", function () {setSelectionText()}, false);
		contentAnnotation.innerHTML=Parent_selectedElement.innerHTML;
	}
	
	// display Annotation List
	var annotationListDiv = document.getElementById('annotationList');
	
	annotationListDiv.style.visibility='visible'; 
	annotationListDiv.innerHTML = getListOfAnnotations();
	getDBPediaReferenceData();
	
	var rnContent = document.getElementById('dynamic_content');
	rnContent.innerHTML = renarrationContent();
}

function saveRenarration(){				
	var popup = document.getElementById("popup");
	var target_audience_span = document.getElementById("target_audience_span");
	target_audience_span.innerHTML = target_audience.replace(/=nth=/g, "-1");
	
	popup.style.display = "block";
	target_audience_span.style.display = "block"
}

function commitRenarration(){			
	var dt = new Date();
	var renarratedAt = dt.toISOString();
	var id = generateUUID();
	var audience_elem = document.getElementById('audience_type-1');
	var audience_type  = audience_elem.options[audience_elem.selectedIndex].value;
	var sourceURL = document.getElementById('remoteURL').value;
	var targetURI = document.getElementById('renarration_name').value;
	var renarrator_name = document.getElementById('name').value;
	var renarrator_email = document.getElementById('email').value;
	var renarrator_userId = document.getElementById('userId').value;
	
	renarration_template["@id"] = id;
	renarration_template.renarratedAt = renarratedAt;
	renarration_template.audience = [audience_type];
	renarration_template.source = {"@id" : sourceURL, "@type" : ["foaf:Page", "rn:Document"]};
	if(targetURI.length>0){
		renarration_template.target = {"@id" : renarration_url + "resources/renarrated/" + targetURI + ".html", "@type" : ["foaf:Page", "rn:Document"]};
	}
	renarration_template.transform["@id"] = generateUUID();
	renarration_template.renarrator.name = renarrator_name;
	renarration_template.renarrator["@id"] = renarrator_userId;
	
	//set motivations
	var motivations = [];
	var motivations_idx = 0;
	for (i = 1; i<=4; i++) {
		checkbox_elem = document.getElementById('motivation_'+i);
		if(checkbox_elem.checked){
			motivations[motivations_idx] = checkbox_elem.value;
			motivations_idx = motivations_idx + 1;
			checkbox_elem.checked = false;
		}
	}	
	renarration_template.motivation = motivations;	

	for(var i=0; i<transforms.length; i++){
		renarration_template.transform.nodes.push(JSON.parse(transforms[i]));
	}	
	
	var renarrationText = JSON.stringify(renarration_template);
	var myIFrame = document.getElementById("ReNarrationIFrame");    
	var iframeContent = "<html><head>" + myIFrame.contentWindow.document.head.innerHTML + "</head><body>" + myIFrame.contentWindow.document.body.innerHTML +  "</body></html>";    
	
	document.getElementById("renarrationText").value = renarrationText;
	document.getElementById("renarrationHTML").value = iframeContent.replace(renarration_url + "resources/js/injected.js", "");
	if(targetURI.length>0){
		document.getElementById("fileName").value = targetURI + ".html";
	}
	
	
	deselectRenarrationDetails();
	closeRenarrationPopup();
	saveRenarrationCollection();
}

function deselectRenarrationDetails(){
	var audience_elem = document.getElementById('audience_type-1');
	var targetURI = document.getElementById('renarration_name');
	
	targetURI.value = "";
	audience_elem.selectedIndex = 0;
}

function saveRenarrationCollection(){
	var renarrationForm = document.getElementById("RenarrationForm");
				
	renarrationForm.submit();
}

function closeRenarrationPopup(){
	var popup = document.getElementById("popup");
	popup.style.display = "none";
}