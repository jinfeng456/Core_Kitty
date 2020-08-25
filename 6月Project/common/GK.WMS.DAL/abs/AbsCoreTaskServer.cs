using Common.dto;
using Dapper;
using GK.WMS.DAL.abs;
using GK.WMS.Entity;
using HY.WCS.DAL.dto;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using WMS.Entity;

namespace GK.WMS.DAL
{
    public abstract class AbsCoreTaskServer : AbsWMSBaseServer, ICoreTaskServer
    {
        public List<CoreTaskParam> GetListByTaskId(long taskId)
        {
            string sql = "select * from Core_task_param where 1=1 and wms_Task_Id=@wmsTaskId";
            return Connection.Query<CoreTaskParam>(sql, new { wmsTaskId = taskId }).ToList();
        }

        public Page<CoreTask> QueryCoreTaskPage<CoreTask>(CoreTaskDto dto)
        {
            string sql = "select * from Core_task where 1=1 ";
            if (!string.IsNullOrEmpty(dto.boxCode))
            {
                sql += " AND box_Code = @boxCode ";
            }
            return this.queryPage<CoreTask>(sql, "id  desc", dto);
        }

        public bool UpdateStatusById(long id)
        {
            string sql = "update Core_task set status=@status where id=@id";
            int i = Connection.Execute(sql, new { id = id });
            if (i != 1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

    }
}
