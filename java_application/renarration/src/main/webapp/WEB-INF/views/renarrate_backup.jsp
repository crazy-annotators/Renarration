<?xml version="1.0" encoding="utf-8"?>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta charset="UTF-8">
	<title>Renarration</title>
	
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
	
	<!-- Functions -->
	<script>  
   	function getReferenceDataFromDBPedia(i) {  
        
		var dbpedia_resource = $('#ref_text_dbpedia' + i).val().replace("#", "%23");
		
    	$("#ref_dbpedia_"+ i).html("");
    	$.ajax({  
     		type : "Get",   
     		url : "getReferenceDataFromDBPedia",   
     		data : "resource=" + dbpedia_resource,  
     		success : function(response) {       			
    	 		$("#ref_dbpedia_"+ i).html(response);    	 		
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	}); 
   	}  
   	</script>
	
	<script>
	var Parent_selectedElement;
	var Parent_selectedElement_XPath;
	var Parent_mouseOverElement;
	var Parent_mouseOverElement_XPath;
	var Annotations = [];
	var Renarrations = [];
	var user_name = "";
	var user_email = "";
	var renarration_url = window.location.protocol+'//' +window.location.host + "/renarration/";
	var transformLength = 0;
	var transforms = [];
	var renarration_template = {
			"context": renarration_url + "ns/20151001.json",
			 "@id" : "",
			 "@type" : "rn:Renarration",
			 "renarratedAt" : "",
			 "audience" : "",
			 "source" : "",
			 "transform" : {
				 "@id" : "",
				 "@type" : "rn:List",
				 "nodes" : [] 
			 },
			 "renarrator" : {
				"@id" : "",
				"@type" : "foaf:Person",
				"name" : ""
			 },
			 "motivation" : ""
			};
	
	var embedded_content = {
			"@id" : "",
			"@type" : "cnt:ContentAsText",
			"content" : ""
	};
	
	var visual_content = {
			"@id" : "",
			"@type" : "",
			"format":""
	};
	
	var narration_collection = {
			"@id" : "",
			"@type" : "rn:List",
			"nodes" : []
	};		
	
	var transform = {
			 "@id" : "",
			 "@type" : "rn:RenarrationTransformation",
			 "selection" : "",
			 "createdAt" : "",
			 "action" : ""
	};
	
	var source_selection = {
			"@id" : "",
			"@type" : "rn:XPathSelector",
			"value" : "#xpointer(/a/b/c)"
	};
	
	var source_list_selection = {
			"@id" : "",
			"@type" : "rn:List",
			"nodes" : [
					    {
							"@id" : "",
							"@type" : "rn:XPathSelector",
							"value" : "#xpointer(/a/b/c)"
						},
					    {
							"@id" : "",
							"@type" : "rn:PrefixSuffixSelector",
							"prefix" : "",
							"suffix" : "",
							"text" : "" 
						}	
			          
			          ]
	};
		
		var namespaces = {
				"oa"		: "http://www.w3.org/ns/oa#",
				"dc"		: "http://purl.org/dc/elements/1.1/",
				"dcterms"	: "http://purl.org/dc/terms/",
				"dctypes"	: "http://purl.org/dc/dcmitype/",
				"foaf"		: "http://xmlns.com/foaf/0.1/",
				"prov"		: "http://www.w3.org/ns/prov#",
				"rdf"		: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
				"rdfs"		: "http://www.w3.org/2000/01/rdf-schema#",
				"skos"		: "http://www.w3.org/2004/02/skos/core#"
				};
					
		var rn_collection_num = 0;
		var target_audience = '<select id="audience_type=nth="> '+
								'<option value=""></option> '+
								'<option value="rn:Programmers">Programmers</option> '+
								'<option value="rn:JavaProgrammers">Java Programmers</option> '+								  	
								'<option value="rn:CppProgrammers">C++ Programmers</option> '+								  									  	
							   '</select> ';
							   
		var rn_dyn_content = '<hr><div id="rn_dynamic=nth="> '+
								'<div> '+
									'<select id="renarration_type=nth=" onchange="enableDivRenarration(=nth=);"> '+
										'<option value=""></option> '+
										'<option value="embedded">Embedded Content</option> '+
										'<option value="image">Image</option> '+								  	
										'<option value="audio">Audio</option> '+								  	
										'<option value="video">Video</option> '+								  									  	
									'</select> '+
									'<input id = "delete_transform" type="button" value="Delete Transform" onClick="deleteTransform(=nth=)"/> '+
								'</div> '+
								'<div id="embedded=nth=" style="display:none;"> '+
									'<textarea id="embedded_text=nth=" style="width: 100%;height: 100px;"> </textarea> '+
									'<input type="text" value="" id="type=nth=" style="display:none;"> '+
									'<input type="text" value="" id="value=nth=" style="display:none;"> '+
									'<input type="text" value="" id="type_id=nth=" style="display:none;"> '+
									'<input type="text" value="" id="annotation_id=nth=" style="display:none;"> '+									
								'</div> '+
								'<div id="image=nth=" style="display:none;"> '+
									'<input type="text" value="" id="image_identifier=nth="> '+									
								'</div> '+
								'<div id="audio=nth=" style="display:none;"> '+
									'<input type="text" value="" id="audio_identifier=nth="> '+									
								'</div> '+
								'<div id="video=nth=" style="display:none;"> '+
									'<input type="text" value="" id="video_identifier=nth="> '+									
								'</div> '+
								'<div id="audience=nth=" style="display:none;"> '+
								target_audience + 
								'</div> '+								
							'</div>';
		
		// div tab variables
		var selected="renarration_Tab";
    	var disp="RenarrationTab";
		// div tab variables				
		
		window.onload = function(){
			setAnnotationVector();
			hightlightElementsUsingXPath();
		}
		
				
	</script>
	<!-- Functions -->
	
	<script src="/renarration/resources/js/ren_lib.js"></script>	
</head>
<body>
	<table width="100%">
		<tr>
			<td width="10%"></td>
			<td width="80%" align="center">	
				<c:choose>
					<c:when test="${empty current_page}">
						<input type="text" id="remoteURL" style="width: 400px;display:none;" value="RemoteUrl">	
					</c:when>
					<c:otherwise>
						<input type="text" id="remoteURL" style="width: 400px;display:none;" value="<c:out value="${current_page}"/>">
					</c:otherwise>
				</c:choose>
				<input id = "btnSave" type="submit" value="Try Another Web Page" onClick="goBack()"/>	
				<input id = "btnSave" type="submit" value="Save Annotations" onClick="saveRenarration()"/>	
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
	
	<div id="AnnotationDiv" style="display:none;" class="annotationInfo">
		
	</div>
	<div id="ReNarrationDiv" style="display:none;" class="ReNarrationDiv">
		<div class="ReNarrationHeadingDiv" width="100%">
    		<span id='renarration_Tab' onclick="show('renarration_Tab','RenarrationTab');">Renarrations</span>
    	</div>
		<div id="RenarrationTab" style="display:block;">
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
						<b>Renarration Details :</b>
					</td>
				</tr>
				<tr>
					<td align="left" valign="top" style="border: solid 1px #E8E8E8;">
						<div id="contentFromIFrameAnnotation"></div>
					</td>
					<td align="left" valign="top" style="border: solid 1px #E8E8E8;">
						<div>
							<div>
								Action : 
								<select id="action" onchange="removeOrReplace();">
									<option value="Replace">Replace</option>
									<option value="Remove">Remove</option>								  									  									  	
								</select>		
								
								<div style="display:inline-block;" align="right">
									<input id = "add_transform" type="button" value="Add Transform" onClick="addTransform()"/>
								</div>
								
								<div id="selectedTextDiv" style="display:none;border: solid 1px red;">
									
								</div>
								<br>
								<div id="selectedText" style="visibility:hidden;">
									
								</div>
							</div> 
							<div id="dynamic_content">
							
							</div>
						</div>
						<div align="right">
							<br><br><hr>
							<input id = "annotate" type="button" value="Apply Transform" onClick="applyRenarration()"/>
							<input id = "annotate" type="button" value="Cancel" onClick="closeRenarrationDiv()"/>				
						</div>
					</td>
				</tr>	
				<tr>
					<td colspan="2" align="left">
						<div id="annotationList" class="annotationList"></div>
					</td>
				</tr>							
			</table>					
		</div>    	
		<div id="AnnotationTab" style="display:none;">
		</div>					
	</div>
	
	<div id="popup" style="display:none;">
		<div class="ReNarrationHeadingDiv" width="100%">
			<span id='motivationTab'>Renarration Details</span>
		</div>
		Please define motivation(s) for renarration : 
		<br><br>
			&nbsp;&nbsp;<input type="checkbox" id="motivation_4" value="rn:alternative">Alternative<br>
			&nbsp;&nbsp;<input type="checkbox" id="motivation_3" value="rn:correction">Correction<br>
			&nbsp;&nbsp;<input type="checkbox" id="motivation_2" value="rn:simplification">Simplification<br>
			&nbsp;&nbsp;<input type="checkbox" id="motivation_1" value="rn:translation">Translation<br>	
		<br>							
		
		Target Audience : 
		<div id="target_audience_span" style="display:none;">
		
		</div>
		<br>
		
		If you would like us to save renarrated content please provide a name : <br>
		&nbsp;&nbsp;<input type="text" id="renarration_name"><br>
		<center>
			<input type="button" value="Create Renarration" onClick="commitRenarration()"/>
			<input type="button" value="Cancel" onClick="closeRenarrationPopup()"/>
		</center>
	</div>	
	
	<textarea id="transforms" style="display:none;"></textarea>
	<input type="text" style="display:none;" id="listOfAnnotations" value="<c:out value="${listOfAnnotations}"/>">
	<input type="text" style="display:none;" id="name" value="<c:out value='<%=request.getSession().getAttribute("name")%>' />">
	<input type="text" style="display:none;" id="email" value="<c:out value='<%=request.getSession().getAttribute("email")%>' />">
	<input type="text" value="" id="selectedText" style="display:none;">
	<input type="text" value="" id="selectedTextAnnotation" style="display:none;">
	
	<div id="RenarrationFormDiv" style="display:none;">
		<form action="/renarration/mongoInsertRenarration" id="RenarrationForm" method="POST">
			<input type="text" value="" name="renarrationText" id="renarrationText">
			<input type="textarea" value="" name="renarrationHTML" id="renarrationHTML">
			<input type="text" value="" name="fileName" id="fileName">
		</form>
	</div>
</body>
</html>
