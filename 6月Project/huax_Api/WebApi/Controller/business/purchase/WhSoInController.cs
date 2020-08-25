using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.dto;
using GK.WMS.Entity.wms;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using System;
using System.Collections.Generic;
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

    [RoutePrefix("whSoIn")]
    public class WhSoInController : BaseApiController
    {

        IWhSoInServer whSoInServer = WMSDalFactray.getDal<IWhSoInServer>();
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();

        [HttpPost, Route("getDetials")]
        public BaseResult getDetials([FromBody] WhSoInDto dto)
        {
            List<WhSoInDetail> info = whSoInServer.getDetials(dto.id);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("saveWhSoIn"), ControlName("订单保存")]
        public BaseResult saveWhSoIn([FromBody] WhSoIn whSoIn)
        {
            if (whSoIn.id == 0)
            {
                whSoIn.id = sequenceIdServer.getId();
                whSoIn.createDate = sequenceIdServer.GetTime();
                whSoIn.finshDate = sequenceIdServer.GetTime();
                whSoIn.status = 1;
                whSoInServer.insertNotNull(whSoIn);
                return BaseResult.Ok(whSoIn);
            }
            else
            {
                whSoIn.status = 1;
                whSoInServer.updateNotNull(whSoIn);
                return BaseResult.Ok(whSoIn);
            }
        }

        [HttpPost, Route("saveDetials"), ControlName("订单明细保存")]
        public BaseResult saveDetials([FromBody] WhSoInDetailAddDto dto)
        {
            WhSoIn whSoIn = whSoInServer.getById<WhSoIn>(dto.id);
            List<WhSoInDetail> detailList = whSoInServer.GetDetails(dto.id);
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
                    WhSoInDetail detail = new WhSoInDetail();
                    CoreItem coreitem = iitemServer.FindCoreItemById(long.Parse(id));
                    detail.id = sequenceIdServer.getId();
                    detail.itemId = int.Parse(id);
                    detail.soId = whSoIn.id;
                    detail.count = 0;
                    detail.finshCount = 0;
                    detail.itemCode = coreitem.code;
                    detail.itemName = coreitem.name;
                    detail.srcSoBillDetail = whSoIn.srcSoBill;
                    whSoInServer.insertNotNull(detail);
                }
            }
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("updateDetials"), ControlName("订单明细修改")]
        public BaseResult updateDetials([FromBody] WhSoInDetail dto)
        {
            List<WhSoIn> InList = whSoInServer.getWhSoIn(dto.soId);
            if (InList[0].status != 1)
            {
                return BaseResult.Error("入库单非新建待执行状态无法编辑");
            }
            bool result = whSoInServer.updateNotNull(dto);
            return BaseResult.Ok("ok");
        }

        [HttpPost, Route("deleteDetial"), ControlName("入库单明细删除")]
        public BaseResult deleteDetial([FromBody] WhSoInDetail dto)
        {
            List<WhSoIn> InList = whSoInServer.getWhSoIn(dto.soId);
            if (InList[0].status != 1)
            {
                return BaseResult.Error("入库单非新建待执行状态无法删除");
            }
            whSoInServer.delete<WhSoInDetail>(dto.id);
            return BaseResult.Ok("ok");
        }

    }
}