using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net.Sockets;
using System.Reflection;
using GK.WCS.Open.http;
using GK.WCS.Open.http.server;
namespace ConsoleApplication2.HttpServer
{
    public class HttpProcess {

        public static Dictionary<String,String > pathDict= new  Dictionary<String,String >();

        public string HttpMethod;
        public string HttpProtocolVersionstring;
        public string HttpUrl;

        public Hashtable HttpHeaders = new Hashtable();
        public StreamWriter OutputStream;
        static Assembly ass;
        static HttpProcess(){
            ass = Assembly.GetExecutingAssembly();//要绝对路径
        }
        /// <summary>
        ///     这个是服务器收到有效链接初始化
        /// </summary>
        internal HttpProcess() {
          

        }

        internal ResJosnData Process(TcpClient client,Stream _inputStream) {
            ResJosnData res = new ResJosnData();
            
            var request = Utils.ReadLine(_inputStream);
            var tokens = request.Split(' ');
            if(tokens.Length != 3) {
                throw new Exception("invalid http request line");
            }
            HttpMethod = tokens[0].ToUpper();
            HttpUrl = tokens[1];
            HttpProtocolVersionstring = tokens[2];
            
           
            
            Hashtable ht = Utils. ParseRequest(_inputStream);
            try {
                
                if(HttpMethod.Equals("GET")) {
                     List<String> param = Utils.GetRequestExec(HttpUrl);
                    if(param.Count <2 ) {
                        res.status = 1;
                        res.data = "请求路径无效！";
                        return res;
                    }
                
                    String className = param[0];
                    param.RemoveAt(0);
                  String  methodName= param[0];
                   param.RemoveAt(0);
                    res.status = 0;
                    res.data =  doServer(className,methodName,param);
                    return res;
                } else if(HttpMethod.Equals("POST")) {
                    String data =Utils.PostRequestExec(ht,_inputStream);
                    if(pathDict.ContainsKey(HttpUrl)){ 
                        res.status = 0;
                        String   name = pathDict[HttpUrl];
                        String[] Names= name.Split('@');
                        res.data = doServer(Names[0],Names[1],new List<String>(){data });;
                    }else{ 
                        res.status = 1;
                        res.data = "post 未实现";
                    }
                   
                    return res;
                } else {
                    res.status = 1;
                    res.data = HttpMethod+" 不支持";
                    return null;

                }
            } catch(Exception e) {
                Console.WriteLine("Exception: " + e);
                res.status = 1;
                res.data = e.Message;
                return res;
            
            }

           
        }

      object  doServer(String className,String methodName,object param){ 
              Type type = ass.GetType("GK.WCS.Open.http.server." + className + "Server");

                    if(type == null) {
                        throw new Exception("请求路径异常");
                    }
                        MethodInfo meth = type.GetMethod(methodName);//加载方法
                    
                    if(meth == null) {
                        throw new Exception("资源不存在");
                    }
                    BaseServer server = (BaseServer)Activator.CreateInstance(type);
                    object value = meth.Invoke(server,new Object[] { param });//执行
            return value;
            
            }






       


    }
}