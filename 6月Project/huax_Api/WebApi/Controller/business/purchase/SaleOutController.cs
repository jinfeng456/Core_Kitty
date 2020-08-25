
using Common.dto;
using GK.Adaper;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
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
using WMS.DAL;
using WMS.Entity;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("sales")]
    public class SalesOutController : BaseApiController
    {
        IWhSoOutServer whSoOutServer = WMSDalFactray.getDal<IWhSoOutServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();
        //销售订单分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]WhSoOutDto dto)
        {
            Page<WhSoOut> info = whSoOutServer.QueryWhSoOutPages<WhSoOut>(dto);
            return  BaseResult.Ok(info);
        }
        //明细查询
        [HttpPost, Route("GetOrderDetailId")]
        public BaseResult GetOrderDetailId(WhSoOut whSoOut)
        {
            List<WhSoOutDetail> list= whSoOutServer.GetOrderDetailId(whSoOut);
            return BaseResult.Ok(list);
        }
        //销售订单同步
        [HttpPost, Route("synchronize"), ControlName("销售订单同步")]
        public BaseResult Synchronize([FromBody]SynchronizeDto dto)
        {

            WhSoOut whSoOut = new WhSoOut();
            WhSoOutDetail whSoOutDetail = new WhSoOutDetail();
            string billcode = dto.vbillcode;
            string orgcode = dto.orgcode;
            string beginTime = dto.beginTime.ToString("yyyy-MM-dd HH:mm:ss");
            string endTime = dto.endTime.ToString("yyyy-MM-dd HH:mm:ss");
            JObject jo = (JObject)JsonConvert.DeserializeObject(NcHttp.SalesSynchronize(billcode, orgcode, beginTime, endTime));
            bool mes = (bool)jo["success"];
            if (mes == false)
            {
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
                    //客户编码
                    String p1 = hvo["param1"].ToString();
                    //客户ID
                    String p2 = hvo["param2"].ToString();
                    //客户名称
                    string p3 = hvo["param3"].ToString();
                    //订单主Id
                    string pk_bill = hvo["pk_bill"].ToString();
                    //订单号
                    string vbillcode = hvo["vbillcode"].ToString();

                    int a = whSoOutServer.GetBillNo(pk_bill).Count;
                    if (a == 0)
                    {
                        whSoOut.id = sequenceIdServer.getId();
                        long soid = whSoOut.id;
                        whSoOut.soNo = vbillcode;
                        whSoOut.srcSoBill = pk_bill;
                        whSoOut.customId= p2;
                        whSoOut.customCode = p1;
                        whSoOut.customName = p3;
                        whSoOut.status = "1";
                        //warehouseIn.createDate = DateTime.Now;
                        //warehouseIn.finshDate = DateTime.Now;
                        whSoOutServer.insert<WhSoOut>(whSoOut);
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
                            //String material_pk = bvo["material_pk"].ToString();
                            //物料单位
                            String castunit = bvo["castunit"].ToString();
                            //物料类别
                            string materialtype = bvo["materialtype"].ToString();
                            //物料编码
                            string material_code = bvo["material_code"].ToString();
                            int b = whSoOutServer.GetPkNo(pk_bill_b).Count;
                            if (b == 0)
                            {
                                whSoOutDetail.id = sequenceIdServer.getId();
                                whSoOutDetail.soid = soid;
                                whSoOutDetail.itemCode = material_code;
                                whSoOutDetail.itemName = material_name;
                                whSoOutDetail.itemSpec = materialspec;
                                whSoOutDetail.count = int.Parse(nastnum);
                                whSoOutDetail.srcSoBillDetail = pk_bill_b;
                                //whSoOutDetail.finshCount = 0;
                                whSoOutDetail.packUnit = castunit;
                                string classtype = materialtype;
                                CoreClassify coreClassify= iitemServer.QueryClassifyByName(classtype);
                                whSoOutDetail.itemId = coreClassify.id;
                                whSoOutServer.insert<WhSoOutDetail>(whSoOutDetail);
                            }
                        }
                    }
                    else
                    {
                        long soid = whSoOutServer.GetBillNo(pk_bill)[i].id;
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
                            //String material_pk = bvo["material_pk"].ToString();
                            //物料单位
                            String castunit = bvo["castunit"].ToString();
                            //物料类别
                            string materialtype = bvo["materialtype"].ToString();
                            //物料编码
                            string material_code = bvo["material_code"].ToString();
                            int b = whSoOutServer.GetPkNo(pk_bill_b).Count;
                            if (b == 0)
                            {
                                whSoOutDetail.id = sequenceIdServer.getId();
                                whSoOutDetail.soid = soid;
                                whSoOutDetail.itemCode = material_code;
                                whSoOutDetail.itemName = material_name;
                                whSoOutDetail.itemSpec = materialspec;
                                whSoOutDetail.count = int.Parse(nastnum);
                                whSoOutDetail.srcSoBillDetail = pk_bill_b;
                                //whSoOutDetail.finshCount = 0;
                                whSoOutDetail.packUnit = castunit;
                                string classtype = materialtype;
                                CoreClassify coreClassify = iitemServer.QueryClassifyByName(classtype);
                                whSoOutDetail.itemId = coreClassify.id;
                                whSoOutServer.insert<WhSoOutDetail>(whSoOutDetail);
                            }
                        }
                    }
                }
                return BaseResult.Ok("同步成功");
            }
        }

        [HttpPost, Route("saveWhSoOut"), ControlName("订单保存")]
        public BaseResult saveWhSoOut([FromBody] WhSoOut whSoOut)
        {
            if (whSoOut.id == 0)
            {
                whSoOut.id = sequenceIdServer.getId();
                whSoOut.createDate = sequenceIdServer.GetTime();
                whSoOut.finshDate = sequenceIdServer.GetTime();
                whSoOut.status = "1";
                whSoOutServer.insertNotNull(whSoOut);
                return BaseResult.Ok(whSoOut);
            }
            else
            {
                whSoOut.status = "1";
                whSoOutServer.updateNotNull(whSoOut);
                return BaseResult.Ok(whSoOut);
            }
        }

        [HttpPost, Route("saveDetials"), ControlName("订单明细保存")]
        public BaseResult saveDetials([FromBody] WhSoInDetailAddDto dto)
        {
            WhSoOut whSoOut = whSoOutServer.getById<WhSoOut>(dto.id);
            List<WhSoOutDetail> detailList = whSoOutServer.GetDetails(dto.id);
            string[] ids = dto.items.Split(',');
            foreach (string id in ids)
            {
                bool same = false;
                foreach (var soDetail in detailList)
                {
                    if (soDetail.itemId == long.Parse(id.Split('|')[0]))
                    {
                        same = true;
                    }
                }
                if (!same)
                {
                    WhSoOutDetail detail = new WhSoOutDetail();
                    CoreItem coreitem = iitemServer.FindCoreItemById(long.Parse(id));
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = int.Parse(id);
                    detail.soid = whSoOut.id;
                    detail.count = 0;
                    detail.finshCount = 0;
                    detail.itemCode = coreitem.code;
                    detail.itemName = coreitem.name;
                    detail.srcSoBillDetail = whSoOut.srcSoBill;
                    whSoOutServer.insertNotNull(detail);
                }
            }
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("getDetials")]
        public BaseResult getDetials([FromBody] WhSoOutDto dto)
        {
            List<WhSoOutDetail> info = whSoOutServer.GetDetails(dto.id);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("updateDetials"), ControlName("销售出库单明细修改")]
        public BaseResult updateDetials([FromBody] WhSoOutDetail dto)
        {
            List<WhSoOut> InList = whSoOutServer.getWhSoOut(dto.soid);
            if (InList[0].status != "1")
            {
                return BaseResult.Error("销售出库单非新建待执行状态无法编辑");
            }
            bool result = whSoOutServer.updateNotNull(dto);
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("deleteDetial"), ControlName("销售出库单明细删除")]
        public BaseResult deleteDetial([FromBody] WhSoOutDetail dto)
        {
            List<WhSoOut> InList = whSoOutServer.getWhSoOut(dto.soid);
            if (InList[0].status != "1")
            {
                return BaseResult.Error("销售出库单非新建待执行状态无法删除");
            }
            whSoOutServer.delete<WhSoOutDetail>(dto.id);
            return BaseResult.Ok("ok");
        }
    }
}