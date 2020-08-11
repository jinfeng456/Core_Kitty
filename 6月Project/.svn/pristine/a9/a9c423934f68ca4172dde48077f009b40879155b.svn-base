
using GK.Adaper;
using GK.Common;
using GK.Common.dto;
using GK.WMS.DAL;

using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using System.Web;


using System.Web.Http;
using System.Web.Http.Cors;
using Web.Authorize;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("warehousein")]
    public class WarehouseInController : BaseApiController
    {
        IReceiptInServer receipt = WMSDalFactray.getDal<IReceiptInServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        //string mes = "aaa";
        //采购订单入库分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]WhSoInDto dto)
        {
            Page<WhSoIn> info = receipt.QueryOrderPage(dto);
            return  BaseResult.Ok(info);
        }
        //明细查询
        [HttpPost, Route("GetOrderDetailId")]
        public BaseResult GetOrderDetailId(WhSoIn warehouseIn)
        {
            List<WhSoInDetail> list= receipt.GetOrderDetailId(warehouseIn);
            return BaseResult.Ok(list);
        }
        //入库单生成
        [HttpPost, Route("Save")]
        public BaseResult Save([FromBody]WhReceiptAll whReceiptAll)
        {
            WhReceiptIn whReceiptIn = new WhReceiptIn();
            WhSoIn warehouseIn = new WhSoIn();
            WhReceiptInDetail whReceiptInDetail = new WhReceiptInDetail();
            warehouseIn.id = whReceiptAll.id;
            warehouseIn.soNo = whReceiptAll.soNo;
            warehouseIn.srcSoBill = whReceiptAll.srcSoBill;
            warehouseIn.gysName = whReceiptAll.gysName;
            warehouseIn.createDate = whReceiptAll.createdate;
            warehouseIn.finshDate = whReceiptAll.finshdate;
            warehouseIn.gysId = whReceiptAll.gysId;
            warehouseIn.gysCode = whReceiptAll.gysCode;
            warehouseIn.status =Convert.ToInt32(whReceiptAll.status) ;
            warehouseIn.gysCode = whReceiptAll.gysCode;
            whReceiptIn.stn = whReceiptAll.stn;
            //whReceiptIn.wmsBanchNo = whReceiptAll.wmsBanchNo;
            //whReceiptIn.FromCorpBatchNo = whReceiptAll.FromCorpBatchNo;
            whReceiptIn.inType = whReceiptAll.inType;
            whReceiptIn.receiptNo = whReceiptAll.receiptNo;
           whReceiptIn.fromCorpName = whReceiptAll.gysName;
         return BaseResult.Ok((receipt.AddReceiptIn(whReceiptIn,warehouseIn)));        
        }
        //采购订单同步
        [HttpPost, Route("synchronize"),ControlName("采购订单同步")]
        public BaseResult Synchronize([FromBody]SynchronizeDto dto)
        {
           
            WhSoIn warehouseIn = new WhSoIn();
            WhSoInDetail warehouseInDetail = new WhSoInDetail();
            string billcode = dto.vbillcode;
            string orgcode = dto.orgcode;
            string beginTime = dto.beginTime.ToString("yyyy-MM-dd HH:mm:ss");
            string endTime = dto.endTime.ToString("yyyy-MM-dd HH:mm:ss");
            JObject jo = (JObject)JsonConvert.DeserializeObject(NcHttp.Synchronize(billcode, orgcode, beginTime, endTime));
            bool mes = (bool)jo["success"];
            if (mes==false) {
                return BaseResult.Error("数据量太大，请缩小范围");
            }
            JObject data = (JObject)jo["data"];
            JArray hvos = (JArray)data["hvo"];
            if (hvos == null)
            {
                return BaseResult.Error("没有可同步的数据");
            }
            else
            {
                for (int i = 0; i < hvos.Count; i++)
            {
                JObject hvo = (JObject)hvos[i];
                //供应商编码
                String p1 = hvo["param1"].ToString();
                //供应商ID
                String p2 = hvo["param2"].ToString();
                //供应商名称
                string p3 = hvo["param3"].ToString();
                //订单主Id
                string pk_bill = hvo["pk_bill"].ToString();
                //订单号
                string vbillcode = hvo["vbillcode"].ToString();
                int a = receipt.GetBillNo(pk_bill).Count;
                if (a==0)
                {
                    warehouseIn.id = sequenceIdServer.getId();
                    long soid = warehouseIn.id;
                    warehouseIn.soNo = vbillcode;
                    warehouseIn.srcSoBill = pk_bill;
                    warehouseIn.gysId = p2;
                    warehouseIn.gysCode = p1;
                    warehouseIn.gysName = p3;
                    warehouseIn.status = 1;
                    warehouseIn.createDate = DateTime.Now;
                    warehouseIn.finshDate = DateTime.Now;
                    receipt.insert<WhSoIn>(warehouseIn);
                    JArray bvos = (JArray)hvo["bvo"];
                    for (int j = 0; j < bvos.Count; j++)
                    {
                        JObject bvo = (JObject)bvos[j];
                        //物料名称
                        String material_name = bvo["material_name"].ToString();
                        //订单子Id
                        String pk_bill_b = bvo["pk_bill_b"].ToString();
                        //数量
                        String nastnum = bvo["nastnum"].ToString();
                        //规格
                        String materialspec = bvo["materialspec"].ToString();
                        //
                        String material_pk = bvo["material_pk"].ToString();
                        //物料单位
                        String castunit = bvo["castunit"].ToString();
                        //
                        String materialtype = bvo["materialtype"].ToString();
                        //物料编码
                        string material_code = bvo["material_code"].ToString();
                        int b = receipt.GetPkNo(pk_bill_b).Count;
                        if (b == 0)
                        {
                            warehouseInDetail.id = sequenceIdServer.getId();
                            warehouseInDetail.soId = soid;
                            warehouseInDetail.itemCode = material_code;
                            warehouseInDetail.itemName = material_name;
                            warehouseInDetail.specification = materialspec;
                            warehouseInDetail.count = int.Parse(nastnum);
                            warehouseInDetail.srcSoBillDetail = pk_bill_b;
                            warehouseInDetail.finshCount = 0;
                            warehouseInDetail.itemUnit = castunit;
                            receipt.insert<WhSoInDetail>(warehouseInDetail);
                        }
                    }
                }
                else {
                    long soid=receipt.GetBillNo(pk_bill)[i].id;
                    JArray bvos = (JArray)hvo["bvo"];
                    for (int j = 0; j < bvos.Count; j++)
                    {
                        JObject bvo = (JObject)bvos[j];
                        //物料名称
                        String material_name = bvo["material_name"].ToString();
                        //订单子Id
                        String pk_bill_b = bvo["pk_bill_b"].ToString();
                        //数量
                        String nastnum = bvo["nastnum"].ToString();
                        //规格
                        String materialspec = bvo["materialspec"].ToString();
                        //
                        String material_pk = bvo["material_pk"].ToString();
                        //物料单位
                        String castunit = bvo["castunit"].ToString();
                        //
                        String materialtype = bvo["materialtype"].ToString();
                        //物料编码
                        string material_code = bvo["material_code"].ToString();
                        int b = receipt.GetPkNo(pk_bill_b).Count;
                        if (b == 0)
                        {
                            warehouseInDetail.id = sequenceIdServer.getId();
                            warehouseInDetail.soId = soid;
                            warehouseInDetail.itemCode = material_code;
                            warehouseInDetail.itemName = material_name;
                            warehouseInDetail.specification = materialspec;
                            warehouseInDetail.count = int.Parse(nastnum);
                            warehouseInDetail.srcSoBillDetail = pk_bill_b;
                            warehouseInDetail.finshCount = 0;
                            warehouseInDetail.itemUnit = castunit;
                            receipt.insert<WhSoInDetail>(warehouseInDetail);
                        }
                    }
                }
            }
                return BaseResult.Ok("同步成功");
            }
        }

    }
}