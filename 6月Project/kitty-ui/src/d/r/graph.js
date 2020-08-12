

function VerticeGraph() {
    var vertices = {};
    var adjList = {};
    //添加顶点的方法。
    function addVertices(v) {
    	if(vertices[v]==undefined){
    			vertices[v]={deep:0,befort:""};
    	}
    
    };
    
     this.addVector = function (v,w) {
	    	addVertices(v);
	    	addVertices(w);
	    	if(adjList[v]== undefined){
	    		adjList[v]=[];
	    	}
	    	adjList[v].push(w)
    };
    this.addEdge = function (v,w) {
	    	this.addVector(v,w);
	    	this.addVector(w,v);
    };
 
  
		this.baseDistance=function(from ,to){
			initPath();
			vertices[from].deep=0
			scan(from ,1);
			var res=[]
			if(vertices[to].deep==-1){
				return res;
			}
				res.push[to]
			while(vertices[to].befort!=from){
				res.push[vertices[to].befort];
				to=vertices[to].befort
			}
			res.push[from]
			return res;
			
		}
		
	 function initPath(){
	 	  for(var k in vertices){
	 			vertices[j].deep=-1
	 			vertices[j].befort="";
	 		}
   }
		function scan(from ,deep){
			var arr = adjList[from];//所有边
			for(var i=0;i<arr.length;i++){//关联点
				  var v=vertices[arr[i]]
					if(v.deep==-1||v.deep>deep){
						vertices[j].deep=deep
						vertices[j].befort=arr[i];
						scan(arr[i],deep++)
					}
				
			}
		
		}
}
