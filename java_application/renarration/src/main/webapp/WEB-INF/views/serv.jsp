<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="ie6 ielt8"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="ie7 ielt8"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="ie8"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--> <html lang="en"> <!--<![endif]-->
<head>
<title>Renarration Service</title>
<meta charset="utf-8">
	<style>
		body{font-family: calibri}
	
		a.five:link {color:black;text-decoration:none;}
		a.five:visited {color:black;text-decoration:none;}
		a.five:hover {text-decoration:underline;}	
		

	</style>
<script>
		window.onload = function(){
			
			var list = document.getElementById("list").value;
			//alert(list);
			var result = "";
			var renarrations = list.split("__--__");
			for(var i=0; i<renarrations.length; i++){
				if(renarrations[i].length>1){
					//alert(renarrations[i].split("**+**")[1]);
					result = result + "<a href='"+renarrations[i].split("**+**")[1]+"'>"+renarrations[i].split("**+**")[1]+"</a> by "+ renarrations[i].split("**+**")[0] + "<br>";
					//alert(result);			
				}
			}	
			document.getElementById("result").innerHTML = result;			
		}
</script>
</head>
<body align="center">
	<br><br><br><br><br><br><br>
	<table width="100%">
	<tr><td align="center">
	<div style="width:650px;border-radius: 10px;border:2px solid lightgray;padding: 10px;height=30px;" align="center">
		Renarrations for the Web resource requested : <br>
		<div id="result">
	
		</div>
	</div>
	</td></tr></table>
	
	<c:choose>
		<c:when test="${not empty list}">
			<input style="display:none;" type="text" id="list" value="<c:out value="${list}"/>">
		</c:when>
	</c:choose>	
</body>
</html>
