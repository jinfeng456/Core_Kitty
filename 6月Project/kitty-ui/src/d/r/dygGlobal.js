var cranePic = new Image();  
    cranePic.src = "png/crane.png";  
    var backPic = new Image();  
    backPic.src = "png/back.png";  
    var productPic = new Image();  
    productPic.src = "png/product.png";  
    
    var carrierBackPic = new Image();  
    carrierBackPic.src = "png/carrierBack.png";  
    screenHeight= window.screen.height 
    screenWidth =window.screen.width
    productBegin =150//其实y坐标
    carrierOffsetX=25;//边距距离
    cols=82
    carrierlength = screenWidth/20;//水平传输线长 
    stockSize=parseInt((screenWidth-carrierOffsetX*2-carrierlength*2-20)/cols)//货位边长
    carrierList=[]; 
    yzjList=[]; 
 
    
    storestock = [];//货架位置
    //货位总长度 20 大概是俩边各半个传输线宽度
    stockBgin=carrierOffsetX+carrierlength+stockSize+2//2 是传输线边框宽度
    stockend=stockBgin+stockSize*(cols-1);
    
    craneList=[];  
    craneBegin=stockBgin-stockSize-2;
    craneEnd=stockend+stockSize+2
    craneGap=(screenHeight-productBegin)/11;
    craneGap=craneGap>stockSize*3.5?stockSize*3.5:craneGap
    
    
    
    function getYmm(i){
    	var y=4150*(i-1);
    	if(i>3){
    		y+=7440-4150;
    	}
    	if(i>7){
    		y+=7530-4150;
    	}
    	return y;
    }
    
    function getCraneY(i){
    	var all = getYmm(12);
    	var me =getYmm(i);
    	var allpx=screenHeight-productBegin;
    	return productBegin+allpx*me/all;
    	
    }
 
   
      function myDraw(context){
      	
      	 context.drawImage(backPic,0,0,canvas.width, canvas.height)
      	 	for(var i=0;i<storestock.length;i++){
        		storestock[i].draw();
        	}
      	 for(var i=0;i<carrierList.length;i++){
				     	 var carrier=		carrierList[i]
		     			 carrier.draw();
		     }
		     for(var i=0;i<yzjList.length;i++){
				     	 var yzj=		yzjList[i]
		     			 yzj.draw();
		     }
		     
		    
		     showCrane();
		     var arr =  carrierTaskRun.getAllAnthor();
   			for(var i=0;i<arr.length;i++){
   				 var p=new Product(context,68*i,170,stockSize);
   				 p.setAnchor(arr[i])
   				 p.draw();
   			}
		     	
       
      } 
      
      function showCrane(){
		    	 for(var i=0;i<craneList.length;i++){
				     	 var crane1=		craneList[i]
				     	 var xmm=crane1.getAnchor().x;
				     	 var goal=crane1.xGoal;
				     	 
				     	 if(goal>xmm){//目标在右边
				     	 	  crane1.xa=Math.abs(crane1.xa)
					     	 	if(crane1.xv<0){//向左跑
					     	 		crane1.xv+=crane1.xa/10;
					     	 	}
				     	 	
				     	 	}else if(goal<xmm){//目标在左边
				     	 		 crane1.xa=-Math.abs(crane1.xa)
					     	 	if(crane1.xv>0){//向右跑
					     	 		crane1.xv+=crane1.xa/10;
					     	 	}
				     	 	}
				     	 
				     	 var x=	crane1.xv/60.0
				     	 if(Math.abs(goal-xmm)<2){
				     	 	   crane1.setAnchor({x:crane1.xGoal,y:crane1.y})
				     	 }else{
				     	 		 crane1.move(x,0)
				     	 }
		     			 crane1.draw();
		     			 
		     }
		       product1.setAnchor(crane1.getAnchor());
		       product1.draw();
		    }
		    
		   
		    	
    	function 	getVY(CraneId){
    	   	return getUpStockY(CraneId)-craneGap/2+stockSize/2;
    	}
    	
    	function 	getUpStockY(CraneId){
    	   	return getCraneY(CraneId)-stockSize*1.25;
    	}
    	function 	getDownStockY(CraneId){
    	   	return getCraneY(CraneId)+stockSize*1.25;
    	}
		    	
		    
		  function initCrane(context){
		  	
		  	   for(var i=1;i<12;i++){
			       	   craneList.push(new Crane(context,(craneBegin+craneEnd)/2,getCraneY(i),stockSize))
			      }
		  	
		  	}
		  	
		  	   
		  function initStock(context){
		  	
		  	   for(var j=1;j<12;j++){
					  	for(var i=0;i<cols;i++){
		        		storestock.push(new Product(context,stockBgin+i*stockSize,getUpStockY(j),stockSize))
		        		storestock.push(new Product(context,stockBgin+i*stockSize,getCraneY(j)+stockSize*1.25,stockSize))
		        	}
					  }
		  	
		  	}
		 
		    
		    	    	