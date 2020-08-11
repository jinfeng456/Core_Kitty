using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CMFrameWork.Common;
using System.Configuration;

namespace HY.WCS.Server.Common
{
    class ServerConstants
    {

        /// <summary>
        /// 文件缓存文件所在路径
        /// </summary>
        public static string FileCachePath
        {
            get { return ConfigurationManager.AppSettings["fileCachePath"]; }
        }

        /// <summary>
        /// 货架信息缓存时间
        /// </summary>
        public static int FileCacheTimeout
        {
            get { return -ConfigurationManager.AppSettings["FileCacheTimeout"].ToInt32(0); }
        }




    }
}
