var imageX = 0; var imageY = 0;
var cx = 0;  var cy = 0;	// current mouse position
var xs = 0;  var ys = 0;	// position on first click (setPosFlag = -1)
var imgString = '<img id="shape" height:"700px"  width="600px" src="http://mitan.in/bcp/raika/image.jpg">';
var xpos = 0;  var ypos = 0;
var annotationDIV = "annotationDIV";
var imgString = "";
var annotated_imageID = "shape";

function $_(IDS) { return document.getElementById(IDS); }

function FindPosition(element){
var xPosition = 0;
    var yPosition = 0;
      
    while (element) {
        xPosition += (element.offsetLeft - element.scrollLeft + element.clientLeft);
        yPosition += (element.offsetTop - element.scrollTop + element.clientTop);
        element = element.offsetParent;
    }
    return [ xPosition, yPosition ];
}

// From: http://www.p01.org/releases/Drawing_lines_in_JavaScript/
function DrawLine() {
	var Ax = xs;  var Ay = ys;
	var Bx = cx;  var By = cy;

	var bla = "";
	var x0 = document.getElementById("x0");
	var y0 = document.getElementById("y0");
	var x1 = document.getElementById("x1");
	var y1 = document.getElementById("y1");
	var x2 = document.getElementById("x2");
	var y2 = document.getElementById("y2");
	x1.value = Ax-imageX;
	y1.value = Ay-imageY;
	x2.value = Bx-imageX;
	y2.value = By-imageY;	
	
		var position = FindPosition(document.getElementById(annotated_imageID));
	x0.value = position[0];
	y0.value = position[1];
	imageX = position[0];
	imageY = position[1];
	
	//var lineLength = Math.sqrt( (Ax-Bx-imageX)*(Ax-Bx-imageX)+(Ay-By-imageY)*(Ay-By-imageY) );  

	//for( var i=0; i<lineLength; i++ ) {
		bla += "<div style='float:left;position:absolute;left:"
			+ Math.abs(Ax-imageX+2) +"px;top:"+ Math.abs(Ay-imageY+53) +"px;width:"+Math.abs(Bx-Ax)+"px;height:"+Math.abs((By-Ay))+"px;background:rgba(255,0,0,0.5)'></div>";
	//}
	$_(annotationDIV).innerHTML = bla + $_(annotationDIV).innerHTML;
  

  
  
  

}

function followMe(evt) {
	var e = (evt) ? evt : ((window.event) ? event : null);
	if (e.pageX || e.pageY){
		xpos = e.pageX;  
		ypos = e.pageY;  
		
	}
	else if (e.clientX || e.clientY)
    {
		xpos = e.clientX + document.body.scrollLeft
        	+ document.documentElement.scrollLeft;
		ypos = e.clientY + document.body.scrollTop
        	+ document.documentElement.scrollTop;
    }

	cx = xpos;
	cy = ypos;

	if (setPosFlag == 0) {
		$_(annotationDIV).innerHTML = imgString;
		DrawLine();
	}
}

function setPos() {
	switch (setPosFlag) {
    	case -1: 
    		xs = xpos;  // $_('SxPos').value = xpos;
    		ys = ypos;  // $_('SyPos').value = ypos;
			//alert(xs);
    		setPosFlag = 0;  break;
    	case 0: 
    		$_(annotationDIV).innerHTML = imgString;
    		DrawLine();
    		setPosFlag = -1;  break;
    	default: break;
	}
}

function ClearInfo() {
	$_(annotationDIV).innerHTML = imgString;
	setPosFlag = -1;
}