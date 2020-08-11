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
   public interface ICoreWhLocServer : IBaseServer
    {
        Page<CoreWhLoc> queryPhysicalLocationPage<CoreWhLoc>(int start, int end, PageDto param );
        CoreWhLoc getById(long id, IDbTransaction transaction = null);
        #region 库房设置
        //库房分页
        Page<ClassQuery> QueryCoreWhPage<ClassQuery>(CoreWhDto dto);
        //库房添加
        long AddCoreWh(CoreWh coreClassify);
        //库房修改
        bool UpdateCoreWh(CoreWh coreWh);
        //库房删除
        int DeleteCoreWh(List<CoreWh> coreWhList);
        //库房查找
        CoreWh FindCoreWhById(long id);
        //库房名称查重
        bool QueryCoreWhPageByName(CoreWh coreWh);
        #endregion

        #region 区域设置
        //区域分页
        Page<CoreWhArea> QueryAreaPage(CoreWhAreaDto dto);
        //区域添加
        long AddArea(CoreWhArea coreWhArea);
        //区域修改
        bool UpdateArea(CoreWhArea coreWhArea);
        //区域删除
        int DeleteArea(List<CoreWhArea> areaList);
        //区域查找
        CoreWhArea FindAreaById(long id);
        //根据ID删除
        // bool DeleteByClassifyId(long userId);
        //区域名称查重
        bool QueryAreaPageByName(CoreWhArea coreWhArea);
        //通过库房ID查询数据
        List<CoreWhArea> GetAreaByWhId(long whId);
        #endregion

        #region 库位设置
        //库位分页
        Page<CoreWhLoc> QueryLocPage(CoreWhLocDto dto);
        //库位添加
        long AddLoc(CoreWhLoc coreWhLoc);
        //库位修改
        bool UpdateLoc(CoreWhLoc coreWhLoc);
        //库位删除
        int DeleteLoc(List<CoreWhLoc> locList);
        //库位查找
        CoreWhLoc FindLocById(long id);
        //根据ID删除
        // bool DeleteByClassifyId(long userId);
        //库位名称查重
        bool QueryLocPageByRow(CoreWhLoc coreWhLoc);
        //通过区域ID查询数据
        List<CoreWhLoc> GetLocByWhAreaId(long areaId);
        //根据库位ID批量修改库区
        bool BatchUpdataLoc(List<long> locList,long areaid);
        #endregion
    }
}
