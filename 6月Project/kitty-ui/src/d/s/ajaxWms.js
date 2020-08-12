  var xmlHttpReg = null;

    if (window.ActiveXObject) {//如果是IE
        xmlHttpReg = new ActiveXObject("Microsoft.XMLHTTP");
     } else if (window.XMLHttpRequest) {
        xmlHttpReg = new XMLHttpRequest(); //实例化一个xmlHttpReg
     }
function myReflash(url,fun,err){

		this.url="http://180.117.162.148:10009"+url;
		var doResult = function () {
        if (xmlHttpReg.readyState == 4 && xmlHttpReg.status == 200) {//4代表执行完成
	        var res= JSON.parse(xmlHttpReg.responseText)
	        try{
	        	fun(res)
	        	}catch(e){}

	        setTimeout(ajax, 1000);
        }
		    if(xmlHttpReg.readyState == 4 &&(xmlHttpReg.status == 0||xmlHttpReg.status == 404) ){
		    	if(err){
			    		var data=[];
			    		data.push(Math.random())
			    		data.push(Math.random())
			    		data.push(Math.random())
			    		data.push(Math.random())
			    	  data.push(Math.random())
			    		data.push(Math.random())
			    		data.push(Math.random())
			    		data.push(Math.random())
			    	  data.push(Math.random())
			    		data.push(Math.random())
			    		data.push(Math.random())
			    		err(data)
		    	}
		 			setTimeout(ajax, 1000);
		    }
    }
		var ajax= function(){
			 xmlHttpReg.open("get", this.url, true);
				try{

					xmlHttpReg.send();
					xmlHttpReg.onreadystatechange = doResult; //设置回调函数
				}catch(e){
						if(err){
								err((Math.random()+0.5)*50000)
						}
							setTimeout(ajax, 1000);
				}
	        }

			ajax();
	}













