using Common.DAL.inter;
using Common.dto;
using GK.WMS.Entity;
using GK.WMS.Entity.wms;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public interface IItemServer : IBaseServer
    {
        #region 物料

        //获取全部物料信息
        Page<CoreItem> QueryMaterialPage<CoreItem>(CoreItemDto dto);

        List<CoreItem> getAllItem();
        // List<CoreItem> GetMaterial(string loginName, string password);
        //物料新增
        long AddMaterial(CoreItem coreItem);
        //修改是否禁用
        bool UpdateActive(CoreItem coreItem);

        bool UpdateInfo(CoreItem coreItem);
        //通过物料类别ID查询数据
        List<CoreItem> GetCoreItemByClassfiyId(long classifyId);
        //删除
        int DeleteCoreItem(List<CoreItem> coreItemList);
        //通过id找物料
        CoreItem FindCoreItemById(long id);
        //通过code查Id
        List<CoreItem> GetCoreItemByCode(string code);

        List<CoreItemDto> GetExportList(CoreItemDto dto);
        #endregion

        #region 物料类别
        //物料类别分页
        Page<ClassQuery> QueryClassifyPage<ClassQuery>(ClassifyDto dto);
        //物料类别添加
        long AddClassify(CoreClassify coreClassify);
        //物料类别修改
        bool UpdateClassify(CoreClassify coreClassify);
        //物料类别删除
        int DeleteClassify(List<CoreClassify> classifyList);
        //查找
        CoreClassify FindClassifyById(long id);
        //根据ID删除
        // bool DeleteByClassifyId(long userId);
        //物料类别名称查重
        bool QueryClassifyPageByName(CoreClassify coreClassify);

        CoreClassify QueryClassifyByName(string classifyName);
        string ImportList(List<CoreItem> coreItemList);

        //批量设置物料类别库区
        bool BatchSetLoc(List<long> locList, long areaid);
        #endregion

        #region 物料类别分区
        //物料类别分区分页
        Page<CoreClassifyArea> QueryClassifyAreaPage(CoreClassifyAreaDto dto);
        //物料类别分区添加
        long AddClassifyArea(CoreClassifyArea coreClassifyArea);
        //物料类别分区修改
        bool UpdateClassifyArea(CoreClassifyArea coreClassifyArea);
        //物料类别分区删除
        int DeleteClassifyArea(List<CoreClassifyArea> coreClassifyArea);

        #endregion
    }
}
