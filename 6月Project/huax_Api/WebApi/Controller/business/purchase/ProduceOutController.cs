
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

    [RoutePrefix("produce")]
    public class ProduceOutController : BaseApiController
    {
        IWhSoOutServer whSoOutServer = WMSDalFactray.getDal<IWhSoOutServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();
        IWhSoOutProduceServer whOutProduceServer= WMSDalFactray.getDal<IWhSoOutProduceServer>();

        //销售订单分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]WhSoOutProduceDto dto)
        {
            Page<WhSoOutProduce> info = whSoOutServer.WhSoOutProducePages<WhSoOutProduce>(dto);
            return  BaseResult.Ok(info);
        }
        //明细查询
        [HttpPost, Route("GetOrderDetailId")]
        public BaseResult GetOrderDetailId(WhSoOutProduce whSoOutProduce)
        {
            List<WhSoOutProduceDetail> list= whSoOutServer.GetProduceDetailId(whSoOutProduce);
            return BaseResult.Ok(list);
        }
        //生产订单同步
        [HttpPost, Route("synchronize"), ControlName("生产订单同步")]
        public BaseResult Synchronize([FromBody]SynchronizeDto dto)
        {

            WhSoOutProduce whSoOutProduce = new WhSoOutProduce();
            WhSoOutProduceDetail whSoOutProduceDetail = new WhSoOutProduceDetail();
            string billcode = dto.vbillcode;
            string orgcode = dto.orgcode;
            string beginTime = dto.beginTime.ToString("yyyy-MM-dd HH:mm:ss");
            string endTime = dto.endTime.ToString("yyyy-MM-dd HH:mm:ss");
            JObject jo = (JObject)JsonConvert.DeserializeObject(NcHttp.ProduceSynchronize(billcode, orgcode, beginTime, endTime));
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
                    //申请人编码
                    String p1 = hvo["param1"].ToString();
                    //申请部门编码
                    String p2 = hvo["param2"].ToString();
                    //申请人名称
                    string p3 = hvo["param3"].ToString();
                    //订单主Id
                    string pk_bill = hvo["pk_bill"].ToString();
                    //订单号
                    string vbillcode = hvo["vbillcode"].ToString();

                    int a = whSoOutServer.GetBillProduceNo(pk_bill).Count;
                    if (a == 0)
                    {
                        whSoOutProduce.id = sequenceIdServer.getId();
                        long soid = whSoOutProduce.id;
                        whSoOutProduce.soNo = vbillcode;
                        whSoOutProduce.srcSoBill = pk_bill;
                        whSoOutProduce.applicantId= p2;
                        whSoOutProduce.applicantCode = p1;
                        whSoOutProduce.applicantName = p3;
                        whSoOutProduce.status = "1";
                        //warehouseIn.createDate = DateTime.Now;
                        //warehouseIn.finshDate = DateTime.Now;
                        whSoOutServer.insert<WhSoOutProduce>(whSoOutProduce);
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
                            //string materialtype = bvo["materialtype"].ToString();
                            //物料编码
                            string material_code = bvo["material_code"].ToString();
                            int b = whSoOutServer.GetPkProduceNo(pk_bill_b).Count;
                            if (b == 0)
                            {
                                whSoOutProduceDetail.id = sequenceIdServer.getId();
                                whSoOutProduceDetail.soId= soid;
                                whSoOutProduceDetail.itemCode = material_code;
                                whSoOutProduceDetail.itemName = material_name;
                                whSoOutProduceDetail.itemSpec = materialspec;
                                whSoOutProduceDetail.count = double.Parse(nastnum);
                                whSoOutProduceDetail.srcSoBillDetail = pk_bill_b;
                                //whSoOutDetail.finshCount = 0;
                                whSoOutProduceDetail.packUnit = castunit;
                                //string classtype = materialtype;
                                //CoreClassify coreClassify= iitemServer.QueryClassifyByName(classtype);
                                //whSoOutProduceDetail.itemId = coreClassify.id;
                                whSoOutServer.insert<WhSoOutProduceDetail>(whSoOutProduceDetail);
                            }
                        }
                    }
                    else
                    {
                        long soid = whSoOutServer.GetBillProduceNo(pk_bill)[i].id;
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
                            //string materialtype = bvo["materialtype"].ToString();
                            //物料编码
                            string material_code = bvo["material_code"].ToString();
                            int b = whSoOutServer.GetPkNo(pk_bill_b).Count;
                            if (b == 0)
                            {
                                whSoOutProduceDetail.id = sequenceIdServer.getId();
                                whSoOutProduceDetail.soId = soid;
                                whSoOutProduceDetail.itemCode = material_code;
                                whSoOutProduceDetail.itemName = material_name;
                                whSoOutProduceDetail.itemSpec = materialspec;
                                whSoOutProduceDetail.count = double.Parse(nastnum);
                                whSoOutProduceDetail.srcSoBillDetail = pk_bill_b;
                                //whSoOutDetail.finshCount = 0;
                                whSoOutProduceDetail.packUnit = castunit;
                                //string classtype = materialtype;
                                ///CoreClassify coreClassify = iitemServer.QueryClassifyByName(classtype);
                                //whSoOutProduceDetail.itemId = coreClassify.id;
                                whSoOutServer.insert<WhSoOutProduceDetail>(whSoOutProduceDetail);
                            }
                        }
                    }
                }
                return BaseResult.Ok("同步成功");
            }
        }

        [HttpPost, Route("saveProduce"), ControlName("生产订单保存")]
        public BaseResult saveProduce([FromBody] WhSoOutProduce whSoOutProduce)
        {
            if (whSoOutProduce.id == 0)
            {
                whSoOutProduce.id = sequenceIdServer.getId();
                whSoOutProduce.createDate = sequenceIdServer.GetTime();
                whSoOutProduce.finishDate = sequenceIdServer.GetTime();
                whSoOutProduce.status = "1";
                whOutProduceServer.insertNotNull(whSoOutProduce);
                return BaseResult.Ok(whSoOutProduce);
            }
            else
            {
                whSoOutProduce.status = "1";
                whOutProduceServer.updateNotNull(whSoOutProduce);
                return BaseResult.Ok(whSoOutProduce);
            }
        }
        [HttpPost, Route("getDetials")]
        public BaseResult getDetials([FromBody] WhSoOutProduceDto dto)
        {
            List<WhSoOutProduceDetail> info = whOutProduceServer.GetDetails(dto.id);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("saveDetials"), ControlName("生产订单明细保存")]
        public BaseResult saveDetials([FromBody] WhSoInDetailAddDto dto)
        {
            WhSoOutProduce whSoOutProduce = whOutProduceServer.getById<WhSoOutProduce>(dto.id);
            List<WhSoOutProduceDetail> detailList = whOutProduceServer.GetDetails(dto.id);
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
                    WhSoOutProduceDetail detail = new WhSoOutProduceDetail();
                    CoreItem coreitem = iitemServer.FindCoreItemById(long.Parse(id));
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = int.Parse(id);
                    detail.soId = whSoOutProduce.id;
                    detail.count = 0;
                    detail.finishCount = 0;
                    detail.itemCode = coreitem.code;
                    detail.itemName = coreitem.name;
                    detail.srcSoBillDetail = whSoOutProduce.srcSoBill;
                    whOutProduceServer.insertNotNull(detail);
                }
            }
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("updateDetials"), ControlName("生产订单明细修改")]
        public BaseResult updateDetials([FromBody] WhSoOutProduceDetail dto)
        {
            List<WhSoOutProduce> InList = whOutProduceServer.getWhSoOutProduce(dto.soId);
            if (InList[0].status != "1")
            {
                return BaseResult.Error("生产订单非新建待执行状态无法编辑");
            }
            bool result = whOutProduceServer.updateNotNull(dto);
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("deleteDetial"), ControlName("生产订单明细删除")]
        public BaseResult deleteDetial([FromBody] WhSoOutProduceDetail dto)
        {
            List<WhSoOutProduce> InList = whOutProduceServer.getWhSoOutProduce(dto.soId);
            if (InList[0].status != "1")
            {
                return BaseResult.Error("生产订单非新建待执行状态无法删除");
            }
            whOutProduceServer.delete<WhSoOutProduceDetail>(dto.id);
            return BaseResult.Ok("ok");
        }
    }
}