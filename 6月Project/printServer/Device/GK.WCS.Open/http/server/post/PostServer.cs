using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization.Json;
using System.Text;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace GK.WCS.Open.http.server
{
   public class PrintServer :BaseServer{
      public  String code(List<string> param){
       
  
            List<PrintDto> list = JsonConvert.DeserializeObject<List<PrintDto>>(param[0]);
            GKtsc.openportExt();
           
                for(int i = 0; i < list.Count(); i++)
                {
                  
           
                    GKtsc.printVehicleCode(list[i], 4);

                    GKtsc.next();

                }
               
          
            GKtsc.closeportExt();


            return "ok";  
            
       }


        public PrintDto AssignPrint(String jsonStr)
        {
            JObject jo = (JObject)JsonConvert.DeserializeObject(jsonStr);
            string itemName = jo["itemName"].ToString(); //物料名称
            string wmsBanchNo = jo["wmsBanchNo"].ToString(); //内部批号
            string countDb = jo["countDb"].ToString(); //数量
            string modelSpecs = jo["modelSpecs"].ToString(); //规格型号
            string itemCode = jo["itemCode"].ToString();// 物料编码
            string FromCorpBatchNo = jo["fromCorpBatchNo"].ToString(); //供应商批次号
            string packUnit = jo["packUnit"].ToString(); //单位
            string exp = jo["exp"].ToString(); //有效期
            string barCode = jo["barCode"].ToString(); //序列号
            PrintDto printDto = new PrintDto();
            printDto.itemName = itemName;
            printDto.wmsBanchNo = wmsBanchNo;
            printDto.countDb = countDb;
            printDto.modelSpecs = modelSpecs;
            printDto.itemCode = itemCode;
            printDto.fromCorpBatchNo = FromCorpBatchNo;
            printDto.packUnit = packUnit;
            if (!string.IsNullOrEmpty(exp))
            {
                printDto.exp = DateTime.Parse(exp).ToString("yyyy年MM月dd日");
            }         
            printDto.barCode=barCode;
            return printDto;
        }
      
    }
}
