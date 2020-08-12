  carrierTaskRun=(function  (){
  	         speed=0.1
				   	 var taskRunStatus={};
				   	 
				   	  function getAnchor(taskNo){
				   	 	   var taskObj=taskRunStatus[taskNo];
				   	 	   ++taskObj.time;
						   	  var beginAnchor =taskObj.beginAnchor;
					        var endAnchor = taskObj.endAnchor;
						   	 var corren= {x:beginAnchor.x+taskObj.move.x*taskObj.time*speed,y:beginAnchor.y+taskObj.move.y*taskObj.time*speed}
						   	 
						   	
					       if(taskObj.move.x!=0&&(corren.x-endAnchor.x)*(corren.x-beginAnchor.x)>0||taskObj.move.y!=0&&(corren.y-endAnchor.y)*(corren.y-beginAnchor.y)>0){
					        	taskObj.time--;
					       }
					       return corren
				   	 	
				   	 }
				   	 
				   	 function initTaskRunStatus(res,beginCarrier,endCarrier){
				   	 	         var beginAnchor =  beginCarrier.getAnchor();
								       var beginWidth = beginCarrier.width;
								       var endAnchor = endCarrier.getAnchor();
								       var endWidth = endCarrier.width;
								      res.beginAnchor=beginAnchor
									    res.endAnchor=endAnchor
								      
										  if(Math.abs(beginAnchor.x-endAnchor.x) >Math.abs(beginAnchor.y-endAnchor.y)){//水平行走
									      	if(beginAnchor.x>endAnchor.x){
									      			res.move={x:-1,y:0}
									      			res.beginAnchor.x+=beginWidth/2
									      			res.endAnchor.x-=endWidth/2-5
									        }else{
									        		res.move={x:1,y:0}
									        	  res.beginAnchor.x-=beginWidth/2
									        	  res.endAnchor.x+=endWidth/2-5
									        }
								      }else {
									      	if(beginAnchor.y>endAnchor.y){
									      		 res.move={x:0,y:-1}
									      		 res.beginAnchor.y+=beginWidth/2
									      		 res.endAnchor.y-=endWidth/2-5
									        }else{
									        	 res.move={x:0,y:1}
									        	 res.beginAnchor.y-=beginWidth/2
									        	 res.endAnchor.y+=endWidth/2-5
									        }
								      }
								      return res;
				   	 	
				   	 	}
  return  new  function(){
			    	
				   	 this.updateTask=function(taskNo,begin,end){
					   	 if(!taskRunStatus.hasOwnProperty(taskNo)){
					   	 			taskRunStatus[taskNo]={}
					   	 }
					   	 
					   	 if(taskRunStatus[taskNo].beginPath!=begin||taskRunStatus[taskNo].endPath!=end){
						   	 		taskRunStatus[taskNo].beginPath=begin;
						   	 		taskRunStatus[taskNo].endPath=end;
						   	 		taskRunStatus[taskNo].time=0;
						   	 		var beginCarrier={}
						   	 	  var endCarrier={}
						   	 		for(var i=0;i<carrierList.length;i++){
									     	 var carrier=		carrierList[i]
							     			 if(carrier.id==begin){
							     			 	  beginCarrier = carrier
							     			 }else if(carrier.id==end){
							     			 	  endCarrier = carrier
							     			 }
							     			 if(beginCarrier.id&&endCarrier.id){
							     			 		break;
							     			 }
							      }
						   	 		initTaskRunStatus(taskRunStatus[taskNo],beginCarrier,endCarrier)
						   	 		
						   	 		
					   	 }
					   	 taskRunStatus[taskNo].perClear=0;
				   	 }
				 	 this.perClear=function(){
				   	for(var taskNo in taskRunStatus){
				   		taskRunStatus[taskNo].perClear=1;
				   	}
				 	 }
				   	 
				   	 
				   	 this.myClear=function(){
						   	for(var key in taskRunStatus){
						   			if(taskRunStatus[key].perClear==1){
						   					delete taskRunStatus[key]
						   			}
						   	}
				   	 }
				   	 
				   	 this.getAllAnthor=function(){
				   	 	var array=[];
				   	 	for(var taskNo in taskRunStatus){
					   	 		var dat=getAnchor(taskNo);
					   	 		array.push(dat)
				   	 	}
				   	 	return array;
				   	 }
				   	 
				   	
	   	 }
	   	 
   	}())
   
   
   
   
   