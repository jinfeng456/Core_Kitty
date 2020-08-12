
  Store= extend( function Store(context,x,y,width,height,forword){
    
     	this.init=function (){
     			
		  	Store.prototype.init.apply(this,arguments)
			this.lineWidth=1;
		  this.cxt=context;
		  this.x1=x-width/2;
			this.y1=y-height/2;
		  this.x2=x+width/2;
			this.y2=y+height/2;
			this.x=x;
			this.y=y;
  			
  			this.rectangle1=new Rectangle(context,this.x1,this.y1+2,this.x2,this.y2-2);
     		this.rectangle2= new Rectangle(context,this.x1+3,this.y1,this.x2-3,this.y2);
     		this.line1= new Line({
     			context:context,
     			x1:this.x1+3,
     			y1:this.y1+2,
     			x2:this.x2-3,
     			y2:this.y2-2
     		});
     		this.line2= new Line({
     			context:context,
     			x1:this.x2-3,
     			y1:this.y1+2,
     			x2:this.x1+3,
     			y2:this.y2-2
     			
     		});
     		this.graphs.push(this.rectangle1);
     		this.graphs.push(this.rectangle2);
     		this.graphs.push(this.line1);
     		this.graphs.push(this.line2);
     	}
        this.init();
    
    },ComplexGraph)
    
  CarrierChain =   extend(function CarrierChain(context,x,y,width,height,forword){
      	this.init=function (){
      			
  				CarrierChain.prototype.init.apply(this,arguments)
				this.cxt=context;
				this.rotateAngle=forword|0;
				this.gap=3;
				this.x=x;
				this.y=y;
				this.x1= x-width/2;
				this.x2= x+width/2;
				this.y1=y-height/2;
				this.y2=y+height/2;
				for( var xtmp=this.x1;xtmp<this.x2;xtmp+=this.gap){
			  		this.graphs.push(new Line({
			  	     			context:context,
			  	     			x1:xtmp,
			  	     			y1:this.y1,
			  	     			x2:xtmp,
			  	     			y2:this.y2
			  	     			
			  	     		}));
				}
				this.graphs.push(new Line({
  	     			context:context,
  	     			x1:this.x1,
  	     			y1:this.y1,
  	     			x2:this.x2,
  	     			y2:this.y1
  	     			
  	     		}));
				this.graphs.push(new Line({
  	     			context:context,
  	     			x1:this.x1,
  	     			y1:this.y2,
  	     			x2:this.x2,
  	     			y2:this.y2
  	     			
  	     		}));
   			}
   			 this.draw=function(){
						context.save(); 
			   		if(this.rotateAngle){
			      		context.translate(x, y);   
			      		context.rotate(forword * Math.PI / 180);//旋转47�??   
			      		context.translate(-x, -y);   
				    }
			  		CarrierChain.prototype.draw.apply(this,arguments)
					  
		      	context.restore(); 
  			 }
   
   	 this.init();
   } ,ComplexGraph);
    
   Yzj=  extend( function Yzj(context,x,y,width,height){
           this.init=	function (){
           		
  				Yzj.prototype.init.apply(this,arguments)
     
     	  		this.x=x;
				this.y=y;
        		this. x1= x-width/2;
		  		this. x2= x+width/2;
		  		this. y1=y-height/2;
		  		this. y2=y+height/2;
		  		this.cxt=context;
		  		this.graphs.push(new Line(
		  				{
		  	     			context:this.cxt,
		  	     			x1:this.x1,
		  	     			y1:this.y1,
		  	     			x2:this.x2,
		  	     			y2:this.y1,
		  	     			width:2
		  	     			
		  	     		}));
       		    this.graphs.push(new Line({
		  	     			context:this.cxt,
		  	     			x1:this.x1,
		  	     			y1:this.y2,
		  	     			x2:this.x2,
		  	     			y2:this.y2,
		  	     			width:2
		  	     			
		  	     		}));
        		this.graphs.push(new Line(
        				{
        					context:this.cxt,
		  	     			x1:this.x1+2,
		  	     			y1:this.y1,
		  	     			x2:this.x1+2,
		  	     			y2:this.y2,
		  	     			width:2
		  	     			
		  	     		}));
        		this.graphs.push(new Line({
  	     			context:this.cxt,
  	     			x1:this.x1+6,
  	     			y1:this.y1,
  	     			x2:this.x1+6,
  	     			y2:this.y2
  	     			
  	     		}));
       		    this.graphs.push(new  Line({
  	     			context:this.cxt,
  	     			x1:this.x2-2,
  	     			y1:this.y1,
  	     			x2:this.x2-2,
  	     			y2:this.y2
  	     			
  	     		}));
        		this.graphs.push(new  Line({
  	     			context:this.cxt,
  	     			x1:this.x2-6,
  	     			y1:this.y1,
  	     			x2:this.x2-6,
  	     			y2:this.y2
  	     			
  	     		}));
        		this.graphs.push(new  Line({
          	     			context:this.cxt,
          	     			x1:(this.x1+this.x2)/2,
          	     			y1:this.y1,
          	     			x2:(this.x1+this.x2)/2,
          	     			y2:this.y2,
          	     			width:4
          	     			
          	     		}));
        }
        
         this.init();
      },ComplexGraph);
   Crane=  extend(  function Crane(context,x,y,width){
					  this.init=function (){
					  		
					      	Crane.prototype.init.apply(this,arguments)
				      		this.len = width*3;
				      		this.x1=x-this.len/2;
				      		this.y1=y-width/2;
				      		this.x2=x+this.len/2;
				      		this.y2=y+width/2;
					        this.x=x;
				   			this.y=y;
				      
			      		 this.graphs.push(new Rectangle(context,this.x-width/2+3,this.y-width/2+3,this.x+width/2-3,this.y+width/2-3,2))
			      		 this.graphs.push(new Line({
	          	     			context:context,
	          	     			x1:this.x1,
	          	     			y1:this.y,
	          	     			x2:this.x2,
	          	     			y2:this.y,
	          	     			width:2
	          	     		})); 
			      		 this.graphs.push(new Line({
	          	     			context:context,
	          	     			x1:this.x1,
	          	     			y1:this.y-width/20,
	          	     			x2:this.x2,
	          	     			y2:this.y-width/20,
	          	     			width:2
	          	     		})); 
			      		 this.graphs.push(new Line({
	          	     			context:context,
	          	     			x1:this.x1,
	          	     			y1:this.y+width/20,
	          	     			x2:this.x2,
	          	     			y2:this.y+width/20,
	          	     			width:2
	          	     		})); 
			      
			      		 this.graphs.push(new Rectangle(context,this.x1,y-width/4*1.5,this.x1+width/2,this.y+width/4*1.5,1,"#000000"))
			      		 this.graphs.push(new Rectangle(context,this.x2-width/4,this.y-width/4*1.2,this.x2,this.y+width/4*1.2,1,"#000000"));
					    }
					     this.init();
      },ComplexGraph);
          
          
    Product= extend( function (context,x,y){
     this.init=function (){
        		
			  Product.prototype.init.apply(this,arguments)
		      this.width=12;
		      this.len=16;
		      this.x1=x-this.width/2;
		      this.y1=y-this.len/2;
		      this.x2=x+this.width/2;
		      this.y2=y+this.len/2;
		      this.x=x;
   			  this.y=y;
		      this.graphs.push(new   Rectangle(context,this.x1,this.y1,this.x2,this.y2,1,"#ff00ff"));
     		 }
       this.init();
      },ComplexGraph);
      
      
           
  StoreRoom=  extend( function (context,x,y){
     
			     this.init=function (){
			     		
			     	StoreRoom.prototype.init.apply(this,arguments)
	     			this.x=x;
	   			  this.y=y;
				    this.x1=x;
				    this.y1=y;
				    var storeWidth=16;
			          for(var i=0;i<52;i++){
			            this.graphs.push(new Store(context,this.x1+i*(storeWidth+1),this.y1,storeWidth,18));
			          	this.graphs.push(new Store(context,this.x1+i*(storeWidth+1),this.y1+40,storeWidth,18));
			          	this.graphs.push(new Store(context,this.x1+i*(storeWidth+1),this.y1+60,storeWidth,18));
			          	this.graphs.push(new Store(context,this.x1+i*(storeWidth+1),this.y1+100,storeWidth,18));
			          }
			     
			     }
			     this.init();
     	    
      } ,ComplexGraph);
  
  
  
  
  
  

  
  
  
