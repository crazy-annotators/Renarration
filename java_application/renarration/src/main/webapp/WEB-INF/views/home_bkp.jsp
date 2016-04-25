<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Re-narration</title>
	
	<!-- Java Script Includes -->
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
	<script src="http://assets.annotateit.org/annotator/v1.2.5/annotator-full.min.js"></script>	
	<script src="http://annotorious.github.com/latest/annotorious.okfn.js"></script>
	<script src="http://localhost:8181/renarration/resources/js/re-narration.js"></script>
	<!-- Java Script Includes -->
	
	<!-- CSS Includes -->
	<link rel="stylesheet" href="http://assets.annotateit.org/annotator/v1.2.5/annotator.min.css">
	<!-- CSS Script Includes -->
	
	<!-- Functions -->
	<script>

	</script>
	<!-- Functions -->	
</head>
<body>
	<h1>
		This framework is designed to allow users to annotate and re-narrate web elements so that the content
		on the Web will be more accessible to users.  
	</h1>
	<input id = "btnSubmit" type="submit" value="Load" onClick="httpGet('http://localhost:8181/renarration/resources/a.html')"/>
	<input id = "annotate" type="button" value="Annotate" onClick="enableAnnotationOnIframe('renarrationDiv')"/>
	<div align="center">
		<iframe id="renarrationDiv" width="80%" height="800"></iframe>
	</div>
</body>
</html>
