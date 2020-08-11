extend =  function(sb, sp){
      sb.prototype=new sp();
			sb.prototype.constructor=sb;
			return sb;
 };
  Graph =extend(function Graph(){
 
			this.init= function (cfg){
				this.className=this.constructor.name;
				this.config={};
				this.copy(cfg,this.config)
				
			}
 
			 this.copy=function(from,to){
						 if(from){
						 				for(var i in from){
									 			to[i]=from[i];
									 }
						 }
						 
			 }
 
 
 			this.getAnchor= function (){
 				return {x:this.x,y:this.y}
 			}
 			
 			this.setAnchor=function (point){
	 			this.move(point.x-this.x,point.y-	this.y)
	 			this.x=point.x;
	 			this.y=point.y;
 			}
 
 },Object); 
 
 SimpleGraph = extend(function SimpleGraph(cfg){
  		this.init=function (){
  			SimpleGraph.prototype.init.apply(this,arguments)
		 }
		 
		 this.init(cfg);
 			this.toRight=function(x){
 				this.x1+=x;
 				this.x2+=x;
 				this.x+=x;
 			}
 			this.toLeft=function(x){
 				this.x1-=x;
 				this.x2-=x;
 				this.x-=x;
 			}
 			this.toUp=function(y){
 				this.y1-=y;
 				this.y2-=y;
 					this.y-=y;
 			}
 			this.toDown=function(y){
 				this.y1+=y;
 				this.y2+=y;
 				this.y+=y;
 			}
 			this.move=function(x,y){
 				this.x+=x;
 				this.y+=y;
 			  this.x1+=x;
 				this.x2+=x;
 			  this.y1+=y;
 				this.y2+=y;
 			}
 			this.moveTo=function(x,y){
 				var defx=this.x1-this.x
 				var defy=this.y1-this.y
 			  this.x1=x+defx;
 				this.x2=x+defx;
 			  this.y1=y+defy;
 				this.y2=y+defy;
 				this.x=x;
 				this.y=y;
 			}
 			
 },Graph);
 
 ComplexGraph = extend(function ComplexGraph(cfg){
 		this.init=function (){
  		ComplexGraph.prototype.init.apply(this,arguments)
 			this.graphs=[];
 		}
 		this.init(cfg);
		this.toRight=function(x){
		 for(var index in this.graphs){
		 		this.graphs[index].toRight(x);
		 }
		}
		this.toLeft=function(x){
		for(var graph in this.graphs){
		 		this.graphs[index].toLeft(x);
		 }
		}
		this.toUp=function(y){
			for(var index in this.graphs){
		 		this.graphs[index].toUp(y);
		  }
		}
		this.toDown=function(y){
			for(var index in this.graphs){
		 		this.graphs[index].toDown(y);
		  }
		}
		this.move=function(x,y){
					this.x+=x;
					this.y+=y;
				  for(var index in this.graphs){
				 		this.graphs[index].move(x,y);
				  }
		}
		this.moveTo=function(x,y){
					this.x=x;
					this.y=y;
				  for(var index in this.graphs){
				 		this.graphs[index].moveTo(x,y);
				  }
		}
		this.draw=function(){
		  for(var index in this.graphs){
		  	this.graphs[index].draw();
		  }
		}
 } ,Graph);
 
 //context,x1,y1,x2,y2,width
Line =  extend(function Line(cfg){
 	this.init=function (){
 			
  		Line.prototype.init.apply(this,arguments)
 		this.lineWidth=cfg.width|1;
		this.x1=cfg.x1;
		this.y1=cfg.y1;
		this.x2=cfg.x2;
		this.y2=cfg.y2;
 			
		this.x=(cfg.x1+cfg.x2)/2;
	  this.y=(cfg.y1+cfg.y2)/2;
		this.cxt=cfg.context;
 
 	}
 
 	this.init(cfg);
 			
	this.draw=function(){
		
		if(!this.cxt){
			this.cxt.beginPath();
		}
	  this.cxt.beginPath();
  	this.cxt.lineWidth =this.lineWidth;
	  this.cxt.moveTo(this.x1,this.y1);
		this.cxt.lineTo(this.x2,this.y2);
		this.cxt.stroke();
	}
   },SimpleGraph)
   
   
   
   
