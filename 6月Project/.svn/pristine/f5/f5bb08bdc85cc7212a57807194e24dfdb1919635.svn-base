using System;
using System.IO;
using System.Text;

namespace WebApi.util
{
    public static class FileUtil
    {
        public static string ReadFileFromPath(string path)
        {
            string line = "";
            return TryExecute(() =>
            {
                if (File.Exists(path))
                {
                    StreamReader sr = new StreamReader(path, Encoding.UTF8);
                    if (!sr.EndOfStream)
                    {
                        line = sr.ReadToEnd();
                        return line;
                    }
                    //while ((line = sr.ReadLine()) != null)
                    //{
                    //    line += sr.ReadToEnd();
                    //    return line;
                    //}
                }
                return line;
            }, line);
        }

        public static T TryExecute<T>(Func<T> func, T defaultValue = default)
        {
            try
            {
                return func();
            }
            catch (Exception ex)
            {
                //SingletonUtil<NlogUtil>.GetInstance().Debug(ex);
                //new NlogUtil().Debug(ex);
                return defaultValue;
            }
        }
    }
}