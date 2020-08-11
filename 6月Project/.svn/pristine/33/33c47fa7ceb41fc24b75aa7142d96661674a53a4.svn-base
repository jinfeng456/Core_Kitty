  function showTuli(context){
  	/*
  	   			var tulix=200;
          tuli(context,tulix,"入库中",'#aaaaff');
          tulix+=150
      		tuli(context,tulix,"库存",'#1111ff');
      		tulix+=150
      		tuli(context,tulix,"出库中",'#6666c4');
      		*/
  	}
  	  function addStockProduct(context,storeRoom,id,status){
    	    var widthType=2
     	  	var w=9;
     	  	var color="#ffffff";
     	  	if(widthType==2){
     	  		w=storeRoom.storeWidth/9
     	  		 if(status==1){
     	  			color="#fa0";
     	  		} else if(status==2){
     	  			color="#1111ff";
     	  		}else if(status==3){
     	  			color="#f0f";
     	  			}
     	  	}else if(widthType==1){
     	  		w=storeRoom.storeWidth/11
     	  		 if(status==1){
     	  			color="#fa0";
     	  		} else if(status==2){
     	  			color="#ffff00";
     	  		}else if(status==3){
     	  			color="#ffff66";
     	  		}
     	  	}
     	  	var  key=parseInt(id)
     	    var  index=1
     	  	var stock = new StockProduct(context,color);
     	  	var store = storeRoom.stores['k'+key];
     	  	var anchor = store.getAnchor();
     	  	
     	  	var newAnchor={x:anchor.x,y:anchor.y}
     	  	
     	  	stock.setAnchor(newAnchor)
     	  	stock.draw();
     	  }
     	  
  
  function tuli(context,tuliy,info,color){
    	    tuliy/=2.5
    			var tulix=1010;
    			var tuli = new   Rectangle(context,tulix,tuliy,tulix+80,tuliy+20,0.5,color);
      		tuli.draw();  
      		context.fillStyle='#000000'
      		context.fillText(info,tulix,tuliy+35);
    	
    	}
    	
    	
           
  
     	   
        function getLocation(x, y) {
					var bbox = canvas.getBoundingClientRect();
					return {
						x: (x - bbox.left) * (canvas.width / bbox.width),
						y: (y - bbox.top) * (canvas.height / bbox.height)
						
						/*
						 * 此处不用下面两行是为了防止使用CSS和JS改变了canvas的高宽之后是表面积拉大而实际
						 * 显示像素不变而造成的坐标获取不准的情况
						x: (x - bbox.left),
						y: (y - bbox.top)
						*/
					};
				}