var injectedJS = '<script src="http://localhost:8181/renarration/resources/js/injected.js"></script>';

function annotatePage(){
	var annotator = $('body').annotator();
	annotator.annotator('addPlugin', 'AnnotoriousImagePlugin');
	annotator.annotator('addPlugin', 'Tags');		
}

function enableAnnotationOnIframe(iFrame){
	document.getElementById(iFrame).contentWindow.annotatePage();
}

// this function is used to get text of a URL
function httpGet(theUrl){
	if (window.XMLHttpRequest)
	{// code for IE7+, Firefox, Chrome, Opera, Safari
		alert('xxx');
		xmlhttp=new XMLHttpRequest();
	}
	else
	{// code for IE6, IE5
		xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange=function()
	{
		if (xmlhttp.readyState==4 && xmlhttp.status==200)
		{
			alert(xmlhttp.responseText);
			createIFrame(xmlhttp.responseText);
		}
	}
	xmlhttp.open("GET", theUrl, false );
	xmlhttp.send();    
}

// this function writes into Iframe Content Dynamically
// also adds annotation functions
function createIFrame(txt){
	//alert(txt);
	var target = document.getElementById("ReNarrationIFrame");
	target.contentDocument.write(txt+	
			'<script src="http://localhost:8181/renarration/resources/js/injected.js"></script>');
}


/*
 * These functions are both used for renarration and annotation
 * */
function goBack(){				
	window.location.href = renarration_url + 'back';
}

function setAnnotationVector(){
	Annotations = [];
	var annotationListString = document.getElementById("listOfAnnotations").value;
	var vecAnnotations = annotationListString.split("__--__");
	for(var i=0; i<vecAnnotations.length; i++){
		if(vecAnnotations[i].length>1)
			Annotations[i] = vecAnnotations[i];				
	}						
}

function hightlightElementsUsingXPath(){		
	for(var i=0; i<Annotations.length; i++){
		var temp_annotation = JSON.parse(Annotations[i]);
		if(temp_annotation.target.selector.hasOwnProperty('xpath')){					
			document.getElementById('ReNarrationIFrame').contentWindow.highlightElementsWithAnnotations(temp_annotation.target.selector.xpath);	
		}
		else{
			document.getElementById('ReNarrationIFrame').contentWindow.highlightElementsWithAnnotations(temp_annotation.target.selector.members[0].xpath);
		}
					
	}
}

function showAnnotationDivOnElement(){			
	
	var i = findAnnotationUsingXPath(Parent_mouseOverElement_XPath);
	//alert(i);
	if(i>=0){
		var annotationDiv = document.getElementById('AnnotationDiv');
		annotationDiv.style.display="none";
		annotationDiv.innerHTML=Annotations[i];
		annotationDiv.style.position='absolute';
		
		annotationDiv.style.top=Parent_mouseOverElement.offsetTop-20;
		annotationDiv.style.left=Parent_mouseOverElement.offsetLeft+180;								
	}

}

function generateUUID() {
    var d = new Date().getTime();
    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = (d + Math.random()*16)%16 | 0;
        d = Math.floor(d/16);
        return (c=='x' ? r : (r&0x3|0x8)).toString(16);
    });
    return uuid;
}

function show(a,b){
	document.getElementById(selected).style.backgroundColor = "rgb(200,200,200)";
	document.getElementById(disp).style.display = "none";    
	document.getElementById(a).style.backgroundColor = "rgb(150,150,150)";      
	document.getElementById(b).style.display = "block";
	
	selected=a;
	disp=b;
}

function getSelectionText() {
    var text = "";
    if (window.getSelection) {
        text = window.getSelection().toString();
    } else if (document.selection && document.selection.type != "Control") {
        text = document.selection.createRange().text;
    }
    return text;
}

function cancelDivChanges(){
	var divElement = document.getElementById('ReNarrationDiv');			
	
	// set Elements to null
	Parent_selectedElement = null;
	Parent_selectedElement_XPath = null;
	
	divElement.style.display = 'none';
}

function enableDiv(divID){
	//alert(divID);
	var divElement = document.getElementById(divID);
	divElement.style.visibility = 'visible';
}

function findAnnotationUsingXPath(xpath){		
	var ret_val = -1;
	//alert(Annotations.length);
	for(var i=0; i<Annotations.length; i++){
		var temp_annotation = JSON.parse(Annotations[i]);
		if(temp_annotation.target.selector.hasOwnProperty('xpath')){
			if(temp_annotation.target.selector.xpath==xpath){
				ret_val = i;
			}		
		}
		else{
			if(temp_annotation.target.selector.members[0].xpath==xpath){
				ret_val = i;
			}
		}
					
	}
	return ret_val;
}