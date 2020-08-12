	  
function initCarrier(context){
    rightCarrier(context);
    leftCarrier(context);
    initVerticeGraph();
}
	  
	  
function rightCarrier(context){

	    var xV=stockend+carrierlength+stockSize;
	 	  var xH=stockend+carrierlength/2+parseInt((stockSize+1)/2)-1.25*stockSize/2
    	var hWidth =carrierlength-1.25*stockSize
    	
    	
    for(var i=1;i<12;i++){
    	  var yBase =getCraneY(i)+stockSize*1.25;
    	  carrierList.push(new CarrierChain(getRightHid(i),context,xH ,getUpStockY(i),hWidth))
    	  carrierList.push(new CarrierChain(getRightHid(i),context,xH ,getDownStockY(i),hWidth))
    	  
    	  
    	  carrierList.push(new CarrierChain(getRightVid(i),context,xV-1.25*stockSize,getVY(i),craneGap,90))//垂直
    	  carrierList.push(new CarrierChain(getRightVid(i),context,xV,getVY(i),craneGap,90))//垂直
    	  yzjList.push(new Yzj(getRightVid(i)+1,context,xV,getUpStockY(i),stockSize,stockSize));
    	  if(i==3){
    	  	  carrierList.push(new CarrierChain(2208,context,xV,getVY(i)+craneGap-4,getCraneY(4)-getCraneY(3)-craneGap,90))//垂直
    	  	
    	  }
    	  if(i==7){
          	  	carrierList.push(new CarrierChain(2208,context,xV,getVY(i)+craneGap-4,getCraneY(8)-getCraneY(7)-craneGap,90))//垂直
        }
    	  
    	}
    	 
    	
	}
	
	function leftCarrier(context){
		    	    	var xBase=carrierOffsetX;
		    	    	var xH=xBase+carrierlength/2+parseInt((stockSize+1)/2)+1.25*stockSize/2
            	  var yBase =getCraneY(1)-stockSize*1.25;
            	  
            	  var hWidth =carrierlength-1.25*stockSize
            	  
            	  carrierList.push(new CarrierChain(2001,context,xBase,getUpStockY(1)-craneGap*1.2,craneGap*0.8,90))//垂直
            	  
            	  for(var i=1;i<12;i++){
            	  	    carrierList.push(new CarrierChain(getLeftHid(i),context,xH,getUpStockY(i),hWidth))
            	  	    carrierList.push(new CarrierChain(getLeftHid(i),context,xH,getDownStockY(i),hWidth))
            	  	    
            	  	    carrierList.push(new CarrierChain(getLYid(i)-1,context,xBase+1.25*stockSize,getVY(i),craneGap,90))//垂直
			            	  carrierList.push(new CarrierChain(getLYid(i)-1,context,xBase,getVY(i),craneGap,90))//垂直
			            	  yzjList.push(new Yzj(getLYid(i),context,xBase,getUpStockY(i),stockSize,stockSize));
			            	  if(i==3){
			            	  	  carrierList.push(new CarrierChain(2008,context,xBase,getVY(i)+craneGap-4,getCraneY(4)-getCraneY(3)-craneGap,90))//垂直
			            	  	
			            	  }
			            	  if(i==7){
			            	  	  carrierList.push(new CarrierChain(2017,context,xBase,getVY(i)+craneGap-4,getCraneY(8)-getCraneY(7)-craneGap,90))//垂直
			            	  	
			            	  }
            	  }
            	

}
function pathOffset(CraneId){
		if(CraneId<4){
			return 0;
			}else if(CraneId<8){
				return 1;
			}else {
				return 2;
			}
	}
function getRightHid(CraneId){//水平id
	
	if(CraneId<4){
		return 2208+CraneId;
	}else {
			return 105+2208+CraneId;
	}

}
function getRightVid(CraneId){//垂直id
	if(CraneId<4){
			return 2200+CraneId*2;
	}else if(CraneId<8){
		  return 2292+CraneId*2;
	}else {
			return 2293+CraneId*2;
	}
}
		   
		    	
		  
function getLeftHid(CraneId){//水平id
		return 2025+CraneId
	}
		    
function getLYid(CraneId){
	return 2001+pathOffset(CraneId)+CraneId*2
}
		    	
		    	
function initVerticeGraph(){
  		
  		var graph =new VerticeGraph();

		for(var i=2001;i<2025;i++){
			graph.addEdge(i,i+1);
		}

		graph.addEdge(2003,2026);
		graph.addEdge(2005,2027);
		graph.addEdge(2007,2028);

		graph.addEdge(2010,2029);
		graph.addEdge(2012,2030);
		graph.addEdge(2014,2031);
		graph.addEdge(2016,2032);

		graph.addEdge(2019,2033);
		graph.addEdge(2021,2034);
		graph.addEdge(2023,2035);
		graph.addEdge(2025,2036);

		for(var i=2201;i<2208;i++){
			graph.addEdge(i,i+1);
		}
		graph.addEdge(2208,2300)
		for(var i=2300;i<2316;i++){
			graph.addEdge(i,i+1);
		}

		graph.addEdge(2203,2209);
		graph.addEdge(2205,2210);
		graph.addEdge(2207,2211);

		graph.addEdge(2301,2317);
		graph.addEdge(2303,2318);
		graph.addEdge(2305,2319);
		graph.addEdge(2307,2320);

		graph.addEdge(2310,2321);
		graph.addEdge(2312,2322);
		graph.addEdge(2314,2323);
		graph.addEdge(2316,2324);
}
		    	