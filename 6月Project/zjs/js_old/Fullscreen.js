//�����{��
var invokeFieldOrMethod = function(element, method) 
{
   var usablePrefixMethod;
   ["webkit", "moz", "ms", "o", ""].forEach(function(prefix) {
       if (usablePrefixMethod) return;
       if (prefix === "") {
           // ��ǰ׺����������ĸСд
           method = method.slice(0,1).toLowerCase() + method.slice(1);   
       }
       var typePrefixMethod = typeof element[prefix + method];
       if (typePrefixMethod + "" !== "undefined") {
           if (typePrefixMethod === "function") {
               usablePrefixMethod = element[prefix + method]();
           } else {
               usablePrefixMethod = element[prefix + method];
           }
       }
   });
   
       return usablePrefixMethod;
};
   
//�M��ȫ��
 function launchFullscreen(element) 
   {
    //�˷����������ڮ����΄��Ј��У���t����o��ȫ��
     if(element.requestFullscreen) {
       element.requestFullscreen();
     } else if(element.mozRequestFullScreen) {
       element.mozRequestFullScreen();
     } else if(element.msRequestFullscreen){ 
       element.msRequestFullscreen();  
     } else if(element.oRequestFullscreen){
        element.oRequestFullscreen();
    }
    else if(element.webkitRequestFullscreen)
     {
       element.webkitRequestFullScreen();
     }else{
     
        var docHtml  = document.documentElement;
        var docBody  = document.body;
        var videobox  = document.getElementById('videobox');
        var  cssText = 'width:100%;height:100%;overflow:hidden;';
        docHtml.style.cssText = cssText;
        docBody.style.cssText = cssText;
        videobox.style.cssText = cssText+';'+'margin:0px;padding:0px;';
        document.IsFullScreen = true;
 
      }
   }
//�˳�ȫ��
   function exitFullscreen()
   {
       if (document.exitFullscreen) {
         document.exitFullscreen();
       } else if (document.msExitFullscreen) {
         document.msExitFullscreen();
       } else if (document.mozCancelFullScreen) {
         document.mozCancelFullScreen();
       } else if(document.oRequestFullscreen){
            document.oCancelFullScreen();
        }else if (document.webkitExitFullscreen){
         document.webkitExitFullscreen();
       }else{
        var docHtml  = document.documentElement;
        var docBody  = document.body;
        var videobox  = document.getElementById('videobox');
        docHtml.style.cssText = "";
        docBody.style.cssText = "";
        videobox.style.cssText = "";
        document.IsFullScreen = false;
    }
  }
document.getElementById('fullScreenBtn').addEventListener('click',function(){
    launchFullscreen(document.getElementById('canvas')); 
  
},false);