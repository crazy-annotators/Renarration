
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
			createIFrame(xmlhttp.responseText)
		}
	}
	xmlhttp.open("GET", theUrl, false );
	xmlhttp.send();    
}

// this function writes into Iframe Content Dynamically
// also adds annotation functions
function createIFrame(txt){
	//alert(txt);
	var target = document.getElementById("renarrationDiv");
	target.contentDocument.write(txt+
			'<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>'+
			'<script src="http://assets.annotateit.org/annotator/v1.2.5/annotator-full.min.js"></script>'+	
			'<script src="http://annotorious.github.com/latest/annotorious.okfn.js"></script>'+		
			'<script src="http://localhost:8181/renarration/resources/js/re-narration.js"></script>'+
			'<link rel="stylesheet" href="http://assets.annotateit.org/annotator/v1.2.5/annotator.min.css">');
}