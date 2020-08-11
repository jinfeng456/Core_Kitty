using System;

namespace Blog.Core.Model
{
    public class BaseResult
    {
        public Object data { get; set; }
        public string Message { get; set; }
        public int code { get; set; }

        public string msg { get; set; }

        public BaseResult(int c, string message, String data)
        {
            this.code = c;
            Message = message;
            this.data = data;
        }

        public BaseResult(Object data)
        {
            code = 200;
            Message = "";
            this.data = data;
        }

        public static BaseResult Error(string message = "操作失败！", int code = 500)
        {
            BaseResult r = new BaseResult();
            r.code = code;
            r.msg = message;
            return r;
        }

        public static BaseResult Ok(Object data)
        {
            BaseResult r = new BaseResult();
            r.code = 200;
            r.data = data;
            return r;
        }
        public BaseResult()
        {

        }
    }
}
