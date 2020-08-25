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

    [RoutePrefix("supplier")]
    public class CoreSupplierCorpController : BaseApiController
    {
        IItemServer iitemServer = WMSDalFactray.getDal<IItemServer>();
        ICoreSupplierServer coreSupplierServer= WMSDalFactray.getDal<ICoreSupplierServer>();
        //供应商分页查询
        [HttpPost, Route("FindPage")]
        public BaseResult FindPage([FromBody]CoreSupplierCorpDto dto)
        {
            Page<CoreSupplierCorp> info = coreSupplierServer.QuerySupplierPage(dto);       
            return  BaseResult.Ok(info);
        }
        //供应商保存
        [HttpPost, Route("Save"), ControlName("供应商保存")]
        public BaseResult Save([FromBody]CoreSupplierCorp coreSupplierCorp)
        {
            if (coreSupplierCorp.id == 0)
            {                
                    return BaseResult.Ok(coreSupplierServer.AddSupplier(coreSupplierCorp));               
            }
            else
            {
                CoreSupplierCorp corecorp=coreSupplierServer.FindSupplierById(coreSupplierCorp.id);
                if (corecorp.editable == "1")
                {
                    return BaseResult.Error("该供应商无法编辑!");
                }
                else
                {
                    return BaseResult.Ok(coreSupplierServer.UpdateSupplier(coreSupplierCorp));
                }
            }
        }
        //供应商删除
        [HttpPost, Route("Delete"), ControlName("供应商删除")]
        public BaseResult Delete([FromBody]List<CoreSupplierCorp> coreSupplierCorpList)
        {
            foreach (var coreSupplierCorp in coreSupplierCorpList)
            {
                List<CoreCorpItem> list = coreSupplierServer.FindCorpItemById(coreSupplierCorp.id);
                if (list.Count>0) { 
                for (int i=0;i<list.Count;i++) {
                    string supplierName = coreSupplierServer.FindSupplierById(list[i].supplierId).name;
                    return BaseResult.Error("供应商"+ supplierName + "已绑定物料!");
                    }
                }
            }
            return  BaseResult.Ok(coreSupplierServer.DeleteSupplier(coreSupplierCorpList));
        }


        //批量设置物料
        [HttpPost, Route("Batchset/{itemid}"), ControlName("批量设置物料")]
        public BaseResult BatchEdit([FromBody]List<long> locList, long itemId)
        {
            return BaseResult.Ok(coreSupplierServer.BatchSetItem(locList, itemId));
        }

        //供应商分页查询
        [HttpPost, Route("GetExportList")]
        public BaseResult GetExportList([FromBody]CoreSupplierCorpDto dto)
        {
            List<CoreSupplierCorp> info = coreSupplierServer.GetExportList(dto);
            return BaseResult.Ok(info);
        }


        //供应商导入
        [HttpPost, Route("ImportList"), ControlName("供应商导入")]
        public BaseResult ImportList([FromBody]List<CoreSupplierCorp> supplierList)
        {
            string[] message = coreSupplierServer.ImportList(supplierList).Split(',');
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