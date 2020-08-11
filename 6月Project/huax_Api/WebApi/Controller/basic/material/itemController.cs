using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Http;
using System.Web.Security;
using Web.Authorize;

using Newtonsoft.Json;
using System.Data;
using GK.WMS.Entity;
using GK.WMS.DAL;
using HY.WCS.DAL.dto;
using GK.Common.dto;

namespace WebApi
{
    [FormAuthenticationFilter]

    [RoutePrefix("item")]
    public class itemController : BaseApiController
    {
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();
        //物料分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreItemDto dto)
        {
            var info = iitemServer.QueryMaterialPage<CoreItem>(dto);
            return BaseResult.Ok(info);
        }

        [HttpPost, Route("findAll")]
        public BaseResult findAll()
        {
            var info = iitemServer.getAllItem();
            return BaseResult.Ok(info);
        }


        //物料保存
        [HttpPost, Route("Save"), ControlName("物料保存")]
        public BaseResult Save([FromBody]CoreItem coreItem)
        {
            if (coreItem.id == 0)
            {
                if (coreItem.isSorting == null)
                {
                    coreItem.isSorting = 1;
                }
                return BaseResult.Ok(iitemServer.AddMaterial(coreItem));
            }
            else
            {
                return BaseResult.Ok(iitemServer.UpdateInfo(coreItem));
            }

        }

        //物料导入
        [HttpPost, Route("ImportList"), ControlName("物料导入")]
        public BaseResult ImportList([FromBody]List<CoreItem> coreItemList)
        {
            string[] message = iitemServer.ImportList(coreItemList).Split(',');
            if (message[0] == "200")
            {
                return BaseResult.Ok("操作成功!");
            }
            else
            {
                return BaseResult.Error(message[1]);
            }

        }
        //物料恢复
        [HttpPost, Route("Restore"), ControlName("物料恢复")]
        public BaseResult Restore([FromBody]CoreItem coreItem)
        {
            return BaseResult.Ok(iitemServer.UpdateActive(coreItem));
        }
        //物料禁用
        [HttpPost, Route("Disable"), ControlName("物料禁用")]
        public BaseResult Disable([FromBody]CoreItem coreItem)
        {
            return BaseResult.Ok(iitemServer.UpdateActive(coreItem));
        }
        //物料删除
        [HttpPost, Route("Delete"), ControlName("物料删除")]
        public BaseResult Delete([FromBody]List<CoreItem> coreItemList)
        {
            foreach (var core in coreItemList)
            {
                CoreItem coreItem = iitemServer.FindCoreItemById(core.id);

            }
            return BaseResult.Ok(iitemServer.DeleteCoreItem(coreItemList));
        }

        //导出
        [HttpPost, Route("GetExportList")]
        public BaseResult GetExportList([FromBody]CoreItemDto dto)
        {
            var info = iitemServer.GetExportList(dto);
            return BaseResult.Ok(info);
        }
    }
}