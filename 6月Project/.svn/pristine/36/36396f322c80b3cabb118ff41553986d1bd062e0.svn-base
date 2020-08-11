using Dapper;
using GK.Common.dto;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using GK.WMS.DAL.abs;
using System.Text;
using GK.WMS.Entity.wms;

namespace GK.WMS.DAL.abs
{
    public abstract class AbsCoreWhLocServer : AbsWMSBaseServer, ICoreWhLocServer
    {
        ISequenceIdServer sequenceIdServer = WMSDalFactray.getDal<ISequenceIdServer>();
        public Page<CoreWhLoc> queryPhysicalLocationPage<CoreWhLoc>(int start, int end, PageDto param)
        {

            string sql = "physical_Location";
            string orderBy = "id";
            return this.queryPage<CoreWhLoc>(sql, orderBy, param);

        }
        public CoreWhLoc getById(long id, IDbTransaction transaction)
        {
            return getById<CoreWhLoc>(id, transaction);
        }
        #region 库房设置
        //库房分页
        public Page<CoreWh> QueryCoreWhPage<CoreWh>(CoreWhDto dto)
        {
            string sql = @"select cw.id,cw.name,cw.code,
                           CASE cw.type
                           WHEN 1 THEN '平库'
                           ELSE '立库'
                           END AS type 
                           from core_Wh cw where 1=1";
            if (dto != null && !string.IsNullOrEmpty(dto.name))
            {
                dto.name = "%" + dto.name + "%";
                sql += " AND cw.name like @name ";
            }
            return this.queryPage<CoreWh>(sql, "id", dto);
        }
        //库房添加
        public long AddCoreWh(CoreWh model)
        {
            model.id = sequenceIdServer.getId();
            model.name = model.name;
            model.code = model.code;
            //model.type = model.type;
            if (model.type.Equals("平库"))
            {
                model.type = "1";
            }
            else
            {
                model.type = "2";
            }
            return Connection.Insert<CoreWh>(model);
        }
        //库房修改
        public bool UpdateCoreWh(CoreWh coreWh)
        {
            if (coreWh.type.Equals("平库"))
            {
                coreWh.type = "1";
            }
            else
            {
                coreWh.type = "2";
            }
            return Connection.Update<CoreWh>(coreWh);
        }
        //库房删除
        public int DeleteCoreWh(List<CoreWh> coreWhList)
        {
            foreach (var corewh in coreWhList)
            {
                Connection.Delete<CoreWh>("id=" + corewh.id.ToString());
            }
            return 1;
        }
        //通过库房ID查询
        public CoreWh FindCoreWhById(long id)
        {
            return Connection.Get<CoreWh>(id);
        }
        //库房名称查重
        public bool QueryCoreWhPageByName(CoreWh coreWh)
        {
            string sql = @"SELECT * FROM core_Wh cw where cw.name='{0}'";
            sql = string.Format(sql, coreWh.name);
            List<CoreWh> list = Connection.Query<CoreWh>(sql, coreWh).ToList();
            if (list.Count == 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        #endregion

        # region 区域设置
        //区域添加
        public long AddArea(CoreWhArea model)
        {
            model.id = sequenceIdServer.getId();
            model.AreaName = model.AreaName;
            model.craneId = model.craneId;
            model.info = model.info;
            model.whId = model.whId;
            model.orderNo = model.orderNo;
            model.locWidth = model.locWidth;
            model.locHight = model.locHight;
            model.locdeep = model.locdeep;
            // model.name =model.name;
            return Connection.Insert<CoreWhArea>(model);
        }
        //区域修改
        public bool UpdateArea(CoreWhArea coreWhArea)
        {
            return Connection.Update<CoreWhArea>(coreWhArea);
        }
        //区域删除
        public int DeleteArea(List<CoreWhArea> areaList)
        {
            foreach (var coreWhArea in areaList)
            {
                Connection.Delete<CoreWhArea>("id=" + coreWhArea.id.ToString());
            }
            return 1;
        }
        //通过区域ID查找
        public CoreWhArea FindAreaById(long id)
        {
            return Connection.Get<CoreWhArea>(id);
        }
        //区域名称查重
        public bool QueryAreaPageByName(CoreWhArea coreWhArea)
        {
            string sql = @"select * from Core_wh_Area where Area_Name='{0}'";
            sql = string.Format(sql, coreWhArea.AreaName);
            List<CoreWhArea> list = Connection.Query<CoreWhArea>(sql, coreWhArea).ToList();
            if (list.Count == 0)
                return false;
            else
                return true;
        }
        //区域分页显示
        public Page<CoreWhArea> QueryAreaPage(CoreWhAreaDto dto)
        {
            string sql = @"select ca.* from Core_wh_Area ca where 1=1";
            if (dto != null && !string.IsNullOrEmpty(dto.AreaName))
            {
                dto.AreaName = "%" + dto.AreaName + "%";
                sql += " AND ca.Area_Name like @AreaName";
            }
            if (dto != null && dto.whId!=0)
            {
                sql += " AND ca.wh_Id = @whId";
            }
            if (dto != null && !string.IsNullOrEmpty(dto.orderNo))
            {
                sql += " AND ca.order_No = @orderNo";
            }
            // Page<ClassQuery> info= queryPage<ClassQuery>(sql, "id", dto);
            return this.queryPage<CoreWhArea>(sql, "order_No desc ", dto);
        }
        //根据库房ID查询数据
        public List<CoreWhArea> GetAreaByWhId(long whId)
        {
            String sql = "select * from Core_wh_Area ca where ca.wh_Id=@whId";
            return Connection.Query<CoreWhArea>(sql, new { whId = whId }).ToList();
        }
        #endregion

        #region 库位设置
        //库位分页
        public Page<CoreWhLoc> QueryLocPage(CoreWhLocDto dto)
        {
            string sql = @"select cl.id,cl.crane_Id,cl.Shelf_Id,
                           cl.area_Id,cl.Row_Number,cl.Col_Number,
                           cl.type,cl.order_No,cl.deep_Index,
                           cl.width,cl.high,cl.deep,cl.maxstock,
                           cl.stock_Count,cl.move_group,
                           CASE cl.Active_Status
                           WHEN 0 THEN '无限制'
                           WHEN 1 THEN '禁止入库'
                           WHEN 2 THEN '禁止出库'
                           ELSE '禁止出入库'
                           END AS Active_Status 
                           from Core_wh_Loc cl where 1=1";
            if (dto != null)
            {
                if (dto != null && dto.areaId != 0)
                {
                    sql += " AND cl.area_Id=@areaId";
                }
                if (dto != null && dto.RowNumber != 0)
                {
                    sql += " AND cl.Row_Number=@rowNumber";
                }
                if (dto != null && dto.ColNumber != 0)
                {
                    sql += " AND cl.Col_Number=@colNumber";
                }
                if (dto != null && dto.ShelfId!=0)
                {
                    sql += " AND cl.shelf_Id = @ShelfId";
                }
            }

            return this.queryPage<CoreWhLoc>(sql, "id", dto);
        }
        //库位添加
        public long AddLoc(CoreWhLoc model)
        {
            return Connection.Insert<CoreWhLoc>(model);
        }
        //库位修改
        public bool UpdateLoc(CoreWhLoc coreWhLoc)
        {
            if (coreWhLoc.ActiveStatus.Equals("无限制"))
            {
                coreWhLoc.ActiveStatus = "0";
            }
            if (coreWhLoc.ActiveStatus.Equals("禁止入库"))
            {
                coreWhLoc.ActiveStatus = "1";
            }
            if (coreWhLoc.ActiveStatus.Equals("禁止出库"))
            {
                coreWhLoc.ActiveStatus = "2";
            }
            if (coreWhLoc.ActiveStatus.Equals("禁止出入库"))
            {
                coreWhLoc.ActiveStatus = "3";
            }
            return Connection.Update<CoreWhLoc>(coreWhLoc);
        }
        //库位删除
        public int DeleteLoc(List<CoreWhLoc> locList)
        {
            foreach (var coreWhLoc in locList)
            {
                Connection.Delete<CoreWhLoc>("id=" + coreWhLoc.id.ToString());
            }
            return 1;
        }
        //通过库位ID查找信息
        public CoreWhLoc FindLocById(long id)
        {
            return Connection.Get<CoreWhLoc>(id);
        }
        //通过库位名称查找信息
        public bool QueryLocPageByRow(CoreWhLoc coreWhLoc)
        {
            string sql = @"select cl.* from Core_wh_Loc cl where cl.Row_Number='{0}' and cl.Col_Number='{1}'";
            sql = string.Format(sql, coreWhLoc.RowNumber, coreWhLoc.ColNumber);
            List<CoreWhArea> list = Connection.Query<CoreWhArea>(sql, coreWhLoc).ToList();
            if (list.Count == 0)
                return false;
            else
                return true;
        }
        //通过区域ID查找信息
        public List<CoreWhLoc> GetLocByWhAreaId(long areaId)
        {
            String sql = "select cl.* from Core_wh_Loc cl where cl.area_Id=@areaId";
            return Connection.Query<CoreWhLoc>(sql, new { areaId = areaId }).ToList();
        }
        //批量修改库位的库区信息
        public bool BatchUpdataLoc(List<long> locList, long areaid)
        {
            for (int i = 0; i < locList.Count(); i++)
            {
                long iid = locList[i];
                string sql = @"update core_Wh_loc set area_id=@areaId where id=@ids";
                Connection.Execute(sql, new { areaId = areaid, ids = locList[i] });
            }
            return true;
        }
        #endregion
    }
}
