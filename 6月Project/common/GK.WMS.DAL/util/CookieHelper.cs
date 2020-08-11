using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace WebApi.util
{
    /// <summary>
    /// Cookie类
    /// </summary>
    public class CookieHelper
    {
        /// <summary>
        /// 清除指定Cookie
        /// </summary>
        /// <param name="cookiename">cookiename</param>
        public static void ClearCookie(string cookiename)
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies[cookiename];
            if (cookie != null)
            {
                cookie.Expires = DateTime.Now.AddYears(-3);
                HttpContext.Current.Response.Cookies.Add(cookie);
            }
        }

        /// <summary>
        /// 获取指定Cookie值
        /// </summary>
        /// <param name="cookiename">cookiename</param>
        /// <returns></returns>
        public static string GetCookieValue(string cookiename)
        {
            HttpCookie cookie = HttpContext.Current.Request.Cookies[cookiename];
            string cookievalue = string.Empty;
            if (cookie != null)
            {
                cookievalue = cookie.Value;
            }
            return cookievalue;
        }

        /// <summary>
        /// 添加一个Cookie
        /// </summary>
        /// <param name="cookiename">cookie名</param>
        /// <param name="cookievalue">cookie值</param>
        /// <param name="expires">过期时间 DateTime</param>
        public static void SetCookie(string cookiename, string cookievalue, int day)
        {
            HttpCookie cookie = new HttpCookie(cookiename)
            {
                Value = cookievalue,
                Expires = DateTime.Now.AddDays(day)
            };
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        public static string LoginName()
        {
            String token = HttpContext.Current.Request.Headers.Get("token");
            if(String.IsNullOrWhiteSpace(token)){ 
                return "";
                }
            byte[] c = Convert.FromBase64String(token);
            byte[] r = new byte[c.Length - 15];
            int index = 0;
            for (int i = 0; i < c.Length; i++)
            {
                if (i < 30)
                {
                    if (i % 2 == 1)
                    {
                        if (index == r.Length)
                        {
                            break;
                        }
                        r[index++] = c[i];
                    }
                }
                else
                {
                    if (index == r.Length)
                    {
                        break;
                    }
                    r[index++] = c[i];
                }
            }
            String name = System.Text.Encoding.UTF8.GetString(r);
            return name;
        }
    }
}
