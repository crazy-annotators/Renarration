<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Re-narration</title>
	<script src="/renarration/resources/js/jquery-2.1.4.js"></script>
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
    	 		$("#propertySelection").css("visibility", "visible");
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}  
   	</script>
   	<script>
   	function getDataPropertiesAjaxPost() {  
        
    	var ont = $('#ontology').val().replace("#", "%23");
    	var ont_class = $('#ont_class').val().replace("#", "%23");
    	
		$("#ontology_properties").html("");
		$("#ontology_properties").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "getDataPropertiesAjaxPost",   
     		data : "ont=" + ont + "&ont_class=" + ont_class,   
     		success : function(response) {  
     			$("#ontology_properties").css("visibility", "visible");
    	 		$("#ontology_properties").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}    	
   	</script>
   	<script>
   	function getObjectPropertiesAjaxPost() {  
        
    	var ont = $('#ontology').val().replace("#", "%23");
    	var ont_class = $('#ont_class').val().replace("#", "%23");
    	
		$("#ontology_properties").html("");
		$("#ontology_properties").css("visibility", "hidden");
    	$.ajax({  
     		type : "Get",   
     		url : "getObjectPropertiesAjaxPost",   
     		data : "ont=" + ont + "&ont_class=" + ont_class,  
     		success : function(response) {  
     			$("#ontology_properties").css("visibility", "visible");
    	 		$("#ontology_properties").html(response);
     		},  
     		error : function(e) {  
      			alert('Error: ' + e);   
     		}  
    	});  
   	}    	
	</script>	
</head>	
<body>
	<c:out value="${semanticList}" default="default value of c:out"/>
	<input type="text" id="ontology" />
	<input type="button" value="Load Ontology" onclick="getClassesAjaxPost();" />
	<div id="ontology_classes" style="visibility: hidden">
		
	</div>
	<div id="propertySelection" style="visibility: hidden">
		<input type="radio" name="group1" value="Data Properties" onclick="getDataPropertiesAjaxPost()">Data Properties
		<input type="radio" name="group1" value="Object Properties" onclick="getObjectPropertiesAjaxPost()"> Object Properties<br>
	</div>
	<div id="ontology_properties" style="visibility: hidden">
	</div>
</body>
</html>
