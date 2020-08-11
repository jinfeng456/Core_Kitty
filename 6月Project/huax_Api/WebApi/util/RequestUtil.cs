using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WebApi.util {
   public class RequestUtil {

        public static string requestStr(String key) {
            String res = System.Web.HttpContext.Current.Request[key];
            return res;
        }




        public static double requestDouble(String key,double defout) {
            String value = System.Web.HttpContext.Current.Request[key];
            if(String.IsNullOrEmpty(value)) {
                return defout;
            }
            double res = defout;
            double.TryParse(value,out res);
            return res;
        }

       
        public static int requestInt(String key,int defout) {
            String value = System.Web.HttpContext.Current.Request[key];
            if(String.IsNullOrEmpty(value)) {
                return defout;
            }
            int res = 0;
            int.TryParse(value,out res);
            return res;
        }

        public static long requestLong(String key,long defout) {
            String value = System.Web.HttpContext.Current.Request[key];
            if(String.IsNullOrEmpty(value)) {
                return defout;
            }
            long res = defout;
            long.TryParse(value,out res);
            return res;
        }
    }
}
