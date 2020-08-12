using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;

namespace WebApi.Controller.file {
    public class FileStreamResult:IHttpActionResult {
        readonly Stream _stream;
        readonly string _mediaType;
        readonly string _fileName;

        public FileStreamResult(Stream stream,string mediaType) : this(stream,mediaType,null) { }

        public FileStreamResult(Stream stream,string mediaType,string fileName) {
            _stream = stream;
            _mediaType = mediaType;
            _fileName = fileName;
        }

        public Task<HttpResponseMessage> ExecuteAsync(CancellationToken cancellationToken) {
            return Task.FromResult<HttpResponseMessage>(Execute());
        }

        private HttpResponseMessage Execute() {
            HttpResponseMessage httpResponseMessage = new HttpResponseMessage(HttpStatusCode.OK);
            try {
                httpResponseMessage.Content = new StreamContent(_stream);
                httpResponseMessage.Content.Headers.ContentType = new MediaTypeHeaderValue(_mediaType);
                if(!string.IsNullOrEmpty(_fileName)) {
                    httpResponseMessage.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") {
                        FileName = HttpUtility.UrlEncode(_fileName,Encoding.UTF8),
                    };
                }
                return httpResponseMessage;
            } catch {
                httpResponseMessage.Dispose();
                throw;
            }
        }
    }
}
