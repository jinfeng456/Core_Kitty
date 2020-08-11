
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
  			
  			this.rectangle1=new Rectangle(context,this.x1,this.y1,this.x2,this.y2);
     		
     		this.graphs.push(this.rectangle1);
     		
     	}
        this.init();
    
    },ComplexGraph)
    
  CarrierChain =   extend(function CarrierChain(id,context,x,y,width,rotateAngle,speed){
      	this.init=function (){
      	var	height=18;
      	this.id=id;
  			CarrierChain.prototype.init.apply(this,arguments)
				this.cxt=context;
				this.width=width
				this.rotateAngle=rotateAngle|0;
				this.gap=20;
				this.speed=speed|0;
				this.x=x;
				this.y=y;
				this.x1= x-width/2;
				this.x2= x+width/2;
				this.y1=y-height/2;
				this.y2=y+height/2;
				var strokeStyle='#15659c'
				
				this.graphs.push(new   Rectangle(context,this.x1+1,this.y1+1,this.x2-1,this.y2-1,3,strokeStyle,'rgba(149,175,181,0.1)'));
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
			      		context.rotate(this.rotateAngle * Math.PI / 180);//旋转47�??   
			      		context.translate(-x, -y);   
				    }
				   
				    
			  		CarrierChain.prototype.draw.apply(this,arguments)
					  
		      	context.restore(); 
		      	
		      	var oldstrokeStyle =context.strokeStyle
				    var oldFont = context.font;
				    var oldfillStyle = context.fillStyle;
				    context.strokeStyle= 'rgba(0,0,0,0.1)'
    		    context.font="bold 12px 宋体";
    		    context.fillStyle='#0000ff'
    		    
      		  context.fillText(id,this.x-3,this.y+4);
    		    
    		    context.strokeStyle= oldstrokeStyle
    		    context.font=oldFont;
    		    context.fillStyle=oldfillStyle;
  			 }
   
   	 this.init();
   } ,ComplexGraph);
    
   Yzj=  extend( function Yzj(id,context,x,y,width,height){
          this.init=	function (){
          this.id=id
  				Yzj.prototype.init.apply(this,arguments)
          this.width=width|1
     	  	this.x=x;
				  this.y=y;
        	this. x1= x-width/2;
		  		this. x2= x+width/2;
		  		this. y1=y-height/2;
		  		this. y2=y+height/2;
		  		this.cxt=context;
		  		/*
		  		this.graphs.push(new Line(
		  				{
		  	     			context:this.cxt,
		  	     			x1:this.x1,
		  	     			y1:this.y1,
		  	     			x2:this.x2,
		  	     			y2:this.y1
		  	     			
		  	     		}));
   		     this.graphs.push(new Line({
  	     			context:this.cxt,
  	     			x1:this.x1,
  	     			y1:this.y2,
  	     			x2:this.x2,
  	     			y2:this.y2
  	     			
  	     		}));
        		this.graphs.push(new Line({
        					context:this.cxt,
		  	     			x1:this.x1+2,
		  	     			y1:this.y1,
		  	     			x2:this.x1+2,
		  	     			y2:this.y2}));*/
		  	     					var strokeStyle='#15659c'
		  	    this.graphs.push(new   Rectangle(context,this.x1,this.y1,this.x2,this.y2,1,strokeStyle,'rgba(149,175,181,0.5)'));
		  	     		
        	
        	
        }
        this.draw=function(){
						 Yzj.prototype.draw.apply(this,arguments)
		      	/*
		      	var oldstrokeStyle =context.strokeStyle
				    var oldFont = context.font;
				    var oldfillStyle = context.fillStyle;
				    context.strokeStyle= 'rgba(0,0,0,0.1)'
    		    context.font="bold 12px 宋体";
    		    context.fillStyle='#0000ff'
    		    
      		  context.fillText(id,this.x-3,this.y+4);
    		    
    		    context.strokeStyle= oldstrokeStyle
    		    context.font=oldFont;
    		    context.fillStyle=oldfillStyle;*/
  			 }
         this.init();
      },ComplexGraph);
   Crane=  extend(  function Crane(context,x,y,stockSize){
					  this.init=function (){
					  		
					      	Crane.prototype.init.apply(this,arguments)
					        this.xv=0//水平速度
			       	    this.xa=0//水平加速度
			       	    stockSize=(stockSize||17)*1.2
			       	    this.width=stockSize;
				      		this.len = 43*stockSize/17;
				      		this.x1=x-this.len/2;
				      		this.y1=y-this.width/2;
				      		this.x2=x+this.len/2;
				      		this.y2=y+this.width/2;
					        this.x=x;
				   			  this.y=y;
				     
					    }
					    
					    this.draw=function(){
						    Crane.prototype.draw.apply(this,arguments)
		            context.drawImage(cranePic,this.x-this.len/2,this.y-this.width/2,this.len,this.width)
  			 			}
   
					     this.init();
      },ComplexGraph);
          
          
    Product= extend( function (context,x,y,size){
     this.init=function (){
        		
			  Product.prototype.init.apply(this,arguments)
		      this.width=parseInt(size)||16;
		      this.len=parseInt(size)||16;
		      this.x1=x-this.width/2;
		      this.y1=y-this.len/2;
		      this.x2=x+this.width/2;
		      this.y2=y+this.len/2;
		      this.x=x;
   			  this.y=y;
		      this.graphs.push(new   Rectangle(context,this.x1,this.y1,this.x2,this.y2,1,"#ff00ff","#ff00ff"));
     		 }
       this.init();
       
        this.draw=function(){
						  //  Product.prototype.draw.apply(this,arguments)
		            context.drawImage(productPic,this.x-this.len/2,this.y-this.width/2,this.len,this.width)
  			}
       
      },ComplexGraph);
      
      
    StockProduct= extend( function (context,color){
     this.init=function (){
        		
			  StockProduct.prototype.init.apply(this,arguments)
		      this.width=10;
		      var x=y=0
		      this.len=6;
		      this.x1=x-this.width/2;
		      this.y1=y-this.len/2;
		      this.x2=x+this.width/2;
		      this.y2=y+this.len/2;
		      this.x=x;
   			  this.y=y;
   			
		      this.graphs.push(new   Rectangle(context,this.x1,this.y1,this.x2,this.y2,1,color,color));
     		 }
       this.init();
      },ComplexGraph);
      
           
  StoreRoom=  extend( function (context,x,y,config ){
  	config=config||{}
  	     this.cols=82
  	
         this.storeWidth=(window.screen.width-30)/this.cols;
         this.storeHigth=8;
         this.shelfHigth=parseInt((window.screen.height-10)/8);
        
         this.rows=config.rows||11
         this.shelfs=config.shelfs||8
         this.beginShelf=config.beginShelf||0;
			   this.init=function (){
			     	StoreRoom.prototype.init.apply(this,arguments)
			     	this.stores={};
	     			this.x=x;
	   			  this.y=y;
				    this.x1=x;
				    this.y1=y;
				    var wordX=this.x+this.cols*this.storeWidth/2
				    for(var shelfId=1;shelfId<=  this.shelfs;shelfId++){
				    	  var vallShelfkey=this.beginShelf+ shelfId
					    	var keyShelfId =vallShelfkey*10000;
					    	for (var col=1;col<= this.cols;col++){
						    		var keyRow=keyShelfId+col*100;
					          for(var row=1;row<= this.rows;row++){
					           	var key =keyRow+row;
					           	var tmpx=this.x1+(col-1)*this.storeWidth;
					           	var tmpy=this.y1+(13-row)*this.storeHigth+(shelfId-1)*this.shelfHigth;
					          	var store=new Store(context,tmpx,tmpy,this.storeWidth,this.storeHigth);
					            this.graphs.push(store);
					            this.stores['k'+key]=store;
					          }
				        }
				        var wordY=this.y1+(shelfId)*this.shelfHigth-8
				        var cfg={context:context,word:vallShelfkey,x:wordX,y:wordY,font:'bold 100px 宋体',fillStyle:'rgba(0,0,0,0.15)'}
				        var word=new Word(cfg);
					      this.graphs.push(word);
				    }
				    	
			     
			   }
			   this.init();
			   
			  this.getId =function (x,y){
				   	var col =  x-this.x1;
				   	col = col/this.storeWidth+1
				   col=	Math.round(col)
				   	if(col<1){
				   		return 0;
				   		}
				   	shelf = y-this.y1
				   	shelfId = shelf/this.shelfHigth+1;
				   	shelfId=parseInt(shelfId)
				   	if(shelfId<1){
				   		return 0;
				   		}
				   	row=13-(shelf%this.shelfHigth)/this.storeHigth
				   	row=Math.round(row);
				   	if(row<1||row>11){
				   		return 0;
				   	}
				   shelfId+=	this.beginShelf
			   	 return shelfId*10000+col*100+row;
			   	}
     	 
     	    
      } ,ComplexGraph);
  
  
  
  
  
  
