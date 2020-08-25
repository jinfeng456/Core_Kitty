
using Common.dto;
using GK.WMS.DAL;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL;
using HY.WCS.DAL.dto;
using HY.WCS.Entity.dto;
using System;
using System.Collections.Generic;
using System.Linq;
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

    [RoutePrefix("corpitem")]
    public class CoreCorpItemController : BaseApiController
    {
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();
        ICoreSupplierServer coreSupplierServer= WMSDalFactray.getDal<ICoreSupplierServer>();
        //供应商分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreCorpItemDto dto)
        {
            Page<CoreCorpItem> info = coreSupplierServer.QueryCorpItemPage(dto);       
            return  BaseResult.Ok(info);
        }
        //供应商保存
        [HttpPost, Route("Save"),ControlName("供应商物料保存")]
        public BaseResult Save([FromBody]CoreCorpItem coreCorpItem)
        {
            if (coreCorpItem.id == 0)
            {                
                    return BaseResult.Ok(coreSupplierServer.AddCorpItem(coreCorpItem));               
            }
            else
            {
                    return BaseResult.Ok(coreSupplierServer.UpdateCorpItem(coreCorpItem));
            }
        }
        //供应商删除
        [HttpPost, Route("Delete"), ControlName("供应商物料删除")]
        public BaseResult Delete([FromBody]List<CoreCorpItem> coreCorpItemList)
        {
            //foreach (var coreSupplierCorp in coreSupplierCorpList)
            //{
                //CoreClassify coreClassify = iitemServer.FindClassifyById(classify.id);
                //List<CoreItem> list = iitemServer.GetCoreItemByClassfiyId(classify.id);
                //if (list.Count()>0)
                //{
                //    return  BaseResult.Error(500, "因该类别下存在物料!");
                //}
            //}
            return  BaseResult.Ok(coreSupplierServer.DeleteCorpItem(coreCorpItemList));
        }

        //供应商物料导出
        [HttpPost, Route("GetExportGcList")]
        public BaseResult GetExportGcList([FromBody]CoreCorpItemDto dto)
        {
            List<CoreCorpItemDto> info = coreSupplierServer.GetExportGcList(dto);
            return BaseResult.Ok(info);
        }

        //供应商物料导入
        [HttpPost, Route("ImportGcList"), ControlName("供应商物料导入")]
        public BaseResult ImportGcList([FromBody]List<CoreCorpItem> coreCorpItemList)
        {
            string[] message = coreSupplierServer.ImportGcList(coreCorpItemList).Split(',');
            if (message[0] == "200")
            {
                return BaseResult.Ok("操作成功!");
            }
            else
            {
                return BaseResult.Error(message[1]);
            }
        }
    }
}