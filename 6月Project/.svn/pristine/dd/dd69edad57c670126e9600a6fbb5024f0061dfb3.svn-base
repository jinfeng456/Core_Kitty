  var info = document.getElementById("info");
  var selectId=0;
  var loadId=0;
  var selectData={}
  var xmlHttpReg2 = null;
  if (window.ActiveXObject) {//如果是IE
      xmlHttpReg2 = new ActiveXObject("Microsoft.XMLHTTP");
   } else if (window.XMLHttpRequest) {
      xmlHttpReg2 = new XMLHttpRequest(); 
   }
  
document.onmousemove = function(event){
            event = event || window.event;
            var x = event.clientX;
            var　y = event.clientY;
            
            var height= window.screen.height 
            var width= window.screen.width 
            if(x<width/2){
            	 
                 info.style.left = (x+2)  + "px";
             
            }else{

            	   info.style.left = (x-220-2)  + "px";
            }
            	
            if(y<height/2){
            		  info.style.top = (y+2)  + "px";  
             }else{
            	    info.style.top = (y-170-2)  + "px";  
            }
         
          
            
};

  
function loadData(fun,err){

		var doResult2 = function () {
				if(xmlHttpReg2.readyState != 4 ){
					return 
				}
        if ( xmlHttpReg2.status == 200) {//4代表执行完成
	        var res= JSON.parse(xmlHttpReg2.responseText)
	        try{
	        	fun(res)
	        	}catch(e){}
	        
	        setTimeout(ajax2, 100);
        }else {
		    	if(err){
		    		 err()
		    	}
		 			setTimeout(ajax2, 1000);
		    }
    }
		var ajax2= function(){
						if(selectId==0){
							 info.style.display="none"
				     	 setTimeout(ajax2, 100);
				     	 return;
			     	}
			
			     if(loadId==selectId){
				     	 setTimeout(ajax2, 100);
				     	 return;
			     	}
			     loadId=selectId;
			     
           xmlHttpReg2.open("get", "http://180.117.162.148:10009/api/dp/load/"+loadId, true);
						try{
								xmlHttpReg2.send();
								xmlHttpReg2.onreadystatechange = doResult2; //设置回调函数
								
						}catch(e){
								if(err){
										err()
								}
							  setTimeout(ajax2, 10000);
						}
	        
			
			}
			ajax2();
	}
	
	
	 loadData(function(val){
			    
    	selectData = val.data;
    	if(selectData=="NoData"){
    		  info.style.display="none"
    		}else{
    			var html ="货位编号："+selectData.cs.locId+"<br/>托盘条码："+selectData.cs.boxCode+"<br>货位状态："
    			if(selectData.cs.status==1){
    				html+="入库中"
    			}else if(selectData.cs.status==2){
    				html+="库存"
    			}else if(selectData.cs.status==3){
    				html+="出库中"
    			}else {
    				html+=selectData.cs.status
    			}
    			
    			for(var i in selectData.list ){
	    				var detial=selectData.list[i];
	    				if(detial.stockStatus==-1){
	    						continue;
	    				}
	    				
	    				html+="<br/>物料编码："+detial.itemCode
	    			  html+="<br/>入库时间："+detial.inTime.substr(0,10)
	    			  html+="<br/>内部批号："+detial.wmsBanchNo
	    			  html+="<br/>库存数量："+detial.countDb
    				
    				}
    			
  			  info.innerHTML=html
  			  info.style.display="block"
    		}
	         
  })