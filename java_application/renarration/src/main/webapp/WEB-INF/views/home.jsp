<?xml version="1.0" encoding="utf-8"?>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<meta charset="UTF-8">
	<title>Renarration Prototype</title>
	
	<!-- Java Script Includes -->
	<script src="/renarration/resources/js/re-narration.js"></script>
	<script src="/renarration/resources/js/img_annotation.js"></script>
	<script src="/renarration/resources/js/tinymce/tinymce.min.js"></script>
	<script src="/renarration/resources/js/jquery-2.1.4.js"></script>
	<!-- Java Script Includes -->

	<script>
		
		function loadRemotePageRenarrate(){
			var remotePageURL = document.getElementById('remoteURL');
			window.location.href='/renarration/url?page=' + remotePageURL.value+"&action=renarrate";
			//iFrame.src = remotePageURL.value;
			//alert(remotePageURL);			
			//httpGet(remotePageURL.value);
		}
		
		function loadRemotePageAnnotate(){
			var remotePageURL = document.getElementById('remoteURL');
			window.location.href='/renarration/url?page=' + remotePageURL.value+"&action=annotate";
			//iFrame.src = remotePageURL.value;
			//alert(remotePageURL);			
			//httpGet(remotePageURL.value);
		}		
		
		function loadRemotePage(){
			var remotePageURL = document.getElementById('remoteURL');
			window.location.href='/renarration/serv?page=' + remotePageURL.value+"";
			//iFrame.src = remotePageURL.value;
			//alert(remotePageURL);			
			//httpGet(remotePageURL.value);
		}		
		

	</script>
	<!-- Functions -->
</head>
<body>
	<div style="margin:200px auto;">
	<table width="100%">
		<tr>
			<td align="center">
				<h1>Renarration Prototype</h1> <br>				
			</td>
		</tr>	
		<tr>
			<td align="center"><u>Please provide a valid URL and start Annotating and/or Renarrating!</u></td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>		
		<tr>
			<td align="center">
				<input type="text" id="remoteURL" style="width: 400px;" value="RemoteUrl"/> 
				&nbsp;&nbsp;<input id = "btnSubmit" type="submit" value="Annotate" onClick="loadRemotePageAnnotate()"/>
				&nbsp;&nbsp;<input id = "btnSubmit" type="submit" value="Renarrate" onClick="loadRemotePageRenarrate()"/>
				&nbsp;&nbsp;<input id = "btnSubmit" type="submit" value="Renarration Service" onClick="loadRemotePage()"/>				
			</td>
		</tr>
	</table>
</div>	
</body>
</html>
