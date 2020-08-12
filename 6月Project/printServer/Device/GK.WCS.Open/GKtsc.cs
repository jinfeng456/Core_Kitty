using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using TSC_Printer;

namespace GK.WCS.Open
{
    public class GKtsc
    {
        static String PrinterName;
        static GKtsc(){
             PrinterName = ConfigurationManager.AppSettings["PrinterName"].ToString();
    }
       
        public static void openportExt()
        {
            TSCLIB_DLL.openport(PrinterName);//找打打印机端口
            TSCLIB_DLL.sendcommand("SIZE 80 mm,60 mm");//设置条码大小
            TSCLIB_DLL.sendcommand("GAP 2 mm,0");//设置条码间隙
            TSCLIB_DLL.sendcommand("SPEED 4");//设置打印速度
            TSCLIB_DLL.sendcommand("DENSITY 7");//设置墨汁浓度
            TSCLIB_DLL.sendcommand("DERECTION 1");//设置相对起点
            TSCLIB_DLL.sendcommand("REFERENCE 3 mm,3 mm");//设置偏移边框
            TSCLIB_DLL.sendcommand("CLS");//清除记忆（每次打印新的条码时先清除上一次的打印记忆）
        }

        public static void next()
        {
           
            TSCLIB_DLL.sendcommand("CLS");//清除记忆（每次打印新的条码时先清除上一次的打印记忆）
        }

        //打印二维码
        public static void printVehicleCode(PrintDto print,int size)
        {

            string codeValue = print.barCode + "/"+ print.countDb + "/" + print.modelSpecs + "/" + print.itemCode  + "/" + print.wmsBanchNo + "/" + print.fromCorpBatchNo + "/" + print.itemName  + "/" + print.packUnit + "/" + print.exp;

            if (codeValue.Length < 120) {
                codeValue+="/                                                                                                                        ";

                codeValue = codeValue.Substring(0,120);
                }
            
            TSCLIB_DLL.sendcommand("CLS");//需要清除上一次的打印记忆
            TSCLIB_DLL.sendcommand("QRCODE 350,25,H,"+size+",A,0,M2,S7,\"" + codeValue + "\"");
            TSCLIB_DLL.windowsfont(600, 460, 24, 180, 0, 0, "黑体", "规格型号："+print.modelSpecs);
            TSCLIB_DLL.windowsfont(600, 420, 24, 180, 0, 0, "黑体", "物料编码："+print.itemCode);
            TSCLIB_DLL.windowsfont(600, 380, 24, 180, 0, 0, "黑体", "内部批号："+print.wmsBanchNo);
            TSCLIB_DLL.windowsfont(600, 340, 24, 180, 0, 0, "黑体", "供应商批号："+print.fromCorpBatchNo);
            TSCLIB_DLL.windowsfont(330, 250, 24, 180, 0, 0, "黑体", "物料名称："+print.itemName);
            TSCLIB_DLL.windowsfont(330, 210, 24, 180, 0, 0, "黑体", "数    量："+print.countDb);
            TSCLIB_DLL.windowsfont(330, 170, 24, 180, 0, 0, "黑体", "单    位："+print.packUnit);
            TSCLIB_DLL.windowsfont(330, 130, 24, 180, 0, 0, "黑体", "有效期至："+print.exp);
            TSCLIB_DLL.windowsfont(330, 90, 24, 180, 0, 0, "黑体",  "序 列 号："+print.barCode);
            TSCLIB_DLL.printlabel("1", "1");
        }

        //打印一维码
        public static void printFinanceCode(int value)
        {
            for (int i = value; i < value + 31; i++)
            {
                TSCLIB_DLL.sendcommand("CLS");//需要清除上一次的打印记忆
                TSCLIB_DLL.barcode("90", "100", "128", "320", "1", "0", "5", "1", i.ToString());
                TSCLIB_DLL.printlabel("1", "1");
            }
            //for(int i = value; i < value+21; i++)
            //   {
            //       TSCLIB_DLL.sendcommand("CLS");//需要清除上一次的打印记忆
            //       TSCLIB_DLL.barcode("40", "100", "128", "320", "1", "0", "6", "1", i.ToString());
            //       //TSCLIB_DLL.windowsfont(440, 35, 24, 180, 0, 0, "黑体", value);
            //       TSCLIB_DLL.printlabel("1", "1");
            //   }


        }
        //关闭打印机端口
        public static void closeportExt()
        {
            TSCLIB_DLL.closeport();
        }
    }
}
