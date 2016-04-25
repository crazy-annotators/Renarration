		// variables used
		var mouseOverElement, mouseOverElementStyleBorderColor, mouseOverElementStyleBorder;
		var mouseOutElement;
		var clickedElement;
		
		// Window Event Listeners
		window.addEventListener("mousedown", bodyMouseDown, false);
		window.addEventListener("mouseover", bodyMouseOver, false);
		window.addEventListener("mouseout", bodyMouseOut, false);
		// Window Event Listeners
		
		// Event Listener Functions
		function bodyMouseOver(event){
			mouseOverElement = event.target;
			if(getPathTo(mouseOverElement).toLowerCase()!='//html[1]/body[1]'){
				mouseOverElementStyleBorderColor = mouseOverElement.style.borderColor;
				mouseOverElementStyleBorder = mouseOverElement.style.border; 
				mouseOverElement.style.border ='2px dashed red';
			}
			
			window.parent.Parent_mouseOverElement = mouseOverElement;
			window.parent.Parent_mouseOverElement_XPath = getPathTo(mouseOverElement).toLowerCase();			
			//window.parent.showAnnotationDivOnElement();			
		}
		
		function bodyMouseOut(event){
			mouseOutElement = event.target;
			if(window.parent.type=="annotation"){
				if(window.parent.findAnnotationUsingXPath(getPathTo(mouseOutElement).toLowerCase())>=0){
					if(getPathTo(mouseOutElement).toLowerCase()!='//html[1]/body[1]'){
						mouseOutElement.style.borderColor = 'yellow';
						mouseOutElement.style.border ='2px solid yellow';
					}
				}
				else{
					if(getPathTo(mouseOutElement).toLowerCase()!='//html[1]/body[1]'){
						mouseOutElement.style.borderColor = mouseOverElementStyleBorderColor;
						mouseOutElement.style.border = mouseOverElementStyleBorder;
					}
				}
			}
			else{
				if(getPathTo(mouseOutElement).toLowerCase()!='//html[1]/body[1]'){
					mouseOutElement.style.borderColor = mouseOverElementStyleBorderColor;
					mouseOutElement.style.border = mouseOverElementStyleBorder;
				}
			}
			//window.parent.hideAnnotationDivOnElement();
			//alert(currentElement.innerHTML);
		}		
		/*
		function bodyMouseOut(event){
			mouseOutElement = event.target;
				if(window.parent.findAnnotationUsingXPath(getPathTo(mouseOutElement).toLowerCase())>=0){
					if(getPathTo(mouseOutElement).toLowerCase()!='//html[1]/body[1]'){
						mouseOutElement.style.borderColor = 'yellow';
						mouseOutElement.style.border ='2px solid yellow';
					}
				}
				else{
					mouseOutElement.style.borderColor = mouseOverElementStyleBorderColor;
					mouseOutElement.style.border = mouseOverElementStyleBorder;
				}
			//window.parent.hideAnnotationDivOnElement();
			//alert(currentElement.innerHTML);
		}	*/	
		function bodyMouseDown(event){
			clickedElement = event.target;
			window.parent.Parent_mouseOverElement = clickedElement;
			var x = new Number();
			var y = new Number();
			if (event.x != undefined && event.y != undefined)
			{
				x = event.x;
				y = event.y;
			}
			else // Firefox method to get the position
			{
				x = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft;
				y = event.clientY + document.body.scrollTop + document.documentElement.scrollTop;
			}

			//alert(clickedElement.innerHTML);
			//alert(getPathTo(clickedElement).toLowerCase());
			updateParentDiv();
			//updateElementContent(getElementByXpath(getPathTo(clickedElement).toLowerCase()));
		}
		// Event Listener Functions
		
		// Library Functions
		function updateElementContent(element){
			element.innerHTML = 'This is a test';
		}

		function getPathTo(element) {
			//if (element.id!=='')
				//return 'id("'+element.id+'")';
			if (element===document.body)
				return '//html[1]/' + element.tagName + '[1]';

			var ix= 0;
			var siblings= element.parentNode.childNodes;
			for (var i= 0; i<siblings.length; i++) {
				var sibling= siblings[i];
				if (sibling===element)
					return getPathTo(element.parentNode)+'/'+element.tagName+'['+(ix+1)+']';
				if (sibling.nodeType===1 && sibling.tagName===element.tagName)
					ix++;
			}
		}	

		function getElementByXpath(path){
			return document.evaluate(path, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
			//alert( getElementByXpath("//html[1]/body[1]/h1[1]").innerHTML );
		}
		
		function updateParentDiv(){
			var divElement = window.parent.document.getElementById('ReNarrationDiv');
			//var divElementIFrameContent = window.parent.document.getElementById('contentFromIFrame');
			divElement.style.display = 'block';
			// set parent element
			window.parent.Parent_selectedElement = clickedElement;
			window.parent.Parent_selectedElement_XPath = getPathTo(clickedElement).toLowerCase();
			window.parent.setContentInDiv();
			//alert(divElement.innerHTML);
			
		}
		
		function highlightElementsWithAnnotations(xpath){
			elem = getElementByXpath(xpath);
			elem.style.borderColor = 'yellow';
			elem.style.border ='2px solid yellow';
		}