BarGraph=  extend( function BarGraph (cfg){
     
			 this.init=function (){
			     		
			     	BarGraph.prototype.init.apply(this,arguments)
			     	this.xName=cfg.xName;
			     	this.yName=cfg.yName;
			     	this.title=cfg.title;
	          var  context=cfg.context;
	          this.cxt=context;
	          this.realheight = cfg.y2-cfg.y1;
	          this.realwidth=cfg.x2-cfg.x1;
	   
            var data = cfg.data;
         


            var grid_cols = data.length + 1;
            var grid_rows = 4;
            this. cell_height = this.realheight / grid_rows;
            this. cell_width = this.realwidth / grid_cols;
          
          
          
					 	this.graphs.push(new Word({//标题
							 	x:(cfg.x2+cfg.x1)/2-40,
							 	y:cfg.y1+20,
					 			context:cfg.context,
					 			word:this.title,
					 			font:'30px sans-serif',
					 			strokeStyle : "black"
					 	}));
         
					 	this.graphs.push(new BrokenLine({//边框线
							 	x:this.x,
							 	y:this.y,
					 			context:cfg.context,
					 			points:[{x:cfg.x1,y:cfg.y1},{x:cfg.x1,y:cfg.y2},{x:cfg.x2,y:cfg.y2}],
					 			strokeStyle : "black"
					 	}));
     
		      	this.graphs.push(new Word({//
									 	x:cfg.x1,
									 	y:cfg.y1,
							 			context:cfg.context,
							 			word:this.yName,
							 			strokeStyle : "black"
					  }));
						this.graphs.push(new Word({
									 	x:cfg.x2,
									 	y:cfg.y2+12,
							 			context:cfg.context,
							 			word:this.xName,
							 			strokeStyle : "black"
						}));
				      
				      this.reflashData(data);
				      
				      
			     }
			    
			     
			     
			     this.reflashData=function(data){
					     this.data=data;
					     var max_v = getMax(data);
				   
				      // 将数据换算为坐标
				      var points = [];
				      for( var i=0; i < data.length; i++){
				        var v= data[i].value;
				        var px = this.cell_width *(i +1);
				        var py = this.realheight - this.realheight*(v / max_v);
				        
				        points.push({"x":px,"y":py});
				      }
				      
				      var newPraphs=[];
				      for(var i in this.graphs){
					      	var g=this.graphs[i];
						      if(g.config.method!='reflashData'){
						      	newPraphs.push(g);
						      }
				      
				      }

				      //绘制坐标图形
				      for(var i in points){
				          var p = points[i];
				      		newPraphs.push(new Rect({
				      							method:'reflashData',
													 	x:p.x+cfg.x1,
													 	y:p.y+cfg.y1,
											 			context:this.cxt,
											 			width:15,
											 			height : this.realheight-p.y,
											 			fillStyle:"green"
									}));
				        	newPraphs.push(new Word({
				        						method:'reflashData',
													 	x: p.x+cfg.x1,
													 	y: p.y - 15+cfg.y1,
											 			context:this.cxt,
											 			word:data[i].value,
											 			strokeStyle : "black"
										}));
										
										newPraphs.push(new Word({//水平名称
														method:'reflashData',
													 	x: p.x+cfg.x1,
													 	y:this.realheight+12+cfg.y1,
											 			context:this.cxt,
											 			word:data[i].lab,
											 			strokeStyle : "black"
										}));
				      }
			     
			     		this.graphs= newPraphs;
			     }
			     
			 	  function  getMax(data){
						   var max_v =0;
					      for(var i = 0; i<data.length; i++){
					        if (data[i].value > max_v) { max_v =data[i].value};
					      }
					      max_v = max_v * 1.1;
					      return max_v;
					}
					 this.init(cfg);
} ,ComplexGraph);
  
  
  
  






 
  
  
  
  
        
           
  LineChart=  extend( function LineChart (cfg){
     
			     this.init=function (){
			     			this.x1=cfg.x1;
					    	this.y1=cfg.y1;
					    	this.x2=cfg.x2;
					    	this.y2=cfg.y2;
					      this.cxt=cfg.context;
					      this.data=cfg.data;
					      this.title=cfg.title
					      this.left=10;  
      					this. buttom=10;
					      this.graphs.push(new Word({//标题
									 	x:(this.x1+this.x2)/2-100,
									 	y:this.y1+30,
							 			context:cfg.context,
							 			word:this.title,
							 			font:'30px sans-serif',
							 			strokeStyle : "black"
							 	}));
         
				        
				        	this.graphs.push(new BrokenLine({
										 	x: this.x1,
										 	y:this.y1,
								 			context:this.cxt,
								 			points:[{x:this.x1,y:this.y1},{x:this.x1,y:this.y2-this.buttom},{x:this.x2,y:this.y2-this.buttom}],
								 			strokeStyle : "black"
								}));
								
								
									this.graphs.push(new Word({
												 	x: this.x1,
												 	y:this.y1,
										 			context:this.cxt,
										 			word:'Yindex',
										 			strokeStyle : "black"
									}));
									
									this.graphs.push(new Word({
												 	x: this.x2,
												 	y:this.y2,
										 			context:this.cxt,
										 			word:'Xindex',
										 			strokeStyle : "black"
									}));
								
			     			this.reflashData(this.data)
			     }
			      this.reflashData=function(data){
			      			this.data=data;
			       			var points= getPoint(this.data,this.x1,this.y1,this.x2,this.y2)
					        var newPraphs=[];
						      for(var i in this.graphs){
							      	var g=this.graphs[i];
								      if(g.config.method!='reflashData'){
								      	newPraphs.push(g);
								      }
						      
						      }
					      
				      	newPraphs.push(new BrokenLine({
				      				method:'reflashData',
										 	x: this.x1,
										 	y:this.y1,
								 			context:this.cxt,
								 			points:points,
								 			strokeStyle : "black"
								}));
					      var len = this.data.length;
				        for(var i=0; i<len; i++){
				        			var p=points[i]
				        			newPraphs.push(new Word({
				        						method:'reflashData',
													 	x: p.x,
													 	y: p.y-10,
											 			context:this.cxt,
											 			word:this.data[i].y,
											 			strokeStyle : "black"
										  }));
				        	   newPraphs.push(new Word({
				        	   				 method:'reflashData',
													 	x: p.x,
													 	y: this.y2,
											 			context:this.cxt,
											 			word:this.data[i].x,
											 			strokeStyle : "black"
										  }));
										  newPraphs.push(new Point({
										      	method:'reflashData',
													 	x: p.x,
													 	y: p.y,
											 			context:this.cxt,
											 			strokeStyle : "black"
										  }));
				        
				        }
				        		this.graphs= newPraphs;
			      }
			    
			     function getPoint(dict,x1,y1,x2,y2){
								var points=[];
								
								var rang=getRange(dict)
								
								var k = (y2-y1-100)/(rang.max-rang.min);
								
							
								var len = dict.length;
				 				var s=(x2-x1)/(len);
				        var xArr = [];
				        for(var i=0; i<len; i++){
						        var d=dict[i];
						    		points.push({x:i * s+s/2+x1,y:y2-((d.y-rang.min)*k + 50)})
						        
				        }
						    return  points;
						}
						
			      function getRange(data){
			     			var tmp_minY= tmp_maxY=data[0].y
			     		  var len = data.length;
					      for(var i=1; i<len; i++){
							      var d=data[i];
							      if(d.y>tmp_maxY){
							      	tmp_maxY=d.y;
							      }
							      if(d.y<tmp_minY){
							       	tmp_minY=d.y;
							      }
					      }
						    return {max:tmp_maxY,min:tmp_minY} ;
			     }
			     
			     this.init(cfg);
      } ,ComplexGraph);
      
