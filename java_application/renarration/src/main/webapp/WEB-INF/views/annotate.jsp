<?xml version="1.0" encoding="utf-8"?>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta charset="UTF-8">
	<title>Annotation - Renarration Prototype</title>
	
	<!-- Java Script Includes -->
	<script src="/renarration/resources/js/re-narration.js"></script>
	<script src="/renarration/resources/js/img_annotation.js"></script>
	<script src="/renarration/resources/js/tinymce/tinymce.min.js"></script>
	<script src="/renarration/resources/js/jquery-2.1.4.js"></script>
	<!-- Java Script Includes -->
	
	<!-- CSS Includes -->
	<link rel="stylesheet" href="/renarration/resources/css/ReNarration.css">
	<link rel="stylesheet" href="/renarration/resources/css/annotationList.css">
	<!-- CSS Script Includes -->

	<script>  
   	function getClassesAjaxPost() {  
        
    	var ont = $('#ontology').val().replace("#", "%23");    
    	
		$("#ontology_classes").html("");
    	$.ajax({  
     		type : "Get",   
     		url : "getClassesAjaxPost",   
     		data : "ont=" + ont,  
     		success : function(response) {  
     			$("#ontology_classes").css("visibility", "visible");
    	 		$("#ontology_classes").html(response);    	 		
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>
   	
	<script>  
   	function getDataPropertiesAjaxPost() {  
        
    	var ont_class = $('#ont_class').val().replace("#", "%23");
		var ont_spl = ont_class.split("==");
    	
		$("#ontology_data_property").html("");
		$("#ontology_object_property").html("");
		$("#ontology_data_property").css("visibility", "hidden");
		$("#ontology_object_property").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "getDataPropertiesAjaxPost",   
     		data : "ont=" + ont_spl[0] + "&ont_class=" + ont_spl[1],   
     		success : function(response) {  
     			$("#ontology_data_property").css("visibility", "visible");
    	 		$("#ontology_data_property").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>      	   	
   	
	<script>  
   	function getObjectPropertiesAjaxPost() {  
        
    	var ont_class = $('#ont_class').val().replace("#", "%23");
		var ont_spl = ont_class.split("==");
    	
		$("#ontology_object_property").html("");
		$("#ontology_data_property").html("");
		$("#ontology_object_property").css("visibility", "hidden");
		$("#ontology_data_property").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "getObjectPropertiesAjaxPost",   
     		data : "ont=" + ont_spl[0] + "&ont_class=" + ont_spl[1],   
     		success : function(response) {  
     			$("#ontology_object_property").css("visibility", "visible");
    	 		$("#ontology_object_property").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>     	
   	
	<script>  
   	function getObjectClassesAjaxPost() {  
        
    	var ont_class = $('#ont_class').val().replace("#", "%23");
		var ont_spl = ont_class.split("==");
    	var object_property = $('#ont_object_property').val().replace("#", "%23");
    	
		$("#object_type").html("");
		$("#object_type").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "getObjectClassesAjaxPost",   
     		data : "ont=" + ont_spl[0] + "&ont_class=" + ont_spl[1]+ "&object_property=" + object_property,   
     		success : function(response) {  
     			$("#object_type").css("visibility", "visible");
    	 		$("#object_type").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>    	

	<script>  
   	function getClassesForDBPedia() {  
        
    	var ont = $('#ontology').val().replace("#", "%23");    
    	
		$("#ontology_classes_dbpedia").html("");
    	$.ajax({  
     		type : "Get",   
     		url : "getClassesAjaxPostDBpedia",   
     		data : "ont=" + ont,  
     		success : function(response) {  
     			$("#ontology_classes_dbpedia").css("visibility", "visible");
    	 		$("#ontology_classes_dbpedia").html(response);    	 		
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>
   	
	<script>  
   	function getDataPropertiesAjaxPostDBpedia() {  
        
    	var ont = $('#rdf_type').val().replace("#", "%23");
    	
		$("#ontology_data_properties_dbpedia").html("");
		$("#ontology_data_properties_dbpedia").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "getDataPropertiesAjaxPostDBpedia",   
     		data : "ont=" + ont,   
     		success : function(response) {  
     			$("#ontology_data_properties_dbpedia").css("visibility", "visible");
    	 		$("#ontology_data_properties_dbpedia").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>   
   	
   	<script>  
   	function QueryDBPediaType() {  
            	
    	var data_type = $('#ont_data_property_dbpedia').val().replace("#", "%23");
    	var regex = $('#regex').val().replace("#", "%23");
    	
		$("#dbpedia_results_type").html("");
		$("#dbpedia_results_type").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "queryDBpediaType",   
     		data : "data_type=" + data_type + "&regex=" + regex,   
     		success : function(response) {  
     			$("#dbpedia_results_type").css("visibility", "visible");
    	 		$("#dbpedia_results_type").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>
   	
	<script>  
   	function QueryDBPedia() {  
            	
        var details = $('#rdf_type').val().replace("#", "%23");   	
		var det_array = details.split("==");
    	var data_type = det_array[0];
    	var regex = $('#regex').val().replace("#", "%23");
    	var object_type = det_array[1];
    	
		$("#dbpedia_results").html("");
		$("#dbpedia_results").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "queryDBpedia",   
     		data : "data_type=" + data_type + "&object_type=" + object_type +"&regex=" + regex,   
     		success : function(response) {  
     			$("#dbpedia_results").css("visibility", "visible");
    	 		$("#dbpedia_results").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>   	

	<script>
		tinymce.init({
		    selector: "textarea#contentFromIFrame",
		    theme: "modern",
		    width: 820,
		    height: 320,
		    plugins: [
		         "advlist autolink link image lists charmap print preview hr anchor pagebreak spellchecker",
		         "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
		         "save table contextmenu directionality emoticons template paste textcolor"
		   ],
		   content_css: "css/content.css",
		   toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | l      ink image | print preview media fullpage | forecolor backcolor emoticons", 
		   style_formats: [
		        {title: 'Bold text', inline: 'b'},
		        {title: 'Red text', inline: 'span', styles: {color: '#ff0000'}},
		        {title: 'Red header', block: 'h1', styles: {color: '#ff0000'}},
		        {title: 'Example 1', inline: 'span', classes: 'example1'},
		        {title: 'Example 2', inline: 'span', classes: 'example2'},
		        {title: 'Table styles'},
		        {title: 'Table row 1', selector: 'tr', classes: 'tablerow1'}
		    ]
		 }); 
	</script>
	
		<script type="text/javascript">
			function pop(div) {
				//alert('Emrah Guder');
				
				var divElement1 = document.getElementById(div);
				divElement1.style.visibility = 'visible';
				
				var divElement = document.getElementById('ReNarrationDiv');			
			
				divElement.style.display = 'none';
				
			}
			function hide(div) {
				document.getElementById(div).style.visibility = 'hidden';
			}
			//To detect escape button
			document.onkeydown = function(evt) {
				evt = evt || window.event;
				if (evt.keyCode == 27) {
					hide('popup');
				}
			};
		</script>	
	
	<!-- Functions -->
	<script>
		var Parent_selectedElement;
		var Parent_selectedElement_XPath;
		var Parent_mouseOverElement;
		var Parent_mouseOverElement_XPath;
		var Annotations = ['{"context":"http://www.w3.org/ns/oa-context-20130208.json","id":"http://www.example.org/annotations/anno1","type":"oa:Annotation","annotatedAt":"Wed, 02 Sep 2015 11:47:58 GMT","serializedAt":"Wed, 02 Sep 2015 11:47:58 GMT","annotatedBy":{"id":"http://www.example.org/people/person1","type":"foaf:Person","mbox":"person1@example.org","name":"Person One"},"serializedBy":{"id":"http://www.example.org/people/serialization1","type":"prov:SoftwareAgent","name":"Code v1.1","homepage":"http://localhost:8080/renarration"},"motivatedBy":"oa:commenting","body":{"@id":"a806000e-fcbb-460f-8fa5-5312c888784f","@type":"http://xmlns.com/foaf/0.1/Person","name":"Emrah Guder"},"target":{"id":"urn:uuid:cc2c8f08-3597-4d73-a529-1c5fed58268b","type":"oa:SpecificResource","hasSelector":{"id":"urn:uuid:7978fa7b-3e03-47e2-89d8-fa39d1280765","type":"rn:XPathSelector","xpath":"//html[1]/body[1]/div[1]/article[1]/div[1]/div[1]/p[1]"},"hasScope":"http://annotatorjs.org/","hasSource":{"type":"foaf:page"}}}', '{"context":"http://www.w3.org/ns/oa-context-20130208.json","id":"http://www.example.org/annotations/anno1","type":"oa:Annotation","annotatedAt":"Wed, 02 Sep 2015 11:48:15 GMT","serializedAt":"Wed, 02 Sep 2015 11:48:15 GMT","annotatedBy":{"id":"http://www.example.org/people/person1","type":"foaf:Person","mbox":"person1@example.org","name":"Person One"},"serializedBy":{"id":"http://www.example.org/people/serialization1","type":"prov:SoftwareAgent","name":"Code v1.1","homepage":"http://localhost:8080/renarration"},"motivatedBy":"oa:commenting","body":{"@id":"f3221ce6-ad8a-4ff9-8eb5-8735ac407960","@type":"http://xmlns.com/foaf/0.1/Person","name":"Murat Guder"},"target":{"id":"urn:uuid:cc2c8f08-3597-4d73-a529-1c5fed58268b","type":"oa:SpecificResource","hasSelector":{"id":"urn:uuid:7978fa7b-3e03-47e2-89d8-fa39d1280765","type":"rn:XPathSelector","xpath":"//html[1]/body[1]/div[1]/article[1]/div[1]/div[1]/p[1]"},"hasScope":"http://annotatorjs.org/","hasSource":{"@id":"http://annotatorjs.org/", "type":"foaf:page"}}}'];
		var user_name = "Emrah Guder";
		var user_email = "";
		var type = "annotation";
		var renarration_url = window.location.protocol+'//' +window.location.host + "/renarration/";
		
		// div tab variables
		var selected="annotation_Tab";
    	var disp="AnnotationTab";
		// div tab variables
		
		// annotation json variables
		var text_body = {
		        "@id": "urn:uuid:1d823e02-60a1-47ae-ae7f-a02f2ac348f8", 
		        "@type": "oa:EmbeddedContent", 
		        "value": "This is part of our logo",
		        "format": "text/plain"
		    };
		
		var dctype_body = {
				"@id":"",
				"@type":"image",
				"format":""
			};
		
		var dbpedia_body = {
				"@id":"",
				"@type":"image",
			};
		
		var semantic_body = {		         
		        "type": ""
		    };
		
		var xpath_selector = {
	            "@id": "urn:uuid:7978fa7b-3e03-47e2-89d8-fa39d1280765", 
	            "@type": "rn:XPathSelector", 						             
	            "xpath": "//xxxxxx/yy/zz"
	        };
		
		var oa_image_with_fragment = {
				"@id": "",
				"@type": "oa:List", 
				"members": [
				            {
		            			"@id": "urn:uuid:7978fa7b-3e03-47e2-89d8-fa39d1280765", 
		            			"@type": "rn:XPathSelector", 						             
		            			"xpath": "//xxxxxx/yy/zz"										
							},
							{
								"@id": "http://example.org/selector1",
							    "@type": "oa:FragmentSelector",
							    "value": "",
							    "conformsTo": "http://www.w3.org/TR/media-frags/"
							}
				]
			};
		
		var oa_text_selected = {
				"@id": "",
				"@type": "oa:List", 
				"members": [
				            {
		            			"@id": "urn:uuid:7978fa7b-3e03-47e2-89d8-fa39d1280765", 
		            			"@type": "rn:XPathSelector", 						             
		            			"xpath": "//xxxxxx/yy/zz"										
							},
							{
								"@id": "http://example.org/selector1",
							    "@type": "oa:TextQuoteSelector",
							    "exact": "",
							    "prefix": "",
							    "suffix": ""
							}
				]
			};
		
		var oa_template = {
    						"@context": "http://www.w3.org/ns/oa-context-20130208.json", 
						    "@id": "http://www.example.org/annotations/anno1", 
						    "@type": "oa:Annotation",						
						    "annotatedAt": "2012-11-10T09:08:07",
						    "serializedAt": "2012-11-10T09:08:07",
						    "annotatedBy": {
						        "@id": "http://www.example.org/people/person1", 
						        "@type": "foaf:Person", 						         
						        "name": "Person One"
						    },
						    "serializedBy": {
						        "@id": "http://www.example.org/people/serialization1", 
						        "@type": "prov:SoftwareAgent", 
						        "name": "Code v1.1", 
						        "homepage": "http://localhost:8080/renarration"
						    },	
						    "motivation": "oa:commenting",
						    "body": {
						        "@id": "urn:uuid:1d823e02-60a1-47ae-ae7f-a02f2ac348f8", 
						        "@type": ["cnt:ContentAsText", "dctypes:Text"], 
						        "chars": "This is part of our logo"
						    }, 
						    "target": {
						        "@id": "urn:uuid:cc2c8f08-3597-4d73-a529-1c5fed58268b", 
						        "@type": "oa:SpecificResource", 
						        "selector": {
						            "@id": "urn:uuid:7978fa7b-3e03-47e2-89d8-fa39d1280765", 
						            "@type": "rn:XPathSelector", 						             
						            "xpath": "//xxxxxx/yy/zz"
						        },						        
						        "source": {
						        	"@id": "",
						        	"@type": "foaf:page"	
						        }
						    }
						};
				
		// annotation json variables
		
		window.onload = function(){
			setAnnotationVector();
			hightlightElementsUsingXPath();
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
		
		function saveAnnotations(){				
				var sourceURL = document.getElementById("sourceURL");
				var annotationText = document.getElementById("annotationText");
				var annotationForm = document.getElementById("AnnotationForm");
				annotationText.value = concatenateAnnotations();
				
				annotationForm.submit();
		}
		
		function goBack(){				
			window.location.href = renarration_url + 'back';
		}
		
		function concatenateAnnotations(){
				return Annotations.join('__--__');
		}		
		
		function Default_Annotation_Object() {
   			this.xpath			= "";
   			this.annotationType	= "";
   			this.annotation		= "";
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
		
		function getDomainAndRange(){		
			var subject_type = document.getElementById("ont_class");
			var subject_type_select = "<select id=\"related_subject_id\">";
			var object_type = document.getElementById("related_object_class");
			var object_type_select = "<select id=\"related_object_id\">";
			
			var subj_type = subject_type.options[subject_type.selectedIndex].value.split("==")[1].replace("http://xmlns.com/foaf/0.1/", "foaf:");
			//alert(subj_type);
			var obj_type = object_type.options[object_type.selectedIndex].value.replace("http://xmlns.com/foaf/0.1/", "foaf:");
			//alert(obj_type);
			//alert(subject_type.options[subject_type.selectedIndex].value);
			//alert(object_type.options[object_type.selectedIndex].value);
			
			for(var i=0; i<Annotations.length; i++){
				//alert("Emrah Guder");
				var temp_annotation = JSON.parse(Annotations[i]);
				//alert(curr_annotation.body["@type"]);
				if(temp_annotation.body["@type"]==subj_type){
					//alert("Emrah");
					subject_type_select = subject_type_select + "<option value=\""+i+"\">" + temp_annotation.body[Object.keys(temp_annotation.body)[2]] + "</option>";
				}		
				if(temp_annotation.body["@type"]==obj_type){
					object_type_select = object_type_select + "<option value=\""+temp_annotation.body["@id"]+"\">" + temp_annotation.body[Object.keys(temp_annotation.body)[2]] + "</option>";
				}					
			}
			
			var relations = document.getElementById("related_ids");
			
			relations.innerHTML = "Instances : <br>" + subject_type_select + "</select><br>" + object_type_select + "</select>";
			
			relations.style.visibility='visible'; 
			
		}				
		
		function getListOfAnnotationUsingXPath(xpath){		
			var result = "<table><tr><td><b>List Of Annotations</b></td></tr>";
			//alert(Annotations.length);
			for(var i=0; i<Annotations.length; i++){
				var temp_annotation = JSON.parse(Annotations[i]);
				if(temp_annotation.target.selector.hasOwnProperty('xpath')){
					if(temp_annotation.target.selector.xpath==xpath){
						result = result + "<tr><td>" + Annotations[i] + "</td></tr>";
					}		
				}
				else{
					if(temp_annotation.target.selector.members[0].xpath==xpath){
						result = result + "<tr><td>" + Annotations[i] + "</td></tr>";
					}
				}
							
			}
			return result+"</table>";
		}
		
		function show(a,b){
			document.getElementById(selected).style.backgroundColor = "rgb(200,200,200)";
			document.getElementById(disp).style.display = "none";    
			document.getElementById(a).style.backgroundColor = "rgb(150,150,150)";      
			document.getElementById(b).style.display = "block";
    		
			selected=a;
    		disp=b;
    	}
		

		function enableDiv(divID){
			//alert(divID);
			var divElement = document.getElementById(divID);
			divElement.style.visibility = 'visible';
		}
		
		function cancelDivChanges(){
			var divElement = document.getElementById('ReNarrationDiv');			
			
			// set Elements to null
			Parent_selectedElement = null;
			Parent_selectedElement_XPath = null;
			
			divElement.style.display = 'none';
		}
		
		// this function applies changes to IFrame
		function applyDivChanges(){
			var divElement = document.getElementById('ReNarrationDiv');
			
			
			Parent_selectedElement.innerHTML = tinymce.get('contentFromIFrame').getContent();
			// set Elements to null
			Parent_selectedElement = null;
			Parent_selectedElement_XPath = null;
			
			divElement.style.display = 'none';
		}
		
		function cancelDivChangesAnnotations(){
			var divElement = document.getElementById('ReNarrationDiv');			
			
			// set Elements to null
			Parent_selectedElement = null;
			Parent_selectedElement_XPath = null;
			
			divElement.style.display = 'none';
			
			hide('popup');
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
		
		function getSelectionText() {
		    var text = "";
		    if (window.getSelection) {
		        text = window.getSelection().toString();
		    } else if (document.selection && document.selection.type != "Control") {
		        text = document.selection.createRange().text;
		    }
		    return text;
		}
		
		function setSelectionText() {
		    var textQuote = document.getElementById('textQuote');
		    textQuote.value=getSelectionText();
		}
		
		// this function applies changes to IFrame
		function applyDivChangesAnnotations(){
			var divElement = document.getElementById('ReNarrationDiv');
			var tempAnnotation = oa_template;
			var dt = new Date();
			var img_x1 = document.getElementById('x1');
			var img_y1 = document.getElementById('y1');
			var img_x2 = document.getElementById('x2');					
			var img_y2 = document.getElementById('y2');	
			var username = document.getElementById("name").value;
			var email = document.getElementById("email").value;
			var renarrator_userId = document.getElementById('userId').value;
			
			//set motivations
			var motivations = [];
			var motivations_idx = 0;
			for (i = 1; i<11; i++) {
				checkbox_elem = document.getElementById('motivation_'+i);
				if(checkbox_elem.checked){
					motivations[motivations_idx] = checkbox_elem.value;
					motivations_idx = motivations_idx + 1;
					checkbox_elem.checked = false;
				}
			}
			
			if(motivations.length>0){
				//alert(tempAnnotation.motivation);
				if(motivations.length>1){
					tempAnnotation.motivation = motivations;
				}
				else{
					tempAnnotation.motivation = motivations[0];
				}
			}			
			
			
			// common sets
			tempAnnotation.annotatedAt = dt.toISOString();
			tempAnnotation.serializedAt = dt.toISOString();
			tempAnnotation["@id"] = generateUUID();
			tempAnnotation.serializedBy["@id"] = renarration_url;
			tempAnnotation.serializedBy["homepage"] = renarration_url;
			tempAnnotation.target.selector = xpath_selector;
			tempAnnotation.target.selector.xpath = Parent_selectedElement_XPath;
			tempAnnotation.target.source["@id"] = document.getElementById("remoteURL").value;	
			tempAnnotation.target.selector["@id"] = generateUUID();
			tempAnnotation.annotatedBy.name = username;
			tempAnnotation.annotatedBy["@id"] = renarrator_userId;
			tempAnnotation.target["@id"] = generateUUID();
			
			if(document.getElementById("text").checked == true){
				// Text annotation								
				tempAnnotation.body = text_body;
				tempAnnotation.body.value = document.getElementById('ContentAsText').value;
				tempAnnotation.body["@id"] = generateUUID();
				
			}
			else if(document.getElementById("semantic").checked == true){
				// Semantic annotation
				var ont_class = document.getElementById('ont_class');
				var data_property_1 = document.getElementById('ont_data_property1');
				var data_property_2 = document.getElementById('ont_data_property2');
				var typ = ont_class.options[ont_class.selectedIndex].value.split("==");
				
				var body_type = typ[1].replace("http://xmlns.com/foaf/0.1/", "foaf:");	
					
				
				tempAnnotation.body = {};				
				if(document.getElementById("subjects").checked == true){
					tempAnnotation.body["@id"] = generateUUID();
					tempAnnotation.body["@type"] = body_type;
					//alert(data_property_2.options[data_property_2.selectedIndex].value);
					if(data_property_1.options[data_property_1.selectedIndex].value!="")
						tempAnnotation.body[data_property_1.options[data_property_1.selectedIndex].value.replace("http://xmlns.com/foaf/0.1/", "foaf:")] = document.getElementById('ont_data_value1').value;
					if(data_property_2.options[data_property_2.selectedIndex].value!="")
						tempAnnotation.body[data_property_2.options[data_property_2.selectedIndex].value.replace("http://xmlns.com/foaf/0.1/", "foaf:")] = document.getElementById('ont_data_value2').value;					
				}
				else if(document.getElementById("objects").checked == true){					 
					 var subject_id = document.getElementById("related_subject_id");
					 var relation_type = document.getElementById("ont_object_property");
					 var object_id = document.getElementById("related_object_id");
					 var relation = JSON.parse(Annotations[subject_id.options[subject_id.selectedIndex].value]);
					 relation.body[relation_type.options[relation_type.selectedIndex].value.replace("http://xmlns.com/foaf/0.1/", "foaf:")] = object_id.options[object_id.selectedIndex].value;
					 Annotations[subject_id.options[subject_id.selectedIndex].value] =  JSON.stringify(relation);
				}
			}
			else if(document.getElementById("visual").checked == true){
				// Visual Representation

				tempAnnotation.body = dctype_body;
				vis_type = document.getElementById('visual_type');
				//alert(vis_type.options[vis_type.selectedIndex].value);
				tempAnnotation.body["@type"] = vis_type.options[vis_type.selectedIndex].value;
				tempAnnotation.body["@id"] = document.getElementById('Identifier').value;
				if(vis_type.options[vis_type.selectedIndex].value=="dctypes:Image"){
					tempAnnotation.body["format"] = "image/jpeg";
				}
				else{
					tempAnnotation.body["format"] = "audio/mpeg";
				}
			}		
			else if(document.getElementById("dbpedia").checked == true){
				// DBpedia Resource

				tempAnnotation.body = dbpedia_body;
				var dbpedia_type = document.getElementById('rdf_type');
				var dbpedia_uri = document.getElementById('dbpedia_result');
				var dbpedia_details = dbpedia_type.options[dbpedia_type.selectedIndex].value.split('==');
				//alert(vis_type.options[vis_type.selectedIndex].value);
				tempAnnotation.body["@type"] = dbpedia_details[1];
				tempAnnotation.body["@id"] = dbpedia_uri.options[dbpedia_uri.selectedIndex].value; 
			}				
			
			
			
			// target is an image
			if(Parent_selectedElement.tagName=="IMG"){
				//alert('Buradayim amk');
				//tempAnnotation.hasTarget.hasSelector = oa_image_with_fragment;
				//if fragment of image is selected
				
				if(img_x1.value!="0"){	
					tempAnnotation.target["@id"] = generateUUID();
					tempAnnotation.target.selector = oa_image_with_fragment;
					
					var img_x = img_x1.value;
					var img_y = img_y1.value;
					var img_w = img_x2.value - img_x1.value;
					var img_h = img_y2.value - img_y1.value;
					
					//alert(img_x.value + ',' + img_y.value + ',' + img_w + ',' + img_h);
					
					tempAnnotation.target.selector["@id"] = generateUUID();
					tempAnnotation.target.selector.members[0]["@id"] = generateUUID(); 
					tempAnnotation.target.selector.members[0].xpath = Parent_selectedElement_XPath;
					tempAnnotation.target.selector.members[1].value = 'xywh=' + img_x + ',' + img_y + ',' + img_w + ',' + img_h;
					tempAnnotation.target.selector.members[1]["@id"] = generateUUID(); 
				}
				
			}
			else {
				var textQuote = document.getElementById('textQuote');
				if(textQuote.value!=""){
					tempAnnotation.target.selector = oa_text_selected;
					tempAnnotation.target.selector["@id"] = generateUUID();
					tempAnnotation.target.selector.members[0]["@id"] = generateUUID(); 					
					tempAnnotation.target.selector.members[0].xpath = Parent_selectedElement_XPath;
					tempAnnotation.target.selector.members[1].exact = textQuote.value;
					tempAnnotation.target.selector.members[1]["@id"] = generateUUID(); 
				}
			}
			
			if(document.getElementById("objects").checked != true)				
				Annotations[Annotations.length] = JSON.stringify(tempAnnotation);
			

			//Parent_selectedElement.addEventListener("mouseover",function() {
				//showAnnotationDivOnElement(Parent_selectedElement, document.getElementById('annotationText').value);
			//}); 															
			Parent_selectedElement.style.border ='2px solid yellow';
			// set Elements to null
			Parent_selectedElement = null;
			Parent_selectedElement_XPath = null;
			
			divElement.style.display = 'none';
			

			
			// set image variables to zero
			img_x1.value=0;
			img_y1.value=0;
			img_x2.value=0;
			img_y2.value=0;
			document.getElementById('textQuote').value = "";
			
			document.getElementById("ContentAsText").value = "";
			document.getElementById("ontology_classes").style.visibility = "hidden";
			document.getElementById("ontology_classes_definition").style.visibility = "hidden";
			document.getElementById("ontology_data_property").style.visibility = "hidden";
			document.getElementById("ontology_object_property").style.visibility = "hidden";
			document.getElementById("object_type").style.visibility = "hidden";
			document.getElementById("related_ids").style.visibility = "hidden";
			
			document.getElementById("subjects").checked = false;
			document.getElementById("objects").checked = false;
			
			document.getElementById("Identifier").value = "";
			document.getElementById("regex").value = "";
			document.getElementById("dbpedia_results").style.visibility = "hidden";
			
			hide('popup');
		}	
		
		function showBorderOfMouseOverElement(xpath){
			if(findAnnotationUsingXPath(xpath)>0){
				Parent_mouseOverElement.style.borderColor = 'yellow';
				Parent_mouseOverElement.style.borderWidth = '2px';
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
		
		function hideAnnotationDivOnElement(){
			window.parent.document.getElementById('AnnotationDiv').style.display="none";
		}
		
		function setContentInDiv(){
			var xpath = document.getElementById('selectedElementXPath');
			xpath.innerHTML = '<b>Selected Element</b> : ' + Parent_selectedElement_XPath;
			tinymce.get('contentFromIFrame').setContent(Parent_selectedElement.innerHTML);
			
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
			if(findAnnotationUsingXPath(Parent_selectedElement_XPath)>=0){	
				annotationListDiv.style.visibility='visible'; 
				annotationListDiv.innerHTML = getListOfAnnotationUsingXPath(Parent_selectedElement_XPath);
			}
			else{
				annotationListDiv.style.visibility='hidden'; 
			}

		}		
		
		function loadRemotePage(){
			var remotePageURL = document.getElementById('remoteURL');
			window.location.href=renarration_url + 'url?page=' + remotePageURL.value;
			//iFrame.src = remotePageURL.value;
			//alert(remotePageURL);			
			//httpGet(remotePageURL.value);
		}
		
		function injectJS(){
			var iFrame_To_Load = document.getElementById('ReNarrationIFrame_to_Load');
			
			
			
			var target = document.getElementById("ReNarrationIFrame");
			target.contentDocument.write('<html><head>' + iFrame_To_Load.contentDocument.head.innerHTML +injectedJS + '</head><body>' + iFrame_To_Load.contentDocument.body.innerHTML + '</body></html>');
		
		}
		
		function annotationElements(){
			if(document.getElementById("text").checked == true){
				var textDiv = document.getElementById('Text_Annotation');
				textDiv.style.display = "block";
				
				var semanticDiv = document.getElementById('Semantic_Annotation');
				semanticDiv.style.display = "none";
				var visDiv = document.getElementById('Visual_Representation');
				visDiv.style.display = "none";	
				var dbpediaDiv = document.getElementById('DBpedia_Annotation');
				dbpediaDiv.style.display = "none";				
				
			}
			else if(document.getElementById("semantic").checked == true){
				var semanticDiv = document.getElementById('Semantic_Annotation');
				semanticDiv.style.display = "block";
				
				var textDiv = document.getElementById('Text_Annotation');
				textDiv.style.display = "none";
				var visDiv = document.getElementById('Visual_Representation');
				visDiv.style.display = "none";	
				var dbpediaDiv = document.getElementById('DBpedia_Annotation');
				dbpediaDiv.style.display = "none";				
			}
			else if(document.getElementById("visual").checked == true){
				var visDiv = document.getElementById('Visual_Representation');
				visDiv.style.display = "block";		
				
				var textDiv = document.getElementById('Text_Annotation');
				textDiv.style.display = "none";
				var semanticDiv = document.getElementById('Semantic_Annotation');
				semanticDiv.style.display = "none";	
				var dbpediaDiv = document.getElementById('DBpedia_Annotation');
				dbpediaDiv.style.display = "none";				
			}
			else if(document.getElementById("dbpedia").checked == true){
				var dbpediaDiv = document.getElementById('DBpedia_Annotation');
				dbpediaDiv.style.display = "block";
				
				var visDiv = document.getElementById('Visual_Representation');
				visDiv.style.display = "none";						
				var textDiv = document.getElementById('Text_Annotation');
				textDiv.style.display = "none";
				var semanticDiv = document.getElementById('Semantic_Annotation');
				semanticDiv.style.display = "none";					
			}			
			else {
				var textDiv = document.getElementById('Text_Annotation');
				textDiv.style.display = "none";				
				var semanticDiv = document.getElementById('Semantic_Annotation');
				semanticDiv.style.display = "none";
				var visDiv = document.getElementById('Visual_Representation');
				visDiv.style.display = "none";	
				var dbpediaDiv = document.getElementById('DBpedia_Annotation');
				dbpediaDiv.style.display = "none";				
				
			}
		}
	</script>
	<!-- Functions -->	
</head>
<body>
	<table width="100%">
		<tr>
			<td width="10%"></td>
			<td width="80%" align="center">
				<div style="display:none;">
					<c:choose>
					<c:when test="${empty current_page}">
						<input type="text" id="remoteURL" style="width: 400px;" value="RemoteUrl"> &nbsp;&nbsp;<input id = "btnSubmit" type="submit" value="Load" onClick="loadRemotePage()"/>		
					</c:when>
					<c:otherwise>
						<input type="text" id="remoteURL" style="width: 400px;" value="<c:out value="${current_page}"/>"> &nbsp;&nbsp;<input id = "btnSubmit" type="submit" value="Load" onClick="loadRemotePage()"/>
					</c:otherwise>
				</c:choose>
				</div>				
				<input id = "btnSave" type="submit" value="Try Another Web Page" onClick="goBack()"/>	
				<input id = "btnSave" type="submit" value="Save Annotations" onClick="saveAnnotations()"/>	
			</td>
			<td width="10%"></td>
		</tr>
		<tr>
			<td width="10%"></td>
			<td width="80%">
				<div align="center">	
					<c:if test="${not empty current_page}">				
						<iframe id="ReNarrationIFrame" width="100%" height="650" src="/renarration/resources/pages/current_page.html"></iframe>
					</c:if>
				</div>				
			</td>
			<td width="10%"></td>
		</tr>
	</table>
	
	<div id="AnnotationFormDiv" style="display:none;">
		<form action="/renarration/mongoInsertAnnotation" id="AnnotationForm" method="POST">
				<c:choose>
					<c:when test="${empty current_page}">
						<input type="text" value="" name="sourceURL" id="sourceURL">		
					</c:when>
					<c:otherwise>
						<input type="text" value="<c:out value="${current_page}"/>" name="sourceURL" id="sourceURL">
					</c:otherwise>
				</c:choose>
			<input type="text" value="" name="annotationText" id="annotationText">		
		</form>
	</div>	
	
	<div id="AnnotationDiv" style="display:none;" class="annotationInfo">
		
	</div>
	<div id="ReNarrationDiv" style="display:none;" class="ReNarrationDiv">
		<div class="ReNarrationHeadingDiv" width="100%">
    		<span id='annotation_Tab' onclick="show('annotation_Tab','AnnotationTab');">Annotations</span>
    	</div>
		<div id="RenarrationTab" style="display:none;">
			<br>
			<div id="selectedElementXPath"></div>
			<br>
			<b>Editable Content : </b>	
			<textarea id="contentFromIFrame" name="area"></textarea>
			<div id="footer">
				<input id = "annotate" type="button" value="Apply" onClick="applyDivChanges()"/>
				<input id = "annotate" type="button" value="Cancel" onClick="cancelDivChanges()"/>		
			</div>
		</div>    	
		<div id="AnnotationTab" style="display:block;">
			<br>
			<table class="text" style="width:98%;">
				<tr>
					<td colspan="2" align="left" width="100%">
						<div id="selectedElementXPathAnnotation"></div>
					</td>
				</tr>
				<tr>
					<td width="50%" align="left">
						<b>Content :</b>
					</td>
					<td width="50%" align="left">
						<b>Annotation Details :</b>
					</td>
				</tr>
				<tr>
					<td align="left" valign="top" style="border: solid 1px #E8E8E8;">
						<div id="contentFromIFrameAnnotation"></div>
					</td>
					<td align="left" valign="top" style="border: solid 1px #E8E8E8;">
						<form>
							<input type="radio" id="text" name="annotation" value="Text" onclick="annotationElements()">Text Annotation&nbsp;&nbsp;
							<input type="radio" id="semantic" name="annotation" value="Semantic" onclick="annotationElements()">Semantic Annotation
							<input type="radio" id="visual" name="annotation" value="Visual" onclick="annotationElements()">Visual Representation
							<input type="radio" id="dbpedia" name="annotation" value="DBpedia" onclick="annotationElements()">DBpedia<br>
						</form>
						
						<div style="display:none;">
						<input type="text" value="" id="textQuote" style="visibility: hidden">
						<input type="text" value="xxx" id="x0" style="visibility: hidden"> 
 						<input type="text" value="Y" id="y0" style="visibility: hidden">

 
 						<input type="text" value="0" id="x1" style="visibility: hidden"> <input type="text" value="0" id="y1" style="visibility: hidden">
 						
 						<input type="text" value="0" id="x2" style="visibility: hidden"> <input type="text" value="0" id="y2" style="visibility: hidden">
						</div>					
						
						<div id="Text_Annotation" style="display:none;">
							Content as Text
							<textarea id="ContentAsText" style="width: 100%;height: 100px;"> </textarea>
						</div>
						
						<div id="Semantic_Annotation" style="display:none;">
							<table>
								<tr>
									<td>
									Type of Entity:
									</td>
									<td>
										<select id="ont_class" onchange="enableDiv('ontology_classes_definition');"> 
											<option value=""></option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/Image">Image</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/Project">Project</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/Agent">Agent</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/LabelProperty">LabelProperty</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/Document">Document</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/OnlineAccount">OnlineAccount</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/Person">Person</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/PersonalProfileDocument">PersonalProfileDocument</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/OnlineChatAccount">OnlineChatAccount</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/OnlineGamingAccount">OnlineGamingAccount</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/Organization">Organization</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/Group">Group</option>
											<option value="http://xmlns.com/foaf/0.1/==http://xmlns.com/foaf/0.1/OnlineEcommerceAccount">OnlineEcommerceAccount</option>
										</select>
									</td>								
								</tr>
								<tr>
									<td colspan="2">
										<div id="ontology_classes" style="visibility: hidden">
											
										</div>
										<div id="ontology_classes_definition" style="visibility: hidden">								
											<form>
												<input name="semantic" type="radio" id="subjects" value="Text" onclick="getDataPropertiesAjaxPost()">Define Subjects and/or Objects
												<input name="semantic" type="radio" id="objects" value="Semantic" onclick="getObjectPropertiesAjaxPost()">Define Relations
											</form>	
										</div>										
										<div id="ontology_data_property" style="visibility: hidden">
											
										</div>	
										<div id="ontology_object_property" style="visibility: hidden">
											
										</div>	
										<div id="object_type" style="visibility: hidden">
											
										</div>						
										<div id="related_ids" style="visibility: hidden">
											
										</div>	
																	
									</td>
								</tr>
							</table>							
						</div>		
						<div id="Visual_Representation" style="display:none;">
							<table>
								<tr>
									<td>Visual Representation Type</td>
									<td>
										<select id="visual_type">
											<option value=""></option>
										 	<option value="dctypes:Image">Image</option>										  	
										  	<option value="dctypes:MovingImage">MovingImage</option>
										  	<option value="dctypes:Sound" selected>Sound</option>
										</select>									
									</td>
								</tr>
								<tr>
									<td>URL</td>
									<td><input type="text" value="" id="Identifier"></td>
								</tr>
							</table>							
						</div>	
						<div id="DBpedia_Annotation" style="display:none;">
							<div>								
								<select id="rdf_type">
									<option value=""></option>
								  	<option value="http://xmlns.com/foaf/0.1/name==http://xmlns.com/foaf/0.1/Person">Person</option>
								  	<option value="http://dbpedia.org/property/name==http://dbpedia.org/ontology/Place">Place</option>								  	
									<option value="http://dbpedia.org/property/name==http://dbpedia.org/ontology/Animal">Animal</option>								  	
									<option value="http://dbpedia.org/property/name==http://dbpedia.org/ontology/Software">Software</option>								  	
									<option value="http://dbpedia.org/property/name==http://dbpedia.org/ontology/Food">Food</option>								  	
								</select>
								<input type="text" value="" id="regex">
								<input type="button" value="Query DBpedia" onclick="QueryDBPedia();" />
							</div>																							
							<div id="dbpedia_results" style="visibility: hidden">
											
							</div>							
						</div>
					</td>
				</tr>	
				<tr>
					<td colspan="2" align="left">
						<div id="annotationList" class="annotationList"></div>
					</td>
				</tr>				
				<tr>
					<td colspan="2" align="right">
						<input id = "annotate" type="button" value="Apply" onClick="pop('popup')"/>
						<input id = "annotate" type="button" value="Cancel" onClick="cancelDivChangesAnnotations()"/>
					</td>
				</tr>			
			</table>					
		</div>					
	</div>
	<input type="text" style="visibility: hidden" id="listOfAnnotations" value="<c:out value="${listOfAnnotations}"/>">
	<input type="text" style="visibility: hidden" id="name" value="<c:out value='<%=request.getSession().getAttribute("name")%>' />">
	<input type="text" style="visibility: hidden" id="email" value="<c:out value='<%=request.getSession().getAttribute("email")%>' />">
	<input type="text" style="visibility: hidden" id="userId" value="<c:out value='<%=request.getSession().getAttribute("userId")%>' />">				
	<div id="popup" style="visibility:hidden;">
		<div class="ReNarrationHeadingDiv" width="100%">
			<span id='motivationTab'>Motivations</span>
		</div>
		Please define motivation(s) for annotation(s) : 
		<br><br>
			<form action="">
				&nbsp;&nbsp;<input type="checkbox" id="motivation_1" value="oa:bookmarking">Bookmarking<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_2" value="oa:classifying">Classifying<br> 
				&nbsp;&nbsp;<input type="checkbox" id="motivation_3" value="oa:commenting">Commenting<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_4" value="oa:describing">Describing<br> 
				&nbsp;&nbsp;<input type="checkbox" id="motivation_5" value="oa:editing">Editing<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_6" value="oa:identifying">Identifying<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_7" value="oa:linking">Linking<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_8" value="oa:moderating">Moderating<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_9" value="oa:questioning">Questioning<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_10" value="oa:replying">Replying<br>
				&nbsp;&nbsp;<input type="checkbox" id="motivation_11" value="oa:tagging">Tagging<br>				
			</form>		
		<br>
		<center>
			<input id = "annotate" type="button" value="Create Annotation" onClick="applyDivChangesAnnotations()"/>
			<input id = "annotate" type="button" value="Cancel" onClick="cancelDivChangesAnnotations()"/>
		</center>
	</div>

</body>
</html>
