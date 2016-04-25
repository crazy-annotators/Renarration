<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="ie6 ielt8"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="ie7 ielt8"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="ie8"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--> <html lang="en"> <!--<![endif]-->
<head>
<meta charset="utf-8">
<title>Login - Renarration Prototype</title>
<link rel="stylesheet" href="/renarration/resources/css/login.css">
	<script>
		
		function generateUUID() {
			var d = new Date().getTime();
			var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
				var r = (d + Math.random()*16)%16 | 0;
				d = Math.floor(d/16);
				return (c=='x' ? r : (r&0x3|0x8)).toString(16);
			});
			return uuid;
		}		
		
		function submitLoginForm(){
			var id_elem = document.getElementById('user_id');
			id_elem.value = generateUUID();
			
			// submit form
			var form = document.getElementById('LoginForm');
			form.submit();
			
		}	
		

	</script>
</head>
<body>
<div class="container">
	<section id="content">
		<form action="/renarration/login" id="LoginForm" method="POST">
			<h1>Login</h1>
			<div>
				<input type="text" placeholder="Name" name="name" required="" id="name" />
			</div>
			<div>
				<input type="text" placeholder="Email" name="email" required="" id="email" />
			</div>
			<div style="display:none;">
				<input type="text" placeholder="id" name="user_id" id="user_id" />
			</div>			
			<div>
				<c:choose>
					<c:when test="${not empty nameMessage}">
						<div><c:out value="${nameMessage}"/></div> 				
					</c:when>
				</c:choose>
				<c:choose>
					<c:when test="${not empty emailMessage}">
						<div><c:out value="${emailMessage}"/></div> 					
					</c:when>
				</c:choose>				
				<input type="button" value="Log in" onClick="submitLoginForm();"/>
			</div>
		</form><!-- form -->
	</section><!-- content -->
</div><!-- container -->
</body>
</html>