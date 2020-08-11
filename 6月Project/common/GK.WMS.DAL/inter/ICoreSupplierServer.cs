using GK.Common.dto;
using GK.DAL.inter;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace GK.WMS.DAL
{
    public interface ICoreSupplierServer : IBaseServer
    {
        #region 供应商信息
        //供应商信息分页
        Page<CoreSupplierCorp> QuerySupplierPage(CoreSupplierCorpDto dto);
        //供应商添加
        long AddSupplier(CoreSupplierCorp coreSupplierCorp);
        //供应商信息修改
        bool UpdateSupplier(CoreSupplierCorp coreSupplierCorp);
        //供应商删除
        int DeleteSupplier(List<CoreSupplierCorp> coreSupplierCorpList);
        //查找
        CoreSupplierCorp FindSupplierById(long id);

        //批量设置物料类别库区
        bool BatchSetItem(List<long> locList, long areaid);
        #endregion

        #region 供应商绑定物料
        //分页
        Page<CoreCorpItem> QueryCorpItemPage(CoreCorpItemDto dto);
        //添加
        long AddCorpItem(CoreCorpItem coreCorpItem);
        //修改
        bool UpdateCorpItem(CoreCorpItem coreCorpItem);
        //删除
        int DeleteCorpItem(List<CoreCorpItem> coreCorpItems);
        //通过供应商ID查询是否绑定物料
        List<CoreCorpItem> FindCorpItemById(long id);
        List<CoreSupplierCorp> GetExportList(CoreSupplierCorpDto dto);
        List<CoreCorpItemDto> GetExportGcList(CoreCorpItemDto dto);
        string ImportList(List<CoreSupplierCorp> supplierList);
        string ImportGcList(List<CoreCorpItem> coreCorpItemList);
        #endregion
    }
}
