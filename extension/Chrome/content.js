// content.js

var renarration_enabled = 0;
var target_element;
var target_element_style_border="";
var annotations;
var renarrations;
var renarrationDiv;

chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    if( request.message === "clicked_browser_action" ) {
		if(renarration_enabled == 1){
			alert("Renarration disabled!");
			renarration_enabled = 0;
		}
		else{
			renarration.createRenarrationDiv();
			alert("Renarration enabled!");
			renarration_enabled = 1;
		}				
    }
  }
);

$('body').click(function(event) {
	if(renarration_enabled == 1 && window.event.srcElement.id!='renarrationDiv' && !renarration.isDescendant(renarrationDiv, window.event.srcElement)){
		target_element = window.event.srcElement;
		
		renarration.updateRenarrationDivStyle(target_element.innerHTML, '20%', '100%', '80%', '0%', 'block');
   }
});

$('body').mouseover(function(event) {
	if(renarration_enabled == 1 && window.event.srcElement.id!='renarrationDiv' && !renarration.isDescendant(renarrationDiv, window.event.srcElement)){
		target_element = window.event.srcElement;
		target_element_style_border = target_element.style.border; 
		target_element.style.border ='2px dashed red';
	}
});

$('body').mouseout(function() {
	if(renarration_enabled == 1){
		target_element.style.border = target_element_style_border;
	}
});

annotation = {
	getAnnotations: function(){
		alert("Emrah");
	},
	createHTMLFromAnnotations: function(){
		
	}
}

selector = {
	getElementByXPath: function(xpath){
		
	},
	getElementByCss: function(css){
		return document.querySelectorAll(css);
	}
}

renarration = {
	getXPath: function(element) {
		if (element===document.body)
			return '//html[1]/' + element.tagName.toLowerCase() + '[1]';

		var ix= 0;
		var siblings= element.parentNode.childNodes;
		
		for (var i= 0; i<siblings.length; i++) {
			var sibling= siblings[i];
			if (sibling===element)
				return renarration.getXPath(element.parentNode)+'/'+element.tagName.toLowerCase()+'['+(ix+1)+']';
			if (sibling.nodeType===1 && sibling.tagName===element.tagName)
			ix++;
		}
	},
	createRenarrationDiv: function(){
		var div = document.createElement( 'div' );
		document.body.appendChild( div );
		// Renarration Div ID
		div.setAttribute("id", "renarrationDiv");
		// Renarration Div Style
		div.style.position = 'fixed';
		div.style.top = '0%';
		div.style.left = '97%';
		div.style.width = '3%';   
		div.style.height = '3%';
		div.style.backgroundColor = '#f5f5ef';
		div.style.display = 'block';
		div.innerHTML = '<center><<</center>';
		renarrationDiv = div;
	},
	updateRenarrationDivStyle: function(innerHTML, width, height, left, top, display){
		document.getElementById("renarrationDiv").remove;
		var div = document.createElement( 'div' );
		document.body.appendChild( div );
		// Renarration Div ID
		div.setAttribute("id", "renarrationDiv");
		// Renarration Div Style
		div.className = 'wrap2';
		div.innerHTML = '<b>Renarration</b><br>' + innerHTML;
		renarrationDiv = div;
	},
	renarrateSubDiv: function(content){
		var mainDiv = document.createElement( 'renarrationDiv' );
		var renarrateSubDiv = document.createElement('div');
		renarrateSubDiv.setAttribute("id", "renarrateSubDiv");
		

	},
	isDescendant: function(parent, child) {
		var node = child.parentNode;
		while (node != null) {
			if (node == parent) {
				return true;
			}
			node = node.parentNode;
		}
		return false;
	}
}