Word =  extend(function Word(cfg){
 		this.init=function (){
  			Line.prototype.init.apply(this,arguments)
 				this.lineWidth=cfg.width|1;
				this.x=cfg.x;
				this.y=cfg.y;
				this.cxt=cfg.context;
				this.word=cfg.word;
	 			this.fillStyle=cfg.fillStyle
	 			this.font=cfg.font;
	 	}
	 	this.init(cfg);
	 	
		this.draw=function(){
			this.cxt.beginPath();
			if(this.fillStyle){
				   this.cxt.fillStyle=this.fillStyle;
			}
			var beforeFont=this.cxt.font
			if(this.font){
				   this.cxt.font=this.font;
			}
	    	this.cxt.fillText(this.word, this.x, this.y);
	    	this.cxt.font=beforeFont;
		}
},SimpleGraph)
   
BrokenLine =extend(function BrokenLine(cfg){
   this.init=function (){
 			
  	BrokenLine.prototype.init.apply(this,arguments)
 		this.lineWidth=cfg.width|1;
		this.points=cfg.points;	
		this.x=cfg.x;
	  this.y=cfg.y;
		this.cxt=cfg.context;
 
 	}
 
 	this.init(cfg);
 			
		this.draw=function(){
			   var len = this.points.length;
			    this.cxt.beginPath();
			   for(var i=0 ;i<len; i++){
	          var p = this.points[i];
	         
	          if(i === 0){
	             this.cxt .moveTo(p.x, p.y);
	          } else{
	             this.cxt .lineTo(p.x, p.y);
	          }
	        }
	      this.cxt.strokeStyle = this.strokeStyle||"black";
	        this.cxt.stroke();
		}
   
   	this.move=function(x,y){
 				this.x+=x;
 				this.y+=y;
 				
 				for(var i=0 ;i<len; i++){
          var p = this.points[i];
          p.x+=x;
          p.y+=y;
        }
 			}
   
   },SimpleGraph)
   
 Rectangle= extend( function Rectangle(context,x1,y1,x2,y2,width,strokeStyle,fillStyle){
   
   
	this.init=function (){
  		Rectangle.prototype.init.apply(this,arguments)
 			this.fillStyle= fillStyle
 			this.strokeStyle=strokeStyle;
   		this.lineWidth=width|1;
 			this.cxt=context;
  	  this.x1=x1;
  		this.y1=y1;
  	  this.x2=x2;
  	  this.y2=y2;
		  this.x=(x1+x2)/2;
 		  this.y=(y1+y2)/2;
 		}
    this.init();
   		
 
	 this.draw=function(){
	 
			this.cxt.fillStyle=this.fillStyle
			this.cxt.strokeStyle=this.strokeStyle
		  this.cxt.beginPath();
			this.cxt.lineWidth =this.lineWidth;
	
			this.cxt.moveTo(this.x1,this.y1)
			this.cxt.lineTo(this.x2,this.y1)
			this.cxt.lineTo(this.x2,this.y2)
			this.cxt.lineTo(this.x1,this.y2)
			this.cxt.lineTo(this.x1,this.y1)
			this.cxt.stroke();
			this.cxt.closePath();
			if(this.fillStyle)
		  context.fill();

	 }
	 
},SimpleGraph)


  Rect= extend( function Rect(cfg){
   
   
	this.init=function (){
  		Rect.prototype.init.apply(this,arguments)
 			  this.fillStyle= cfg.fillStyle 
   			this.lineWidth=cfg.width|1;
 			  this.cxt=cfg.context;
  			this.x=cfg.x;
  			this.y=cfg.y;
  	    this.width=cfg.width;
  			this.height=cfg.height;
		 
 		}
    this.init(cfg);
   		
 
	 this.draw=function(){
				if(this.fillStyle){
				 		this.cxt.fillStyle=this.fillStyle;
				}
        this.cxt.fillRect(this.x,this.y,this.width,this.height);
        this.cxt.fill();
	 }
	 
},SimpleGraph)





