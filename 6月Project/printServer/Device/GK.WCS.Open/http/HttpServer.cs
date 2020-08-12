using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Runtime.InteropServices;
using System.Text;

namespace ConsoleApplication2.HttpServer
{
    public class HttpServer
    {
        private TcpListener _listeners;
        private volatile bool _isInit;
     

        public HttpServer(int port)
        {
            var localEp = new IPEndPoint(IPAddress.Any, port);
            try {
                _listeners = new TcpListener(IPAddress.Any, port);
                _listeners.Start(5000);
                _isInit = true;
                _listeners.BeginAcceptTcpClient(AcceptAsync_Async,null);
            }catch {
              
                Dispose();
            }
        }

        private void AcceptAsync_Async(IAsyncResult iar)
        {
            _listeners.BeginAcceptTcpClient(AcceptAsync_Async,null);
          
                var client = _listeners.EndAcceptTcpClient(iar);

                BufferedStream _inputStream = new BufferedStream(client.GetStream());
                StreamWriter  OutputStream = new StreamWriter(new BufferedStream(client.GetStream()),Encoding.UTF8);
            try {
                var socket = new HttpProcess();
                var res = socket.Process(client,_inputStream);
                Utils.WriteSuccess(OutputStream);
                if (res != null) {
                    OutputStream.WriteLine(JsonConvert.SerializeObject(res));
                }
            


            } finally {
                try {
                    OutputStream.Flush();
                } catch { }

                try {
                    _inputStream.Dispose();
                } catch { }
                try {
                    OutputStream.Dispose();

                } catch { }
                try {
                    client.Close();

                } catch { }

                _inputStream = null;
                OutputStream = null; // bs = null;            
             

            }


        }

       
        public void Dispose()
        {
            if (_isInit)
            {
                _isInit = false;
                Dispose(true);
                GC.SuppressFinalize(this);
            }
        }
        protected virtual void Dispose([MarshalAs(UnmanagedType.U1)] bool flag1){
            if (flag1){
                if (_listeners != null) {
                    try{ 
                        _listeners.Stop();
                        _listeners = null;
                    } catch{
                    }
                }
            }
        }
    }
}