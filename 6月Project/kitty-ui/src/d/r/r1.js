	  
function initCarrier(context){
    rightCarrier(context);
    leftCarrier(context);
    initVerticeGraph();
}
	  
	  
function rightCarrier(context){

	    var xV=stockend+carrierlength+stockSize;//垂直输送线
	 	  var xH=stockend+carrierlength/2+parseInt((stockSize+1)/2)-1.25*stockSize/2
    	var hWidth =carrierlength-1.25*stockSize
    	var xBase=xV;
    	
    	          var y1=getUpStockY(1)-craneGap*2.1;
  	            carrierList.push(new CarrierChain(1210,context,xBase,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1206,context,xBase-craneGap*1.1-45,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1203,context,xBase-craneGap*1.1*2-45,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1200,context,xBase-craneGap*1.1*3-45,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1283,context,xBase-craneGap*1.1*4-45,y1+11,craneGap*0.8,90))//垂直
            	  carrierList.push(new CarrierChain(1299,context,xBase-craneGap*1.1*5-45,y1+11,craneGap*0.8,90))//垂直
           
            	  
            	  var inHY=getUpStockY(1)-craneGap*1.6-stockSize/2;
            	  yzjList.push(new Yzj(1211,context,xBase,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1207,context,xBase-craneGap*1.1-45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1204,context,xBase-craneGap*1.1*2-45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1201,context,xBase-craneGap*1.1*3-45,inHY,stockSize,stockSize));
            	  
            	  carrierList.push(new CarrierChain(1209,context,xBase-craneGap*0.4,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1208,context,xBase-craneGap*1.5,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1205,context,xBase-craneGap*2.6,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1202,context,xBase-craneGap*3.7,inHY,craneGap*1.1))//水平
            	  
            	  inHY=inHY+1.25*stockSize
            	  carrierList.push(new CarrierChain(1225,context,xBase-craneGap*0.4-stockSize*1.25,inHY,craneGap*1.1))//水平
            	 
            	  carrierList.push(new CarrierChain(1226,context,xBase-craneGap*2.4,inHY,craneGap*2.15))//水平
            	  carrierList.push(new CarrierChain(1227,context,xBase-craneGap*3.7-stockSize*1.25/2,inHY,craneGap*1.1-stockSize*1.25))//水平
            	  yzjList.push(new Yzj(1228,context,xBase-craneGap*1.1*3-45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1230,context,xBase-craneGap*1.1*4-45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1232,context,xBase-craneGap*1.1*5-45,inHY,stockSize,stockSize));
            	  
            	  carrierList.push(new CarrierChain(1229,context,xBase-craneGap*4.5-stockSize,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1231,context,xBase-craneGap*5.9,inHY,craneGap*1.1))//水平
            	  
            	  
         
            	  carrierList.push(new CarrierChain(1214,context,xBase-1.25*stockSize,getUpStockY(1)-craneGap*0.5,craneGap*0.7,90))//垂直
            	  carrierList.push(new CarrierChain(1223,context,xBase-1.25*stockSize,getUpStockY(1)-craneGap*1.05,stockSize,90))//垂直
            	  
            	  var xBaseNear=xBase-1.25*stockSize;
            	
            	  
            	 
            	     carrierList.push(new CarrierChain(1222,context,xH,getUpStockY(1),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1216,context,xH,getDownStockY(1),hWidth))
            	  	    
            	  	   
            	  	    yzjList.push(new Yzj(1221,context,xBaseNear,getUpStockY(1),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1220,context,xBaseNear,getVY(1)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1215,context,xBaseNear,getDownStockY(1),stockSize,stockSize));
            	  
            	  
            	   
            	       carrierList.push(new CarrierChain(1219,context,xH,getUpStockY(2),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1358,context,xH,getDownStockY(2),hWidth))
            	  	    
            	  	 
            	  	    yzjList.push(new Yzj(1218,context,xBaseNear,getUpStockY(2),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1217,context,xBaseNear,getVY(2)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1354,context,xBaseNear,getDownStockY(2),stockSize,stockSize));
            	  
            	     carrierList.push(new CarrierChain(1357,context,xH,getUpStockY(3),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1359,context,xH,getDownStockY(3),hWidth))
            	  	   
            	  	    yzjList.push(new Yzj(1355,context,xBaseNear,getUpStockY(3),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1356,context,xBaseNear,getVY(3)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1352,context,xBaseNear,getDownStockY(3),stockSize,stockSize));
            	  
            	     carrierList.push(new CarrierChain(1360,context,xH,getUpStockY(4),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1361,context,xH,getDownStockY(4),hWidth))
            	  	    
            	  	  
            	  	    yzjList.push(new Yzj(1349,context,xBaseNear,getUpStockY(4),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1348,context,xBaseNear,getVY(4)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1347,context,xBaseNear,getDownStockY(4),stockSize,stockSize));
            	  
            	   
            	     carrierList.push(new CarrierChain(1362,context,xH,getUpStockY(5),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1363,context,xH,getDownStockY(5),hWidth))
            	  	    
            	  	    
            	  	    yzjList.push(new Yzj(1346,context,xBaseNear,getUpStockY(5),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1345,context,xBaseNear,getVY(5)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1343,context,xBaseNear,getDownStockY(5),stockSize,stockSize));
            	  
            	 
            	     carrierList.push(new CarrierChain(1364,context,xH,getUpStockY(6),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1365,context,xH,getDownStockY(6),hWidth))
            	  	    
            	  	    
            	  	    yzjList.push(new Yzj(1342,context,xBaseNear,getUpStockY(6),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1341,context,xBaseNear,getVY(6)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1340,context,xBaseNear,getDownStockY(6),stockSize,stockSize));
            	  
            	  
            	  
            	     carrierList.push(new CarrierChain(1366,context,xH,getUpStockY(7),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1367,context,xH,getDownStockY(7),hWidth))
            	  	    
            	  	  
            	  	    yzjList.push(new Yzj(1339,context,xBaseNear,getUpStockY(7),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1338,context,xBaseNear,getVY(7)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1337,context,xBaseNear,getDownStockY(7),stockSize,stockSize));
            	  
            	  
            	     carrierList.push(new CarrierChain(1368,context,xH,getUpStockY(8),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1369,context,xH,getDownStockY(8),hWidth))
            	  	    
            	  	 
            	  	    yzjList.push(new Yzj(1333,context,xBaseNear,getUpStockY(8),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1332,context,xBaseNear,getVY(8)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1331,context,xBaseNear,getDownStockY(8),stockSize,stockSize));
            	  
            	  
            	     carrierList.push(new CarrierChain(1370,context,xH,getUpStockY(9),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1371,context,xH,getDownStockY(9),hWidth))
            	  	    
            	  	   
            	  	    yzjList.push(new Yzj(1330,context,xBaseNear,getUpStockY(9),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1329,context,xBaseNear,getVY(9)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1327,context,xBaseNear,getDownStockY(9),stockSize,stockSize));
            	  
            	     carrierList.push(new CarrierChain(1372,context,xH,getUpStockY(10),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1373,context,xH,getDownStockY(10),hWidth))
            	  	    
            	  	    yzjList.push(new Yzj(1326,context,xBaseNear,getUpStockY(10),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1325,context,xBaseNear,getVY(10)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1324,context,xBaseNear,getDownStockY(10),stockSize,stockSize));
            	  
            	   
            	     carrierList.push(new CarrierChain(1374,context,xH,getUpStockY(11),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1375,context,xH,getDownStockY(11),hWidth))
            	  	    
            	  	
            	  	    yzjList.push(new Yzj(1323,context,xBaseNear,getUpStockY(11),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(1322,context,xBaseNear,getVY(11)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(1321,context,xBaseNear,getDownStockY(11),stockSize,stockSize));
            	  
            	  
            	  
            	  
            	  
            	  var width=getCraneY(4)-getCraneY(3)-craneGap;
			    	  	var yV=(getCraneY(4)+getCraneY(3))/2
			    	 
			    	    carrierList.push(new CarrierChain(1351,context,xBaseNear,yV-width/4,width/2,90))//垂直
			    	    carrierList.push(new CarrierChain(1350,context,xBaseNear,yV+width/4,width/2,90))//垂直
			    	    var width=getCraneY(8)-getCraneY(7)-craneGap;
				    	  var yV=(getCraneY(8)+getCraneY(7))/2
				    	   carrierList.push(new CarrierChain(1335,context,xBaseNear,yV-width/4,width/2,90))//垂直
			    	     carrierList.push(new CarrierChain(1334,context,xBaseNear,yV+width/4,width/2,90))//垂直
			    	     
      	     	  carrierList.push(new CarrierChain(1212,context,xBase,getUpStockY(1)-craneGap*1.2,craneGap*0.8,90))//垂直
      	        carrierList.push(new CarrierChain(1213,context,xBase,getUpStockY(1)-craneGap*0.45,craneGap*0.7,90))//垂直
      	  		
      	        carrierList.push(new CarrierChain(1300,context,xBase,getDownStockY(1)-craneGap*0.4,craneGap*0.8,90))//垂直
      	  	    carrierList.push(new CarrierChain(1301,context,xBase,getVY(1)+craneGap+stockSize,craneGap-stockSize*2,90))//垂直
            	  carrierList.push(new CarrierChain(1302,context,xBase,getVY(2)+craneGap-stockSize/2,craneGap-stockSize,90))//垂直
      	    	  carrierList.push(new CarrierChain(1303,context,xBase,getVY(3)+craneGap-stockSize,craneGap,90))//垂直
            	 
      	    	  yzjList.push(new Yzj(1304,context,xBase,getDownStockY(3),stockSize,stockSize));
      	    	  var width=getCraneY(4)-getCraneY(3)-craneGap;
			    	  	var yV=(getCraneY(4)+getCraneY(3))/2
			    	  	carrierList.push(new CarrierChain(1305,context,xBase,yV-width/4,width/2,90))//垂直
			    	  	carrierList.push(new CarrierChain(1306,context,xBase,yV+width/4,width/2,90))//垂直
			    	  	
      	    	  carrierList.push(new CarrierChain(1307,context,xBase,getVY(4)+craneGap-stockSize,craneGap,90))//垂直
      	    	  carrierList.push(new CarrierChain(1308,context,xBase,getVY(5)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1309,context,xBase,getDownStockY(5),stockSize,stockSize));
         
            	  carrierList.push(new CarrierChain(1310,context,xBase,getVY(6)+craneGap-stockSize,craneGap,90))//垂直
            	  	  
            	  carrierList.push(new CarrierChain(1311,context,xBase,getVY(7)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1312,context,xBase,getDownStockY(7),stockSize,stockSize));
            	  var width=getCraneY(8)-getCraneY(7)-craneGap;
				    	  var yV=(getCraneY(8)+getCraneY(7))/2
				    	  carrierList.push(new CarrierChain(1313,context,xBase,yV-width/4,width/2,90))//垂直
            	  
            
            	  carrierList.push(new CarrierChain(1314,context,xBase,getVY(8)+craneGap-stockSize*1.6,craneGap+stockSize*1.1,90))//垂直
            	  carrierList.push(new CarrierChain(1315,context,xBase,getVY(9)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1316,context,xBase,getDownStockY(9),stockSize,stockSize));
            	  carrierList.push(new CarrierChain(1317,context,xBase,getVY(10)+craneGap-stockSize,craneGap,90))//垂直
            	  carrierList.push(new CarrierChain(1318,context,xBase,getVY(11)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1319,context,xBase,getDownStockY(11),stockSize,stockSize));
    	
	}
	
	function leftCarrier(context){
		    	    	var xBase=carrierOffsetX;
		    	    	var xH=xBase+carrierlength/2+parseInt((stockSize+1)/2)+1.25*stockSize/2
            	  var yBase =getCraneY(1)-stockSize*1.25;
            	  
            	  var hWidth =carrierlength-1.25*stockSize
            	  var y1=getUpStockY(1)-craneGap*2.1;
            	  carrierList.push(new CarrierChain(1010,context,xBase,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1006,context,xBase+craneGap*1.1+45,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1003,context,xBase+craneGap*1.1*2+45,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1000,context,xBase+craneGap*1.1*3+45,y1,craneGap*0.4,90))//垂直
            	  carrierList.push(new CarrierChain(1083,context,xBase+craneGap*1.1*4+45,y1+11,craneGap*0.8,90))//垂直
            	  carrierList.push(new CarrierChain(1084,context,xBase+craneGap*1.1*5+45,y1+11,craneGap*0.8,90))//垂直
           
            	  
            	  var inHY=getUpStockY(1)-craneGap*1.6-stockSize/2;
            	  yzjList.push(new Yzj(1011,context,xBase,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1007,context,xBase+craneGap*1.1+45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1004,context,xBase+craneGap*1.1*2+45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1001,context,xBase+craneGap*1.1*3+45,inHY,stockSize,stockSize));
            	  
            	  carrierList.push(new CarrierChain(1009,context,xBase+craneGap*0.4,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1008,context,xBase+craneGap*1.5,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1005,context,xBase+craneGap*2.6,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1002,context,xBase+craneGap*3.7,inHY,craneGap*1.1))//水平
            	  
            	  inHY=inHY+1.25*stockSize
            	  carrierList.push(new CarrierChain(1075,context,xBase+craneGap*0.4+stockSize*1.25,inHY,craneGap*1.1))//水平
            	 
            	  carrierList.push(new CarrierChain(1076,context,xBase+craneGap*2.4,inHY,craneGap*2.15))//水平
            	  carrierList.push(new CarrierChain(1077,context,xBase+craneGap*3.7+stockSize*1.25/2,inHY,craneGap*1.1-stockSize*1.25))//水平
            	  yzjList.push(new Yzj(1078,context,xBase+craneGap*1.1*3+45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1080,context,xBase+craneGap*1.1*4+45,inHY,stockSize,stockSize));
            	  yzjList.push(new Yzj(1082,context,xBase+craneGap*1.1*5+45,inHY,stockSize,stockSize));
            	  
            	  carrierList.push(new CarrierChain(1079,context,xBase+craneGap*4.5+stockSize,inHY,craneGap*1.1))//水平
            	  carrierList.push(new CarrierChain(1081,context,xBase+craneGap*5.9,inHY,craneGap*1.1))//水平
            	  
            	  
         
            	  carrierList.push(new CarrierChain(1072,context,xBase+1.25*stockSize,getUpStockY(1)-craneGap*0.5,craneGap*0.7,90))//垂直
            	  carrierList.push(new CarrierChain(1073,context,xBase+1.25*stockSize,getUpStockY(1)-craneGap*1.05,stockSize,90))//垂直
            	  
            	  var xBaseNear=xBase+1.25*stockSize;
            	  
            	  for(var i=1;i<12;i++){
            	  	    carrierList.push(new CarrierChain(1087+i*2,context,xH,getUpStockY(i),hWidth))//与货位接壤
            	  	    carrierList.push(new CarrierChain(1088+i*2,context,xH,getDownStockY(i),hWidth))
            	  	    
            	  	    var upYzId=1073-i*3-getRoom(i)*2+1;
            	  	    yzjList.push(new Yzj(upYzId,context,xBaseNear,getUpStockY(i),stockSize,stockSize));
            	  	    carrierList.push(new CarrierChain(upYzId-1,context,xBaseNear,getVY(i)+craneGap-stockSize,craneGap,90))//垂直  靠近垛机
			            	  yzjList.push(new Yzj(upYzId-2,context,xBaseNear,getDownStockY(i),stockSize,stockSize));
            	  }
            	  	var width=getCraneY(4)-getCraneY(3)-craneGap;
				    	  	var yV=(getCraneY(4)+getCraneY(3))/2
				    	 
				    	     carrierList.push(new CarrierChain(1062,context,xBaseNear,yV-width/4,width/2,90))//垂直
				    	     carrierList.push(new CarrierChain(1061,context,xBaseNear,yV+width/4,width/2,90))//垂直
				    	      	var width=getCraneY(8)-getCraneY(7)-craneGap;
					    	  	var yV=(getCraneY(8)+getCraneY(7))/2
					    	   carrierList.push(new CarrierChain(1048,context,xBaseNear,yV-width/4,width/2,90))//垂直
				    	     carrierList.push(new CarrierChain(1047,context,xBaseNear,yV+width/4,width/2,90))//垂直
            	  
      	     	  carrierList.push(new CarrierChain(1012,context,xBase,getUpStockY(1)-craneGap*1.2,craneGap*0.8,90))//垂直
      	        carrierList.push(new CarrierChain(1013,context,xBase,getUpStockY(1)-craneGap*0.45,craneGap*0.7,90))//垂直
      	  		
      	        carrierList.push(new CarrierChain(1014,context,xBase,getDownStockY(1)-craneGap*0.4,craneGap*0.8,90))//垂直
      	  	    carrierList.push(new CarrierChain(1015,context,xBase,getVY(1)+craneGap+stockSize,craneGap-stockSize*2,90))//垂直
            	  carrierList.push(new CarrierChain(1016,context,xBase,getVY(2)+craneGap-stockSize/2,craneGap-stockSize,90))//垂直
      	    	  carrierList.push(new CarrierChain(1017,context,xBase,getVY(3)+craneGap-stockSize,craneGap,90))//垂直
            	 
      	    	  yzjList.push(new Yzj(1018,context,xBase,getDownStockY(3),stockSize,stockSize));
      	    	  var width=getCraneY(4)-getCraneY(3)-craneGap;
			    	  	var yV=(getCraneY(4)+getCraneY(3))/2
			    	  	carrierList.push(new CarrierChain(1019,context,xBase,yV-width/4,width/2,90))//垂直
			    	  	carrierList.push(new CarrierChain(1020,context,xBase,yV+width/4,width/2,90))//垂直
			    	  	
      	    	  carrierList.push(new CarrierChain(1021,context,xBase,getVY(4)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1022,context,xBase,getDownStockY(5),stockSize,stockSize));
            	  carrierList.push(new CarrierChain(1023,context,xBase,getVY(5)+craneGap-stockSize,craneGap,90))//垂直
            	  carrierList.push(new CarrierChain(1024,context,xBase,getVY(6)+craneGap-stockSize,craneGap,90))//垂直
            	  	  
            	  carrierList.push(new CarrierChain(1025,context,xBase,getVY(7)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1026,context,xBase,getDownStockY(7),stockSize,stockSize));
            	  var width=getCraneY(8)-getCraneY(7)-craneGap;
				    	  var yV=(getCraneY(8)+getCraneY(7))/2
				    	  carrierList.push(new CarrierChain(1027,context,xBase,yV-width/4,width/2,90))//垂直
            	  
            
            	  carrierList.push(new CarrierChain(1028,context,xBase,getVY(8)+craneGap-stockSize*1.6,craneGap+stockSize*1.1,90))//垂直
            	  
            	  carrierList.push(new CarrierChain(1029,context,xBase,getVY(9)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1030,context,xBase,getDownStockY(9),stockSize,stockSize));
            	  carrierList.push(new CarrierChain(1031,context,xBase,getVY(10)+craneGap-stockSize,craneGap,90))//垂直
            	  carrierList.push(new CarrierChain(1032,context,xBase,getVY(11)+craneGap-stockSize,craneGap,90))//垂直
            	  yzjList.push(new Yzj(1033,context,xBase,getDownStockY(11),stockSize,stockSize));
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
	
function getRoom(CraneId){
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

		    
function getLYid(CraneId){
	return 1009+pathOffset(CraneId)+CraneId
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
		    	