DrawCircle=  extend( function DrawCircle (cfg){
     
			 this.init=function (){
			     	  DrawCircle.prototype.init.apply(this,arguments);
			     	  this.ctx=cfg.context;
						  this.x=cfg.x;
						  this.y=cfg.y;
						  this.r=cfg.r;
						  this.color = cfg.color;
						  this.data = cfg.data;
						  
						  this.name = cfg.name;

			  }
			  this.init(cfg);
			 	this.draw=function(){
						
						 var startPoint = 1.5 * Math.PI;
						 var x=this.x;
						 var y=this.y;
						 var r=this.r;
						  var oldFillStyle= this.ctx.fillStyle;
						  var oldStrokeStyle= this.ctx.strokeStyle;
						  for(var i=0;i<this.data.length;i++){
							  var end = startPoint-Math.PI*2*(this.data[i]/100);
							  this.ctx.fillStyle = this.color[i];
							  this.ctx.strokeStyle = this.color[i];
							  this.ctx.beginPath();
							  this.ctx.moveTo(x,y);
							  this.ctx.arc(x,y,r,startPoint,end,true);
							  this.ctx.fill();
							  this.ctx.stroke();
							  this.ctx.closePath();
							  var middle=(startPoint+end)/2
							  var dx=Math.sin(0.5*Math.PI-middle)*r;
							  var dy=Math.cos(0.5*Math.PI-middle)*r;
							  this. ctx.fillText(parseInt(this.data[i]), x+dx*1.3,y+dy*1.3);
							  
							  this.ctx.moveTo(x+dx*1.3,y+dy*1.3);
							  this.ctx.lineTo(x+dx,y+dy);
							  this.ctx.stroke();
							  
							  startPoint -= Math.PI*2*(this.data[i]/100);
						  }
						 
						  this.ctx.fillStyle=oldFillStyle;
						  this.ctx.strokeStyle=oldStrokeStyle;
						
						
				 }  
			 	  
			 	 this.reflashData=function(data){
			 	 			this.data=data
			 	 
			 	 } 
} ,SimpleGraph);
  
  
  
  
  
  
  Table= extend( function Table(cfg){
			this.init=function (){
		  		Table.prototype.init.apply(this,arguments)
		 			 	this.cxt=cfg.context;
					  this.x1=cfg.x1;
					  this.y1=cfg.y1;
					  this.x2=cfg.x2;
					  this.y2=cfg.y2;
					  this.data=cfg.data;
						
				 
		 }
     this.init(cfg);
		 this.draw=function(){ 
		 				var data=this.data;
						var column=data[0].length;
						var row=data.length;
					  var w=(cfg.x2-cfg.x1)/column;
					  var h=(cfg.y2-cfg.y1)/row;
				 this.cxt.strokeStyle='black';
		        for(r=1;r<=row;r++){      //控制画多少行 
			          for(c=1;c<=column;c++) {    //控制画多少列
			              var x=this.x1+(c-1)*w;
			              var y=this.y1+(r-1)*h;

			              x_zuobiao=x+10;
			              y_zuobiao=y+10;
			             
			              this.cxt.rect(x,y,w,h);
			              
			              this.cxt.fillText(data[r-1][c-1],x_zuobiao,y_zuobiao);
		              }
		          }
		      this.cxt.stroke();
		 }
},SimpleGraph)



  Point= extend( function Point(cfg){
	  this.init=function (){
  		  Point.prototype.init.apply(this,arguments)
 			  this.fillStyle= cfg.fillStyle 
 			  this.cxt=cfg.context;
  			this.x=cfg.x;
  			this.y=cfg.y;
 		}
   this.init(cfg);
	 this.draw=function(){
	 			var context = this.cxt;
				context.fillStyle = this.fillStyle;
        context.beginPath();
        context.arc(this.x,this.y,3,0,Math.PI*2);
        context.fill();
	  }
	 
},SimpleGraph)




  
