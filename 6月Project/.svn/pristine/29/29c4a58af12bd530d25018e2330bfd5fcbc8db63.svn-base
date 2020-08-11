using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using GK.Adaper;
using GK.Common.entity;
using GK.Mongon.DAL;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using GK.Ws.Mes.NC;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Quartz;
using Quartz.Impl;
using WebApi;

namespace Web.job {
  
    public class TimeJob:JobBase {

        IReceiptInServer receiptInServer = WMSDalFactray.getDal<IReceiptInServer>();
        IReceiptOutServer receiptOutServer = WMSDalFactray.getDal<IReceiptOutServer>();
        ISysAuthorityServer sysAuthorityServer= WMSDalFactray.getDal<ISysAuthorityServer>();
        public override void excute() {
            //upload();
            wmsBack();
        }
        void wmsBack() 
        {

        }


       void upload()
        {
            List<WhReceiptIn> receiptInTasks = receiptInServer.GetNotUploadList();
            if (receiptInTasks.Count<=0)
            {
                return;
            }
            ReportIn(receiptInTasks);

            List<WhReceiptOut> receiptOutTasks = receiptOutServer.GetNotUploadList();
            if (receiptOutTasks.Count <= 0)
            {
                return;
            }
            ReportOut(receiptOutTasks);
        }

        private void ReportIn(List<WhReceiptIn> receiptInTasks)
        {
            NCFinishUpload modelUpload = new NCFinishUpload();
            NCFinishUploadJson modelJson = new NCFinishUploadJson();
            NCFinishUploadJsonAggvos modelJsonAggvos = new NCFinishUploadJsonAggvos();
            NCFinishUploadJsonBvo modelJsonBvo = new NCFinishUploadJsonBvo();
            modelJson.aggvos = new List<NCFinishUploadJsonAggvos>();
            modelJsonAggvos.bvo = new List<NCFinishUploadJsonBvo>();



            foreach (var receiptInTask in receiptInTasks)
            {
                modelUpload.username = "jiangzhaowei";
                modelUpload.ts = "2020-05-21 17:08:49";
                modelUpload.signToken = NcHttp.string2MD5();
                modelUpload.type = "cgrk";

                modelJson.orgcode = "10117";
                modelJson.warehouse = "02";
                string code = sysAuthorityServer.GetCodeByName(receiptInTask.creater);
                modelJson.whmanager = "004649";
                
                List<WhReceiptInDetail> whReceiptInDetails = receiptInServer.GetListByReceiptId(receiptInTask.id);
                foreach (var whReceiptInDetail in whReceiptInDetails)
                {
                    //通过soid,so_Detail_Id查询主表id和子表id
                    if (whReceiptInDetail.soid==0 || whReceiptInDetail.soDetailId==0)
                    {
                        return;
                    }
                    string pkBillH = receiptInServer.GetpkBillHById((long)whReceiptInDetail.soid);
                    string pkBillB = receiptInServer.GetpkBillBById((long)whReceiptInDetail.soDetailId);

                    modelJsonAggvos.pk_bill_h = pkBillH;
                    modelJsonAggvos.wmshid = "";

                    modelJsonBvo.wmsbid = "";
                    modelJsonBvo.pk_bill_b = pkBillB;
                    modelJsonBvo.outnum = whReceiptInDetail.finshCount.ToString();
                    modelJsonBvo.outdate = whReceiptInDetail.createTime.ToString();
                    modelJsonBvo.batchnum = "";
                    modelJsonAggvos.bvo.Add(modelJsonBvo);
                    modelJson.aggvos.Add(modelJsonAggvos);                   
                }
                modelUpload.json = modelJson;


                JObject jo = (JObject)JsonConvert.DeserializeObject(NcHttp.ReportTask(modelUpload));
                bool result = (bool)jo["success"];
                if (result==true)
                {
                    BaseResult.Ok("上报成功！");
                    bool updateResult =  receiptInServer.UpdateUploadById(receiptInTask.id);
                }
                else
                {
                    BaseResult.Ok("上报失败！");
                }
            }
        }

        private void ReportOut(List<WhReceiptOut> receiptOutTasks)
        {
            NCFinishUpload modelUpload = new NCFinishUpload();
            NCFinishOutUploadJson modelOutJson = new NCFinishOutUploadJson();
            NCFinishOutUploadJsonAggvos modelOutJsonAggvos = new NCFinishOutUploadJsonAggvos();
            NCFinishOutUploadJsonBvo modelOutJsonBvo = new NCFinishOutUploadJsonBvo();
            modelOutJson.aggvos = new List<NCFinishOutUploadJsonAggvos>();
            modelOutJsonAggvos.bvo = new List<NCFinishOutUploadJsonBvo>();

            foreach (var receiptOutTask in receiptOutTasks)
            {
                modelUpload.username = "jiangzhaowei";
                modelUpload.ts = "2020-05-21 17:08:49";
                modelUpload.signToken = NcHttp.string2MD5();
                modelUpload.type = "xsck";

                modelOutJson.orgcode = "10117";
                modelOutJson.warehouse = "02";
                string code = sysAuthorityServer.GetCodeByName(receiptOutTask.creater);
                modelOutJson.whmanager = "004649";

                List<WhReceiptOutDetail> whReceiptOutDetails = receiptOutServer.GetListByReceiptId(receiptOutTask.id);
                foreach (var whReceiptOutDetail in whReceiptOutDetails)
                {
                    //通过soid,so_Detail_Id查询主表id和子表id
                    if (whReceiptOutDetail.soid == 0 || whReceiptOutDetail.soDetailId == 0)
                    {
                        return;
                    }
                    string pkBillH = receiptInServer.GetpkBillHById((long)whReceiptOutDetail.soid);
                    string pkBillB = receiptInServer.GetpkBillBById((long)whReceiptOutDetail.soDetailId);

                    modelOutJsonAggvos.pk_bill_h = pkBillH;
                    modelOutJsonAggvos.wmshid = whReceiptOutDetail.id.ToString();

                    modelOutJsonBvo.wmsbid = whReceiptOutDetail.id.ToString();
                    modelOutJsonBvo.pk_bill_b = pkBillB;
                    modelOutJsonBvo.outnum =Convert.ToDouble( whReceiptOutDetail.finshCount);
                    modelOutJsonBvo.outdate = whReceiptOutDetail.createTime.ToString();
                    modelOutJsonBvo.batchnum = "";
                    modelOutJsonBvo.boxno = "";
                    modelOutJsonBvo.oboxnum = "";
                    modelOutJsonBvo.eboxnum = "";
                    modelOutJsonAggvos.bvo.Add(modelOutJsonBvo);
                    modelOutJson.aggvos.Add(modelOutJsonAggvos);
                }
                modelUpload.json = modelOutJson;

                JObject jo = (JObject)JsonConvert.DeserializeObject(NcHttp.ReportTask(modelUpload));
                bool result = (bool)jo["success"];
                if (result == true)
                {
                    BaseResult.Ok("上报成功！");
                    bool updateResult = receiptOutServer.UpdateUploadById(receiptOutTask.id);
                }
                else
                {
                    BaseResult.Ok("上报失败！");
                }
            }
        }


    }

  

}