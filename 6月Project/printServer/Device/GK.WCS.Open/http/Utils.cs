﻿using System;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Threading;




namespace ConsoleApplication2.HttpServer {
    public class Utils {
        private const int BufSize = 4096;
        /// <summary>
        ///     输出200状态
        /// </summary>
        public static void WriteSuccess(StreamWriter OutputStream) {
            OutputStream.WriteLine("HTTP/1.0 200 OK");
            OutputStream.WriteLine("Content-Type: text/json;charset=utf-8");
            OutputStream.WriteLine("Connection: close");
            OutputStream.WriteLine("Access-Control-Allow-Origin: *");
            OutputStream.WriteLine("Access-Control-Allow-Credentials: true");
            OutputStream.WriteLine("Access-Control-Allow-Methods: GET,POST,PUT,DELETE,OPTIONS");
            OutputStream.WriteLine("Access-Control-Allow-Headers: Content-Type,token");
            /*
            { "响应头(396 字节)":
            { "headers":[{"name":"Access - Control - Allow - Credentials","value":"true"},
            {"name":"Access - Control - Allow - Headers","value":"Content - Type, token"},
            {"name":"Access - Control - Allow - Methods","value":"GET, POST, PUT, DELETE, OPTIONS"},
            {"name":"Access - Control - Allow - Origin","value":" * "},{"name":"Content - Length","value":"0"},
            {"name":"Date","value":"Tue, 04 Aug 2020 03:40:42 GMT"},{"name":"Server","value":"Microsoft - IIS / 10.0"},
            {"name":"X - Powered - By","value":"ASP.NET"},
            {"name":"X - SourceFiles","value":" =? UTF - 8 ? B ? RTpcRFlHU1ZOXGh1YXhfQXBpXFdlYlxDb3JlU3RvY2tcR2V0Q29kZUluZm8 =?= "}]}}"
            */
            OutputStream.WriteLine("");
        }

      
        public static string ReadLine(Stream _inputStream) {
            int next_char;
            var data = "";
            while(true) {
                next_char = _inputStream.ReadByte();
                if(next_char == '\n') {
                    break;
                }
                if(next_char == '\r') {
                    continue;
                }
                if(next_char == -1) {
                    Thread.Sleep(1);
                    continue;
                }
                ;
                data += Convert.ToChar(next_char);
            }
            return data;
        }

        public static Dictionary<string,string> getData(string rawData) {
            var rets = new Dictionary<string,string>();
            var rawParams = rawData.Split('&');
            foreach(var param in rawParams) {
                var kvPair = param.Split('=');
                var key = kvPair[0];
                var value = HttpUtility.UrlDecode(kvPair[1]);
                rets[key] = value;
            }
            return rets;
        }

        public static Hashtable ParseRequest(Stream _inputStream) {
            Hashtable HttpHeaders = new Hashtable();
            string line;
            while((line = Utils.ReadLine(_inputStream)) != null) {
                if(line.Equals("")) {
                    break;
                }
                var separator = line.IndexOf(':');
                if(separator == -1) {
                    continue;
                }
                var name = line.Substring(0,separator);
                var pos = separator + 1;
                while((pos < line.Length) && (line[pos] == ' ')) {
                    pos++; //过滤键值对的空格
                }
                var value = line.Substring(pos,line.Length - pos);
                HttpHeaders[name] = value;
            }

            return HttpHeaders;
        }

        //读取文件
        public static  string PostRequestExec(Hashtable HttpHeaders,Stream _inputStream) {
            var content_len = 0;
            var ms = new MemoryStream();
            if(HttpHeaders.ContainsKey("Content-Length")) {
                //内容的长度
                content_len = Convert.ToInt32(HttpHeaders["Content-Length"]);

                var buf = new byte[BufSize];
                var to_read = content_len;
                while(to_read > 0) {
                    var numread = _inputStream.Read(buf,0,Math.Min(BufSize,to_read));
                    if(numread == 0) {
                        if(to_read == 0) {
                            break;
                        }
                        throw new Exception("client disconnected during post");
                    }
                    to_read -= numread;
                    ms.Write(buf,0,numread);
                }
                ms.Seek(0,SeekOrigin.Begin);
            }
      
            var inputData = new StreamReader(ms);
            return  inputData.ReadToEnd();
            //return Utils.getData(data);
        }



        public static List<string> GetRequestExec(String HttpUrl) {
            var datas = new List<string>();
            String[] dataArr = HttpUrl.Split('/');

            for(int i = 1;i < dataArr.Length;i++) {
                if(!String.IsNullOrWhiteSpace(dataArr[i])) {
                    datas.Add(HttpUtility.UrlDecode(dataArr[i]));
                }
               
            }
           
            return datas;
        }

    }
}
