
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
      
      
    StockProduct= extend( function (context,color){
     this.init=function (){
        		
			  StockProduct.prototype.init.apply(this,arguments)
		      this.width=4;
		      var x=y=0
		      this.len=4;
		      this.x1=x-this.width/2;
		      this.y1=y-this.len/2;
		      this.x2=x+this.width/2;
		      this.y2=y+this.len/2;
		      this.x=x;
   			  this.y=y;
   			
		      this.graphs.push(new   Rectangle(context,this.x1,this.y1,this.x2,this.y2,1,color));
     		 }
       this.init();
      },ComplexGraph);
      
           
  StoreRoom=  extend( function (context,x,y){
         this.storeWidth=75;
			   this.init=function (){
				     	StoreRoom.prototype.init.apply(this,arguments)
				     	this.stores={};
		     			this.x=x;
		   			  this.y=y;
					    this.x1=x;
					    this.y1=y;
				    for(var shelfId=1;shelfId<=6;shelfId++){
					    	var keyShelfId = shelfId*10000;
					    	for (var col=1;col<=17;col++){
						    		var keyRow=keyShelfId+col*100;
					          for(var row=1;row<=18;row++){
					           	var key =keyRow+row;
					           	var tmpx=this.x1+(col-1)*(this.storeWidth);
					           	var tmpy=this.y1+row*6+(shelfId-1)*120;
					          	var store=new Store(context,tmpx,tmpy,this.storeWidth,4);
					            this.graphs.push(store);
					            this.stores['k'+key]=store;
					          }
				        }
				    }
				    	
			     
			   }
			     this.init();
     	  this.addStockProduct=function(id,widthType,status){
     	  	var w=9;
     	  	var color="";
     	  	if(widthType==1){
     	  		w=this.storeWidth/9
     	  		color="#ff00ff";
     	  	}else if(widthType==2){
     	  		w=this.storeWidth/11
     	  			var color="#ff3300";
     	  	}
     	  	
     	  	
     	  	var  key=parseInt(id/100)
     	    var  index=id%100
     	  	var stock = new StockProduct(context,color);
     	  	var store = this.stores['k'+key];
     	  	var anchor = store.getAnchor();
     	  	
     	  	var newAnchor={x:store.x1+parseInt(w*(index-0.5)),y:anchor.y}
     	  	
     	  	stock.setAnchor(newAnchor)
     	    this.graphs.push(stock);
     	  }
     	    
     	    
      } ,ComplexGraph);
  
  
  
  
  
  
