using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TSC_Printer
{
    public class TSCLIB_DLL
    {
        /// <summary>
        /// 打开打印机
        /// </summary>
        /// <param name="printername">打印机形成</param>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "openport")]
        public static extern int openport(string printername);

        /// <summary>
        /// 关闭端口
        /// </summary>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "closeport")]
        public static extern int closeport();

        /// <summary>
        /// 设置
        /// </summary>
        /// <param name="width">宽度</param>
        /// <param name="height">高度</param>
        /// <param name="speed">打印速度</param>
        /// <param name="density"></param>
        /// <param name="sensor"></param>
        /// <param name="vertical"></param>
        /// <param name="offset"></param>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "setup")]
        public static extern int setup(string width, string height,
                  string speed, string density,
                  string sensor, string vertical,
                  string offset);

        /// <summary>
        /// 清除
        /// </summary>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "clearbuffer")]
        public static extern int clearbuffer();



        /// <summary>
        /// 使用條碼機內建條碼列印 
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="type"></param>
        /// <param name="height"></param>
        /// <param name="readable"></param>
        /// <param name="rotation"></param>
        /// <param name="narrow"></param>
        /// <param name="wide"></param>
        /// <param name="code"></param>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "barcode")]
        public static extern int barcode(string x, string y, string type,
                    string height, string readable, string rotation,
                    string narrow, string wide, string code);

        /// <summary>
        /// 使用條碼機內建文字列印 
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="fonttype"></param>
        /// <param name="rotation"></param>
        /// <param name="xmul"></param>
        /// <param name="ymul"></param>
        /// <param name="text"></param>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "printerfont")]
        public static extern int printerfont(string x, string y, string fonttype,
                        string rotation, string xmul, string ymul,
                        string text);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="printercommand"></param>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "sendcommand")]
        public static extern int sendcommand(string printercommand);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="set"></param>
        /// <param name="copy"></param>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "printlabel")]
        public static extern int printlabel(string set, string copy);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="image_name"></param>
        /// <returns></returns>
        [DllImport("TSCLIB.dll", EntryPoint = "downloadpcx")]
        public static extern int downloadpcx(string filename, string image_name);


        [DllImport("TSCLIB.dll", EntryPoint = "formfeed")]
        public static extern int formfeed();


        [DllImport("TSCLIB.dll", EntryPoint = "windowsfont")]
        public static extern int windowsfont(int x, int y, int fontheight,
                        int rotation, int fontstyle, int fontunderline,
                        string szFaceName, string content);



        [DllImport("TSCLIB.dll", EntryPoint = "about")]
        public static extern int about();



        [DllImport("TSCLIB.dll", EntryPoint = "nobackfeed")]
        public static extern int nobackfeed();

    }
}
